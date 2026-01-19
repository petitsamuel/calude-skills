---
name: audit-report
description: Generate comprehensive audit report file
args:
  - name: output
    description: Output file path
    required: false
    default: ./audit-report.md
---

# Audit Report Command

Generates a comprehensive audit report and saves it to a file.

## Usage

```bash
/audit-report [--output=<path>]
```

## Examples

```bash
# Default output location
/audit-report

# Custom output path
/audit-report --output=./reports/audit-2026-01-19.md

# Save in specific directory
/audit-report --output=/tmp/codebase-audit.md
```

## Report Contents

The generated report includes:

- Executive summary with severity breakdown
- Findings organized by category
- Code examples for each issue
- Remediation recommendations
- Priority rankings
- Evidence and file locations

## Format

Reports are generated in Markdown format with:
- Severity indicators (🔴 🟠 🟡 🟢)
- Syntax-highlighted code blocks
- Clickable file references
- Structured sections
