---
description: "Validate design implementation in browser using browser validator specialist with Chrome DevTools MCP"
argument-hint: "[test-url] [design-reference]"
allowed-tools: Task
---

Spawn the **browser-validator-specialist** agent for comprehensive browser-based validation:

```
Task(cms-cultivator:browser-validator-specialist:browser-validator-specialist,
     prompt="Validate the design implementation at the provided URL.

# Browser-Based Validation

## Test URL
{User's test-url}

## Design Reference (Optional)
{User's design-reference if provided, or 'Not provided'}

## Validation Requirements

### Responsive Behavior Testing
Test at all standard breakpoints:
- Mobile: 320px x 568px
- Tablet: 768px x 1024px
- Desktop: 1024px x 768px
- Large Desktop: 1920px x 1080px (optional)

For each breakpoint:
1. Resize viewport using Chrome DevTools MCP
2. Capture screenshot: screenshots/{component}/{{breakpoint}}-{{width}}px.png
3. Analyze layout for issues:
   - Text overflow or truncation
   - Images extending beyond viewport
   - Horizontal scrolling (should not occur)
   - Broken layouts or misaligned elements
   - Touch targets < 44px (on mobile)
   - Font sizes < 16px (on mobile)

### Accessibility Compliance (WCAG 2.1 Level AA)

**Color Contrast**:
- Calculate exact contrast ratios for all text
- Normal text: 4.5:1 minimum
- Large text (18pt+ or 14pt+ bold): 3:1 minimum
- Report failures with file paths and fixes

**Semantic HTML**:
- Verify heading hierarchy (h1 → h2 → h3, no skipped levels)
- Check for proper landmark regions (<header>, <nav>, <main>, <footer>)
- Validate ARIA attributes
- Check image alt text (content images have descriptive alt, decorative have alt='')

**Keyboard Navigation**:
- Test Tab key navigation through interactive elements
- Verify focus order is logical
- Check focus indicators are visible (2px outline minimum)
- Test Enter/Space on buttons
- Test Escape on modals/dialogs
- Ensure no keyboard traps

**Touch Targets**:
- Verify all interactive elements ≥ 44x44px on mobile
- Check spacing between targets ≥ 8px
- Report undersized targets with file paths and fixes

### Interaction Validation
- Test hover states (using Chrome DevTools MCP hover tool)
- Test click actions (using Chrome DevTools MCP click tool)
- Verify focus states distinct from hover
- Check active states (during click)
- Validate disabled states
- Test loading states for async actions

### Console & Network Analysis
- Check JavaScript console for errors using `list_console_messages`
- Report errors with stack traces and file/line numbers
- Check network requests using `list_network_requests`
- Report 404s, failed requests, CORS errors
- Note slow-loading resources

### Design Comparison (if reference provided)
If design reference (Figma URL or screenshot) is provided:
- Compare visual accuracy at each breakpoint
- Check colors match design specifications
- Verify typography sizes and weights
- Confirm spacing matches (margins, padding)
- Validate layout proportions
- Check image aspect ratios
- Note any deviations with recommendations

## Chrome DevTools MCP Tools to Use

Navigation:
- `mcp__chrome-devtools__navigate_page` - Load test URL
- `mcp__chrome-devtools__resize_page` - Change viewport size

Analysis:
- `mcp__chrome-devtools__take_screenshot` - Capture page images
- `mcp__chrome-devtools__take_snapshot` - Get DOM structure for analysis

Interaction:
- `mcp__chrome-devtools__click` - Click elements by UID
- `mcp__chrome-devtools__hover` - Hover over elements
- `mcp__chrome-devtools__press_key` - Test keyboard navigation

Debugging:
- `mcp__chrome-devtools__list_console_messages` - Get JavaScript errors
- `mcp__chrome-devtools__list_network_requests` - Check network activity

## Report Format

Generate detailed technical report with this structure:

```markdown
# Validation Report: {{Component Name}}
**URL**: {{test-url}}
**Date**: {{timestamp}}

## 📊 Summary
✅ Passed: {{N}} checks
⚠️  Warnings: {{N}} checks
❌ Failed: {{N}} checks

## 📱 Responsive Behavior
[For each breakpoint: screenshot, description, issues with file paths and fixes]

## ♿ Accessibility (WCAG AA)
[Color contrast, semantic HTML, keyboard nav, ARIA - with calculations and fixes]

## 🖱️  Interactions
[Hover, click, focus states - with screenshots]

## 🐛 Console & Network
[JavaScript errors, failed requests - with stack traces]

## 🎨 Design Comparison
[If reference provided: visual accuracy assessment]

## 📝 Recommendations (Priority Order)
🔴 Critical (Must Fix)
🟡 Important (Should Fix)
🟢 Nice to Have (Polish)

[Each with file path, line number, current code, recommended fix]
```

Provide exact file paths, line numbers, contrast ratio calculations, code snippets, and actionable remediation steps.")
```

## How It Works

This command spawns the **browser-validator-specialist** agent, which:

