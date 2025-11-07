---
description: Comprehensive accessibility audit with WCAG 2.1 Level AA compliance
argument-hint: "[focus-area]"
allowed-tools: Read, Glob, Grep, Write, Edit, Bash(npm:*), Bash(ddev exec npm:*)
---

You are helping perform accessibility audits following WCAG 2.1 Level AA guidelines. This command combines comprehensive auditing, focused checks, reporting, and fix generation.

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

---

## MODE 1: Full Audit (`/audit-a11y`)

### Step 1: Identify Scope

- If a file path or URL is provided as an argument, audit that specific target
- If no argument, analyze recently changed files using `git diff`
- Look for HTML, Twig (`.html.twig`), PHP template files, JSX/TSX files

### Step 2: Run Comprehensive WCAG 2.1 AA Checks

#### Perceivable

**Images & Non-Text Content (1.1.1)**:
- All images have appropriate alt text
- Decorative images use `alt=""`
- Complex images have detailed descriptions
- Icons conveying meaning have text alternatives
- No "image of" or "picture of" in alt text

**Color & Contrast (1.4.1, 1.4.3, 1.4.11)**:
- Text contrast ratio ≥ 4.5:1 for normal text
- Text contrast ratio ≥ 3:1 for large text (18pt+)
- UI component contrast ≥ 3:1
- Color not sole means of conveying information

**Multimedia (1.2.1, 1.2.2, 1.2.5)**:
- Videos have captions
- Audio content has transcripts
- Videos have audio descriptions where needed

**Adaptable Content (1.3.1, 1.3.2, 1.3.3)**:
- Semantic HTML structure
- Logical reading order
- Instructions don't rely on sensory characteristics

#### Operable

**Keyboard Access (2.1.1, 2.1.2)**:
- All functionality available via keyboard
- No keyboard traps
- Custom interactive elements have keyboard support

**Navigation (2.4.1, 2.4.2, 2.4.3, 2.4.4, 2.4.5, 2.4.6, 2.4.7)**:
- Skip links present
- Page has descriptive title
- Focus order is logical
- Link purpose clear from context
- Multiple ways to find pages
- Headings and labels descriptive
- Focus visible for all elements

**Timing & Seizures (2.2.1, 2.2.2, 2.3.1)**:
- Adjustable timing where needed
- Pause/stop/hide for moving content
- No flashing content

#### Understandable

**Readable (3.1.1, 3.1.2)**:
- Page language defined
- Language changes marked
- Content readable and understandable

**Predictable (3.2.1, 3.2.2, 3.2.3, 3.2.4)**:
- Focus doesn't cause unexpected changes
- Input doesn't cause unexpected changes
- Navigation consistent across pages
- Components consistently identified

**Input Assistance (3.3.1, 3.3.2, 3.3.3, 3.3.4)**:
- Form errors identified
- Labels and instructions provided
- Error suggestions offered
- Important actions can be reversed

#### Robust

**Compatible (4.1.1, 4.1.2, 4.1.3)**:
- Valid HTML markup
- Name, role, value present for all UI components
- Status messages accessible

### Step 3: Platform-Specific Checks

**Drupal:**
- Form API proper usage
- Views accessibility
- Block accessibility
- Menu accessibility
- Drupal.t() usage for translatable strings
- Theme hook implementations

**WordPress:**
- Theme accessibility-ready tag
- Gutenberg block accessibility
- Widget accessibility
- Navigation menu accessibility
- Screen reader text usage
- Skip links implementation

### Step 4: Output Comprehensive Report

```markdown
# Accessibility Audit Report

**Scope**: [files/urls audited]
**Date**: [current date]
**WCAG Version**: 2.1 Level AA

---

## Executive Summary

- Total Issues Found: [count]
- Critical: [count] (Blocks access completely)
- Serious: [count] (Major barrier to access)
- Moderate: [count] (Significant inconvenience)
- Minor: [count] (Minor issue)

**Overall Status**: [Pass / Partial Conformance / Non-Conformance]

---

## Critical Issues 🔴

### Issue 1: [Issue Title]
**WCAG**: [criterion] - [criterion name]
**Severity**: Critical
**Location**: `path/to/file.php:123`

**Problem**:
[Clear description of the accessibility violation]

**Impact**:
[Who is affected - screen reader users, keyboard users, low vision, etc.]

**Current Code**:
```html
[problematic code]
```

**Fixed Code**:
```html
[corrected code with accessibility fix]
```

**Remediation Steps**:
1. [Step-by-step fix instructions]

---

## Serious Issues 🟡

[Same format as critical]

---

## Moderate Issues 🟠

[Same format as critical]

---

## Minor Issues 🔵

[Same format as critical]

---

## Accessibility Wins ✅

[List things that are done well for positive reinforcement]

---

## Testing Recommendations

### Manual Testing Required:
- Keyboard navigation testing
- Screen reader testing (NVDA, JAWS, VoiceOver)
- Color contrast verification
- Zoom to 200% test
- [Other manual tests needed]

### Automated Testing:
```bash
# Run axe DevTools
npm run test:a11y

