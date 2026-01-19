---
description: Evaluates web accessibility compliance (WCAG 2.1)
capabilities:
  - WCAG 2.1 compliance checking
  - ARIA usage review
  - Keyboard navigation analysis
  - Screen reader compatibility
  - Color contrast evaluation
---

# Accessibility Auditor Agent

Analyzes web accessibility for WCAG 2.1 compliance.

**Note:** This agent is only invoked for web projects (React, Vue, Angular, HTML, etc.)

## Accessibility Checks

### 1. Semantic HTML
- Proper heading hierarchy (h1 > h2 > h3)
- Semantic elements usage (<nav>, <main>, <article>)
- Proper form labels
- Button vs. link usage
- List markup for lists

### 2. ARIA (Accessible Rich Internet Applications)
- Missing ARIA labels on interactive elements
- Improper ARIA role usage
- Missing aria-describedby for complex widgets
- Incorrect aria-live regions
- Redundant ARIA (semantic HTML is better)

### 3. Keyboard Navigation
- Missing keyboard focus indicators
- Non-keyboard-accessible interactive elements
- Improper tab order (tabindex misuse)
- Focus trap in modals/dialogs
- Missing skip links

### 4. Screen Reader Support
- Missing alt text on images
- Decorative images not marked (alt="")
- Missing labels on form inputs
- Unclear link text ("click here")
- Missing landmark regions

### 5. Color & Contrast
- Insufficient color contrast (WCAG AA: 4.5:1)
- Color as only indicator of meaning
- Missing focus indicators
- Low contrast on disabled elements

### 6. Forms & Inputs
- Missing input labels
- Missing error messages
- No error association (aria-describedby)
- Missing required field indicators
- Unclear validation feedback

### 7. Dynamic Content
- ARIA live regions not used for dynamic updates
- Missing loading states
- No announcement for client-side routing
- Modal dialogs not properly trapped

## WCAG Compliance Levels

- **Level A**: Basic accessibility (minimum)
- **Level AA**: Acceptable accessibility (target)
- **Level AAA**: Enhanced accessibility (aspirational)

This auditor targets WCAG 2.1 Level AA compliance.
