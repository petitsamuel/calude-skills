# Security Fix Template

```markdown
# Security Fix: {{vulnerability_type}}

## Threat Analysis
**Vulnerability:** {{vulnerability_description}}
**CVE:** {{cve_id}}
**CVSS Score:** {{cvss_score}}
**Attack Vector:** {{attack_vector}}
**Impact:** {{impact}}

## Security Requirements
- {{requirement_1}}
- {{requirement_2}}
- Input validation
- Output encoding
- Access control

## Implementation Tasks
1. Analyze vulnerability
2. Implement secure solution
3. Add security tests
4. Verify no bypass possible
5. Document fix

## Acceptance Criteria
- [ ] Vulnerability patched
- [ ] Security tests added
- [ ] No bypass vectors
- [ ] Input validated
- [ ] All tests passing

## Security Testing
```bash
{{security_test_command}}
{{test_command}}
```

Output: <promise>SECURITY_FIXED</promise>
```
