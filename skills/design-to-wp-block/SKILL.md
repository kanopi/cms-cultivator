---
name: design-to-wp-block
description: Create WordPress block patterns from Figma designs or screenshots using the design-specialist agent. Auto-activates when user provides a Figma URL or design mockup and asks to create a WordPress block pattern, component, or section. Invoke when user says "create a WordPress block from this design", "convert this Figma to a block pattern", or provides a design reference with WordPress context.
---

# Design to WordPress Block

Create production-ready WordPress block patterns from Figma designs or screenshots using the design-specialist agent.

## Usage

- "Create a WordPress block pattern from this Figma design: [URL]"
- "Convert this mockup to a WordPress block pattern: [screenshot path]"
- "Build a hero-cta block pattern from this design for the kanopi-base theme"

**Arguments**: `[design-source] [pattern-name] [theme-namespace]`

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() is unavailable but design data can be accessed:

1. **Analyze design** — If screenshot provided, use Read to view image and extract:
   - Colors (hex codes), typography (fonts, sizes, weights), spacing values
   - Layout structure and component hierarchy
   - Responsive behavior requirements
2. **Generate block pattern** directly using Write:
   - Create `wp-content/themes/{theme}/patterns/{pattern-slug}.php` with proper WordPress pattern headers
   - Use native WordPress blocks only (Group, Cover, Heading, Paragraph, Buttons, Image, Columns, etc.)
   - Include i18n functions (`esc_html_e()`, `esc_attr_e()`)
3. **Generate SCSS** — Create companion stylesheet at `wp-content/themes/{theme}/assets/styles/scss/patterns/_{pattern-slug}.scss`
   - Mobile-first (base → 768px → 1024px)
   - WCAG AA color contrast (4.5:1 minimum)
   - Touch-friendly (44px minimum targets)
   - Proper focus indicators (2px outline minimum)
   - `@prefers-reduced-motion` support
4. **Generate editor stylesheet** — Create `_{pattern-slug}-editor.scss` for block editor styling
5. **Provide instructions** — Manual steps for testing and enqueue setup

**Note for Tier 1 with Figma**: Figma MCP tools are only available in the main Claude Code conversation, not subagents. Fetch design context in the main conversation before activating this skill.

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() and Figma MCP available:

**Step 1: Fetch Design Data in Main Conversation**

If design source is a Figma URL:
```
ToolSearch(query: "select:mcp__plugin_figma_figma__get_design_context")
mcp__plugin_figma_figma__get_design_context(fileKey, nodeId, clientLanguages: "html,css,php", clientFrameworks: "wordpress")
mcp__plugin_figma_figma__get_screenshot(fileKey, nodeId)
```

Extract: colors (hex), typography, spacing, layout structure, component hierarchy.

**Step 2: Spawn design-specialist for code generation**

```
Agent(subagent_type="cms-cultivator:design-specialist:design-specialist",
      prompt="Create a WordPress block pattern from the provided design specifications.

## Design Specifications (Pre-Fetched)
{extracted colors, typography, spacing, layout structure}

## Pattern Details
- Pattern Name: {pattern-name}
- Theme: {theme-namespace or auto-detect}

## Requirements
- Native WordPress blocks only (Group, Cover, Heading, Paragraph, Buttons, Image, Columns)
- Pattern file: wp-content/themes/{theme}/patterns/{pattern-slug}.php
- Mobile-first, WCAG AA, 44px touch targets

## Output Required
Return the structured report including:
- Generated file paths
- SCSS paths section (component name, front-end path, editor path)
- Design specifications section (colors, typography, spacing)
- Test page URL and screenshots directory")
```

**Step 3: Spawn responsive-styling-specialist** using the SCSS paths and design specs from Step 2 output:

```
Agent(subagent_type="cms-cultivator:responsive-styling-specialist:responsive-styling-specialist",
      prompt="Generate mobile-first responsive SCSS for the {pattern-name} WordPress block pattern.

Component: {component from design-specialist output}
File paths:
- Front-end: {front-end SCSS path from design-specialist output}
- Editor: {editor SCSS path from design-specialist output}

Design specifications:
{colors, typography, spacing from design-specialist output}

Requirements:
- Mobile-first (base → 768px → 1024px)
- WCAG AA color contrast (4.5:1 normal text, 3:1 large text)
- Touch-friendly targets (44px minimum)
- Proper focus indicators (2px outline)
- Reduced motion support
- Generate TWO files: front-end SCSS and editor SCSS (prefixed with .editor-styles-wrapper)")
```

**Step 4: Spawn browser-validator-specialist** using the test page URL from Step 2 output:

```
Agent(subagent_type="cms-cultivator:browser-validator-specialist:browser-validator-specialist",
      prompt="Validate the WordPress block pattern implementation.

Test URL: {test page URL from design-specialist output}
Design reference: {original design source}

Validation requirements:
- Test responsive breakpoints: 320px, 768px, 1024px+
- Capture screenshots at each breakpoint
- Check WCAG AA accessibility (contrast, keyboard nav, focus indicators, semantic HTML)
- Validate interactions (hover, click, focus states)
- Check JavaScript console for errors
- Compare with original design reference
- Generate detailed technical report with file paths and remediation steps

Save screenshots to: {screenshots dir from design-specialist output}")
```

**Step 5: Report** — present the block pattern file paths, CSS paths, and browser validation results to the user.

## What Gets Created

### 1. Block Pattern PHP File
**Path**: `wp-content/themes/{theme}/patterns/{pattern-slug}.php`
```php
<?php
/**
 * Title: Hero CTA
 * Slug: my-theme/hero-cta
 * Categories: features, call-to-action
 * Description: Full-width hero section with heading, text, and CTA
 */
?>
<!-- wp:group {"className":"hero-cta-pattern"} -->
<div class="wp-block-group hero-cta-pattern">
    <!-- wp:heading {"level":1} -->
    <h1><?php esc_html_e( 'Your Heading Here', 'my-theme' ); ?></h1>
    <!-- /wp:heading -->
    ...
</div>
<!-- /wp:group -->
```

### 2. Front-End Stylesheet
**Path**: `wp-content/themes/{theme}/assets/styles/scss/patterns/_{pattern-slug}.scss`
- Mobile-first responsive (768px tablet, 1024px desktop)
- WCAG AA compliant colors
- Touch targets ≥ 44px on mobile

### 3. Editor Stylesheet
**Path**: `wp-content/themes/{theme}/assets/styles/scss/patterns/_{pattern-slug}-editor.scss`
- All front-end styles wrapped in `.editor-styles-wrapper`

## Pattern Registration

**WordPress 6.0+**: Patterns in `/patterns/` directory auto-discovered — no registration needed.

**Auto-enqueue editor styles** (add once to functions.php):
```php
function my_theme_setup() {
    add_theme_support( 'editor-styles' );
    $styles = glob( get_template_directory() . '/assets/styles/css/patterns/*-editor.css' );
    foreach ( $styles as $path ) {
        add_editor_style( str_replace( get_template_directory() . '/', '', $path ) );
    }
}
add_action( 'after_setup_theme', 'my_theme_setup' );
```

## Kanopi Projects

```bash
ddev theme-build          # Compile SCSS
ddev wp cache flush        # Clear cache
ddev pa11y [test-url]     # Accessibility test
```

## Related Skills

- **design-analyzer** — Extracts technical specs from designs
- **responsive-styling** — Generates mobile-first CSS/SCSS
- **browser-validator** — Validates implementation in browser
- **design-to-drupal-paragraph** — Drupal equivalent
