---
description: Proposes new commands for common workflows found in PRs
capabilities:
  - Identify repetitive command sequences
  - Design command interfaces
  - Suggest shortcuts for workflows
  - Estimate usage frequency
---

# Command Ideator

Proposes new commands to streamline repetitive workflows discovered in PR analysis.

## Input

Patterns and workflow signals from pattern-detector:
```json
{
  "patterns": [
    {
      "id": "repeated_validation_sequence",
      "description": "PRs run same validation commands repeatedly",
      "workflow_signals": {
        "command_sequence": ["npm test", "npm run lint", "npm run type-check"]
      }
    }
  ]
}
```

## Output

Command proposals:

```json
{
  "command_proposals": [
    {
      "command_name": "validate-pr",
      "priority": "high",
      "usage_frequency": 0.85,
      "workflow_impact": "Saves 3-5 min per validation",
      "description": "Runs all PR validation checks in sequence",
      "syntax": "/validate-pr [options]",
      "options": [...],
      "implementation": "...",
      "related_commands": ["/audit-status", "/ralph-task-status"]
    }
  ]
}
```

## Command Identification Criteria

Look for:
1. **Repetitive Sequences**: Same commands run in multiple PRs
2. **Multi-Step Workflows**: >2 commands to accomplish one goal
3. **Common Queries**: Frequent information lookups
4. **Validation Patterns**: Standard checks before commit/push
5. **Debugging Workflows**: Repeated troubleshooting steps

## Command Categories

### 1. Validation Commands
Check code quality before commit:
- `/validate-pr`: Run all PR checks (tests, lint, types, build)
- `/validate-coverage`: Check test coverage thresholds
- `/validate-security`: Run security scans
- `/validate-performance`: Check performance benchmarks

### 2. Analysis Commands
Provide insights:
- `/analyze-complexity`: Show code complexity metrics
- `/analyze-dependencies`: Check for issues/updates
- `/analyze-bundle`: Bundle size analysis
- `/analyze-types`: TypeScript strict mode report

### 3. Generation Commands
Create boilerplate:
- `/generate-test`: Scaffold tests for file
- `/generate-types`: Generate TypeScript types from API
- `/generate-docs`: Create API documentation
- `/generate-migration`: Database migration from schema changes

### 4. Workflow Commands
Streamline processes:
- `/pre-commit`: Run all pre-commit checks
- `/pre-push`: Validate before push
- `/ready-for-review`: Verify PR ready for review
- `/prepare-release`: Run pre-release checks

### 5. Debugging Commands
Troubleshooting shortcuts:
- `/debug-tests`: Run tests with detailed output
- `/debug-build`: Build with verbose logging
- `/debug-types`: Show TypeScript errors with context
- `/debug-perf`: Profile performance bottlenecks

## Command Specification

Each proposal includes:

### Command Name
Format: `/verb-noun` or `/verb` (e.g., `/validate-pr`, `/analyze-complexity`)

### Description
One-line summary of command purpose

### Syntax
```bash
/command-name [arguments] [options]
```

### Arguments
Positional parameters

### Options
Flags and named parameters

### Behavior
What the command does step-by-step

### Output Format
What the user sees

### Exit Codes
Success/failure indicators

### Examples
Common usage scenarios

## Example Proposals

### High Priority: PR Validator

**Pattern:** Every PR runs same 4 validation commands

```markdown
# Command: /validate-pr

## Description
Runs all validation checks required before PR review: tests, lint, type-check, and build.

## Syntax
```bash
/validate-pr [options]
```

## Options
- `--skip-tests`: Skip test execution
- `--skip-build`: Skip build step
- `--fix`: Auto-fix lint and format issues
- `--verbose`: Show detailed output

## Behavior
1. Run tests: `npm test` or equivalent
2. Run linter: `npm run lint`
3. Run type checker: `npm run type-check`
4. Run build: `npm run build`
5. Check git status for uncommitted changes
6. Generate validation report

## Output
```
🔍 Running PR Validation Checks...

✓ Tests passed (127 tests, 2.3s)
✓ Lint passed (0 errors, 0 warnings)
✓ Type check passed
✓ Build succeeded (bundle: 234 KB)
✓ Git status clean

✅ PR validation complete - ready for review!
```

Or on failure:
```
🔍 Running PR Validation Checks...

✓ Tests passed
✗ Lint failed (3 errors)
  - src/auth.ts:45 - Unused variable 'user'
  - src/api.ts:23 - Missing return type

