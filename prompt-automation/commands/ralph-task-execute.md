---
name: ralph-task-execute
description: Start Ralph Loop with locked design
args:
  - name: max-iterations
    description: Maximum number of iterations
    required: false
    default: 25
---

# Ralph Task Execute Command

Starts the Ralph Loop with the approved design.

## Usage

```bash
/ralph-task-execute [--max-iterations=<n>]
```

## Examples

```bash
# Default max iterations (25)
/ralph-task-execute

# Custom max iterations
/ralph-task-execute --max-iterations=30

# Lower max for simple tasks
/ralph-task-execute --max-iterations=15
```

## What It Does

1. **Initializes Ralph Loop**
   - Creates `.claude-task-state.json` for tracking
   - Reads `DESIGN-<timestamp>.md`
   - Injects implementation prompt
   - Starts iteration 1

2. **Iteration Cycle**
   - Claude implements based on design
   - Modifies files according to specs
   - Updates state file with progress
   - Attempts to exit

3. **Stop Hook Intercepts**
   - Checks for completion promise `<promise>COMPLETE</promise>`
   - If not found, runs validation
   - Re-injects same prompt
   - Increments iteration counter

4. **Validation on Completion**
   - Tests passing (`npm test`, etc.)
   - Build succeeds (`npm run build`, etc.)
   - Git status clean (all changes committed)
   - Acceptance criteria met (parsed from DESIGN file)

5. **Auto-Continuation**
   - If validation fails, loop continues
   - Fixes issues automatically
   - Validates again
   - Repeats until all checks pass

6. **Completion**
   - All validation checks pass
   - Outputs completion message
   - Cleans up state file
   - Keeps DESIGN file for documentation

## Safety Mechanisms

- **Max Iterations**: Hard stop after N iterations
- **Infinite Loop Detection**: Same error 3+ times = stuck
- **Progress Tracking**: Monitors file changes per iteration
- **State Persistence**: Survives session restarts

## Monitoring Progress

Use `/ralph-task-status` to check:
- Current iteration
- Validation results
- Files modified
- Tests passing status

## Cancellation

Use `/ralph-task-cancel` to stop loop safely.

## Files Created

- `.claude-task-state.json` - Loop state (deleted after)
- `DESIGN-<timestamp>.md` - Design doc (kept)
