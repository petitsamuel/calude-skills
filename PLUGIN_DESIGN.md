# Claude Code Plugins Design Document

## Overview

This document outlines the design for two Claude Code plugins:

1. **codebase-audit** - Comprehensive multi-dimensional codebase analysis using specialized sub-agents
2. **prompt-automation** - Intelligent prompt engineering system for iterative task automation (Ralph Loop style)

---

## Plugin 1: Codebase Audit Plugin

### Name & Purpose

**Plugin Name**: `codebase-audit`

**Purpose**: Perform comprehensive, multi-dimensional audits of codebases using specialized sub-agents to analyze security, safety, code quality, performance, accessibility, and maintainability. Generates actionable improvement recommendations across all dimensions.

### Directory Structure

```
codebase-audit/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── audit.md                    # Main audit command
│   ├── security-audit.md           # Security-only audit
│   ├── quality-audit.md            # Code quality audit
│   └── full-report.md              # Generate comprehensive report
├── agents/
│   ├── audit-orchestrator.md       # Coordinates all audit agents
│   ├── security-auditor.md         # Security vulnerabilities & best practices
│   ├── safety-auditor.md           # Safety patterns & error handling
│   ├── code-quality-auditor.md     # Code smells, patterns, maintainability
│   ├── performance-auditor.md      # Performance bottlenecks & optimization
│   ├── accessibility-auditor.md    # A11y compliance (for web projects)
│   ├── dependency-auditor.md       # Dependency vulnerabilities & updates
│   ├── test-coverage-auditor.md    # Test quality & coverage analysis
│   └── documentation-auditor.md    # Documentation completeness
├── skills/
│   ├── report-generator/
│   │   ├── SKILL.md
│   │   └── templates/
│   │       ├── summary.md
│   │       ├── security-report.md
│   │       └── full-audit-report.md
│   └── issue-prioritizer/
│       └── SKILL.md
├── hooks/
│   └── hooks.json                  # Pre-audit validation
├── scripts/
│   ├── collect-metrics.sh          # Gather codebase metrics
│   ├── dependency-check.sh         # Check for known vulnerabilities
│   └── generate-report.py          # Format and compile audit results
├── config/
│   ├── severity-levels.json        # Issue severity configuration
│   ├── security-patterns.json      # Security anti-patterns to detect
│   └── quality-thresholds.json     # Code quality benchmarks
└── README.md
```

### Component Details

#### Commands

**`/audit [scope] [--format=<markdown|json|html>] [--severity=<low|medium|high|critical>]`**
- Main command to trigger comprehensive audit
- **Scope options**: `all`, `security`, `quality`, `performance`, `tests`, `deps`
- **Format options**: Output format for report
- **Severity filter**: Only show issues above threshold

**`/security-audit [--deep]`**
- Focused security audit only
- `--deep` flag enables more thorough analysis

**`/quality-audit [--metrics]`**
- Code quality and maintainability analysis
- `--metrics` includes quantitative metrics (cyclomatic complexity, etc.)

**`/full-report [--output=<path>]`**
- Generate comprehensive audit report
- Save to file with `--output` flag

#### Agents

**1. audit-orchestrator.md**
```yaml
---
description: Coordinates multi-dimensional codebase audit by managing specialized audit agents
capabilities:
  - Parallel agent coordination
  - Result aggregation and prioritization
  - Report generation
  - Progress tracking
auto_invoke: true
---

# Audit Orchestrator

Manages the complete audit workflow by:
1. Analyzing project structure and technology stack
2. Dispatching specialized audit agents based on project type
3. Collecting and aggregating results from all agents
4. Prioritizing findings by severity and impact
5. Generating comprehensive, actionable reports

Invokes agents in parallel for optimal performance:
- security-auditor
- safety-auditor
- code-quality-auditor
- performance-auditor
- test-coverage-auditor
- dependency-auditor
- documentation-auditor
- accessibility-auditor (if web project detected)
```

