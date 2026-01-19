# Suggestion Formatter Skill

Formats PR learning suggestions for optimal readability and actionability.

## Purpose

Transforms raw analysis data into clear, actionable suggestions that users can immediately apply.

## Output Modes

### Summary Mode (default)
- High-level findings only
- Top patterns and suggestions
- Quick scan friendly
- Minimal detail

### Detailed Mode
- Full analysis with examples
- Complete specifications
- Implementation guidance
- All supporting data

### Actionable Mode
- Only ready-to-implement items
- Copy-paste friendly
- No analysis, just actions
- Prioritized by impact

## Formatting Principles

### 1. Clarity
- Use clear headings
- Break into sections
- Highlight key points
- Provide context

### 2. Actionability
- Start with what to do
- Include how to do it
- Show expected outcomes
- Provide commands/code

### 3. Prioritization
- Most important first
- Group by category
- Score by impact
- Filter by threshold

### 4. Scannability
- Use bullet points
- Add visual indicators (✓ ✗ ⚠️)
- Bold key terms
- Keep paragraphs short

## Template Structure

```markdown
🔍 PR Analysis Results (N PRs from last X days)

📊 Key Findings:
[Top 3-5 patterns with frequency]

💡 Suggested Improvements:

### CLAUDE.md Updates
[Specific additions with sections]

### New Skills
[Skill proposals with ROI]

### New Commands
[Command ideas with usage]

### Workflow Changes
[Process improvements]

---

📈 Impact Summary:
- Estimated time savings: X hours/month
- Review iterations reduced: Y%
- Quality improvements: Z areas
```

## Examples

See `examples/` for formatted output samples:
- `summary-output.md`
- `detailed-output.md`
- `actionable-output.md`

## Formatting Functions

### formatPattern(pattern)
```
Pattern: [Name]
Frequency: X PRs
Impact: [High/Medium/Low]
Solution: [Summary]
```

### formatCLAUDEmd(suggestion)
```
## [Section Name]

[Clear guideline with examples]

✅ Good: [example]
❌ Bad: [example]
```

### formatSkill(proposal)
```
Skill: /skill-name
Purpose: [One line]
ROI: [Score] (affects X PRs, saves Y min)
Implementation: [Effort level]
```

### formatCommand(proposal)
```
Command: /command-name
Usage: /command-name [args]
Benefit: [Time saved / convenience]
```

### formatWorkflow(recommendation)
```
Issue: [Problem statement]
Root Cause: [Analysis]
Solution: [Specific steps]
Impact: [Expected improvement]
```

## Templates

See `templates/` directory:
- `summary-template.md`
- `detailed-template.md`
- `actionable-template.md`
- `section-templates/`
  - `claude-md-section.md`
  - `skill-section.md`
  - `command-section.md`
  - `workflow-section.md`
