#!/usr/bin/env bash

# Ralph Loop Stop Hook
# This hook intercepts exit attempts and re-injects the prompt to continue the loop
# Based on ralph-wiggum plugin architecture

STATE_FILE=".claude/ralph-task.local.md"

# Check if Ralph Loop is active
if [ ! -f "$STATE_FILE" ]; then
  # No active loop, allow normal exit
  exit 0
fi

# Read the state file
if ! STATE_CONTENT=$(cat "$STATE_FILE" 2>/dev/null); then
  # Can't read state file, allow exit
  exit 0
fi

# Extract YAML frontmatter fields
# Note: This uses simple grep/sed for YAML parsing (not robust but sufficient)
ACTIVE=$(echo "$STATE_CONTENT" | grep "^active:" | sed 's/active: *//' | tr -d ' ')
ITERATION=$(echo "$STATE_CONTENT" | grep "^iteration:" | sed 's/iteration: *//')
MAX_ITERATIONS=$(echo "$STATE_CONTENT" | grep "^maxIterations:" | sed 's/maxIterations: *//')
COMPLETION_PROMISE=$(echo "$STATE_CONTENT" | grep "^completionPromise:" | sed 's/completionPromise: *//')

# Validate we got all required fields
if [ -z "$ACTIVE" ] || [ -z "$ITERATION" ] || [ -z "$MAX_ITERATIONS" ] || [ -z "$COMPLETION_PROMISE" ]; then
  echo "⚠️  Warning: Corrupted state file, allowing exit"
  exit 0
fi

# Check if loop is still active
if [ "$ACTIVE" != "true" ]; then
  # Loop stopped, allow exit
  exit 0
fi

# Validate numeric fields
if ! [[ "$ITERATION" =~ ^[0-9]+$ ]] || ! [[ "$MAX_ITERATIONS" =~ ^[0-9]+$ ]]; then
  echo "⚠️  Warning: Invalid iteration numbers in state file"
  exit 0
fi

# Check if we've hit max iterations
if [ "$ITERATION" -ge "$MAX_ITERATIONS" ]; then
  echo ""
  echo "✓ Ralph Loop completed: reached maximum iterations ($MAX_ITERATIONS)"
  echo ""
  # Mark as inactive
  sed -i '' 's/^active: true/active: false/' "$STATE_FILE"
  exit 0
fi

# Check if completion promise was emitted
if echo "$CLAUDE_OUTPUT" | grep -q "<promise>$COMPLETION_PROMISE</promise>"; then
  echo ""
  echo "✓ Ralph Loop completed: found completion promise <promise>$COMPLETION_PROMISE</promise>"
  echo ""
  # Mark as inactive
  sed -i '' 's/^active: true/active: false/' "$STATE_FILE"
  exit 0
fi

# Increment iteration count
NEXT_ITERATION=$((ITERATION + 1))
sed -i '' "s/^iteration: $ITERATION/iteration: $NEXT_ITERATION/" "$STATE_FILE"

# Extract the prompt (everything after the frontmatter)
# The prompt starts after the closing --- of YAML frontmatter
PROMPT=$(awk '/^---$/{ if (count++ == 1) { p=1; next } } p' "$STATE_FILE")

if [ -z "$PROMPT" ]; then
  echo "⚠️  Warning: No prompt found in state file"
  exit 0
fi

echo ""
echo "🔄 Ralph Loop continuing (iteration $NEXT_ITERATION/$MAX_ITERATIONS)..."
echo "   Looking for completion signal: <promise>$COMPLETION_PROMISE</promise>"
echo ""

# Re-inject the prompt to continue the loop
export CLAUDE_RESPONSE_PROMPT="$PROMPT

---

**Ralph Loop Status:**
- Iteration: $NEXT_ITERATION / $MAX_ITERATIONS
- Completion signal: <promise>$COMPLETION_PROMISE</promise>
- State file: $STATE_FILE

Continue working on the task. Review your previous work, validate progress, and continue until all acceptance criteria are met. When complete, output the completion promise."

# Return 1 to block the exit and continue the session
exit 1
