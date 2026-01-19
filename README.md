# Claude Code Plugins

Enterprise-grade Claude Code plugins for comprehensive codebase auditing, intelligent task automation, and continuous learning from pull requests.

## Overview

This repository contains three powerful Claude Code plugins designed to enhance your development workflow:

1. **[Codebase Audit](#codebase-audit)** - Multi-dimensional codebase analysis using specialized AI agents
2. **[Prompt Automation](#prompt-automation)** - Intelligent Ralph Loop automation with task design and validation
3. **[PR Learner](#pr-learner)** - Learn from pull request patterns to suggest workflow improvements

## Installation

### Prerequisites

- [Claude Code CLI](https://code.claude.com/) installed
- Git
- For PR Learner: [GitHub CLI](https://cli.github.com/) (`gh`) installed and authenticated

### Install Plugins

Clone this repository to your Claude Code plugins directory:

```bash
# Clone the repository
git clone https://github.com/petitsamuel/claude-plugins.git ~/.claude/plugins/claude-plugins

# Or if you prefer a different location, clone and symlink:
git clone https://github.com/petitsamuel/claude-plugins.git ~/dev/claude-plugins
ln -s ~/dev/claude-plugins/codebase-audit ~/.claude/plugins/codebase-audit
ln -s ~/dev/claude-plugins/prompt-automation ~/.claude/plugins/prompt-automation
ln -s ~/dev/claude-plugins/pr-learner ~/.claude/plugins/pr-learner
```

### Enable Plugins

Add to your Claude Code settings (`~/.claude/settings.json`):

```json
{
  "plugins": [
    "~/.claude/plugins/claude-plugins/codebase-audit",
    "~/.claude/plugins/claude-plugins/prompt-automation",
    "~/.claude/plugins/claude-plugins/pr-learner"
  ]
}
```

### Verify Installation

```bash
# List available commands from the plugins
claude --help | grep -E "(audit|ralph|pr-learn)"
```

---

## Codebase Audit

Comprehensive automated code quality analysis across multiple dimensions using specialized AI agents.

### Features

**Multi-Dimensional Analysis:**
- 🔒 **Security** - OWASP Top 10, vulnerability detection, secrets scanning
- 🛡️ **Safety** - Error handling, edge cases, failure modes
- 📐 **Code Quality** - Patterns, complexity, technical debt
- ⚡ **Performance** - Bottlenecks, N+1 queries, optimization opportunities
- ♿ **Accessibility** - WCAG 2.1 compliance (for web projects)
- 📦 **Dependencies** - Vulnerability scanning, outdated packages
- 🧪 **Test Coverage** - Coverage analysis, test quality assessment
- 📖 **Documentation** - Completeness, clarity, accuracy

### Quick Start

```bash
# Run comprehensive audit
/audit

# Security-focused audit
/audit security

# Generate detailed report
/audit-report --output=./audit-report.md
```

[Full Documentation →](./codebase-audit/README.md)

---

## Prompt Automation

Intelligent Ralph Loop automation with interactive task design, refinement, and multi-signal completion validation.

### Features

- 🎯 **Interactive Task Design** - Clarifying questions and requirement extraction
- 📝 **8 Task Templates** - Pre-built patterns for common development scenarios
- 🔄 **Ralph Loop Automation** - Self-correcting iterative execution
- ✅ **Multi-Signal Validation** - Tests, builds, git status, and acceptance criteria
- 📊 **Progress Tracking** - Real-time status and iteration monitoring

### Quick Start

```bash
# Design a new task
/ralph-task-design "Add user authentication with JWT"

# Refine the design
/ralph-task-refine --add "Include password reset flow"

# Approve and execute
/ralph-task-approve
/ralph-task-execute

# Monitor progress
/ralph-task-status
```

[Full Documentation →](./prompt-automation/README.md)

### Ralph Loop Explained

The Ralph Loop enables autonomous, iterative task completion:

1. **Design Phase** - Interactive clarification and task specification
2. **Execution** - Automated loop with validation after each iteration
3. **Validation** - Tests, builds, git status, and acceptance criteria
4. **Self-Correction** - Continues until completion or max iterations

**Key Innovation:** The same prompt is re-injected after each iteration, allowing Claude to see its own work and continuously improve until all criteria are met.

---

## PR Learner

Analyze merged pull requests to identify patterns and automatically suggest improvements to skills, conventions, and workflows.

### Features

- 🔍 **Pattern Detection** - AI-based semantic clustering of recurring issues
- 📊 **Impact Scoring** - Prioritizes suggestions by frequency and ROI
- 📈 **Trend Analysis** - Tracks pattern evolution over time
- 💡 **Actionable Suggestions** - Ready-to-implement improvements
- 🔗 **GitHub Integration** - Seamless PR data via `gh` CLI

### Quick Start

```bash
# Analyze recent PRs
/pr-learn

# Deeper analysis
/pr-learn --days 30 --count 50 --output detailed

# Get only actionable items
/pr-learn --output actionable
```

[Full Documentation →](./pr-learner/README.md)

### What It Learns

The plugin analyzes PRs to suggest:
- **CLAUDE.md Updates** - Document missing conventions
- **New Agent Skills** - Automate repetitive validations
- **New Commands** - Streamline common workflows
- **Process Improvements** - Optimize development practices

---

## Architecture

All three plugins follow a consistent agent-based architecture:

- **Commands** - User-facing interfaces (e.g., `/audit`, `/ralph-task-design`, `/pr-learn`)
- **Agents** - Specialized AI agents that handle specific responsibilities
- **Skills** - Reusable capabilities shared across agents
- **Hooks** - Event-based automation (e.g., Ralph Loop continuation)

See [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed design specifications.

---

## Documentation

- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Complete architectural design and specifications
- **[NAMING_CONVENTIONS.md](./NAMING_CONVENTIONS.md)** - Contributing guidelines and naming standards
- **Plugin-specific READMEs:**
  - [codebase-audit/README.md](./codebase-audit/README.md)
  - [prompt-automation/README.md](./prompt-automation/README.md)
  - [pr-learner/README.md](./pr-learner/README.md)

---

## Design Principles

### 1. Modularity
- Each agent has a single, clear responsibility
- Skills are reusable across multiple agents
- Commands compose agents and skills

### 2. Parallelization
- Audit agents run in parallel for performance
- Independent analyses don't block each other

### 3. Extensibility
- Easy to add new audit dimensions
- Customizable templates and patterns
- Plugin architecture supports custom agents

### 4. Safety
- Max iteration limits prevent infinite loops
- Graceful cancellation and error handling
- Clear completion criteria

### 5. Actionability
- All findings include remediation steps
- Code examples for fixes provided
- Prioritized by severity and impact

---

## Examples

### Comprehensive Codebase Audit

```bash
# Run full audit
/audit

# Output includes:
# - Security vulnerabilities (OWASP Top 10)
# - Code quality issues
# - Performance bottlenecks
# - Test coverage gaps
# - Documentation issues
```

### Automated Feature Development

```bash
# Design the feature
/ralph-task-design "Add OAuth2 authentication"

# Review and approve the generated design
/ralph-task-approve

# Execute with Ralph Loop
/ralph-task-execute --max-iterations 25

# Claude automatically:
# - Implements the feature
# - Writes tests
# - Runs validation
# - Self-corrects issues
# - Continues until complete
```

### Learning from PRs

```bash
# Analyze last month's PRs
/pr-learn --days 30 --count 50

# Output suggests:
# - Add import path conventions to CLAUDE.md
# - Create /validate-error-handling skill
# - Use /ralph-task-design for features
# - Add test coverage requirements
```

---

## Requirements

### All Plugins
- Claude Code CLI
- Git
- Project source code

### PR Learner Additional Requirements
- GitHub CLI (`gh`) installed
- GitHub authentication configured
- Read access to repository

---

## Contributing

Contributions are welcome! Please follow:

1. **Naming Conventions** - See [NAMING_CONVENTIONS.md](./NAMING_CONVENTIONS.md)
2. **Architecture Patterns** - See [ARCHITECTURE.md](./ARCHITECTURE.md)
3. **Code Quality** - Use the codebase-audit plugin on your changes
4. **Testing** - Test your changes thoroughly

### Development Setup

```bash
# Clone the repository
git clone https://github.com/petitsamuel/claude-plugins.git
cd claude-plugins

# Make your changes

# Test with local installation
ln -s $(pwd)/codebase-audit ~/.claude/plugins/codebase-audit
```

---

## Resources

### Claude Code Documentation
- [Claude Code Overview](https://code.claude.com/)
- [Plugin System Reference](https://code.claude.com/docs/en/plugins-reference)

### Ralph Loop Resources
- [Ralph Loop Explained](https://blog.devgenius.io/ralph-wiggum-explained-the-claude-code-loop-that-keeps-going-3250dcc30809)
- [Awesome Claude](https://awesomeclaude.ai/ralph-wiggum)

---

## License

MIT License - See [LICENSE](./LICENSE) file for details

---

## Support

- **Issues** - [GitHub Issues](https://github.com/petitsamuel/claude-plugins/issues)
- **Discussions** - [GitHub Discussions](https://github.com/petitsamuel/claude-plugins/discussions)
- **Documentation** - See individual plugin READMEs

---

## Built for the Claude Code community
