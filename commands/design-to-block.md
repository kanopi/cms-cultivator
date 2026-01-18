---
description: "Create WordPress block pattern from Figma design or screenshot using design specialist"
argument-hint: "[design-source] [pattern-name] [theme-namespace]"
allowed-tools: Task
---

Spawn the **design-specialist** agent for WordPress block pattern creation:

```
Task(cms-cultivator:design-specialist:design-specialist,
     prompt="Create a WordPress block pattern from the provided design.

# WordPress Block Pattern from Design

## Design Reference
{User's design source - Figma URL or screenshot path}

## Pattern Details
- Pattern Name: {User's pattern-name}
- Theme: {User's theme-namespace or auto-detect from current directory}
- Generate slug as: {theme-prefix}/{pattern-slug}

## Requirements

### Block Pattern Structure
- Use **native WordPress blocks only**:
  - Core blocks: Group, Cover, Heading, Paragraph, Buttons, Button, Image, Columns, Column, Gallery, Spacer, Separator
  - No custom blocks or third-party dependencies
- Follow modern block pattern format with proper PHP header comments
- Create pattern file at: wp-content/themes/{theme}/patterns/{pattern-slug}.php
- Use proper WordPress pattern headers (Title, Slug, Categories, Description)

### Theme Prefix Logic
1. Extract theme name from user input or current directory
2. Generate prefix: Take first part before hyphen, or first 6 characters
3. Convert to lowercase
4. Pattern slug format: {prefix}/{pattern-name}

Examples:
- Theme 'kanopi-base' → prefix 'kanopi' → slug 'kanopi/hero-cta'
- Theme 'my-theme' → prefix 'my' → slug 'my/hero-cta'

### Styling Requirements
- Create companion SCSS file at: wp-content/themes/{theme}/assets/styles/scss/patterns/_{pattern-slug}.scss
- Mobile-first responsive approach (base styles → 768px → 1024px)
- WCAG 2.1 Level AA compliance (4.5:1 contrast minimum for normal text)
- Touch-friendly targets (44px minimum on mobile)
- Proper focus indicators (2px outline minimum)
- Support keyboard navigation
- Include @prefers-reduced-motion support

### Process
1. Analyze design using design-analyzer skill
   - Extract colors, typography, spacing, layout
   - Identify WordPress blocks needed
   - Plan responsive behavior
   - Note accessibility requirements

2. Generate block pattern PHP file
   - Proper WordPress pattern headers
   - Native WordPress blocks only
   - Semantic HTML structure
   - Placeholder content with i18n functions

3. Spawn responsive-styling-specialist agent
   - Pass design specifications
   - Request mobile-first SCSS
   - WAIT for completion before proceeding

4. Create test page
   - URL: http://{site-domain}/test-{pattern-slug}/
   - Insert pattern using WordPress blocks
   - Or provide manual instructions if WP-CLI unavailable

5. Spawn browser-validator-specialist agent
   - Pass test URL and design reference
   - Request responsive testing (320px, 768px, 1024px+)
   - Request accessibility validation (WCAG AA)
   - Request detailed technical report
   - WAIT for completion

6. Report detailed results
   - File paths with line counts
   - Technical specifications
   - Validation findings
   - Next steps")
```

## How It Works

This command spawns the **design-specialist** agent with WordPress focus. The agent orchestrates the complete workflow:

1. **Analyzes design** using the design-analyzer skill to extract technical requirements
2. **Generates block pattern PHP** using native WordPress blocks
3. **Spawns responsive-styling-specialist** for mobile-first CSS/SCSS (waits for completion)
4. **Creates test page** for validation
5. **Spawns browser-validator-specialist** for comprehensive testing (waits for completion)
6. **Reports detailed results** with file paths and technical specs

**Sequential execution ensures** each step completes successfully before proceeding.

## When to Use

**Use this command (`/design-to-block`)** when:
- ✅ You have a Figma design or screenshot to convert
- ✅ You want a WordPress block pattern (not a custom block)
- ✅ You need responsive, accessible, production-ready code
- ✅ You want automated testing and validation