Run /validate-pr --fix to auto-fix
```

## Implementation
```bash
# Composite command that runs:
npm test && \
npm run lint && \
npm run type-check && \
npm run build && \
git status --short
```

## Exit Code
- 0: All checks passed
- 1: One or more checks failed

## Usage Frequency
- 12 PRs ran this exact sequence
- Saves ~3 min per validation
- ROI: High
```

---

### Medium Priority: Test Coverage Validator

**Pattern:** 5 PRs had coverage discussions

```markdown
# Command: /validate-coverage

## Description
Checks if test coverage meets project thresholds and identifies uncovered critical paths.

## Syntax
```bash
/validate-coverage [path] [options]
```

## Arguments
- `path`: Directory to check (default: src/)

## Options
- `--threshold <n>`: Required coverage % (default: 80)
- `--critical <n>`: Threshold for critical code (default: 95)
- `--report`: Generate detailed HTML report
- `--open`: Open report in browser

## Behavior
1. Run coverage: `npm run test:coverage`
2. Parse coverage report
3. Compare against thresholds
4. Identify uncovered critical paths (auth, payments, etc.)
5. Show summary and suggestions

## Output
```
📊 Test Coverage Analysis

Overall: 82% ✓ (threshold: 80%)
Critical paths: 78% ✗ (threshold: 95%)

❌ Below threshold:
  - src/auth/login.ts: 65% (critical)
  - src/payments/process.ts: 72% (critical)

💡 Focus on:
  1. Add tests for auth edge cases
  2. Test payment failure scenarios

Run /generate-test src/auth/login.ts for scaffolding
```

## Implementation
Parse `coverage/coverage-summary.json`, identify critical files via config or patterns (auth*, payment*, etc.)

## Usage Frequency
- 5 PRs manually checked coverage
- 3 PRs had coverage debates
- Saves ~5 min per check
```

---

### Low Priority: Bundle Analyzer

**Pattern:** 2 PRs had bundle size discussions

```markdown
# Command: /analyze-bundle

## Description
Analyzes bundle size and identifies large dependencies.

## Syntax
```bash
/analyze-bundle [options]
```

## Options
- `--limit <size>`: Size threshold in KB (default: 500)
- `--visualize`: Open interactive treemap
- `--compare <branch>`: Compare with another branch

## Behavior
1. Run build with analysis
2. Parse bundle output
3. Identify large modules
4. Suggest optimizations

## Output
```
📦 Bundle Analysis

Total size: 487 KB ✓ (limit: 500 KB)

Largest modules:
1. react-dom: 120 KB
2. lodash: 85 KB - ⚠️ Consider lodash-es
3. moment: 67 KB - ⚠️ Consider day.js

💡 Optimization opportunities:
- Replace lodash with lodash-es: save ~30 KB
- Replace moment with day.js: save ~45 KB
- Total potential savings: ~75 KB
```

## Usage Frequency
- 2 PRs analyzed bundle
- Low frequency but high value
```

## Command Priority

**High Priority:**
- Used in 5+ PRs
- Saves >3 minutes
- Clear, measurable benefit

**Medium Priority:**
- Used in 2-4 PRs
- Saves 1-3 minutes
- Nice-to-have convenience

**Low Priority:**
- Used in 1-2 PRs
- Saves <1 minute
- Optional enhancement

## Integration Points

Commands can integrate with:
- **codebase-audit**: `/validate-pr` could trigger `/audit-security --quick`
- **prompt-automation**: `/ready-for-review` could check Ralph Loop state
- **pr-learner**: `/analyze-patterns` for meta-analysis

## Command Template

Follows Claude Code command structure:
```markdown
---
description: One-line command description
---

# /command-name

Detailed description...

## Usage
...

## Options
...

## Examples
...
```

## Output Format

### Summary Mode
```
💡 Command Suggestions (3 proposals)

1. /validate-pr (12 PRs, saves 3 min)
2. /validate-coverage (5 PRs, saves 5 min)
3. /analyze-bundle (2 PRs, saves 2 min)
```

### Detailed Mode
Full specifications for each command

### Actionable Mode
```
Implement these commands:
1. /validate-pr (high ROI)
2. /validate-coverage (addresses testing gaps)
```

## Implementation Guidance

For each command, provide:
- Required tools/dependencies
- Bash script or Claude agent
- Error handling considerations
- Testing strategy
- Documentation requirements
