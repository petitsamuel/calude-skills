# PR Learner Plugin

Analyzes recent pull requests to identify patterns and suggest improvements to skills, CLAUDE.md, commands, and workflows.

## Overview

This plugin learns from your team's PR history to automatically suggest:
- **CLAUDE.md updates**: Document patterns and conventions
- **New agent skills**: Automate repetitive validations and fixes
- **New commands**: Streamline common workflows
- **Process improvements**: Optimize development practices

## Features

- **Pattern Detection**: AI-based semantic clustering identifies recurring issues
- **Impact Scoring**: Prioritizes suggestions by frequency, severity, and ROI
- **Trend Analysis**: Tracks pattern evolution over time
- **Solution Validation**: Measures effectiveness of applied improvements
- **GitHub Integration**: Seamless PR data fetching via `gh` CLI
- **Multiple Output Modes**: Summary, detailed, or actionable formats

## Command

### `/pr-learn`

Analyze recent merged PRs and generate improvement suggestions.

```bash
/pr-learn
/pr-learn --days 14 --count 20
/pr-learn --output detailed
```

**Options:**
- `--days <n>`: Analyze PRs from last N days (default: 7)
- `--count <n>`: Maximum PRs to analyze (default: 10)
- `--output <level>`: Output detail level
  - `summary`: High-level findings (default)
  - `detailed`: Full analysis with examples
  - `actionable`: Only ready-to-implement suggestions

## What Gets Analyzed

### PR Comments
- Review feedback patterns
- Common correction requests
- Frequently amended sections
- Reviewer concerns

### Code Changes
- Refactoring patterns
- Bug fix types
- Import corrections
- Test additions
- Type fixes

### Workflow Signals
- Long review cycles (>5 days)
- Scope creep (files added mid-review)
- Frequent amendments (fix commits)
- Build/test failures
- Unclear requirements

## Suggestions Generated

### 1. CLAUDE.md Updates
Adds missing conventions and guidelines:

```markdown
## Import Paths
Always use absolute imports with @/ alias:

✅ Good: import { User } from '@/models/User'
❌ Bad: import { User } from '../../../models/User'
```

### 2. New Agent Skills
Automates repetitive tasks:

```
Skill: error-handler-validator
Purpose: Validates async functions have try-catch
ROI: 0.95 (8 PRs affected, saves 120 min)
Usage: /validate-error-handling src/
```

### 3. New Commands
Streamlines workflows:

```
Command: /validate-pr
Purpose: Run all PR validation checks
Usage: /validate-pr --fix
Benefit: Saves 3-5 min per validation
```

### 4. Workflow Improvements
Optimizes processes:

```
Issue: 5 PRs had scope creep
Root Cause: No design phase
Solution: Use /ralph-task-design for features
Impact: Reduce scope changes by 60%
```

## Usage Example

```bash
# Analyze last week's PRs
/pr-learn

# Output:
# 🔍 PR Analysis Results (10 PRs from last 7 days)
#
# 📊 Key Findings:
# 1. Import paths corrected in 6 PRs
# 2. Error handling added in 8 PRs
# 3. Tests missing initially in 6 PRs
#
# 💡 Suggested Improvements:
# ✓ CLAUDE.md: Add import path conventions
# ✓ New Skill: error-handler-validator
# ✓ Command: /validate-pr
# ✓ Workflow: Use /ralph-task-design for features

# Get detailed analysis
/pr-learn --output detailed

# Quick actionable list
/pr-learn --output actionable
```

## Agents

### pr-analysis-orchestrator
Coordinates the analysis workflow, fetches PR data, and aggregates findings.

### pr-reader
Extracts structured data from raw PR content (comments, diff, commits).

### pattern-detector
Identifies recurring patterns using semantic clustering and impact scoring.

### claude-md-suggester
Generates specific, copy-paste ready additions to CLAUDE.md files.

### skill-optimizer
Proposes new agent skills to automate repetitive tasks found in PRs.

### command-ideator
Suggests new commands for common workflows discovered in PR analysis.

### workflow-advisor
Recommends process improvements based on PR patterns and correlations.

## Skills

### pattern-library
Comprehensive catalog of common PR patterns, anti-patterns, and resolutions.

### suggestion-formatter
Formats analysis output for optimal readability and actionability.

### github-integration
Handles all GitHub API interactions for PR data collection via `gh` CLI.

### impact-scorer
Calculates impact scores for patterns to prioritize improvements objectively.

### trend-analyzer
Analyzes pattern trends over time to identify emerging issues and improvements.

## Installation

### Option 1: Install from Repository

```bash
# Clone the repository
git clone https://github.com/petitsamuel/calude-skills.git ~/.claude/plugins/claude-plugins

# Add to your Claude Code settings (~/.claude/settings.json)
{
  "plugins": [
    "~/.claude/plugins/claude-plugins/pr-learner"
  ]
}
```

### Option 2: Symlink Installation

```bash
# Clone anywhere
git clone https://github.com/petitsamuel/calude-skills.git ~/dev/claude-plugins

# Create symlink
ln -s ~/dev/claude-plugins/pr-learner ~/.claude/plugins/pr-learner

# Add to settings
{
  "plugins": [
    "~/.claude/plugins/pr-learner"
  ]
}
```

### Verify Installation

```bash
# Check if the plugin is loaded
claude --help | grep pr-learn

# Verify GitHub CLI is installed
gh --version
```

## Requirements

### GitHub CLI
```bash
# Install gh CLI
brew install gh  # macOS
# or see: https://cli.github.com/

# Authenticate
gh auth login

# Verify
gh pr list --limit 1
```

### Repository Access
- Must have read access to repository
- Must be run from within a git repository
- Requires merged PRs in the analysis period

## Output Modes

