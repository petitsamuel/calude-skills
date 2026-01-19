# Refactoring Template

## Structure

```markdown
# Refactoring: {{module_name}}

## Context
**Current State:**
{{current_state}}

**Problems:**
{{problems_list}}

**Goals:**
{{improvement_goals}}

## Goals
- Improve {{quality_aspect}} without breaking functionality
- Maintain API compatibility
- All tests must pass throughout
- Incremental, safe changes

## Constraints
**Must NOT Change:**
- Public API signatures
- External behavior
- Data formats
- Configuration

**Must Maintain:**
- All tests passing
- Performance characteristics
- Security properties

## Current vs Target Architecture
**Current:**
{{current_architecture}}

**Target:**
{{target_architecture}}

**Why Better:**
{{benefits}}

## Incremental Refactoring Steps
{{#each steps}}
{{@index}}. {{this.step}}
   - Change: {{this.change}}
   - Validation: {{this.validation}}
   - Rollback if: {{this.rollback_condition}}
{{/each}}

## Safety Protocol
After EACH step:
1. Run all tests
2. If tests fail → rollback that step
3. If tests pass → commit
4. Proceed to next step

Never proceed with failing tests!

## Implementation Tasks
1. Establish baseline (all tests passing)
2. {{task_1}}
   - Make change
   - Run tests
   - Commit if passing
3. {{task_2}}
   - Make change
   - Run tests
   - Commit if passing
4. Continue incrementally...

## Acceptance Criteria
- [ ] All refactoring steps completed
- [ ] All tests still passing
- [ ] API compatibility maintained
- [ ] Performance not degraded
- [ ] Code quality improved
- [ ] Documentation updated

## Validation Checks
Run after EVERY step:
```bash
{{test_command}}
{{build_command}}
{{lint_command}}
```

## Completion Conditions
When ALL true:
- Target architecture achieved
- All tests passing
- No behavior changes
- Code quality metrics improved
- Git commits show incremental progress

Output: <promise>REFACTOR_COMPLETE</promise>

## Rollback Plan
If any step causes issues:
```bash
git revert HEAD  # Undo last commit
```

Or reset to last known good state:
```bash
git reset --hard {{baseline_commit}}
```

## Quality Metrics
**Before Refactoring:**
- Complexity: {{before_complexity}}
- Duplication: {{before_duplication}}
- Test Coverage: {{before_coverage}}

**Target After Refactoring:**
- Complexity: {{target_complexity}}
- Duplication: {{target_duplication}}
- Test Coverage: {{target_coverage}} (maintain or improve)
```