**Design source can be**:
- Figma URL: `https://figma.com/file/ABC123?node-id=1:234`
- Screenshot path: `./mockups/hero.png` or `/absolute/path/to/design.jpg`
- Relative path: `../designs/feature.png`

## Example Usage

```bash
# From Figma URL
/design-to-block https://figma.com/file/ABC123 hero-cta my-theme

# From screenshot in current directory
/design-to-block mockup.png team-grid

# From screenshot with theme specified
/design-to-block designs/hero.png hero-section kanopi-base

# Minimal (auto-detect theme from current directory)
/design-to-block design.png feature-banner
```

## What Gets Created

### 1. Block Pattern PHP File
**Path**: `wp-content/themes/{theme}/patterns/{pattern-slug}.php`

**Contains**:
- WordPress pattern header (Title, Slug, Categories, Description)
- Native WordPress block markup
- Semantic HTML structure
- i18n ready (uses `esc_html_e()`, `esc_attr_e()`)
- Custom CSS class for styling hook

**Example**:
```php
<?php
/**
 * Title: Hero CTA
 * Slug: my-theme/hero-cta
 * Categories: features, call-to-action
 * Description: Full-width hero section with heading, text, and call-to-action button
 */
?>
<!-- wp:group {"className":"hero-cta-pattern"} -->
<div class="wp-block-group hero-cta-pattern">
    <!-- wp:heading {"level":1} -->
    <h1><?php esc_html_e( 'Your Heading Here', 'my-theme' ); ?></h1>
    <!-- /wp:heading -->

    <!-- wp:paragraph -->
    <p><?php esc_html_e( 'Supporting text goes here', 'my-theme' ); ?></p>
    <!-- /wp:paragraph -->

    <!-- wp:buttons -->
    <div class="wp-block-buttons">
        <!-- wp:button -->
        <div class="wp-block-button">
            <a class="wp-block-button__link"><?php esc_html_e( 'Call to Action', 'my-theme' ); ?></a>
        </div>
        <!-- /wp:button -->
    </div>
    <!-- /wp:buttons -->
</div>
<!-- /wp:group -->
```

### 2. Responsive Stylesheet
**Path**: `wp-content/themes/{theme}/assets/styles/scss/patterns/_{pattern-slug}.scss`

**Contains**:
- Mobile-first base styles
- Tablet breakpoint styles (@media min-width: 768px)
- Desktop breakpoint styles (@media min-width: 1024px)
- WCAG AA compliant colors (with contrast ratios documented)
- Touch-friendly sizing (44px minimum targets)
- Proper focus indicators
- Reduced motion support

### 3. Test Page
**URL**: `http://{site-domain}/test-{pattern-slug}/`

**Created automatically** if WP-CLI available, or manual instructions provided.

### 4. Validation Report
Comprehensive technical report including:
- ✅ Responsive behavior at all breakpoints (with screenshots)
- ✅ Accessibility findings (contrast ratios, keyboard nav, ARIA)
- ✅ File paths and line numbers for any issues
- ✅ Specific code fixes for problems
- ✅ Next steps and recommendations

## Output Example

