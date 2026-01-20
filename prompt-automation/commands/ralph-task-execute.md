---
name: ralph-task-execute
description: Lock design and start Ralph Loop
args:
  - name: max-iterations
    description: Maximum number of iterations
    required: false
    default: 25
  - name: design-file
    description: Path to DESIGN file (auto-detects latest if not provided)
    required: false
run:
  type: bash
  command: ${CLAUDE_PLUGIN_ROOT}/scripts/setup-ralph-loop.sh
---

# Ralph Task Execute Command

Locks the design and starts the Ralph Loop for autonomous implementation.

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

---

## Execution Instructions

When this command is invoked, follow these steps **exactly**:

### Step 1: Find and Lock the Design Document

1. **Locate the most recent DESIGN file:**
   ```bash
   ls -t DESIGN-*.md | head -1
   ```

2. **Read the design file** to extract:
   - Task name (from title)
   - Timestamp (from filename)
   - Task type (Testing, Feature, Bug Fix, etc.)
   - Validation commands
   - Acceptance criteria

3. **Lock the design** by updating its status:
   ```markdown
   **Status**: LOCKED ✅ - Ready for Implementation
   ```

### Step 2: Generate Minimal Implementation Prompt

Use the `prompt-engineer` agent to generate a **minimal prompt** (50-80 lines):

```
Invoke prompt-engineer agent with:
- Mode: "minimal-prompt-generation"
- Input: DESIGN-[timestamp].md
- Output: Store prompt text in memory (DO NOT write to file)
```

The prompt should follow the structure from `agents/prompt-engineer.md` → "Minimal Implementation Prompt Generation" section.

**Critical**: The prompt must be **minimal** - reference the DESIGN file, don't duplicate it.

### Step 3: Create Loop State File

Create `.claude-task-state.json` with this exact structure:

```json
{
  "designFile": "DESIGN-[timestamp].md",
  "prompt": "[Generated minimal prompt text]",
  "currentIteration": 0,
  "maxIterations": [from --max-iterations arg, default 25],
  "completionPromise": "[TASK_TYPE]_COMPLETE",
  "status": "running",
  "startedAt": "[ISO timestamp]",
  "validation": {
    "lastRun": null,
    "testsPass": null,
    "buildSucceeds": null,
    "gitClean": null
  },
  "filesModified": []
}
```

**Completion promise mapping:**
- Testing task → `TESTS_COMPLETE`
- Feature development → `FEATURE_COMPLETE`
- Bug fix → `BUG_FIXED`
- Performance → `OPTIMIZED`
- Refactoring → `REFACTORED`
- Security → `SECURITY_FIXED`
- Documentation → `DOCS_COMPLETE`
- API development → `API_COMPLETE`

### Step 4: Enable Stop Hook

Update `hooks.json` to enable the Ralph Loop stop hook:

```bash
# Read hooks.json
# Find the "Ralph Loop Continuation" hook under "Stop"
# Set "enabled": true
# Write back to hooks.json
```

**Important**: The hook must be enabled BEFORE starting implementation.

### Step 5: Inject Implementation Prompt

Output the generated minimal prompt directly to the user, which starts iteration 1:

```
[The minimal prompt text from Step 2]

---

**Ralph Loop Initialized:**
- Design: DESIGN-[timestamp].md
- Iteration: 1 / [max]
- Completion Signal: <promise>[COMPLETION_PROMISE]</promise>
- State: .claude-task-state.json

Begin implementation. Work incrementally, validate frequently, and output the completion promise only when ALL acceptance criteria are met and validation passes.
```

This prompt injection starts the loop. The stop hook will intercept exit attempts and re-inject the same prompt.

---

## Loop Mechanics

### Iteration Cycle

1. **Implementation**: Claude implements based on minimal prompt (which references DESIGN file)
2. **Attempt Exit**: Claude tries to complete the turn
3. **Hook Intercepts**: `hooks/stop-loop.sh` checks for completion promise
4. **Decision**:
   - If `<promise>COMPLETE</promise>` found → Validate → Exit if valid
   - If not found → Increment iteration → Re-inject prompt → Continue

### Validation on Completion

When completion promise is detected:
1. Run test suite
2. Run build (if applicable)
3. Check git status
4. Verify acceptance criteria

If all pass → Loop exits successfully
If any fail → Loop continues (Claude self-corrects)

### State Updates

The state file tracks:
- Current iteration number
- Files modified
- Last validation results
- Timestamp of each iteration

Update after each iteration (the stop hook does this).

---

## Safety Mechanisms

### Max Iterations
Hard stop after N iterations:
```
if currentIteration >= maxIterations:
  Report status
  Clean up state
  Exit loop
```

### Infinite Loop Detection
If same error occurs 3+ times in a row:
```
- Report stuck state
- Suggest manual intervention
- Exit loop
```

### Emergency Stop
User can run `/ralph-task-cancel` at any time to stop gracefully.

---

## Monitoring Progress

Use `/ralph-task-status` to check:
- Current iteration count
- Validation status
- Files modified
- Test results

---

## Completion & Cleanup

When loop completes successfully:

1. **Report completion:**
   ```
   🎉 Task completed in [N] iterations!

   Final Validation:
   ✓ Tests passing
   ✓ Build succeeds
   ✓ Git status clean
   ✓ All acceptance criteria met
   ```

2. **Disable stop hook:**
   Update `hooks.json` to set `enabled: false`

3. **Clean up state file:**
   Delete `.claude-task-state.json`

4. **Keep design file:**
   `DESIGN-[timestamp].md` is preserved for documentation

---

## Files Created/Modified

- `.claude-task-state.json` - Loop state (deleted after completion)
- `DESIGN-[timestamp].md` - Design doc (status updated to LOCKED)
- `hooks.json` - Stop hook enabled during loop, disabled after
- [Implementation files] - Created/modified during loop iterations

---

## Important Notes

1. **No Approve Step**: This command replaces `/ralph-task-approve` - it locks design and executes in one step

2. **Minimal Prompts**: The generated prompt should be 50-80 lines, not 1000+ lines

3. **Stop Hook Required**: The loop won't work without the stop hook enabled

4. **State Persistence**: The state file allows loop to survive session restarts

5. **Self-Correction**: Claude will automatically fix issues and continue until success or max iterations

---

## Troubleshooting

**Loop doesn't continue after first iteration:**
- Check `.claude-task-state.json` exists
- Verify stop hook is enabled in `hooks.json`
- Check hook has execute permissions

**Validation keeps failing:**
- Review validation commands in DESIGN file
- Check if tests need setup/fixtures
- Verify build configuration is correct

**Hit max iterations:**
- Increase `--max-iterations` value
- Or break task into smaller phases
- Or review blockers and resolve manually
