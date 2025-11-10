---
name: accessibility-checker
description: Automatically check specific elements or code for accessibility issues when user asks if something is accessible or mentions WCAG compliance. Performs focused accessibility checks on individual components, forms, or pages. Invoke when user asks "is this accessible?", "WCAG compliant?", or shows code/elements asking about accessibility.
---

# Accessibility Checker

Automatically check code and elements for accessibility issues.

## When to Use This Skill

Activate this skill when the user:
- Asks "is this accessible?"
- Shows an element and asks "does this meet WCAG?"
- Mentions "accessibility issue", "a11y", or "screen reader"
- Asks "will this work for keyboard users?"
- Questions contrast, ARIA, alt text, or form labels
- Says "check this for accessibility"

## Quick Checks

This skill performs **focused accessibility checks** on specific elements, unlike `/audit-a11y` which does comprehensive site-wide audits.

### Common Checks

**Button Accessibility:**
- Has accessible name (text, aria-label, or aria-labelledby)
- Keyboard focusable
- Proper ARIA role if custom button
- Sufficient color contrast

**Form Accessibility:**
- All inputs have associated labels
- Error messages properly linked
- Required fields indicated
- Fieldsets for related inputs

**Image Accessibility:**
- Alt text present and descriptive
- Decorative images have alt=""
- Complex images have detailed descriptions

**Link Accessibility:**
- Descriptive link text (not "click here")
- Links distinguishable from text
- Keyboard accessible

### Response Format

```markdown
## Accessibility Check: [Element Type]

### ✅ Passes
- Has proper ARIA label
- Keyboard accessible
- Sufficient color contrast (4.8:1)

### ❌ Issues Found
1. **Missing focus indicator** (WCAG 2.4.7 Level AA)
   - Current: No visible focus state
   - Fix: Add `:focus` styles with outline

2. **Low contrast** (WCAG 1.4.3 Level AA)
   - Current: 3.2:1
   - Required: 4.5:1
   - Fix: Use darker text color #333

### Suggested Code

[Provide fixed code example]
```

## Integration with /audit-a11y Command

- **This Skill**: Quick element-specific checks
  - "Is this button accessible?"
  - "Check this form for a11y"
  - Single component analysis

- **`/audit-a11y` Command**: Comprehensive site audit
  - Full WCAG 2.1 Level AA audit
  - Multiple pages analyzed
  - Detailed compliance reports

## Resources

- WCAG 2.1 Guidelines: https://www.w3.org/WAI/WCAG21/quickref/
- WebAIM Contrast Checker: https://webaim.org/resources/contrastchecker/
