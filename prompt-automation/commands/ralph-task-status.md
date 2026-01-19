---
name: ralph-task-status
description: Show current task progress
---

# Ralph Task Status Command

Shows the current state and progress of an active Ralph Loop task.

## Usage

```bash
/ralph-task-status
```

## Example Output

```
📋 Task: Build Todo API
📄 Design: DESIGN-20260119-143022.md

🔄 Status: Executing
📊 Iteration: 12/25

Validation Status:
✓ Tests passing (npm test)
✓ Build succeeds (npm run build)
✗ Git status has uncommitted changes
✓ Acceptance criteria: 5/7 complete

Acceptance Criteria Progress:
✓ All CRUD endpoints implemented
✓ JWT authentication working
✓ Input validation in place
✓ Unit tests passing (85% coverage)
✓ Integration tests passing
✗ OpenAPI docs not yet generated
✗ README not yet updated

Files Modified This Iteration:
- src/api/todos.ts
- src/middleware/auth.ts
- tests/api/todos.test.ts

Next Action: Continue implementing remaining criteria
```

## Information Shown

- **Task Name**: From DESIGN file
- **Design File**: Path to design document
- **Status**: Executing / Completed / Failed
- **Iteration**: Current / Max
- **Validation Status**: Each validation check result
- **Acceptance Criteria**: Progress on each criterion
- **Files Modified**: Recent changes
- **Next Action**: What the loop is working on

## Status Values

- **Not Started**: Design approved, not yet executing
- **Executing**: Ralph Loop active
- **Validating**: Checking completion
- **Completed**: All criteria met, loop finished
- **Stuck**: No progress for 3+ iterations
- **Max Iterations**: Reached max without completion

## No Active Task

If no task is active:

```
No active Ralph Loop task.

To start:
1. /ralph-task-design "your task"
2. /ralph-task-approve
3. /ralph-task-execute
```