```
✅ WordPress Block Pattern Created: Hero CTA

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Files Created

1. **Block Pattern PHP**
   - Path: wp-content/themes/my-theme/patterns/hero-cta.php
   - Lines: 127
   - Slug: my-theme/hero-cta
   - Blocks: Group, Heading, Paragraph, Buttons
   - Registration: Auto-discovered (WordPress 6.0+)

2. **Responsive Stylesheet**
   - Path: wp-content/themes/my-theme/assets/styles/scss/patterns/_hero-cta.scss
   - Lines: 234
   - Approach: Mobile-first
   - Breakpoints: 768px (tablet), 1024px (desktop)
   - WCAG AA: ✅ All text meets 4.5:1 minimum
   - Touch targets: ✅ 44px minimum on mobile

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Test Page

URL: http://my-site.test/test-hero-cta/
Status: Published

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Validation Results

**Summary**: ✅ 12 passed • ⚠️ 2 warnings • ❌ 0 failed

### Responsive Behavior
✅ Mobile (320px) - Layout optimal
✅ Tablet (768px) - Layout optimal
✅ Desktop (1024px) - Layout optimal

### Accessibility
✅ Color contrast passes (all text 4.5:1+)
✅ Keyboard navigation works
⚠️  Focus indicator could be stronger
   - File: _hero-cta.scss:45
   - Fix: Increase outline from 1px to 2px

### Interactions
✅ Hover states working
✅ Click handlers functional
⚠️  Touch target slightly small on mobile (42px)
   - File: _hero-cta.scss:67
   - Fix: Increase padding from 11px to 12px

See full report: screenshots/hero-cta/validation-report.md

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Next Steps

1. Review test page in browser: http://my-site.test/test-hero-cta/
2. Apply recommended fixes (2 minor issues)
3. Import SCSS into theme stylesheet
4. Pattern is ready to use in Block Editor!
   - Appears in: Patterns → Features
   - Slug: my-theme/hero-cta
```

## Integration with Existing Workflows

### Kanopi Projects
If using Kanopi DDEV add-ons:
```bash
# After pattern creation, compile styles
ddev theme-build

# Run accessibility audit
ddev pa11y http://my-site.ddev.site/test-hero-cta/
```

### Non-Kanopi Projects
```bash
# Compile SCSS (if using node-sass or similar)
npm run build:styles

# Or import in your main SCSS file
@import 'patterns/hero-cta';
```

## Pattern Registration

**WordPress 6.0+**: Patterns in the `/patterns/` directory are automatically discovered. No manual registration needed.

**WordPress 5.9 and earlier**: Patterns must be registered manually in `functions.php`:

```php
function my_theme_register_block_patterns() {
    register_block_pattern(
        'my-theme/hero-cta',
        array(
            'title'       => __( 'Hero CTA', 'my-theme' ),
            'description' => __( 'Full-width hero section with heading, text, and CTA button', 'my-theme' ),
            'categories'  => array( 'features', 'call-to-action' ),
            'content'     => file_get_contents( get_template_directory() . '/patterns/hero-cta.php' ),
        )
    );
}
add_action( 'init', 'my_theme_register_block_patterns' );
```

## Troubleshooting

### Error: "Design reference not found"
**Solution**: Verify file path is correct. Use absolute paths or paths relative to project root.

```bash
# Check file exists
ls -la mockups/hero.png

# Use absolute path
/design-to-block /full/path/to/mockups/hero.png hero-cta
```

### Error: "Theme directory not found"
**Solution**: Navigate to WordPress root or specify theme name explicitly.

```bash
# Navigate to WordPress root
cd /path/to/wordpress

# Or specify theme name
/design-to-block design.png hero-cta my-theme-name
```

### Warning: "Chrome DevTools MCP not available"
**Impact**: Browser validation will be skipped, manual validation checklist provided instead.

**Solution**: Install Chrome DevTools MCP for automated testing:
1. Install: https://github.com/anthropics/claude-chrome-mcp
2. Configure in Claude Code settings
3. Restart Claude Code
4. Retry command

### Pattern not appearing in Block Editor
**Check**:
1. Pattern file exists in `/patterns/` directory
2. WordPress version is 6.0+ for auto-discovery
3. Pattern has proper PHP header comments
4. Theme is active
5. Clear browser cache and refresh editor

## Related Commands

- `/design-to-paragraph` - Create Drupal paragraph type from design
- `/design-validate` - Validate existing implementation
- `/audit-a11y` - Comprehensive accessibility audit
- `/pr-review` - Review code before committing

---

**For complete technical workflow details**, see:
→ [`agents/design-specialist/AGENT.md`](../agents/design-specialist/AGENT.md)
→ [`skills/design-analyzer/SKILL.md`](../skills/design-analyzer/SKILL.md)
→ [`skills/responsive-styling/SKILL.md`](../skills/responsive-styling/SKILL.md)
→ [`skills/browser-validator/SKILL.md`](../skills/browser-validator/SKILL.md)
