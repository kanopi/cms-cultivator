# Accessibility Audit Export Handler

Transform WCAG compliance scan results into Bug Report or Little Task templates based on severity.

## Input Format

WCAG compliance scan results with:
- WCAG violations
- Severity levels
- Affected elements
- Remediation steps

## Output Template

Little Task or Bug Report based on severity

## Example Transformation

### Input Finding:

```markdown
### High: Missing Alt Text on Images

**WCAG:** 1.1.1 Non-text Content (Level A)
**Impact:** Screen readers cannot describe images
**Affected:** 47 images across site

Missing `alt` attributes on images throughout the site, preventing screen reader users from understanding visual content.

**Example:**
```html
<img src="/products/widget.jpg">
```

**Recommendation:** Add descriptive alt text to all images.
```

### Exported Task:

```markdown
# Bug Report: Missing Alt Text Prevents Screen Reader Access

## Bug Description
47 images across the site are missing `alt` attributes, violating WCAG 2.1 Level A success criterion 1.1.1 (Non-text Content). Screen reader users cannot access image content.

## Accessibility Impact
**Severity:** High (P1)
**WCAG:** 1.1.1 Non-text Content (Level A)
**Compliance:** Currently fails WCAG 2.1 Level A

**User Impact:**
- Screen reader users cannot understand visual content
- Images announced as "image" with no description
- Product images lack context (significant for e-commerce)

## Affected Areas
- Product pages: 23 images
- Blog posts: 12 images
- Homepage: 8 images
- About page: 4 images

**Total:** 47 images

## Steps to Reproduce
1. Install NVDA or JAWS screen reader
2. Navigate to any product page
3. Listen to image announcements
4. Observe: images announced as "image" with no description

## Expected Behavior
All images should have descriptive `alt` attributes:
```html
<img src="/products/widget.jpg" alt="Blue widget with chrome finish, 12-inch diameter">
```

## Actual Behavior
Images have no alt attributes:
```html
<img src="/products/widget.jpg">
```

## Remediation Plan

### 1. Audit All Images
Run accessibility scan to identify all missing alt text:
```bash
/audit-a11y images
```

### 2. Add Alt Text Guidelines
**Decorative images:** Use `alt=""`
**Informative images:** Describe content/function
**Product images:** Include key features/characteristics

### 3. Implement Fixes

**Product images:**
```html
<img src="widget.jpg" alt="Blue widget with chrome finish, 12-inch diameter">
```

**Blog feature images:**
```html
<img src="blog-header.jpg" alt="Developer working on laptop with code visible">
```

**Logos:**
```html
<img src="logo.png" alt="Company Name logo">
```

**Decorative images:**
```html
<img src="background-pattern.png" alt="">
```

## Testing Requirements
- [ ] All 47 images have alt attributes
- [ ] Alt text is descriptive and meaningful
- [ ] Decorative images use `alt=""`
- [ ] Screen reader testing (NVDA/JAWS)
- [ ] Automated scan passes (axe, WAVE)

## Validation
- Test URLs: All site pages
- Screen reader: NVDA on Windows, VoiceOver on Mac
- Expected: All images described appropriately

## Files to Change
- `templates/product-card.php`
- `templates/blog-post.php`
- `header.php`
- `footer.php`
- (47 image instances across multiple files)

## Deployment Notes
- No cache clearing required
- Update content guidelines for future images

## Priority
**P1 (High)** - WCAG Level A violation, blocks accessibility compliance
```
