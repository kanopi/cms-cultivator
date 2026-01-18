# Design Workflow Commands

Accelerate design-to-code workflows with automated component generation, responsive styling, and browser validation.

---

## Commands

### `/design-to-block [design-source] [pattern-name] [theme-namespace]`

Create WordPress block patterns from design references (Figma URLs, screenshots, mockups).

**Usage:**
```bash
# From uploaded image
/design-to-block design.png hero-cta

# From Figma URL
/design-to-block https://figma.com/file/ABC123 feature-grid kanopi

# With custom theme namespace
/design-to-block mockup.jpg testimonial-section mytheme
```

**What it does:**
1. **Analyzes design** - Extracts colors, typography, spacing, layout
2. **Maps to blocks** - Selects appropriate WordPress core blocks
3. **Generates pattern** - Creates PHP block pattern file
4. **Generates styles** - Creates mobile-first SCSS with WCAG AA compliance
5. **Validates in browser** - Tests responsive behavior and accessibility
6. **Reports results** - Detailed technical report with file paths and fixes

**What it generates:**
- **Pattern file**: `patterns/{pattern-name}.php`
- **Styles file**: `assets/scss/patterns/_{pattern-name}.scss`
- **Screenshots**: `screenshots/{pattern-name}/` (mobile, tablet, desktop)
- **Validation report**: Accessibility and responsive issues with fixes

**Design input formats:**
- Screenshots (.png, .jpg, .jpeg, .webp)
- Figma URLs
- Local design files

**WordPress blocks used:**
- Group (containers)
- Cover (full-width sections with backgrounds)
- Heading (h1-h6)
- Paragraph (body text)
- Buttons/Button (CTAs)
- Image (media)
- Gallery (image collections)
- Columns/Column (layouts)

**Requires:** Chrome DevTools MCP for browser validation

---

### `/design-to-paragraph [design-source] [paragraph-name] [module-name]`

Create Drupal paragraph types from design references.

**Usage:**
```bash
# From uploaded image
/design-to-paragraph design.png content_card

# From Figma URL
/design-to-paragraph https://figma.com/file/XYZ789 hero_banner kanopi_paragraphs

# With custom module
/design-to-paragraph mockup.jpg feature_grid my_custom_module
```

**What it does:**
1. **Analyzes design** - Extracts requirements and content structure
2. **Maps to fields** - Determines field types and configuration
3. **Generates YAML** - Creates Drupal configuration files
4. **Generates template** - Creates Twig template with markup
5. **Generates styles** - Creates mobile-first SCSS
6. **Validates in browser** - Tests implementation
7. **Reports results** - Technical report with installation steps

**What it generates:**
- **Configuration files**:
  - `config/install/paragraphs.paragraphs_type.{name}.yml`
  - `config/install/field.storage.paragraph.*.yml`
  - `config/install/field.field.paragraph.*.yml`
  - `config/install/core.entity_form_display.paragraph.*.yml`
  - `config/install/core.entity_view_display.paragraph.*.yml`
- **Template**: `templates/paragraph--{name}.html.twig`
- **Styles**: `scss/paragraphs/_{name}.scss`
- **Screenshots**: Validation screenshots
- **Installation guide**: Step-by-step import instructions

**Drupal field types used:**
- `string` - Short text (titles, labels)
- `text_long` - Body/description fields
- `link` - URLs and CTAs
- `entity_reference` (Media) - Images and videos
- `boolean` - Feature toggles
- `list_text` - Select options
- `entity_reference` (Taxonomy) - Categories/tags

**Drupal MCP (optional):**
- If available: Automatically imports configuration
- If not: Provides manual import instructions

---

### `/design-validate [test-url] [design-reference]`

Validate design implementations in browser with comprehensive checks.

**Usage:**
```bash
# Validate without design reference
/design-validate http://site.ddev.site/test-hero/

# Validate with design comparison
/design-validate http://local.test/page mockups/original-design.png

# Validate production page
/design-validate https://example.com/new-feature

# With Figma reference
/design-validate http://site.test/test design-ref.png
```

**What it validates:**

**Responsive Behavior:**
- Tests at 320px (mobile), 768px (tablet), 1024px (desktop)
- Captures screenshots at each breakpoint
- Checks for text overflow, horizontal scrolling, broken layouts
- Verifies touch targets ≥ 44px on mobile
- Ensures font sizes ≥ 16px on mobile