**2. security-auditor.md**
```yaml
---
description: Identifies security vulnerabilities and anti-patterns
capabilities:
  - OWASP Top 10 detection
  - Authentication/authorization review
  - Input validation analysis
  - Cryptography review
  - Secrets detection
  - API security
---

# Security Auditor

Performs deep security analysis:
- SQL injection vulnerabilities
- XSS and CSRF risks
- Command injection points
- Insecure deserialization
- Authentication bypass vectors
- Authorization flaws
- Hardcoded secrets and credentials
- Insecure cryptographic practices
- API authentication weaknesses
- Rate limiting and DoS protection

Outputs findings with:
- Severity level (Critical/High/Medium/Low)
- CVE references where applicable
- Remediation recommendations
- Code examples of fixes
```

**3. safety-auditor.md**
```yaml
---
description: Analyzes error handling, edge cases, and failure modes
capabilities:
  - Error handling patterns
  - Silent failure detection
  - Edge case analysis
  - Null/undefined handling
  - Resource leak detection
---

# Safety Auditor

Focuses on robustness and reliability:
- Missing error handling
- Silent failures (empty catch blocks)
- Unhandled promise rejections
- Resource leaks (files, connections, memory)
- Race conditions
- Deadlock potential
- Input edge cases
- Boundary condition handling
```

**4. code-quality-auditor.md**
```yaml
---
description: Evaluates code maintainability, patterns, and technical debt
capabilities:
  - Code smell detection
  - Design pattern analysis
  - Cyclomatic complexity
  - Duplication detection
  - Naming convention review
---

# Code Quality Auditor

Analyzes maintainability:
- Code duplication (DRY violations)
- Long functions/methods
- Deep nesting
- High cyclomatic complexity
- Poor naming conventions
- Magic numbers/strings
- God classes/objects
- Tight coupling
- Missing abstractions
- Technical debt accumulation
```

**5. performance-auditor.md**
```yaml
---
description: Identifies performance bottlenecks and optimization opportunities
capabilities:
  - N+1 query detection
  - Memory leak analysis
  - Algorithmic complexity review
  - Caching opportunities
  - Bundle size analysis
---

# Performance Auditor

Identifies performance issues:
- O(n²) or worse algorithms
- N+1 database queries
- Missing indexes
- Inefficient loops
- Memory leaks
- Unnecessary re-renders (React/Vue)
- Large bundle sizes
- Unoptimized images
- Missing caching strategies
- Blocking operations
```

**6. test-coverage-auditor.md**
```yaml
---
description: Analyzes test quality, coverage, and gaps
capabilities:
  - Coverage analysis
  - Test quality assessment
  - Critical path identification
  - Flaky test detection
---

# Test Coverage Auditor

Evaluates testing practices:
- Test coverage percentages
- Untested critical paths
- Missing edge case tests
- Flaky tests
- Test maintainability
- Integration test gaps
- E2E test coverage
- Mock/stub quality
```

**7. dependency-auditor.md**
```yaml
---
description: Reviews dependencies for vulnerabilities and updates
capabilities:
  - Vulnerability scanning
  - Outdated package detection
  - License compliance
  - Dependency graph analysis
---

# Dependency Auditor

Analyzes project dependencies:
- Known CVEs in dependencies
- Outdated packages
- Deprecated dependencies
- Transitive vulnerability exposure
- License compliance issues
- Unused dependencies
- Duplicate dependencies
- Breaking change warnings
```

**8. documentation-auditor.md**
```yaml
---
description: Assesses documentation completeness and quality
capabilities:
  - README quality
  - API documentation
  - Code comment analysis
  - Setup instruction validation
---

# Documentation Auditor

Reviews documentation:
- README completeness
- Missing API documentation
- Outdated documentation
- Setup/installation clarity
- Architecture documentation
- Contributing guidelines
- Code comment quality
- Example code freshness
```

**9. accessibility-auditor.md**
```yaml
---
description: Evaluates web accessibility compliance (WCAG 2.1)
capabilities:
  - WCAG 2.1 compliance
  - ARIA usage review
  - Keyboard navigation
  - Screen reader compatibility
auto_invoke_conditions:
  - project_type: ["web", "frontend", "react", "vue", "angular"]
---

# Accessibility Auditor

Analyzes web accessibility:
- Missing ARIA labels
- Color contrast issues
- Keyboard navigation gaps
- Focus management
- Screen reader compatibility
- Semantic HTML usage
- Alt text for images
- Form accessibility
```

