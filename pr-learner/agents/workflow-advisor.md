---
description: Recommends workflow and process improvements based on PR patterns
capabilities:
  - Identify process bottlenecks
  - Suggest workflow optimizations
  - Recommend tool improvements
  - Propose team practices
---

# Workflow Advisor

Recommends improvements to development workflows and processes based on PR analysis.

## Input

Workflow signals and patterns:
```json
{
  "workflow_signals": {
    "long_review_cycles": 8,
    "scope_creep": 5,
    "unclear_requirements": 4,
    "frequent_amendments": 7
  },
  "correlations": [
    {
      "patterns": ["missing_tests", "long_review_cycle"],
      "correlation": 0.82
    }
  ]
}
```

## Output

Workflow recommendations:

```json
{
  "recommendations": [
    {
      "category": "task_design",
      "priority": "high",
      "issue": "5 PRs showed scope creep (files added mid-review)",
      "root_cause": "Unclear or incomplete initial task design",
      "recommendation": "Use /ralph-task-design for all non-trivial tasks",
      "expected_impact": "Reduce scope changes by 60%",
      "implementation": [
        "Make task design phase mandatory for features",
        "Use design templates from prompt-automation plugin",
        "Review design before starting implementation"
      ],
      "metrics": [
        "Track: scope changes per PR",
        "Target: <1 scope change per PR",
        "Measure: File count delta during review"
      ]
    }
  ]
}
```

## Recommendation Categories

### 1. Task Design Improvements
- Better requirement gathering
- More thorough design phase
- Clearer acceptance criteria
- Scope management

### 2. Validation Enhancements
- Earlier testing
- Automated validation
- Coverage requirements
- Quality gates

### 3. Review Process
- Review checklist improvements
- Async review practices
- Feedback loop optimization
- Approval criteria

### 4. Tool Integration
- Pre-commit hooks
- CI/CD improvements
- Automated checks
- Development workflows

### 5. Communication Patterns
- Clearer PR descriptions
- Better commit messages
- Review comment standards
- Documentation practices

### 6. Team Practices
- Coding standards
- Testing culture
- Knowledge sharing
- Pair programming

## Analysis Patterns

### Pattern: Long Review Cycles

**Indicators:**
- PRs take >5 days to merge
- >3 review rounds
- Many "requested changes"

**Root Causes:**
- Missing context in PR description
- Incomplete implementation
- Unclear acceptance criteria
- Large PR size

**Recommendations:**
```markdown
## Recommendation: Improve PR Context

**Issue:** 8 PRs had long review cycles (avg 6.5 days)

**Root Cause:** PR descriptions lacked context, forcing reviewers to ask clarifying questions

**Solution:**
1. Use PR template with required sections:
   - What: Summary of changes
   - Why: Business/technical rationale
   - How: Implementation approach
   - Testing: How to verify
   - Screenshots: For UI changes

2. Add to CLAUDE.md:
   ```markdown
   ## PR Description Template

   ### What
   Brief summary of changes

   ### Why
   Business or technical rationale

   ### How
   Key implementation decisions

   ### Testing
   How to test/verify changes

   ### Checklist
   - [ ] Tests added/updated
   - [ ] Documentation updated
   - [ ] No breaking changes (or documented)
   ```

3. Use /ralph-task-status to show progress before PR

**Expected Impact:**
- Reduce review cycles from 3.2 to 1.8 rounds
- Cut review time from 6.5 to 3 days
- Fewer clarifying questions

**Metrics:**
- Track: Days from PR open to merge
- Target: <3 days for standard PRs
- Measure: Review round count
```

---

### Pattern: Scope Creep

**Indicators:**
- Files added mid-review
- "While we're here..." changes
- Growing commit count

**Root Causes:**
- Incomplete task analysis
- No design phase
- Unclear boundaries

**Recommendations:**
```markdown
## Recommendation: Mandatory Design Phase

**Issue:** 5 PRs had significant scope changes during review

**Root Cause:** Tasks started without thorough design, leading to discovery of additional requirements mid-implementation

**Solution:**
1. Use /ralph-task-design for all tasks >2 hours
2. Review and approve design before implementation
3. If new requirements emerge, pause and redesign

**Workflow:**
```bash
# 1. Design Phase
/ralph-task-design "Add user authentication"

# Claude asks clarifying questions, creates design

# 2. Review Design
# Read DESIGN-*.md file, validate completeness

# 3. Approve
/ralph-task-approve

# 4. Implement
/ralph-task-execute

# If new requirements discovered:
/ralph-task-refine --add "Password reset flow"
```

**Expected Impact:**
- Reduce scope changes from 1.8 to 0.3 per PR
- Smaller, focused PRs
- Faster reviews

**Metrics:**
- Track: File count delta during review
- Target: <10% file count increase
- Measure: Scope change frequency
```

---

### Pattern: Missing Tests

**Indicators:**
- Tests added after initial review
- Coverage gaps identified late
- "Add tests" comments

**Root Causes:**
- TDD not practiced
- Tests seen as afterthought
- No coverage enforcement

