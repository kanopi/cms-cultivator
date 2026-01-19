# Design Workflow Guide

This guide walks through the complete design-to-code workflow using CMS Cultivator, from analyzing designs to validating implementations in the browser.

---

## Overview

The design workflow consists of three main stages:

1. **Design Analysis** - Extract technical requirements from Figma or screenshots
2. **Code Generation** - Create WordPress blocks or Drupal paragraphs
3. **Browser Validation** - Test responsive behavior and accessibility

---

## Stage 1: Design Analysis

### Providing Design References

CMS Cultivator can analyze designs from two sources:

**Figma URLs:**
```bash
/design-to-block https://figma.com/file/abc123/Hero-Section
```

**Screenshots/Images:**
```bash
# First, show the design file to Claude
/design-to-block hero-design.png
```

**What gets analyzed:**

1. **Colors**
   - Brand colors (primary, secondary, accent)
   - Text colors
   - Background colors
   - Gradient definitions
   - Color contrast ratios (WCAG AA validation)

2. **Typography**
   - Font families
   - Font sizes (responsive scaling)
   - Line heights
   - Font weights
   - Letter spacing
   - Text transforms

3. **Spacing**
   - Margins (responsive)
   - Padding (responsive)
   - Gap values (for flexbox/grid)
   - Container widths

4. **Layout**
   - Flexbox or Grid usage
   - Alignment patterns
   - Responsive breakpoints (768px, 1024px)
   - Stacking behavior on mobile

5. **Interactive Elements**
   - Hover states
   - Focus indicators
   - Active states
   - Touch targets (44px minimum)

6. **Accessibility Requirements**
   - Color contrast (4.5:1 for normal text, 3:1 for large)
   - ARIA labels
   - Semantic HTML structure
   - Keyboard navigation patterns
   - Screen reader considerations

---

## Stage 2A: WordPress Block Patterns

### Use `/design-to-block [design-reference]`

Create block patterns from designs for WordPress sites.

**Workflow:**

```bash
# 1. Provide your design reference
/design-to-block https://figma.com/file/abc123/Hero-Section

# Or with a local image
/design-to-block hero-design.png
```

**What it creates:**

1. **Block Pattern PHP File**
   - Location: `wp-content/themes/your-theme/patterns/`
   - File name: Descriptive, kebab-case (e.g., `hero-with-cta.php`)
   - Pattern header with metadata

2. **HTML Structure**
   - Core blocks (Group, Columns, Heading, Paragraph, Button)
   - Semantic HTML5 elements
   - Proper nesting and hierarchy
   - ARIA attributes where needed

3. **Inline Styles**
   - Mobile-first responsive CSS
   - Custom properties for colors
   - Proper spacing units (rem, em)
   - Focus indicators
   - Hover states

4. **Responsive Behavior**
   - Mobile layout (< 768px)
   - Tablet layout (768px - 1024px)
   - Desktop layout (> 1024px)
   - Proper stacking on small screens

5. **Accessibility Features**
   - WCAG AA color contrast
   - Touch-friendly targets (44px min)
   - Keyboard navigation
   - Screen reader text where needed
   - Proper heading hierarchy

**Example Output:**

