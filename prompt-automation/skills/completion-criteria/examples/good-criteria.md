# Examples of Well-Formed Completion Criteria

## Example 1: Feature Development

**Task:** Add user authentication with JWT

**Completion Criteria:**
- [ ] User can register with email/password
- [ ] User can login and receive JWT token
- [ ] Protected routes reject unauthenticated requests
- [ ] Token refresh mechanism works
- [ ] All auth tests passing (`npm test -- auth`)
- [ ] No new TypeScript errors (`npm run type-check`)
- [ ] Build succeeds (`npm run build`)
- [ ] Git status shows only expected changes

**Validation Commands:**
```bash
npm test -- auth
npm run type-check
npm run build
git status
```

**Completion Promise:**
```
Output: <promise>AUTH_IMPLEMENTED</promise>
```

---

## Example 2: Bug Fix

**Task:** Fix memory leak in WebSocket connection handler

**Completion Criteria:**
- [ ] Memory usage stable over 1 hour test period
- [ ] No unclosed connections in logs
- [ ] Existing WebSocket tests still passing
- [ ] New regression test added and passing
- [ ] Memory profiler shows no leaks
- [ ] Build succeeds without warnings

**Validation Commands:**
```bash
npm test -- websocket
npm run test:memory-leak
npm run build
```

**Completion Promise:**
```
Output: <promise>LEAK_FIXED</promise>
```

---

## Example 3: Refactoring

**Task:** Extract API client logic into reusable service

**Completion Criteria:**
- [ ] All API calls use new service
- [ ] No duplicate API logic remains
- [ ] All existing tests still passing
- [ ] New service unit tests added
- [ ] Test coverage maintained or improved
- [ ] No behavior changes (regression test suite passes)
- [ ] TypeScript compilation clean
- [ ] Linting passes

**Validation Commands:**
```bash
npm test
npm run coverage
npm run lint
npm run type-check
git diff --stat
```

**Completion Promise:**
```
Output: <promise>REFACTORING_COMPLETE</promise>
```

---

## Example 4: Performance Optimization

**Task:** Reduce API response time by 50%

**Completion Criteria:**
- [ ] Baseline measurement: 400ms average
- [ ] Target achieved: <200ms average
- [ ] P95 latency <300ms
- [ ] P99 latency <500ms
- [ ] All tests still passing
- [ ] No new errors in logs
- [ ] Load test confirms improvements

**Validation Commands:**
```bash
npm test
npm run benchmark
npm run load-test
```

**Completion Promise:**
```
Output: <promise>PERFORMANCE_IMPROVED</promise>
```

---

## Key Patterns in Good Criteria

### 1. Specific and Measurable
❌ Bad: "Code should be better"
✅ Good: "Test coverage >80% and all tests passing"

### 2. Verifiable Through Commands
❌ Bad: "Should look good"
✅ Good: "npm run lint passes with 0 errors"

### 3. Includes Regression Prevention
❌ Bad: "New feature works"
✅ Good: "New feature works AND existing tests still pass"

### 4. Clear Success Signal
❌ Bad: No completion indicator
✅ Good: "Output: <promise>TASK_COMPLETE</promise>"

### 5. Multiple Validation Layers
- Functional (does it work?)
- Technical (does it build/test?)
- Process (is git clean?)
- Quality (performance/security/coverage?)

### 6. Objective Not Subjective
❌ Bad: "Code is clean and maintainable"
✅ Good: "Complexity score <10, no duplicate code >5 lines"
