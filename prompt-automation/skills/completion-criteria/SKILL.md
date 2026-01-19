# Completion Criteria Skill

This skill helps define clear, verifiable completion criteria for tasks.

## Purpose

Generates specific, measurable acceptance criteria that can be validated through:
- Test execution results
- Build success/failure
- Git status checks
- Behavioral verification
- Performance benchmarks

## Usage

Reference this skill when creating task designs or prompts to ensure clear success criteria.

## Criteria Categories

### 1. Functional Criteria
- Feature works as specified
- All user flows complete successfully
- Edge cases handled correctly

### 2. Technical Criteria
- All tests passing
- Build succeeds without errors
- No new linting violations
- Type checking passes

### 3. Quality Criteria
- Code coverage thresholds met
- Performance benchmarks achieved
- Security checks passed
- Accessibility standards met

### 4. Process Criteria
- Git status clean (or expected changes only)
- Documentation updated
- Examples provided

## Validation Commands

Each criterion should be verifiable through commands like:
```bash
npm test
npm run build
npm run lint
npm run type-check
git status
```

## Promise Pattern

Tasks should emit a completion promise when all criteria met:
```
Output: <promise>TASK_COMPLETE</promise>
```

## Examples

See `examples/` directory for well-formed completion criteria patterns.
