# Claude Code Plugins

Production-ready plugins for enterprise-grade codebase analysis, task automation, and continuous improvement.

## Plugins

Three specialized plugins, each solving a distinct problem:

1. **[Codebase Audit](./codebase-audit/)** - Multi-dimensional code analysis
2. **[Prompt Automation](./prompt-automation/)** - Ralph Loop automation with task design
3. **[PR Learner](./pr-learner/)** - Learn from PR patterns to improve workflows

## Documentation

- **[THREE_PLUGINS_DESIGN.md](./THREE_PLUGINS_DESIGN.md)** - Complete architectural specification
- **[IMPLEMENTATION_PROMPT.md](./IMPLEMENTATION_PROMPT.md)** - Implementation guide
- Plugin-specific README in each directory

## Quick Start

### Codebase Audit
```bash
/audit                    # Full audit
/audit security          # Security only
/audit-report --output=audit.md
```

### Prompt Automation
```bash
/ralph-task-design "Add user auth with JWT"
/ralph-task-approve
/ralph-task-execute --max-iterations=25
```

### PR Learner
```bash
/pr-learn                # Analyze last 7 days
/pr-learn --days=30 --count=50
```

## Installation

Add to Claude Code settings:
```json
{
  "plugins": [
    "/path/to/codebase-audit",
    "/path/to/prompt-automation",
    "/path/to/pr-learner"
  ]
}
```

## Testing

Run validation tests:
```bash
chmod +x test-plugins.sh
./test-plugins.sh
```

## Requirements

- Claude Code CLI
- For PR Learner: GitHub CLI (`gh`) with authentication

## Contributing

1. Test structure: `./test-plugins.sh`
2. Follow naming conventions (kebab-case, frontmatter)
3. See plugin-specific README for details

## License

MIT
