# Impact Scorer Skill

Calculates impact scores for patterns to prioritize improvements.

## Purpose

Provides objective scoring to rank patterns by potential value, enabling data-driven prioritization.

## Scoring Formula

```
impact_score = (frequency × 0.4) +
               (severity × 0.3) +
               (fix_cost × 0.2) +
               (trend × 0.1)
```

Range: 0.0 (no impact) to 1.0 (critical impact)

## Scoring Components

### 1. Frequency Score (40% weight)

Based on how often the pattern occurs:

```
frequency_score = min(1.0, occurrences / total_prs)
```

Examples:
- 1 of 10 PRs: 0.10
- 5 of 10 PRs: 0.50
- 10 of 10 PRs: 1.00

### 2. Severity Score (30% weight)

Based on impact category:

- **Critical (1.0)**: Security, data loss, production outage
- **High (0.75)**: Broken functionality, major bugs
- **Medium (0.5)**: Code quality, performance issues
- **Low (0.25)**: Style, minor issues

### 3. Fix Cost Score (20% weight)

Lower cost = higher score (easier to fix = more valuable):

- **Quick fix (0.2)**: Documentation update, config change
- **Medium fix (0.1)**: New skill, tooling setup
- **Complex fix (0.0)**: Major refactor, architecture change

### 4. Trend Score (10% weight)

Based on occurrence trajectory:

- **Increasing (+0.1)**: Getting worse, urgent
- **Stable (0.0)**: Constant rate
- **Decreasing (-0.1)**: Improving, lower priority

## Priority Bands

### High Priority (0.7 - 1.0)
- Address immediately
- Clear ROI
- Significant impact

### Medium Priority (0.4 - 0.69)
- Address soon
- Moderate ROI
- Worthwhile improvement

### Low Priority (0.0 - 0.39)
- Address if time permits
- Low ROI
- Nice-to-have

## Example Calculations

### Example 1: Missing Error Handling

```
Occurrences: 8 of 10 PRs
Severity: High (functionality impact)
Fix Cost: Medium (new skill + docs)
Trend: Stable

Calculation:
frequency = 8/10 = 0.80
severity = 0.75
fix_cost = 0.10
trend = 0.00

impact = (0.80 × 0.4) + (0.75 × 0.3) + (0.10 × 0.2) + (0.00 × 0.1)
       = 0.32 + 0.225 + 0.02 + 0.0
       = 0.565

Priority: Medium
```

### Example 2: Import Path Conventions

```
Occurrences: 6 of 10 PRs
Severity: Medium (quality issue)
Fix Cost: Quick (docs + ESLint rule)
Trend: Increasing

Calculation:
frequency = 6/10 = 0.60
severity = 0.50
fix_cost = 0.20
trend = 0.10

impact = (0.60 × 0.4) + (0.50 × 0.3) + (0.20 × 0.2) + (0.10 × 0.1)
       = 0.24 + 0.15 + 0.04 + 0.01
       = 0.44

Priority: Medium
```

### Example 3: Security Vulnerability

```
Occurrences: 2 of 10 PRs
Severity: Critical (security)
Fix Cost: Quick (validation added)
Trend: Stable

Calculation:
frequency = 2/10 = 0.20
severity = 1.00
fix_cost = 0.20
trend = 0.00

impact = (0.20 × 0.4) + (1.00 × 0.3) + (0.20 × 0.2) + (0.00 × 0.1)
       = 0.08 + 0.30 + 0.04 + 0.0
       = 0.42

Priority: Medium (borderline, but severity makes it important)
```

## ROI Calculation

For skill/command proposals:

```
roi = (frequency × time_saved_per_pr) / implementation_effort_hours
```

Examples:
- Pattern in 6 PRs, saves 10 min each, 1 hour to implement: ROI = 60/60 = 1.0
- Pattern in 3 PRs, saves 5 min each, 3 hours to implement: ROI = 15/180 = 0.08

## Scoring Adjustments

### Contextual Multipliers

**Security issues:** Severity × 1.5 (cap at 1.0)
**Production blockers:** Severity × 1.3
**Quick wins:** Fix cost × 2.0

**Team size adjustment:**
```
adjusted_impact = base_impact × (1 + log10(team_size))
```

Small team (5): 1.7× multiplier
Large team (50): 2.7× multiplier

### Confidence Intervals

Score confidence based on data quality:

```
confidence = min(1.0, sample_size / 10)
```

- 10+ PRs: 100% confidence
- 5 PRs: 50% confidence
- 2 PRs: 20% confidence

Output: `impact_score: 0.75 (confidence: 80%)`

## Templates

See `templates/` for scoring calculators:
- `calculate-impact.js`
- `calculate-roi.js`
- `priority-bands.yaml`

## Examples

See `examples/` for scored patterns:
- `high-priority-pattern.yaml`
- `medium-priority-pattern.yaml`
- `low-priority-pattern.yaml`