```php
<?php
/**
 * Title: Hero with CTA
 * Slug: theme-slug/hero-with-cta
 * Categories: featured
 * Description: Full-width hero section with heading, subheading, and call-to-action button
 */
?>

<!-- wp:group {"align":"full","style":{"spacing":{"padding":{"top":"4rem","bottom":"4rem","left":"1.5rem","right":"1.5rem"}}},"backgroundColor":"primary","className":"hero-section"} -->
<div class="wp-block-group alignfull hero-section has-primary-background-color has-background" style="padding-top:4rem;padding-right:1.5rem;padding-bottom:4rem;padding-left:1.5rem">

    <!-- wp:heading {"textAlign":"center","level":1,"style":{"typography":{"fontSize":"3rem","lineHeight":"1.2"},"spacing":{"margin":{"bottom":"1.5rem"}}}} -->
    <h1 class="has-text-align-center" style="margin-bottom:1.5rem;font-size:3rem;line-height:1.2">
        Transform Your Digital Experience
    </h1>
    <!-- /wp:heading -->

    <!-- wp:paragraph {"align":"center","style":{"typography":{"fontSize":"1.25rem"},"spacing":{"margin":{"bottom":"2rem"}}}} -->
    <p class="has-text-align-center" style="margin-bottom:2rem;font-size:1.25rem">
        Build faster, launch sooner, and grow your business with our expert team.
    </p>
    <!-- /wp:paragraph -->

    <!-- wp:buttons {"layout":{"type":"flex","justifyContent":"center"}} -->
    <div class="wp-block-buttons">
        <!-- wp:button {"style":{"spacing":{"padding":{"top":"1rem","bottom":"1rem","left":"2rem","right":"2rem"}}}} -->
        <div class="wp-block-button">
            <a class="wp-block-button__link wp-element-button" style="padding-top:1rem;padding-right:2rem;padding-bottom:1rem;padding-left:2rem">
                Get Started Today
            </a>
        </div>
        <!-- /wp:button -->
    </div>
    <!-- /wp:buttons -->

</div>
<!-- /wp:group -->

<style>
.hero-section {
    /* Mobile-first base styles */
    min-height: 400px;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.hero-section h1 {
    font-size: clamp(2rem, 5vw, 3rem);
}

.hero-section .wp-block-button__link {
    min-height: 44px;
    min-width: 44px;
    transition: all 0.3s ease;
}

.hero-section .wp-block-button__link:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.hero-section .wp-block-button__link:focus {
    outline: 2px solid currentColor;
    outline-offset: 2px;
}

/* Tablet and up */
@media (min-width: 768px) {
    .hero-section {
        min-height: 500px;
        padding: 6rem 2rem;
    }
}

/* Desktop and up */
@media (min-width: 1024px) {
    .hero-section {
        min-height: 600px;
        padding: 8rem 2rem;
    }
}

/* Reduced motion support */
@media (prefers-reduced-motion: reduce) {
    .hero-section .wp-block-button__link {
        transition: none;
    }

    .hero-section .wp-block-button__link:hover {
        transform: none;
    }
}
</style>
```

**Using the Pattern:**

1. **Register the pattern** (usually automatic if in `/patterns/` directory)
2. **Insert in Block Editor:**
   - Click the "+" button
   - Search for pattern name ("Hero with CTA")
   - Click to insert
3. **Customize content:**
   - Edit text directly in the editor
   - Adjust colors via block settings
   - Modify spacing as needed

**Tips:**

- Keep patterns reusable (avoid hardcoded content)
- Use theme.json for colors and spacing when possible
- Test on actual devices, not just browser resize
- Validate with screen readers
- Check color contrast with tools like WebAIM

---

## Stage 2B: Drupal Paragraph Types

### Use `/design-to-paragraph [design-reference]`

Create paragraph types from designs for Drupal sites.

**Workflow:**

```bash
# 1. Provide your design reference
/design-to-paragraph https://figma.com/file/abc123/Hero-Section

# Or with a local image
/design-to-paragraph hero-design.png
```

**What it creates:**

1. **Field Configuration**
   - Field machine names
   - Field types (text, formatted text, image, link, etc.)
   - Field labels
   - Help text
   - Required fields
   - Cardinality settings

2. **Paragraph Type Structure**
   - Paragraph type machine name
   - Display name
   - Description
   - Field groupings

3. **Twig Template**
   - Location: `templates/paragraph/paragraph--hero-section.html.twig`
   - Semantic HTML structure
   - Field rendering with proper escaping
   - BEM class naming convention
   - ARIA attributes

4. **SCSS/CSS Styles**
   - Location: `css/paragraphs/hero-section.scss`
   - Mobile-first responsive styles
   - CSS custom properties
   - Proper nesting
   - Breakpoint mixins

5. **Implementation Guide**
   - Drush commands for field creation
   - Configuration export instructions
   - Template suggestions
   - Cache considerations

**Example Output:**

**Field Configuration (YAML):**

