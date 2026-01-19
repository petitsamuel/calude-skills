# Codebase Audit Plugin

Comprehensive multi-dimensional codebase analysis using specialized sub-agents.

## Overview

The codebase-audit plugin performs thorough analysis of your codebase across multiple dimensions including security, quality, performance, testing, dependencies, documentation, safety, and accessibility. It uses specialized AI agents that run in parallel to provide fast, comprehensive audits with actionable recommendations.

## Features

- **8 Audit Dimensions**: Security, Quality, Performance, Tests, Dependencies, Documentation, Safety, Accessibility
- **Parallel Execution**: All agents run simultaneously for maximum speed
- **4 Severity Levels**: Critical, High, Medium, Low with clear prioritization
- **Actionable Results**: Every finding includes remediation steps with code examples
- **Flexible Scoping**: Run full audits or focus on specific areas

## Commands

### `/audit [scope] [--format=markdown] [--severity=low]`

Main comprehensive audit command.

**Scopes:**
- `all` - Run all audit dimensions (default)
- `security` - OWASP Top 10, vulnerabilities
- `quality` - Code smells, complexity, patterns
- `performance` - Bottlenecks, N+1 queries
- `tests` - Test coverage and quality
- `deps` - Dependency vulnerabilities
- `docs` - Documentation completeness
- `safety` - Error handling, edge cases
- `a11y` - Accessibility (WCAG 2.1)

**Examples:**
```bash
# Full audit
/audit

# Security only
/audit security

# High severity issues only
/audit all --severity=high
```

### `/audit-security [--deep]`

Focused security scan.

```bash
# Standard security audit
/audit-security

# Deep security analysis
/audit-security --deep
```

### `/audit-quality [--metrics]`

Code quality and maintainability analysis.

```bash
# Standard quality audit
/audit-quality

# Include detailed metrics
/audit-quality --metrics
```

### `/audit-report [--output=path]`

Generate comprehensive audit report file.

```bash
# Default output
/audit-report

# Custom output path
/audit-report --output=./reports/audit-2026-01-19.md
```

### `/audit-status`

Show active audit progress.

```bash
/audit-status
```

## Audit Dimensions

### 1. Security
- SQL injection, XSS, CSRF vulnerabilities
- Authentication and authorization flaws
- Hardcoded secrets and credentials
- Insecure cryptographic practices
- OWASP Top 10 coverage

### 2. Safety
- Error handling patterns
- Silent failure detection
- Edge case handling
- Resource leak detection
- Null/undefined safety

### 3. Code Quality
- Code duplication (DRY violations)
- Function complexity and length
- Code smells and anti-patterns
- Naming conventions
- Technical debt

### 4. Performance
- Algorithmic complexity (O(n²) or worse)
- N+1 query patterns
- Memory leaks
- Caching opportunities
- Frontend optimization (for web projects)

### 5. Test Coverage
- Coverage percentages
- Untested critical paths
- Test quality assessment
- Flaky test detection
- Missing test types

### 6. Dependencies
- Known CVE vulnerabilities
- Outdated packages
- License compliance
- Supply chain security
- Maintenance status

### 7. Documentation
- README quality
- API documentation completeness
- Code comments
- Setup instructions
- Architecture documentation

### 8. Accessibility (Web Projects)
- WCAG 2.1 compliance
- ARIA usage
- Keyboard navigation
- Screen reader compatibility
- Color contrast

## Severity Levels

- 🔴 **Critical** - Fix immediately (security breaches, data loss)
- 🟠 **High** - Fix this sprint (significant vulnerabilities)
- 🟡 **Medium** - Plan to fix (quality issues, moderate risks)
- 🟢 **Low** - Track as tech debt (minor improvements)

## Example Output

```markdown
# Codebase Audit Report

## Executive Summary
- 🔴 Critical: 3
- 🟠 High: 12
- 🟡 Medium: 28
- 🟢 Low: 45

## Security Findings

### 🔴 Critical: SQL Injection Vulnerability
**Location:** `src/api/users.ts:45`

**Vulnerable Code:**
```javascript
const query = `SELECT * FROM users WHERE id = ${userId}`;
```

**Remediation:**
```javascript
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

**Priority:** Fix immediately
```

## Installation

### Option 1: Install from Repository

```bash
# Clone the repository
git clone https://github.com/petitsamuel/calude-skills.git ~/.claude/plugins/claude-plugins

# Add to your Claude Code settings (~/.claude/settings.json)
{
  "plugins": [
    "~/.claude/plugins/claude-plugins/codebase-audit"
  ]
}
```

### Option 2: Symlink Installation

```bash
# Clone anywhere
git clone https://github.com/petitsamuel/calude-skills.git ~/dev/claude-plugins

# Create symlink
ln -s ~/dev/claude-plugins/codebase-audit ~/.claude/plugins/codebase-audit

# Add to settings
{
  "plugins": [
    "~/.claude/plugins/codebase-audit"
  ]
}
```

### Verify Installation

```bash
# Check if the plugin is loaded
claude --help | grep audit
```

## Configuration

Optional configuration in `.claude/settings.json`:

```json
{
  "codebase-audit": {
    "ignore-paths": ["node_modules/", "vendor/", "dist/"],
    "severity-threshold": "medium"
  }
}
```

## Architecture

The plugin uses a coordinator-agent pattern:

1. **audit-orchestrator** - Coordinates all audit agents
2. **8 specialized agents** - Each handles one audit dimension
3. **Agents run in parallel** - Maximum performance
4. **Results aggregated** - Deduplicated and prioritized
5. **Report generated** - Professional markdown output

## Requirements

- Claude Code CLI
- Project source code
- (Optional) Package manager tools (npm, pip, cargo, etc.) for dependency scanning

## License

MIT

## Support

For issues or questions, please open an issue in the repository.
