---
description: "Create WordPress block pattern from Figma design or screenshot using design specialist"
argument-hint: "[design-source] [pattern-name] [theme-namespace]"
allowed-tools: ToolSearch, mcp__plugin_figma_figma__get_design_context, mcp__plugin_figma_figma__get_screenshot, Task, Read
---

**CRITICAL FIRST STEP**: Fetch design data in main conversation BEFORE spawning agent.

## Step 1: Fetch Design Data

### If design source is a Figma URL:

1. **Load Figma MCP tools**:
```
ToolSearch(query: "select:mcp__plugin_figma_figma__get_design_context")
ToolSearch(query: "select:mcp__plugin_figma_figma__get_screenshot")
```

2. **Parse Figma URL**:
```
URL format: https://figma.com/design/{fileKey}?node-id={nodeId}
Extract: fileKey and nodeId (replace hyphen with colon in nodeId)
```

3. **Fetch design context**:
```
mcp__plugin_figma_figma__get_design_context(
  fileKey: {extracted},
  nodeId: {extracted with colon},
  clientLanguages: "html,css,php",
  clientFrameworks: "wordpress"
)
```

4. **Get screenshot**:
```
mcp__plugin_figma_figma__get_screenshot(
  fileKey: {same},
  nodeId: {same},
  clientLanguages: "html,css,php",
  clientFrameworks: "wordpress"
)
```

5. **Extract specifications from Figma data**:
- Colors (hex codes from CSS/Tailwind)
- Typography (fonts, sizes, weights, line-heights)
- Spacing (margins, padding, gaps)
- Layout structure
- Image asset URLs
- Component hierarchy

### If design source is a screenshot:

1. **Read the image file**:
```
Read(file_path: {screenshot-path})
```

2. **Visually analyze** and note:
- Layout structure
- Estimated colors
- Typography styles
- Spacing patterns
- Component relationships

## Step 2: Spawn Agent with Design Specifications

Now spawn the **design-specialist** agent with the fetched/extracted specifications:

```
Task(cms-cultivator:design-specialist:design-specialist,
     prompt="Create a WordPress block pattern from the provided design specifications.

# WordPress Block Pattern from Design

## Design Reference
{Original design source - Figma URL or screenshot path}

## Design Specifications (Pre-Fetched)
{Paste the extracted design specifications here, including:
- Colors with hex codes
- Typography details
- Spacing values
- Layout structure
- Component hierarchy
- Image asset URLs (if from Figma)
}

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

---

## Tool Usage

**Allowed operations:**
- ✅ Spawn design-specialist agent (orchestrator)
- ✅ Agent spawns responsive-styling-specialist for CSS generation (sequential)
- ✅ Agent spawns browser-validator-specialist for testing (sequential)
- ✅ Generate WordPress block pattern PHP files
- ✅ Generate responsive SCSS stylesheets
- ✅ Create test pages for validation
- ✅ Capture screenshots at multiple breakpoints

**Not allowed:**
- ❌ Do not activate themes or plugins
- ❌ Do not modify existing theme files (only create new pattern files)
- ❌ Do not commit or push changes

The design-specialist orchestrates all operations sequentially (analysis → code → styling → validation).

---

## How It Works

This command has a **two-phase workflow**:

### Phase 1: Main Conversation Fetches Design (YOU)
1. **Detect design source type** (Figma URL vs screenshot)
2. **For Figma**: Load MCP tools, fetch design context and screenshot, extract specifications
3. **For screenshots**: Read image file, perform visual analysis
4. **Extract/document** all design specifications (colors, typography, spacing, layout)

### Phase 2: Agent Creates Pattern (design-specialist)
1. **Receives** pre-fetched design specifications from Phase 1
2. **Generates block pattern PHP** using native WordPress blocks based on specs
3. **Spawns responsive-styling-specialist** for mobile-first CSS/SCSS (waits for completion)
4. **Creates test page** for validation
5. **Spawns browser-validator-specialist** for comprehensive testing (waits for completion)
6. **Reports detailed results** with file paths and technical specs

**Why this workflow?**
- MCP tools are only available in main conversation, not in subagents
- Fetching design data first ensures accurate specifications
- Agent can focus on implementation with exact values

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

### 2. Front-End Stylesheet
**Path**: `wp-content/themes/{theme}/assets/styles/scss/patterns/_{pattern-slug}.scss`

**Contains**:
- Mobile-first base styles
- Tablet breakpoint styles (@media min-width: 768px)
- Desktop breakpoint styles (@media min-width: 1024px)
- WCAG AA compliant colors (with contrast ratios documented)
- Touch-friendly sizing (44px minimum targets)
- Proper focus indicators
- Reduced motion support

### 3. Editor Stylesheet
**Path**: `wp-content/themes/{theme}/assets/styles/scss/patterns/_{pattern-slug}-editor.scss`

**Contains**:
- All front-end styles wrapped in `.editor-styles-wrapper` context
- Ensures pattern appears styled in WordPress block editor (admin)
- Mirrors front-end styles for accurate preview
- Editor-specific overrides if needed

### 4. Test Page
**URL**: `http://{site-domain}/test-{pattern-slug}/`

