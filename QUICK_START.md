# Quick Start Guide

This guide will help you get started implementing the two Claude Code plugins.

## Prerequisites

- Claude Code CLI installed (`npm install -g @anthropic-ai/claude-code`)
- Git installed
- Basic understanding of Markdown and JSON
- Familiarity with bash scripting (for hooks)

---

## Setup

### 1. Initialize Plugin Directories

```bash
# Create both plugin structures
mkdir -p codebase-audit/{.claude-plugin,commands,agents,skills,hooks,scripts,config}
mkdir -p prompt-automation/{.claude-plugin,commands,agents,skills,hooks,templates,scripts}

# Create skill subdirectories for codebase-audit
mkdir -p codebase-audit/skills/{report-generator,issue-prioritizer}
mkdir -p codebase-audit/skills/report-generator/templates

# Create skill subdirectories for prompt-automation
mkdir -p prompt-automation/skills/{prompt-patterns,completion-criteria,prompt-optimizer}
mkdir -p prompt-automation/templates/{prompts,completion-promises}
```

### 2. Create plugin.json Files

**Codebase Audit:**
```bash
cat > codebase-audit/.claude-plugin/plugin.json << 'EOF'
{
  "name": "codebase-audit",
  "version": "1.0.0",
  "description": "Comprehensive multi-dimensional codebase audit using specialized sub-agents",
  "keywords": ["audit", "security", "quality", "performance", "testing"],
  "commands": "./commands/",
  "agents": "./agents/",
  "skills": "./skills/",
  "hooks": "./hooks/hooks.json"
}
EOF
```

**Prompt Automation:**
```bash
cat > prompt-automation/.claude-plugin/plugin.json << 'EOF'
{
  "name": "prompt-automation",
  "version": "1.0.0",
  "description": "Intelligent prompt engineering and Ralph Loop automation system",
  "keywords": ["prompt", "automation", "ralph-loop", "iteration"],
  "commands": "./commands/",
  "agents": "./agents/",
  "skills": "./skills/",
  "hooks": "./hooks/hooks.json"
}
EOF
```

---

## Codebase Audit Plugin - Step by Step

### Step 1: Create the Main Audit Command

```bash
cat > codebase-audit/commands/audit.md << 'EOF'
---
name: audit
description: Perform comprehensive codebase audit
args:
  - name: scope
    description: Audit scope (all, security, quality, performance, tests, deps)
    required: false
    default: all
  - name: format
    description: Output format (markdown, json, html)
    required: false
    default: markdown
  - name: severity
    description: Minimum severity to report (low, medium, high, critical)
    required: false
    default: low
---

# Audit Command

Triggers comprehensive codebase audit using specialized agents.

## Usage

```bash
/audit [scope] [--format=<format>] [--severity=<level>]
```

## Examples

```bash
# Full audit
/audit all

# Security only
/audit security

# High severity issues only
/audit all --severity=high

# JSON output
/audit all --format=json
```

## Process

1. Analyzes project structure
2. Dispatches appropriate audit agents in parallel
3. Aggregates results
4. Generates formatted report
EOF
```

### Step 2: Create the Audit Orchestrator Agent