# Run Lighthouse accessibility audit
lighthouse --only-categories=accessibility [url]
```

---

## Summary by WCAG Principle

| Principle | Level A | Level AA | Status |
|-----------|---------|----------|--------|
| Perceivable | [X]/[Total] | [X]/[Total] | [✅/⚠️/❌] |
| Operable | [X]/[Total] | [X]/[Total] | [✅/⚠️/❌] |
| Understandable | [X]/[Total] | [X]/[Total] | [✅/⚠️/❌] |
| Robust | [X]/[Total] | [X]/[Total] | [✅/⚠️/❌] |

---

## Resources

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WebAIM Articles](https://webaim.org/articles/)
- [Deque University](https://dequeuniversity.com/)
- [Specific resources related to issues found]

---

## Next Steps

**Priority Actions**:
1. [Most critical fix] - Est: [X] hours
2. [Second priority] - Est: [X] hours
3. [Third priority] - Est: [X] hours

**Total Estimated Effort**: [X] hours

**Recommended Timeline**:
- Week 1-2: Critical issues
- Week 3-4: Serious issues
- Week 5-6: Moderate issues
```

---

## MODE 2: Focused Checks (`/audit-a11y [focus]`)

### Contrast Check (`/audit-a11y contrast`)

Check color contrast ratios against WCAG 2.1 AA standards.

**Requirements**:
- Normal text: ≥ 4.5:1 ratio
- Large text (18pt+ or 14pt+ bold): ≥ 3:1 ratio
- UI components: ≥ 3:1 ratio

**What to Check**:
- Text against background colors
- Link colors (normal, hover, visited, focus)
- Button colors (all states)
- Form inputs and labels
- Icons with meaning

**Output Format**:
```markdown
## Color Contrast Check

### Passing Combinations ✅
- Body text (#333 on #fff): 12.6:1 (WCAG AAA)
- Primary button (white on #0066cc): 4.6:1 (WCAG AA)

### Failing Combinations ❌
- **Light gray text (#999 on #fff)**: 2.8:1 (Fails WCAG AA - needs 4.5:1)
  - Location: `styles.css:45` - `.muted-text`
  - Recommendation: Darken to #767676 (4.5:1) or #595959 (7:1 for AAA)

- **Link hover (#66b3ff on #fff)**: 2.1:1 (Fails WCAG AA)
  - Location: `components/Link.scss:12`
  - Recommendation: Use #0052a3 (4.5:1) or add underline

### Tool Recommendations
- Use: https://contrast-ratio.com/
- Use: https://webaim.org/resources/contrastchecker/
- Browser extension: axe DevTools

### Files to Update
1. `styles/main.css:45` - Update .muted-text color
2. `components/Link.module.scss:12` - Update hover state
```

---

### ARIA Check (`/audit-a11y aria`)

Validate ARIA attributes following best practices.

**First Rule of ARIA**: Don't use ARIA if native HTML works

**What to Check**:
- Proper ARIA roles
- Required ARIA attributes present
- No redundant ARIA
- Valid ARIA values
- ARIA relationships (aria-labelledby, aria-describedby)

**Common Issues**:
- `<button role="button">` - Redundant, remove role
- `<div role="button">` without `tabindex="0"` - Not keyboard accessible
- `aria-hidden="true"` on focusable elements - Creates keyboard trap
- Missing `aria-required` on required form fields

**Output Format**:
```markdown
## ARIA Validation

### Correct Usage ✅
- Custom select widget uses `role="listbox"` with proper keyboard support
- Alert banner uses `role="alert"` with `aria-live="assertive"`
- Accordion uses `aria-expanded` to indicate state

### Issues Found ❌

#### Critical Issues
1. **Keyboard trap in modal** (`Modal.jsx:45`)
   - Issue: `<div aria-hidden="true">` contains focusable buttons
   - Fix: Move aria-hidden to parent or remove focusable elements
   ```jsx
   // Before
   <div aria-hidden="true">
     <button>Close</button>
   </div>

   // After
   <div aria-hidden="true">
     <button tabindex="-1">Close</button>
   </div>
   ```

2. **Redundant ARIA** (`Button.tsx:12`)
   - Issue: `<button role="button">` - Native button has implicit role
   - Fix: Remove role attribute

#### Moderate Issues
3. **Missing aria-required** (`ContactForm.jsx:23`)
   - Issue: Required fields not indicated to screen readers
   - Fix: Add `aria-required="true"` or `required` attribute

### Best Practices
- Prefer native HTML over ARIA when possible
- Test with actual screen readers (NVDA, JAWS, VoiceOver)
- Validate with axe DevTools or WAVE
```

---

### Headings Check (`/audit-a11y headings`)

Validate heading hierarchy for proper document structure.

**Rules**:
- Only one `<h1>` per page
- No skipped heading levels (h1 → h3)
- Headings used for structure, not styling
- Logical document outline

