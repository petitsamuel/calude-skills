# Prompt Optimizer Skill

This skill provides techniques for writing effective, high-quality prompts for Claude.

## Purpose

Helps engineer prompts that:
- Provide clear context and goals
- Break complex tasks into steps
- Include validation criteria
- Enable self-correction loops
- Maintain focus and scope

## Core Principles

### 1. Context First
Always provide:
- Current state of the codebase
- Relevant constraints
- Available tools and resources
- Success criteria

### 2. Clear Structure
Use consistent sections:
- **Goal**: What needs to be accomplished
- **Context**: Current situation and constraints
- **Tasks**: Step-by-step breakdown
- **Validation**: How to verify completion
- **Promise**: Completion signal

### 3. Actionable Steps
- Break large tasks into phases
- Each step should be clear and verifiable
- Include validation after each major step

### 4. Self-Correction
- Include instructions for handling errors
- Specify when to re-attempt vs. escalate
- Define success/failure conditions

### 5. Scope Management
- Be explicit about what's in/out of scope
- Prevent scope creep with clear boundaries
- Focus on MVP first, iterations later

## Prompt Template Structure

```markdown
# Goal
[One sentence: what needs to be accomplished]

# Context
[Relevant background, constraints, current state]

# Tasks
1. [Step 1 with validation]
2. [Step 2 with validation]
3. [Step 3 with validation]

# Validation Commands
```bash
[Commands to verify success]
```

# Acceptance Criteria
- [ ] [Specific, measurable criterion]
- [ ] [Specific, measurable criterion]

# Self-Correction
- If [error condition]: [recovery action]
- If validation fails: [retry/escalate logic]

# Completion Signal
Output: <promise>TASK_COMPLETE</promise>
```

## Optimization Techniques

### Make It Specific
❌ "Improve the code"
✅ "Reduce function complexity from 15 to <8 and extract helper functions"

### Add Context
❌ "Fix the bug"
✅ "Fix the bug in auth.ts:42 where JWT tokens expire immediately. Current behavior: tokens expire after 1 second. Expected: 1 hour expiration."

### Include Examples
❌ "Write good tests"
✅ "Write tests following the pattern in user.test.ts: arrange-act-assert structure, descriptive names, edge cases covered"

### Specify Output Format
❌ "Analyze the code"
✅ "Output findings as JSON: {file: string, line: number, severity: 'high'|'medium'|'low', description: string}"

### Add Validation
❌ "Implement the feature"
✅ "Implement the feature, then run `npm test && npm run build` to verify. All tests must pass before completion."

## Common Anti-Patterns

### 1. Vague Goals
Problem: "Make it better"
Solution: "Reduce load time from 3s to <1s by optimizing images and lazy loading"

### 2. Missing Context
Problem: "Add caching"
Solution: "Add Redis caching to the /api/users endpoint which currently takes 500ms and is called 1000x/min"

### 3. No Validation
Problem: "Build the feature"
Solution: "Build the feature and verify with: npm test && curl localhost:3000/api/test"

### 4. Scope Creep
Problem: "Add auth and also improve the UI and refactor the database"
Solution: "Add JWT-based auth. (UI and DB improvements are separate tasks)"

### 5. Implicit Assumptions
Problem: "Use the standard approach"
Solution: "Use JWT tokens stored in httpOnly cookies, following OWASP guidelines"

## Examples

See `examples/` directory for before/after prompt optimization samples.
