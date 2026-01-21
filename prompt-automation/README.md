# Prompt Automation Plugin

Ralph Loop automation with intelligent task design, prompt engineering, and completion validation.

## Commands

```bash
/ralph-task-design "<description>"  # Start design phase (asks clarifying questions)
/ralph-task-refine --add|--remove|--change "<text>"  # Modify design (optional)
/ralph-task-execute [--max-iterations=N]  # Lock design and start Ralph Loop (default: 25)
/ralph-task-status                  # Show progress and validation status
/ralph-task-cancel [--save-progress]  # Stop loop gracefully
```

## Workflow

1. **Design** - `/ralph-task-design "Add JWT auth"` (creates DESIGN-*.md)
2. **Refine** - `/ralph-task-refine --add "password reset"` (optional)
3. **Execute** - `/ralph-task-execute --max-iterations=25` (locks design, starts loop)
4. **Monitor** - `/ralph-task-status` (check progress)

## Key Features

### Minimal Prompts
- Generates 50-80 line prompts (not 1000+ lines)
- References DESIGN file for all details
- Reduces token waste by 95%+
- Single source of truth

### Explicit Validation Protocol
- Clear instructions on when/how to validate
- Prevents premature completion signals
- Self-correcting on validation failures
- Comprehensive criteria checking

### Task Templates
8 pre-built templates for common scenarios:
- **feature-development** - New features with tests and docs
- **bug-fix** - TDD-style bug resolution
- **refactoring** - Safe code improvement
- **testing** - Test suite creation
- **performance-optimization** - Benchmark-driven optimization
- **security-fix** - Vulnerability remediation
- **documentation** - Documentation creation
- **api-development** - API-specific development

## How It Works

1. **Design Phase**: Creates comprehensive `DESIGN-<timestamp>.md` with:
   - Complete requirements and architecture
   - Task breakdown and acceptance criteria
   - Validation commands and edge cases
   - All implementation details

2. **Execute Phase**: Locks design and starts Ralph Loop:
   - Generates **minimal prompt** (50-80 lines) that references DESIGN file
   - Creates `.claude-task-state.json` for loop tracking
   - Enables stop hook for autonomous iteration
   - Injects prompt to start implementation

3. **Loop Iteration**:
   - Claude implements based on minimal prompt + DESIGN file
   - Stop hook intercepts exit attempts
   - Checks for completion promise `<promise>COMPLETE</promise>`
   - If not found: validates, re-injects prompt, continues
   - If found: validates ALL criteria, exits if pass, continues if fail

4. **Validation**: Auto-validates via:
   - Test execution (`npm test`, `pytest`, etc.)
   - Build verification (`npm run build`, etc.)
   - Git status (all changes committed)
   - Acceptance criteria from DESIGN file

5. **Self-Correction**: If validation fails:
   - Identifies specific issues
   - Fixes problems automatically
   - Re-validates and continues
   - Repeats until all checks pass or max iterations reached

## Validation

Auto-validates completion via:
- Test execution (`npm test`, `pytest`, etc.)
- Build verification (`npm run build`, etc.)
- Git status (all changes committed)
- Acceptance criteria from DESIGN file

## License

MIT