### Summary Mode (Default)
Quick overview for daily/weekly checks:

```
🔍 PR Analysis Results (10 PRs from last 7 days)

📊 Key Findings:
1. [Pattern]: 6 PRs required import path corrections
2. [Pattern]: 8 PRs had missing error handling
3. [Pattern]: 6 PRs missing tests initially

💡 Suggested Improvements:
✓ CLAUDE.md: Add import path conventions
✓ New Skill: error-handler-validator
✓ Command: /validate-pr
✓ Workflow: Emphasize TDD in task templates

📈 Impact Summary:
- Estimated time savings: 4.2 hours/month
- Review iterations reduced: 35%
- Quality improvements: 3 critical areas

Use --output detailed for full analysis
```

### Detailed Mode
Comprehensive analysis for deep dives:

```markdown
# PR Learning Analysis Report

## PRs Analyzed
- PR #123: Fix auth bug (https://...)
- PR #145: Add user dashboard (https://...)
[...]

## Patterns Detected

### 1. Import Path Conventions (Impact: 0.69)
**Frequency:** 6 of 10 PRs (60%)
**Description:** Relative imports frequently corrected to absolute

**Examples:**
- PR #123: 3 files changed
  - auth.ts: `../../../models/User` → `@/models/User`
- PR #145: 2 files changed
  [...]

**Root Cause:** Missing import convention documentation

**Suggested Solutions:**
1. Add to CLAUDE.md:
   [Full markdown snippet]

2. Add ESLint rule:
   [Configuration]

3. Create skill: /fix-imports

**Expected Impact:** 87% reduction in import corrections

[... more patterns ...]

## Suggested Improvements

### CLAUDE.md Updates
[Full sections ready to copy-paste]

### New Skills
[Complete specifications]

### New Commands
[Full implementations]

### Workflow Changes
[Detailed recommendations]

## Metrics & Trends
[Timeline analysis, correlations, forecasts]
```

### Actionable Mode
Just the action items:

```
Immediate Actions:

CLAUDE.md Updates:
1. Add import path conventions (affects 6 PRs)
2. Document error handling standards (affects 8 PRs)
3. Define test coverage requirements (affects 6 PRs)

New Skills to Implement:
1. /validate-error-handling (ROI: 0.95)
2. /fix-imports (ROI: 0.87)

New Commands to Create:
1. /validate-pr (saves 3-5 min per use)
2. /validate-coverage (prevents coverage debates)

Workflow Changes:
1. Use /ralph-task-design for all features
2. Add "How to Test" section to PR template
3. Enforce tests before code review

Apply with:
1. Edit CLAUDE.md files
2. Run /ralph-task-design for new skills
3. Update PR template in .github/
```

## Workflow Integration

### 1. Regular Analysis
```bash
# Weekly check
/pr-learn --days 7

# Monthly deep dive
/pr-learn --days 30 --count 50 --output detailed
```

### 2. Apply Suggestions
```bash
# Update CLAUDE.md with suggestions
# (manual copy-paste from output)

# Create new skill via prompt-automation
/ralph-task-design "Implement error-handler-validator skill"

# Validate improvement
/pr-learn --days 7  # Run again after 1 week
```

### 3. Track Effectiveness
```bash
# Compare before/after
/pr-learn --days 30 --output detailed

# Look for trend changes in report:
# "Pattern: missing_tests"
# "Trend: Decreasing (-65%)" ✓
```

## Best Practices

### 1. Run Regularly
- Weekly: Catch emerging patterns early
- Monthly: Deep analysis and trend validation
- After major changes: Measure impact

### 2. Prioritize by Impact
- Start with high-impact patterns (score >0.7)
- Focus on patterns affecting >5 PRs
- Address security issues immediately

### 3. Measure Effectiveness
- Run before applying suggestions (baseline)
- Apply improvements incrementally
- Run after to validate (compare trends)

### 4. Iterate
- Not all suggestions will work
- Track what helps, discard what doesn't
- Refine based on results

### 5. Share Learnings
- Review findings with team
- Discuss workflow changes
- Update conventions collaboratively

## Troubleshooting

### No PRs Found
```bash
# Check for merged PRs
gh pr list --state merged --limit 10

# Extend time window
/pr-learn --days 30

# Check if in git repo
git status
```

### GitHub CLI Issues
```bash
# Verify installation
gh --version

# Re-authenticate
gh auth logout
gh auth login

# Check permissions
gh pr list --limit 1
```

### Low Confidence Scores
```
Pattern confidence: 40% (only 4 PRs analyzed)

Solution: Analyze more PRs for better patterns:
/pr-learn --days 30 --count 50
```

## Examples

See skills for detailed examples:
- `pattern-library/examples/import-path-conventions.yaml`
- `impact-scorer/examples/high-priority-pattern.yaml`
- `trend-analyzer/examples/increasing-trend.yaml`

## Integration with Other Plugins

### codebase-audit
Use audit findings to validate PR learner suggestions:
```bash
/pr-learn  # Suggests: add error handling to CLAUDE.md
/audit-security  # Validates: confirms error handling gaps
```

### prompt-automation
Implement suggested skills:
```bash
/pr-learn  # Suggests: create /validate-error-handling
/ralph-task-design "Implement error-handler-validator skill"
```

## Metrics to Track

Create a dashboard tracking:

```
PR Health Metrics:

Lead Time: Days from PR open to merge
  Current: 6.5 days
  Target: <3 days

Review Efficiency: Rounds per PR
  Current: 3.2 rounds
  Target: <2 rounds

Quality: CI failure rate
  Current: 28%
  Target: <5%

Scope Management: File delta during review
  Current: +18%
  Target: <10%

Testing: Coverage at initial submission
  Current: 62%
  Target: >80%
```

## License

MIT
