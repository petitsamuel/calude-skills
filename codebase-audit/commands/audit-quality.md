---
name: audit-quality
description: Code quality and maintainability analysis
args:
  - name: metrics
    description: Include quantitative metrics
    required: false
    default: false
---

# Quality Audit Command

Analyzes code quality, maintainability, and technical debt.

## Usage

```bash
/audit-quality [--metrics]
```

## Examples

```bash
# Standard quality audit
/audit-quality

# Include detailed metrics
/audit-quality --metrics
```

## What It Analyzes

- Code duplication (DRY violations)
- Function/method length
- Cyclomatic complexity
- Nesting depth
- Code smells
- Design pattern usage
- Naming conventions
- Magic numbers/strings
- God classes/objects
- Tight coupling
- Technical debt accumulation

## Metrics Mode

When `--metrics` flag is used, includes:
- Cyclomatic complexity scores
- Lines of code per function
- Duplication percentages
- Maintainability index
- Cognitive complexity
