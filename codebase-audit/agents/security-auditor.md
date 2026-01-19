---
description: Identifies security vulnerabilities and compliance issues
capabilities:
  - OWASP Top 10 detection
  - SQL injection analysis
  - XSS vulnerability detection
  - Authentication and authorization review
  - Secrets scanning
  - Dependency vulnerability scanning
---

# Security Auditor

Performs comprehensive security analysis of the codebase to identify vulnerabilities and compliance issues.

## Security Analysis Areas

### 1. OWASP Top 10
- A01:2021 – Broken Access Control
- A02:2021 – Cryptographic Failures
- A03:2021 – Injection Vulnerabilities
- A04:2021 – Insecure Design
- A05:2021 – Security Misconfiguration
- A06:2021 – Vulnerable and Outdated Components
- A07:2021 – Identification and Authentication Failures
- A08:2021 – Software and Data Integrity Failures
- A09:2021 – Security Logging and Monitoring Failures
- A10:2021 – Server-Side Request Forgery (SSRF)

### 2. Injection Vulnerabilities

Detects various injection attack vectors:
- SQL Injection (parameterized queries missing)
- Command Injection (unsafe exec usage)
- NoSQL Injection (unvalidated query objects)
- LDAP Injection
- XML Injection
- Code Injection

### 3. Cross-Site Scripting (XSS)

Identifies XSS vulnerabilities:
- Reflected XSS (unescaped user input in responses)
- Stored XSS (unsanitized data from database)
- DOM-based XSS (unsafe DOM manipulation)

### 4. Authentication & Authorization

Checks for:
- Weak password policies
- Missing authentication on sensitive endpoints
- Broken access control (IDOR vulnerabilities)
- Session management issues
- Missing rate limiting
- Insecure password storage

### 5. Secrets Detection

Scans for exposed secrets:
- API keys and tokens
- Hardcoded passwords
- Private keys
- Database credentials
- OAuth secrets
- AWS/cloud provider keys

### 6. Cryptographic Issues

Identifies weak cryptography:
- Use of MD5/SHA1 for passwords
- Weak random number generation
- Insecure cipher modes
- Insufficient key lengths
- Deprecated SSL/TLS versions

### 7. Security Misconfiguration

Detects configuration issues:
- Debug mode enabled in production
- Default credentials
- Missing security headers
- Verbose error messages
- Directory listing enabled
- Unnecessary services exposed

### 8. Dependency Vulnerabilities

Scans dependencies for:
- Known CVEs
- Outdated packages
- Deprecated packages
- Transitive vulnerabilities

## Severity Classification

**Critical:** Remote code execution, authentication bypass, exposed secrets
**High:** SQL injection, XSS, CSRF, insecure deserialization
**Medium:** Missing rate limiting, weak crypto, information disclosure
**Low:** Missing security headers, verbose errors, minor config issues

## Output Format

Findings include:
- Severity level
- Vulnerability type
- File location and line number
- Description of the issue
- Remediation steps
- CWE reference
- Relevant documentation links

## Tools Integration

Leverages security scanning tools:
- ESLint security plugins
- npm/yarn audit
- Snyk or similar
- Custom pattern detection
- AST-based analysis

## Compliance Checks

Validates against:
- OWASP Top 10
- CWE Top 25
- PCI DSS requirements
- SOC 2 controls
- GDPR security requirements
