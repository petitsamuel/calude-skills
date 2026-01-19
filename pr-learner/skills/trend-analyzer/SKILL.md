# Trend Analyzer Skill

Analyzes pattern trends over time to identify emerging issues and improvements.

## Purpose

Tracks pattern frequency over time to:
- Identify worsening problems (increasing trend)
- Validate improvement effectiveness (decreasing trend)
- Prioritize urgent issues
- Celebrate wins

## Trend Detection

### Simple Trend
Compare first half vs second half of analysis period:

```
trend = (recent_rate - early_rate) / early_rate
```

Examples:
- Early: 2/5 PRs (40%), Recent: 4/5 PRs (80%): +100% (increasing)
- Early: 5/5 PRs (100%), Recent: 2/5 PRs (40%): -60% (decreasing)

### Trend Categories

- **Strongly Increasing**: >50% increase → Urgent
- **Increasing**: 10-50% increase → Growing problem
- **Stable**: -10% to +10% → Steady state
- **Decreasing**: -50% to -10% → Improving
- **Strongly Decreasing**: <-50% decrease → Major improvement

## Timeline Analysis

### Weekly Buckets
```json
{
  "pattern_id": "missing_tests",
  "timeline": [
    {"week": "2026-W01", "count": 1, "total_prs": 3},
    {"week": "2026-W02", "count": 3, "total_prs": 4},
    {"week": "2026-W03", "count": 5, "total_prs": 5}
  ],
  "trend": "strongly_increasing",
  "rate_change": "+200%",
  "urgency": "high"
}
```

### Monthly Buckets (for longer analysis)
```json
{
  "pattern_id": "import_path_issues",
  "timeline": [
    {"month": "2025-12", "count": 2, "total_prs": 8},
    {"month": "2026-01", "count": 6, "total_prs": 12}
  ],
  "trend": "increasing"
}
```

## Correlation Analysis

### Pattern Correlation Over Time
Track if patterns appear together:

```
correlation = cooccurrence_count / max(pattern1_count, pattern2_count)
```

Example:
```json
{
  "pattern1": "missing_tests",
  "pattern2": "long_review_cycle",
  "correlation": 0.82,
  "insight": "PRs without tests take 2× longer to review",
  "timeline": [
    {"week": "2026-W01", "correlation": 0.75},
    {"week": "2026-W02", "correlation": 0.85},
    {"week": "2026-W03", "correlation": 0.87}
  ],
  "trend": "strengthening"
}
```

## Solution Effectiveness

Track pattern frequency before/after solution applied:

```json
{
  "pattern_id": "import_path_issues",
  "solution_applied": "2026-01-10",
  "before": {
    "period": "2025-12-01 to 2026-01-09",
    "occurrences": 8,
    "rate": 0.67
  },
  "after": {
    "period": "2026-01-10 to 2026-01-20",
    "occurrences": 1,
    "rate": 0.10
  },
  "improvement": "85% reduction",
  "effectiveness": "high"
}
```

## Forecasting

### Simple Projection
Project pattern frequency 1 month ahead:

```
projected = current_rate + (trend_slope × time_periods)
```

Example:
- Current: 60% of PRs
- Trend: +10% per week
- 4 weeks ahead: 60% + (10% × 4) = 100% (all PRs will have issue)

### Alert Thresholds
```
if projected_rate > 0.8:
  urgency = "critical"  # 80%+ of PRs will be affected
elif projected_rate > 0.5:
  urgency = "high"      # 50%+ of PRs will be affected
else:
  urgency = "medium"
```

## Visualization (Text-Based)

### Trend Graph
```
Pattern: missing_tests

Week 01: ██░░░ 40% (2/5 PRs)
Week 02: ████░ 80% (4/5 PRs)
Week 03: █████ 100% (5/5 PRs)

Trend: ↗ Strongly Increasing (+150%)
Urgency: CRITICAL
Action: Immediate intervention needed
```

### Improvement Graph
```
Pattern: import_path_issues
Solution: Added ESLint rule (2026-01-10)

Before: ██████░░ 75% (6/8 PRs)
After:  █░░░░░░░ 10% (1/10 PRs)

Improvement: ↘ 87% reduction
Status: ✓ Solution effective
```

## Metrics Dashboard

Summary of all patterns:

```
📈 Pattern Trends (last 30 days)

🔴 CRITICAL (Increasing rapidly)
  1. missing_tests: 40% → 100% (+150%)
  2. scope_creep: 20% → 60% (+200%)

🟡 WARNING (Increasing)
  3. error_handling: 50% → 65% (+30%)

🟢 IMPROVING (Decreasing)
  4. import_paths: 75% → 10% (-87%) ✓ Solution working
  5. console_logs: 40% → 15% (-63%) ✓ Linter added

⚪ STABLE
  6. test_structure: 30% → 28% (stable)
  7. type_safety: 15% → 18% (stable)
```

## Historical Comparison

Compare current vs previous periods:

```
This Month vs Last Month:
  New patterns: 2
  Resolved patterns: 1
  Worsening patterns: 3
  Improving patterns: 2
  Stable patterns: 4

Overall trend: Declining quality (3 worsening)
Recommendation: Focus on test requirements
```

## Seasonality Detection

Identify periodic patterns:

```
Pattern: build_failures

Q4 2025: 12% of PRs
Q1 2026: 45% of PRs

Potential cause: Year-end code freeze led to
accumulated technical debt released in Q1

Recommendation: Plan Q2 quality sprint
```

## Templates

See `templates/` for:
- `trend-report.md`
- `timeline-visualization.txt`
- `forecast-calculation.js`

## Examples

See `examples/` for:
- `increasing-trend.yaml`
- `decreasing-trend.yaml`
- `solution-effectiveness.yaml`
- `correlation-analysis.yaml`