```yaml
# config/install/field.storage.paragraph.field_hero_heading.yml
langcode: en
status: true
dependencies:
  module:
    - paragraphs
    - text
id: paragraph.field_hero_heading
field_name: field_hero_heading
entity_type: paragraph
type: string
settings:
  max_length: 255
  is_ascii: false
  case_sensitive: false
module: core
locked: false
cardinality: 1
translatable: true
indexes: {  }
persist_with_no_fields: false
custom_storage: false

# config/install/field.field.paragraph.hero_section.field_hero_heading.yml
langcode: en
status: true
dependencies:
  config:
    - field.storage.paragraph.field_hero_heading
    - paragraphs.paragraphs_type.hero_section
id: paragraph.hero_section.field_hero_heading
field_name: field_hero_heading
entity_type: paragraph
bundle: hero_section
label: 'Heading'
description: 'Main heading text (H1)'
required: true
translatable: true
default_value: {  }
default_value_callback: ''
settings:
  display_summary: true
field_type: string
```

**Twig Template:**

```twig
{#
/**
 * @file
 * Template for Hero Section paragraph type.
 *
 * Available variables:
 * - paragraph: Full paragraph entity.
 * - content: All paragraph items. Use {{ content }} to print them all.
 * - content.field_hero_heading: Heading field.
 * - content.field_hero_subheading: Subheading field.
 * - content.field_hero_cta: Call-to-action link field.
 * - content.field_hero_background: Background image field.
 */
#}

{%
  set classes = [
    'paragraph',
    'paragraph--type--' ~ paragraph.bundle|clean_class,
    'paragraph--hero-section',
    view_mode ? 'paragraph--view-mode--' ~ view_mode|clean_class,
  ]
%}

<section{{ attributes.addClass(classes) }} role="region" aria-label="Hero Section">
  <div class="paragraph--hero-section__container">

    {% if content.field_hero_background %}
      <div class="paragraph--hero-section__background">
        {{ content.field_hero_background }}
      </div>
    {% endif %}

    <div class="paragraph--hero-section__content">

      {% if content.field_hero_heading %}
        <h1 class="paragraph--hero-section__heading">
          {{ content.field_hero_heading }}
        </h1>
      {% endif %}

      {% if content.field_hero_subheading %}
        <div class="paragraph--hero-section__subheading">
          {{ content.field_hero_subheading }}
        </div>
      {% endif %}

      {% if content.field_hero_cta %}
        <div class="paragraph--hero-section__cta">
          {{ content.field_hero_cta }}
        </div>
      {% endif %}

    </div>
  </div>
</section>
```

**SCSS Styles:**

```scss
// _hero-section.scss
.paragraph--hero-section {
  // Mobile-first base styles
  position: relative;
  min-height: 400px;
  display: flex;
  align-items: center;
  padding: 2rem 1.5rem;
  background-color: var(--color-primary);
  color: var(--color-text-on-primary);

  &__container {
    position: relative;
    width: 100%;
    max-width: 1200px;
    margin: 0 auto;
    z-index: 2;
  }

  &__background {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 1;

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  }

  &__content {
    position: relative;
    text-align: center;
    z-index: 2;
  }

  &__heading {
    font-size: clamp(2rem, 5vw, 3rem);
    line-height: 1.2;
    margin-bottom: 1.5rem;
    font-weight: 700;
  }

  &__subheading {
    font-size: clamp(1rem, 3vw, 1.25rem);
    line-height: 1.5;
    margin-bottom: 2rem;
    opacity: 0.9;
  }

  &__cta {
    display: flex;
    justify-content: center;
    gap: 1rem;
    flex-wrap: wrap;

    a {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-height: 44px;
      min-width: 44px;
      padding: 1rem 2rem;
      background-color: var(--color-accent);
      color: var(--color-text-on-accent);
      text-decoration: none;
      border-radius: 0.25rem;
      font-weight: 600;
      transition: all 0.3s ease;

      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
      }

      &:focus {
        outline: 2px solid currentColor;
        outline-offset: 2px;
      }
    }
  }

  // Tablet and up
  @media (min-width: 768px) {
    min-height: 500px;
    padding: 4rem 2rem;

    &__heading {
      margin-bottom: 2rem;
    }

    &__subheading {
      margin-bottom: 2.5rem;
    }
  }

  // Desktop and up
  @media (min-width: 1024px) {
    min-height: 600px;
    padding: 6rem 2rem;
  }

  // Reduced motion support
  @media (prefers-reduced-motion: reduce) {
    &__cta a {
      transition: none;

      &:hover {
        transform: none;
      }
    }
  }
}
```