```bash
cat > codebase-audit/agents/audit-orchestrator.md << 'EOF'
---
description: Coordinates multi-dimensional codebase audit by managing specialized audit agents
capabilities:
  - Parallel agent coordination
  - Result aggregation and prioritization
  - Report generation
  - Progress tracking
auto_invoke: true
---

# Audit Orchestrator Agent

## Responsibilities

Manages the complete audit workflow by:

1. **Project Analysis**
   - Detect programming languages
   - Identify frameworks and libraries
   - Determine project type (web, API, CLI, etc.)

2. **Agent Dispatching**
   - Select appropriate agents based on project type
   - Launch agents in parallel for performance
   - Track agent progress

3. **Result Aggregation**
   - Collect findings from all agents
   - Deduplicate issues
   - Cross-reference related findings

4. **Prioritization**
   - Sort by severity (Critical > High > Medium > Low)
   - Consider exploitability and impact
   - Recommend fix order

5. **Report Generation**
   - Format findings in requested format
   - Include code examples and remediation
   - Generate executive summary

## Agent Coordination

### Always Invoked
- security-auditor
- code-quality-auditor
- test-coverage-auditor
- documentation-auditor
- dependency-auditor

### Conditionally Invoked
- accessibility-auditor (if web project)
- performance-auditor (based on project size)
- safety-auditor (for production systems)

## Implementation Strategy

```typescript
// Pseudo-code for orchestration
async function orchestrateAudit(scope: string) {
  // 1. Analyze project
  const projectInfo = await analyzeProject();

  // 2. Select agents
  const agents = selectAgents(scope, projectInfo);

  // 3. Run in parallel
  const results = await Promise.all(
    agents.map(agent => runAgent(agent))
  );

  // 4. Aggregate and prioritize
  const findings = aggregateFindings(results);
  const prioritized = prioritizeIssues(findings);

  // 5. Generate report
  return generateReport(prioritized);
}
```

## Usage

This agent is automatically invoked when the `/audit` command is executed.
EOF
```

### Step 3: Create a Security Auditor Agent

```bash
cat > codebase-audit/agents/security-auditor.md << 'EOF'
---
description: Identifies security vulnerabilities and anti-patterns
capabilities:
  - OWASP Top 10 detection
  - Authentication/authorization review
  - Input validation analysis
  - Cryptography review
  - Secrets detection
---

# Security Auditor Agent

## Security Checks

### 1. Injection Vulnerabilities
- SQL injection
- Command injection
- LDAP injection
- XPath injection
- NoSQL injection

### 2. Authentication & Authorization
- Weak password requirements
- Missing authentication
- Broken access control
- Session management flaws
- JWT vulnerabilities

### 3. Sensitive Data Exposure
- Hardcoded credentials
- API keys in code
- Passwords in logs
- Unencrypted data storage
- Insecure data transmission

### 4. XXE & Deserialization
- XML external entity attacks
- Insecure deserialization
- Pickle usage (Python)
- YAML.load (Ruby)

### 5. Security Misconfiguration
- Debug mode in production
- Default credentials
- Unnecessary services enabled
- Missing security headers
- Verbose error messages

### 6. XSS (Cross-Site Scripting)
- Reflected XSS
- Stored XSS
- DOM-based XSS
- Unsafe innerHTML usage

### 7. Insecure Dependencies
- Known CVEs
- Outdated packages
- Vulnerable dependencies

### 8. CSRF (Cross-Site Request Forgery)
- Missing CSRF tokens
- Unsafe HTTP methods

## Detection Patterns

### SQL Injection Example
```javascript
// VULNERABLE
const query = `SELECT * FROM users WHERE id = ${userId}`;

// SECURE
const query = 'SELECT * FROM users WHERE id = ?';
db.query(query, [userId]);
```

### Command Injection Example
```python
# VULNERABLE
subprocess.call(f"rm -rf {user_path}", shell=True)

# SECURE
subprocess.run(["rm", "-rf", user_path])
```

### Hardcoded Secrets Example
```javascript
// VULNERABLE
const API_KEY = "sk-1234567890abcdef";

// SECURE
const API_KEY = process.env.API_KEY;
```

## Output Format

```json
{
  "severity": "critical",
  "category": "injection",
  "type": "SQL Injection",
  "location": "src/api/users.ts:45",
  "description": "User input directly interpolated into SQL query",
  "vulnerable_code": "const query = `SELECT * FROM users WHERE id = ${userId}`;",
  "remediation": "Use parameterized queries",
  "secure_code": "const query = 'SELECT * FROM users WHERE id = ?'; db.query(query, [userId]);",
  "cve_references": [],
  "owasp_category": "A03:2021 - Injection"
}
```

## Implementation

Use tools like:
- `grep` for pattern detection
- Static analysis tools (ESLint, Bandit, Brakeman)
- `git secrets` for credential detection
- npm audit / pip-audit for dependency checks

## Severity Levels

- **Critical**: Actively exploitable, high impact
- **High**: Exploitable with effort, significant impact
- **Medium**: Requires specific conditions, moderate impact
- **Low**: Theoretical risk, minimal impact
EOF
```

