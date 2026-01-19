# Pattern Library Skill

A comprehensive library of common PR patterns, anti-patterns, and their resolutions.

## Purpose

Provides a reference catalog of patterns discovered across projects to:
- Enable faster pattern recognition
- Suggest proven solutions
- Share knowledge across analyses
- Build institutional memory

## Pattern Categories

### Code Quality Patterns
- Import path inconsistencies
- Error handling gaps
- Code complexity issues
- Duplication patterns
- Naming conventions
- Type safety issues

### Testing Patterns
- Missing test coverage
- Inadequate edge case testing
- Test structure issues
- Flaky tests
- Slow test suites
- Mock/stub misuse

### Security Patterns
- Input validation missing
- SQL injection risks
- XSS vulnerabilities
- Authentication issues
- Secret exposure
- CSRF protection missing

### Performance Patterns
- N+1 query problems
- Memory leaks
- Inefficient algorithms
- Unnecessary re-renders
- Bundle size issues
- Cache misuse

### Documentation Patterns
- Missing API docs
- Unclear comments
- Outdated README
- No usage examples
- Configuration undocumented

### Workflow Patterns
- Scope creep indicators
- Long review cycles
- Unclear requirements
- Frequent amendments
- Build failures
- Merge conflicts

## Pattern Structure

Each pattern includes:

```yaml
pattern_id: import_path_conventions
category: code_quality
severity: medium
frequency: common

description: |
  Relative imports frequently corrected to absolute imports

indicators:
  - Relative import paths in PR diff
  - Review comments mentioning imports
  - Multiple import changes in one PR

root_causes:
  - Missing import convention documentation
  - No linter enforcement
  - Inconsistent examples in codebase

solutions:
  - Add to CLAUDE.md:
      section: Code Conventions
      content: Import path standards
  - Add ESLint rule: import/no-relative-parent-imports
  - Use path aliases in tsconfig.json

prevention:
  - Document conventions upfront
  - Enforce with tooling
  - Include in onboarding

examples:
  - pr: 123
    files: [auth.ts, user.ts]
    change: "../../../models" → "@/models"
```

## Usage

Pattern library is used by:
- **pattern-detector**: Matches new patterns against known ones
- **claude-md-suggester**: Uses solutions to generate CLAUDE.md additions
- **skill-optimizer**: Identifies automation opportunities
- **workflow-advisor**: Recommends process improvements

## Pattern Templates

See `templates/` directory for pattern definition templates:
- `code-quality-pattern.yaml`
- `testing-pattern.yaml`
- `security-pattern.yaml`
- `performance-pattern.yaml`
- `documentation-pattern.yaml`
- `workflow-pattern.yaml`

## Pattern Examples

See `examples/` directory for real-world patterns:
- `import-path-conventions.yaml`
- `missing-error-handling.yaml`
- `test-coverage-gaps.yaml`
- `scope-creep.yaml`

## Pattern Lifecycle

1. **Discovery**: New pattern found in PR analysis
2. **Validation**: Confirmed across multiple PRs (≥3)
3. **Documentation**: Added to pattern library
4. **Solution**: Resolution documented
5. **Prevention**: Proactive measures identified
6. **Tracking**: Monitor for recurrence

## Pattern Matching

When analyzing new PRs:
1. Extract features (keywords, code changes, comments)
2. Compare against pattern library using semantic similarity
3. Match if similarity >0.7
4. If no match and frequency ≥3, create new pattern
5. Update existing patterns with new examples

## Pattern Evolution

Patterns evolve based on:
- Frequency changes (increasing/decreasing)
- New solutions discovered
- Effectiveness of preventions
- Project-specific variations

## Cross-Project Patterns

Some patterns are universal:
- Error handling standards
- Test quality requirements
- Security best practices
- Performance optimization

Others are project-specific:
- Framework-specific patterns
- Domain-specific rules
- Team conventions
- Architecture decisions

## Pattern Metrics

Track for each pattern:
- First occurrence date
- Last occurrence date
- Total occurrences
- Projects affected
- Solution effectiveness
- Prevention success rate
