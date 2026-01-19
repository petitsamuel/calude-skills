# Prompt Automation Plugin

Intelligent Ralph Loop automation with prompt engineering, task analysis, and completion validation.

## Overview

This plugin streamlines the Ralph Loop workflow by:
1. **Design Phase**: Interactive task design with clarifying questions and prompt optimization
2. **Refinement**: Iterative design modifications until approved
3. **Execution**: Automated Ralph Loop with self-correction and validation
4. **Validation**: Multi-signal completion detection (tests, build, git, acceptance criteria)

## Features

- **Intelligent Task Analysis**: Automatically classifies tasks, extracts requirements, estimates complexity
- **Prompt Engineering**: Generates optimized prompts with clear structure, validation, and completion criteria
- **8 Task Templates**: Pre-built templates for common development scenarios
- **Automated Validation**: Verifies completion via tests, builds, git status, and custom criteria
- **Self-Correcting Loop**: Continues until all acceptance criteria met or max iterations reached
- **Design Tracking**: Maintains design state in human-readable DESIGN-<timestamp>.md files

## Commands

### `/ralph-task-design`

Start the design phase for a new task. Analyzes requirements, asks clarifying questions, and creates initial design.

```bash
/ralph-task-design "Add user authentication with JWT"
```

**Options:**
- `--template <type>`: Use specific task template (feature, bug-fix, refactoring, testing, performance, security, documentation, api)
- `--skip-questions`: Skip clarifying questions and use defaults

**Output:**
- Creates `DESIGN-<timestamp>.md` with task specification
- Creates `.claude-task-state.json` with design state

### `/ralph-task-refine`

Modify existing task design before execution.

```bash
/ralph-task-refine --add "Include password reset flow"
/ralph-task-refine --remove "Social auth integration"
/ralph-task-refine --change "Use httpOnly cookies instead of localStorage"
```

**Options:**
- `--add <text>`: Add requirement or task
- `--remove <text>`: Remove requirement or task
- `--change <text>`: Modify requirement or task

### `/ralph-task-approve`

Lock design and generate implementation prompt ready for Ralph Loop execution.

```bash
/ralph-task-approve
```

**Output:**
- Updates design status to "approved"
- Generates optimized implementation prompt
- Ready for `/ralph-task-execute`

### `/ralph-task-execute`

Start Ralph Loop with approved design.

```bash
/ralph-task-execute
/ralph-task-execute --max-iterations 30
```

**Options:**
- `--max-iterations <n>`: Maximum loop iterations (default: 20)

**What It Does:**
1. Loads approved design and prompt
2. Starts Ralph Loop with completion validation
3. Runs validation commands after each iteration
4. Auto-continues until completion promise emitted or max iterations reached
5. Uses Stop hook to intercept exit and re-inject prompt

### `/ralph-task-status`

Show current task progress and validation status.

```bash
/ralph-task-status
```

**Output:**
- Current iteration count
- Validation results (tests, build, git status)
- Remaining acceptance criteria
- Estimated progress

### `/ralph-task-cancel`

Stop active Ralph Loop gracefully.

```bash
/ralph-task-cancel
```

**Options:**
- `--save-progress`: Keep design file and state for later resumption

## Task Templates

The plugin includes 8 task type templates in `skills/prompt-patterns/`:

1. **feature-development**: Full-featured new functionality
2. **bug-fix**: TDD-focused bug resolution
3. **refactoring**: Safety-focused code improvement
4. **testing**: Test creation with coverage targets
5. **performance-optimization**: Benchmark-driven optimization
6. **security-fix**: Security vulnerability remediation
7. **documentation**: Documentation creation
8. **api-development**: API-specific development

## Workflow Example

```bash
# 1. Design Phase
/ralph-task-design "Optimize the /api/products endpoint to respond in <500ms"

# Claude asks clarifying questions:
# - Current response time? (2.4s avg)
# - Technologies? (Node.js, MongoDB, no caching)
# - Constraints? (Must maintain same API contract)

# 2. Review design in DESIGN-<timestamp>.md

# 3. Refine if needed
/ralph-task-refine --add "Add Redis caching layer"

# 4. Approve design
/ralph-task-approve

# 5. Execute Ralph Loop
/ralph-task-execute --max-iterations 25

# Loop runs automatically:
# - Implements optimization
# - Runs benchmarks
# - Validates performance targets
# - Continues until <promise>OPTIMIZED</promise> emitted

# 6. Check status anytime
/ralph-task-status

# Output:
# ✓ Iteration 8/25
# ✓ Tests passing
# ✓ Build successful
# ✓ Performance: 420ms avg (target: <500ms)
# ⏳ Remaining: Document changes, verify load test
```

## Skills

