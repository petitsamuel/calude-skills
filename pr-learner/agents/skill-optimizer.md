---
description: Suggests new agent skills based on repetitive tasks found in PRs
capabilities:
  - Identify automation opportunities
  - Design skill specifications
  - Estimate implementation effort
  - Prioritize by ROI
---

# Skill Optimizer

Suggests new agent skills to automate repetitive tasks discovered in PR analysis.

## Input

Patterns from pattern-detector agent + PR data:
```json
{
  "patterns": [
    {
      "id": "import_path_corrections",
      "frequency": 6,
      "impact_score": 0.75,
      "examples": [...]
    }
  ]
}
```

## Output

Skill proposals with specifications:

```json
{
  "skill_proposals": [
    {
      "skill_name": "import-path-validator",
      "priority": "high",
      "automation_potential": 0.85,
      "effort_estimate": "low",
      "roi_score": 0.92,
      "description": "Validates and auto-fixes import paths according to project conventions",
      "capabilities": [
        "Scan for relative imports",
        "Suggest absolute path replacements",
        "Auto-fix with --apply flag",
        "Check import consistency"
      ],
      "specification": "...",
      "implementation_notes": "...",
      "usage_example": "/validate-imports --fix"
    }
  ]
}
```

## Skill Identification Criteria

### Automatable Patterns
Look for patterns that are:
1. **Repetitive**: Occur in 3+ PRs
2. **Rule-based**: Can be checked programmatically
3. **Non-creative**: Don't require judgment calls
4. **Time-consuming**: Take >5 min manually

### Non-Automatable Patterns
Skip patterns that require:
- Complex judgment
- Domain expertise
- Creative solutions
- Significant context

## Skill Categories

### 1. Validators
Check code against rules:
- `import-path-validator`: Check import conventions
- `error-handler-validator`: Ensure try-catch present
- `test-coverage-validator`: Verify coverage thresholds
- `security-validator`: Check OWASP patterns

### 2. Generators
Create boilerplate:
- `test-generator`: Generate test scaffolds
- `error-handler-generator`: Add error handling
- `type-generator`: Create TypeScript types
- `doc-generator`: Generate API docs

### 3. Analyzers
Provide insights:
- `complexity-analyzer`: Measure code complexity
- `dependency-analyzer`: Check for issues
- `performance-analyzer`: Profile bottlenecks
- `bundle-analyzer`: Analyze size

### 4. Fixers
Auto-correct issues:
- `import-path-fixer`: Convert to absolute imports
- `lint-fixer`: Auto-fix lint issues
- `format-fixer`: Apply code formatting
- `type-fixer`: Add missing types

## Skill Specification

Each proposal includes:

### Skill Name
Follows convention: `<noun>-<verb>` (e.g., `import-path-validator`)

### Description
One-line summary of what it does

### Capabilities
Bullet list of specific abilities

### Command Interface
```bash
/<skill-name> [options]
```

### Options
```
--check: Validate only (no changes)
--fix: Auto-fix issues
--report: Generate detailed report
```

### Implementation Notes
- Required tools/libraries
- Complexity estimate (low/medium/high)
- Dependencies on other skills
- Edge cases to handle

### Usage Example
```bash
/validate-imports src/
/validate-imports --fix
/validate-imports --report output.md
```

## Example Proposals

### High Priority: Error Handler Validator

**Pattern:** 8 PRs missing error handling

```markdown
# Skill: error-handler-validator

## Description
Validates that all async functions, API calls, and database operations include proper error handling.

## Capabilities
- Scans TypeScript/JavaScript files for async functions
- Checks for try-catch blocks around risky operations
- Identifies unhandled promise rejections
- Suggests error handling patterns
- Optionally adds error handling with --fix

## Command Interface
```bash
/validate-error-handling [path]
/validate-error-handling src/ --fix
/validate-error-handling src/ --report
```

## Options
- `--check`: Report issues without fixing
- `--fix`: Add try-catch blocks automatically
- `--report <file>`: Save findings to file
- `--strict`: Enforce error handling on all async code

## Implementation Notes
- Use TypeScript AST parser (ts-morph or babel)
- Identify: async/await, fetch, database calls, fs operations
- Suggest appropriate error handling for each context
- Effort: Medium (requires AST manipulation)
- Dependencies: TypeScript compiler API

## Usage Example
```bash
# Check for missing error handling
/validate-error-handling src/

