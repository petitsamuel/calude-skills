# Feature Development Template

## Structure

```markdown
# Task: {{feature_name}}

## Context
{{background}}
{{existing_codebase_state}}
{{integration_points}}

## Goals
- Primary: {{primary_goal}}
{{#each secondary_goals}}
- Secondary: {{this}}
{{/each}}

Success metrics:
- {{metric_1}}
- {{metric_2}}

## Requirements

### Functional
{{#each functional_requirements}}
- {{this}}
{{/each}}

### Non-Functional
- Performance: {{performance_target}}
- Security: {{security_requirements}}
- Accessibility: {{accessibility_level}}
- Error Handling: {{error_handling_strategy}}

## Technical Approach
- **Framework**: {{framework}}
- **Architecture Pattern**: {{architecture}}
- **Data Storage**: {{data_storage}}
- **Testing Strategy**: {{testing_approach}}

Design decisions:
{{design_rationale}}

## Implementation Tasks
1. **Setup**: {{setup_tasks}}
2. **Core Implementation**: {{core_tasks}}
3. **Testing**: {{testing_tasks}}
4. **Documentation**: {{documentation_tasks}}
5. **Integration**: {{integration_tasks}}

## Acceptance Criteria
- [ ] All functional requirements implemented
- [ ] Unit tests written (coverage > {{coverage_threshold}}%)
- [ ] Integration tests passing
- [ ] Error handling in place for edge cases
- [ ] Documentation updated (README, API docs)
- [ ] Code follows project style guide
- [ ] No security vulnerabilities introduced
- [ ] Performance meets targets

## Validation Checks
```bash
{{test_command}}
{{build_command}}
{{lint_command}}
{{type_check_command}}
{{coverage_command}}
```

## Completion Conditions
When ALL of the following are true:
- All acceptance criteria checked
- All validation checks pass
- No failing tests
- Build succeeds with no errors/warnings
- Git status clean (all changes committed)
- Code review ready

Output: <promise>{{completion_promise}}</promise>

## Edge Cases & Error Handling
{{#each edge_cases}}
- **{{this.scenario}}**: {{this.handling}}
{{/each}}

Common patterns:
- Invalid input → Return 400 with descriptive error
- Database error → Return 500, log detailed error, rollback transaction
- Authentication failure → Return 401, log attempt
- Not found → Return 404 with helpful message

## Rollback Plan
If issues found after deployment:
1. {{rollback_step_1}}
2. {{rollback_step_2}}
3. {{rollback_step_3}}

Database migrations: {{migration_rollback}}
```
