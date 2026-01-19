---
description: Analyze recent PRs and suggest improvements to skills, CLAUDE.md, commands, and workflows
---

# /pr-learn

Analyzes recent merged pull requests to identify patterns and suggest improvements.

## Usage

```bash
/pr-learn
/pr-learn --days 14
/pr-learn --count 20
/pr-learn --output detailed
```

## Options

- `--days <n>`: Analyze PRs from last N days (default: 7)
- `--count <n>`: Maximum number of PRs to analyze (default: 10)
- `--output <level>`: Output detail level
  - `summary`: High-level findings only (default)
  - `detailed`: Include all analysis and examples
  - `actionable`: Show only actionable suggestions

## What It Analyzes

### 1. PR Comments & Feedback
- Common review comments
- Recurring issues
- Missed patterns
- Frequent corrections

### 2. Code Changes
- Repeated refactoring patterns
- Common bug types
- Performance fixes
- Security improvements

### 3. Workflow Patterns
- Multi-iteration PRs (design issues)
- Frequently amended commits (unclear specs)
- Long review cycles (missing context)
- Scope creep indicators

## Suggestions Generated

### CLAUDE.md Updates
- Add project-specific patterns
- Document common gotchas
- Define coding standards
- Clarify architecture decisions

### New Agent Skills
- Automation for repeated tasks
- Checks for common issues
- Validators for patterns
- Generators for boilerplate

### New Commands
- Shortcuts for frequent workflows
- Validation commands
- Analysis tools
- Code generators

### Workflow Improvements
- Better task breakdown strategies
- Enhanced validation criteria
- Improved prompt patterns
- Optimized agent coordination

## Output Format

### Summary Mode (default)
```
🔍 PR Analysis Results (10 PRs from last 7 days)

📊 Key Findings:
1. [Pattern]: 6 PRs required import path corrections
2. [Pattern]: 4 PRs had missing error handling
3. [Pattern]: 3 PRs needed test coverage improvements

💡 Suggested Improvements:
✓ CLAUDE.md: Add import path conventions
✓ New Skill: error-handler-validator
✓ Command: /validate-coverage

Use --output detailed for full analysis
```

### Detailed Mode
Includes:
- Full PR list with links
- Detailed pattern analysis
- Code examples from PRs
- Specific CLAUDE.md additions
- Complete skill specifications
- Command implementations

### Actionable Mode
Shows only:
- Ready-to-apply CLAUDE.md updates
- Implementable skill ideas
- Command suggestions
- One-line action items

## How It Works

1. **Fetch PRs**: Uses `gh pr list` to get recent merged PRs
2. **Read PR Data**: Fetches comments, diff, commits for each PR
3. **Pattern Detection**: AI-based semantic clustering of issues/patterns
4. **Impact Scoring**: Ranks findings by frequency and severity
5. **Suggestion Generation**: Creates actionable improvements
6. **Output**: Presents findings in requested format

## Examples

### Basic Analysis
```bash
/pr-learn
```

Output:
```
🔍 Analyzing 10 merged PRs from last 7 days...

✓ Found 8 actionable patterns

Top Suggestions:
1. Add to CLAUDE.md: "Always use absolute imports from @/"
2. New skill: import-path-validator
3. Update workflow: Add import validation to PR checklist
```

### Deep Dive
```bash
/pr-learn --days 30 --count 50 --output detailed
```

Provides comprehensive analysis with examples and implementation details.

### Quick Check
```bash
/pr-learn --days 3 --output actionable
```

Shows only recent, immediately actionable improvements.

## Integration

After reviewing suggestions:

```bash
# Apply CLAUDE.md updates (manual)
# Edit ~/.claude/CLAUDE.md or .claude/CLAUDE.md

# Create new skills (via prompt-automation)
/ralph-task-design "Implement import-path-validator skill based on PR patterns"

# Add commands
# Create .claude-plugin/commands/new-command.md

# Update workflows
# Modify existing commands or agent instructions
```

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- Access to repository PRs
- Merged PRs from the specified time period

## Notes

- Only analyzes **merged** PRs (not open or closed without merge)
- Skips draft PRs
- Focuses on patterns, not individual PR quality
- Suggestions are advisory, not prescriptive
- Uses semantic clustering, not simple keyword matching

## Tips

- Run weekly to catch emerging patterns
- Use `--days 14` for new projects to establish baselines
- Review detailed output to understand context
- Apply suggestions incrementally
- Re-run after applying changes to measure impact
