# Claude Code Plugins - Design Repository

Enterprise-grade Claude Code plugins for comprehensive codebase auditing and intelligent task automation.

## 📋 Repository Contents

This repository contains the complete design specifications for two powerful Claude Code plugins:

1. **[Codebase Audit Plugin](#codebase-audit-plugin)** - Multi-dimensional codebase analysis using specialized sub-agents
2. **[Prompt Automation Plugin](#prompt-automation-plugin)** - Intelligent prompt engineering and Ralph Loop automation

## 📚 Documentation

- **[PLUGIN_DESIGN.md](./PLUGIN_DESIGN.md)** - Complete architectural design for both plugins
  - Directory structures
  - Agent specifications
  - Skill definitions
  - Command interfaces
  - Hook configurations
  - Usage examples
  - Implementation roadmap

- **[NAMING_CONVENTIONS.md](./NAMING_CONVENTIONS.md)** - Comprehensive naming standards
  - File and directory naming
  - Command and agent naming
  - Variable naming conventions
  - JSON field naming
  - Anti-patterns to avoid
  - Validation checklist

## 🔍 Codebase Audit Plugin

### Overview

The **codebase-audit** plugin performs comprehensive, automated code quality analysis across multiple dimensions using specialized AI agents.

### Key Features

**Multi-Dimensional Analysis:**
- 🔒 **Security** - OWASP Top 10, vulnerability detection, secrets scanning
- 🛡️ **Safety** - Error handling, edge cases, failure modes
- 📐 **Code Quality** - Patterns, complexity, technical debt
- ⚡ **Performance** - Bottlenecks, N+1 queries, optimization opportunities
- ♿ **Accessibility** - WCAG 2.1 compliance (for web projects)
- 📦 **Dependencies** - Vulnerability scanning, outdated packages
- 🧪 **Test Coverage** - Coverage analysis, test quality assessment
- 📖 **Documentation** - Completeness, clarity, accuracy

### Architecture

```
┌─────────────────────────────────────┐
│     Audit Orchestrator Agent        │
│  (Coordinates all audit agents)     │
└───────────────┬─────────────────────┘
                │
    ┌───────────┴───────────┐
    │                       │
    ▼                       ▼
┌─────────┐           ┌─────────┐
│Security │           │ Quality │
│ Auditor │           │ Auditor │
└─────────┘           └─────────┘
    │                       │
    ▼                       ▼
┌─────────┐           ┌─────────┐
│  Safety │           │  Perf   │
│ Auditor │           │ Auditor │
└─────────┘           └─────────┘
    │                       │
    └───────────┬───────────┘
                │
                ▼
        ┌───────────────┐
        │    Report     │
        │   Generator   │
        └───────────────┘
```

### Usage

```bash
# Full comprehensive audit
/audit all

# Security-focused audit
/audit security --severity=high

# Code quality with metrics
/quality-audit --metrics

# Generate comprehensive report
/full-report --output=./audit-report.md
```

### Sample Output

```markdown
# Codebase Audit Report

## Executive Summary
- 🔴 Critical Issues: 3
- 🟠 High Severity: 12
- 🟡 Medium Severity: 28
- 🟢 Low Severity: 45

## Security Findings

### 🔴 Critical: SQL Injection Vulnerability
**Location**: `src/api/users.ts:45`
**Severity**: Critical
**Description**: User input directly interpolated into SQL query

**Vulnerable Code:**
```js
const query = `SELECT * FROM users WHERE id = ${userId}`;
```

**Remediation:**
```js
const query = `SELECT * FROM users WHERE id = ?`;
db.query(query, [userId]);
```
```

---

## 🤖 Prompt Automation Plugin

### Overview

The **prompt-automation** plugin is an intelligent prompt engineering system that automates complex, multi-step tasks using Ralph Loop methodology.

### Key Features

**Intelligent Prompt Engineering:**
- 🎯 **Auto-Generation** - Analyzes tasks and generates optimal prompts
- 📝 **Template Library** - Proven patterns for common tasks
- 🔄 **Ralph Loop** - Iterative self-improvement execution
- ✅ **Completion Detection** - Automatic task completion verification
- 🎓 **Learning** - Improves prompts based on execution feedback

### Architecture

```
User Task
    │
    ▼
┌─────────────────┐
│ Task Analyzer   │
│ (Extracts reqs) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Prompt Engineer │
│ (Generates      │
│  optimal prompt)│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Loop            │
│ Orchestrator    │
│                 │
│ ┌─────────────┐ │
│ │ Execute     │ │
│ │ ↓           │ │
│ │ Check       │ │
│ │ ↓           │ │
│ │ Complete? →Exit
│ │ ↓           │ │
│ │ Re-inject   │ │
│ └──────↑──────┘ │
│        │        │
└────────┼────────┘
         │
     Iteration++
```

### Ralph Loop Mechanism

The Ralph Loop enables autonomous, iterative task completion:

1. **Inject Prompt** - Initial task prompt sent to Claude
2. **Execute** - Claude works on task, modifies files
3. **Stop Hook** - Intercepts exit attempt
4. **Check Completion** - Verifies completion criteria
5. **Re-inject** - Same prompt sent again with accumulated context
6. **Loop** - Claude sees previous work, continues improving

**Key Innovation:** The prompt never changes, but context accumulates through file modifications and git history, enabling true self-referential improvement.

### Usage

```bash
# Auto-generate prompt from task description
/auto-prompt "Build a REST API for todos with CRUD operations"

# Output:
# ┌─────────────────────────────────────┐
# │ Build Todo REST API:                │
# │                                     │
# │ Requirements:                       │
# │ - POST /todos (create)              │
# │ - GET /todos (list)                 │
# │ - GET /todos/:id (get one)          │
# │ - PUT /todos/:id (update)           │
# │ - DELETE /todos/:id (delete)        │
# │ - Input validation                  │
# │ - Error handling                    │
# │                                     │
# │ Testing:                            │
# │ - Unit tests (80%+ coverage)        │
# │ - Integration tests                 │
# │ - All tests must pass               │
# │                                     │
# │ Documentation:                      │
# │ - OpenAPI/Swagger docs              │
# │ - README with API examples          │
# │                                     │
# │ Completion Criteria:                │
# │ - All CRUD endpoints working        │
# │ - Tests passing                     │
# │ - Docs generated                    │
# │                                     │
# │ Output: <promise>COMPLETE</promise> │
# └─────────────────────────────────────┘

# Start Ralph Loop with generated prompt
/start-loop "<generated prompt>" --max-iterations=25 --promise="COMPLETE"

# Cancel if needed
/cancel-loop
```

### Prompt Templates

Pre-built templates for common scenarios:

- **feature-development.md** - New feature with tests and docs
- **bug-fix.md** - TDD-style bug resolution
- **refactoring.md** - Safe, test-driven refactoring
- **testing.md** - Test suite creation
- **performance-optimization.md** - Optimization with benchmarks
- **security-fix.md** - Security vulnerability remediation

### Real-World Impact

The Ralph Loop methodology has demonstrated impressive results:

- **6 repositories** generated overnight (Y Combinator hackathon)
- **$50k contract** completed for $297 in API costs
- **Programming language** ("cursed") created over 3 months
- **Autonomous feature development** from vague requirements

---

## 🏗️ Implementation Roadmap

### Phase 1: Foundation (Week 1)
- [ ] Initialize repository structure
- [ ] Create directory layouts for both plugins
- [ ] Write plugin.json configurations
- [ ] Set up basic documentation

### Phase 2: Codebase Audit (Weeks 2-3)
- [ ] Implement core audit agents
  - [ ] audit-orchestrator
  - [ ] security-auditor
  - [ ] code-quality-auditor
  - [ ] performance-auditor
- [ ] Build report-generator skill
- [ ] Create audit command interface
- [ ] Test with sample codebases

### Phase 3: Prompt Automation (Weeks 3-4)
- [ ] Implement prompt-engineer agent
- [ ] Create task-analyzer agent
- [ ] Build loop-orchestrator agent
- [ ] Implement Ralph Loop stop hook
- [ ] Create prompt template library
- [ ] Test with sample tasks

### Phase 4: Integration & Testing (Week 5)
- [ ] Comprehensive integration testing
- [ ] Performance optimization
- [ ] Error handling and edge cases
- [ ] User documentation
- [ ] Example use cases

### Phase 5: Polish & Launch (Week 6)
- [ ] Final testing and bug fixes
- [ ] Video demos and tutorials
- [ ] Community documentation
- [ ] Launch announcement

---

## 🎯 Design Principles

### 1. Modularity
- Each agent has a single, clear responsibility
- Skills are reusable across multiple agents
- Commands compose agents and skills

### 2. Parallelization
- Audit agents run in parallel for performance
- Independent analyses don't block each other
- Results aggregated efficiently

### 3. Extensibility
- Easy to add new audit dimensions
- Prompt templates are user-customizable
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

## 🔧 Technical Stack

### Codebase Audit Plugin
- **Analysis Tools**: ESLint, PyLint, TSC, RuboCop (language-specific)
- **Security Scanners**: npm audit, Snyk, Bandit, Brakeman
- **Coverage Tools**: Jest, coverage.py, SimpleCov
- **Report Formats**: Markdown, JSON, HTML

### Prompt Automation Plugin
- **State Management**: Shell scripts, JSON state files
- **Hooks**: Bash stop hook for loop continuation
- **Templates**: Markdown prompt templates
- **Detection**: Pattern matching, test verification

---

## 📖 Resources

### Claude Code Documentation
- [Claude Code Overview](https://code.claude.com/docs/en/overview)
- [Plugin System Reference](https://code.claude.com/docs/en/plugins-reference)
- [Agent Development Guide](https://docs.claude.com/en/api/agent-sdk/overview)

### Ralph Loop Resources
- [Ralph Wiggum Explained](https://blog.devgenius.io/ralph-wiggum-explained-the-claude-code-loop-that-keeps-going-3250dcc30809)
- [Awesome Claude - Ralph Loop](https://awesomeclaude.ai/ralph-wiggum)
- [Official Ralph Loop Plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/ralph-loop)

### Example Plugins
- [Official Claude Plugins](https://github.com/anthropics/claude-code/tree/main)
- [PR Review Toolkit](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/pr-review-toolkit)
- [Code Review Plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/code-review)

---

## 🤝 Contributing

Contributions are welcome! Please follow:

1. **Naming Conventions** - See [NAMING_CONVENTIONS.md](./NAMING_CONVENTIONS.md)
2. **Architecture Patterns** - See [PLUGIN_DESIGN.md](./PLUGIN_DESIGN.md)
3. **Code Quality** - Use the codebase-audit plugin on your changes!
4. **Testing** - Include tests for new agents and skills

---

## 📝 License

MIT License - See LICENSE file for details

---

## 🙋 Questions & Support

- **Documentation**: See [PLUGIN_DESIGN.md](./PLUGIN_DESIGN.md)
- **Issues**: Open a GitHub issue
- **Discussions**: Use GitHub Discussions

---

## 🎉 Acknowledgments

- **Anthropic** - For Claude Code and the plugin system
- **Ralph Loop Community** - For pioneering iterative AI workflows
- **Claude Code Plugin Developers** - For inspiration and examples

---

**Built with ❤️ for the Claude Code community**
