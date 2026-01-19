---
name: audit-security
description: Security-focused codebase scan
args:
  - name: deep
    description: Enable deep security analysis
    required: false
    default: false
---

# Security Audit Command

Performs focused security audit of the codebase.

## Usage

```bash
/audit-security [--deep]
```

## Examples

```bash
# Standard security audit
/audit-security

# Deep security analysis
/audit-security --deep
```

## What It Checks

- SQL injection vulnerabilities
- XSS (Cross-Site Scripting) risks
- Authentication and authorization flaws
- Hardcoded secrets and credentials
- Insecure cryptographic practices
- Command injection points
- Insecure deserialization
- CSRF vulnerabilities
- Security misconfigurations
- Unsafe API practices

## Deep Mode

When `--deep` flag is used:
- More thorough pattern matching
- Additional vulnerability checks
- Dependency vulnerability deep scan
- Complex attack vector analysis
