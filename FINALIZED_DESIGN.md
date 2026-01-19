# Claude Code Plugins - Finalized Design Document

**Date:** 2026-01-18
**Status:** Design Complete - Ready for Implementation

---

## Overview

This document contains the finalized design for three Claude Code plugins:

1. **codebase-audit** - Multi-dimensional codebase analysis
2. **prompt-automation** - Ralph Loop task automation
3. **workflow-optimizer** - PR-based learning and improvement suggestions

---

## Design Decisions Summary

### Architectural Decisions
- ✅ **Three separate plugins** (not unified)
- ✅ **Agent-based architecture** (multiple specialized agents)
- ✅ **Parallel agent execution** (all agents run simultaneously)
- ✅ **Convention over configuration** (minimal config, smart defaults)
- ✅ **Hybrid skills** (instructions + resources)
- ✅ **Minimal hooks** (essential only)

### Key Configurations
- ✅ **Severity levels**: Critical, High, Medium, Low (4 levels)
- ✅ **Output format**: Markdown only for MVP
- ✅ **Validation**: All checks (tests, build, git, acceptance criteria)
- ✅ **Design updates**: Auto-update by default (configurable)
- ✅ **Template enforcement**: Flexible (warnings, not errors)

### Naming Conventions
- ✅ **Commands**: Prefixed (`/audit-*`, `/ralph-task-*`, `/workflow-*`)
- ✅ **Files**: kebab-case (e.g., `security-auditor.md`)
- ✅ **Agents**: Minimal frontmatter (description + capabilities)
- ✅ **Design files**: `DESIGN-<timestamp>.md` (visible, kept)
- ✅ **State files**: `.claude-task-state.json` (hidden, deleted after)

---

## Plugin 1: Codebase Audit

### Purpose
Comprehensive multi-dimensional codebase analysis using specialized sub-agents.

### Commands (`/audit-*`)
```bash
/audit [scope] [--format=markdown] [--severity=low]
  # Scope: all|security|quality|performance|tests|deps|docs|safety|a11y

/audit-security [--deep]
  # Security-focused scan

/audit-quality [--metrics]
  # Code quality analysis with optional metrics

/audit-report [--output=path]
  # Generate comprehensive report file

/audit-status
  # Show active audit progress
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
│       └── SKILL.md
├── hooks/
│   └── hooks.json
└── README.md
```

### Audit Dimensions (8 Total)
1. **Security** - OWASP Top 10, vulnerabilities, secrets
2. **Safety** - Error handling, edge cases, failure modes
3. **Code Quality** - Complexity, smells, patterns, tech debt
4. **Performance** - Bottlenecks, N+1 queries, memory leaks
5. **Test Coverage** - Coverage %, test quality, gaps
6. **Dependencies** - CVEs, outdated packages
7. **Documentation** - Completeness, accuracy
8. **Accessibility** - WCAG 2.1 (conditional on web projects)

### Agent Frontmatter Format
```yaml
---
description: Brief description of what agent does
capabilities:
  - Capability 1
  - Capability 2
  - Capability 3
auto_invoke: true
---
```

### Execution Flow
```
/audit command
  ↓
audit-orchestrator spawns 8 agents in PARALLEL
  ↓
Agents analyze codebase independently
  ↓
Results aggregated by orchestrator
  ↓
Findings prioritized by severity
  ↓
report-generator formats output
  ↓
Markdown report returned to user
```

### Severity Levels
- **Critical** - Actively exploitable, high impact (fix immediately)
- **High** - Exploitable with effort, significant impact (fix this sprint)
- **Medium** - Requires conditions, moderate impact (plan to fix)
- **Low** - Theoretical risk, minimal impact (track as debt)

### Configuration
```json
// .claude/settings.json
{
  "plugins": ["/path/to/codebase-audit"],
  "codebase-audit": {
    "ignore-paths": ["node_modules/", "vendor/"],
    "severity-threshold": "medium"
  }
}
```

---

## Plugin 2: Prompt Automation (Ralph Loop)

### Purpose
Intelligent prompt engineering and Ralph Loop automation for iterative task execution.

