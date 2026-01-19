---
name: ralph-task-approve
description: Lock design and generate implementation prompt
---

# Ralph Task Approve Command

Locks the design and generates the implementation prompt for Ralph Loop execution.

## Usage

```bash
/ralph-task-approve
```

## What It Does

1. **Locks Design**
   - Finalizes `DESIGN-<timestamp>.md`
   - No further changes allowed without starting over

2. **Generates Implementation Prompt**
   - Creates comprehensive prompt based on design
   - Embeds all requirements and architecture
   - Includes acceptance criteria
   - Adds completion promise marker
   - Specifies validation checks

3. **Prepares for Execution**
   - Prompt is ready for `/ralph-task-execute`
   - All specifications locked in
   - Clear success criteria defined

## After Approval

You can then:
- Run `/ralph-task-execute` to start Ralph Loop
- Review the complete prompt before execution
- Start implementation with locked design

## Cannot Be Undone

Once approved, design is locked. To make changes:
1. Cancel current task with `/ralph-task-cancel`
2. Start new design with `/ralph-task-design`

## Example Flow

```bash
# 1. Design
/ralph-task-design "build todo API"

# 2. Refine (optional)
/ralph-task-refine --add="JWT authentication"

# 3. Approve
/ralph-task-approve

# 4. Execute
/ralph-task-execute --max-iterations=30
```