1. **Navigates to test URL** using Chrome DevTools MCP
2. **Tests responsive behavior** at 320px, 768px, 1024px breakpoints
3. **Captures screenshots** at each breakpoint for visual verification
4. **Checks accessibility** (WCAG AA contrast, keyboard nav, semantic HTML, ARIA)
5. **Validates interactions** (hover, click, focus states)
6. **Analyzes console** for JavaScript errors
7. **Checks network requests** for failed resources
8. **Compares with design** (if reference provided)
9. **Generates detailed technical report** with file paths, line numbers, and fixes

**Requires**: Chrome DevTools MCP must be installed and connected.

## When to Use

**Use this command (`/design-validate`)** when:
- ✅ Implementation is complete and ready for validation
- ✅ You want comprehensive responsive testing
- ✅ You need WCAG AA accessibility compliance verification
- ✅ You want detailed technical findings with file paths
- ✅ You have Chrome DevTools MCP available

**Can validate**:
- WordPress block patterns
- Drupal paragraph types
- Custom theme components
- Any web page or component

## Example Usage

```bash
# Validate without design reference
/design-validate http://site.ddev.site/test-hero/

# Validate with design comparison
/design-validate http://local.test/page mockups/original-design.png

# Validate production page
/design-validate https://example.com/new-feature

# With Figma reference
/design-validate http://site.test/test design-ref.fig
```

## What You Get

### Comprehensive Validation Report

```
🔍 Validation Report: Hero CTA Section
URL: http://site.ddev.site/test-hero/

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📊 Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Passed: 12 checks
⚠️  Warnings: 3 checks
❌ Failed: 2 checks

Overall Status: Needs fixes before production

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📱 Responsive Behavior
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Mobile (320px)
Screenshot: screenshots/hero-cta/mobile-320px.png
✅ Layout adapts correctly
❌ Text overflow in heading
   File: wp-content/themes/my-theme/assets/scss/patterns/_hero-cta.scss:45
   Current: font-size: 2rem;
   Fix: font-size: clamp(1.5rem, 5vw, 2rem);
   Impact: High - Affects mobile readability

Tablet (768px)
Screenshot: screenshots/hero-cta/tablet-768px.png
✅ Layout optimal

Desktop (1024px)
Screenshot: screenshots/hero-cta/desktop-1024px.png
✅ Layout optimal

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
♿ Accessibility
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Color Contrast:
❌ Body text fails: 3.8:1 (need 4.5:1)
   File: _hero-cta.scss:23
   Current: color: #666
   Fix: color: #595959
   Calculation: (255+0.05)/(89+0.05) = 4.54:1 ✅

Keyboard Navigation:
✅ All elements focusable
⚠️  Focus indicator weak (1px)
   File: _buttons.scss:15
   Fix: outline: 2px solid; outline-offset: 2px;

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📝 Recommendations
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 CRITICAL
1. Fix body text contrast (_hero-cta.scss:23)
2. Add aria-label to icon button (hero-cta.php:42)

🟡 IMPORTANT
3. Fix mobile text overflow (_hero-cta.scss:45)
4. Strengthen focus indicators (_buttons.scss:15)

🟢 NICE TO HAVE
5. Increase touch target size (_hero-cta.scss:67)

All files use paths relative to theme/module root.
```

### Screenshot Gallery

Screenshots saved to `screenshots/{component}/`:
- `initial-fullpage.png` - Full page before testing
- `mobile-320px.png` - Mobile viewport
- `tablet-768px.png` - Tablet viewport
- `desktop-1024px.png` - Desktop viewport
- `button-hover.png` - Hover state test
- `button-focused.png` - Focus state test

### Technical Details

- **Exact file paths** and line numbers
- **Contrast ratio calculations** with formulas
- **Code snippets** showing current vs. recommended
- **Impact assessment** (Critical, Important, Nice to Have)
- **Actionable fixes** (copy-paste ready)

## Integration with Existing Workflows

### After Implementation
```bash
# Create component
/design-to-block design.png hero-cta

# Automatically validates, but you can re-run:
/design-validate http://site.test/test-hero-cta/
```

### During Development
```bash
# Make changes to code
# Test immediately
/design-validate http://localhost:8000/component

# Apply recommended fixes
# Re-validate
/design-validate http://localhost:8000/component
```

### Before PR/Deployment
```bash
# Final validation check
/design-validate https://staging.example.com/new-feature design-ref.png

# Ensure all critical issues resolved
/pr-review
```

### Kanopi Projects (with DDEV)
```bash
# After DDEV site running
/design-validate http://site.ddev.site/test-page

# Can combine with other audits
ddev pa11y http://site.ddev.site/test-page
ddev lighthouse http://site.ddev.site/test-page
```

## Requirements

### Chrome DevTools MCP (Required)

This command requires Chrome DevTools MCP to be installed and connected.

**Installation**:
1. Install Chrome DevTools MCP: https://github.com/anthropics/claude-chrome-mcp
2. Configure in Claude Code settings
3. Restart Claude Code CLI
4. Verify connection: Chrome should be accessible