**Output Format**:
```markdown
## Heading Hierarchy

### Page: Homepage

**Outline**:
```
H1: Welcome to Our Site ✅
  H2: Featured Products ✅
    H3: Product Category 1 ✅
    H3: Product Category 2 ✅
  H2: Latest News ✅
    H3: News Article 1 ✅
```

**Status**: ✅ Valid hierarchy

---

### Page: Blog Post

**Outline**:
```
H1: Blog Post Title ✅
  H3: First Section ❌ (Skipped H2)
    H4: Subsection
  H2: Second Section ✅
```

**Issues**:
- ❌ Skipped from H1 to H3 (missing H2)
- Location: `blog-post.html:25`
- Fix: Change first H3 to H2

**Recommendation**:
```html
<!-- Before -->
<h1>Blog Post Title</h1>
<h3>First Section</h3>

<!-- After -->
<h1>Blog Post Title</h1>
<h2>First Section</h2>
```

### Multiple H1 Check
- ✅ All pages have exactly one H1
```

---

### Forms Check (`/audit-a11y forms`)

Check form accessibility including labels, error handling, and fieldsets.

**What to Check**:
- All inputs have associated labels
- Required fields indicated
- Error messages associated with fields
- Fieldsets for grouped inputs
- Clear focus indicators
- Accessible error handling

**Output Format**:
```markdown
## Form Accessibility

### Form: Contact Form

#### Labels ✅
- All inputs have `<label>` elements
- Labels properly associated with `for` attribute

#### Required Fields
**Issues**:
- ❌ Required fields not indicated visually
- ❌ Missing `aria-required="true"` on required fields

**Fix**:
```html
<!-- Before -->
<label for="email">Email</label>
<input type="email" id="email" required>

<!-- After -->
<label for="email">
  Email <span aria-label="required">*</span>
</label>
<input type="email" id="email" required aria-required="true">
```

#### Error Handling
**Issues**:
- ❌ Error messages not associated with fields
- ❌ No `aria-invalid` on invalid fields

**Fix**:
```html
<!-- Before -->
<input type="email" id="email">
<p class="error">Invalid email</p>

<!-- After -->
<input type="email" id="email" aria-invalid="true" aria-describedby="email-error">
<p id="email-error" role="alert">Invalid email address</p>
```

#### Fieldsets
- ✅ Radio buttons grouped in `<fieldset>` with `<legend>`
- ✅ Checkbox groups properly structured

#### Focus Indicators
- ⚠️ Custom focus styles should meet 3:1 contrast ratio
- Check: `:focus` and `:focus-visible` styles

### Recommendations
1. Add visual required indicators (*)
2. Add aria-required to all required fields
3. Associate error messages with aria-describedby
4. Add aria-invalid when validation fails
5. Ensure focus indicators visible
```

---

### Alt Text Check (`/audit-a11y alt-text`)

Audit image alternative text for proper accessibility.

**Image Types**:
1. **Informative**: Alt describes what's important
2. **Decorative**: `alt=""` (empty, not missing)
3. **Functional**: Alt describes action (e.g., "Search")
4. **Complex**: Alt + detailed description (aria-describedby)

**What to Check**:
- All images have alt attribute
- Alt text describes image purpose
- Decorative images have `alt=""`
- Complex images have detailed descriptions
- No "image of" or "picture of" in alt text

**Output Format**:
```markdown
## Image Alt Text Audit

### Informative Images ✅
```html
<img src="product.jpg" alt="Blue running shoes with white stripes">
```
**Status**: Good - Describes key visual features

### Issues Found ❌

#### 1. Missing Alt Text (Logo.jsx:5)
```jsx
// Before
<img src="/logo.png" />

// After
<img src="/logo.png" alt="Company Name - Home" />
```

#### 2. Decorative Image Missing Empty Alt (Hero.jsx:12)
```jsx
// Before
<img src="/background-pattern.svg" alt="background" />

// After (if purely decorative)
<img src="/background-pattern.svg" alt="" role="presentation" />
```

#### 3. Redundant "Image of" (Gallery.tsx:45)
```tsx
// Before
<img src="/team.jpg" alt="Image of our team at conference" />

// After
<img src="/team.jpg" alt="Team members at 2024 industry conference" />
```

#### 4. Non-Descriptive Alt (Button.jsx:23)
```jsx
// Before
<img src="/icon.svg" alt="icon" />

// After (if functional)
<img src="/search-icon.svg" alt="Search" />

// Or (if decorative)
<img src="/icon.svg" alt="" aria-hidden="true" />
```

#### 5. Complex Image Needing Description (Chart.jsx:67)
```jsx
// Before
<img src="/sales-chart.png" alt="Sales chart" />

// After
<figure>
  <img src="/sales-chart.png" alt="Q4 sales trends by region"
       aria-describedby="chart-desc" />
  <figcaption id="chart-desc">
    Detailed description: Sales increased 25% in North region,
    decreased 10% in South region, remained stable in East and West.
  </figcaption>
