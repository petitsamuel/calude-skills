# Prompt Optimization: Before and After Examples

## Example 1: Feature Development

### ❌ Before (Vague)
```
Add user authentication to the app
```

**Problems:**
- No context about current state
- Unclear what "authentication" means
- No validation criteria
- No scope boundaries

### ✅ After (Optimized)
```markdown
# Goal
Implement JWT-based user authentication with registration and login

# Context
- Express.js backend at /server
- MongoDB user model exists at /server/models/User.js
- Frontend is React with fetch API
- No auth currently exists

# Tasks
1. Create /api/auth/register endpoint (POST email, password)
2. Create /api/auth/login endpoint (POST email, password, returns JWT)
3. Add JWT middleware to protect /api/user/* routes
4. Hash passwords with bcrypt (salt rounds: 10)
5. Add auth tests to /server/tests/auth.test.js

# Validation Commands
```bash
npm test -- auth
curl -X POST localhost:3000/api/auth/register -d '{"email":"test@test.com","password":"test123"}'
curl -X POST localhost:3000/api/auth/login -d '{"email":"test@test.com","password":"test123"}'
```

# Acceptance Criteria
- [ ] Users can register with email/password
- [ ] Passwords are hashed (not stored plain)
- [ ] Login returns valid JWT token
- [ ] Protected routes reject requests without valid token
- [ ] All tests passing (npm test)
- [ ] Build succeeds (npm run build)

Output: <promise>AUTH_COMPLETE</promise>
```

---

## Example 2: Bug Fix

### ❌ Before (Missing Context)
```
Fix the memory leak
```

**Problems:**
- Which memory leak?
- Where is it?
- How do we know it's fixed?

### ✅ After (Optimized)
```markdown
# Goal
Fix memory leak in WebSocket connection handler at server/websocket.js:45

# Context
- Memory usage grows 50MB/hour under load
- Profiler shows EventEmitter listeners not cleaned up
- Issue occurs when clients disconnect without proper close handshake
- Affects production server with 1000+ concurrent connections

# Current Behavior
```javascript
socket.on('disconnect', () => {
  // Handler doesn't remove all listeners
  console.log('Client disconnected');
});
```

# Expected Behavior
All event listeners should be removed when socket disconnects

# Tasks
1. Add listener cleanup in disconnect handler
2. Add test that verifies listener count decreases
3. Run 1-hour memory test to confirm leak is fixed
4. Add documentation comment explaining cleanup

# Validation Commands
```bash
npm test -- websocket
npm run test:memory -- --duration=3600
node --inspect server/debug-memory.js
```

# Acceptance Criteria
- [ ] Memory usage stable over 1 hour (<5% growth)
- [ ] Listener count decreases on disconnect (test verifies)
- [ ] Existing WebSocket tests still pass
- [ ] No regression in connection handling

Output: <promise>LEAK_FIXED</promise>
```

---

## Example 3: Refactoring

### ❌ Before (No Validation)
```
Refactor the API code
```

**Problems:**
- What needs refactoring?
- Why?
- How do we know we didn't break anything?

### ✅ After (Optimized)
```markdown
# Goal
Extract duplicate API client code into reusable service class

# Context
- 6 files have duplicate fetch + error handling: user.js, product.js, order.js, cart.js, review.js, payment.js
- Each has ~30 lines of boilerplate
- No consistent error handling
- No retry logic

# Current Pattern (Duplicated)
```javascript
async function getUser(id) {
  try {
    const res = await fetch(`/api/users/${id}`);
    if (!res.ok) throw new Error('Failed');
    return await res.json();
  } catch (err) {
    console.error(err);
    return null;
  }
}
```

# Target Pattern
```javascript
const apiClient = new APIClient();
async function getUser(id) {
  return apiClient.get(`/users/${id}`);
}
```

# Tasks
1. Create services/APIClient.js with get/post/put/delete methods
2. Add error handling, retry logic, and timeout to APIClient
3. Update all 6 files to use APIClient
4. Remove duplicate code (verify with: git diff --stat)
5. Ensure all tests still pass

# Validation Commands
```bash
npm test
npm run lint
git diff --stat  # Should show net reduction in LOC
```

# Acceptance Criteria
- [ ] APIClient handles all HTTP methods
- [ ] All 6 files updated to use APIClient
- [ ] No duplicate fetch logic remains
- [ ] All existing tests pass (no behavior change)
- [ ] Code coverage maintained or improved
- [ ] Net reduction of >100 lines

Output: <promise>REFACTORED</promise>
```

---

## Example 4: Performance Optimization

### ❌ Before (No Baseline)
```
Make the API faster
```

**Problems:**
- How fast is it now?
- How fast should it be?
- How do we measure success?

### ✅ After (Optimized)
```markdown
# Goal
Reduce /api/products response time from 2.4s to <500ms

# Context
- Current avg: 2.4s (measured via `npm run benchmark`)
- Endpoint fetches 1000 products from MongoDB
- No pagination, no caching, no indexes
- Called 500x/min in production

# Baseline Metrics
```bash
$ npm run benchmark
/api/products: avg 2400ms, p95 3100ms, p99 4200ms
```

# Target Metrics
- Average: <500ms (80% improvement)
- P95: <800ms
- P99: <1200ms

# Optimization Plan
1. Add MongoDB index on products.category
2. Implement pagination (limit=50, offset)
3. Add Redis cache (TTL=5min)
4. Lazy load product images

# Tasks
1. Profile current query (explain plan)
2. Add index: db.products.createIndex({category: 1, createdAt: -1})
3. Update controller to use pagination
4. Add Redis caching layer
5. Benchmark after each change
6. Verify all tests still pass

# Validation Commands
```bash
npm run benchmark  # Should show <500ms avg
npm test
npm run load-test  # 1000 req/min for 5 min
```

# Acceptance Criteria
- [ ] Average response time <500ms
- [ ] P95 <800ms, P99 <1200ms
- [ ] All tests passing
- [ ] Load test shows stable performance
- [ ] No new errors in logs

Output: <promise>OPTIMIZED</promise>
```

---

## Key Improvements Summary

| Aspect | Before | After |
|--------|--------|-------|
| **Clarity** | Vague | Specific goal with context |
| **Scope** | Unbounded | Clear start/end |
| **Validation** | None | Commands + criteria |
| **Context** | Missing | Current state + constraints |
| **Measurability** | Subjective | Objective metrics |
| **Completeness** | Implicit | Explicit promise signal |

---

## Prompt Optimization Checklist

Use this when reviewing prompts:

- [ ] **Context**: Does it explain current state?
- [ ] **Goal**: Is the objective clear and specific?
- [ ] **Scope**: Are boundaries defined?
- [ ] **Steps**: Is it broken into phases?
- [ ] **Validation**: Are there verification commands?
- [ ] **Criteria**: Are success conditions measurable?
- [ ] **Examples**: Are patterns/formats shown?
- [ ] **Promise**: Is there a completion signal?
- [ ] **Recovery**: Does it handle errors?
- [ ] **Constraints**: Are limits specified?
