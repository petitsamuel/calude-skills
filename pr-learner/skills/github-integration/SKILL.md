# GitHub Integration Skill

Handles all GitHub API interactions for PR data collection.

## Purpose

Provides reliable, efficient access to GitHub PR data via the `gh` CLI.

## Capabilities

### PR List Fetching
```bash
gh pr list --state merged --limit 10 --json number,title,url,createdAt,mergedAt
```

### PR Detail Fetching
```bash
gh pr view <number> --json body,comments,reviews,commits
```

### PR Diff Fetching
```bash
gh pr diff <number>
```

### PR Comments
```bash
gh api repos/:owner/:repo/pulls/<number>/comments
gh api repos/:owner/:repo/issues/<number>/comments
```

## Data Structures

### PR Metadata
```json
{
  "number": 123,
  "title": "Fix auth bug",
  "url": "https://github.com/...",
  "created_at": "2026-01-15T10:00:00Z",
  "merged_at": "2026-01-18T14:30:00Z",
  "author": "username",
  "labels": ["bug", "security"]
}
```

### PR Comments
```json
{
  "comments": [
    {
      "user": "reviewer",
      "body": "Needs error handling here",
      "path": "src/auth.ts",
      "line": 45,
      "created_at": "2026-01-16T12:00:00Z"
    }
  ]
}
```

### PR Diff
```diff
diff --git a/src/auth.ts b/src/auth.ts
-import { User } from '../../../models/User';
+import { User } from '@/models/User';
```

## Error Handling

### gh not installed
```
Error: GitHub CLI (gh) is required
Install: https://cli.github.com/

macOS: brew install gh
Linux: See installation guide
Windows: Download from website
```

### Not authenticated
```
Error: Not authenticated with GitHub
Run: gh auth login
```

### No PRs found
```
No merged PRs found in the last 7 days
Try: /pr-learn --days 30
```

### Rate limited
```
Warning: GitHub API rate limit reached
Waiting 60 seconds before retry...
```

## Performance Optimizations

### Batch Requests
- Fetch PR list once
- Fetch details in parallel (limit: 5 concurrent)
- Cache results to avoid refetching

### Selective Fetching
- Only fetch needed fields (--json flag)
- Skip large diffs for analysis summary
- Paginate large comment threads

### Rate Limit Management
- Check remaining rate limit before batch
- Implement exponential backoff
- Cache responses for repeated analysis

## Examples

See `examples/` directory:
- `pr-list-response.json`
- `pr-detail-response.json`
- `pr-diff-sample.txt`
- `pr-comments-response.json`

## GitHub CLI Configuration

Required setup:
```bash
# Authenticate
gh auth login

# Set default repo (optional)
gh repo set-default owner/repo

# Verify access
gh pr list --limit 1
```

## Templates

See `templates/` for response parsing:
- `parse-pr-list.js`
- `parse-pr-detail.js`
- `parse-diff.js`
- `extract-comments.js`
