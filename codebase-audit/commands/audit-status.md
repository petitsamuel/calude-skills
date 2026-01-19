---
name: audit-status
description: Show active audit progress
---

# Audit Status Command

Shows the current status of any active audit operations.

## Usage

```bash
/audit-status
```

## Examples

```bash
# Check audit progress
/audit-status
```

## Output

Displays:
- Currently running audit agents
- Completed agents
- Progress indicators
- Estimated time remaining (if available)
- Number of findings so far

## Example Output

```
📊 Audit Status

Active Agents: 5/8
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ security-auditor      Complete (3 findings)
✓ safety-auditor        Complete (12 findings)
✓ code-quality-auditor  Complete (28 findings)
⏳ performance-auditor   Running...
⏳ test-coverage-auditor Running...
⏳ dependency-auditor    Running...
⏳ documentation-auditor Queued
⏳ accessibility-auditor Queued

Findings so far: 43 issues
```
