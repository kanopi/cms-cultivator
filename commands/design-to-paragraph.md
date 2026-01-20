---
description: "Create Drupal paragraph type from design using design specialist (Drupal MCP optional)"
argument-hint: "[design-source] [paragraph-name] [module-name]"
allowed-tools: Task
---

Spawn the **design-specialist** agent for Drupal paragraph creation:

```
Task(cms-cultivator:design-specialist:design-specialist,
     prompt="Create a Drupal paragraph type from the provided design.

# Drupal Paragraph Type from Design

## Design Reference
{User's design source - Figma URL or screenshot path}

## Paragraph Details
- Paragraph name: {User's paragraph-name} (machine name: lowercase, underscores)
- Module: {User's module-name or 'custom_paragraphs'}

## Requirements

### Paragraph Type Creation
**Try Drupal MCP first** (if available):
- Create paragraph type via MCP
- Configure fields via MCP
- Report success

**Fallback if Drupal MCP unavailable**:
- Generate YAML configuration files:
  - paragraphs.paragraph_type.{paragraph_name}.yml
  - field.storage.paragraph.field_*.yml (per field)
  - field.field.paragraph.{paragraph_name}.field_*.yml (per field)
- Save to: modules/custom/{module}/config/install/
- Provide detailed manual import instructions

### Field Types to Consider
Based on design analysis:
- Text (plain): Short text, headings
- Text (formatted, long): Body content, descriptions
- Link: CTAs, buttons, URLs
- Entity reference (Media): Images, videos
- Boolean: Toggle features, show/hide options
- List (text): Select dropdowns, radio buttons
- Entity reference (Taxonomy): Categories, tags

### Template Creation
- Generate Twig template: modules/custom/{module}/templates/paragraph--{paragraph_name}.html.twig
- Use semantic HTML structure
- Include proper Drupal template variables
- Add BEM-style CSS classes

### Styling Requirements
- Create SCSS file: modules/custom/{module}/scss/_{paragraph_name}.scss
- Mobile-first responsive approach
- Drupal-specific: Use .paragraph--type--{paragraph_name} as root class
- WCAG 2.1 Level AA compliance
- Touch-friendly targets (44px minimum)

### Process
1. Analyze design using design-analyzer skill
   - Extract colors, typography, spacing, layout
   - **Map to Drupal field types and configuration**
   - Plan responsive behavior
   - Note accessibility requirements

2. Check Drupal MCP availability
   - Try to detect Drupal MCP connection
   - If available: proceed with MCP
   - If not: proceed with YAML generation

3a. If Drupal MCP available:
   - Create paragraph type via MCP
   - Add and configure fields via MCP
   - Clear Drupal cache
   - Report success with field details

3b. If Drupal MCP NOT available:
   - Generate YAML configuration files
   - Create module structure if needed
   - Provide step-by-step manual import instructions:
     * Module info file creation
     * File copying
     * Module enabling
     * Configuration import commands
     * Cache clearing
     * Verification steps

4. Generate Twig template
   - Semantic HTML structure
   - Proper Drupal template syntax
   - BEM-style classes
   - Accessibility attributes

5. Spawn responsive-styling-specialist agent
   - Pass design specifications
   - Request mobile-first SCSS
   - Specify Drupal paragraph class structure
   - WAIT for completion before proceeding

6. Create test node (if MCP available) OR provide manual instructions
   - If MCP: Create test node programmatically
   - If manual: Provide step-by-step instructions for:
     * Adding paragraph field to content type
     * Creating test node
     * Adding paragraph instance
     * Publishing and viewing

7. Spawn browser-validator-specialist agent
   - Pass test URL (or instructions for manual URL)
   - Request responsive testing (320px, 768px, 1024px+)
   - Request accessibility validation (WCAG AA)
   - Request detailed technical report
   - WAIT for completion

8. Report detailed results
   - Configuration method (MCP or manual)
   - File paths with line counts
   - Manual instructions (if applicable)
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
- ✅ Generate Drupal paragraph type YAML configuration
- ✅ Generate field definitions and entity view modes
- ✅ Generate Twig templates
- ✅ Generate responsive CSS/SCSS
- ✅ Create test nodes for validation (if Drupal MCP available)

**Not allowed:**
- ❌ Do not enable modules or import config (provide manual instructions if Drupal MCP unavailable)
- ❌ Do not modify existing paragraph types
- ❌ Do not commit or push changes

The design-specialist orchestrates all operations sequentially (analysis → config → template → styling → validation).

---

## How It Works

This command spawns the **design-specialist** agent with Drupal focus. The agent orchestrates the complete workflow with **optional Drupal MCP** support:

1. **Analyzes design** using the design-analyzer skill to extract field requirements
2. **Creates paragraph type**:
   - **Via Drupal MCP** (if available) - automated creation
   - **Via YAML files** (fallback) - manual import required
3. **Generates Twig template** and module structure
4. **Spawns responsive-styling-specialist** for mobile-first CSS/SCSS (waits for completion)
5. **Creates test node** or provides manual instructions
6. **Spawns browser-validator-specialist** for comprehensive testing (waits for completion)
7. **Reports detailed results** with file paths and next steps

**Drupal MCP is optional** - if not available, detailed manual configuration instructions are provided.

## When to Use

**Use this command (`/design-to-paragraph`)** when:
- ✅ You have a Figma design or screenshot to convert
- ✅ You want a Drupal paragraph type (not a custom block or node type)
- ✅ You need responsive, accessible, production-ready code
- ✅ You're okay with manual configuration if Drupal MCP unavailable

**Design source can be**:
- Figma URL: `https://figma.com/file/XYZ789?node-id=5:67`
- Screenshot path: `./mockups/slideshow.png`
- Relative path: `../designs/gallery.jpg`

