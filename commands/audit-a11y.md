---
description: Comprehensive accessibility audit with WCAG 2.1 Level AA compliance using accessibility specialist
argument-hint: "[focus-area]"
allowed-tools: Task
---

I'll use the **accessibility specialist** agent to perform a comprehensive WCAG 2.1 Level AA accessibility audit.

## Usage

**Full Audit:**
- `/audit-a11y` - Complete WCAG 2.1 AA audit with detailed findings

**Focused Checks:**
- `/audit-a11y contrast` - Check color contrast only (WCAG 1.4.3)
- `/audit-a11y aria` - Check ARIA attributes only
- `/audit-a11y headings` - Check heading hierarchy only
- `/audit-a11y forms` - Check form accessibility only
- `/audit-a11y alt-text` - Check image alt text only
- `/audit-a11y keyboard` - Check keyboard navigation only

**Reporting & Fixes:**
- `/audit-a11y checklist` - Generate WCAG 2.1 AA compliance checklist
- `/audit-a11y report` - Generate stakeholder-friendly compliance report
- `/audit-a11y fix` - Generate specific code fixes for identified issues

**Quick Element Checks:**
For quick accessibility checks on specific buttons, forms, or elements during conversation, the **accessibility-checker** Agent Skill auto-activates when you ask "is this accessible?" See: [`skills/accessibility-checker/SKILL.md`](../skills/accessibility-checker/SKILL.md)

---

## How It Works

This command spawns the **accessibility-specialist** agent, which uses the **accessibility-checker** skill and performs comprehensive WCAG 2.1 Level AA audits.

### The Accessibility Specialist Will

1. **Run comprehensive WCAG checks** across all 4 principles:
   - **Perceivable** - Images, color contrast, multimedia, semantic structure
   - **Operable** - Keyboard access, navigation, timing, seizures
   - **Understandable** - Readable content, predictable behavior, input assistance
   - **Robust** - Valid HTML, ARIA implementation, status messages

2. **Analyze platform-specific patterns**:
   - **Drupal**: Form API, Views, blocks, menus, theme hooks
   - **WordPress**: Block editor, widgets, theme templates, navigation menus

3. **Test keyboard navigation**:
   - Tab order and focus management
   - Skip links and landmarks
   - Keyboard traps detection
   - Focus indicators visibility

4. **Validate color contrast**:
   - Text contrast (4.5:1 for normal, 3:1 for large)
   - UI components (3:1 minimum)
   - All interactive states (hover, focus, active)

5. **Check ARIA usage**:
   - Proper roles and attributes
   - Required ARIA attributes present
   - No redundant ARIA on native elements
   - Valid ARIA relationships

6. **Generate actionable reports**:
   - Prioritized issues (Critical → Serious → Moderate → Minor)
   - Code examples (before/after)
   - Specific file locations and line numbers
   - Remediation steps and effort estimates

---

## What Gets Audited

### Perceivable (WCAG Principle 1)

**Images & Non-Text Content (1.1.1)**:
- Alt text on all images
- Decorative images use `alt=""`
- Icons with meaning have text alternatives
- Complex images have detailed descriptions

**Color & Contrast (1.4.1, 1.4.3, 1.4.11)**:
- Text contrast ≥ 4.5:1 (normal), ≥ 3:1 (large)
- UI components contrast ≥ 3:1
- Color not sole indicator of information

**Multimedia (1.2.1, 1.2.2, 1.2.5)**:
- Videos have captions
- Audio has transcripts
- Audio descriptions where needed

**Adaptable Content (1.3.1, 1.3.2, 1.3.3)**:
- Semantic HTML structure
- Logical reading order
- No sensory-only instructions

### Operable (WCAG Principle 2)

**Keyboard Access (2.1.1, 2.1.2)**:
- All functionality via keyboard
- No keyboard traps
- Custom elements have keyboard support

**Navigation (2.4.1-2.4.7)**:
- Skip links present
- Descriptive page titles
- Logical focus order
- Clear link purpose
- Multiple navigation paths
- Visible focus indicators

**Timing (2.2.1, 2.2.2)**:
- Adjustable timing
- Pause/stop/hide controls for moving content

**No Seizures (2.3.1)**:
- No content flashes > 3 times/second

### Understandable (WCAG Principle 3)

**Readable (3.1.1, 3.1.2)**:
- Page language defined
- Language changes marked

**Predictable (3.2.1-3.2.4)**:
- No unexpected context changes
- Consistent navigation
- Consistent component identification

**Input Assistance (3.3.1-3.3.4)**:
- Form errors identified
- Labels and instructions provided
- Error suggestions offered
- Important actions reversible

### Robust (WCAG Principle 4)

**Compatible (4.1.1, 4.1.2, 4.1.3)**:
- Valid HTML markup
- Name, role, value for UI components
- Status messages accessible

