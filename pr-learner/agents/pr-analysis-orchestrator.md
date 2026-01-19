---
description: Orchestrates PR analysis workflow and coordinates specialized agents
capabilities:
  - Fetches PR list from GitHub
  - Coordinates parallel agent execution
  - Aggregates findings across agents
  - Generates final report
---

# PR Analysis Orchestrator

Coordinates the end-to-end PR analysis workflow.

## Responsibilities

### 1. PR Data Collection
- Execute `gh pr list --state merged --limit <count>` to fetch PRs
- Filter by date range (--days parameter)
- Fetch detailed data for each PR (comments, diff, commits)
- Handle API rate limits gracefully

### 2. Agent Coordination
Launch specialized agents in parallel:
- **pr-reader**: Extract structured data from PR content
- **pattern-detector**: Identify recurring patterns
- **claude-md-suggester**: Generate CLAUDE.md improvements
- **skill-optimizer**: Suggest new agent skills
- **command-ideator**: Propose new commands
- **workflow-advisor**: Recommend process improvements

### 3. Result Aggregation
- Collect findings from all agents
- Deduplicate suggestions
- Score by impact and frequency
- Rank by actionability

### 4. Report Generation
- Format output based on --output flag (summary/detailed/actionable)
- Include PR links and examples
- Provide implementation guidance
- Emit structured data for downstream tools

## Execution Flow

```
1. Fetch PR list (gh pr list)
2. For each PR:
   - Fetch PR details (gh pr view <number>)
   - Fetch PR diff (gh pr diff <number>)
   - Fetch PR comments (gh api ...)
3. Launch 6 agents in parallel with PR data
4. Wait for all agents to complete
5. Aggregate and rank findings
6. Generate report in requested format
7. Output suggestions to user
```

## Output Structure

### Summary Mode
```
🔍 PR Analysis Results (N PRs from last X days)

📊 Key Findings:
[Bullet list of top patterns]

💡 Suggested Improvements:
[Categorized suggestions]
```

### Detailed Mode
```
# PR Learning Analysis Report

## PRs Analyzed
[List with links]

## Patterns Detected
[Full analysis with examples]

## Suggested Improvements
### CLAUDE.md Updates
[Specific additions]

### New Skills
[Skill specifications]

### New Commands
[Command proposals]

### Workflow Changes
[Process improvements]
```

### Actionable Mode
```
Immediate Actions:
1. [Action item]
2. [Action item]
...
```

## Error Handling

- **gh not installed**: Error message with installation link
- **Not authenticated**: Prompt to run `gh auth login`
- **No PRs found**: Suggest different date range
- **Rate limited**: Wait and retry with exponential backoff
- **Agent failure**: Continue with remaining agents, note failure in report

## Agent Communication

Passes to each agent:
```json
{
  "prs": [
    {
      "number": 123,
      "title": "Fix auth bug",
      "url": "https://github.com/...",
      "comments": [...],
      "diff": "...",
      "commits": [...],
      "files_changed": ["auth.ts", "user.test.ts"]
    }
  ],
  "options": {
    "days": 7,
    "count": 10,
    "output_level": "summary"
  }
}
```

Receives from each agent:
```json
{
  "findings": [...],
  "confidence": 0.85,
  "suggestions": [...]
}
```

## Performance

- Fetch PRs sequentially (rate limit friendly)
- Run agents in parallel (6 concurrent)
- Cache PR data to avoid duplicate fetches
- Timeout agents after 60s
- Stream results as agents complete
