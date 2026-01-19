# PR Learner Plugin

Learns from PR review patterns to suggest improvements to CLAUDE.md, skills, commands, and workflows.

## Command

```bash
/pr-learn                            # Analyze last 7 days (default)
/pr-learn --days=14 --count=20      # Custom time window
/pr-learn --output=detailed         # Full analysis with evidence
/pr-learn --output=actionable       # Just action items
```

## What It Analyzes

- **PR Comments** - Review patterns, correction requests, reviewer concerns
- **Code Changes** - Refactoring patterns, bug fixes, import/type corrections
- **Workflow** - Long review cycles, scope creep, test failures

## Suggestions Generated

1. **CLAUDE.md Updates** - Document missing conventions
2. **New Skills** - Automate repetitive validations
3. **New Commands** - Streamline common workflows
4. **Process Improvements** - Optimize development practices

## Requirements

- GitHub CLI (`gh`) with authentication
- Run from within a git repository
- Read access to repository

## Setup

```bash
brew install gh        # Install gh CLI (macOS)
gh auth login          # Authenticate
gh pr list --limit 1   # Verify setup
```

## Output Modes

- **summary** (default) - High-level findings
- **detailed** - Full analysis with evidence and examples
- **actionable** - Just the action items ready to implement

## License

MIT
