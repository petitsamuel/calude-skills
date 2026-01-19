---
name: ralph-task-refine
description: Modify design before locking in
args:
  - name: add
    description: Add requirements or constraints
    required: false
  - name: remove
    description: Remove requirements
    required: false
  - name: change
    description: Change architectural decisions
    required: false
---

# Ralph Task Refine Command

Modifies the prepared design before approval.

## Usage

```bash
/ralph-task-refine [--add="X"] [--remove="Y"] [--change="Z"]
```

## Examples

```bash
# Add a requirement
/ralph-task-refine --add="JWT authentication"

# Remove a requirement
/ralph-task-refine --remove="GraphQL support"

# Change architecture
/ralph-task-refine --change="Use PostgreSQL instead of MongoDB"

# Multiple changes
/ralph-task-refine --add="Rate limiting" --change="Use Redis for caching"
```

## What It Does

1. Reads current `DESIGN-<timestamp>.md`
2. Applies requested modifications
3. Updates design document
4. Shows updated design preview
5. User can refine again or approve

## Modification Types

### Add (--add)
- New requirements
- Additional constraints
- Extra validation rules
- More test requirements
- Additional documentation needs

### Remove (--remove)
- Unnecessary requirements
- Overly complex features
- Out-of-scope items

### Change (--change)
- Technology stack changes
- Architecture pattern changes
- Database changes
- API design changes
- Testing strategy changes

## Tips

- Be specific about what to change
- Review the updated design after refinement
- Can refine multiple times before approval
- Changes update the DESIGN file but don't affect prompt until approved