## Example Usage

```bash
# From Figma URL with custom module
/design-to-paragraph https://figma.com/file/XYZ789 slideshow custom_slideshow

# From screenshot in current directory
/design-to-paragraph mockup.png image_gallery

# Minimal (uses default module name 'custom_paragraphs')
/design-to-paragraph design.png testimonial

# From absolute path
/design-to-paragraph /path/to/designs/feature.png feature_section my_module
```

## What Gets Created

### Output Depends on Drupal MCP Availability

#### If Drupal MCP Available ✅

**1. Paragraph Type** (created via MCP)
- Machine name: `{paragraph_name}`
- Label: Auto-generated from design
- Fields: Configured automatically
- Status: Active and ready to use

**2. Twig Template**
- Path: `modules/custom/{module}/templates/paragraph--{paragraph_name}.html.twig`
- Semantic HTML structure
- Drupal template variables
- BEM-style CSS classes

**3. Responsive Stylesheet**
- Path: `modules/custom/{module}/scss/_{paragraph_name}.scss`
- Mobile-first SCSS
- Drupal paragraph classes
- WCAG AA compliant

**4. Test Node** (created via MCP)
- Content type: Page (or specified type)
- Paragraph instance added
- Published and ready to view

**5. Validation Report**
- Comprehensive testing results
- Screenshots at all breakpoints
- Accessibility findings
- Recommendations

#### If Drupal MCP NOT Available ⚠️

**1. YAML Configuration Files**

`paragraphs.paragraph_type.{paragraph_name}.yml`:
```yaml
langcode: en
status: true
dependencies: {  }
id: slideshow
label: 'Slideshow'
icon_uuid: null
icon_default: null
description: 'Image slideshow with captions'
behavior_plugins: {  }
```

`field.storage.paragraph.field_images.yml`:
```yaml
langcode: en
status: true
dependencies:
  module:
    - paragraphs
    - media
id: paragraph.field_images
field_name: field_images
entity_type: paragraph
type: entity_reference
settings:
  target_type: media
module: core
locked: false
cardinality: -1
translatable: true
```

`field.field.paragraph.slideshow.field_images.yml`:
```yaml
langcode: en
status: true
dependencies:
  config:
    - field.storage.paragraph.field_images
    - paragraphs.paragraphs_type.slideshow
    - media.type.image
id: paragraph.slideshow.field_images
field_name: field_images
entity_type: paragraph
bundle: slideshow
label: 'Images'
description: 'Upload slideshow images'
required: true
translatable: true
```

All saved to: `modules/custom/{module}/config/install/`

**2. Module Info File**

`{module}.info.yml`:
```yaml
name: 'Custom Slideshow'
type: module
description: 'Slideshow paragraph type from design-to-code'
core_version_requirement: ^9 || ^10
dependencies:
  - paragraphs:paragraphs
  - media:media
```

**3. Twig Template** (same as MCP version)

**4. Responsive Stylesheet** (same as MCP version)

**5. Detailed Manual Instructions** (see below)

**6. Validation Instructions** (manual test node creation required first)

### Manual Import Instructions (When Drupal MCP Unavailable)

The design-specialist provides these detailed steps:

```markdown
⚠️  **Drupal MCP not detected - manual configuration required**

## Files Generated

✅ Configuration files created:
- modules/custom/custom_slideshow/config/install/paragraphs.paragraph_type.slideshow.yml
- modules/custom/custom_slideshow/config/install/field.storage.paragraph.field_images.yml
- modules/custom/custom_slideshow/config/install/field.field.paragraph.slideshow.field_images.yml
- modules/custom/custom_slideshow/config/install/field.storage.paragraph.field_caption.yml
- modules/custom/custom_slideshow/config/install/field.field.paragraph.slideshow.field_caption.yml

✅ Template and styles:
- modules/custom/custom_slideshow/templates/paragraph--slideshow.html.twig
- modules/custom/custom_slideshow/scss/_slideshow.scss

✅ Module info:
- modules/custom/custom_slideshow/custom_slideshow.info.yml

## Step-by-Step Installation

### 1. Copy Files to Drupal Site

```bash
# Navigate to your Drupal root
cd /path/to/drupal