#### Skills

**1. report-generator**
```markdown
# Report Generator Skill

Generates professional audit reports in multiple formats.

## Capabilities
- Markdown reports with severity badges
- JSON structured data for CI/CD
- HTML interactive reports
- Issue prioritization
- Executive summaries
- Trend analysis (if historical data available)

## Templates
- `summary.md`: High-level executive summary
- `security-report.md`: Detailed security findings
- `full-audit-report.md`: Comprehensive multi-dimensional report

## Usage
Automatically invoked by audit-orchestrator to format final output.
```

**2. issue-prioritizer**
```markdown
# Issue Prioritizer Skill

Prioritizes audit findings based on severity, impact, and effort.

## Prioritization Factors
- Severity level (Critical → Low)
- Exploitability (for security issues)
- Impact on users/business
- Fix effort estimation
- Dependency on other issues

## Output
Ranked list of issues with recommended fix order.
```

#### Hooks Configuration

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "When performing audits, always provide specific code examples and actionable remediation steps."
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Task",
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/scripts/collect-metrics.sh"
          }
        ]
      }
    ]
  }
}
```

### plugin.json Configuration

```json
{
  "name": "codebase-audit",
  "version": "1.0.0",
  "description": "Comprehensive multi-dimensional codebase audit using specialized sub-agents",
  "author": {
    "name": "Sam",
    "email": "sam@example.com"
  },
  "keywords": ["audit", "security", "quality", "performance", "testing"],
  "commands": "./commands/",
  "agents": "./agents/",
  "skills": "./skills/",
  "hooks": "./hooks/hooks.json"
}
```

### Usage Examples

```bash
# Full audit with all agents
/audit all

# Security-focused audit only
/audit security --severity=high

# Generate comprehensive report
/full-report --output=./audit-report.md

# Quick security scan
/security-audit

# Code quality with metrics
/quality-audit --metrics
```

### Expected Output

```markdown
# Codebase Audit Report
Generated: 2026-01-18

## Executive Summary
- **Critical Issues**: 3
- **High Severity**: 12
- **Medium Severity**: 28
- **Low Severity**: 45

## Security Findings

### 🔴 Critical: SQL Injection Vulnerability
**Location**: `src/api/users.ts:45`
**Description**: User input directly interpolated into SQL query
**Remediation**: Use parameterized queries
```js
// Before (vulnerable)
const query = `SELECT * FROM users WHERE id = ${userId}`;

// After (secure)
const query = `SELECT * FROM users WHERE id = ?`;
db.query(query, [userId]);
```

## Performance Findings

### 🟡 Medium: N+1 Query Pattern
**Location**: `src/services/posts.ts:120-135`
...
```

---

## Plugin 2: Prompt Automation Plugin

### Name & Purpose

**Plugin Name**: `prompt-automation`

**Purpose**: Intelligent prompt engineering system that automates iterative task execution through Ralph Loop methodology. Generates, refines, and orchestrates prompts for complex multi-step tasks with automatic retry, self-correction, and completion detection.

### Directory Structure

```
prompt-automation/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── auto-prompt.md             # Generate optimal prompt for task
│   ├── start-loop.md              # Start Ralph Loop with task
│   ├── cancel-loop.md             # Cancel active loop
│   └── refine-prompt.md           # Refine existing prompt
├── agents/
│   ├── prompt-engineer.md         # Generates optimal prompts
│   ├── task-analyzer.md           # Analyzes tasks to extract requirements
│   ├── completion-detector.md     # Detects when tasks are complete
│   └── loop-orchestrator.md       # Manages Ralph Loop execution
├── skills/
│   ├── prompt-patterns/
│   │   ├── SKILL.md
│   │   └── templates/
│   │       ├── feature-development.md
│   │       ├── bug-fix.md
│   │       ├── refactoring.md
│   │       ├── testing.md
│   │       └── documentation.md
│   ├── completion-criteria/
│   │   └── SKILL.md
│   └── prompt-optimizer/
│       └── SKILL.md
├── hooks/
│   ├── hooks.json
│   └── stop-loop.sh               # Ralph Loop stop hook
├── templates/
│   ├── prompts/
│   │   ├── tdd-workflow.md
│   │   ├── feature-with-tests.md
│   │   ├── security-fix.md
│   │   └── performance-optimization.md
│   └── completion-promises/
│       ├── standard-promises.json
│       └── custom-promises.json
├── scripts/
│   ├── loop-manager.sh
│   ├── inject-prompt.sh
│   └── check-completion.py
└── README.md
```

### Component Details

#### Commands

**`/auto-prompt "<task description>" [--template=<type>]`**
- Analyzes task and generates optimal prompt
- Auto-selects appropriate template
- Includes completion criteria
- Ready for Ralph Loop execution

**`/start-loop "<prompt>" [--max-iterations=<n>] [--promise=<text>]`**
- Starts Ralph Loop with generated or custom prompt
- Auto-detects completion criteria
- Supports custom completion promises

**`/cancel-loop`**
- Safely terminates active Ralph Loop
- Saves progress and state

**`/refine-prompt "<original prompt>" --feedback="<what went wrong>"`**
- Improves existing prompt based on execution feedback
- Learns from failures

#### Agents

**1. prompt-engineer.md**
```yaml
---
description: Expert at crafting optimal prompts for complex tasks
capabilities:
  - Task decomposition
  - Requirement extraction
  - Completion criteria definition
  - Prompt template selection
  - Context injection
