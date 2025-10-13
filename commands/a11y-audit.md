---
description: Run comprehensive accessibility audit on current code
allowed-tools: Read, Glob, Grep, Bash(npm:*), Bash(ddev exec npm:*)
---

Perform a comprehensive accessibility audit following WCAG 2.1 Level AA guidelines.

## Instructions

1. **Identify the scope:**
   - If a file path or URL is provided as an argument, audit that specific target
   - If no argument, analyze recently changed files using `git diff`
   - Look for HTML, Twig (`.html.twig`), PHP template files, JSX/TSX files

2. **Run accessibility checks across all categories:**

   ### Perceivable
   - **Images**: Check for alt text, decorative images, complex images
   - **Color**: Validate color contrast (text, UI components, graphics)
   - **Multimedia**: Check for captions, transcripts, audio descriptions
   - **Adaptable**: Verify semantic HTML, reading order, sensory characteristics
   - **Distinguishable**: Check contrast, text sizing, text spacing, reflow

   ### Operable
   - **Keyboard**: Test keyboard accessibility, no keyboard trap, shortcuts
   - **Timing**: Check for adjustable timing, pause/stop/hide
   - **Seizures**: Validate no flashing content
   - **Navigation**: Multiple ways to navigate, descriptive headings, focus order, link purpose, focus visible
   - **Input Modalities**: Target size, pointer gestures, labels in name, motion actuation

   ### Understandable
   - **Readable**: Language attributes, unusual words, reading level
   - **Predictable**: Focus order, input changes, consistent navigation/identification
   - **Input Assistance**: Error identification, labels/instructions, error suggestions, error prevention

   ### Robust
   - **Compatible**: Valid HTML, name/role/value, status messages

3. **For each issue found, provide:**
   - **Location**: File path and line number
   - **WCAG Reference**: Success criterion number (e.g., 1.1.1, 1.4.3)
   - **Severity**: Critical, Serious, Moderate, Minor
   - **Issue Description**: Clear explanation of the problem
   - **Impact**: Who is affected and how
   - **Remediation**: Specific fix with code example

4. **Specific checks for Drupal:**
   - Form API proper usage
   - Views accessibility
   - Block accessibility
   - Menu accessibility
   - Drupal.t() usage for translatable strings
   - Theme hook implementations

5. **Specific checks for WordPress:**
   - Theme accessibility-ready tag
   - Gutenberg block accessibility
   - Widget accessibility
   - Navigation menu accessibility
   - Screen reader text usage
   - Skip links implementation

6. **Automated tool integration (if available):**
   - Reference axe-core violations if detectable
   - Reference pa11y issues if available
   - Reference WAVE findings if applicable

## Output Format

```markdown
# Accessibility Audit Report

**Scope**: [files/urls audited]
**Date**: [current date]
**WCAG Version**: 2.1 Level AA

## Executive Summary

- Total Issues Found: [count]
- Critical: [count]
- Serious: [count]
- Moderate: [count]
- Minor: [count]

## Critical Issues 🔴

### Issue 1: [Issue Title]
**WCAG**: [criterion] - [criterion name]
**Severity**: Critical
**Location**: `path/to/file.php:123`

**Problem**:
[Clear description of the accessibility violation]

**Impact**:
[Who is affected - screen reader users, keyboard users, etc.]

**Current Code**:
\`\`\`html
[problematic code]
\`\`\`

**Fixed Code**:
\`\`\`html
[corrected code with accessibility fix]
\`\`\`

**Remediation Steps**:
1. [Step-by-step fix instructions]

---

## Serious Issues 🟡

[Same format as critical]

## Moderate Issues 🟠

[Same format as critical]

## Minor Issues 🔵

[Same format as critical]

## Accessibility Wins ✅

[List things that are done well for positive reinforcement]

## Testing Recommendations

1. **Manual Testing Required**:
   - Keyboard navigation testing
   - Screen reader testing (NVDA, JAWS, VoiceOver)
   - Color contrast verification
   - [Other manual tests needed]

2. **Automated Testing**:
   - Run axe DevTools
   - Run WAVE browser extension
   - Run Lighthouse accessibility audit

## Resources

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WebAIM Articles](https://webaim.org/articles/)
- [Specific resources related to issues found]

## Next Steps

1. [Prioritized list of remediation tasks]
```

## Analysis Guidelines

- **Be thorough but practical** - Focus on issues that truly impact users
- **Provide context** - Explain why something is an accessibility issue
- **Give specific fixes** - Include actual code examples
- **Consider progressive enhancement** - Suggest improvements beyond minimum compliance
- **Check cascade effects** - Look for patterns that might affect multiple pages
