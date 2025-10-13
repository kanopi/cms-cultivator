---
description: Generate WCAG 2.1 Level AA compliance checklist
allowed-tools: Read, Glob, Grep, Write
---

Create a comprehensive accessibility checklist based on WCAG 2.1 Level AA.

## Instructions

1. **Generate checklist** covering all WCAG criteria
2. **Customize for project type** (Drupal/WordPress/custom)
3. **Include testing guidance**
4. **Provide resources**

## Output Format

```markdown
# Accessibility Compliance Checklist

## Perceivable

### Images & Non-Text Content
- [ ] All images have appropriate alt text (1.1.1)
- [ ] Decorative images use alt="" (1.1.1)
- [ ] Complex images have long descriptions (1.1.1)
- [ ] Icons convey meaning have text alternatives (1.1.1)

### Color & Contrast
- [ ] Color contrast ratio ≥ 4.5:1 for normal text (1.4.3)
- [ ] Color contrast ratio ≥ 3:1 for large text (1.4.3)
- [ ] UI component contrast ≥ 3:1 (1.4.11)
- [ ] Color not sole means of conveying information (1.4.1)

### Multimedia
- [ ] Videos have captions (1.2.2)
- [ ] Audio content has transcripts (1.2.1)
- [ ] Videos have audio descriptions where needed (1.2.5)

### Adaptable Content
- [ ] Content structure uses semantic HTML (1.3.1)
- [ ] Reading order is logical (1.3.2)
- [ ] Instructions don't rely on sensory characteristics (1.3.3)

## Operable

### Keyboard Access
- [ ] All functionality available via keyboard (2.1.1)
- [ ] No keyboard traps (2.1.2)
- [ ] Skip links present (2.4.1)
- [ ] Focus order is logical (2.4.3)
- [ ] Focus visible for all elements (2.4.7)

### Navigation
- [ ] Multiple ways to find pages (2.4.5)
- [ ] Headings and labels descriptive (2.4.6)
- [ ] Link purpose clear from context (2.4.4)
- [ ] Page has descriptive title (2.4.2)

## Understandable

### Readable
- [ ] Page language defined (3.1.1)
- [ ] Language changes marked (3.1.2)
- [ ] Content readable and understandable (3.1.5)

### Predictable
- [ ] Navigation consistent across pages (3.2.3)
- [ ] Components consistently identified (3.2.4)
- [ ] Context changes clearly indicated (3.2.2)

### Input Assistance
- [ ] Form errors identified (3.3.1)
- [ ] Labels and instructions provided (3.3.2)
- [ ] Error suggestions offered (3.3.3)
- [ ] Important actions can be reversed (3.3.4)

## Robust

### Compatible
- [ ] HTML validates (4.1.1)
- [ ] Name, role, value present for all UI components (4.1.2)
- [ ] Status messages accessible (4.1.3)

## Testing Procedures

### Automated Testing
- [ ] Run axe DevTools
- [ ] Run Lighthouse audit
- [ ] Run WAVE evaluation

### Manual Testing
- [ ] Keyboard navigation test
- [ ] Screen reader test (NVDA/JAWS/VoiceOver)
- [ ] Zoom to 200% test
- [ ] Color contrast verification

### Browser Testing
- [ ] Chrome + NVDA
- [ ] Firefox + NVDA
- [ ] Safari + VoiceOver
- [ ] Edge + JAWS

## Sign-off

- [ ] All critical issues resolved
- [ ] All serious issues resolved
- [ ] Moderate issues documented
- [ ] Testing completed
- [ ] Documentation updated

**Auditor**: _______________
**Date**: _______________
**WCAG Level**: AA
**Conformance**: [ ] Full  [ ] Partial
```
