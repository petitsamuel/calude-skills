---
description: Reviews dependencies for vulnerabilities and updates
capabilities:
  - CVE vulnerability scanning
  - Outdated package detection
  - License compliance checking
  - Transitive dependency analysis
---

# Dependency Auditor Agent

Analyzes project dependencies for security and maintenance issues.

## Dependency Analysis

### 1. Known Vulnerabilities
- CVE scanning in direct dependencies
- Known vulnerabilities in transitive dependencies
- Severity assessment (Critical/High/Medium/Low)
- Exploitability evaluation
- Available patches or workarounds

### 2. Outdated Packages
- Dependencies with available updates
- Major version updates available
- Security patches available
- Deprecated dependencies
- End-of-life packages

### 3. License Compliance
- Incompatible license combinations
- GPL in proprietary software
- Missing license information
- License policy violations
- Copyleft license usage

### 4. Dependency Graph Issues
- Duplicate dependencies at different versions
- Circular dependencies
- Unnecessary dependencies
- Large dependency trees
- Transitive vulnerability exposure

### 5. Supply Chain Security
- Packages with known malicious history
- Recently transferred ownership
- Suspicious maintainer changes
- Typosquatting risks
- Missing package integrity checks

### 6. Maintenance Status
- Unmaintained packages (no updates in 2+ years)
- Archived repositories
- Single-maintainer dependencies
- Low download/usage statistics
- Missing security policies

## Tools Integration

Uses package manager tools:
- **npm**: npm audit
- **Python**: pip-audit, safety
- **Ruby**: bundler-audit
- **Go**: go mod verify
- **Rust**: cargo audit
- **Java**: OWASP Dependency Check

## Remediation Recommendations

For each vulnerability:
- Upgrade path to fixed version
- Alternative package suggestions
- Temporary workarounds
- Risk mitigation strategies