---

# Prompt Engineer Agent

Generates high-quality prompts by:

## Analysis Phase
1. Parse task description
2. Identify task type (feature, bug fix, refactoring, etc.)
3. Extract explicit and implicit requirements
4. Determine complexity and scope

## Prompt Generation
1. Select appropriate template
2. Inject specific requirements
3. Define clear acceptance criteria
4. Add completion promise markers
5. Include self-verification steps

## Output Structure
```markdown
# Task: [Task Name]

## Objective
[Clear, specific goal]

## Requirements
- Explicit requirement 1
- Explicit requirement 2
- Implicit requirement (inferred from context)

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] All tests passing
- [ ] Documentation updated

## Implementation Approach
1. Step 1
2. Step 2
3. Step 3

## Completion Promise
When all criteria are met, output:
<promise>TASK_COMPLETE</promise>
```

## Best Practices
- Break complex tasks into phases
- Include self-testing steps
- Specify error handling requirements
- Add rollback instructions if needed
```

**2. task-analyzer.md**
```yaml
---
description: Analyzes task descriptions to extract requirements and constraints
capabilities:
  - Requirement extraction
  - Task classification
  - Complexity estimation
  - Dependency identification
---

# Task Analyzer Agent

Performs deep task analysis:

## Task Classification
- Feature development
- Bug fix
- Refactoring
- Performance optimization
- Security fix
- Testing
- Documentation

## Requirement Extraction
- **Explicit**: Stated in task description
- **Implicit**: Inferred from context (tests, docs, etc.)
- **Non-functional**: Performance, security, accessibility

## Complexity Assessment
- Simple (1-3 steps)
- Moderate (4-8 steps)
- Complex (9+ steps, multiple files)

## Output
Structured task analysis used by prompt-engineer to generate optimal prompts.
```

**3. completion-detector.md**
```yaml
---
description: Detects when tasks are complete based on multiple signals
capabilities:
  - Promise marker detection
  - Test pass verification
  - File change analysis
  - Error state detection
---

# Completion Detector Agent

Determines task completion through:

## Signal Analysis
1. **Promise markers**: `<promise>COMPLETE</promise>` in output
2. **Test status**: All tests passing
3. **Build status**: Clean build with no errors
4. **Git state**: No uncommitted changes (if required)
5. **Coverage**: Test coverage meets threshold

## Failure Detection
- Infinite loops (same error 3+ times)
- Stuck patterns (no file changes in 2+ iterations)
- Timeout (max iterations reached)

## Action
- Signal loop termination when complete
- Report completion status
- Suggest next steps if incomplete
```

**4. loop-orchestrator.md**
```yaml
---
description: Manages Ralph Loop execution lifecycle
capabilities:
  - Loop initialization
  - State management
  - Progress tracking
  - Iteration control
  - Emergency shutdown
---

# Loop Orchestrator Agent

