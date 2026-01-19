# Codebase Audit Plugin

Multi-dimensional codebase analysis using 8 specialized parallel agents.

## Commands

```bash
/audit [scope]           # Main audit (scopes: all|security|quality|performance|tests|deps|docs|safety|a11y)
/audit-security [--deep] # Security-focused scan
/audit-quality [--metrics] # Code quality analysis
/audit-report [--output=path] # Generate report file
/audit-status            # Show progress
```

## What It Audits

1. **Security** - OWASP Top 10, SQL injection, XSS, secrets, auth flaws
2. **Safety** - Error handling, edge cases, resource leaks, null safety
3. **Code Quality** - Duplication, complexity, smells, naming, tech debt
4. **Performance** - N+1 queries, algorithmic complexity, memory leaks, caching
5. **Test Coverage** - Coverage %, untested paths, test quality, flaky tests
6. **Dependencies** - CVEs, outdated packages, license compliance
7. **Documentation** - README, API docs, comments, setup instructions
8. **Accessibility** - WCAG 2.1, ARIA, keyboard nav, screen readers (web only)

## Severity Levels

- 🔴 **Critical** - Fix immediately
- 🟠 **High** - Fix this sprint
- 🟡 **Medium** - Plan to fix
- 🟢 **Low** - Track as tech debt

## Configuration

Optional in `.claude/settings.json`:
```json
{
  "codebase-audit": {
    "ignore-paths": ["node_modules/", "dist/"],
    "severity-threshold": "medium"
  }
}
```

## License

MIT
