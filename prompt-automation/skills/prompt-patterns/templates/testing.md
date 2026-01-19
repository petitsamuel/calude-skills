# Testing Template

```markdown
# Task: Add Tests for {{module_name}}

## Goals
- Achieve {{coverage_target}}% test coverage
- Test all critical paths
- Cover edge cases
- Ensure test quality and maintainability

## Coverage Targets
- Overall: {{overall_target}}%
- Critical code: {{critical_target}}%
- Business logic: {{business_logic_target}}%

## Test Categories
### Unit Tests
{{unit_test_requirements}}

### Integration Tests
{{integration_test_requirements}}

### E2E Tests (if applicable)
{{e2e_test_requirements}}

## Implementation Tasks
1. Analyze untested code
2. Identify critical paths
3. Write unit tests
4. Write integration tests
5. Verify coverage thresholds met

## Acceptance Criteria
- [ ] Coverage > {{coverage_target}}%
- [ ] All critical paths tested
- [ ] Edge cases covered
- [ ] Tests are maintainable
- [ ] All tests passing

## Validation
```bash
{{test_command}}
{{coverage_command}}
```

Output: <promise>TESTS_COMPLETE</promise>
```