Manages the complete Ralph Loop:

## Initialization
1. Validate prompt structure
2. Set completion criteria
3. Configure max iterations
4. Initialize state tracking

## Iteration Management
```
┌─────────────────────────────────────┐
│ Inject prompt into session          │
└────────────┬────────────────────────┘
             │
             ▼
   ┌─────────────────────┐
   │ Claude executes     │
   │ task                │
   └──────────┬──────────┘
              │
              ▼
   ┌─────────────────────┐
   │ Completion check    │
   │ - Promise marker?   │
   │ - Tests pass?       │
   │ - Build success?    │
   └──────────┬──────────┘
              │
        ┌─────┴─────┐
        │           │
    Complete?    Continue?
        │           │
        ▼           ▼
     EXIT      Re-inject
              (iteration++)
```

## State Tracking
- Current iteration count
- Files modified
- Tests run
- Errors encountered
- Progress metrics

## Safety
- Max iteration limit
- Infinite loop detection
- Emergency stop handler
```

#### Skills

**1. prompt-patterns**
```markdown
# Prompt Patterns Skill

Library of proven prompt templates for common tasks.

## Templates

### Feature Development
```
Build [feature name] with the following:

Requirements:
- [Requirement 1]
- [Requirement 2]

Technical Approach:
- [Technology/pattern to use]

Acceptance Criteria:
- [ ] Feature implemented
- [ ] Unit tests added (coverage > 80%)
- [ ] Integration tests passing
- [ ] Documentation updated
- [ ] Code reviewed

Self-Testing:
1. Run all tests: `npm test`
2. Check coverage: `npm run coverage`
3. Build project: `npm run build`
4. Manual smoke test

Completion:
Output <promise>COMPLETE</promise> when all criteria met.
```

### Bug Fix with TDD
```
Fix bug: [bug description]

Steps:
1. Write failing test that reproduces bug
2. Implement minimal fix
3. Verify test passes
4. Run full test suite
5. Check for regressions
6. Add additional test cases for edge cases

Success Criteria:
- [ ] Bug reproduced by test
- [ ] Fix implemented
- [ ] All tests pass
- [ ] No regressions
- [ ] Edge cases covered

Output <promise>BUG_FIXED</promise> when complete.
```

### Refactoring
```
Refactor [component/module]:

Goals:
- [Goal 1: e.g., reduce complexity]
- [Goal 2: e.g., improve testability]

Constraints:
- Maintain all existing functionality
- Keep API compatibility
- All tests must pass

Process:
1. Run tests to establish baseline
2. Refactor incrementally
3. Run tests after each change
4. If tests fail, rollback last change
5. Repeat until goals achieved

Completion: <promise>REFACTOR_COMPLETE</promise>
```
```

**2. completion-criteria**
```markdown
# Completion Criteria Skill

Defines clear, verifiable completion criteria for tasks.

## Criteria Types

### Functional
- Feature works as specified
- All acceptance criteria met
- No critical bugs

### Testing
- Unit tests passing
- Integration tests passing
- Coverage threshold met (typically 80%+)
- E2E tests pass (if applicable)

### Quality
- Linting passes
- Type checking passes (TypeScript)
- Build succeeds
- No console errors/warnings

### Documentation
- README updated (if needed)
- API docs updated
- Code comments added (complex logic)
- CHANGELOG updated

### Version Control
- Changes committed
- Commit message follows convention
- Branch pushed (if applicable)

## Promise Markers
Standard completion markers:
- `<promise>COMPLETE</promise>`
- `<promise>READY_FOR_REVIEW</promise>`
- `<promise>TESTS_PASSING</promise>`
- `<promise>BUG_FIXED</promise>`
```

**3. prompt-optimizer**
```markdown
# Prompt Optimizer Skill

Refines prompts based on execution feedback.

## Optimization Strategies

### Add Specificity
If task incomplete:
- Add more specific requirements
- Include example code
- Clarify ambiguous steps

### Improve Structure
If agent confused:
- Break into smaller steps
- Number steps explicitly
- Add checkpoint verification

### Strengthen Criteria
If premature completion:
- Add stricter acceptance criteria
- Include self-verification steps
- Require explicit test evidence

