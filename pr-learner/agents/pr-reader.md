---
description: Extracts structured data from PR content (comments, diff, commits)
capabilities:
  - Parse PR comments for patterns
  - Extract code change themes
  - Identify review feedback
  - Detect multi-iteration changes
---

# PR Reader

Extracts structured, machine-readable data from raw PR content.

## Input

Raw PR data from GitHub API:
- PR metadata (title, description, labels)
- Comments (review comments, regular comments)
- Diff (file changes, line changes)
- Commits (messages, changes)

## Output

Structured data for pattern detection:

```json
{
  "pr_number": 123,
  "metadata": {
    "title": "Fix auth bug",
    "iterations": 3,
    "review_cycles": 2,
    "scope_changes": true
  },
  "feedback_themes": [
    {
      "theme": "missing_error_handling",
      "occurrences": 4,
      "examples": [
        "auth.ts:45: needs try-catch",
        "user.ts:23: handle null case"
      ]
    }
  ],
  "code_change_patterns": [
    {
      "pattern": "import_path_fix",
      "files": ["auth.ts", "user.ts"],
      "description": "Changed relative to absolute imports"
    }
  ],
  "commit_patterns": [
    {
      "pattern": "repeated_fix_commits",
      "count": 5,
      "messages": ["fix lint", "fix tests", "fix build"]
    }
  ],
  "workflow_signals": {
    "unclear_requirements": false,
    "missing_tests": true,
    "scope_creep": false,
    "long_review_cycle": true
  }
}
```

## Extraction Rules

### Feedback Themes
Look for:
- Repeated reviewer comments across files
- Similar correction requests
- Common "requested changes" patterns
- Frequently amended sections

Categories:
- Code quality (complexity, duplication)
- Testing (coverage, edge cases)
- Security (validation, injection)
- Performance (N+1, memory leaks)
- Style (naming, formatting)
- Documentation (missing, unclear)

### Code Change Patterns
Identify:
- Refactoring patterns (extract function, rename)
- Bug fix patterns (null check, error handling)
- Import changes (path corrections, additions)
- Test additions (missing coverage)
- Type fixes (TypeScript errors)

### Commit Patterns
Analyze:
- Fix commits after initial PR (`fix lint`, `fix tests`)
- Scope expansion (new files added mid-review)
- Rollbacks or reverts
- Commit message quality

### Workflow Signals

**Unclear Requirements:**
- Multiple scope changes
- Significant rewrites
- "Actually we need..." comments

**Missing Tests:**
- "Add tests" comments
- Test files added after review
- Coverage discussions

**Scope Creep:**
- Files unrelated to PR title
- "While we're here..." changes
- Growing file count over time

**Long Review Cycle:**
- >5 days from open to merge
- >3 review rounds
- Many requested changes

## Examples

### Example 1: Import Path Issues

**Input:**
- Comment: "Use absolute imports from @/"
- Diff: Changed `../../../utils` to `@/utils`
- Occurs in 3 files

**Output:**
```json
{
  "feedback_themes": [{
    "theme": "import_path_conventions",
    "occurrences": 3,
    "examples": [
      "auth.ts:5: ../../../utils → @/utils",
      "user.ts:12: ../../types → @/types"
    ]
  }]
}
```

### Example 2: Missing Error Handling

**Input:**
- Comment: "Needs try-catch here"
- Comment: "What if the API fails?"
- Diff: Added try-catch in 2 functions

**Output:**
```json
{
  "feedback_themes": [{
    "theme": "missing_error_handling",
    "occurrences": 2,
    "examples": [
      "api.ts:34: Added try-catch for fetch",
      "db.ts:67: Added null check"
    ]
  }]
}
```

### Example 3: Scope Creep

**Input:**
- Initial files: `auth.ts`
- Later added: `user.ts`, `db.ts`, `config.ts`
- Comment: "While fixing auth, I also updated..."

**Output:**
```json
{
  "workflow_signals": {
    "scope_creep": true
  },
  "metadata": {
    "scope_changes": true,
    "iterations": 4
  }
}
```

## Processing Logic

1. **Parse Comments**: Extract all review comments and regular comments
2. **Categorize Feedback**: Group by theme using semantic similarity
3. **Analyze Diff**: Identify change patterns (refactor, fix, add)
4. **Examine Commits**: Look for iteration patterns
5. **Compute Signals**: Calculate workflow health indicators
6. **Structure Output**: Format as JSON for downstream agents

## Edge Cases

- **Empty Comments**: Extract patterns from diff only
- **Large PRs**: Sample representative changes, note scale
- **Bot Comments**: Filter out automated comments (Dependabot, CI)
- **Non-English**: Best effort extraction, flag if unclear
- **Merge Conflicts**: Note as workflow signal
