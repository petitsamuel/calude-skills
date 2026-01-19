---
name: prompt-patterns
description: Library of proven prompt templates for common task types
resources:
  - templates/feature-development.md
  - templates/bug-fix.md
  - templates/refactoring.md
  - templates/testing.md
  - templates/performance-optimization.md
  - templates/security-fix.md
  - templates/documentation.md
  - templates/api-development.md
---

# Prompt Patterns Skill

Provides proven prompt templates for 8 common task types.

## What This Skill Does

Offers structured templates that the prompt-engineer agent uses to create comprehensive implementation prompts. Each template is optimized for its specific task type with appropriate sections, validation steps, and completion criteria.

## Template Types

### 1. Feature Development
Full-featured template for new functionality:
- Complete requirements breakdown
- Architecture and technical design
- Implementation tasks
- Comprehensive testing requirements
- Documentation needs
- Edge cases and error handling
- Rollback plan

**Use for:** New features, new components, new modules

### 2. Bug Fix
TDD-focused template for bug resolution:
- Bug reproduction steps
- Root cause analysis
- Test-first approach
- Minimal fix strategy
- Regression prevention

**Use for:** Bug fixes, defect resolution

### 3. Refactoring
Safety-focused template for code improvement:
- Current state analysis
- Constraints (what must not break)
- Incremental refactoring steps
- Validation after each step
- Rollback plan

**Use for:** Code restructuring, architecture improvements

### 4. Testing
Test creation template:
- Coverage targets
- Test categories (unit, integration, e2e)
- Critical paths to test
- Edge cases
- Test data needs

**Use for:** Adding tests, improving coverage

### 5. Performance Optimization
Benchmark-driven template:
- Baseline metrics
- Target metrics
- Profiling strategy
- Optimization steps
- Before/after benchmarks

**Use for:** Speed improvements, optimization

### 6. Security Fix
Security-focused template:
- Threat analysis
- Security requirements
- Secure implementation
- Security testing
- Verification steps

**Use for:** Security vulnerabilities, hardening

### 7. Documentation
Documentation creation template:
- Documentation scope
- Target audience
- Completeness checklist
- Examples and tutorials
- Review criteria

**Use for:** Docs, README, API docs, guides

### 8. API Development
API-specific template:
- API contract definition
- Endpoint specifications
- Request/response schemas
- Validation rules
- Error responses
- API documentation
- API testing

**Use for:** REST APIs, GraphQL, API endpoints

## Template Selection

The prompt-engineer agent selects templates based on:
1. Task type classification from task-analyzer
2. Keywords in task description
3. User-specified `--type` flag
4. Context and requirements

## Customization

Templates are starting points. The prompt-engineer agent:
- Fills in specific requirements
- Adds project-specific context
- Adjusts validation commands
- Customizes completion criteria

## When To Use

This skill is automatically used by prompt-engineer during design phase to structure the implementation prompt appropriately for the task type.