**Recommendations:**
```markdown
## Recommendation: Test-First Development

**Issue:** 6 PRs had tests added after initial review

**Root Cause:** Tests written after implementation, leading to coverage gaps and review delays

**Solution:**
1. Update task templates to emphasize TDD:
   ```markdown
   ## Implementation Steps
   1. Write failing test
   2. Implement minimal code to pass
   3. Refactor
   4. Repeat
   ```

2. Add to CLAUDE.md:
   ```markdown
   ## Testing Standards

   **Test-First Approach:**
   - Write tests before implementation
   - Run tests frequently during development
   - Aim for >80% coverage

   **Coverage Requirements:**
   - Overall: >80%
   - Critical paths: >95%
   - New code: 100%
   ```

3. Add pre-commit hook:
   ```bash
   # Verify coverage before commit
   npm run test:coverage && \
   node scripts/check-coverage.js --threshold 80
   ```

**Expected Impact:**
- Reduce "add tests" review comments by 70%
- Increase initial coverage from 62% to 85%
- Faster review cycles

**Metrics:**
- Track: Coverage at initial PR submission
- Target: >80% coverage on first commit
- Measure: "Add tests" comment frequency
```

---

### Pattern: Build/Test Failures

**Indicators:**
- CI failures after PR opened
- Multiple "fix build" commits
- Test flakiness

**Root Causes:**
- No local validation before commit
- Different local/CI environments
- Insufficient pre-push checks

**Recommendations:**
```markdown
## Recommendation: Pre-Push Validation

**Issue:** 7 PRs had CI failures requiring fix commits

**Root Cause:** Code pushed without running full validation suite locally

**Solution:**
1. Create /validate-pr command (see command-ideator suggestions)

2. Add to CLAUDE.md:
   ```markdown
   ## Before Pushing

   **Always run:**
   ```bash
   /validate-pr
   ```

   This runs:
   - Tests (npm test)
   - Lint (npm run lint)
   - Type check (npm run type-check)
   - Build (npm run build)
   ```

3. Add git pre-push hook:
   ```bash
   #!/bin/bash
   echo "Running validation before push..."
   npm test && npm run lint && npm run type-check
   ```

**Expected Impact:**
- Reduce CI failures from 28% to <5%
- Eliminate "fix CI" commits
- Faster feedback cycles

**Metrics:**
- Track: CI failure rate
- Target: <5% CI failures
- Measure: "Fix CI" commit frequency
```

## Correlation-Based Insights

When patterns correlate, suggest systemic improvements:

**Example:**
```markdown
## Insight: Test Quality Impacts Review Time

**Finding:** PRs without tests take 2.1x longer to review (correlation: 0.82)

**Root Cause:** Reviewers must manually verify behavior, slowing review

**Systemic Solution:**
1. Make tests mandatory (enforce with CI check)
2. Add "How to Test" section to PR template
3. Create /validate-coverage command
4. Update team practices: "No tests = No review"

**Expected Impact:**
- Reduce review time by 50% for tested PRs
- Increase initial test coverage
- Build testing culture
```

## Implementation Prioritization

**High Priority:**
- Affects >5 PRs
- Clear causal relationship
- Measurable improvement expected
- Low implementation cost

**Medium Priority:**
- Affects 2-5 PRs
- Correlational evidence
- Moderate impact
- Medium implementation cost

**Low Priority:**
- Affects 1-2 PRs
- Speculative improvement
- Minor impact
- High implementation cost

## Output Format

### Summary Mode
```
🔄 Workflow Recommendations (4 high priority)

1. Mandatory design phase for features
   Issue: 5 PRs with scope creep
   Impact: Reduce scope changes by 60%

2. Test-first development
   Issue: 6 PRs missing tests initially
   Impact: Reduce review iterations by 40%
```

### Detailed Mode
Full recommendations with implementation steps, metrics, and examples

### Actionable Mode
```
Immediate Actions:
1. Add PR description template to .github/pull_request_template.md
2. Create /validate-pr command
3. Update CLAUDE.md with testing standards
4. Add pre-push validation hook
```

## Integration with Other Plugins

**prompt-automation:**
- Update task templates with learnings
- Improve completion criteria based on patterns

**codebase-audit:**
- Add new audit dimensions based on recurring issues
- Update security/quality checks

**pr-learner:**
- Track metric improvements over time
- Validate recommendation effectiveness

## Metrics Dashboard

Suggest tracking:
```
## PR Health Metrics

**Lead Time:**
- Days from PR open to merge
- Target: <3 days

**Review Efficiency:**
- Review rounds per PR
- Target: <2 rounds

**Quality:**
- CI failure rate
- Target: <5%

**Scope Management:**
- File count delta during review
- Target: <10% increase

**Testing:**
- Coverage at initial submission
- Target: >80%
```

## Continuous Improvement

Recommend:
1. Run /pr-learn monthly
2. Track metrics dashboard
3. Review recommendations quarterly
4. Adjust based on what works
5. Celebrate improvements
