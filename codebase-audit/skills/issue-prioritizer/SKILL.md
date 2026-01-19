---
name: issue-prioritizer
description: Prioritizes audit findings based on severity, impact, and effort
---

# Issue Prioritizer Skill

Intelligently prioritizes audit findings to help teams focus on what matters most.

## What This Skill Does

Analyzes all audit findings and ranks them by considering multiple factors:
- Severity level (Critical/High/Medium/Low)
- Business impact (data loss, downtime, security breach)
- Exploitability (for security issues)
- Estimated fix effort (High/Medium/Low)
- Dependencies between issues
- User impact

## Prioritization Algorithm

### Factor Weights

1. **Severity** (40% weight)
   - Critical: 10 points
   - High: 7 points
   - Medium: 4 points
   - Low: 2 points

2. **Exploitability** (30% weight - security issues only)
   - Actively exploited: 10 points
   - Easy to exploit: 7 points
   - Requires specific conditions: 4 points
   - Theoretical: 2 points

3. **Business Impact** (20% weight)
   - Data loss/corruption: 10 points
   - Service downtime: 8 points
   - User experience degradation: 5 points
   - Minor inconvenience: 2 points

4. **Fix Effort** (10% weight - inverse)
   - Low effort: 10 points (quick wins)
   - Medium effort: 5 points
   - High effort: 2 points

### Priority Categories

**Immediate** (Score 8-10)
- Fix within 24-48 hours
- Typically Critical severity with high exploitability
- Example: Actively exploited SQL injection

**This Sprint** (Score 6-7)
- Fix within current sprint/iteration
- High severity or Medium with easy fixes
- Example: Missing input validation on user forms

**Next Sprint** (Score 4-5)
- Plan for next sprint
- Medium severity or Low severity with high impact
- Example: Code duplication across modules

**Backlog** (Score 1-3)
- Track as technical debt
- Low severity, low impact, or premature optimization
- Example: Minor naming convention inconsistencies

## Output Format

For each finding, provides:
```
Issue: [Title]
Priority: [Immediate/This Sprint/Next Sprint/Backlog]
Score: X.X/10
Reasoning:
  - Severity: [Level] (X points)
  - Exploitability: [Level] (X points)
  - Impact: [Description] (X points)
  - Effort: [Level] (X points)
Fix Order: #X (in overall priority list)
Dependencies: [List of blocking/blocked issues]
```

## Special Cases

### Issue Dependencies
If Issue B depends on Issue A being fixed first:
- Issue A gets priority boost
- Issue B marked as blocked
- Fix order explicitly stated

### Duplicate Issues
When multiple agents find similar issues:
- Consolidate into single finding
- Use highest severity reported
- Aggregate all locations
- Combine remediation recommendations

### Quick Wins
Low-effort, medium-impact issues get priority boost:
- Easy fixes that improve security/quality
- Examples: Adding input validation, fixing config

## When To Use

Invoked by audit-orchestrator during result aggregation phase, before report generation.