**If not available**:
```
❌ Chrome DevTools MCP not connected

Browser validation requires Chrome DevTools MCP.

To enable:
1. Install: https://github.com/anthropics/claude-chrome-mcp
2. Configure in Claude Code settings
3. Restart Claude Code
4. Retry: /design-validate {url}

Alternative: Manual validation checklist provided
```

### Test URL Requirements

**URL must be**:
- Accessible from your machine
- Fully loaded page (not 404, not behind authentication)
- Stable (not constantly changing)

**Supported formats**:
- `http://localhost:8000/page`
- `http://site.ddev.site/test-page`
- `http://site.test/node/123`
- `https://staging.example.com/feature`
- `https://production.com/public-page`

### Design Reference (Optional)

**Supported formats**:
- Screenshot: `design.png`, `mockup.jpg`, `/path/to/reference.png`
- Figma URL: `https://figma.com/file/ABC123`
- Any image file readable by Claude

**Used for**:
- Visual comparison against implementation
- Color accuracy verification
- Typography size checking
- Spacing validation
- Layout proportion verification

## Troubleshooting

### Error: "Chrome DevTools MCP not connected"
**Solution**: Install and configure Chrome DevTools MCP (see Requirements above)

**Workaround**: Manual validation checklist provided:
```
📋 Manual Validation Checklist

Test URL: {test-url}

Responsive Testing:
□ View at 320px (mobile)
□ View at 768px (tablet)
□ View at 1024px+ (desktop)
□ No horizontal scrolling on mobile
□ No text overflow
□ Touch targets ≥ 44px on mobile

Accessibility Testing:
□ Check contrast: https://webaim.org/resources/contrastchecker/
□ Test Tab key navigation
□ Verify focus indicators visible
□ Check heading hierarchy (browser DevTools)
□ Verify alt text on images
□ Test with screen reader

Interaction Testing:
□ Test all hover states
□ Test all click/tap actions
□ Check JavaScript console for errors
□ Verify network requests successful

Browser Testing:
□ Chrome/Edge
□ Firefox
□ Safari
□ Mobile browsers
```

### Error: "Cannot access test URL"
**Possible causes**:
- Local development server not running
- URL typo
- Firewall blocking access
- HTTPS certificate issues

**Solutions**:
```bash
# Verify URL in browser first
open http://site.test/test-page

# Check dev server is running
# WordPress
wp server

# DDEV
ddev describe

# Check /etc/hosts for local domains
cat /etc/hosts | grep site.test
```

### Warning: "Design reference not found"
**Impact**: Visual comparison skipped, validation proceeds without it

**Solution**: Verify file path is correct
```bash
# Check file exists
ls -la mockups/design.png

# Use absolute path
/design-validate http://site.test/page /full/path/to/design.png
```

### Screenshots not saving
**Possible causes**:
- Permission issues in screenshots directory
- Disk space full
- Invalid file paths

**Solutions**:
```bash
# Create screenshots directory
mkdir -p screenshots

# Check permissions
chmod 755 screenshots

# Check disk space
df -h
```

## Output Files

All validation outputs saved to organized structure:

```
screenshots/
  {component-name}/
    mobile-320px.png
    tablet-768px.png
    desktop-1024px.png
    button-hover.png
    button-focused.png
    initial-fullpage.png
    validation-report.md (optional)
```

## Best Practices

### 1. Validate Early and Often
Don't wait until the end. Validate during development to catch issues early.

### 2. Fix Critical Issues First
Priority order: Critical (WCAG failures) → Important (UX issues) → Nice to Have (polish)

### 3. Re-validate After Fixes
Always re-run validation after applying recommended fixes to confirm they worked.

### 4. Save Validation Reports
Keep reports in version control or project documentation for reference.

### 5. Test on Real Devices
After automated validation passes, test on actual mobile devices for real-world verification.

### 6. Compare with Design
Always provide design reference when available for visual accuracy verification.

## Validation Scope

**What this validates**:
- ✅ Responsive behavior (layout, sizing, overflow)
- ✅ Accessibility (WCAG AA contrast, keyboard nav, semantic HTML, ARIA)
- ✅ Visual accuracy (if design reference provided)
- ✅ Interactions (hover, click, focus states)
- ✅ JavaScript errors
- ✅ Network issues

**What this does NOT validate**:
- ❌ Cross-browser compatibility (only tests in Chrome)
- ❌ Performance (use `/audit-perf` for that)
- ❌ Security vulnerabilities (use `/audit-security`)
- ❌ Code quality (use `/quality-analyze`)
- ❌ SEO (not in scope)

## Related Commands

- `/design-to-block` - Create WordPress block pattern (includes validation)
- `/design-to-paragraph` - Create Drupal paragraph (includes validation)
- `/audit-a11y` - Comprehensive accessibility audit
- `/audit-perf` - Performance audit with Core Web Vitals
- `/audit-live-site` - Full site audit (all categories)
- `/pr-review` - Code review before committing

---

**For complete technical validation details**, see:
→ [`agents/browser-validator-specialist/AGENT.md`](../agents/browser-validator-specialist/AGENT.md)
→ [`skills/browser-validator/SKILL.md`](../skills/browser-validator/SKILL.md)
