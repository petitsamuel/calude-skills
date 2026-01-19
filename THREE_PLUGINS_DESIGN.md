# Claude Code Plugins - Complete Design Specification

**Date:** 2026-01-19
**Status:** Final Design - Ready for Implementation
**Plugins:** 3 (codebase-audit, prompt-automation, pr-learner)

---

## Table of Contents

1. [Design Principles](#design-principles)
2. [Plugin 1: Codebase Audit](#plugin-1-codebase-audit)
3. [Plugin 2: Prompt Automation](#plugin-2-prompt-automation)
4. [Plugin 3: PR Learner](#plugin-3-pr-learner)
5. [Cross-Plugin Conventions](#cross-plugin-conventions)
6. [Implementation Roadmap](#implementation-roadmap)

---

## Design Principles

### Architectural Standards
- ✅ **Separate plugins** (not unified)
- ✅ **Agent-based architecture** (specialized sub-agents)
- ✅ **Parallel execution** where possible
- ✅ **Convention over configuration** (smart defaults)
- ✅ **Minimal hooks** (essential only)
- ✅ **Hybrid skills** (instructions + resources)

### Naming Conventions
- **Commands:** Prefixed (`/audit-*`, `/ralph-task-*`, `/pr-learn-*`)
- **Files:** kebab-case (`security-auditor.md`)
- **Agents:** Minimal frontmatter (description + capabilities)
- **Skills:** `SKILL.md` + optional resources

### Agent Frontmatter Format
```yaml
---
description: Brief description of agent purpose
capabilities:
  - Capability 1
  - Capability 2
auto_invoke: true
---
```

### Skill Structure
```
skill-name/
├── SKILL.md              # Instructions
├── templates/            # Optional templates
└── examples/             # Optional examples
```

---

## Plugin 1: Codebase Audit

### Purpose
Multi-dimensional codebase analysis using specialized sub-agents.

### Commands

```bash
/audit [scope] [--format=markdown] [--severity=low]
  # Main comprehensive audit
  # Scope: all|security|quality|performance|tests|deps|docs|safety|a11y

/audit-security [--deep]
  # Security-focused scan

/audit-quality [--metrics]
  # Code quality with optional metrics

/audit-report [--output=path]
  # Save report to file

/audit-status
  # Show audit progress
```

### Directory Structure

```
codebase-audit/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── audit.md
│   ├── audit-security.md
│   ├── audit-quality.md
│   ├── audit-report.md
│   └── audit-status.md
├── agents/
│   ├── audit-orchestrator.md
│   ├── security-auditor.md
│   ├── safety-auditor.md
│   ├── code-quality-auditor.md
│   ├── performance-auditor.md
│   ├── accessibility-auditor.md
│   ├── dependency-auditor.md
│   ├── test-coverage-auditor.md
│   └── documentation-auditor.md
├── skills/
│   ├── report-generator/
│   │   ├── SKILL.md
│   │   └── templates/
│   │       └── audit-report.md
│   └── issue-prioritizer/
│       ├── SKILL.md
│       └── examples/
│           └── prioritization-example.md
├── hooks/
│   └── hooks.json
└── README.md
```

### Audit Dimensions (8)

1. **Security** - OWASP Top 10, vulnerabilities, secrets, injection
2. **Safety** - Error handling, edge cases, null checks, failure modes
3. **Code Quality** - Complexity, smells, patterns, duplication, tech debt
4. **Performance** - Bottlenecks, N+1 queries, memory leaks, inefficient algorithms
5. **Test Coverage** - Coverage %, test quality, missing tests, flaky tests
6. **Dependencies** - CVEs, outdated packages, security advisories
7. **Documentation** - README, API docs, comments, completeness
8. **Accessibility** - WCAG 2.1 compliance (conditional on web projects)

### Agents

**audit-orchestrator.md**
```yaml
---
description: Coordinates multi-dimensional audit by managing specialized agents
capabilities:
  - Parallel agent coordination
  - Result aggregation
  - Priority ranking
  - Report generation
auto_invoke: true
---

# Audit Orchestrator

Spawns 8 specialized agents in parallel, aggregates findings,
prioritizes by severity, and generates comprehensive report.
```

**security-auditor.md**
```yaml
---
description: Identifies security vulnerabilities and anti-patterns
capabilities:
  - OWASP Top 10 detection
  - SQL injection analysis
  - XSS vulnerability detection
  - Secrets scanning
  - Authentication issues
---

# Security Auditor

Analyzes codebase for security vulnerabilities...
```

*(Similar structure for other 7 auditors)*

### Execution Flow

```
/audit command
  ↓
audit-orchestrator
  ↓
Spawns 8 agents in PARALLEL
  ├→ security-auditor
  ├→ safety-auditor
  ├→ code-quality-auditor
  ├→ performance-auditor
  ├→ test-coverage-auditor
  ├→ dependency-auditor
  ├→ documentation-auditor
  └→ accessibility-auditor (if web)
  ↓
Aggregate results
  ↓
Prioritize by severity
  ↓
report-generator formats
  ↓
Markdown output to user
```

### Severity Levels

- **🔴 Critical** - Actively exploitable, high impact (fix immediately)
- **🟠 High** - Exploitable with effort, significant impact (fix this sprint)
- **🟡 Medium** - Requires conditions, moderate impact (plan to fix)
- **🟢 Low** - Theoretical risk, minimal impact (track as debt)

### Example Output

```markdown
# Codebase Audit Report

## Executive Summary
- 🔴 Critical: 3
- 🟠 High: 12
- 🟡 Medium: 28
- 🟢 Low: 45

## Security Findings

### 🔴 Critical: SQL Injection Vulnerability
**Location:** `src/api/users.ts:45`
**Severity:** Critical
**Category:** Injection

**Vulnerable Code:**
```javascript
const query = `SELECT * FROM users WHERE id = ${userId}`;
```

**Remediation:**
```javascript
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

**OWASP:** A03:2021 - Injection
**Priority:** Fix immediately

---

### 🟠 High: Missing Input Validation
...
```

### Configuration

```json
{
  "plugins": ["/path/to/codebase-audit"],
  "codebase-audit": {
    "ignore-paths": ["node_modules/", "vendor/", "dist/"],
    "severity-threshold": "medium"
  }
}
```

### plugin.json

```json
{
  "name": "codebase-audit",
  "version": "1.0.0",
  "description": "Multi-dimensional codebase analysis",
  "keywords": ["audit", "security", "quality", "performance"],
  "commands": "./commands/",
  "agents": "./agents/",
  "skills": "./skills/",
  "hooks": "./hooks/hooks.json"
}
```

---

## Plugin 2: Prompt Automation

### Purpose
Ralph Loop automation with intelligent prompt engineering.

### Commands

```bash
/ralph-task-design "<description>" [--type=feature|bug-fix|...]
  # Heavy design phase with Q&A

/ralph-task-refine [--add="X"] [--remove="Y"] [--change="Z"]
  # Modify design

/ralph-task-approve
  # Lock design, generate prompt

/ralph-task-execute [--max-iterations=N]
  # Start Ralph Loop

/ralph-task-status
  # Show progress

/ralph-task-cancel
  # Stop loop
```

### Directory Structure

```
prompt-automation/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── ralph-task-design.md
│   ├── ralph-task-refine.md
│   ├── ralph-task-approve.md
│   ├── ralph-task-execute.md
│   ├── ralph-task-status.md
│   └── ralph-task-cancel.md
├── agents/
│   ├── prompt-engineer.md
│   ├── task-analyzer.md
│   ├── completion-detector.md
│   └── loop-orchestrator.md
├── skills/
│   ├── prompt-patterns/
│   │   ├── SKILL.md
│   │   └── templates/
│   │       ├── feature-development.md
│   │       ├── bug-fix.md
│   │       ├── refactoring.md
│   │       ├── testing.md
│   │       ├── performance-optimization.md
│   │       ├── security-fix.md
│   │       ├── documentation.md
│   │       └── api-development.md
│   ├── completion-criteria/
│   │   ├── SKILL.md
│   │   └── examples/
│   │       └── good-criteria.md
│   └── prompt-optimizer/
│       ├── SKILL.md
│       └── examples/
│           └── refined-prompt.md
├── hooks/
│   ├── hooks.json
│   └── stop-loop.sh
└── README.md
```

### Task Types (8)

1. **Feature Development** - Full template with all sections
2. **Bug Fix** - Context, Root Cause, Test Strategy
3. **Refactoring** - Constraints, Incremental Steps, Rollback
4. **Testing** - Coverage Targets, Test Categories
5. **Performance** - Baseline/Target Metrics, Profiling
6. **Security Fix** - Threat Analysis, Security Testing
7. **Documentation** - Scope, Target Audience, Completeness
8. **API Development** - API Contract, Validation Rules

### Agents

**task-analyzer.md**
```yaml
---
description: Analyzes task descriptions to extract requirements
capabilities:
  - Task classification
  - Requirement extraction
  - Complexity estimation
  - Dependency identification
---

# Task Analyzer

Auto-detects task type and extracts structured requirements.
```

**prompt-engineer.md**
```yaml
---
description: Generates optimal prompts for complex tasks
capabilities:
  - Template selection
  - Requirement structuring
  - Completion criteria definition
  - Architecture design
---

# Prompt Engineer

Creates comprehensive, structured prompts with clear acceptance criteria.
```

**completion-detector.md**
```yaml
---
description: Validates task completion through multiple signals
capabilities:
  - Promise marker detection
  - Test verification
  - Build validation
  - Acceptance criteria checking
---

# Completion Detector

Validates completion via tests, build, git status, and acceptance criteria.
```

**loop-orchestrator.md**
```yaml
---
description: Manages Ralph Loop execution lifecycle
capabilities:
  - Loop initialization
  - State management
  - Progress tracking
  - Auto-validation
  - Auto-continuation on failure
---

# Loop Orchestrator

Manages the complete Ralph Loop workflow with validation.
```

### Workflow

```
User: /ralph-task-design "build todo API"
  ↓
task-analyzer extracts requirements
  ↓
prompt-engineer asks clarifying questions:
  - Database? (PostgreSQL)
  - Authentication? (JWT)
  - Testing framework? (Jest)
  ↓
prompt-engineer designs architecture
  ↓
Generates DESIGN-20260119-143022.md
  ↓
Shows preview to user
  ↓
User: /ralph-task-approve
  ↓
Locks design, generates implementation prompt
  ↓
User: /ralph-task-execute --max-iterations=25
  ↓
Creates .claude-task-state.json
  ↓
┌─────────────────────────────────┐
│ Ralph Loop - Iteration 1        │
│ Read: DESIGN-<timestamp>.md     │
│ Implement based on specs        │
│ Update: .claude-task-state.json │
└─────────────────────────────────┘
  ↓
Stop hook intercepts exit
  ↓
Check for <promise>COMPLETE</promise>
  ↓
Not found → Re-inject prompt (iteration++)
  ↓
┌─────────────────────────────────┐
│ Ralph Loop - Iteration 2        │
│ See previous work in files      │
│ Continue implementation         │
└─────────────────────────────────┘
  ↓
... continues ...
  ↓
<promise>COMPLETE</promise> detected
  ↓
Run validation:
  ✓ npm test
  ✓ npm run build
  ✓ git status
  ✓ Parse acceptance criteria from DESIGN file
  ↓
All pass? → Complete ✅
Any fail? → Auto-continue loop 🔄
```

### File Artifacts

**DESIGN-<timestamp>.md** (visible, kept)
```markdown
# Task Design: Todo API
Generated: 2026-01-19

## Context
Building REST API for todo management with CRUD operations.
Existing codebase uses Express.js + TypeScript.

## Goals
- Primary: Complete REST API with all CRUD operations
- Secondary: JWT authentication for user isolation

## Requirements
### Functional
- POST /api/todos - Create todo
- GET /api/todos - List all todos
- GET /api/todos/:id - Get single todo
- PUT /api/todos/:id - Update todo
- DELETE /api/todos/:id - Delete todo

### Non-Functional
- Input validation on all endpoints
- Error handling with proper HTTP codes
- JSON response format
- JWT authentication

## Technical Approach
- **Framework:** Express.js
- **Language:** TypeScript
- **Database:** PostgreSQL with Prisma ORM
- **Auth:** JWT via jsonwebtoken
- **Testing:** Jest + Supertest
- **Validation:** Joi schemas

## Implementation Tasks
1. Setup project structure and dependencies
2. Define Prisma schema for Todo model
3. Implement authentication middleware
4. Create POST /api/todos endpoint
5. Create GET /api/todos endpoint
6. Create GET /api/todos/:id endpoint
7. Create PUT /api/todos/:id endpoint
8. Create DELETE /api/todos/:id endpoint
9. Add input validation middleware
10. Write unit tests for each endpoint
11. Write integration tests
12. Generate OpenAPI documentation

## Acceptance Criteria
- [ ] All 5 CRUD endpoints implemented
- [ ] JWT authentication working
- [ ] Input validation prevents invalid data
- [ ] Unit tests passing (coverage > 80%)
- [ ] Integration tests passing
- [ ] Error handling returns proper HTTP codes
- [ ] OpenAPI docs generated
- [ ] README updated with API examples

## Validation Checks
```bash
npm test
npm run coverage
npm run build
npm run lint
```

## Completion Conditions
When ALL of the following are true:
- All acceptance criteria checked
- All validation checks pass
- Git status clean (changes committed)
- Documentation complete

Output: <promise>API_COMPLETE</promise>

## Edge Cases & Error Handling
- **Empty todo title** → Return 400 with error message
- **Invalid todo ID** → Return 404 with helpful message
- **Unauthorized access** → Return 401 with auth error
- **Database connection failure** → Return 500, log error

## Rollback Plan
If deployment fails:
1. Revert to previous git tag
2. Run database migration rollback: `npx prisma migrate reset`
3. Restore from backup if data corrupted
```

**.claude-task-state.json** (hidden, deleted after)
```json
{
  "designFile": "DESIGN-20260119-143022.md",
  "currentIteration": 5,
  "maxIterations": 25,
  "completionPromise": "API_COMPLETE",
  "status": "executing",
  "validation": {
    "lastCheck": "2026-01-19T14:35:00Z",
    "testsPass": true,
    "buildSucceeds": true,
    "gitClean": false,
    "acceptanceCriteria": [
      {"item": "All CRUD endpoints", "complete": true},
      {"item": "JWT authentication", "complete": true},
      {"item": "Tests >80%", "complete": false}
    ]
  }
}
```

### Validation Strategy

When `<promise>` marker detected:
1. **Tests** → Run `npm test` / `pytest` / `cargo test`
2. **Build** → Run `npm run build` / `cargo build`
3. **Git** → Check all changes committed
4. **Acceptance Criteria** → Parse from DESIGN file, verify each item

**If all pass:** Task complete ✅
**If any fail:** Auto-continue loop to fix issues 🔄

### Stop Hook

**hooks/stop-loop.sh**
```bash
#!/bin/bash
# Ralph Loop Stop Hook

if [ ! -f ".claude-task-state.json" ]; then
  exit 0
fi

DESIGN_FILE=$(jq -r '.designFile' .claude-task-state.json)
CURRENT=$(jq -r '.currentIteration' .claude-task-state.json)
MAX=$(jq -r '.maxIterations' .claude-task-state.json)
PROMISE=$(jq -r '.completionPromise' .claude-task-state.json)

# Check for completion promise
if grep -q "<promise>${PROMISE}</promise>" output.log 2>/dev/null; then
  # Run validation
  npm test && npm run build
  if [ $? -eq 0 ]; then
    echo "✅ Task complete!"
    rm .claude-task-state.json
    exit 0
  else
    echo "⚠️ Validation failed, continuing..."
  fi
fi

# Check max iterations
if [ $CURRENT -ge $MAX ]; then
  echo "⚠️ Max iterations reached"
  rm .claude-task-state.json
  exit 0
fi

# Increment and continue
CURRENT=$((CURRENT + 1))
jq ".currentIteration = $CURRENT" .claude-task-state.json > tmp.json
mv tmp.json .claude-task-state.json

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Iteration $CURRENT/$MAX"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Re-inject prompt
cat "$DESIGN_FILE"

exit 1  # Block exit to continue loop
```

### Configuration

```json
{
  "plugins": ["/path/to/prompt-automation"],
  "prompt-automation": {
    "default-max-iterations": 25,
    "auto-update-design": true,
    "validation": {
      "tests": true,
      "build": true,
      "git-clean": true,
      "lint": false
    }
  }
}
```

### plugin.json

```json
{
  "name": "prompt-automation",
  "version": "1.0.0",
  "description": "Ralph Loop automation with intelligent prompt engineering",
  "keywords": ["ralph-loop", "automation", "prompt", "iteration"],
  "commands": "./commands/",
  "agents": "./agents/",
  "skills": "./skills/",
  "hooks": "./hooks/hooks.json"
}
```

---

## Plugin 3: PR Learner

### Purpose
Learns from PR review patterns to suggest improvements to CLAUDE.md, agent skills, commands, and workflows.

### Command

```bash
/pr-learn [--count=10] [--since=7d]
  # Analyzes recent merged PRs
  # Outputs suggestions in conversation (no files)
```

### Directory Structure

```
pr-learner/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   └── pr-learn.md
├── agents/
│   ├── pr-analysis-orchestrator.md
│   ├── pr-reader.md
│   ├── pattern-detector.md
│   ├── claude-md-suggester.md
│   ├── skill-optimizer.md
│   ├── command-ideator.md
│   └── workflow-advisor.md
├── skills/
│   ├── pattern-matching/
│   │   ├── SKILL.md
│   │   └── examples/
│   │       ├── code-quality-patterns.md
│   │       ├── security-patterns.md
│   │       └── style-patterns.md
│   ├── claude-md-generator/
│   │   ├── SKILL.md
│   │   └── templates/
│   │       ├── coding-standard.md
│   │       ├── security-requirement.md
│   │       └── testing-requirement.md
│   ├── skill-enhancement/
│   │   ├── SKILL.md
│   │   └── examples/
│   │       └── skill-update-example.md
│   ├── command-design/
│   │   ├── SKILL.md
│   │   └── templates/
│   │       └── command-template.md
│   └── workflow-optimization/
│       ├── SKILL.md
│       └── examples/
│           ├── git-hooks.md
│           ├── ci-checks.md
│           └── pre-commit.md
├── hooks/
│   └── hooks.json
└── README.md
```

### Data Sources

- **PR Comments** - Review comments, inline comments, discussions
- **Code Changes** - Diffs, file patterns, commit messages
- **PR Metadata** - Labels, reviewers, merge status
- **Platform** - GitHub only (MVP, via `gh` CLI)
- **Scope** - Recent merged PRs only (complete feedback cycle)

### Agents

**pr-analysis-orchestrator.md**
```yaml
---
description: Coordinates PR analysis and suggestion generation
capabilities:
  - Agent coordination
  - Result aggregation
  - Suggestion categorization
  - Priority ranking
auto_invoke: true
---

# PR Analysis Orchestrator

Coordinates all PR learning agents and generates comprehensive suggestions.
```

**pr-reader.md**
```yaml
---
description: Fetches PR data from GitHub
capabilities:
  - PR fetching via gh CLI
  - Comment extraction
  - Diff parsing
  - Metadata collection
---

# PR Reader

Uses `gh` CLI to fetch merged PR data including comments and code changes.
```

**pattern-detector.md**
```yaml
---
description: Identifies recurring patterns via semantic clustering
capabilities:
  - Semantic comment clustering
  - Pattern frequency analysis
  - Impact assessment
  - Confidence scoring
---

# Pattern Detector

Uses AI to cluster similar feedback and identify recurring themes.

## Pattern Detection

Analyzes PR comments using semantic clustering:
1. Collect all review comments
2. Use LLM to cluster similar feedback
3. Identify recurring themes
4. Rank by frequency and impact
5. Generate human-readable patterns

**Example:**
```
Comments:
- "This function is too complex"
- "Can you simplify this?"
- "Break this into smaller functions"

→ Clusters as: "Function complexity" pattern
→ Frequency: 3 occurrences
→ Suggests: Add CLAUDE.md rule about max function length
```
```

**claude-md-suggester.md**
```yaml
---
description: Generates CLAUDE.md additions from patterns
capabilities:
  - Rule generation
  - Example creation
  - Rationale writing
  - Evidence linking
---

# CLAUDE.md Suggester

Creates ready-to-apply CLAUDE.md additions with examples and rationale.
```

**skill-optimizer.md**
```yaml
---
description: Suggests agent skill improvements
capabilities:
  - Skill gap analysis
  - Pattern mapping to skills
  - Enhancement recommendations
---

# Skill Optimizer

Identifies which agent skills should be enhanced based on patterns.
```

**command-ideator.md**
```yaml
---
description: Proposes new command ideas
capabilities:
  - Task automation identification
  - Command design
  - Use case definition
---

# Command Ideator

Suggests new commands to automate recurring manual tasks.
```

**workflow-advisor.md**
```yaml
---
description: Recommends workflow improvements
capabilities:
  - Git hook suggestions
  - CI/CD enhancements
  - Pre-commit checks
  - Automation opportunities
---

# Workflow Advisor

Suggests workflow improvements like hooks, CI checks, automation.
```

### Workflow

```
User: /pr-learn --count=10

  ↓
pr-analysis-orchestrator
  ↓
pr-reader fetches last 10 merged PRs via gh CLI
  ├→ PR comments
  ├→ Code diffs
  └→ Metadata
  ↓
pattern-detector analyzes with semantic clustering
  ├→ Groups similar comments
  ├→ Identifies themes
  └→ Ranks by frequency
  ↓
Parallel suggestion generation:
  ├→ claude-md-suggester (CLAUDE.md additions)
  ├→ skill-optimizer (skill improvements)
  ├→ command-ideator (new command ideas)
  └→ workflow-advisor (workflow improvements)
  ↓
Aggregate and categorize suggestions
  ↓
Output in conversation with expandable evidence
  ↓
User: "Apply suggestion 1 to CLAUDE.md"
  ↓
Claude uses Edit tool to update .claude/CLAUDE.md
```

### Example Output

```markdown
📊 Analyzing last 10 merged PRs...
✓ Fetched 10 PRs
✓ Extracted 47 review comments
✓ Analyzed code changes
✓ Detected 8 recurring patterns

Found 12 improvement opportunities

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🔒 Security Improvements (2)

### 1. SQL Query Parameterization
**Priority:** 🔴 CRITICAL | **Confidence:** High | **Occurrences:** 3

**Recommendation:**
Add to CLAUDE.md:

## Database Security
Always use parameterized queries for SQL operations.

**Why:** Prevents SQL injection vulnerabilities.

**Example:**
```javascript
// ❌ Bad
const query = `SELECT * FROM users WHERE id = ${userId}`;

// ✅ Good
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

<details>
<summary><b>📊 Show Evidence</b></summary>

### Evidence Details
- **PR #127**: "This is vulnerable to SQL injection"
  - File: `src/api/users.ts:45`
  - Reviewer: @security-reviewer
  - [View PR](https://github.com/org/repo/pull/127)

- **PR #129**: "Use parameterized queries here"
  - File: `src/db/queries.ts:23`
  - Reviewer: @tech-lead
  - [View PR](https://github.com/org/repo/pull/129)

- **PR #131**: "Same SQL injection issue again"
  - File: `src/api/posts.ts:67`
  - Reviewer: @security-reviewer
  - [View PR](https://github.com/org/repo/pull/131)

### Pattern Analysis
- Detected across 3 PRs over 14 days
- Mentioned by 2 different reviewers
- Related files: 3 (all in API layer)
</details>

---

### 2. Input Validation
**Priority:** 🟠 HIGH | **Confidence:** Medium | **Occurrences:** 2

**Recommendation:**
Add to CLAUDE.md:

## API Security
Validate all API inputs with schema validation.

**Why:** Prevents injection attacks and data corruption.

**Example:**
```javascript
// ✅ Good
const schema = Joi.object({
  email: Joi.string().email().required(),
  age: Joi.number().min(0).max(150)
});
const { error } = schema.validate(req.body);
if (error) return res.status(400).send(error);
```

<details>
<summary><b>📊 Show Evidence</b></summary>

- **PR #124**: "Add input validation"
- **PR #128**: "Missing validation on this endpoint"
</details>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 📐 Code Quality Improvements (5)

### 3. Use const over let
**Priority:** 🟡 MEDIUM | **Confidence:** High | **Occurrences:** 8

**Recommendation:**
Add to CLAUDE.md:

## Code Style
Use `const` for variables that don't change, `let` only when reassignment needed.

**Example:**
```javascript
// ❌ Bad
let userId = user.id;
let userName = user.name;

// ✅ Good
const userId = user.id;
const userName = user.name;
```

<details>
<summary><b>📊 Show Evidence</b></summary>

8 occurrences across PRs #123, #125, #130, #132, #134, #136, #138, #140
</details>

---

### 4. Function Complexity
**Priority:** 🟡 MEDIUM | **Confidence:** High | **Occurrences:** 4

**Recommendation:**
Add to CLAUDE.md:

## Code Quality
Keep functions focused. Max 50 lines per function.
Extract complex logic into named helper functions.

**Example:**
```javascript
// ❌ Bad - 80 line function doing many things

// ✅ Good - Break into smaller functions
function processOrder(order) {
  validateOrder(order);
  calculateTotal(order);
  applyDiscounts(order);
  saveToDatabase(order);
}
```

<details>...</details>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🤖 Agent Skill Improvements (3)

### 5. Enhance security-auditor
**Priority:** 🟠 HIGH | **Confidence:** High

**Recommendation:**
Update `security-auditor` skill to detect SQL injection patterns:

Add to detection patterns:
- String concatenation in SQL queries
- Missing parameterization
- Direct variable interpolation in queries

**Rationale:** 3 SQL injection issues caught in code review that could have been caught by automated audit.

---

### 6. Enhance code-quality-auditor
**Priority:** 🟡 MEDIUM | **Confidence:** Medium

**Recommendation:**
Update `code-quality-auditor` to detect overly complex functions:

Add cyclomatic complexity check:
- Flag functions > 50 lines
- Flag functions with > 10 branches
- Suggest extraction

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 💡 New Command Ideas (2)

### 7. /auto-format command
**Priority:** 🟡 MEDIUM | **Confidence:** High

**Suggestion:**
Create a command that automatically fixes common style issues:
- const/let corrections
- Trailing commas
- Indentation
- Import sorting

**Rationale:** 12 formatting comments across 6 PRs. Manual fix time: ~15min per PR.

**Estimated Impact:** Saves 90min+ per sprint in review time.

---

### 8. /security-check command
**Priority:** 🟠 HIGH | **Confidence:** Medium

**Suggestion:**
Create a quick security pre-commit check:
- SQL injection patterns
- Hardcoded secrets
- Unsafe eval usage
- Missing input validation

**Rationale:** 4 security issues caught in review that could be caught pre-commit.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

## 🔧 Workflow Improvements (2)

### 9. Add pre-commit linting hook
**Priority:** 🟡 MEDIUM | **Confidence:** High

**Suggestion:**
Add git pre-commit hook to run linter automatically:

```bash
#!/bin/bash
# .git/hooks/pre-commit
npm run lint
if [ $? -ne 0 ]; then
  echo "Linting failed. Fix errors before committing."
  exit 1
fi
```

**Rationale:** 10 linting issues across 7 PRs caught in review.

---

### 10. Add CI test coverage check
**Priority:** 🟠 HIGH | **Confidence:** High

**Suggestion:**
Add CI check that fails if test coverage < 80%:

```yaml
# .github/workflows/ci.yml
- name: Check coverage
  run: |
    npm run coverage
    if [ $(jq '.total.lines.pct' coverage/coverage-summary.json | cut -d. -f1) -lt 80 ]; then
      echo "Coverage below 80%"
      exit 1
    fi
```

**Rationale:** 3 PRs merged with insufficient test coverage.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Would you like me to apply any of these suggestions?

Examples:
- "Apply suggestion 1 to CLAUDE.md"
- "Apply all security suggestions"
- "Update security-auditor with suggestion 5"
- "Show me more detail on suggestion 7"
```

### User Application Workflow

```
User: "Apply suggestion 1 to CLAUDE.md"

Claude:
  ✓ Reading .claude/CLAUDE.md
  ✓ Adding SQL parameterization rule

  Added to .claude/CLAUDE.md:

  ## Database Security
  Always use parameterized queries for SQL operations.

  **Why:** Prevents SQL injection vulnerabilities.

  **Example:**
  ```javascript
  // ❌ Bad
  const query = `SELECT * FROM users WHERE id = ${userId}`;

  // ✅ Good
  const query = 'SELECT * FROM users WHERE id = ?';
  db.query(query, [userId]);
  ```

  Done! ✅

---

User: "Apply suggestions 3 and 4 as well"

Claude:
  ✓ Reading .claude/CLAUDE.md
  ✓ Adding const/let style rule
  ✓ Adding function complexity rule

  Added 2 more rules to CLAUDE.md ✅

---

User: "Update security-auditor with suggestion 5"

Claude:
  ✓ Reading agents/security-auditor.md
  ✓ Adding SQL injection detection patterns

  Updated security-auditor agent with:
  - String concatenation detection in SQL
  - Missing parameterization checks
  - Variable interpolation warnings

  Done! ✅
```

### Configuration

```json
{
  "plugins": ["/path/to/pr-learner"],
  "pr-learner": {
    "default-pr-count": 10,
    "default-lookback-days": 7,
    "min-pattern-occurrences": 2,
    "confidence-threshold": "medium"
  }
}
```

### plugin.json

```json
{
  "name": "pr-learner",
  "version": "1.0.0",
  "description": "Learn from PR patterns to improve workflows",
  "keywords": ["pr", "learning", "workflow", "improvement"],
  "commands": "./commands/",
  "agents": "./agents/",
  "skills": "./skills/",
  "hooks": "./hooks/hooks.json"
}
```

---

## Cross-Plugin Conventions

### File Naming
- **kebab-case** for all files: `security-auditor.md`
- **UPPERCASE** for special files: `SKILL.md`, `README.md`
- **No timestamps** in filenames (except DESIGN files in prompt-automation)

### Agent Frontmatter
```yaml
---
description: One-line description of agent purpose
capabilities:
  - Capability 1
  - Capability 2
  - Capability 3
auto_invoke: true  # Optional, defaults to true
---
```

### Skill Structure
```
skill-name/
├── SKILL.md              # Main instructions (required)
├── templates/            # Optional templates
│   └── template.md
└── examples/             # Optional examples
    └── example.md
```

### Hooks Configuration
Minimal hooks only:
```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [{
          "type": "prompt",
          "prompt": "Guidance for this plugin..."
        }]
      }
    ]
  }
}
```

### Command Prefixes
- **codebase-audit:** `/audit-*`
- **prompt-automation:** `/ralph-task-*`
- **pr-learner:** `/pr-learn-*`

### Configuration Pattern
```json
{
  "plugins": [
    "/path/to/plugin1",
    "/path/to/plugin2"
  ],
  "plugin-name": {
    "option1": "value1",
    "option2": true
  }
}
```

---

## Implementation Roadmap

### Phase 1: Foundation (Week 1)
- [ ] Create all directory structures
- [ ] Write all plugin.json files
- [ ] Create all README.md files
- [ ] Set up hooks.json files

### Phase 2: Codebase Audit (Week 2)
- [ ] Implement audit-orchestrator agent
- [ ] Implement 8 audit agents
- [ ] Create report-generator skill
- [ ] Build 5 audit commands
- [ ] Test with sample projects

### Phase 3: Prompt Automation (Week 3)
- [ ] Implement 4 core agents
- [ ] Create 8 task type templates
- [ ] Build Ralph Loop stop hook
- [ ] Implement 6 commands
- [ ] Test with sample tasks

### Phase 4: PR Learner (Week 4)
- [ ] Implement pr-analysis-orchestrator
- [ ] Implement 6 specialized agents
- [ ] Create 5 comprehensive skills
- [ ] Build pr-learn command
- [ ] Test with real repositories

### Phase 5: Integration & Testing (Week 5)
- [ ] End-to-end testing all plugins
- [ ] Cross-plugin workflow testing
- [ ] Performance optimization
- [ ] Bug fixes

### Phase 6: Documentation & Launch (Week 6)
- [ ] Complete user documentation
- [ ] Video tutorials
- [ ] Example workflows
- [ ] Launch announcement

---

## Success Metrics

### Codebase Audit
- ✅ Reduces manual audit time by 80%+
- ✅ Catches 95%+ of common vulnerabilities
- ✅ All findings include actionable remediation
- ✅ Ready for CI/CD integration

### Prompt Automation
- ✅ Reduces prompt crafting time by 70%+
- ✅ Increases task completion rate
- ✅ Auto-validates work quality
- ✅ Handles complex multi-step tasks

### PR Learner
- ✅ Identifies 10+ actionable improvements per 10 PRs
- ✅ Reduces recurring review comments by 50%+
- ✅ Improves team coding standards
- ✅ Automates workflow improvements

---

**Design Status:** Complete ✅
**Plugins:** 3 (codebase-audit, prompt-automation, pr-learner)
**Ready for Implementation:** Yes ✅
**Next Step:** Begin scaffolding all three plugins