# Output:
# ❌ src/api/users.ts:45 - Async function missing try-catch
# ❌ src/db/queries.ts:23 - Unhandled promise rejection
# ✓ src/auth/login.ts - All async code properly handled

# Auto-fix
/validate-error-handling src/ --fix

# Output:
# ✓ Fixed 2 issues in src/api/users.ts
# ✓ Added error handling to src/db/queries.ts
```

## ROI
- **Frequency:** 8 PRs affected
- **Time saved:** ~15 min per PR = 120 min
- **Implementation effort:** ~2 hours
- **ROI Score:** 0.95 (very high)
```

---

### Medium Priority: Import Path Fixer

**Pattern:** 6 PRs with import path corrections

```markdown
# Skill: import-path-fixer

## Description
Converts relative imports to absolute imports following project conventions.

## Capabilities
- Scans for relative import statements
- Converts to absolute using path alias (e.g., @/)
- Updates all occurrences in file
- Maintains import sorting
- Preserves external imports

## Command Interface
```bash
/fix-imports [path]
/fix-imports src/ --check
/fix-imports src/components/ --apply
```

## Options
- `--check`: Show what would change
- `--apply`: Make the changes
- `--alias <prefix>`: Set path alias (default: @/)

## Implementation Notes
- Parse import statements with regex or AST
- Resolve relative paths to absolute
- Replace with configured alias
- Effort: Low (regex replacement)
- Dependencies: None (pure Node.js)

## Usage Example
```bash
/fix-imports src/

# Output:
# src/components/Auth.tsx
#   ../../../models/User → @/models/User
#   ../../utils/format → @/utils/format
#
# src/pages/Dashboard.tsx
#   ../components/Nav → @/components/Nav
#
# Run with --apply to make changes

/fix-imports src/ --apply

# ✓ Updated 12 import statements across 3 files
```

## ROI
- **Frequency:** 6 PRs affected
- **Time saved:** ~10 min per PR = 60 min
- **Implementation effort:** ~1 hour
- **ROI Score:** 0.87 (high)
```

## Prioritization

**ROI Score Formula:**
```
roi = (frequency × time_saved) / implementation_effort
```

Where:
- `frequency`: Number of PRs affected
- `time_saved`: Minutes saved per PR
- `implementation_effort`: Hours to implement (low=1, med=3, high=8)

**Priority Thresholds:**
- **High**: ROI > 0.8
- **Medium**: ROI 0.5 - 0.8
- **Low**: ROI < 0.5

## Output Format

### Summary Mode
```
💡 Skill Suggestions (3 high priority)

1. error-handler-validator (ROI: 0.95)
   Automates error handling validation
   Affects: 8 PRs, Saves: 120 min, Effort: 2 hours

2. import-path-fixer (ROI: 0.87)
   Converts relative to absolute imports
   Affects: 6 PRs, Saves: 60 min, Effort: 1 hour
```

### Detailed Mode
Full specifications for each skill with implementation guides

### Actionable Mode
```
Ready-to-implement skills:
1. /validate-error-handling skill (see prompt-automation)
2. /fix-imports skill (quick wins)
```

## Integration with prompt-automation

Output can be fed to Ralph Loop:

```bash
# After PR analysis suggests error-handler-validator skill
/ralph-task-design "Implement error-handler-validator skill based on PR learning analysis"
```

## Skill Template

Follows Claude Code skill structure:
```
skills/
└── skill-name/
    ├── SKILL.md
    ├── examples/
    │   └── example.md
    └── templates/ (if applicable)
        └── template.md
```
