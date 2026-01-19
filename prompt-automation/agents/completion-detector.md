---
description: Validates task completion through multiple signals
capabilities:
  - Promise marker detection
  - Test execution and validation
  - Build verification
  - Git status checking
  - Acceptance criteria validation
---

# Completion Detector Agent

Determines when tasks are truly complete using multiple validation signals.

## Validation Strategy

### 1. Promise Marker Detection

Checks for completion promise in output:
```
<promise>COMPLETE</promise>
<promise>API_COMPLETE</promise>
<promise>BUG_FIXED</promise>
```

**Requirements:**
- Promise must match exactly
- Must be in recent output
- Indicates intentional completion claim

### 2. Test Validation

Runs test suite and checks results:

**Commands by Project Type:**
```bash
# JavaScript/Node
npm test
npm run coverage

# Python
pytest
pytest --cov

# Ruby
bundle exec rspec
bundle exec rspec --coverage

# Go
go test ./...
go test -cover

# Rust
cargo test
```

**Success Criteria:**
- All tests pass (exit code 0)
- No test failures
- Coverage meets threshold (default 80%)

### 3. Build Verification

Ensures project builds successfully:

```bash
# JavaScript/Node
npm run build
npm run compile

# Python
python -m compileall .

# TypeScript
tsc --noEmit

# Go
go build

# Rust
cargo build
```

**Success Criteria:**
- Build completes (exit code 0)
- No compilation errors
- No type errors

### 4. Git Status Check

Validates all work is committed:

```bash
git status --porcelain
```

**Success Criteria:**
- No uncommitted changes
- No untracked files (or only expected artifacts)
- Clean working directory

### 5. Acceptance Criteria Validation

Parses DESIGN file and checks each criterion:

```markdown
## Acceptance Criteria
- [ ] All CRUD endpoints implemented
- [ ] JWT authentication working
- [ ] Tests passing (>80% coverage)
- [ ] Documentation updated
```

**Validation:**
- Reads each criterion
- Checks if accomplished
- Uses heuristics and file checks
- Reports progress

## Failure Detection

### Infinite Loop Detection

Detects when stuck:
- Same error message 3+ iterations
- No file changes for 2+ iterations
- Test failures not decreasing

**Action:** Report stuck state, suggest next steps

### Premature Completion

Detects false completion:
- Promise marker found BUT
- Tests failing
- Build broken
- Acceptance criteria incomplete

**Action:** Continue loop to fix issues

### Timeout Detection

Max iterations reached:
- Report what was accomplished
- List what remains
- Provide summary

## Validation Flow

```
Promise marker found?
  ↓
Yes → Run all validation checks
  ↓
Tests pass?
  ↓
Yes → Build succeeds?
  ↓
Yes → Git clean?
  ↓
Yes → Acceptance criteria met?
  ↓
Yes → COMPLETE ✅
  ↓
No → Auto-continue loop 🔄
```

## Output Format

```
⏸️  Completion marker detected. Running validation...

Validation Checks:
✓ Tests passing (npm test) - 87% coverage
✓ Build succeeds (npm run build)
✗ Git status - uncommitted changes in 2 files
✓ Acceptance criteria:
  ✓ All CRUD endpoints working
  ✓ JWT authentication working
  ✓ Input validation in place
  ✓ Unit tests passing (>80%)
  ✓ Integration tests passing
  ✗ OpenAPI docs incomplete
  ✗ README not updated

⚠️  Task not fully complete (3 issues remaining)

🔄 Auto-continuing loop to complete remaining work...
```

## Configuration

Default validation can be configured:

```json
{
  "validation": {
    "tests": true,
    "build": true,
    "git-clean": true,
    "lint": false,
    "coverage-threshold": 80
  }
}
```
