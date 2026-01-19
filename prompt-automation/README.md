# Prompt Automation Plugin

Ralph Loop automation with intelligent task design, prompt engineering, and completion validation.

## Commands

```bash
/ralph-task-design "<description>"  # Start design phase (asks clarifying questions)
/ralph-task-refine --add|--remove|--change "<text>"  # Modify design
/ralph-task-approve                 # Lock design, generate prompt
/ralph-task-execute [--max-iterations=N]  # Start Ralph Loop (default: 25)
/ralph-task-status                  # Show progress and validation status
/ralph-task-cancel [--save-progress]  # Stop loop gracefully
```

## Workflow

1. **Design** - `/ralph-task-design "Add JWT auth"` (creates DESIGN-*.md)
2. **Refine** - `/ralph-task-refine --add "password reset"` (optional)
3. **Approve** - `/ralph-task-approve` (locks design)
4. **Execute** - `/ralph-task-execute --max-iterations=25` (runs loop)
5. **Monitor** - `/ralph-task-status` (check progress)

## Task Templates

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

1. Creates `DESIGN-<timestamp>.md` with requirements and acceptance criteria
2. Generates optimized prompt with completion conditions
3. Starts Ralph Loop that:
   - Executes task iteration
   - Validates via tests, build, git status
   - Re-injects prompt if not complete
   - Continues until `<promise>COMPLETE</promise>` or max iterations
4. Stop hook intercepts exit to continue loop

## Validation

Auto-validates completion via:
- Test execution (`npm test`, `pytest`, etc.)
- Build verification (`npm run build`, etc.)
- Git status (all changes committed)
- Acceptance criteria from DESIGN file

## License

MIT
