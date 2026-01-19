---
description: Generates suggested additions to CLAUDE.md files based on PR patterns
capabilities:
  - Analyze existing CLAUDE.md structure
  - Generate specific, actionable additions
  - Format suggestions for easy copy-paste
  - Prioritize by impact
---

# CLAUDE.md Suggester

Generates additions to CLAUDE.md (global or project-specific) based on detected PR patterns.

## Input

Patterns from pattern-detector agent:
```json
{
  "patterns": [
    {
      "id": "import_path_conventions",
      "description": "...",
      "impact_score": 0.75
    }
  ]
}
```

Existing CLAUDE.md content (if available)

## Output

Structured suggestions for CLAUDE.md:

```json
{
  "suggestions": [
    {
      "priority": "high",
      "section": "Code Conventions",
      "content": "## Import Paths\n\nAlways use absolute imports from `@/` instead of relative paths:\n\n```typescript\n// ✅ Good\nimport { User } from '@/models/User';\n\n// ❌ Bad\nimport { User } from '../../../models/User';\n```",
      "rationale": "6 PRs required import path corrections",
      "impact": "Reduces review iterations and maintains consistency"
    }
  ]
}
```

## Suggestion Categories

### 1. Code Conventions
Patterns → Standards:
- Import path styles
- Naming conventions
- File structure
- Code organization

### 2. Error Handling Standards
Patterns → Guidelines:
- Try-catch usage
- Error boundary patterns
- Fallback behaviors
- Logging standards

### 3. Testing Requirements
Patterns → Expectations:
- Coverage thresholds
- Test structure (AAA pattern)
- Edge case checklist
- Mock/stub guidelines

### 4. Security Guidelines
Patterns → Rules:
- Input validation requirements
- Authentication patterns
- Secret management
- XSS/injection prevention

### 5. Performance Standards
Patterns → Benchmarks:
- Response time targets
- Bundle size limits
- Memory constraints
- Query optimization

### 6. Documentation Requirements
Patterns → Templates:
- Comment standards
- API documentation format
- README sections
- Change log structure

## Suggestion Structure

Each suggestion includes:

### Content
The actual markdown to add to CLAUDE.md, formatted and ready to paste.

### Section
Where to add it: "Code Conventions", "Testing", "Security", etc.

### Rationale
Why this is needed (pattern frequency, PRs affected)

### Impact
What this prevents or improves

### Priority
- **High**: Affects security, functionality, or >5 PRs
- **Medium**: Affects quality, performance, or 2-5 PRs
- **Low**: Style/preferences, or 1-2 PRs

## Example Suggestions

### High Priority: Error Handling

**Pattern:** 8 PRs had missing error handling added during review

**Suggestion:**
```markdown
## Error Handling Standards

All API calls, database operations, and external integrations MUST include error handling:

```typescript
// ✅ Good: Comprehensive error handling
async function fetchUser(id: string) {
  try {
    const response = await fetch(`/api/users/${id}`);
    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }
    return await response.json();
  } catch (error) {
    logger.error('Failed to fetch user', { id, error });
    throw new UserFetchError(`Could not load user ${id}`, { cause: error });
  }
}

// ❌ Bad: No error handling
async function fetchUser(id: string) {
  const response = await fetch(`/api/users/${id}`);
  return await response.json();
}
```

**Error Response Format:**
```typescript
{
  error: {
    code: 'USER_NOT_FOUND',
    message: 'User with ID 123 not found',
    details: { userId: '123' }
  }
}
```
```

**Priority:** High
**Rationale:** 8 PRs required error handling additions
**Impact:** Prevents production errors and improves user experience

---

### Medium Priority: Test Structure

**Pattern:** 5 PRs had tests restructured for clarity

**Suggestion:**
```markdown
## Test Structure

Use the Arrange-Act-Assert (AAA) pattern for all tests:

```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create user with valid data', async () => {
      // Arrange
      const userData = { email: 'test@test.com', name: 'Test' };
      const mockDb = createMockDb();

      // Act
      const result = await userService.createUser(userData);

      // Assert
      expect(result).toMatchObject(userData);
      expect(mockDb.insert).toHaveBeenCalledWith('users', userData);
    });
  });
});
```

**Test Coverage Requirements:**
- Overall: >80%
- Critical paths (auth, payments): >95%
- Edge cases: Must be tested explicitly
```

**Priority:** Medium
**Rationale:** 5 PRs had test clarity issues
**Impact:** Makes tests easier to understand and maintain

---

### Low Priority: Console Cleanup

**Pattern:** 3 PRs had console.log statements removed

**Suggestion:**
```markdown
## Debug Output

Use proper logging instead of console.log:

```typescript
// ✅ Good: Structured logging
logger.debug('User login attempt', { userId, timestamp });

// ❌ Bad: Console logging
console.log('User:', userId, 'at', timestamp);
```

Add eslint rule to prevent console statements:
```json
{
  "rules": {
    "no-console": ["error", { "allow": ["warn", "error"] }]
  }
}
```
```

**Priority:** Low
**Rationale:** 3 PRs needed console cleanup
**Impact:** Cleaner production code

## Avoiding Duplicates

Before suggesting:
1. Check existing CLAUDE.md for similar guidance
2. Don't duplicate existing rules
3. Enhance/clarify if rule exists but is unclear
4. Combine related suggestions

**Example:**
If CLAUDE.md already has "Use TypeScript", don't suggest it again.
If it says "Use types" but PRs show "any" usage, suggest: "Avoid `any` type, use specific types or `unknown`"

## Format Adaptation

Match the existing CLAUDE.md style:
- Heading levels
- Code block languages
- Emoji usage (or lack thereof)
- Section organization
- Example formatting

## Diff-Friendly Output

For easy application:

```markdown
### Suggested Addition to CLAUDE.md

**Location:** After "Code Conventions" section

**Add:**
<insert-markdown-here>

**Or** apply with this sed command:
```bash
sed -i '/## Code Conventions/a <escaped-content>' CLAUDE.md
```
```

## Global vs Project-Specific

Distinguish suggestions:

**Global (~/.claude/CLAUDE.md):**
- General coding principles
- Language-agnostic patterns
- Universal best practices

**Project-Specific (.claude/CLAUDE.md):**
- Project architecture
- Specific tech stack patterns
- Team conventions
- Domain-specific rules

Output separately with clear labels.
