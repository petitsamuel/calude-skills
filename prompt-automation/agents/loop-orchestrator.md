---
description: Manages Ralph Loop execution lifecycle
capabilities:
  - Loop initialization and state management
  - Progress tracking
  - Iteration control
  - Auto-validation
  - Auto-continuation on failure
---

# Loop Orchestrator Agent

Manages the complete Ralph Loop workflow from initialization to completion.

## Responsibilities

### 1. Loop Initialization

Sets up Ralph Loop execution:

**Creates State File** (`.claude-task-state.json`):
```json
{
  "designFile": "DESIGN-20260119-143022.md",
  "currentIteration": 0,
  "maxIterations": 25,
  "completionPromise": "API_COMPLETE",
  "status": "initializing",
  "validation": {}
}
```

**Reads Design File:**
- Loads DESIGN-<timestamp>.md
- Parses acceptance criteria
- Extracts validation commands
- Identifies task type for completion promise

**Generates Minimal Implementation Prompt:**
- Creates 50-80 line prompt that references DESIGN file
- Includes explicit validation protocol (when/how/what-if)
- Specifies completion promise format
- Adds working style guidelines
- **Does NOT duplicate design content** - references it instead
- Stores prompt in state file for re-injection

**Locks Design:**
- Updates design file status to "LOCKED ✅"
- Prevents further modifications during execution

### 2. Iteration Management

Controls loop execution:

**Each Iteration:**
1. Increment iteration counter
2. Inject prompt (stop hook handles this)
3. Track file modifications
4. Monitor test results
5. Update state file

**State Tracking:**
```json
{
  "currentIteration": 5,
  "filesModified": [
    "src/api/todos.ts",
    "tests/api/todos.test.ts"
  ],
  "lastValidation": {
    "timestamp": "2026-01-19T14:35:00Z",
    "testsPass": true,
    "buildSucceeds": true,
    "gitClean": false
  }
}
```

### 3. Progress Monitoring

Tracks progress indicators:

**File Change Tracking:**
- Files created
- Files modified
- Files deleted
- Line changes

**Test Progress:**
- Tests passing count
- Coverage percentage
- New tests added

**Build Status:**
- Successful builds
- Build errors
- Build warnings

### 4. Auto-Validation

On completion promise detection:

**Validation Sequence:**
1. Run test suite
2. Run build
3. Check git status
4. Parse acceptance criteria
5. Validate each criterion

**Decision:**
- All pass → Complete ✅
- Any fail → Continue loop 🔄

### 5. Auto-Continuation

When validation fails:

**Determines Next Action:**
- If tests fail → fix test failures
- If build broken → fix build errors
- If git dirty → commit changes
- If criteria incomplete → continue implementation

**Provides Context:**
- Shows validation results
- Highlights what's incomplete
- Re-injects prompt with context
- Allows loop to self-correct

### 6. Safety Mechanisms

Prevents infinite loops:

**Max Iterations Check:**
```javascript
if (currentIteration >= maxIterations) {
  reportStatus();
  cleanupState();
  exit();
}
```

**Stuck Detection:**
```javascript
if (sameError3Times() || noProgressIn2Iterations()) {
  reportStuckState();
  suggestManualIntervention();
  exit();
}
```

**Emergency Stop:**
- User can run `/ralph-task-cancel`
- Gracefully stops loop
- Preserves work
- Cleans up state

### 7. Completion & Cleanup

When task complete:

**Success Actions:**
1. Report completion
2. Show final validation results
3. Delete `.claude-task-state.json`
4. Keep `DESIGN-<timestamp>.md` for documentation
5. Provide summary of work done

**Output:**
```
🎉 Task successfully completed in 17 iterations!

Final Validation:
✓ All tests passing (89% coverage)
✓ Build succeeds
✓ Git status clean
✓ All 7 acceptance criteria met

Files Modified:
- 12 files created
- 8 files modified
- 156 tests added

DESIGN file kept at: DESIGN-20260119-143022.md
```

## Integration with Stop Hook

Coordinates with `hooks/stop-loop.sh`:

**Stop Hook Responsibilities:**
- Intercept exit attempts
- Check for completion promise
- Call completion-detector for validation
- Re-inject prompt if not complete
- Increment iteration counter

**Orchestrator Responsibilities:**
- Initialize state
- Track progress
- Manage state file
- Coordinate agents
- Report status

Together they create the self-referential loop that enables autonomous, iterative task completion.