### prompt-patterns
Library of task type templates with proven structures for different development scenarios.

### completion-criteria
Defines clear, verifiable completion criteria that can be validated through commands.

### prompt-optimizer
Techniques for writing effective prompts with context, structure, validation, and self-correction.

## Agents

### task-analyzer
Classifies tasks, extracts requirements, estimates complexity, identifies dependencies.

### prompt-engineer
Generates optimized prompts with clear structure, asks clarifying questions, designs task architecture.

### completion-detector
Validates task completion via multiple signals: test execution, build status, git state, acceptance criteria.

### loop-orchestrator
Manages Ralph Loop lifecycle: iteration tracking, state persistence, auto-continuation, graceful termination.

## State Management

### DESIGN-<timestamp>.md
Human-readable design document created during design phase.

**Format:**
```markdown
# Task: [Task Name]

## Requirements
- Requirement 1
- Requirement 2

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Validation Commands
```bash
npm test
npm run build
```

## Completion Promise
<promise>TASK_COMPLETE</promise>
```

### .claude-task-state.json
Machine-readable state for loop management.

**Format:**
```json
{
  "task_id": "uuid",
  "status": "running",
  "current_iteration": 5,
  "max_iterations": 20,
  "completion_promise": "TASK_COMPLETE",
  "prompt": "...",
  "design_file": "DESIGN-2026-01-19-1234.md",
  "validation_history": []
}
```

## Hooks

### SessionStart Hook
Reminds Claude to use task templates and create clear completion criteria.

### Stop Hook (stop-loop.sh)
Intercepts exit attempts during Ralph Loop:
- Checks if loop is active via `.claude-task-state.json`
- Verifies if completion promise was emitted
- Checks if max iterations reached
- If neither: re-injects prompt and continues loop
- If either: allows graceful exit

## Installation

### Option 1: Install from Repository

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/claude-plugins.git ~/.claude/plugins/claude-plugins

# Add to your Claude Code settings (~/.claude/settings.json)
{
  "plugins": [
    "~/.claude/plugins/claude-plugins/prompt-automation"
  ]
}
```

### Option 2: Symlink Installation

```bash
# Clone anywhere
git clone https://github.com/YOUR_USERNAME/claude-plugins.git ~/dev/claude-plugins

# Create symlink
ln -s ~/dev/claude-plugins/prompt-automation ~/.claude/plugins/prompt-automation

# Add to settings
{
  "plugins": [
    "~/.claude/plugins/prompt-automation"
  ]
}
```

### Verify Installation

```bash
# Check if the plugin is loaded
claude --help | grep ralph

# Verify stop hook is executable (important for Ralph Loop)
chmod +x ~/.claude/plugins/prompt-automation/hooks/stop-loop.sh
```

## Configuration

No configuration needed. The plugin uses smart defaults:
- Max iterations: 20 (override with `--max-iterations`)
- Design file format: DESIGN-<timestamp>.md
- State file: .claude-task-state.json
- Completion validation: tests + build + git + criteria

## Best Practices

### 1. Start with Design Phase
Always use `/ralph-task-design` first. The interactive clarification process catches issues early.

### 2. Review Design Document
Read the generated DESIGN file before approving. It's your blueprint for the entire task.

### 3. Use Appropriate Templates
Choose the right template for your task type:
- New features → feature-development
- Fixing bugs → bug-fix
- Improving code → refactoring
- Adding tests → testing
- Speed improvements → performance-optimization

### 4. Set Realistic Iterations
- Simple tasks: 10-15 iterations
- Medium tasks: 20-30 iterations
- Complex tasks: 30-50 iterations

### 5. Monitor Progress
Use `/ralph-task-status` to check validation status and remaining work.

### 6. Trust the Validation
The multi-signal validation (tests + build + git + criteria) ensures comprehensive completion.

## Troubleshooting

### Loop Not Starting
- Verify design is approved: check `.claude-task-state.json` status field
- Ensure Stop hook is executable: `chmod +x hooks/stop-loop.sh`

### Loop Exits Prematurely
- Check if completion promise was emitted in output
- Verify Stop hook is configured in `hooks/hooks.json`
- Review validation commands in design file

### Validation Failing
- Run validation commands manually to debug
- Check test failures: `npm test`
- Verify build errors: `npm run build`
- Review git status for unexpected changes

### Too Many Iterations
- Review design for scope creep
- Check if acceptance criteria are too broad
- Consider breaking task into smaller chunks
- Refine design with `/ralph-task-refine --remove`

## Examples

See `skills/prompt-patterns/templates/` for comprehensive examples of each task type.

See `skills/prompt-optimizer/examples/before-after.md` for prompt optimization techniques.

See `skills/completion-criteria/examples/good-criteria.md` for validation patterns.

## License

MIT