### Add Context
If wrong approach:
- Include architectural guidance
- Reference existing patterns
- Specify technologies/libraries

## Example Refinement

**Original** (too vague):
```
Add user authentication
```

**Refined**:
```
Implement user authentication with JWT:

Requirements:
- Login endpoint: POST /api/auth/login
- Accept: { email, password }
- Return: { token, user }
- Token expires in 24h
- Password hashed with bcrypt
- Rate limiting: 5 attempts per minute

Tests Required:
- Valid login returns token
- Invalid credentials return 401
- Token expires after 24h
- Rate limiting works

Complete when:
- All tests pass
- Postman collection works
- Documentation updated

Output: <promise>AUTH_COMPLETE</promise>
```
```

#### Hooks Configuration

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "${CLAUDE_PLUGIN_ROOT}/hooks/stop-loop.sh"
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "hooks": [
          {
            "type": "agent",
            "agentType": "completion-detector",
            "prompt": "Analyze the subagent output and determine if the task is complete."
          }
        ]
      }
    ],
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "prompt",
            "prompt": "When using Ralph Loop patterns, ensure prompts include clear completion criteria and self-verification steps."
          }
        ]
      }
    ]
  }
}
```

#### Stop Hook Script

**hooks/stop-loop.sh**
```bash
#!/bin/bash
# Ralph Loop stop hook - re-injects prompt to continue iteration

# Check if loop is active
if [ ! -f ".claude-loop-state" ]; then
  exit 0  # No active loop, allow normal exit
fi

# Load loop state
source .claude-loop-state

# Check completion
if grep -q "<promise>${COMPLETION_PROMISE}</promise>" "${LOOP_OUTPUT_FILE}"; then
  echo "✓ Task completed successfully"
  rm .claude-loop-state
  exit 0  # Allow exit
fi

# Check max iterations
if [ ${CURRENT_ITERATION} -ge ${MAX_ITERATIONS} ]; then
  echo "⚠ Max iterations (${MAX_ITERATIONS}) reached"
  rm .claude-loop-state
  exit 0  # Allow exit
fi

# Increment iteration
CURRENT_ITERATION=$((CURRENT_ITERATION + 1))
echo "CURRENT_ITERATION=${CURRENT_ITERATION}" > .claude-loop-state

# Re-inject prompt
echo "${ORIGINAL_PROMPT}"

# Block exit to continue loop
exit 1
```

### plugin.json Configuration

```json
{
  "name": "prompt-automation",
  "version": "1.0.0",
  "description": "Intelligent prompt engineering and Ralph Loop automation system",
  "author": {
    "name": "Sam",
    "email": "sam@example.com"
  },
  "keywords": ["prompt", "automation", "ralph-loop", "iteration", "prompt-engineering"],
  "commands": "./commands/",
  "agents": "./agents/",
  "skills": "./skills/",
  "hooks": "./hooks/hooks.json"
}
```

### Usage Examples

```bash
# Generate optimal prompt for a task
/auto-prompt "Build a REST API for a todo app with auth"

# Start Ralph Loop with generated prompt
/start-loop "<generated prompt>" --max-iterations=30 --promise="COMPLETE"

# Quick start with template
/auto-prompt "Fix the login bug" --template=bug-fix
/start-loop "<generated prompt>"

# Refine a prompt that didn't work
/refine-prompt "Build user auth" --feedback="Too vague, needs JWT specifics"

# Cancel stuck loop
/cancel-loop
```

### Expected Workflow

