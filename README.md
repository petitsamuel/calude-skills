# Claude Code Plugins

Production-ready plugins for enterprise-grade codebase analysis, task automation, and continuous improvement.

## Plugins

Three specialized plugins, each solving a distinct problem:

1. **[Codebase Audit](./codebase-audit/)** - Multi-dimensional code analysis
2. **[Prompt Automation](./prompt-automation/)** - Ralph Loop automation with task design
3. **[PR Learner](./pr-learner/)** - Learn from PR patterns to improve workflows

## Documentation

- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Complete architectural design and specifications
- **[NAMING_CONVENTIONS.md](./NAMING_CONVENTIONS.md)** - Contributing guidelines and naming standards
- Plugin-specific README in each directory

## Quick Start

### Codebase Audit
```bash
/audit                    # Full audit
/audit security          # Security only
/audit-report            # Outputs to ./audit-report.md (default)
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

Run validation tests to verify plugin structure:
```bash
chmod +x test-plugins.sh
./test-plugins.sh
```

The script validates:
- Directory structure (agents, commands, skills, hooks)
- JSON validity (plugin.json, hooks.json)
- Frontmatter presence in agent files
- SKILL.md files in skill directories

## Requirements

- Claude Code CLI
- For PR Learner: GitHub CLI (`gh`) with authentication

## Contributing

1. Test structure: `./test-plugins.sh`
2. Follow naming conventions (kebab-case, frontmatter)
3. See plugin-specific README for details

## License

MIT