**Created automatically** if WP-CLI available, or manual instructions provided.

### 5. Validation Report
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

2. **Front-End Stylesheet**
   - Path: wp-content/themes/my-theme/assets/styles/scss/patterns/_hero-cta.scss
   - Lines: 234
   - Approach: Mobile-first
   - Breakpoints: 768px (tablet), 1024px (desktop)
   - WCAG AA: ✅ All text meets 4.5:1 minimum
   - Touch targets: ✅ 44px minimum on mobile

3. **Editor Stylesheet**
   - Path: wp-content/themes/my-theme/assets/styles/scss/patterns/_hero-cta-editor.scss
   - Lines: 248
   - Context: WordPress block editor (.editor-styles-wrapper)
   - Ensures pattern appears styled in admin

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
3. **Compile SCSS** to CSS (`npm run build:styles` or `ddev theme-build`)
4. **Set up auto-enqueue (one-time)** - Add glob code to functions.php (see "Enqueue Editor Stylesheet" → Option 1)
5. **Import SCSS** into theme stylesheet (for front-end)
6. **Clear cache** (`wp cache flush`)
7. **Test in block editor** - Insert pattern and verify styling appears
8. Pattern is ready to use in Block Editor!
   - Appears in: Patterns → Features
   - Slug: my-theme/hero-cta

**Pro tip**: With auto-enqueue set up, future patterns automatically get editor styles without updating functions.php!
```

## Integration with Existing Workflows

### Kanopi Projects
If using Kanopi DDEV add-ons:

**One-time setup** (auto-enqueue all pattern editor styles):
```php
// functions.php
function my_theme_setup() {
    add_theme_support( 'editor-styles' );

    // Auto-load all pattern editor stylesheets
    $pattern_editor_styles = glob( get_template_directory() . '/assets/styles/css/patterns/*-editor.css' );
    foreach ( $pattern_editor_styles as $style_path ) {
        $relative_path = str_replace( get_template_directory() . '/', '', $style_path );
        add_editor_style( $relative_path );
    }
}
add_action( 'after_setup_theme', 'my_theme_setup' );
```

**After each pattern creation**:
```bash
# Compile styles (front-end + editor)
ddev theme-build

# Run accessibility audit
ddev pa11y http://my-site.ddev.site/test-hero-cta/

# Clear WordPress cache
ddev wp cache flush
```

### Non-Kanopi Projects

**One-time setup** (same auto-enqueue code as above)

**After each pattern creation**:
```bash
# Compile SCSS (if using node-sass or similar)
npm run build:styles

# Clear WordPress cache
wp cache flush

# Import in your main SCSS files
# Front-end: @import 'patterns/hero-cta';
# Editor: @import 'patterns/hero-cta-editor';
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

## Enqueue Editor Stylesheet

**IMPORTANT**: The editor stylesheet must be enqueued to style patterns in the WordPress block editor.

### Option 1: Auto-Enqueue All Pattern Editor Styles (Recommended)

Automatically enqueue all `*-editor.css` files from the patterns directory:

```php
function my_theme_setup() {
    // Add editor stylesheet support
    add_theme_support( 'editor-styles' );

    // Auto-enqueue all pattern editor stylesheets
    $pattern_editor_styles = glob( get_template_directory() . '/assets/styles/css/patterns/*-editor.css' );

    foreach ( $pattern_editor_styles as $style_path ) {
        // Convert absolute path to relative path
        $relative_path = str_replace( get_template_directory() . '/', '', $style_path );
        add_editor_style( $relative_path );
    }
}
add_action( 'after_setup_theme', 'my_theme_setup' );
```

**Benefits**:
- ✅ No need to manually add each pattern
- ✅ New patterns automatically get editor styles
- ✅ No maintenance required
- ✅ Works for any number of patterns

### Option 2: Import in Main Editor Stylesheet (SCSS)