```
User: "Build a todo API with CRUD operations"
         │
         ▼
  /auto-prompt analyzes task
         │
         ▼
  prompt-engineer generates:
  ┌─────────────────────────────────┐
  │ Build Todo API:                 │
  │ - POST /todos                   │
  │ - GET /todos                    │
  │ - PUT /todos/:id                │
  │ - DELETE /todos/:id             │
  │ - Validation on all endpoints   │
  │ - Unit tests (80%+ coverage)    │
  │ - Integration tests             │
  │ - OpenAPI docs                  │
  │                                 │
  │ Complete when:                  │
  │ - Tests pass                    │
  │ - API docs generated            │
  │ - Postman collection works      │
  │                                 │
  │ Output: <promise>COMPLETE</promise> │
  └─────────────────────────────────┘
         │
         ▼
  User: /start-loop "<prompt>" --max-iterations=25
         │
         ▼
  ┌─────────────────────────────────┐
  │ Iteration 1:                    │
  │ - Create project structure      │
  │ - Set up Express                │
  └─────────────────────────────────┘
         │
         ▼
  Stop hook re-injects prompt
         │
         ▼
  ┌─────────────────────────────────┐
  │ Iteration 2:                    │
  │ - Implement POST /todos         │
  │ - Add validation                │
  │ - Write tests                   │
  └─────────────────────────────────┘
         │
         ▼
  ... continues until ...
         │
         ▼
  ┌─────────────────────────────────┐
  │ Iteration 8:                    │
  │ - All tests passing ✓           │
  │ - Docs generated ✓              │
  │ - <promise>COMPLETE</promise>   │
  └─────────────────────────────────┘
         │
         ▼
  Loop exits successfully
```

---

## Implementation Strategy

### Phase 1: Core Structure (Week 1)
1. Create directory structures for both plugins
2. Write plugin.json configurations
3. Create basic README files
4. Set up hooks.json files

### Phase 2: Codebase Audit Plugin (Week 2-3)
1. Implement core agents (orchestrator, security, quality, performance)
2. Create report-generator skill
3. Build basic audit command
4. Test with sample codebases

### Phase 3: Prompt Automation Plugin (Week 3-4)
1. Implement prompt-engineer agent
2. Create prompt templates
3. Build Ralph Loop stop hook
4. Implement loop orchestrator
5. Test with sample tasks

### Phase 4: Polish & Documentation (Week 5)
1. Comprehensive testing of both plugins
2. Write detailed documentation
3. Create example use cases
4. Record demo videos

### Phase 5: Advanced Features (Week 6+)
- Add more audit dimensions
- Implement prompt learning from feedback
- Add historical trend analysis
- Build web UI for audit reports

---

## Technical Considerations

### Codebase Audit Plugin

**Dependencies:**
- Static analysis tools (ESLint, PyLint, etc.)
- Security scanners (npm audit, Snyk, etc.)
- Test coverage tools (Jest, coverage.py, etc.)

**Performance:**
- Run agents in parallel for speed
- Cache results for incremental audits
- Support partial audits (specific directories)

**Extensibility:**
- Plugin architecture for custom audit agents
- Configurable severity thresholds
- Custom security pattern rules

### Prompt Automation Plugin

**State Management:**
- Persist loop state in `.claude-loop-state`
- Track iteration count and history
- Store completion criteria

**Safety:**
- Always set max-iterations default (30)
- Detect infinite loops (same error 3+ times)
- Allow graceful cancellation

**Learning:**
- Store successful prompts for reuse
- Learn from failed prompts
- Build prompt library over time

---

## Success Metrics

### Codebase Audit Plugin
- Reduces manual audit time by 80%+
- Catches 95%+ of common vulnerabilities
- Provides actionable recommendations
- Integrates with CI/CD pipelines

### Prompt Automation Plugin
- Reduces prompt crafting time by 70%+
- Increases task completion rate
- Handles complex multi-step tasks autonomously
- Learns and improves over time

---

## Future Enhancements

### Codebase Audit
- Real-time monitoring mode
- IDE integration
- Automated fix generation
- Comparison with industry benchmarks

### Prompt Automation
- Multi-agent orchestration
- Prompt A/B testing
- Natural language task parsing
- Integration with project management tools

---

## Resources

### Documentation
- [Claude Code Plugins Reference](https://code.claude.com/docs/en/plugins-reference)
- [Claude Code Documentation](https://code.claude.com/docs/en/overview)
- [Ralph Loop Explained](https://blog.devgenius.io/ralph-wiggum-explained-the-claude-code-loop-that-keeps-going-3250dcc30809)
- [Awesome Claude - Ralph Wiggum](https://awesomeclaude.ai/ralph-wiggum)

### Examples
- [Official Claude Plugins](https://github.com/anthropics/claude-plugins-official)
- [Ralph Loop Plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/ralph-loop)
- [PR Review Toolkit](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/pr-review-toolkit)
