---
description: Comprehensive accessibility audit with WCAG 2.1 Level AA compliance using accessibility specialist
argument-hint: "[options]"
allowed-tools: Task, Bash(git:*)
---

Spawn the **accessibility-specialist** agent using:

```
Task(cms-cultivator:accessibility-specialist:accessibility-specialist,
     prompt="Perform a comprehensive WCAG 2.1 Level AA accessibility audit with the following parameters:
       - Depth mode: [quick/standard/comprehensive - parsed from arguments, default: standard]
       - Scope: [current-pr/module/file/entire - parsed from arguments, default: entire]
       - Format: [report/json/summary/checklist - parsed from arguments, default: report]
       - Focus area: [use legacy focus argument if provided, otherwise 'complete audit']
       - Files to analyze: [file list based on scope]
     Check semantic HTML, ARIA, keyboard navigation, color contrast, and screen reader compatibility for both Drupal and WordPress patterns. Save the comprehensive audit report to a file (audit-a11y-YYYY-MM-DD-HHMM.md) and present the file path to the user.")
```

## Arguments

This command supports flexible argument modes for different use cases:

### Depth Modes
- `--quick` - Critical WCAG AA failures only (~5 min) - Focus on Level A violations and high-severity issues
- `--standard` - Full WCAG AA audit (default, ~15 min) - Comprehensive Level AA compliance check
- `--comprehensive` - WCAG AA + AAA + best practices (~30 min) - Deep analysis including AAA and recommendations

### Scope Control
- `--scope=current-pr` - Only files changed in current PR (uses git diff)
- `--scope=module=<name>` - Specific module/directory (e.g., `--scope=module=src/components`)
- `--scope=file=<path>` - Single file (e.g., `--scope=file=src/Button.tsx`)
- `--scope=entire` - Full codebase (default)

### Output Formats
- `--format=report` - Detailed markdown report with examples and recommendations (default)
- `--format=json` - Structured JSON for CI/CD integration
- `--format=summary` - Executive summary with high-level findings
- `--format=checklist` - Simple pass/fail checklist with issue counts

### Legacy Focus Areas (Still Supported)
For backward compatibility, single-word focus areas without `--` prefix are treated as legacy focus filters:
- `contrast` - Focus on color contrast checks (WCAG 1.4.3)
- `keyboard` - Focus on keyboard navigation checks
- `aria` - Focus on ARIA usage checks
- `semantic-html` - Focus on HTML structure checks
- `headings` - Focus on heading hierarchy
- `forms` - Focus on form accessibility
- `alt-text` - Focus on image alt text

## Usage Examples

### Quick Checks
```bash
# Quick pre-commit check on your changes
/audit-a11y --quick --scope=current-pr

# Quick check with checklist output
/audit-a11y --quick --scope=current-pr --format=checklist

# Quick check on specific module
/audit-a11y --quick --scope=module=user-profile
```

### Standard Audits
```bash
# Standard audit (same as legacy `/audit-a11y`)
/audit-a11y

# Standard audit on PR changes
/audit-a11y --scope=current-pr

# Standard audit with JSON output for CI/CD
/audit-a11y --standard --format=json
```

### Comprehensive Audits
```bash
# Comprehensive pre-release audit
/audit-a11y --comprehensive

# Comprehensive audit with executive summary
/audit-a11y --comprehensive --format=summary

# Comprehensive audit on specific file
/audit-a11y --comprehensive --scope=file=src/components/Header.tsx
```

### Legacy Syntax (Still Works)
```bash
# Focus on specific area (legacy)
/audit-a11y contrast
/audit-a11y keyboard
/audit-a11y aria

# Combine legacy focus with new modes
/audit-a11y contrast --quick
/audit-a11y forms --scope=current-pr
```

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

## Tool Usage

**Allowed operations:**
- ✅ Spawn accessibility-specialist agent
- ✅ Read code files for semantic HTML analysis
- ✅ Run automated accessibility tools (pa11y, axe-core, Lighthouse)
- ✅ Analyze color contrast ratios
- ✅ Test keyboard navigation patterns
- ✅ Generate WCAG compliance reports

**Not allowed:**
- ❌ Do not modify code directly (provide fixes in report)
- ❌ Do not commit changes
- ❌ Do not install accessibility tools (suggest installation if needed)

The accessibility-specialist agent performs all audit operations.

---

## How It Works

This command spawns the **accessibility-specialist** agent, which uses the **accessibility-checker** skill and performs comprehensive WCAG 2.1 Level AA audits.

### 1. Parse Arguments

The command first parses the arguments to determine the audit parameters:

**Depth mode:**
- Check for `--quick`, `--standard`, or `--comprehensive` flags
- Default: `--standard` (if not specified)

**Scope:**
- Check for `--scope=<value>` flag
- If `--scope=current-pr`: Get changed files using `git diff --name-only origin/main...HEAD`
- If `--scope=module=<name>`: Target specific directory
- If `--scope=file=<path>`: Target single file
- Default: `--scope=entire` (analyze entire codebase)

**Format:**
- Check for `--format=<value>` flag
- Options: `report` (default), `json`, `summary`, `checklist`
- Default: `--format=report`

**Legacy focus area:**
- If argument doesn't start with `--`, treat as legacy focus area
- Examples: `contrast`, `keyboard`, `aria`, `forms`, `headings`, `alt-text`
- Can be combined with new flags: `/audit-a11y contrast --quick`

### 2. Determine Files to Analyze

Based on the scope parameter:

**For `current-pr`:**
```bash
git diff --name-only origin/main...HEAD | grep -E '\.(php|tsx?|jsx?|twig|html|css|scss)$'
```

**For `module=<name>`:**
```bash
find <module-path> -type f -name "*.php" -o -name "*.tsx" -o -name "*.jsx" -o -name "*.twig"
```

**For `file=<path>`:**
Analyze the single specified file.

**For `entire`:**
Analyze all relevant files in the codebase.

### 3. Spawn Accessibility Specialist

Pass all parsed parameters to the agent:
```
Task(cms-cultivator:accessibility-specialist:accessibility-specialist,
     prompt="Run WCAG 2.1 Level AA accessibility audit with:
       - Depth mode: {depth}
       - Scope: {scope}
       - Format: {format}
       - Focus area: {focus or 'complete audit'}
       - Files to analyze: {file_list}")
```

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