</figure>
```

### Summary
- Total images: 45
- ✅ Proper alt text: 32
- ❌ Missing alt: 5
- ❌ Poor alt text: 8
- Images fixed: 13

### Best Practices
- Be specific and descriptive
- Don't start with "image of" or "picture of"
- Context matters - alt depends on purpose
- Decorative images need `alt=""` (empty, not omitted)
- Functional images describe action
```

---

### Keyboard Check (`/audit-a11y keyboard`)

Test keyboard accessibility and navigation.

**What to Check**:
- All interactive elements keyboard accessible
- Logical tab order
- Visible focus indicators
- No keyboard traps
- Skip links present
- Keyboard shortcuts documented

**Output Format**:
```markdown
## Keyboard Navigation Check

### Tab Order Test
**Page**: Homepage

**Tab Sequence**:
1. ✅ Skip to main content link
2. ✅ Logo (link)
3. ✅ Main navigation items (1-5)
4. ❌ Hidden menu item (should have tabindex="-1")
5. ✅ Search button
6. ✅ Main content links
7. ❌ Footer link skipped due to CSS issue

**Issues**:
- Hidden menu items still in tab order
- Footer elements not keyboard accessible

### Focus Indicators
- ✅ Default browser outline visible
- ⚠️ Custom :focus styles need review
- ❌ Modal dialog loses focus on open

### Keyboard Traps
**Test Results**:
- ✅ Can tab through entire page
- ❌ **Keyboard trap in modal** (Modal.jsx:45)
  - Issue: Cannot tab out of modal
  - Missing: Focus trap management
  - Fix needed: Implement focus trap with escape key

### Interactive Elements
**Tested**:
- ✅ Links: Enter key activates
- ✅ Buttons: Space and Enter activate
- ✅ Dropdowns: Arrow keys navigate
- ❌ Custom select: Missing keyboard support
- ❌ Date picker: Not keyboard accessible

### Custom Components Issues

#### 1. Custom Dropdown (Dropdown.tsx:12)
**Problem**: Mouse-only functionality
**Fix**:
```tsx
// Add keyboard support
<div role="button"
     tabindex="0"
     onKeyDown={(e) => {
       if (e.key === 'Enter' || e.key === ' ') {
         toggle();
       }
     }}>
```

#### 2. Modal Dialog (Modal.jsx:45)
**Problem**: No focus management
**Fix**:
```jsx
useEffect(() => {
  if (isOpen) {
    // Store last focused element
    previousFocus.current = document.activeElement;

    // Focus modal
    modalRef.current?.focus();

    // Trap focus
    return () => {
      previousFocus.current?.focus();
    };
  }
}, [isOpen]);
```

### Skip Links
- ✅ "Skip to main content" present
- Location: `Layout.tsx:12`
- Test: Tab on page load, press Enter

### Recommendations
1. Fix keyboard trap in modal
2. Add keyboard support to custom select
3. Make date picker keyboard accessible
4. Remove hidden items from tab order
5. Test with keyboard-only navigation
6. Document any custom keyboard shortcuts

### Testing Checklist
- [ ] Tab through entire page
- [ ] Test all interactive elements with Enter/Space
- [ ] Check focus visibility
- [ ] Test escape key functionality
- [ ] Verify no keyboard traps
- [ ] Test with screen reader
```

---

## MODE 3: Checklist Generation (`/audit-a11y checklist`)

Generate a comprehensive WCAG 2.1 Level AA compliance checklist.

