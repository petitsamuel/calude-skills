---
name: ralph-task-cancel
description: Stop active loop gracefully
---

# Ralph Task Cancel Command

Safely stops an active Ralph Loop.

## Usage

```bash
/ralph-task-cancel
```

## What It Does

1. **Stops Loop**
   - Terminates the Ralph Loop
   - Prevents next iteration
   - Disables stop hook

2. **Preserves Work**
   - All file changes kept
   - Git history preserved
   - DESIGN file kept for reference

3. **Cleanup**
   - Deletes `.claude-task-state.json`
   - Removes loop tracking

4. **Reports Status**
   - Shows iterations completed
   - Lists what was accomplished
   - Notes what remains incomplete

## Example Output

```
🛑 Ralph Loop Cancelled

Task: Build Todo API
Iterations Completed: 12/25
Status at Cancel: 5/7 acceptance criteria met

Accomplished:
✓ All CRUD endpoints implemented
✓ JWT authentication working
✓ Input validation in place
✓ Unit tests passing (85% coverage)
✓ Integration tests passing

Remaining Work:
✗ OpenAPI docs not yet generated
✗ README not yet updated

Files Modified:
- src/api/todos.ts
- src/middleware/auth.ts
- src/models/todo.ts
- tests/api/todos.test.ts
- tests/integration/api.test.ts

DESIGN file kept at: DESIGN-20260119-143022.md

You can resume by:
1. Reviewing DESIGN file for remaining work
2. Completing manually
3. Or starting new loop with /ralph-task-design
```

## When To Cancel

- Task taking too long
- Stuck in infinite loop
- Need to change direction
- Found blocking issue
- Want to continue manually

## After Cancellation

You can:
- Complete remaining work manually
- Start a new task design
- Commit current progress
- Review what was accomplished

## No Active Task

If no task is active:

```
No active Ralph Loop to cancel.
```