### Step 4: Create Report Generator Skill

```bash
cat > codebase-audit/skills/report-generator/SKILL.md << 'EOF'
---
name: report-generator
description: Generates professional audit reports in multiple formats
---

# Report Generator Skill

Transforms audit findings into professional, actionable reports.

## Capabilities

1. **Format Support**
   - Markdown (human-readable)
   - JSON (machine-readable)
   - HTML (interactive, styled)

2. **Report Sections**
   - Executive Summary
   - Severity Breakdown
   - Findings by Category
   - Detailed Remediation
   - Metrics & Statistics

3. **Prioritization**
   - Sort by severity
   - Group by category
   - Estimate fix effort

## Markdown Template

```markdown
# Codebase Audit Report
Generated: {{date}}

## Executive Summary
- 🔴 Critical Issues: {{critical_count}}
- 🟠 High Severity: {{high_count}}
- 🟡 Medium Severity: {{medium_count}}
- 🟢 Low Severity: {{low_count}}

**Overall Risk Level**: {{risk_level}}

## Findings

{{#each findings}}
### {{severity_emoji}} {{severity}}: {{title}}
**Location**: `{{location}}`
**Category**: {{category}}

**Description**: {{description}}

**Vulnerable Code**:
```{{language}}
{{vulnerable_code}}
```

**Remediation**:
```{{language}}
{{secure_code}}
```

**Priority**: {{priority}} ({{effort}} effort)

---

{{/each}}

## Recommendations

1. Address all Critical issues immediately
2. Plan High severity fixes within this sprint
3. Schedule Medium issues for next sprint
4. Track Low issues as technical debt

## Metrics

- **Total Issues**: {{total_issues}}
- **Files Scanned**: {{files_scanned}}
- **Lines of Code**: {{loc}}
- **Security Score**: {{security_score}}/100
```

## Usage

Automatically invoked by audit-orchestrator after all agents complete.
EOF
```

### Step 5: Create Hooks Configuration

```bash
cat > codebase-audit/hooks/hooks.json << 'EOF'
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
EOF
```

---

## Prompt Automation Plugin - Step by Step

### Step 1: Create Auto-Prompt Command

```bash
cat > prompt-automation/commands/auto-prompt.md << 'EOF'
---
name: auto-prompt
description: Generate optimal prompt for a task
args:
  - name: task
    description: Task description
    required: true
  - name: template
    description: Prompt template to use
    required: false
---

# Auto-Prompt Command

Analyzes a task description and generates an optimal prompt for execution.

## Usage

```bash
/auto-prompt "<task description>" [--template=<type>]
```

## Examples

```bash
# Auto-generate prompt
/auto-prompt "Build a REST API for todos"

# Use specific template
/auto-prompt "Fix the login bug" --template=bug-fix
```

## Process

1. Analyze task with task-analyzer agent
2. Extract requirements and constraints
3. Select appropriate template
4. Generate prompt with prompt-engineer agent
5. Include completion criteria
6. Output ready-to-use prompt

## Output

A complete, structured prompt ready for `/start-loop`.
EOF
```

### Step 2: Create Start Loop Command

```bash
cat > prompt-automation/commands/start-loop.md << 'EOF'
---
name: start-loop
description: Start Ralph Loop with a prompt
args:
  - name: prompt
    description: The prompt to execute iteratively
    required: true
  - name: max-iterations
    description: Maximum number of iterations
    required: false
    default: 30
  - name: promise
    description: Completion promise marker
    required: false
    default: COMPLETE
---

# Start Loop Command

Initiates a Ralph Loop with the provided prompt.

## Usage

```bash
/start-loop "<prompt>" [--max-iterations=<n>] [--promise=<text>]
```

## Examples

```bash
# Basic usage
/start-loop "Build todo API with tests" --max-iterations=25

# Custom completion promise
/start-loop "Fix auth bug" --promise=BUG_FIXED
```

## How It Works

1. **Initialize**: Save loop state and configuration
2. **Execute**: Run prompt in Claude session
3. **Monitor**: Check for completion promise
4. **Iterate**: Re-inject prompt if not complete
5. **Terminate**: Exit when complete or max iterations reached

## Loop State

Stored in `.claude-loop-state`:
```bash
ORIGINAL_PROMPT="..."
MAX_ITERATIONS=30
CURRENT_ITERATION=0
COMPLETION_PROMISE="COMPLETE"
LOOP_OUTPUT_FILE=".claude-loop-output"
```

## Stop Hook

The stop hook (`hooks/stop-loop.sh`) intercepts exit attempts and re-injects the prompt for continuous iteration.
EOF
```

### Step 3: Create Prompt Engineer Agent

```bash
cat > prompt-automation/agents/prompt-engineer.md << 'EOF'
---
description: Expert at crafting optimal prompts for complex tasks
capabilities:
  - Task decomposition
  - Requirement extraction
  - Completion criteria definition
  - Prompt template selection
---

# Prompt Engineer Agent

Generates high-quality, structured prompts for complex tasks.

## Prompt Structure

Every generated prompt includes:

1. **Clear Objective**: What needs to be accomplished
2. **Explicit Requirements**: All stated and inferred needs
3. **Implementation Steps**: Ordered, actionable steps
4. **Acceptance Criteria**: Verifiable completion conditions
5. **Self-Testing**: How to validate the work
6. **Completion Promise**: Clear marker for done state

## Template Selection

Based on task analysis:

- **Feature Development**: New functionality with tests
- **Bug Fix**: TDD approach with regression tests
- **Refactoring**: Safe, incremental improvements
- **Testing**: Test suite creation
- **Performance**: Optimization with benchmarks
- **Security**: Vulnerability remediation
- **Documentation**: Comprehensive docs

## Example Output

```markdown
# Task: Build Todo REST API

## Objective
Create a complete REST API for todo management with CRUD operations.

## Requirements
### Functional
- POST /api/todos - Create new todo
- GET /api/todos - List all todos
- GET /api/todos/:id - Get single todo
- PUT /api/todos/:id - Update todo
- DELETE /api/todos/:id - Delete todo

### Non-Functional
- Input validation on all endpoints
- Proper HTTP status codes
- Error handling with descriptive messages
- JSON response format

### Testing
- Unit tests for each endpoint
- Integration tests for API
- Test coverage > 80%
- All tests must pass

### Documentation
- OpenAPI/Swagger specification
- README with API examples
- Postman collection

## Implementation Steps

1. **Project Setup**
   - Initialize Node.js project
   - Install dependencies (Express, Jest, etc.)
   - Set up project structure

2. **Data Model**
   - Define Todo schema
   - Set up database/storage
   - Create model layer

3. **API Implementation**
   - Implement POST /api/todos
   - Implement GET /api/todos
   - Implement GET /api/todos/:id
   - Implement PUT /api/todos/:id
   - Implement DELETE /api/todos/:id
   - Add input validation
   - Add error handling

4. **Testing**
   - Write unit tests for each endpoint
   - Write integration tests
   - Run tests: `npm test`
   - Check coverage: `npm run coverage`

5. **Documentation**
   - Generate OpenAPI spec
   - Write README with examples
   - Create Postman collection

6. **Verification**
   - All tests passing
   - Coverage > 80%
   - Manual API testing
   - Documentation complete

## Acceptance Criteria
- [ ] All 5 CRUD endpoints implemented
- [ ] Input validation working
- [ ] Error handling in place
- [ ] Unit tests passing (coverage > 80%)
- [ ] Integration tests passing
- [ ] OpenAPI docs generated
- [ ] README with examples
- [ ] Postman collection created

## Self-Testing
Run after each iteration:
```bash
npm test
npm run coverage
curl -X POST http://localhost:3000/api/todos -d '{"title":"Test"}'
```

## Completion Promise
When ALL acceptance criteria are met and tests pass, output:

<promise>COMPLETE</promise>
```

## Best Practices

1. **Be Specific**: Include exact endpoint names, file paths, commands
2. **Include Examples**: Show expected input/output
3. **Define Success**: Clear, verifiable criteria
4. **Add Self-Tests**: Commands to verify progress
5. **Incremental Steps**: Break complex tasks into phases
6. **Error Handling**: Explicitly require error handling
7. **Testing**: Always include test requirements
EOF
```

### Step 4: Create Ralph Loop Stop Hook

```bash
cat > prompt-automation/hooks/stop-loop.sh << 'EOF'
#!/bin/bash
# Ralph Loop Stop Hook
# Re-injects prompt to continue iteration

# Check if loop is active
if [ ! -f ".claude-loop-state" ]; then
  exit 0  # No active loop, allow normal exit
fi

# Load loop state
source .claude-loop-state

# Check for completion promise
if grep -q "<promise>${COMPLETION_PROMISE}</promise>" "${LOOP_OUTPUT_FILE}" 2>/dev/null; then
  echo "✓ Task completed successfully!"
  echo "Final iteration: ${CURRENT_ITERATION}"
  rm -f .claude-loop-state .claude-loop-output
  exit 0  # Allow exit
fi

# Check max iterations
if [ ${CURRENT_ITERATION} -ge ${MAX_ITERATIONS} ]; then
  echo "⚠️  Max iterations (${MAX_ITERATIONS}) reached"
  echo "Loop terminated without completion promise"
  rm -f .claude-loop-state .claude-loop-output
  exit 0  # Allow exit
fi

# Increment iteration counter
CURRENT_ITERATION=$((CURRENT_ITERATION + 1))
echo "ORIGINAL_PROMPT=\"${ORIGINAL_PROMPT}\"" > .claude-loop-state
echo "MAX_ITERATIONS=${MAX_ITERATIONS}" >> .claude-loop-state
echo "CURRENT_ITERATION=${CURRENT_ITERATION}" >> .claude-loop-state
echo "COMPLETION_PROMISE=\"${COMPLETION_PROMISE}\"" >> .claude-loop-state
echo "LOOP_OUTPUT_FILE=\"${LOOP_OUTPUT_FILE}\"" >> .claude-loop-state

# Show progress
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔄 Iteration ${CURRENT_ITERATION}/${MAX_ITERATIONS}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Re-inject original prompt
echo "${ORIGINAL_PROMPT}"

# Block exit to continue loop
exit 1
EOF

chmod +x prompt-automation/hooks/stop-loop.sh
```

### Step 5: Create Hooks Configuration

```bash
cat > prompt-automation/hooks/hooks.json << 'EOF'
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
EOF
```

### Step 6: Create a Prompt Template

```bash
cat > prompt-automation/templates/prompts/feature-development.md << 'EOF'
# Feature Development Template

Use this template for building new features.

## Structure

```markdown
# Feature: {{feature_name}}

## Objective
{{clear_objective}}

## Requirements
{{#each requirements}}
- {{this}}
{{/each}}

## Technical Approach
- Framework/Library: {{tech_stack}}
- Architecture: {{architecture_pattern}}
- Data Storage: {{data_storage}}

## Implementation Steps
1. {{step_1}}
2. {{step_2}}
3. {{step_3}}
...

## Acceptance Criteria
{{#each criteria}}
- [ ] {{this}}
{{/each}}

## Testing Requirements
- [ ] Unit tests (coverage > 80%)
- [ ] Integration tests
- [ ] E2E tests (if applicable)
- [ ] All tests passing

## Documentation
- [ ] README updated
- [ ] API docs generated
- [ ] Code comments added

## Self-Testing Commands
```bash
{{test_command}}
{{coverage_command}}
{{build_command}}
```

## Completion Promise
When all criteria met and tests pass:
<promise>COMPLETE</promise>
```

## Example

```markdown
# Feature: User Authentication

## Objective
Implement JWT-based user authentication with login and logout.

## Requirements
- POST /api/auth/login endpoint
- POST /api/auth/logout endpoint
- JWT token generation
- Token expiry (24 hours)
- Password hashing with bcrypt
- Rate limiting (5 attempts/minute)

## Technical Approach
- Framework: Express.js
- Auth: JWT (jsonwebtoken)
- Hashing: bcrypt
- Rate Limiting: express-rate-limit

## Implementation Steps
1. Install dependencies (jsonwebtoken, bcrypt, express-rate-limit)
2. Create auth middleware
3. Implement password hashing utilities
4. Build POST /api/auth/login endpoint
5. Build POST /api/auth/logout endpoint
6. Add JWT verification middleware
7. Add rate limiting
8. Write unit tests
9. Write integration tests

## Acceptance Criteria
- [ ] Login endpoint accepts email/password
- [ ] Login returns JWT token on success
- [ ] Login returns 401 on invalid credentials
- [ ] Token expires after 24 hours
- [ ] Logout invalidates token
- [ ] Rate limiting blocks after 5 attempts
- [ ] Passwords hashed with bcrypt
- [ ] All tests passing (coverage > 80%)

## Testing Requirements
- [ ] Test valid login
- [ ] Test invalid credentials
- [ ] Test token expiry
- [ ] Test logout
- [ ] Test rate limiting
- [ ] Integration tests for auth flow

## Documentation
- [ ] README with auth endpoints
- [ ] Postman collection
- [ ] OpenAPI spec

## Self-Testing Commands
```bash
npm test
npm run coverage
curl -X POST http://localhost:3000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
```

## Completion Promise
<promise>COMPLETE</promise>
```
EOF
```

---

## Testing Your Plugins

### 1. Install Plugins Locally

```bash
# Add to your Claude settings
# ~/.claude/settings.json or project .claude/settings.json

{
  "plugins": [
    "/absolute/path/to/codebase-audit",
    "/absolute/path/to/prompt-automation"
  ]
}
```

### 2. Test Codebase Audit

```bash
# Navigate to a test project
cd /path/to/test-project

# Run Claude Code
claude

# In Claude Code:
/audit all
```

### 3. Test Prompt Automation

```bash
# In Claude Code:
/auto-prompt "Build a simple calculator CLI in Python"

# Then start the loop with the generated prompt:
/start-loop "<generated-prompt>" --max-iterations=10
```

---

## Next Steps

1. **Implement remaining agents** - Use the patterns from the examples above
2. **Add more templates** - Create templates for common tasks
3. **Test thoroughly** - Try on real projects
4. **Gather feedback** - Use the plugins and iterate
5. **Document learnings** - Keep notes on what works well

---

## Troubleshooting

### Plugin Not Loading
- Check `plugin.json` syntax with `jq . < .claude-plugin/plugin.json`
- Verify all paths are relative and start with `./`
- Check file permissions on scripts

### Ralph Loop Not Working
- Ensure stop hook has execute permission: `chmod +x hooks/stop-loop.sh`
- Check `.claude-loop-state` file is being created
- Verify `CLAUDE_PLUGIN_ROOT` environment variable

### Agents Not Running
- Check agent frontmatter YAML is valid
- Verify agent descriptions are clear
- Ensure `auto_invoke` is set correctly

---

## Resources

- [Full Design Doc](./PLUGIN_DESIGN.md)
- [Naming Conventions](./NAMING_CONVENTIONS.md)
- [Claude Code Docs](https://code.claude.com/docs)

Happy plugin building! 🚀