```markdown
# Accessibility Compliance Checklist

**Project**: [Project Name]
**Date**: [Date]
**WCAG Version**: 2.1
**Target Level**: AA

---

## Perceivable

### Images & Non-Text Content (1.1.1)
- [ ] All images have appropriate alt text
- [ ] Decorative images use alt=""
- [ ] Complex images have long descriptions
- [ ] Icons conveying meaning have text alternatives

### Color & Contrast (1.4.1, 1.4.3, 1.4.11)
- [ ] Color contrast ratio ≥ 4.5:1 for normal text
- [ ] Color contrast ratio ≥ 3:1 for large text
- [ ] UI component contrast ≥ 3:1
- [ ] Color not sole means of conveying information

### Multimedia (1.2.1, 1.2.2, 1.2.5)
- [ ] Videos have captions
- [ ] Audio content has transcripts
- [ ] Videos have audio descriptions where needed

### Adaptable Content (1.3.1, 1.3.2, 1.3.3)
- [ ] Content structure uses semantic HTML
- [ ] Reading order is logical
- [ ] Instructions don't rely on sensory characteristics

### Distinguishable (1.4.3-1.4.13)
- [ ] Text spacing can be adjusted
- [ ] Content reflows to 320px width
- [ ] Text resizes to 200% without loss of functionality
- [ ] Images of text avoided (except logos)

---

## Operable

### Keyboard Access (2.1.1, 2.1.2, 2.1.4)
- [ ] All functionality available via keyboard
- [ ] No keyboard traps
- [ ] Character key shortcuts can be disabled/remapped

### Navigation (2.4.1-2.4.7)
- [ ] Skip links present
- [ ] Page has descriptive title
- [ ] Focus order is logical
- [ ] Link purpose clear from context
- [ ] Multiple ways to find pages
- [ ] Headings and labels descriptive
- [ ] Focus visible for all elements

### Timing (2.2.1, 2.2.2)
- [ ] Timing adjustable where needed
- [ ] Can pause, stop, or hide moving content

### Seizures & Physical Reactions (2.3.1)
- [ ] No flashing content (< 3 flashes per second)

### Input Modalities (2.5.1-2.5.4)
- [ ] Pointer gestures have keyboard alternative
- [ ] Pointer cancellation available
- [ ] Labels in name match visible text
- [ ] Motion actuation has alternative

---

## Understandable

### Readable (3.1.1, 3.1.2)
- [ ] Page language defined
- [ ] Language changes marked
- [ ] Content readable and understandable

### Predictable (3.2.1-3.2.4)
- [ ] Focus doesn't cause unexpected changes
- [ ] Input doesn't cause unexpected changes
- [ ] Navigation consistent across pages
- [ ] Components consistently identified

### Input Assistance (3.3.1-3.3.4)
- [ ] Form errors identified
- [ ] Labels and instructions provided
- [ ] Error suggestions offered
- [ ] Important actions can be reversed or confirmed

---

## Robust

### Compatible (4.1.1, 4.1.2, 4.1.3)
- [ ] HTML validates
- [ ] Name, role, value present for all UI components
- [ ] Status messages accessible

---

## Testing Procedures

### Automated Testing
- [ ] Run axe DevTools
- [ ] Run Lighthouse accessibility audit
- [ ] Run WAVE evaluation

### Manual Testing
- [ ] Keyboard navigation test (Tab, Enter, Space, Arrow keys, Escape)
- [ ] Screen reader test (NVDA/JAWS/VoiceOver)
- [ ] Zoom to 200% test
- [ ] Color contrast verification
- [ ] Reflow test (320px viewport)

### Browser Testing
- [ ] Chrome + NVDA
- [ ] Firefox + NVDA
- [ ] Safari + VoiceOver
- [ ] Edge + JAWS

---

## Drupal-Specific Checks
- [ ] Form API properly used
- [ ] Views accessibility verified
- [ ] Block accessibility checked
- [ ] Menu accessibility confirmed
- [ ] Drupal.t() used for translatable strings
- [ ] Theme hooks implement accessibility

---

## WordPress-Specific Checks
- [ ] Theme has accessibility-ready tag
- [ ] Gutenberg blocks accessible
- [ ] Widgets accessible
- [ ] Navigation menus accessible
- [ ] Screen reader text properly used
- [ ] Skip links implemented

---

## Sign-off

- [ ] All critical issues resolved
- [ ] All serious issues resolved
- [ ] Moderate issues documented
- [ ] Testing completed
- [ ] Documentation updated

**Auditor**: _______________
**Date**: _______________
**WCAG Level**: AA
**Conformance**: [ ] Full  [ ] Partial  [ ] Non-Conformance
```

---

## MODE 4: Report Generation (`/audit-a11y report`)

Generate a stakeholder-friendly accessibility compliance report.

