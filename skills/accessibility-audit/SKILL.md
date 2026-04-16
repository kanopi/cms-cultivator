---
name: accessibility-audit
description: Comprehensive WCAG 2.1 Level AA accessibility audit for Drupal and WordPress projects. Spawns accessibility-specialist for full site analysis. Invoke when user runs /audit-a11y, requests a full accessibility audit, needs a WCAG compliance report, or asks for comprehensive accessibility analysis across pages or modules. Supports --quick, --standard, --comprehensive depth modes and scope/format flags.
disable-model-invocation: true
---

# Accessibility Audit

Comprehensive WCAG 2.1 Level AA accessibility audit using the accessibility-specialist agent.

## Usage

- `/audit-a11y` — Full WCAG 2.1 AA audit (standard depth)
- `/audit-a11y --quick --scope=current-pr` — Pre-commit check on PR changes
- `/audit-a11y --comprehensive --format=summary` — Pre-release deep audit with executive summary
- `/audit-a11y --standard --format=json` — CI/CD integration output
- `/audit-a11y contrast` — Legacy focus area (still supported)

## Arguments

### Depth Modes
- `--quick` — Critical WCAG AA failures only (~5 min)
- `--standard` — Full WCAG AA audit (default, ~15 min)
- `--comprehensive` — WCAG AA + AAA + best practices (~30 min)

### Scope Control
- `--scope=current-pr` — Only files changed in current PR (uses git diff)
- `--scope=module=<name>` — Specific module/directory
- `--scope=file=<path>` — Single file
- `--scope=entire` — Full codebase (default)

### Output Formats
- `--format=report` — Detailed markdown report (default)
- `--format=json` — Structured JSON for CI/CD
- `--format=summary` — Executive summary
- `--format=checklist` — Simple pass/fail checklist

### Legacy Focus Areas (Still Supported)
`contrast`, `keyboard`, `aria`, `semantic-html`, `headings`, `forms`, `alt-text`

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() or bash tools are unavailable, perform accessibility analysis directly:

1. **Parse arguments** — Determine depth mode, scope, format, and any legacy focus area from the user's request
2. **Identify files to analyze** — Read project structure using Glob and Grep to find relevant HTML, PHP, Twig, and template files
3. **Analyze accessibility directly**:
   - Use Read to examine files for semantic HTML, ARIA attributes, form labels, alt text
   - Calculate color contrast from CSS/SCSS color values
   - Check heading hierarchy and landmark regions
   - Review keyboard accessibility patterns
   - Identify CMS-specific patterns (Drupal Form API, WordPress block markup)
4. **Generate report** — Format findings per requested output format, prioritized Critical → Serious → Moderate → Minor
5. **Save report** — Write to `audit-a11y-YYYY-MM-DD-HHMM.md` and present path to user

**Supported checks in Tier 1**: semantic HTML, ARIA usage, form labels, alt text, heading hierarchy, color values in CSS, keyboard patterns visible in code.

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() available:

1. **Parse arguments** — Determine depth, scope, format, and focus area
2. **Determine files** — For `--scope=current-pr`, run:
   ```bash
   git diff --name-only origin/main...HEAD | grep -E '\.(php|tsx?|jsx?|twig|html|css|scss)$'
   ```
3. **Spawn accessibility-specialist**:
   ```
   Task(cms-cultivator:accessibility-specialist:accessibility-specialist,
        prompt="Perform a comprehensive WCAG 2.1 Level AA accessibility audit with:
          - Depth mode: {depth}
          - Scope: {scope}
          - Format: {format}
          - Focus area: {focus or 'complete audit'}
          - Files to analyze: {file_list}
        Check semantic HTML, ARIA, keyboard navigation, color contrast, and screen reader compatibility for both Drupal and WordPress patterns. Save the comprehensive audit report to audit-a11y-YYYY-MM-DD-HHMM.md and present the file path to the user.")
   ```
4. **Present results** to user with file path

## What Gets Audited

### Perceivable (WCAG Principle 1)
- Alt text on images (1.1.1), decorative images have `alt=""`
- Color contrast ≥ 4.5:1 normal text, ≥ 3:1 large text (1.4.3, 1.4.11)
- Color not sole indicator of information (1.4.1)
- Semantic HTML structure and logical reading order (1.3.1, 1.3.2)

### Operable (WCAG Principle 2)
- All functionality via keyboard, no keyboard traps (2.1.1, 2.1.2)
- Skip links, descriptive titles, logical focus order (2.4.1–2.4.7)
- Visible focus indicators on all interactive elements

### Understandable (WCAG Principle 3)
- Page language defined (3.1.1), language changes marked (3.1.2)
- Consistent navigation and component identification (3.2.3, 3.2.4)
- Form errors identified, labels provided, error suggestions offered (3.3.1–3.3.4)

### Robust (WCAG Principle 4)
- Valid HTML markup (4.1.1), name/role/value for UI components (4.1.2)
- Status messages accessible without focus (4.1.3)

## CMS-Specific Checks

**Drupal**: Form API label usage, Views table captions, block landmark regions, menu aria-labels, admin keyboard navigation

**WordPress**: Block editor aria-labels, widget headings, theme template skip links, navigation aria attributes, Customizer focus management

## Output Report Format

```markdown
# Accessibility Audit Report

**Scope**: [files audited]
**Date**: [date]
**WCAG Version**: 2.1 Level AA

## Executive Summary
- Total Issues: [count]
- Critical: [count] | Serious: [count] | Moderate: [count] | Minor: [count]
- Overall Status: [Pass/Partial/Non-Conformance]

## Critical Issues 🔴
## Serious Issues 🟡
## Moderate Issues 🟠
## Minor Issues 🔵
## Accessibility Wins ✅
## Priority Actions
```

## Quick Start (Kanopi Projects)

```bash
ddev exec npx axe [url]
ddev exec npx pa11y [url]
ddev exec npx lighthouse [url] --only-categories=accessibility
```

## Related Skills

- **accessibility-checker** — Quick element-specific checks during development (auto-activates on "is this accessible?")
- **audit-export** — Export findings to CSV for project management tools
- **audit-report** — Generate client-facing executive summary from audit file