Import all pattern editor styles in a single SCSS file:

```scss
// assets/styles/scss/editor.scss

// Automatically import all pattern editor styles
// Note: You need to manually add each @import, or use a build tool
@import 'patterns/hero-cta-editor';
@import 'patterns/team-grid-editor';
@import 'patterns/feature-banner-editor';
// Add more as you create patterns
```

Then enqueue the compiled main editor stylesheet:

```php
function my_theme_setup() {
    add_theme_support( 'editor-styles' );
    add_editor_style( 'assets/styles/css/editor.css' );
}
add_action( 'after_setup_theme', 'my_theme_setup' );
```

### Option 3: Manual Single File Enqueue

Manually enqueue specific pattern editor stylesheets:

```php
function my_theme_setup() {
    // Add editor stylesheet support
    add_theme_support( 'editor-styles' );

    // Enqueue specific pattern editor styles
    add_editor_style( 'assets/styles/css/patterns/hero-cta-editor.css' );
    add_editor_style( 'assets/styles/css/patterns/team-grid-editor.css' );
    // Add more as you create patterns
}
add_action( 'after_setup_theme', 'my_theme_setup' );
```

**Downside**: Must update `functions.php` every time you add a new pattern.

### Option 4: theme.json with Auto-Enqueue

Combine theme.json with automatic enqueuing:

**theme.json**:
```json
{
  "version": 2,
  "settings": {
    "appearanceTools": true,
    "useRootPaddingAwareAlignments": true
  }
}
```

**functions.php** (same as Option 1):
```php
function my_theme_setup() {
    add_theme_support( 'editor-styles' );

    // Auto-enqueue all pattern editor stylesheets
    $pattern_editor_styles = glob( get_template_directory() . '/assets/styles/css/patterns/*-editor.css' );

    foreach ( $pattern_editor_styles as $style_path ) {
        $relative_path = str_replace( get_template_directory() . '/', '', $style_path );
        add_editor_style( $relative_path );
    }
}
add_action( 'after_setup_theme', 'my_theme_setup' );
```

### Testing Editor Styles

1. **Compile SCSS to CSS** (if using build process):
   ```bash
   npm run build:styles
   # or
   ddev theme-build
   ```

2. **Clear WordPress cache**:
   ```bash
   wp cache flush
   ```

3. **Hard refresh browser** (Cmd+Shift+R on Mac, Ctrl+Shift+R on Windows)

4. **Create or edit a page** in WordPress admin

5. **Insert the pattern** from the Block Inserter

6. **Verify styling** - Pattern should now appear styled in the editor

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

### Pattern appears unstyled in Block Editor
**This is the most common issue!** The pattern shows on the front-end but not in the admin editor.

**Solution**:

1. **Verify editor stylesheet exists**:
   ```bash
   ls wp-content/themes/{theme}/assets/styles/css/patterns/{pattern-slug}-editor.css
   ```

2. **Compile SCSS to CSS**:
   ```bash
   npm run build:styles
   # or
   ddev theme-build
   ```

3. **Set up auto-enqueue in `functions.php`** (recommended):
   ```php
   function my_theme_setup() {
       add_theme_support( 'editor-styles' );

       // Auto-enqueue ALL pattern editor styles
       $pattern_editor_styles = glob( get_template_directory() . '/assets/styles/css/patterns/*-editor.css' );
       foreach ( $pattern_editor_styles as $style_path ) {
           $relative_path = str_replace( get_template_directory() . '/', '', $style_path );
           add_editor_style( $relative_path );
       }
   }
   add_action( 'after_setup_theme', 'my_theme_setup' );
   ```

   **OR manually enqueue single file**:
   ```php
   function my_theme_setup() {
       add_theme_support( 'editor-styles' );
       add_editor_style( 'assets/styles/css/patterns/{pattern-slug}-editor.css' );
   }
   add_action( 'after_setup_theme', 'my_theme_setup' );
   ```

4. **Clear WordPress cache**:
   ```bash
   wp cache flush
   ```

5. **Hard refresh browser** in editor (Cmd+Shift+R / Ctrl+Shift+R)

6. **Check if styles are loaded** in browser DevTools:
   - Open WordPress block editor
   - Inspect element → Network tab → Filter by CSS
   - Look for `{pattern-slug}-editor.css`
   - If missing, editor stylesheet not enqueued correctly
   - Verify glob is finding files: `var_dump(glob(get_template_directory() . '/assets/styles/css/patterns/*-editor.css'));`

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