**Implementation Commands:**

```bash
# 1. Create paragraph type
drush generate paragraph-type

# 2. Create fields
drush generate field:paragraph

# 3. Export configuration
drush config:export

# 4. Clear cache
drush cr

# 5. Import on other environments
drush config:import
```

**Tips:**

- Use consistent field naming (`field_[paragraph_type]_[field_name]`)
- Group related fields with field groups
- Set proper field widget/formatter settings
- Use Display Suite or Layout Builder for complex layouts
- Enable paragraph previews for content editors
- Consider translation requirements early

---

## Stage 3: Browser Validation

### Use `/design-validate [url]`

Validate your implementation in a real browser using Chrome DevTools.

**Requirements:**

- Chrome DevTools MCP Server must be configured
- Target site must be accessible (local or deployed)

**Workflow:**

```bash
# 1. Start your local development server
# WordPress:
wp server

# Drupal:
drush rs
# Or with DDEV:
ddev launch

# 2. Run validation on your page
/design-validate http://localhost:8000/hero-section

# Or validate production
/design-validate https://staging.example.com/new-page
```

**What it validates:**

### Responsive Behavior

Tests at three breakpoints:

1. **Mobile (320px width)**
   - Content stacking
   - Touch target sizes (minimum 44×44px)
   - Readable font sizes (minimum 16px)
   - Horizontal scrolling issues
   - Proper spacing in tight layouts

2. **Tablet (768px width)**
   - Layout transitions
   - Content reflow
   - Navigation patterns
   - Image scaling
   - Grid/flexbox behavior

3. **Desktop (1024px+ width)**
   - Maximum content width
   - Multi-column layouts
   - Hover states
   - Focus indicators
   - Full design implementation

### Accessibility Compliance (WCAG AA)

1. **Color Contrast**
   - Normal text: 4.5:1 minimum
   - Large text (18pt+): 3:1 minimum
   - Interactive elements: 3:1 minimum
   - Reports exact ratios and pass/fail status

2. **Keyboard Navigation**
   - Tab order is logical
   - All interactive elements focusable
   - Focus indicators visible (2px minimum)
   - No keyboard traps
   - Skip links present

3. **ARIA Usage**
   - Proper landmark roles
   - Correct ARIA labels
   - Valid ARIA attributes
   - No ARIA conflicts with native semantics
   - Live regions configured properly

4. **Semantic HTML**
   - Proper heading hierarchy (h1 → h2 → h3)
   - Form labels associated with inputs
   - Alt text on images
   - List markup for lists
   - Button vs. link usage

5. **Screen Reader Compatibility**
   - Meaningful text alternatives
   - Descriptive link text
   - Form error messages
   - Status announcements
   - Hidden content handled properly

### Interactions

1. **Click Targets**
   - Minimum 44×44px touch targets
   - Adequate spacing between targets
   - Clear hover states
   - Visual feedback on click

2. **Forms**
   - Labels visible and associated
   - Error messages clear
   - Required field indicators
   - Autocomplete attributes

3. **Animations**
   - Respects `prefers-reduced-motion`
   - No excessive motion
   - Transitions enhance UX
   - Performance implications noted

**Example Validation Report:**

