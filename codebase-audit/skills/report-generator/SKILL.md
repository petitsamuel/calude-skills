---
name: report-generator
description: Generates professional audit reports in multiple formats
resources:
  - templates/audit-report.md
---

# Report Generator Skill

Transforms audit findings from multiple agents into professional, actionable reports.

## What This Skill Does

Takes raw findings from all audit agents and creates structured, prioritized reports with:
- Executive summary with metrics
- Findings organized by severity and category
- Code examples for each issue
- Remediation recommendations with secure code examples
- Priority rankings for fixes
- File locations and line numbers

## When To Use

Automatically invoked by audit-orchestrator after all audit agents complete their analysis.

## Capabilities

### 1. Format Support
- **Markdown** - Human-readable reports with syntax highlighting
- Additional formats can be added in future versions

### 2. Report Sections
- **Executive Summary**: High-level overview with severity breakdown
- **Findings by Category**: Security, Quality, Performance, etc.
- **Detailed Remediation**: Step-by-step fix instructions
- **Metrics & Statistics**: Counts, percentages, trends

### 3. Prioritization
- Sort findings by severity (Critical → Low)
- Group related issues together
- Estimate fix effort (High/Medium/Low)
- Recommend fix order based on impact and dependencies

## Report Structure Template

```markdown
# Codebase Audit Report

## Executive Summary
- 🔴 Critical: X
- 🟠 High: Y
- 🟡 Medium: Z
- 🟢 Low: W

## [Category] Findings

### [Severity]: [Issue Title]
**Location:** `file/path.ext:line`
**Severity:** [Critical/High/Medium/Low]

**Description:** [What the issue is]

**Vulnerable Code:**
```[language]
[code snippet]
```

**Remediation:**
```[language]
[secure code]
```

**Priority:** [Immediate/This Sprint/Next Sprint/Backlog]
```

## Usage Instructions

1. Collect findings from all completed agents
2. Deduplicate similar issues across agents
3. Sort by severity and category
4. Apply report template structure
5. Include code examples from findings
6. Add remediation recommendations
7. Generate priority rankings
8. Output in requested format

## Available Templates

See `templates/audit-report.md` for the full report structure template.
