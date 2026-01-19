#!/usr/bin/env bash

# Ralph Loop Stop Hook
# This hook intercepts exit attempts and re-injects the prompt to continue the loop
# It only activates when a Ralph Loop is active (detected via state file)

STATE_FILE=".claude-task-state.json"

# Check if Ralph Loop is active
if [ ! -f "$STATE_FILE" ]; then
  # No active loop, allow normal exit
  exit 0
fi

# Read loop state
if ! LOOP_STATE=$(cat "$STATE_FILE" 2>/dev/null); then
  # Can't read state file, allow exit
  exit 0
fi

# Extract loop status
STATUS=$(echo "$LOOP_STATE" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)

if [ "$STATUS" != "running" ]; then
  # Loop not running, allow exit
  exit 0
fi

# Extract max iterations and current iteration
MAX_ITERATIONS=$(echo "$LOOP_STATE" | grep -o '"max_iterations":[0-9]*' | cut -d':' -f2)
CURRENT_ITERATION=$(echo "$LOOP_STATE" | grep -o '"current_iteration":[0-9]*' | cut -d':' -f2)

# Check if we've hit max iterations
if [ "$CURRENT_ITERATION" -ge "$MAX_ITERATIONS" ]; then
  echo "✓ Ralph Loop completed: reached maximum iterations ($MAX_ITERATIONS)"
  exit 0
fi

# Extract completion promise
COMPLETION_PROMISE=$(echo "$LOOP_STATE" | grep -o '"completion_promise":"[^"]*"' | cut -d'"' -f4)

# Check if completion promise was emitted
if echo "$CLAUDE_OUTPUT" | grep -q "<promise>$COMPLETION_PROMISE</promise>"; then
  echo "✓ Ralph Loop completed: found completion promise <promise>$COMPLETION_PROMISE</promise>"
  # Update state to completed
  echo "$LOOP_STATE" | sed 's/"status":"running"/"status":"completed"/' > "$STATE_FILE"
  exit 0
fi

# Extract the original prompt
PROMPT=$(echo "$LOOP_STATE" | grep -o '"prompt":"[^"]*"' | cut -d'"' -f4)

# Increment iteration count
NEXT_ITERATION=$((CURRENT_ITERATION + 1))
echo "$LOOP_STATE" | sed "s/\"current_iteration\":$CURRENT_ITERATION/\"current_iteration\":$NEXT_ITERATION/" > "$STATE_FILE"

echo ""
echo "🔄 Ralph Loop continuing (iteration $NEXT_ITERATION/$MAX_ITERATIONS)..."
echo "   Looking for completion signal: <promise>$COMPLETION_PROMISE</promise>"
echo ""

# Re-inject the prompt to continue the loop
# The CLAUDE_RESPONSE_PROMPT variable will be used by Claude Code to continue
export CLAUDE_RESPONSE_PROMPT="$PROMPT

---

**Ralph Loop Status:**
- Iteration: $NEXT_ITERATION / $MAX_ITERATIONS
- Completion signal: <promise>$COMPLETION_PROMISE</promise>
- State file: $STATE_FILE

Continue working on the task. Review your previous work, validate progress, and continue until all acceptance criteria are met. When complete, output the completion promise."

# Return 1 to block the exit and continue the session
exit 1