```markdown
# Browser Validation Report
**URL:** http://localhost:8000/hero-section
**Generated:** 2025-01-19 14:30:00

## Responsive Behavior

### ✅ Mobile (320px)
- Content stacks properly
- All touch targets ≥ 44×44px
- Font sizes ≥ 16px (no zoom required)
- No horizontal scroll

### ✅ Tablet (768px)
- Layout transitions smoothly
- Images scale proportionally
- Navigation accessible
- Content readable

### ✅ Desktop (1024px)
- Max-width applied (1200px)
- Multi-column layout working
- Hover states functional
- Design matches specification

## Accessibility (WCAG AA)

### Color Contrast
- ✅ Heading: 8.2:1 (excellent)
- ✅ Body text: 7.1:1 (excellent)
- ✅ Button: 4.8:1 (pass)
- ❌ **FAIL**: Link text: 3.8:1 (needs 4.5:1)

**Fix Required:**
```css
.paragraph--hero-section__link {
  color: #005A9C; /* Improves contrast to 4.6:1 */
}
```

### Keyboard Navigation
- ✅ Logical tab order
- ✅ Focus indicators visible (2px solid)
- ✅ No keyboard traps
- ⚠️ **WARNING**: Skip link missing

**Recommendation:**
```html
<a href="#main-content" class="skip-link">Skip to main content</a>
```

### ARIA Usage
- ✅ Landmark roles correct
- ✅ `aria-label` on section: "Hero Section"
- ✅ No ARIA conflicts
- ✅ Valid attributes

### Semantic HTML
- ✅ Single H1 on page
- ✅ Proper heading hierarchy
- ✅ Alt text on images
- ✅ Button vs. link usage correct

### Screen Reader Testing
- ✅ All content announced
- ✅ Link text descriptive
- ✅ No hidden content issues

## Interactions

### Touch Targets
- ✅ Button: 48×48px
- ✅ Links: 44×44px minimum
- ✅ Adequate spacing (8px min)

### Animations
- ✅ `prefers-reduced-motion` respected
- ✅ Transitions smooth (0.3s)
- ✅ No excessive motion

## Issues Summary

### 🔴 Critical (1)
- Link color contrast: 3.8:1 (needs 4.5:1)

### 🟡 Warnings (1)
- Missing skip navigation link

### ✅ Passed (23 checks)

## Recommendations

### 1. Fix Link Contrast (CRITICAL)
**File:** `css/paragraphs/hero-section.scss`
**Line:** 45
**Current:**
```scss
color: #4A90E2; // 3.8:1 contrast
```
**Fixed:**
```scss
color: #005A9C; // 4.6:1 contrast
```

### 2. Add Skip Link (RECOMMENDED)
**File:** `templates/paragraph/paragraph--hero-section.html.twig`
**Location:** Before `<section>` tag
**Code:**
```html
<a href="#main-content" class="skip-link">Skip to main content</a>
```

## Next Steps

1. ✅ Apply color contrast fix
2. ✅ Add skip navigation link
3. ✅ Re-run validation to confirm
4. ✅ Test with actual screen reader (NVDA, JAWS, or VoiceOver)
5. ✅ Test on physical mobile device
```

**After Fixing Issues:**

```bash
# Re-run validation
/design-validate http://localhost:8000/hero-section

# Should now pass all checks
```

---

## Complete Workflow Example

Here's a typical workflow from design to deployment:

```bash
# === WordPress Block Pattern Workflow ===

# 1. Receive design from designer
# (Figma link or PNG/JPG file)

# 2. Generate block pattern
/design-to-block https://figma.com/file/abc123/Hero-Section

# Output: patterns/hero-with-cta.php
# - Block pattern structure
# - Responsive CSS
# - Accessibility features

# 3. Review and refine the generated pattern
# - Adjust colors to match theme
# - Customize spacing
# - Update placeholder content

# 4. Test in Block Editor
# - Insert pattern
# - Customize content
# - Preview on frontend

# 5. Start local server
ddev launch

# 6. Validate implementation
/design-validate http://cms-cultivator.ddev.site/hero-test

# Output shows:
# ❌ Button contrast: 3.2:1 (needs 4.5:1)
# ⚠️ Touch target: 40px (needs 44px min)

# 7. Fix identified issues
# Edit patterns/hero-with-cta.php:
# - Update button color
# - Increase button padding

# 8. Re-validate
/design-validate http://cms-cultivator.ddev.site/hero-test

# ✅ All checks passed!

# 9. Commit and deploy
git add patterns/hero-with-cta.php
git commit -m "feat(patterns): add hero with CTA pattern"
git push

# === Drupal Paragraph Type Workflow ===

# 1. Generate paragraph type
/design-to-paragraph hero-design.png

# Output:
# - Field configuration YAML
# - Twig template
# - SCSS styles
# - Implementation guide

# 2. Create fields via Drush
drush generate paragraph-type
# Name: Hero Section
# Machine name: hero_section

drush generate field:paragraph
# Entity type: paragraph
# Bundle: hero_section
# Field name: field_hero_heading
# Field type: text (plain)

drush generate field:paragraph
# Field name: field_hero_subheading
# Field type: text (formatted)

drush generate field:paragraph
# Field name: field_hero_cta
# Field type: link

# 3. Add template and styles
# Copy generated files:
# - templates/paragraph/paragraph--hero-section.html.twig
# - css/paragraphs/_hero-section.scss

# 4. Import SCSS in main stylesheet
# In style.scss:
@import 'paragraphs/hero-section';

# 5. Clear cache
drush cr

# 6. Create test content
# - Add paragraph to node
# - Fill in fields
# - Save and view

# 7. Validate implementation
/design-validate http://cms-cultivator.ddev.site/node/123

# Output shows issues, fix and re-validate

# 8. Export configuration
drush config:export

# 9. Commit and deploy
git add config/ templates/ css/
git commit -m "feat(paragraphs): add hero section paragraph type"
git push
```

