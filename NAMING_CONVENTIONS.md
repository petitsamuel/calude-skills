# Claude Code Plugins - Naming Conventions & Best Practices

## Plugin Naming

### Plugin Names (kebab-case)
- Use descriptive, hyphenated names
- Keep names concise but clear
- Avoid generic names

**Good Examples:**
- `codebase-audit`
- `prompt-automation`
- `security-scanner`
- `test-coverage-analyzer`

**Bad Examples:**
- `plugin1` (not descriptive)
- `CodebaseAudit` (wrong case)
- `codebase_audit` (wrong separator)
- `the-best-audit-plugin-ever` (too long)

---

## File & Directory Naming

### Directories
- Use kebab-case for consistency
- Keep names singular unless collection
- Be specific about purpose

```
✓ commands/
✓ agents/
✓ skills/
✓ hooks/
✓ templates/
✓ scripts/

✗ Commands/
✗ agent/
✗ skill-files/
```

### Files

**Markdown Files** (kebab-case)
```
✓ security-auditor.md
✓ prompt-engineer.md
✓ full-report.md

✗ SecurityAuditor.md
✗ promptEngineer.md
✗ full_report.md
```

**JSON/Script Files** (kebab-case)
```
✓ plugin.json
✓ hooks.json
✓ collect-metrics.sh
✓ severity-levels.json

✗ pluginConfig.json
✗ Hooks.json
✗ collect_metrics.sh
```

**Template Files** (kebab-case)
```
✓ feature-development.md
✓ security-report.md
✓ bug-fix.md

✗ featureDevelopment.md
✗ SecurityReport.md
```

---

## Agent Naming

### Agent File Names
Use descriptive names ending with purpose/role:

**Pattern:** `<domain>-<role>.md`

**Examples:**
```
✓ security-auditor.md
✓ code-quality-auditor.md
✓ prompt-engineer.md
✓ task-analyzer.md
✓ audit-orchestrator.md
✓ completion-detector.md
✓ loop-orchestrator.md

✗ security.md (not specific enough)
✗ auditor.md (too generic)
✗ engineer-agent.md (redundant)
```

### Agent Roles Taxonomy

**Orchestrators:** Coordinate other agents
- `audit-orchestrator.md`
- `loop-orchestrator.md`
- `workflow-orchestrator.md`

**Analyzers:** Examine and report on code/data
- `task-analyzer.md`
- `dependency-analyzer.md`
- `performance-analyzer.md`

**Auditors:** Evaluate against standards
- `security-auditor.md`
- `quality-auditor.md`
- `accessibility-auditor.md`

**Engineers:** Generate or transform content
- `prompt-engineer.md`
- `test-engineer.md`
- `refactor-engineer.md`

**Detectors:** Identify patterns or conditions
- `completion-detector.md`
- `vulnerability-detector.md`
- `regression-detector.md`

**Reviewers:** Provide feedback and recommendations
- `code-reviewer.md`
- `design-reviewer.md`
- `documentation-reviewer.md`

---

## Command Naming

### Command File Names (kebab-case)
```
✓ audit.md
✓ security-audit.md
✓ full-report.md
✓ auto-prompt.md
✓ start-loop.md
✓ cancel-loop.md

✗ doAudit.md
✗ SecurityAudit.md
✗ full_report.md
```

### Command Invocation Names
Use slash prefix with kebab-case:

```
✓ /audit
✓ /security-audit
✓ /full-report
✓ /auto-prompt
✓ /start-loop

✗ /auditCode
✗ /security_audit
✗ /fullReport
```

### Command Argument Naming

Use full words with hyphens for flags:

```bash
✓ /audit --format=json
✓ /audit --severity=high
✓ /start-loop --max-iterations=30
✓ /full-report --output=./report.md

✗ /audit -f json (too cryptic)
✗ /audit --fmt=json (abbreviation)
✗ /start-loop --maxIter=30 (camelCase)
```

---

## Skill Naming

### Skill Directory Names
Use descriptive, hyphenated names:

```
✓ report-generator/
✓ issue-prioritizer/
✓ prompt-patterns/
✓ completion-criteria/
✓ prompt-optimizer/

✗ reporter/
✗ ReportGenerator/
✗ report_generator/
```