```markdown
# Accessibility Compliance Report

**Project**: [Project Name]
**Date**: [Date]
**Auditor**: [Name]
**WCAG Version**: 2.1
**Target Level**: AA

---

## Executive Summary

This report summarizes the accessibility audit of [Project Name] conducted on [Date]. The site was evaluated against WCAG 2.1 Level AA success criteria.

**Overall Status**: [Full Conformance / Partial Conformance / Non-Conformance]

**Key Findings**:
- [X] issues identified across all WCAG principles
- [Y] critical issues blocking access for users with disabilities
- [Z] moderate issues causing significant inconvenience
- Estimated remediation effort: [X hours/weeks]

**Risk Assessment**: [Low / Medium / High]
- **ADA Compliance**: [Summary of ADA compliance status]
- **Section 508**: [Summary of Section 508 compliance]
- **Legal Risk**: [Assessment of legal exposure]

---

## Conformance Summary

| WCAG Principle | Level A | Level AA | Status |
|----------------|---------|----------|--------|
| Perceivable    | [X]/[Total] | [X]/[Total] | [✅/⚠️/❌] |
| Operable       | [X]/[Total] | [X]/[Total] | [✅/⚠️/❌] |
| Understandable | [X]/[Total] | [X]/[Total] | [✅/⚠️/❌] |
| Robust         | [X]/[Total] | [X]/[Total] | [✅/⚠️/❌] |

**Overall Conformance**: [Percentage]%

---

## Critical Issues (Priority 1)

These issues completely block access for users with disabilities and must be addressed immediately.

### 1. [Issue Title]
**WCAG**: [Criterion] - [Name]
**Impact**: [Description of user impact]
**Affected**: [Pages/Components affected]
**Users Impacted**: [Which disability groups]

**Business Impact**:
- Legal risk: [High/Medium/Low]
- Users affected: [Estimated percentage]
- Severity: Critical

**Recommendation**: [Brief remediation steps]
**Effort**: [Estimated hours]
**Priority**: Must fix before launch

---

## Serious Issues (Priority 2)

These issues create major barriers to access and should be addressed soon.

[Continue with serious issues in same format...]

---

## Moderate Issues (Priority 3)

These issues cause inconvenience but don't completely block access.

[Continue with moderate issues in same format...]

---

## Testing Methodology

**Automated Testing**:
- axe DevTools (v[version])
- Lighthouse (v[version])
- WAVE (v[version])

**Manual Testing**:
- Keyboard navigation: Full keyboard-only testing
- Screen readers:
  - NVDA [version] with Chrome/Firefox
  - JAWS [version] with Edge
  - VoiceOver with Safari
- 200% zoom test
- Color contrast analyzer
- 320px reflow test

**Browsers Tested**:
- Chrome [version]
- Firefox [version]
- Safari [version]
- Edge [version]

**Devices Tested**:
- Desktop: Windows 11, macOS [version]
- Mobile: iOS [version], Android [version]

---

## Remediation Roadmap

### Phase 1 (Weeks 1-2): Critical Issues
**Focus**: Issues that completely block access

**Tasks**:
1. [Critical issue 1] - [X hours]
2. [Critical issue 2] - [X hours]
3. [Critical issue 3] - [X hours]

**Total Effort**: [X] hours
**Cost**: [Estimate if applicable]

### Phase 2 (Weeks 3-4): Serious Issues
**Focus**: Major barriers to access

**Tasks**:
1. [Serious issue 1] - [X hours]
2. [Serious issue 2] - [X hours]

**Total Effort**: [X] hours
**Cost**: [Estimate if applicable]

### Phase 3 (Weeks 5-6): Moderate Issues
**Focus**: Inconveniences and enhancements

**Tasks**:
1. [Moderate issue 1] - [X hours]
2. [Moderate issue 2] - [X hours]

**Total Effort**: [X] hours
**Cost**: [Estimate if applicable]

**Total Project Effort**: [X] hours / [X] weeks
**Total Cost**: [Estimate if applicable]

---

## Recommendations

### Immediate Actions
1. Fix critical issues blocking access
2. Implement automated accessibility testing in CI/CD
3. Train development team on WCAG 2.1 AA requirements

### Short-term (1-3 months)
1. Resolve all serious issues
2. Establish accessibility review process for new features
3. Create accessibility style guide
4. Implement regular manual testing schedule

### Long-term (3-6 months)
1. Address moderate issues
2. Conduct regular accessibility audits (quarterly)
3. Establish accessibility champions in each team
4. Consider WCAG 2.1 AAA compliance for enhanced accessibility

---

## Legal & Compliance Considerations

**ADA Compliance**:
[Summary of ADA compliance status and risk]

**Section 508**:
[Summary of Section 508 compliance for government contracts]

**AODA (Canada)**:
[If applicable]

**EN 301 549 (EU)**:
[If applicable]

**Risk Level**: [Low / Medium / High]

**Recommendation**: [Legal/compliance recommendations]

---

## Business Benefits of Remediation

### Expanded Market Reach
- [X]% of population has disabilities (WHO)
- Improved SEO (semantic HTML, proper headings)
- Better mobile experience (keyboard nav, proper touch targets)

### Risk Mitigation
- Reduced legal exposure
- Compliance with ADA, Section 508, AODA
- Positive brand reputation

### User Experience Improvements
- Benefits all users, not just those with disabilities
- Better keyboard navigation
- Clearer content structure
- Improved form usability

---

## Appendix A: Detailed Findings

[Detailed technical findings with code examples from full audit]

---

## Appendix B: Success Criteria Reference

[List all WCAG 2.1 Level A and AA criteria with pass/fail status]

---

## Appendix C: Resources

**WCAG Guidelines**:
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [Understanding WCAG 2.1](https://www.w3.org/WAI/WCAG21/Understanding/)

**Testing Tools**:
- [axe DevTools](https://www.deque.com/axe/devtools/)
- [WAVE](https://wave.webaim.org/)
- [Lighthouse](https://developers.google.com/web/tools/lighthouse)

**Learning Resources**:
- [WebAIM](https://webaim.org/)
- [Deque University](https://dequeuniversity.com/)
- [A11y Project](https://www.a11yproject.com/)

---

**Report Prepared By**: [Name]
**Role**: [Title]
**Contact**: [Email]
**Date**: [Date]
**Version**: 1.0
```

---

## MODE 5: Fix Generation (`/audit-a11y fix`)

Generate specific code fixes for identified accessibility issues.

First, run `/audit-a11y` to identify issues, then generate fixes with prioritization.

