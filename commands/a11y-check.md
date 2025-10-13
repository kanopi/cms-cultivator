---
description: Check specific accessibility aspects (contrast, ARIA, headings, forms, alt-text, keyboard)
argument-hint: [focus-area]
allowed-tools: Read, Glob, Grep, Bash(npm:*)
---

You are helping check specific accessibility aspects of code. This command combines all specific accessibility checks with optional focus areas.

## Usage

- `/a11y-check` - Run all accessibility checks
- `/a11y-check contrast` - Check color contrast only
- `/a11y-check aria` - Check ARIA attributes only
- `/a11y-check headings` - Check heading hierarchy only
- `/a11y-check forms` - Check form accessibility only
- `/a11y-check alt-text` - Check image alt text only
- `/a11y-check keyboard` - Check keyboard navigation only

## Check Areas

### 1. COLOR CONTRAST (WCAG 2.1 AA)

**Requirement**: 4.5:1 ratio for normal text, 3:1 for large text

#### What to Check
- Text against background colors
- Link colors (normal, hover, visited, focus)
- Button colors (all states)
- Form inputs and labels
- Icons with meaning

#### How to Check
```bash
# Look for color definitions in CSS/SCSS
grep -r "color:" --include="*.css" --include="*.scss"
grep -r "background" --include="*.css" --include="*.scss"
```

#### Output Format
```markdown
## Color Contrast Check

### Passing Combinations ✅
- Body text (#333) on white background: 12.6:1 (WCAG AAA)
- Primary button (white on #0066cc): 4.6:1 (WCAG AA)

### Failing Combinations ❌
- **Light gray text (#999) on white**: 2.8:1 (Fails WCAG AA - needs 4.5:1)
  - Recommendation: Darken to #767676 (4.5:1) or #595959 (7:1 for AAA)

- **Link hover (#66b3ff) on white**: 2.1:1 (Fails WCAG AA)
  - Recommendation: Use #0052a3 (4.5:1) or add underline

### Tool Recommendations
- Use: https://contrast-ratio.com/
- Use: https://webaim.org/resources/contrastchecker/
- Browser extension: axe DevTools

### Files to Update
- `styles/main.css:45` - Update .muted-text color
- `components/Link.module.scss:12` - Update hover state
```

---

### 2. ARIA ATTRIBUTES

**Rule**: First Rule of ARIA - Don't use ARIA if native HTML works

#### What to Check
- Proper ARIA roles
- Required ARIA attributes present
- No redundant ARIA
- Valid ARIA values
- ARIA relationships (aria-labelledby, aria-describedby)

#### Common Issues
- `<button role="button">` - Redundant, remove role
- `<div role="button">` without `tabindex="0"` - Not keyboard accessible
- `aria-label` without visible text - Screen reader only, consider visible label
- Missing `aria-required` on required form fields
- `aria-hidden="true"` on focusable elements - Creates keyboard trap

#### Output Format
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
   ```tsx
   // Before
   <button role="button">Click me</button>

   // After
   <button>Click me</button>
   ```

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

### 3. HEADING HIERARCHY

**Rule**: One H1 per page, no skipped levels

#### What to Check
- Only one `<h1>` per page
- No skipped heading levels (h1 → h3)
- Headings used for structure, not styling
- Logical document outline

#### Output Format
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

### 4. FORM ACCESSIBILITY

#### What to Check
- All inputs have associated labels
- Required fields indicated
- Error messages associated with fields
- Fieldsets for grouped inputs
- Clear focus indicators
- Accessible error handling

#### Output Format
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

### 5. IMAGE ALT TEXT

#### What to Check
- All images have alt attribute
- Alt text describes image purpose
- Decorative images have `alt=""`
- Complex images have detailed descriptions
- No "image of" or "picture of" in alt text

#### Image Types
1. **Informative**: Alt describes what's important
2. **Decorative**: `alt=""` (empty, not missing)
3. **Functional**: Alt describes action (e.g., "Search")
4. **Complex**: Alt + detailed description (longdesc or aria-describedby)

#### Output Format
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

### 6. KEYBOARD NAVIGATION

#### What to Check
- All interactive elements keyboard accessible
- Logical tab order
- Visible focus indicators
- No keyboard traps
- Skip links present
- Keyboard shortcuts documented

#### Output Format
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

## Combined Output Format

When running `/a11y-check` with no focus area, provide all checks:

```markdown
# Accessibility Check Report

## 1. ✅ COLOR CONTRAST
[Full contrast analysis]

## 2. ⚠️ ARIA ATTRIBUTES
[Full ARIA validation]
Found: 3 issues

## 3. ✅ HEADING HIERARCHY
[Full heading analysis]
All pages valid

## 4. ❌ FORM ACCESSIBILITY
[Full form analysis]
Found: 5 issues

## 5. ⚠️ IMAGE ALT TEXT
[Full alt text audit]
13 images need fixing

## 6. ❌ KEYBOARD NAVIGATION
[Full keyboard check]
Found: 4 issues

---

## SUMMARY

**Overall Status**: ⚠️ Needs Work

**Issues by Severity**:
- Critical: 2
- High: 5
- Medium: 8
- Low: 3

**Total Issues**: 18

**Priority Fixes**:
1. Fix keyboard trap in modal (Critical)
2. Associate form error messages (High)
3. Update low-contrast text colors (High)
4. Add missing alt text to 5 images (Medium)
5. Fix redundant ARIA attributes (Low)

**Estimated Time to Fix**: 4-6 hours

**Ready for WCAG 2.1 AA Compliance**: ❌ No
**Blocking Issues**: 7
```

## Focus Area Execution

- `/a11y-check contrast` → Output only section 1
- `/a11y-check aria` → Output only section 2
- `/a11y-check headings` → Output only section 3
- `/a11y-check forms` → Output only section 4
- `/a11y-check alt-text` → Output only section 5
- `/a11y-check keyboard` → Output only section 6
- `/a11y-check` → Output all sections

## Testing Tools

Recommend these tools:
- **axe DevTools**: Browser extension for automated testing
- **WAVE**: WebAIM accessibility checker
- **Lighthouse**: In Chrome DevTools
- **Screen readers**: NVDA (Windows), JAWS (Windows), VoiceOver (Mac)
- **Keyboard**: Tab, Enter, Space, Arrow keys, Escape

Remember: Automated tools catch ~30-40% of issues. Manual testing and actual screen reader use are essential for full WCAG 2.1 AA compliance.