### Commands (`/ralph-task-*`)
```bash
/ralph-task-design "<description>" [--type=feature|bug-fix|...]
  # Heavy design phase with questions and architecture

/ralph-task-refine [--add="X"] [--remove="Y"] [--change="Z"]
  # Modify design before locking in

/ralph-task-approve
  # Lock design and generate implementation prompt

/ralph-task-execute [--max-iterations=N]
  # Start Ralph Loop with locked design
  # Auto-validates on completion, continues if needed

/ralph-task-status
  # Show current task, iteration, progress

/ralph-task-cancel
  # Stop active loop gracefully
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
│       └── SKILL.md
├── hooks/
│   ├── hooks.json
│   └── stop-loop.sh
├── templates/
│   └── completion-promises/
│       └── standard-promises.json
└── README.md
```

### Task Types (8 Total)
1. **Feature Development** - Full: Context, Goals, Requirements, Technical Approach, Tasks, Acceptance, Validation, Completion, Edge Cases, Rollback
2. **Bug Fix** - Context, Goals, Root Cause, Tasks, Test Strategy, Acceptance, Validation, Completion
3. **Refactoring** - Context, Goals, Constraints, Tasks, Validation, Rollback, Completion
4. **Testing** - Goals, Coverage Targets, Test Categories, Tasks, Acceptance, Validation, Completion
5. **Performance** - Context, Goals, Baseline Metrics, Target Metrics, Profiling, Tasks, Benchmarks, Completion
6. **Security Fix** - Context, Threat Analysis, Goals, Security Requirements, Tasks, Security Testing, Completion
7. **Documentation** - Goals, Documentation Scope, Target Audience, Tasks, Completeness Checklist, Completion
8. **API Development** - Context, Goals, API Contract, Validation Rules, Error Responses, Tasks, API Testing, Documentation, Completion

### Workflow
```
User: /ralph-task-design "build todo API"
  ↓
task-analyzer extracts requirements
  ↓
prompt-engineer asks clarifying questions
  ↓
User answers questions
  ↓
prompt-engineer designs architecture
  ↓
Generates DESIGN-<timestamp>.md
  ↓
User: /ralph-task-approve
  ↓
Generates implementation prompt
  ↓
User: /ralph-task-execute
  ↓
Creates .claude-task-state.json
  ↓
┌─────────────────────────────┐
│ Ralph Loop Iteration 1      │
│ - Read DESIGN file          │
│ - Implement based on specs  │
│ - Update state file         │
└─────────────────────────────┘
  ↓
Stop hook intercepts exit
  ↓
Re-inject prompt (iteration++)
  ↓
┌─────────────────────────────┐
│ Ralph Loop Iteration 2      │
│ - See previous work         │
│ - Continue implementation   │
└─────────────────────────────┘
  ↓
... continues ...
  ↓
<promise>COMPLETE</promise> found
  ↓
Run validation checks:
  ✓ Tests passing
  ✓ Build succeeds
  ✓ Git status clean
  ✓ Acceptance criteria met
  ↓
If all pass: Complete ✅
If any fail: Auto-continue loop 🔄
```

### File Artifacts
**DESIGN-<timestamp>.md** (visible, kept)
```markdown
# Task Design: Todo API
Generated: 2026-01-18

## Context
[Background and existing state]

## Goals
- Primary: Build REST API for todos
- Secondary: Add authentication

## Requirements
### Functional
- POST /api/todos
- GET /api/todos
...

## Technical Approach
- Stack: Express.js + TypeScript + PostgreSQL
...

## Implementation Tasks
1. Setup project structure
2. Implement endpoints
...

## Acceptance Criteria
- [ ] All CRUD endpoints working
- [ ] Tests passing (>80% coverage)
...

## Completion Promise
<promise>API_COMPLETE</promise>
```

**.claude-task-state.json** (hidden, deleted after)
```json
{
  "designFile": "DESIGN-20260118-143022.md",
  "currentIteration": 5,
  "maxIterations": 25,
  "completionPromise": "API_COMPLETE",
  "status": "executing",
  "validation": {
    "testsPass": true,
    "buildSucceeds": true,
    "gitClean": false,
    "acceptanceCriteria": [
      {"item": "All CRUD endpoints", "complete": true},
      {"item": "Tests >80%", "complete": false}
    ]
  }
}
```