# Copy the entire module directory
cp -r modules/custom/custom_slideshow/* web/modules/custom/custom_slideshow/

# Or if files generated elsewhere:
cp -r /path/to/generated/custom_slideshow/* web/modules/custom/custom_slideshow/
```

### 2. Enable the Module

```bash
# Using Drush
drush en custom_slideshow -y

# Or via UI: /admin/modules
# Check "Custom Slideshow" and click "Install"
```

**Verify module enabled**:
```bash
drush pml | grep custom_slideshow
```

Expected output: `Enabled    custom_slideshow`

### 3. Import Configuration

```bash
# Import configuration from module's config/install directory
drush config:import --partial --source=modules/custom/custom_slideshow/config/install

# Alternative command (if above fails):
drush cim --partial --source=modules/custom/custom_slideshow/config/install
```

**Troubleshooting import issues**:
```bash
# If you get "configuration already exists" errors:
drush config:delete paragraphs.paragraphs_type.slideshow
drush config:delete field.storage.paragraph.field_images
# Then retry import
```

### 4. Clear Cache

```bash
drush cr

# Or via UI: /admin/config/development/performance → "Clear all caches"
```

### 5. Verify Paragraph Type

```bash
# Check if paragraph type exists
drush cget paragraphs.paragraphs_type.slideshow

# List all paragraph types
drush cget --include-overridden paragraphs.paragraphs_type
```

**Via UI**: Visit `/admin/structure/paragraphs_type`

Expected: "Slideshow" paragraph type appears in list

### 6. Add Paragraph Field to Content Type

The paragraph type is created but not yet attached to any content type.

**Via Drush**:
```bash
# Add paragraph field to 'page' content type
drush field:create node.page \
  --field-name=field_paragraphs \
  --field-type=entity_reference_revisions \
  --target-type=paragraph \
  --cardinality=-1
```

**Via UI**:
1. Visit: `/admin/structure/types/manage/page/fields`
2. Click "Add field"
3. Field type: "Entity reference revisions"
4. Label: "Paragraphs" (or your preference)
5. Target type: "Paragraph"
6. Allowed paragraph types: Check "Slideshow"
7. Save

### 7. Create Test Node

**Via UI**:
1. Visit: `/node/add/page`
2. Title: "Test: Slideshow"
3. Click "Add Slideshow" (in paragraphs field)
4. Upload images to "Images" field
5. Add caption text
6. Save and publish

**Note the node ID** from URL (e.g., `/node/123`)

### 8. Compile SCSS (if applicable)

```bash
# If your theme uses SCSS compilation
cd web/themes/custom/your_theme
npm run build

# Or import in your main SCSS file:
@import '../../../modules/custom/custom_slideshow/scss/slideshow';
```

### 9. Run Validation

Once test node is created, validate with:

```bash
/design-validate http://yoursite.ddev.site/node/123
```

## Expected Outcome

✅ Paragraph type "slideshow" available at: `/admin/structure/paragraphs_type`
✅ Fields configured:
   - field_images (Entity reference - Media, unlimited)
   - field_caption (Text - plain, single)
✅ Can be added to content types via "Entity reference revisions" field
✅ Twig template renders paragraph instances
✅ Styles applied when SCSS compiled

## Troubleshooting

**Error: "Module already enabled"**
- Solution: Module exists, proceed to step 3 (import configuration)

**Error: "Configuration entity already exists"**
- Solution: Delete existing config first:
  ```bash
  drush config:delete paragraphs.paragraphs_type.slideshow
  drush cim --partial --source=modules/custom/custom_slideshow/config/install
  ```

**Error: "The media module is required"**
- Solution: Enable media module:
  ```bash
  drush en media -y
  ```

**Paragraph type not appearing**
- Check: Module enabled (`drush pml | grep custom_slideshow`)
- Check: Config imported (`drush cget paragraphs.paragraphs_type.slideshow`)
- Try: Clear cache (`drush cr`)
- Try: Rebuild cache and registry (`drush cr && drush cache:rebuild`)

**Styles not applying**
- Check: SCSS compiled to CSS
- Check: CSS file included in theme
- Try: Clear Drupal cache
- Try: Hard refresh browser (Ctrl+Shift+R)
```

## Output Example

### With Drupal MCP (Automated)

```
✅ Drupal Paragraph Type Created: Slideshow

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Configuration (via Drupal MCP)

✅ Paragraph type 'slideshow' created successfully
✅ Fields configured:
   - field_images (Entity reference - Media, unlimited)
   - field_caption (Text - plain, single)
   - field_autoplay (Boolean, single)
✅ Cache cleared

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Files Created

1. **Twig Template**
   - Path: modules/custom/custom_slideshow/templates/paragraph--slideshow.html.twig
   - Lines: 89

2. **Responsive Stylesheet**
   - Path: modules/custom/custom_slideshow/scss/_slideshow.scss
   - Lines: 198
   - WCAG AA: ✅ All text meets minimum contrast

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Test Node

URL: http://site.ddev.site/node/123
Status: Published
Paragraph instance: Slideshow added with test content

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Validation Results

✅ 14 passed • ⚠️ 1 warning • ❌ 0 failed

[Detailed validation report...]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Next Steps

1. Review test node: http://site.ddev.site/node/123
2. Add paragraph type to production content types
3. Compile SCSS if needed
4. Use in content: /node/add/page → Add Slideshow paragraph
```

### Without Drupal MCP (Manual)

```
✅ Drupal Paragraph Type Files Generated: Slideshow

⚠️  **Drupal MCP not available - manual import required**

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Generated Files

**Configuration** (YAML):
- modules/custom/custom_slideshow/config/install/paragraphs.paragraph_type.slideshow.yml
- modules/custom/custom_slideshow/config/install/field.storage.paragraph.field_images.yml
- modules/custom/custom_slideshow/config/install/field.field.paragraph.slideshow.field_images.yml
- modules/custom/custom_slideshow/config/install/field.storage.paragraph.field_caption.yml
- modules/custom/custom_slideshow/config/install/field.field.paragraph.slideshow.field_caption.yml
- modules/custom/custom_slideshow/custom_slideshow.info.yml

**Template & Styles**:
- modules/custom/custom_slideshow/templates/paragraph--slideshow.html.twig (89 lines)
- modules/custom/custom_slideshow/scss/_slideshow.scss (198 lines)

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Manual Import Required

**See detailed instructions above** for complete step-by-step guide.

**Quick start**:
1. Copy files to Drupal: `cp -r modules/custom/custom_slideshow/* /path/to/drupal/web/modules/custom/custom_slideshow/`
2. Enable module: `drush en custom_slideshow -y`
3. Import config: `drush config:import --partial --source=modules/custom/custom_slideshow/config/install`
4. Clear cache: `drush cr`
5. Verify: Visit /admin/structure/paragraphs_type

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
## Next Steps

1. **Follow manual import instructions above** (steps 1-9)
2. Create test node with slideshow paragraph
3. Run validation: `/design-validate http://site.ddev.site/node/[NODE_ID]`
4. Review validation results and apply fixes
5. Add paragraph type to production content types
```

## Integration with Existing Workflows

### Kanopi Projects (with DDEV)
```bash
# After paragraph creation
ddev drush en custom_slideshow -y
ddev drush cim --partial --source=modules/custom/custom_slideshow/config/install
ddev drush cr

# Compile styles if needed
ddev theme-build

# Run accessibility audit
ddev pa11y http://site.ddev.site/node/123
```

### Non-Kanopi Projects
```bash
# Standard Drush commands
drush en custom_slideshow -y
drush cim --partial --source=modules/custom/custom_slideshow/config/install
drush cr
```

## Troubleshooting

### Error: "Drupal MCP connection failed"
**Impact**: Falls back to YAML generation automatically. No action needed.

**To enable MCP**: Install and configure Drupal MCP server for future use.

### Error: "Paragraph module not found"
**Solution**: Enable paragraphs module first:
```bash
composer require 'drupal/paragraphs:^1.15'
drush en paragraphs -y
```

### Error: "Media module not found"
**Solution**: Enable media module (Drupal core):
```bash
drush en media -y
```

### Configuration import fails
**Common causes**:
- Configuration already exists (delete first)
- Dependencies not met (enable required modules)
- Invalid YAML syntax (check generated files)

**Debug**:
```bash
# Check configuration status
drush config:status

# Validate YAML syntax
drush config:inspect paragraphs.paragraphs_type.slideshow

# View detailed error messages
drush cim --partial --source=modules/custom/custom_slideshow/config/install --verbose
```

## Related Commands

- `/design-to-block` - Create WordPress block pattern from design
- `/design-validate` - Validate existing implementation
- `/audit-a11y` - Comprehensive accessibility audit
- `/pr-review` - Review code before committing

---

**For complete technical workflow details**, see:
→ [`agents/design-specialist/AGENT.md`](../agents/design-specialist/AGENT.md)
→ [`skills/design-analyzer/SKILL.md`](../skills/design-analyzer/SKILL.md)
→ [`skills/responsive-styling/SKILL.md`](../skills/responsive-styling/SKILL.md)
→ [`skills/browser-validator/SKILL.md`](../skills/browser-validator/SKILL.md)
