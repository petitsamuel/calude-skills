# Bug Fix Template

## Structure

```markdown
# Bug Fix: {{bug_description}}

## Context
**Bug Report:** {{bug_report}}
**Affected Users:** {{user_impact}}
**Environment:** {{environment}}
**First Observed:** {{date}}

## Reproduction Steps
1. {{step_1}}
2. {{step_2}}
3. {{step_3}}

**Expected Behavior:** {{expected}}
**Actual Behavior:** {{actual}}

## Root Cause Analysis
**Investigation:**
{{investigation_process}}

**Root Cause:**
{{root_cause}}

**Why It Happened:**
{{why}}

## Goals
- Fix the bug completely
- Prevent regression
- Add test coverage
- No new bugs introduced

## Requirements
- Bug must be reproducible via test
- Fix must be minimal and targeted
- All existing tests must still pass
- New tests added to prevent regression

## TDD Implementation Approach
1. **Write Failing Test**
   - Create test that reproduces the bug
   - Verify test fails (proves bug exists)

2. **Implement Minimal Fix**
   - Make smallest change to pass test
   - No extra refactoring yet

3. **Verify Fix**
   - Run new test (should pass)
   - Run all tests (no regressions)

4. **Add Edge Case Tests**
   - Test boundary conditions
   - Test related scenarios

5. **Refactor (Optional)**
   - Clean up if needed
   - Only if tests remain passing

## Implementation Tasks
1. Write test that reproduces bug
2. Verify test fails
3. Analyze failure
4. Implement minimal fix
5. Verify test passes
6. Run full test suite
7. Add edge case tests
8. Update documentation if needed

## Acceptance Criteria
- [ ] Bug reproduced by test
- [ ] Test passes after fix
- [ ] All existing tests pass
- [ ] No regressions detected
- [ ] Edge cases covered
- [ ] Root cause documented
- [ ] Prevention strategy noted

## Validation Checks
```bash
{{test_command}}
{{coverage_command}}
```

## Completion Conditions
When ALL true:
- New test passes
- All tests pass
- No regressions
- Coverage maintained or improved
- Git status clean

Output: <promise>BUG_FIXED</promise>

## Regression Prevention
How to prevent this bug from happening again:
{{prevention_strategy}}

Changes to make:
- Code review checklist items
- Additional validation
- Better error handling
- Improved tests
```