```markdown
# Accessibility Fixes

## High Priority Fixes (Week 1-2)

### 1. Add Missing Form Labels
**WCAG**: 1.3.1, 4.1.2
**Impact**: Screen readers cannot identify form fields
**Effort**: 2 hours
**Files**: contact-form.html, signup.html

**Before**:
```html
<input type="text" name="username" placeholder="Username">
```

**After**:
```html
<label for="username">Username</label>
<input type="text" id="username" name="username" placeholder="Username">
```

**Implementation Steps**:
1. Add unique `id` to each input
2. Add `<label>` element with matching `for` attribute
3. Ensure label text is descriptive and clear
4. Place label before or after input (not wrapped unless necessary)
5. Test with screen reader (NVDA, JAWS, or VoiceOver)

---

### 2. Fix Color Contrast
**WCAG**: 1.4.3
**Impact**: Low vision users cannot read text
**Effort**: 1 hour
**Files**: styles.css, theme.scss

**Before**:
```css
.text-muted { color: #999999; } /* 2.8:1 contrast */
.link-secondary { color: #66b3ff; } /* 2.1:1 contrast */
```

**After**:
```css
.text-muted { color: #767676; } /* 4.5:1 contrast - WCAG AA */
.link-secondary { color: #0052a3; } /* 4.6:1 contrast - WCAG AA */
```

**Implementation Steps**:
1. Use contrast checker (https://contrast-ratio.com/)
2. Update color values in CSS files
3. Update design system/style guide
4. Test on actual screens (not just design tools)
5. Verify all states (normal, hover, focus, active)

---

### 3. Add Skip Links
**WCAG**: 2.4.1
**Impact**: Keyboard users must tab through entire navigation
**Effort**: 3 hours
**Files**: Layout.tsx, Header.jsx, styles.css

**Before**:
```jsx
<header>
  <nav>...</nav>
</header>
<main>...</main>
```

**After**:
```jsx
<a href="#main-content" className="skip-link">
  Skip to main content
</a>
<header>
  <nav>...</nav>
</header>
<main id="main-content" tabIndex="-1">...</main>
```

```css
.skip-link {
  position: absolute;
  left: -10000px;
  top: auto;
  width: 1px;
  height: 1px;
  overflow: hidden;
}

.skip-link:focus {
  position: static;
  width: auto;
  height: auto;
}
```

**Implementation Steps**:
1. Add skip link as first focusable element
2. Link to main content area
3. Add `id` to main content container
4. Style skip link to be visible on focus
5. Test by tabbing from page load

---

## Medium Priority Fixes (Week 3-4)

### 4. Fix ARIA Redundancy
**WCAG**: 4.1.2
**Impact**: Confuses screen readers
**Effort**: 1 hour
**Files**: Button.tsx, Link.jsx

**Before**:
```jsx
<button role="button" type="submit">Submit</button>
<a href="/home" role="link">Home</a>
```

**After**:
```jsx
<button type="submit">Submit</button>
<a href="/home">Home</a>
```

**Implementation Steps**:
1. Remove redundant roles from native elements
2. Use native HTML elements when possible
3. Only add ARIA when no native element exists
4. Test with screen reader

---

### 5. Add Image Alt Text
**WCAG**: 1.1.1
**Impact**: Screen readers cannot describe images
**Effort**: 4 hours
**Files**: Multiple image components

**Before**:
```jsx
<img src="/logo.png" />
<img src="/decorative-bg.svg" alt="background" />
<img src="/icon.png" alt="icon" />
```

**After**:
```jsx
<img src="/logo.png" alt="Company Name - Home" />
<img src="/decorative-bg.svg" alt="" role="presentation" />
<img src="/search-icon.png" alt="Search" />
```

**Implementation Steps**:
1. Identify image purpose (informative, decorative, functional, complex)
2. Write appropriate alt text
   - Informative: Describe what's important
   - Decorative: Use `alt=""` (empty, not omitted)
   - Functional: Describe action
   - Complex: Add detailed description
3. Don't start with "image of" or "picture of"
4. Test with screen reader

---

### 6. Fix Keyboard Trap in Modal
**WCAG**: 2.1.2
**Impact**: Keyboard users cannot escape modal
**Effort**: 5 hours
**Files**: Modal.jsx, useModal.ts

**Before**:
```jsx
function Modal({ isOpen, children }) {
  return isOpen ? (
    <div className="modal">
      {children}
    </div>
  ) : null;
}
```

**After**:
```jsx
function Modal({ isOpen, onClose, children }) {
  const modalRef = useRef(null);
  const previousFocus = useRef(null);

  useEffect(() => {
    if (isOpen) {
      // Save currently focused element
      previousFocus.current = document.activeElement;

      // Focus modal
      modalRef.current?.focus();

      // Trap focus within modal
      const handleKeyDown = (e) => {
        if (e.key === 'Escape') {
          onClose();
        }

        if (e.key === 'Tab') {
          const focusableElements = modalRef.current.querySelectorAll(
            'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
          );
          const firstElement = focusableElements[0];
          const lastElement = focusableElements[focusableElements.length - 1];

          if (e.shiftKey && document.activeElement === firstElement) {
            e.preventDefault();
            lastElement.focus();
          } else if (!e.shiftKey && document.activeElement === lastElement) {
            e.preventDefault();
            firstElement.focus();
          }
        }
      };

      document.addEventListener('keydown', handleKeyDown);

      return () => {
        document.removeEventListener('keydown', handleKeyDown);
        // Restore focus to previously focused element
        previousFocus.current?.focus();
      };
    }
  }, [isOpen, onClose]);

  return isOpen ? (
    <div
      className="modal"
      ref={modalRef}
      role="dialog"
      aria-modal="true"
      tabIndex="-1"
    >
      {children}
    </div>
  ) : null;
}
```

**Implementation Steps**:
1. Save reference to previously focused element
2. Focus modal when opened
3. Trap Tab key to keep focus within modal
4. Handle Escape key to close
5. Restore focus when closed
6. Add `role="dialog"` and `aria-modal="true"`
7. Test with keyboard only

---

## Low Priority Fixes (Week 5-6)

### 7. Improve Focus Indicators
**WCAG**: 2.4.7
**Impact**: Keyboard users can't see where focus is
**Effort**: 2 hours
**Files**: styles.css, theme.scss

**Before**:
```css
*:focus {
  outline: none; /* Removed focus indicator */
}
```

**After**:
```css
*:focus {
  outline: 2px solid #0066cc;
  outline-offset: 2px;
}

*:focus:not(:focus-visible) {
  outline: none;
}

*:focus-visible {
  outline: 2px solid #0066cc;
  outline-offset: 2px;
}
```

**Implementation Steps**:
1. Never use `outline: none` without replacement
2. Use `:focus-visible` for keyboard-only indicators
3. Ensure 3:1 contrast ratio for focus indicator
4. Test with keyboard navigation
5. Test in all browsers

---

## Implementation Roadmap

### Week 1-2: High Priority (Critical Access Blockers)
- [ ] Add form labels (2 hours)
- [ ] Fix color contrast (1 hour)
- [ ] Add skip links (3 hours)
**Total: 6 hours**

### Week 3-4: Medium Priority (Major Barriers)
- [ ] Fix ARIA redundancy (1 hour)
- [ ] Add image alt text (4 hours)
- [ ] Fix keyboard trap (5 hours)
**Total: 10 hours**

### Week 5-6: Low Priority (Enhancements)
- [ ] Improve focus indicators (2 hours)
**Total: 2 hours**

**Grand Total: 18 hours**

---

## Testing Plan

After each fix:
1. **Keyboard Test**: Tab through affected areas
2. **Screen Reader Test**: Use NVDA, JAWS, or VoiceOver
3. **Automated Scan**: Run axe DevTools
4. **Manual Verification**: Check WCAG criterion met
5. **Regression Test**: Ensure no new issues introduced

---

## Verification Checklist

- [ ] All critical issues resolved
- [ ] All fixes tested with keyboard
- [ ] All fixes tested with screen reader
- [ ] Automated tests passing
- [ ] No new accessibility issues introduced
- [ ] Documentation updated
- [ ] Team trained on fixes
- [ ] Monitoring in place for future issues
```

---

## Quick Start (Kanopi Projects)

### Pre-Audit Quality Checks

Before running accessibility audit, run Kanopi's quality checks:

```bash
# Check for common code quality issues
ddev composer code-check    # Drupal
ddev composer phpstan       # WordPress

# Check dependencies for known vulnerabilities
ddev composer audit
ddev exec npm audit
```

### Run Accessibility Tests

```bash
# Install accessibility testing tools
ddev exec npm install --save-dev @axe-core/cli pa11y lighthouse

# Run axe-core
ddev exec npx axe [url]

# Run pa11y
ddev exec npx pa11y [url]

# Run Lighthouse
ddev exec npx lighthouse [url] --only-categories=accessibility
```

---

## Analysis Guidelines

- **Be thorough but practical** - Focus on issues that truly impact users
- **Provide context** - Explain why something is an accessibility issue
- **Give specific fixes** - Include actual code examples with before/after
- **Consider progressive enhancement** - Suggest improvements beyond minimum compliance
- **Check cascade effects** - Look for patterns that might affect multiple pages
- **Prioritize by user impact** - Critical issues that block access come first

---

## Testing Tools Reference

**Automated Tools** (catch ~30-40% of issues):
- **axe DevTools**: Browser extension, best automated tool
- **WAVE**: WebAIM's accessibility checker
- **Lighthouse**: Built into Chrome DevTools
- **pa11y**: Command-line accessibility testing

**Manual Testing** (required for full WCAG 2.1 AA compliance):
- **Screen Readers**:
  - NVDA (Windows, free): https://www.nvaccess.org/
  - JAWS (Windows, paid): https://www.freedomscientific.com/products/software/jaws/
  - VoiceOver (macOS, built-in): Cmd+F5
- **Keyboard**: Tab, Enter, Space, Arrow keys, Escape
- **Contrast Checker**: https://contrast-ratio.com/
- **Zoom**: Test at 200% zoom level
- **Reflow**: Test at 320px viewport width

**Remember**: Automated tools are helpful but catch less than half of issues. Manual testing with actual assistive technologies is essential for true WCAG 2.1 AA compliance.
