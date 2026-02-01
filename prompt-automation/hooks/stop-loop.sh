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

# Extract YAML frontmatter fields (only from between --- markers, strip quotes)
FRONTMATTER=$(echo "$STATE_CONTENT" | awk '/^---$/{ if (++count == 2) exit } count == 1 && NR > 1')

ACTIVE=$(echo "$FRONTMATTER" | grep "^active:" | sed 's/active: *//' | sed 's/"//g' | tr -d ' ')
ITERATION=$(echo "$FRONTMATTER" | grep "^iteration:" | sed 's/iteration: *//' | sed 's/"//g')
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep "^maxIterations:" | sed 's/maxIterations: *//' | sed 's/"//g')
COMPLETION_PROMISE=$(echo "$FRONTMATTER" | grep "^completionPromise:" | sed 's/completionPromise: *//' | sed 's/"//g')
DESIGN_FILE=$(echo "$FRONTMATTER" | grep "^designFile:" | sed 's/designFile: *//' | sed 's/"//g')

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
  # Mark as inactive in frontmatter only (cross-platform approach)
  awk '/^---$/{
    count++
    print
    if (count == 1) {
      in_frontmatter=1
    } else {
      in_frontmatter=0
    }
    next
  }
  in_frontmatter && /^active: true$/ {
    print "active: false"
    next
  }
  {print}' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
  exit 0
fi

# Check if completion promise was emitted
if echo "$CLAUDE_OUTPUT" | grep -q "<promise>$COMPLETION_PROMISE</promise>"; then
  echo ""
  echo "🎯 Ralph Loop: Completion promise detected!"
  echo "   Promise: <promise>$COMPLETION_PROMISE</promise>"
  echo ""
  echo "📋 Running validation checks from DESIGN file..."
  echo ""

  # Extract validation commands from DESIGN file if it exists
  VALIDATION_FAILED=false
  if [ -f "$DESIGN_FILE" ]; then
    # Look for validation commands in DESIGN file
    # Common patterns: "npm test", "npm run build", "pytest", etc.
    VALIDATION_COMMANDS=$(grep -A 10 "## Validation" "$DESIGN_FILE" 2>/dev/null | grep -E "^(npm|bun|yarn|pnpm|pytest|cargo|go) " || echo "")

    if [ -n "$VALIDATION_COMMANDS" ]; then
      echo "Found validation commands in DESIGN file:"
      echo "$VALIDATION_COMMANDS"
      echo ""

      # Run each validation command
      while IFS= read -r cmd; do
        if [ -n "$cmd" ]; then
          echo "Running: $cmd"
          if ! eval "$cmd" 2>&1 | tail -5; then
            echo "❌ Validation failed: $cmd"
            VALIDATION_FAILED=true
            break
          fi
          echo "✓ Passed: $cmd"
          echo ""
        fi
      done <<< "$VALIDATION_COMMANDS"
    else
      echo "ℹ️  No validation commands found in DESIGN file, skipping automated validation"
    fi
  fi

  # Check git status
  if ! git diff --quiet 2>/dev/null; then
    echo "⚠️  Warning: Uncommitted changes detected"
    echo "Git status:"
    git status --short | head -10
    echo ""
    VALIDATION_FAILED=true
  fi

  if [ "$VALIDATION_FAILED" = true ]; then
    echo ""
    echo "🔄 Validation failed - continuing loop for fixes..."
    echo "   Claude will self-correct and try again"
    echo ""
    # Don't mark as complete, let loop continue
  else
    echo ""
    echo "✅ All validation passed!"
    echo "   Ralph Loop completed successfully"
    echo ""
    # Mark as inactive (cross-platform approach)
    awk '/^---$/{
      count++
      print
      if (count == 1) {
        in_frontmatter=1
      } else {
        in_frontmatter=0
      }
      next
    }
    in_frontmatter && /^active: true$/ {
      print "active: false"
      next
    }
    {print}' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
    exit 0
  fi
fi

# Increment iteration count in frontmatter only (cross-platform approach)
NEXT_ITERATION=$((ITERATION + 1))
awk -v old="$ITERATION" -v new="$NEXT_ITERATION" '
/^---$/{
  count++
  print
  if (count == 1) {
    in_frontmatter=1
  } else {
    in_frontmatter=0
  }
  next
}
in_frontmatter && /^iteration: / {
  print "iteration: " new
  next
}
{print}' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"

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
