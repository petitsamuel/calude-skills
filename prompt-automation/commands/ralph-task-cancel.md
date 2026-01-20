---
name: ralph-task-cancel
description: Cancel active Ralph Loop
run:
  type: bash
  command: ${CLAUDE_PLUGIN_ROOT}/scripts/cancel-ralph-loop.sh
---

# Ralph Task Cancel Command

Cancels the currently active Ralph Loop and reports the iteration it was on.

## Usage

```bash
/ralph-task-cancel
```

## What It Does

1. **Checks for active loop** - Looks for `.claude/ralph-task.local.md`
2. **Reports status** - Shows which iteration the loop was on
3. **Deactivates loop** - Marks the state file as inactive
4. **Allows exit** - Next exit attempt will succeed

## Example Output

If loop is active:
```
🛑 Cancelled Ralph Loop
   Was at iteration: 5 / 25
   Task: Add JWT Authentication
   State file marked as inactive
```

If no loop is active:
```
ℹ️  No active Ralph Loop found
```

## State File

The command sets `active: false` in `.claude/ralph-task.local.md` which tells the stop hook to allow normal exit on the next attempt.

## Note

The state file is preserved after cancellation so you can review:
- How many iterations were completed
- What the task was
- When it started
- The implementation prompt that was being used

To completely remove the state file:
```bash
rm .claude/ralph-task.local.md
```
