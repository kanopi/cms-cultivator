---
name: design-to-drupal-paragraph
description: Create Drupal paragraph types from Figma designs or screenshots using the design-specialist agent. Auto-activates when user provides a design reference and asks to create a Drupal paragraph type, content component, or layout section. Invoke when user says "create a Drupal paragraph from this design", "convert this mockup to a paragraph type", or provides a design with Drupal context.
---

# Design to Drupal Paragraph

Create production-ready Drupal paragraph types from Figma designs or screenshots using the design-specialist agent.

## Usage

- "Create a Drupal paragraph type from this design: [screenshot path]"
- "Build a slideshow paragraph from this Figma: [URL]"
- "Convert this mockup to a Drupal paragraph type called testimonial"

**Arguments**: `[design-source] [paragraph-name] [module-name]`

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() is unavailable:

1. **Analyze design** — If screenshot provided, use Read to view image and extract:
   - Colors, typography, spacing, layout structure
   - Content areas → map to Drupal field types
2. **Generate configuration files** directly using Write:
   - `paragraphs.paragraph_type.{paragraph_name}.yml`
   - `field.storage.paragraph.field_*.yml` (per field)
   - `field.field.paragraph.{paragraph_name}.field_*.yml` (per field)
   - All saved to `modules/custom/{module}/config/install/`
3. **Generate Twig template** — `modules/custom/{module}/templates/paragraph--{paragraph_name}.html.twig`
   - Semantic HTML with BEM classes
   - Proper Drupal template variables
   - Accessibility attributes
4. **Generate SCSS** — `modules/custom/{module}/scss/_{paragraph_name}.scss`
   - Mobile-first (base → 768px → 1024px)
   - Drupal class: `.paragraph--type--{paragraph_name}` as root
   - WCAG AA compliant
5. **Provide manual import instructions** — Step-by-step Drush commands

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() available:

**Step 2: Spawn design-specialist for code generation**:

```
Agent(subagent_type="cms-cultivator:design-specialist:design-specialist",
      prompt="Create a Drupal paragraph type from the provided design.

## Design Reference
{design source - Figma URL or screenshot path}

## Paragraph Details
- Paragraph name: {paragraph-name} (machine name: lowercase, underscores)
- Module: {module-name or 'custom_paragraphs'}

## Process
1. Analyze design using design-analyzer skill
   - Extract colors, typography, spacing, layout
   - Map to Drupal field types
2. Check Drupal MCP availability
   - If available: create paragraph type via MCP
   - If not: generate YAML configuration files
3. Generate Twig template (semantic HTML, BEM classes)
4. Create test node (if MCP available) or provide manual instructions

## Output Required
Return the structured report including:
- YAML and template file paths
- SCSS path section (component name, root class, file path)
- Design specifications section (colors, typography, spacing)
- Test node URL (or instructions) and screenshots directory")
```

**Step 3: Spawn responsive-styling-specialist** using the SCSS path and design specs from Step 2 output:

```
Agent(subagent_type="cms-cultivator:responsive-styling-specialist:responsive-styling-specialist",
      prompt="Generate mobile-first responsive SCSS for the {paragraph_name} Drupal paragraph.

Component: {component from design-specialist output}
Root class: {root class from design-specialist output}
File path: {SCSS file path from design-specialist output}

Design specifications:
{colors, typography, spacing from design-specialist output}

Requirements:
- Mobile-first (base → 768px → 1024px)
- WCAG AA color contrast (4.5:1 normal text, 3:1 large text)
- Touch-friendly targets (44px minimum)
- Proper focus indicators (2px outline)
- Reduced motion support
- Use root class as BEM parent")
```

**Step 4: Spawn browser-validator-specialist** using the test node URL from Step 2 output:

```
Agent(subagent_type="cms-cultivator:browser-validator-specialist:browser-validator-specialist",
      prompt="Validate the Drupal paragraph type implementation.

Test URL: {test node URL from design-specialist output, or skip if manual creation required}
Design reference: {original design source}

Validation requirements:
- Test responsive breakpoints: 320px, 768px, 1024px+
- Capture screenshots at each breakpoint
- Check WCAG AA accessibility
- Validate interactions
- Check JavaScript console
- Compare with original design
- Generate detailed technical report

Save screenshots to: {screenshots dir from design-specialist output}")
```

**Step 5: Report** — present the paragraph type file paths, SCSS path, and browser validation results to the user.

## Field Types

| Design Element | Drupal Field Type |
|----------------|-------------------|
| Short text, headings | Text (plain) |
| Body content, descriptions | Text (formatted, long) |
| CTAs, buttons, URLs | Link |
| Images, videos | Entity reference (Media) |
| Toggle features | Boolean |
| Select dropdowns | List (text) |
| Categories, tags | Entity reference (Taxonomy) |

## What Gets Created

### With Drupal MCP (Automated)
- Paragraph type created via MCP API
- Fields configured automatically
- Test node created
- YAML config files generated as reference

### Without Drupal MCP (Manual)
- YAML configuration files in `modules/custom/{module}/config/install/`
- Module info file `{module}.info.yml`
- Twig template
- SCSS stylesheet
- Detailed step-by-step import instructions

### Manual Import Instructions
```bash
# Enable module
drush en {module} -y

# Import configuration
drush config:import --partial --source=modules/custom/{module}/config/install

# Clear cache
drush cr

# Verify
drush cget paragraphs.paragraphs_type.{paragraph_name}
```

## Generated YAML Example

```yaml
# paragraphs.paragraph_type.slideshow.yml
langcode: en
status: true
id: slideshow
label: 'Slideshow'
description: 'Image slideshow with captions'
```

## Kanopi Projects

```bash
ddev drush en {module} -y
ddev drush cim --partial --source=modules/custom/{module}/config/install
ddev drush cr
ddev theme-build
```

## Related Skills

- **design-analyzer** — Extracts technical specs from designs
- **responsive-styling** — Generates mobile-first CSS/SCSS
- **browser-validator** — Validates implementation in browser
- **design-to-wp-block** — WordPress equivalent