### SKILL.md File
Always name the main skill file `SKILL.md` (uppercase):

```
skills/
├── report-generator/
│   └── SKILL.md          ✓
├── issue-prioritizer/
│   └── skill.md          ✗
└── prompt-patterns/
    └── pattern.md        ✗
```

---

## Hook Naming

### Hook Configuration Files
```
✓ hooks.json              (main hook config)
✓ security-hooks.json     (domain-specific)
✓ audit-hooks.json
```

### Hook Script Files
Use descriptive names with action-context pattern:

```
✓ stop-loop.sh            (stops loop execution)
✓ collect-metrics.sh      (collects codebase metrics)
✓ format-code.py          (formats code)
✓ validate-commit.sh      (validates commit)

✗ loop.sh
✗ metrics.sh
✗ format.py
✗ validate.sh
```

---

## Configuration File Naming

Use domain-specific names with purpose:

```
✓ severity-levels.json
✓ security-patterns.json
✓ quality-thresholds.json
✓ standard-promises.json
✓ custom-promises.json

✗ config.json
✗ settings.json
✗ data.json
```

---

## Template Naming

### Template Directory Structure
```
templates/
├── prompts/
│   ├── feature-development.md      ✓
│   ├── bug-fix.md                  ✓
│   └── performance-optimization.md ✓
└── reports/
    ├── security-report.md          ✓
    └── full-audit-report.md        ✓
```

---

## Variable Naming in Scripts

### Environment Variables (SCREAMING_SNAKE_CASE)
```bash
✓ ${CLAUDE_PLUGIN_ROOT}
✓ ${MAX_ITERATIONS}
✓ ${COMPLETION_PROMISE}
✓ ${CURRENT_ITERATION}

✗ ${claudePluginRoot}
✗ ${max_iterations}
✗ ${MaxIterations}
```

### Shell Variables (snake_case)
```bash
✓ current_iteration=0
✓ loop_state_file=".claude-loop-state"
✓ completion_marker="<promise>COMPLETE</promise>"

✗ currentIteration=0
✗ LoopStateFile=".claude-loop-state"
✗ COMPLETION_MARKER="<promise>COMPLETE</promise>"
```

---

## JSON Field Naming

### Plugin Metadata (camelCase)
```json
{
  "name": "codebase-audit",           ✓
  "version": "1.0.0",                 ✓
  "description": "...",               ✓
  "commands": "./commands/",          ✓
  "mcpServers": "./mcp.json",         ✓
  "outputStyles": "./styles/"         ✓
}
```

### Configuration Objects (camelCase)
```json
{
  "severityLevels": ["critical", "high", "medium", "low"],  ✓
  "maxIterations": 30,                                      ✓
  "completionPromise": "COMPLETE"                           ✓
}
```

---

## Consistency Principles

### 1. Case Usage by Context

| Context | Case Style | Example |
|---------|-----------|---------|
| File/directory names | kebab-case | `security-auditor.md` |
| Command names | kebab-case | `/security-audit` |
| JSON keys | camelCase | `"maxIterations"` |
| Environment vars | SCREAMING_SNAKE | `${CLAUDE_PLUGIN_ROOT}` |
| Shell variables | snake_case | `current_iteration` |
| Plugin names | kebab-case | `codebase-audit` |

### 2. Descriptiveness vs. Brevity

**Prefer descriptiveness:**
- File names: `security-auditor.md` > `auditor.md`
- Commands: `/full-report` > `/report`
- Variables: `max_iterations` > `max_iter`

**Acceptable brevity:**
- Common terms: `src/`, `lib/`, `config/`
- Standard abbreviations: `auth`, `db`, `api`
- Well-known acronyms: `html`, `json`, `url`

### 3. Semantic Naming

Names should indicate **purpose** or **function**, not implementation:

```
✓ completion-detector.md     (what it does)
✓ security-patterns.json     (what it contains)
✓ collect-metrics.sh         (what action it performs)

✗ script1.sh                 (meaningless)
✗ data.json                  (too generic)
✗ parser-class.md            (implementation detail)
```

### 4. Naming Hierarchy

Use hierarchical naming for related components:

```
commands/
├── audit.md                  (general)
├── security-audit.md         (specific)
├── quality-audit.md          (specific)
└── performance-audit.md      (specific)

agents/
├── audit-orchestrator.md     (coordinator)
├── security-auditor.md       (specialist)
├── code-quality-auditor.md   (specialist)
└── performance-auditor.md    (specialist)
```

---

## Anti-Patterns to Avoid

### ❌ Inconsistent Casing
```
commands/
├── audit.md              ✓
├── Security-Audit.md     ✗ (wrong case)
└── qualityAudit.md       ✗ (wrong case)
```

### ❌ Mixed Naming Styles
```json
{
  "name": "codebase-audit",     ✓
  "max_iterations": 30,         ✗ (should be camelCase)
  "CompletionPromise": "DONE"   ✗ (should be camelCase)
}
```

### ❌ Ambiguous Names
```
✗ process.sh              (process what?)
✗ handler.md              (handle what?)
✗ utils.json              (what utilities?)

✓ process-audit-results.sh
✓ error-handler.md
✓ string-utils.json
```

### ❌ Redundant Naming
```
✗ agents/security-auditor-agent.md
✗ commands/audit-command.md
✗ skills/prompt-skill/

✓ agents/security-auditor.md
✓ commands/audit.md
✓ skills/prompt-patterns/
```

---

## Quick Reference Table

| Element | Case | Pattern | Example |
|---------|------|---------|---------|
| Plugin name | kebab-case | `<purpose>-<type>` | `codebase-audit` |
| Directory | kebab-case | `<plural>` | `commands/` |
| Command file | kebab-case | `<action>-<target>.md` | `security-audit.md` |
| Agent file | kebab-case | `<domain>-<role>.md` | `prompt-engineer.md` |
| Skill dir | kebab-case | `<function>-<type>/` | `report-generator/` |
| Skill file | UPPERCASE | `SKILL.md` | `SKILL.md` |
| Config file | kebab-case | `<domain>-<type>.json` | `severity-levels.json` |
| Script file | kebab-case | `<action>-<target>.<ext>` | `collect-metrics.sh` |
| JSON key | camelCase | `<descriptive>` | `maxIterations` |
| Env var | SCREAMING_SNAKE | `<CONTEXT>_<NAME>` | `CLAUDE_PLUGIN_ROOT` |
| Shell var | snake_case | `<descriptive>` | `current_iteration` |

---

## Validation Checklist

Before finalizing names, verify:

- [ ] **Consistency**: Same case style for same element types
- [ ] **Clarity**: Purpose is obvious from name
- [ ] **Standards**: Follows Claude Code conventions
- [ ] **No abbreviations**: Unless industry-standard
- [ ] **No redundancy**: Don't repeat context in name
- [ ] **Hierarchy**: Related items follow naming pattern
- [ ] **Length**: Descriptive but not excessive (2-4 words)
- [ ] **Special chars**: Only hyphens in file/command names

---

## Examples: Well-Named vs. Poorly-Named

### ✓ Well-Named Plugin Structure
```
codebase-audit/
├── .claude-plugin/
│   └── plugin.json
├── commands/
│   ├── audit.md
│   └── security-audit.md
├── agents/
│   ├── audit-orchestrator.md
│   └── security-auditor.md
├── skills/
│   └── report-generator/
│       └── SKILL.md
└── scripts/
    └── collect-metrics.sh
```

### ✗ Poorly-Named Plugin Structure
```
CodebaseAudit/                    ✗ wrong case
├── .claude-plugin/
│   └── config.json               ✗ wrong name
├── Commands/                     ✗ wrong case
│   ├── doAudit.md               ✗ wrong case/style
│   └── security_check.md        ✗ wrong separator
├── agent/                        ✗ wrong plurality
│   ├── orchestrator.md          ✗ not specific
│   └── SecurityAuditor.md       ✗ wrong case
├── skills/
│   └── reporter/                 ✗ not descriptive
│       └── skill.md              ✗ wrong case
└── utils/                        ✗ too generic
    └── metrics.sh                ✗ not specific
```

---

This naming convention guide ensures consistency, clarity, and maintainability across all Claude Code plugins.
