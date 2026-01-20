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

# Extract iteration and task info
ITERATION=$(grep "^iteration:" "$STATE_FILE" | sed 's/iteration: *//')
MAX_ITERATIONS=$(grep "^maxIterations:" "$STATE_FILE" | sed 's/maxIterations: *//')
TASK_NAME=$(grep "^taskName:" "$STATE_FILE" | sed 's/taskName: *//')

# Mark as inactive
sed -i '' 's/^active: true/active: false/' "$STATE_FILE"

echo ""
echo "🛑 Cancelled Ralph Loop"
echo "   Was at iteration: $ITERATION / $MAX_ITERATIONS"
echo "   Task: $TASK_NAME"
echo "   State file marked as inactive"
echo ""
echo "The state file has been preserved at: $STATE_FILE"
echo "To completely remove it: rm $STATE_FILE"
echo ""

