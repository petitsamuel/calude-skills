#!/usr/bin/env bash

# Ralph Loop Stop Hook
# This hook intercepts exit attempts and re-injects the prompt to continue the loop
# It only activates when a Ralph Loop is active (detected via state file)

# Enable pipefail to properly capture exit status in pipelines
set -o pipefail

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

# Extract completion promise
COMPLETION_PROMISE=$(echo "$LOOP_STATE" | grep -o '"completion_promise":"[^"]*"' | cut -d'"' -f4)

# Extract validation commands (JSON array)
VALIDATION_COMMANDS=$(echo "$LOOP_STATE" | grep -o '"validation_commands":\[[^]]*\]' | sed 's/"validation_commands"://')

# Function to run validation checks
run_validation() {
  local validation_failed=0

  echo "⏸️  Completion marker detected. Running validation..."
  echo ""
  echo "Validation Checks:"

  # Check git status for uncommitted changes (both staged and unstaged)
  if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    echo "✗ Git status - uncommitted changes detected"
    validation_failed=1
  else
    echo "✓ Git status - clean working directory"
  fi

  # Run custom validation commands if defined
  if [ -n "$VALIDATION_COMMANDS" ] && [ "$VALIDATION_COMMANDS" != "null" ]; then
    # Parse JSON array of commands - use process substitution to avoid subshell
    while IFS= read -r cmd; do
      cmd=$(echo "$cmd" | xargs)  # Trim whitespace
      if [ -n "$cmd" ]; then
        echo -n "  Running: $cmd ... "
        # Capture exit status separately to handle pipefail correctly
        local output
        local exit_status
        output=$(eval "$cmd" 2>&1)
        exit_status=$?
        if [ $exit_status -eq 0 ]; then
          echo "✓"
        else
          echo "✗"
          echo "    Output (last 5 lines):"
          echo "$output" | tail -5 | sed 's/^/    /'
          validation_failed=1
        fi
      fi
    done < <(echo "$VALIDATION_COMMANDS" | tr -d '[]"' | tr ',' '\n')
  fi

  return $validation_failed
}

# Check if completion promise was emitted (check this BEFORE max iterations)
if echo "$CLAUDE_OUTPUT" | grep -q "<promise>$COMPLETION_PROMISE</promise>"; then
  # Run validation before accepting completion
  if run_validation; then
    echo ""
    echo "✓ Ralph Loop completed: all validation checks passed"
    echo "  Completion promise: <promise>$COMPLETION_PROMISE</promise>"
    # Update state to completed
    echo "$LOOP_STATE" | sed 's/"status":"running"/"status":"completed"/' > "$STATE_FILE"
    exit 0
  else
    echo ""
    echo "⚠️  Completion promise found but validation failed"
    echo "🔄 Continuing loop to fix remaining issues..."
    # Don't exit - fall through to continue the loop
  fi
fi

# Check max iterations AFTER completion promise validation
# This ensures we always check for valid completion before hitting the limit
if [ "$CURRENT_ITERATION" -ge "$MAX_ITERATIONS" ]; then
  echo "⚠️  Ralph Loop reached maximum iterations ($MAX_ITERATIONS)"
  echo "   Task may be incomplete. Review output and run /ralph-task-status"
  # Update state to indicate max iterations reached
  echo "$LOOP_STATE" | sed 's/"status":"running"/"status":"max_iterations"/' > "$STATE_FILE"
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
