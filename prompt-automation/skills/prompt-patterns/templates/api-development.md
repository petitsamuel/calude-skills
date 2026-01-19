# API Development Template

```markdown
# Task: Build {{api_name}}

## API Contract
{{#each endpoints}}
### {{this.method}} {{this.path}}
**Description:** {{this.description}}

**Request:**
```json
{{this.request_schema}}
```

**Response:**
```json
{{this.response_schema}}
```

**Status Codes:**
- 200: {{this.success_description}}
- 400: {{this.validation_error}}
- 401: {{this.auth_error}}
- 404: {{this.not_found}}
- 500: {{this.server_error}}
{{/each}}

## Validation Rules
{{#each validation_rules}}
- {{this}}
{{/each}}

## Error Response Format
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "details": {}
  }
}
```

## Implementation Tasks
1. Define routes
2. Implement endpoints
3. Add validation middleware
4. Add error handling
5. Write API tests
6. Generate OpenAPI docs

## Acceptance Criteria
- [ ] All endpoints implemented
- [ ] Validation working
- [ ] Error handling consistent
- [ ] API tests passing
- [ ] OpenAPI docs generated
- [ ] Postman collection created

## Validation
```bash
{{test_command}}
curl {{test_endpoint}}
```

Output: <promise>API_COMPLETE</promise>
```