**Accessibility (WCAG 2.1 Level AA):**
- **Color contrast**: Calculates exact ratios (4.5:1 for normal text, 3:1 for large)
- **Semantic HTML**: Heading hierarchy, landmark regions, proper structure
- **Keyboard navigation**: Tab order, focus indicators (2px minimum), no traps
- **ARIA**: Proper labels, descriptions, live regions
- **Touch targets**: Minimum 44x44px on mobile viewports

**Interactions:**
- Hover states
- Click actions
- Focus states
- Disabled states
- Loading states

**Console & Network:**
- JavaScript errors with stack traces
- Failed network requests (404s, CORS)
- Performance issues

**Design Comparison (if reference provided):**
- Visual accuracy at each breakpoint
- Color matching
- Typography verification
- Spacing validation
- Layout proportions

**What it generates:**
- **Screenshots**: `screenshots/{component}/` at all breakpoints
- **Technical report**: File paths, line numbers, contrast calculations, fixes
- **Priority recommendations**: Critical (must fix) → Important (should fix) → Nice to have

**Requires:** Chrome DevTools MCP installed and connected

---

## Workflow Example

### WordPress Block Pattern

```bash
# 1. Upload design or reference Figma URL
# User: "Create a hero banner from this design"
# [Uploads hero-design.png]

# 2. Run command
/design-to-block hero-design.png hero-banner

# 3. Review generated files:
# ✓ patterns/hero-banner.php
# ✓ assets/scss/patterns/_hero-banner.scss
# ✓ screenshots/hero-banner/ (mobile, tablet, desktop)
# ✓ Validation report

# 4. Apply recommended fixes (if any)
# Edit files based on validation report

# 5. Re-validate
/design-validate http://site.ddev.site/test-hero-banner/

# 6. Commit and create PR
/pr-commit-msg
/pr-create PROJ-123
```

### Drupal Paragraph Type

```bash
# 1. Upload design
# User: "Create a card component from this"
# [Uploads card-design.png]

# 2. Run command
/design-to-paragraph card-design.png content_card

# 3. Review generated YAML and Twig files
# ✓ config/install/*.yml (7 configuration files)
# ✓ templates/paragraph--content-card.html.twig
# ✓ scss/paragraphs/_content-card.scss

# 4. Import configuration
# Manual: drush config-import --partial --source=modules/custom/my_module/config/install
# Or with Drupal MCP: Automatic import

# 5. Validate
/design-validate http://site.ddev.site/node/123

# 6. Apply fixes and commit
# Based on validation report
/pr-commit-msg
/pr-create PROJ-456
```

---

## Features

### Automatic Design Analysis

The **design-analyzer** Agent Skill automatically activates when you:
- Upload an image file (.png, .jpg, .jpeg, .webp, .svg)
- Mention a Figma URL
- Say "implement this design", "create component from mockup", etc.

**What it extracts:**
- Colors (hex codes, primary/secondary/accent)
- Typography (families, sizes, weights, line-heights)
- Spacing (margins, padding, gaps)
- Layout (grid systems, columns, flexbox patterns)
- Responsive behavior (breakpoint requirements)
- Interactive elements (hover states, animations)

### Mobile-First Responsive Styling

The **responsive-styling** Agent Skill automatically generates mobile-first CSS when creating styles:

**Standard breakpoints:**
- Mobile: 320px-767px (base styles)
- Tablet: 768px-1023px (`@media (min-width: 768px)`)
- Desktop: 1024px+ (`@media (min-width: 1024px)`)

**Best practices:**
- Mobile-first approach (enhance upward)
- WCAG AA color contrast (4.5:1 minimum)
- Touch-friendly (44px minimum targets)
- Proper focus indicators (2px outline minimum)
- Reduced motion support
- Fluid typography with clamp()

### Browser-Based Validation

The **browser-validator** Agent Skill validates implementations using Chrome DevTools MCP:

**8 validation phases:**
1. Initial setup and navigation
2. DOM structure validation
3. Responsive testing at breakpoints
4. Interactive elements testing
5. Keyboard navigation
6. Color contrast analysis
7. Console and network analysis
8. Comprehensive accessibility audit

