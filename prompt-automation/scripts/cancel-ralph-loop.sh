#!/usr/bin/env bash
# Cancel Ralph Loop script

STATE_FILE=".claude/ralph-task.local.md"

# Check if state file exists
if [ ! -f "$STATE_FILE" ]; then
    echo ""
    echo "ℹ️  No active Ralph Loop found"
    echo ""
    exit 0
fi

# Extract values from YAML frontmatter only (between --- markers)
FRONTMATTER=$(awk '/^---$/{ if (++count == 2) exit } count == 1 && NR > 1' "$STATE_FILE")

ITERATION=$(echo "$FRONTMATTER" | grep "^iteration:" | sed 's/iteration: *//' | sed 's/"//g')
MAX_ITERATIONS=$(echo "$FRONTMATTER" | grep "^maxIterations:" | sed 's/maxIterations: *//' | sed 's/"//g')
TASK_NAME=$(echo "$FRONTMATTER" | grep "^taskName:" | sed 's/taskName: *//' | sed 's/"//g')

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

echo ""
echo "🛑 Cancelled Ralph Loop"
echo "   Was at iteration: $ITERATION / $MAX_ITERATIONS"
echo "   Task: $TASK_NAME"
echo "   State file marked as inactive"
echo ""
echo "The state file has been preserved at: $STATE_FILE"
echo "To completely remove it: rm $STATE_FILE"
echo ""