### Validation Strategy
When `<promise>` marker detected, run all checks:
1. **Tests** - `npm test` / `pytest` / `cargo test`
2. **Build** - `npm run build` / `cargo build`
3. **Git** - All changes committed
4. **Acceptance Criteria** - Parse from DESIGN file, verify each

If any fail → Auto-continue loop
If all pass → Task complete ✅

### Configuration
```json
// .claude/settings.json
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

### Stop Hook (hooks/stop-loop.sh)
```bash
#!/bin/bash
# Ralph Loop Stop Hook

# Check if loop is active
if [ ! -f ".claude-task-state.json" ]; then
  exit 0
fi

# Load state
DESIGN_FILE=$(jq -r '.designFile' .claude-task-state.json)
CURRENT=$(jq -r '.currentIteration' .claude-task-state.json)
MAX=$(jq -r '.maxIterations' .claude-task-state.json)
PROMISE=$(jq -r '.completionPromise' .claude-task-state.json)

# Check for completion
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

echo "🔄 Iteration $CURRENT/$MAX"
cat "$DESIGN_FILE"

# Block exit to continue loop
exit 1
```

---

## Skill Structure (Both Plugins)

### Format: Hybrid (Instructions + Resources)

**Example: report-generator skill**
```
skills/
└── report-generator/
    ├── SKILL.md              # Main instructions
    ├── templates/            # Optional templates
    │   └── audit-report.md
    └── examples/             # Optional examples
        └── good-report.md
```

**SKILL.md format:**
```markdown
---
name: report-generator
description: Generates professional audit reports
resources:
  - templates/audit-report.md
  - examples/good-report.md
---

# Report Generator Skill

## What This Skill Does
Transforms audit findings into professional reports.

## When To Use
After all audit agents complete.

## Instructions
1. Collect findings from all agents
2. Sort by severity
3. Use template for structure
4. Format with examples as reference

## Available Templates
See `templates/audit-report.md` for structure.

## Examples
See `examples/good-report.md` for quality reference.
```

---

## Hooks Configuration

### Codebase Audit (hooks/hooks.json)
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
    ]
  }
}
```

### Prompt Automation (hooks/hooks.json)
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

---

## Implementation Roadmap

### Phase 1: Foundation (Week 1)
- [ ] Create directory structures
- [ ] Write plugin.json files
- [ ] Create README files
- [ ] Set up hooks.json

### Phase 2: Codebase Audit (Week 2-3)
- [ ] Implement audit-orchestrator
- [ ] Implement 8 audit agents
- [ ] Create report-generator skill
- [ ] Build audit commands
- [ ] Test with sample projects

### Phase 3: Prompt Automation (Week 3-4)
- [ ] Implement task-analyzer agent
- [ ] Implement prompt-engineer agent
- [ ] Create 8 task type templates
- [ ] Build Ralph Loop stop hook
- [ ] Implement loop-orchestrator
- [ ] Test with sample tasks

### Phase 4: Integration & Testing (Week 5)
- [ ] End-to-end testing
- [ ] Performance optimization
- [ ] Documentation
- [ ] Example use cases

### Phase 5: Polish & Launch (Week 6)
- [ ] Bug fixes
- [ ] User documentation
- [ ] Video tutorials
- [ ] Release

---

## Success Metrics

### Codebase Audit
- Reduces manual audit time by 80%+
- Catches 95%+ of common vulnerabilities
- Provides actionable recommendations
- Integrates with CI/CD

### Prompt Automation
- Reduces prompt crafting time by 70%+
- Increases task completion rate
- Handles complex multi-step tasks
- Auto-validates work quality

---

## Future Enhancements

### Codebase Audit
- Real-time monitoring mode
- IDE integration
- Automated fix generation
- Industry benchmark comparisons
- Additional output formats (JSON, HTML, SARIF, PDF)

### Prompt Automation
- Multi-agent orchestration
- Prompt A/B testing
- Natural language task parsing
- Project management integration
- Historical prompt library
- Learning from successful/failed prompts

---

**Design Status: Complete ✅**
**Ready for Implementation: Yes ✅**
**Next Step: Begin scaffolding**