---

## Best Practices

### Design Analysis

**Provide Clear References:**
- Use high-resolution images (minimum 1920px width)
- Include all states (default, hover, active, focus)
- Show mobile and desktop layouts
- Include design annotations (spacing, colors, fonts)

**Figma Tips:**
- Share design with "View only" permissions
- Use Figma's developer mode for accurate specs
- Include component variants
- Document interaction patterns

### Code Generation

**Review Generated Code:**
- Check for placeholder content
- Verify color values match brand
- Validate spacing matches design
- Test all breakpoints

**Customize Thoughtfully:**
- Keep accessibility features intact
- Maintain mobile-first approach
- Preserve semantic HTML
- Don't remove ARIA attributes without understanding them

**Follow CMS Patterns:**
- WordPress: Use core blocks when possible
- Drupal: Follow field naming conventions
- Both: Use CSS custom properties for theming

### Browser Validation

**Test Early and Often:**
- Validate during development, not just at the end
- Test on actual devices, not just browser resize
- Use real content, not Lorem Ipsum
- Check with screen readers (NVDA, JAWS, VoiceOver)

**Address Issues by Priority:**
1. **Critical**: Color contrast, keyboard traps, missing alt text
2. **Important**: Skip links, heading hierarchy, touch targets
3. **Nice-to-have**: Performance optimizations, animation polish

**Automate When Possible:**
- Run validation in CI/CD pipeline
- Set up automated accessibility scans
- Monitor color contrast in design system
- Use linting tools (a11y plugins for ESLint/Stylelint)

---

## Troubleshooting

### Design Analysis Issues

**Problem:** "Can't access Figma URL"

**Solution:**
- Verify sharing permissions (set to "Anyone with link")
- Try exporting design as PNG and using image instead
- Check if Figma file is in organization with restricted access

**Problem:** "Colors don't match design"

**Solution:**
- Verify color space in design (RGB vs CMYK)
- Check if design has color overlays or opacity
- Use browser DevTools color picker to verify
- Compare hex values in Figma vs generated code

### WordPress Block Pattern Issues

**Problem:** "Pattern doesn't appear in Block Editor"

**Solution:**
```bash
# 1. Verify file location
ls wp-content/themes/your-theme/patterns/

# 2. Check PHP syntax
php -l wp-content/themes/your-theme/patterns/hero-with-cta.php

# 3. Clear cache
wp cache flush

# 4. Check pattern header format
# Must have:
# - Title
# - Slug (unique)
# - Categories (at least one)
```

**Problem:** "Styles not applying"

**Solution:**
- Check if inline styles are in `<style>` tag
- Verify CSS selectors match generated HTML
- Check for theme CSS conflicts
- Use `!important` as last resort
- Inspect with browser DevTools

**Problem:** "Pattern breaks on mobile"

**Solution:**
- Test with actual mobile device, not just browser resize
- Check for missing `viewport` meta tag
- Verify media queries are correct
- Look for fixed widths instead of responsive units
- Check for `overflow: hidden` issues

### Drupal Paragraph Type Issues

**Problem:** "Fields not appearing"

**Solution:**
```bash
# 1. Verify field configuration
drush config:get field.field.paragraph.hero_section.field_hero_heading

# 2. Check field is in display
drush config:get core.entity_view_display.paragraph.hero_section.default

# 3. Clear cache
drush cr

# 4. Rebuild permissions
drush php:eval "node_access_rebuild();"

# 5. Check field permissions
drush config:get field.field.paragraph.hero_section.field_hero_heading | grep -i permission
```

