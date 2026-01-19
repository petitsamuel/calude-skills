---
name: ralph-task-design
description: Heavy design phase with questions and architecture
args:
  - name: task
    description: Task description
    required: true
  - name: type
    description: Task type (feature, bug-fix, refactoring, testing, performance, security, documentation, api)
    required: false
---

# Ralph Task Design Command

Initiates heavy design phase with clarifying questions and architectural planning.

## Usage

```bash
/ralph-task-design "<description>" [--type=<type>]
```

## Examples

```bash
# Auto-detect task type
/ralph-task-design "build todo API with CRUD operations"

# Explicitly specify type
/ralph-task-design "fix login not working" --type=bug-fix

# Performance optimization
/ralph-task-design "optimize database queries" --type=performance
```

## Process

1. **Task Analysis**
   - Classify task type (or use specified type)
   - Extract explicit and implicit requirements
   - Identify complexity and scope

2. **Clarifying Questions**
   - Technology stack preferences
   - Database choices
   - Authentication requirements
   - Testing frameworks
   - Deployment targets

3. **Architecture Design**
   - System architecture
   - File structure
   - Database schemas
   - API endpoints
   - Validation rules
   - Error handling strategy

4. **Design Document Generation**
   - Creates `DESIGN-<timestamp>.md`
   - Includes all requirements and architecture
   - Defines acceptance criteria
   - Specifies completion conditions

5. **Preview**
   - Shows complete design document
   - User can refine with `/ralph-task-refine`
   - Or approve with `/ralph-task-approve`

## Task Types

- **feature** - New functionality
- **bug-fix** - Bug resolution with TDD
- **refactoring** - Safe, incremental refactoring
- **testing** - Test suite creation
- **performance** - Performance optimization
- **security** - Security fix
- **documentation** - Documentation creation
- **api** - API endpoint development