---

## CMS-Specific Audits

### Drupal Projects

The accessibility specialist checks:
- **Form API** - Proper label usage, required field indicators
- **Views** - Table captions, accessible pagers, exposed filters
- **Blocks** - Landmark regions, semantic structure
- **Menus** - Proper navigation markup, aria-labels
- **Admin UI** - Keyboard navigation, modal focus management

### WordPress Projects

The accessibility specialist checks:
- **Block Editor** - Gutenberg block accessibility, aria-labels
- **Widgets** - Widget titles as proper headings, keyboard access
- **Theme Templates** - Semantic HTML5, skip links, navigation
- **Navigation Menus** - Proper aria attributes, screen reader text
- **Admin Customizer** - Focus management, keyboard controls

---

## Output Formats

### Comprehensive Audit Report

```markdown
# Accessibility Audit Report

**Scope**: [files/urls audited]
**Date**: [date]
**WCAG Version**: 2.1 Level AA

## Executive Summary
- Total Issues: [count]
- Critical: [count] | Serious: [count] | Moderate: [count] | Minor: [count]
- Overall Status: [Pass/Partial/Non-Conformance]

## Critical Issues 🔴
[Issues that completely block access - must fix immediately]

## Serious Issues 🟡
[Major barriers to access - high priority]

## Moderate Issues 🟠
[Significant inconveniences - medium priority]

## Minor Issues 🔵
[Minor improvements - low priority]

## Accessibility Wins ✅
[Things done well - positive reinforcement]

## WCAG Principle Summary
[Compliance status by Perceivable, Operable, Understandable, Robust]

## Testing Recommendations
[Manual and automated testing steps]

## Priority Actions
[Ordered list with time estimates and impact]
```

### Focus Area Reports

When using focused checks (`/audit-a11y contrast`, `/audit-a11y aria`, etc.), the accessibility specialist provides targeted reports for that specific area only.

### Compliance Checklist

Generate a comprehensive WCAG 2.1 Level AA checklist for project sign-off and ongoing compliance tracking.

### Stakeholder Report

Executive-friendly report with business impact, legal considerations, remediation roadmap, and ROI analysis.

### Fix Generation

Code-level fixes with before/after examples, implementation steps, and effort estimates prioritized by impact.

---

## Quick Start (Kanopi Projects)

### Pre-Audit Quality Checks

```bash
# Check code quality first
ddev composer code-check    # Drupal
ddev composer phpstan       # WordPress

# Check dependencies
ddev composer audit
ddev exec npm audit
```

### Run Accessibility Tests

```bash
# Install testing tools
ddev exec npm install --save-dev @axe-core/cli pa11y lighthouse

# Run automated tools
ddev exec npx axe [url]
ddev exec npx pa11y [url]
ddev exec npx lighthouse [url] --only-categories=accessibility
```

---

## Testing Tools

**Automated Tools** (catch ~30-40% of issues):
- **axe DevTools** - Browser extension, best automated tool
- **WAVE** - WebAIM's accessibility checker
- **Lighthouse** - Built into Chrome DevTools
- **pa11y** - Command-line testing

**Manual Testing Required** (for full WCAG compliance):
- **Screen Readers**:
  - NVDA (Windows, free)
  - JAWS (Windows, paid)
  - VoiceOver (macOS, built-in with Cmd+F5)
- **Keyboard Testing**: Tab, Enter, Space, Arrow keys, Escape
- **Contrast Checker**: https://contrast-ratio.com/
- **Zoom Test**: 200% zoom level
- **Reflow Test**: 320px viewport width

**Remember**: Automated tools catch less than half of issues. Manual testing with actual assistive technologies is essential for true WCAG 2.1 AA compliance.

---

## Related Commands

- **[`/pr-create`](pr-create.md)** - PR creation includes a11y checks for UI changes
- **[`/pr-review`](pr-review.md)** - PR reviews include accessibility analysis
- **[`/audit-live-site`](audit-live-site.md)** - Comprehensive audits include accessibility

## Agent Used

**accessibility-specialist** - WCAG 2.1 Level AA compliance specialist with platform-specific knowledge for Drupal and WordPress.

## What Makes This Different

**Before (manual a11y review):**
- Check accessibility yourself with tools
- Miss CMS-specific patterns
- No prioritized remediation roadmap
- Incomplete WCAG coverage

**With accessibility-specialist:**
- ✅ Comprehensive WCAG 2.1 AA audit
- ✅ Automated + manual testing methodology
- ✅ CMS-specific pattern validation (Drupal/WordPress)
- ✅ Prioritized issues (Critical → Minor)
- ✅ Code fixes with before/after examples
- ✅ Stakeholder-friendly reports
- ✅ Legal/compliance guidance
- ✅ Remediation roadmap with effort estimates