**Problem:** "Twig template not loading"

**Solution:**
```bash
# 1. Verify template location
# Must be in: themes/THEME/templates/paragraph/

# 2. Check file naming
# Correct: paragraph--hero-section.html.twig
# Incorrect: paragraph-hero-section.html.twig

# 3. Clear Twig cache
drush cr

# 4. Enable Twig debugging (development only)
# In settings.php or development.services.yml:
parameters:
  twig.config:
    debug: true
    auto_reload: true

# 5. Check template suggestions
# Look in HTML source for:
# <!-- BEGIN OUTPUT from 'themes/...' -->
```

**Problem:** "Styles not loading"

**Solution:**
- Verify SCSS compiled to CSS
- Check library definition in `theme.libraries.yml`
- Ensure library is attached (globally or in template)
- Clear Drupal cache
- Check browser console for 404 errors

### Browser Validation Issues

**Problem:** "DevTools MCP not connecting"

**Solution:**
```bash
# 1. Check MCP server is running
ps aux | grep chrome-devtools-mcp

# 2. Verify MCP configuration
cat ~/.config/claude/mcp.json

# 3. Restart MCP server
# (Depends on your MCP setup)

# 4. Check Chrome/Chromium is installed
which google-chrome
which chromium

# 5. Try manual DevTools connection
# Open Chrome, navigate to chrome://inspect
```

**Problem:** "Validation shows false positives"

**Solution:**
- Manually verify with browser DevTools
- Test with actual assistive technology
- Check if browser extensions interfering
- Compare with other accessibility tools (axe, WAVE)
- Consider context (some warnings may not apply)

**Problem:** "Site not accessible during validation"

**Solution:**
```bash
# For local development:

# WordPress:
wp server --host=0.0.0.0 --port=8000

# Drupal:
drush rs 0.0.0.0:8000

# DDEV:
ddev launch
# Get URL from: ddev describe

# Check firewall settings
# Ensure port is open

# For remote sites:
# - Verify URL is correct
# - Check if site requires authentication
# - Ensure no IP restrictions
# - Try with VPN if behind firewall
```

---

## Related Commands

- **[`/design-to-block`](../commands/design-workflow.md#design-to-block)** - Create WordPress block patterns from designs
- **[`/design-to-paragraph`](../commands/design-workflow.md#design-to-paragraph)** - Create Drupal paragraph types from designs
- **[`/design-validate`](../commands/design-workflow.md#design-validate)** - Validate implementation in browser
- **[`/audit-a11y`](../commands/accessibility.md)** - Comprehensive WCAG accessibility audit

---

## Additional Resources

### Design Tools
- [Figma](https://www.figma.com/)
- [Adobe XD](https://www.adobe.com/products/xd.html)
- [Sketch](https://www.sketch.com/)

### Accessibility
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WebAIM Color Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [WAVE Browser Extension](https://wave.webaim.org/extension/)
- [axe DevTools](https://www.deque.com/axe/devtools/)

### WordPress
- [Block Patterns Documentation](https://developer.wordpress.org/block-editor/reference-guides/block-api/block-patterns/)
- [Theme.json Reference](https://developer.wordpress.org/block-editor/how-to-guides/themes/theme-json/)
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)

### Drupal
- [Paragraph Module](https://www.drupal.org/project/paragraphs)
- [Twig Template Documentation](https://www.drupal.org/docs/theming-drupal/twig-in-drupal)
- [Drupal Coding Standards](https://www.drupal.org/docs/develop/standards)
- [Field API](https://www.drupal.org/docs/drupal-apis/entity-api/fields-api)

### Responsive Design
- [MDN: Responsive Design](https://developer.mozilla.org/en-US/docs/Learn/CSS/CSS_layout/Responsive_Design)
- [A Complete Guide to Flexbox](https://css-tricks.com/snippets/css/a-guide-to-flexbox/)
- [A Complete Guide to Grid](https://css-tricks.com/snippets/css/complete-guide-grid/)

---

**Key Takeaway**: The design workflow ensures pixel-perfect, accessible, and responsive implementations by combining automated code generation with rigorous browser-based validation. Always validate early and often to catch issues before they reach production.
