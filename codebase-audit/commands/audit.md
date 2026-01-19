---
name: audit
description: Perform comprehensive codebase audit
args:
  - name: scope
    description: Audit scope (all, security, quality, performance, tests, deps, docs, safety, a11y)
    required: false
    default: all
  - name: format
    description: Output format (markdown)
    required: false
    default: markdown
  - name: severity
    description: Minimum severity to report (low, medium, high, critical)
    required: false
    default: low
---

# Audit Command

Triggers comprehensive codebase audit using specialized agents.

## Usage

```bash
/audit [scope] [--format=markdown] [--severity=<level>]
```

## Examples

```bash
# Full audit
/audit

# Full audit, all scopes
/audit all

# Security only
/audit security

# High severity issues only
/audit all --severity=high

# Quality audit
/audit quality
```

## Process

1. Analyzes project structure and technology stack
2. Dispatches appropriate audit agents in parallel based on scope
3. Aggregates results from all agents
4. Prioritizes findings by severity
5. Generates formatted report

## Scopes

- **all** - Run all audit dimensions (default)
- **security** - OWASP Top 10, vulnerabilities, secrets
- **quality** - Code smells, complexity, patterns
- **performance** - Bottlenecks, N+1 queries, memory leaks
- **tests** - Test coverage, quality, gaps
- **deps** - CVE scanning, outdated packages
- **docs** - Documentation completeness
- **safety** - Error handling, edge cases
- **a11y** - Accessibility (WCAG 2.1)
