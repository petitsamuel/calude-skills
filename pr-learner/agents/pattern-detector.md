---
description: Identifies recurring patterns across multiple PRs using semantic clustering
capabilities:
  - Semantic pattern clustering
  - Frequency analysis
  - Impact scoring
  - Cross-PR correlation
---

# Pattern Detector

Identifies recurring patterns across multiple PRs using AI-based semantic clustering.

## Input

Structured PR data from pr-reader agent:
```json
{
  "prs": [
    {
      "pr_number": 123,
      "feedback_themes": [...],
      "code_change_patterns": [...],
      "workflow_signals": {...}
    }
  ]
}
```

## Output

Ranked patterns with impact scores:
```json
{
  "patterns": [
    {
      "id": "import_path_conventions",
      "category": "code_quality",
      "frequency": 6,
      "severity": "medium",
      "impact_score": 0.75,
      "description": "Import paths frequently corrected from relative to absolute",
      "examples": [
        "PR #123: 3 files",
        "PR #145: 2 files",
        "PR #167: 1 file"
      ],
      "root_cause": "Missing import path convention in docs",
      "suggested_fix": "Add import path standards to CLAUDE.md"
    }
  ],
  "correlations": [
    {
      "pattern_ids": ["missing_tests", "long_review_cycle"],
      "correlation": 0.82,
      "insight": "PRs missing tests take 2x longer to review"
    }
  ]
}
```

## Pattern Categories

### 1. Code Quality Patterns
- Repeated refactoring
- Complexity issues
- Duplication
- Naming inconsistencies
- Type errors

### 2. Testing Patterns
- Missing test coverage
- Edge cases not handled
- Flaky tests
- Test quality issues

### 3. Security Patterns
- Input validation missing
- SQL injection risks
- XSS vulnerabilities
- Authentication issues
- Secret exposure

### 4. Performance Patterns
- N+1 queries
- Memory leaks
- Inefficient algorithms
- Unnecessary re-renders
- Bundle size issues

### 5. Documentation Patterns
- Missing docs
- Unclear comments
- Outdated README
- API docs incomplete

### 6. Workflow Patterns
- Unclear requirements
- Scope creep
- Long review cycles
- Frequent amendments
- Build/test failures

## Semantic Clustering

Uses AI to group similar issues that may have different wording:

**Example:**
- "Use absolute imports" (PR #123)
- "Import from @/" (PR #145)
- "Fix import path" (PR #167)

Clustered as: `import_path_conventions`

**Algorithm:**
1. Extract all feedback items and code changes
2. Generate semantic embeddings for each item
3. Cluster by similarity (threshold: 0.7)
4. Label each cluster with representative description
5. Count frequency across PRs
6. Score impact based on frequency + severity

## Impact Scoring

Impact score (0.0 - 1.0) calculated from:

**Frequency (40%):**
- Number of PRs affected
- Number of files affected
- Number of comments about it

**Severity (30%):**
- Critical: Security, data loss (1.0)
- High: Broken functionality (0.75)
- Medium: Quality, performance (0.5)
- Low: Style, minor (0.25)

**Fix Cost (20%):**
- Low cost (quick doc update): +0.2
- Medium cost (new skill): +0.1
- High cost (major refactor): +0.0

**Trend (10%):**
- Increasing over time: +0.1
- Stable: +0.0
- Decreasing: -0.1

**Formula:**
```
impact = (frequency_score * 0.4) +
         (severity_score * 0.3) +
         (fix_cost_score * 0.2) +
         (trend_score * 0.1)
```

## Pattern Examples

### High Impact Pattern

```json
{
  "id": "missing_error_handling",
  "category": "code_quality",
  "frequency": 8,
  "severity": "high",
  "impact_score": 0.85,
  "description": "API calls often missing try-catch and error handling",
  "examples": [
    "PR #123: Added try-catch to 4 functions",
    "PR #134: Fixed unhandled promise rejection",
    "PR #156: Added error boundaries"
  ],
  "root_cause": "No established error handling pattern",
  "suggested_fix": "Create error-handler-validator skill + add patterns to CLAUDE.md"
}
```

### Medium Impact Pattern

```json
{
  "id": "test_coverage_gaps",
  "category": "testing",
  "frequency": 5,
  "severity": "medium",
  "impact_score": 0.62,
  "description": "Tests added after initial review, coverage initially missed",
  "examples": [
    "PR #145: Added tests for edge cases",
    "PR #167: Increased coverage 60% → 80%"
  ],
  "root_cause": "Tests not part of initial task checklist",
  "suggested_fix": "Update task templates to emphasize TDD approach"
}
```

### Low Impact Pattern

```json
{
  "id": "console_log_cleanup",
  "category": "code_quality",
  "frequency": 3,
  "severity": "low",
  "impact_score": 0.28,
  "description": "Debug console.log statements left in code",
  "examples": [
    "PR #156: Removed 2 console.log",
    "PR #178: Removed debug output"
  ],
  "root_cause": "No pre-commit hook for console cleanup",
  "suggested_fix": "Add eslint rule or pre-commit hook"
}
```

## Cross-PR Correlations

Identifies patterns that appear together:

**Example:**
```json
{
  "pattern_ids": ["missing_tests", "long_review_cycle"],
  "correlation": 0.82,
  "insight": "PRs without initial tests take 2x longer to merge",
  "recommendation": "Emphasize TDD in task templates to reduce review time"
}
```

**Example:**
```json
{
  "pattern_ids": ["scope_creep", "unclear_requirements"],
  "correlation": 0.91,
  "insight": "PRs with scope changes correlate with unclear initial requirements",
  "recommendation": "Improve design phase with more clarifying questions"
}
```

## Trending Analysis

Tracks patterns over time:

```json
{
  "pattern_id": "import_path_conventions",
  "timeline": [
    {"week": "2026-W01", "count": 1},
    {"week": "2026-W02", "count": 3},
    {"week": "2026-W03", "count": 5}
  ],
  "trend": "increasing",
  "urgency": "high"
}
```

## Output Filtering

Based on `--output` flag:

**summary**: Top 10 patterns only
**detailed**: All patterns with full analysis
**actionable**: Only patterns with impact_score > 0.5

## Performance

- Process up to 100 PRs efficiently
- Semantic clustering in <10s
- Incremental processing for large datasets
- Cache embeddings for repeated analysis