**Report format:**
```markdown
# Validation Report: Component Name

## 📊 Summary
✅ Passed: 12 checks
⚠️  Warnings: 3 checks
❌ Failed: 2 checks

## 📱 Responsive Behavior
[Screenshots and issues at each breakpoint]

## ♿ Accessibility
[Contrast ratios, semantic HTML, keyboard nav]

## 📝 Recommendations (Priority Order)
🔴 CRITICAL
1. Fix body text contrast (file.scss:23)
   Current: color: #666
   Fix: color: #595959
   Calculation: 4.54:1 ✅

🟡 IMPORTANT
2. Fix mobile text overflow (file.scss:45)
   Fix: font-size: clamp(1.5rem, 5vw, 2rem);
```

---

## Platform Support

### WordPress
- Native block patterns
- Core blocks (Group, Cover, Heading, Paragraph, Buttons, etc.)
- Block pattern categories
- Theme.json integration
- FSE compatibility

### Drupal
- Paragraph types
- Field API integration
- Configuration management
- Twig templates
- Optional Drupal MCP for auto-import

### Kanopi Projects (DDEV)
Works seamlessly with Kanopi's DDEV setup:
```bash
# Access local sites
/design-validate http://site.ddev.site/test-page

# Combine with other audits
ddev pa11y http://site.ddev.site/test-page
ddev lighthouse http://site.ddev.site/test-page
```

---

## Requirements

### Required
- **Claude Code CLI** - To run plugin commands
- **Chrome DevTools MCP** - For browser validation
  - Install: https://github.com/anthropics/claude-chrome-mcp
  - Configure in Claude Code settings
  - Restart Claude Code

### Optional
- **Drupal MCP** - Auto-import configuration (WordPress doesn't need this)
- **DDEV** - Local development environment
- **Figma access** - To read Figma URLs (requires authentication)

---

## Troubleshooting

### Chrome DevTools MCP Not Connected

**Error:**
```
❌ Chrome DevTools MCP not connected
Browser validation requires Chrome DevTools MCP.
```

**Solution:**
1. Install: https://github.com/anthropics/claude-chrome-mcp
2. Configure in Claude Code settings
3. Restart Claude Code CLI
4. Retry: `/design-validate {url}`

**Alternative:** Manual validation checklist provided

### Cannot Access Test URL

**Possible causes:**
- Local dev server not running
- URL typo
- Firewall blocking access
- HTTPS certificate issues

**Solutions:**
```bash
# Verify URL in browser first
open http://site.test/test-page

# Check dev server status (WordPress)
wp server

# Check DDEV status
ddev describe

# Check /etc/hosts for local domains
cat /etc/hosts | grep site.test
```

### Design Reference Not Found

**Impact:** Visual comparison skipped, validation proceeds without it

**Solution:**
```bash
# Check file exists
ls -la mockups/design.png

# Use absolute path
/design-validate http://site.test/page /full/path/to/design.png
```

---

## Best Practices

### 1. Validate Early and Often
Don't wait until implementation is complete. Validate during development to catch issues early.

### 2. Provide Design References
Always provide Figma URLs or screenshots for accurate implementation.

### 3. Fix Critical Issues First
Priority: WCAG failures (critical) → UX issues (important) → Polish (nice to have)

### 4. Re-validate After Fixes
Always re-run validation after applying recommended fixes.

### 5. Test on Real Devices
After automated validation passes, test on actual mobile devices.

### 6. Use Semantic HTML
Proper semantic structure improves accessibility and SEO.

---

## Related Commands

- [`/pr-create`](pr-workflow.md#pr-create-ticket-number) - Create PR after implementation
- [`/pr-review self`](pr-workflow.md#pr-review-pr-numberself-focus) - Self-review before PR
- [`/audit-a11y`](accessibility.md) - Comprehensive accessibility audit
- [`/audit-perf`](performance.md) - Performance optimization
- [`/audit-live-site`](live-site-auditing.md) - Full site audit

---

## Learn More

- **[Agent Skills](../agents-and-skills.md)** - How skills auto-activate
- **[Kanopi Tools](../kanopi-tools/overview.md)** - DDEV integration
- **[Contributing](../contributing.md)** - Contribute to the project
