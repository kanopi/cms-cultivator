---
name: design-analyzer
description: Automatically extract technical requirements from design references when user mentions Figma, uploads images, or says "implement this design". Analyzes colors, typography, spacing, layout, and maps to WordPress blocks or Drupal paragraph fields. Provides detailed specifications for developers including exact values, responsive behavior, and accessibility requirements.
---

# Design Analyzer Skill

## Purpose
**Fetch and extract** technical requirements from design references (Figma URLs, screenshots, mockups) for CMS component implementation.

**CRITICAL FIRST STEP**: This skill MUST actively fetch design data using available tools (Figma MCP, Read tool) before performing any analysis. Never guess or infer design specifications - always fetch the actual design first.

## Philosophy

Accurate design-to-code translation requires systematic extraction of technical specifications.

### Core Beliefs

1. **Precision Over Interpretation**: Extract exact values, don't guess or estimate
2. **Accessibility from the Start**: Check contrast and touch targets during analysis
3. **Responsive by Default**: Design for mobile first, enhance for desktop
4. **Document Technical Decisions**: Record exact colors, spacing, typography for reproducibility

### Why Design Analysis Matters

- **Pixel-Perfect Implementation**: Faithful translation of designer intent
- **Consistent Experiences**: Same colors, spacing, typography across components
- **Accessibility Compliance**: Catch contrast and touch target issues early
- **Developer Efficiency**: Clear specs eliminate guesswork

## When This Skill Activates

This skill automatically activates when:
- User mentions **Figma URL** or Figma design
- User **uploads an image** file (.png, .jpg, .jpeg, .webp, .svg)
- User says phrases like:
  - "implement this design"
  - "create a component from this mockup"
  - "build this layout"
  - "convert this design to [WordPress/Drupal]"
- User asks to analyze visual design elements
- User references a "screenshot" or "wireframe"

## Decision Framework

Before analyzing a design, determine:

### What's the Design Source?

1. **Figma URL** → Extract artboard structure, exact values from design tokens
2. **Screenshot/Image** → Visual analysis, estimate values, measure ratios
3. **Wireframe** → Structure only, minimal styling details
4. **Partial mockup** → Analyze what's visible, note missing context

### What's the Target Platform?

**WordPress**:
- Map to **native blocks** (Group, Heading, Paragraph, Buttons, Image, Columns)
- Output: Block pattern PHP file + SCSS
- Focus: Block composition and responsive classes

**Drupal**:
- Map to **paragraph fields** (text, image, link, entity reference)
- Output: Paragraph type YAML + Twig + SCSS
- Focus: Field structure and view modes

### What Components Are Visible?

**Layout patterns**:
- Hero sections → Full-width container with content overlay
- Card grids → Repeating cards with consistent spacing
- Feature lists → Icon + heading + text patterns
- Navigation → Header with menu items

**Interactive elements**:
- Buttons → Identify all button states (default, hover, focus, active)
- Forms → Note input types, labels, validation states
- Links → Check text links vs. button styles

### What Technical Specs Are Needed?

**Always extract**:
- ✅ **Colors** - Hex values, opacity, contrast ratios
- ✅ **Typography** - Font families, sizes, weights, line heights
- ✅ **Spacing** - Margins, padding, gaps (in px or rem)
- ✅ **Layout** - Grid columns, flex direction, alignment

**Check for accessibility**:
- ✅ **Contrast ratios** - Calculate for all text (4.5:1 minimum)
- ✅ **Touch targets** - Verify buttons ≥ 44x44px on mobile
- ✅ **Focus indicators** - Note if visible focus states exist

### What Responsive Behavior?

**Analyze breakpoints**:
- **Mobile (< 768px)** - Stacked layout, larger touch targets
- **Tablet (768-1023px)** - Mixed layout, medium spacing
- **Desktop (1024px+)** - Full layout, smaller relative spacing

**Common responsive patterns**:
- Columns → Stack on mobile, side-by-side on desktop
- Font sizes → Smaller base on mobile, larger on desktop
- Images → Full width on mobile, constrained on desktop

### Decision Tree

```
User provides design reference
    ↓
Identify source type (Figma/image/wireframe)
    ↓
Determine target platform (WordPress/Drupal)
    ↓
Extract visual specs (colors/typography/spacing)
    ↓
Check accessibility (contrast/touch targets)
    ↓
Map to CMS components (blocks/paragraphs)
    ↓
Document responsive behavior
    ↓
Output structured technical spec
```

## Capabilities

### Design Input Fetching & Processing

**CRITICAL**: This skill actively FETCHES design data before analysis:

- **Figma URLs**:
  - ✅ Use Figma MCP to fetch design context and code
  - ✅ Use Figma MCP to capture screenshots
  - ✅ Extract exact values from Figma design tokens
  - ✅ Download image assets locally
  - Extract node IDs, artboard names, frame structure

- **Screenshots**:
  - ✅ Read image files using Read tool
  - Analyze visual hierarchy, layout patterns, UI components

- **Mockups**: Identify design system elements, spacing, typography
- **Wireframes**: Extract structure and content relationships

### Component Identification
- Recognize common patterns: heroes, CTAs, cards, galleries, slideshows
- Map sections to CMS components (WordPress blocks, Drupal paragraphs)
- Identify reusable patterns vs. unique implementations
- Detect interactive elements requiring JavaScript

### Technical Extraction
- **Colors**: Extract hex codes, identify primary/secondary/accent colors
- **Typography**: Font families, sizes, weights, line-heights
- **Spacing**: Margins, padding, gaps (in px, rem, or relative units)
- **Layout**: Grid systems, flexbox patterns, column structures
- **Breakpoints**: Responsive design requirements
- **Interactions**: Hover states, animations, transitions

## Analysis Process

### 0. Fetch Design Data (CRITICAL FIRST STEP)

**Before any analysis**, you MUST fetch the actual design data:

#### For Figma URLs:

**STEP 1: Load Figma MCP Tools**
```
Use ToolSearch to load Figma tools FIRST:
ToolSearch(query: "select:mcp__plugin_figma_figma__get_design_context")
ToolSearch(query: "select:mcp__plugin_figma_figma__get_screenshot")
```

**STEP 2: Parse Figma URL**
```
URL format: https://figma.com/design/{fileKey}?node-id={nodeId}
Example: https://figma.com/design/ABC123XYZ?node-id=16981-81661

Extract:
- fileKey: "ABC123XYZ"
- nodeId: "16981:81661" (IMPORTANT: Replace hyphen with colon!)
```

**STEP 3: Fetch Design Context**
```
Call Figma MCP to get design structure and code:
mcp__plugin_figma_figma__get_design_context(
  fileKey: {extracted fileKey},
  nodeId: {extracted nodeId with colon},
  clientLanguages: "html,css,scss",
  clientFrameworks: "wordpress" | "drupal"
)

Returns:
- React/Tailwind code (will need conversion to native WordPress/Drupal)
- Exact CSS values (colors, spacing, typography from Figma)
- Image asset URLs (valid for 7 days)
- Design token information
```

**STEP 4: Get Visual Screenshot**
```
Call Figma MCP to get visual reference:
mcp__plugin_figma_figma__get_screenshot(
  fileKey: {same fileKey},
  nodeId: {same nodeId with colon},
  clientLanguages: "html,css,scss",
  clientFrameworks: "wordpress" | "drupal"
)

Returns: Visual image for analysis
```

**STEP 5: Extract Design Specifications**

From the Figma data, extract:
- **Colors**: Exact hex codes from CSS values in code output
- **Typography**: Font families, sizes (px), weights, line-heights from code
- **Spacing**: Margins, padding, gaps from Tailwind classes or CSS
- **Layout**: Flexbox, grid, positioning from class names
- **Images**: Download URLs for all assets (imgVariable = "https://...")
- **Dimensions**: Width, height, border-radius values
- **Effects**: Shadows, gradients, opacity

**STEP 6: Download Image Assets Locally**
```bash
# Create directory for pattern/paragraph assets
mkdir -p {theme-path}/assets/images/patterns

# Download each image asset
cd {theme-path}/assets/images/patterns
curl -o {descriptive-filename}.png "{figma-asset-url}"
curl -o {descriptive-filename-2}.jpg "{figma-asset-url-2}"
```

Update code references to use local paths:
```
OLD: src="https://www.figma.com/api/mcp/asset/..."
NEW: src="<?php echo esc_url( get_template_directory_uri() . '/assets/images/patterns/{filename}.png' ); ?>"
```

#### For Screenshot/Image Files:

**STEP 1: Read Image File**
```
Use Read tool to load the image:
Read(file_path: {screenshot-path})
```

**STEP 2: Visual Analysis**

Analyze the image visually:
- Identify layout structure
- Estimate colors (use hex color picker if available)
- Measure relative spacing and proportions
- Identify typography styles
- Note component hierarchy

**DO NOT PROCEED** until you have:
- ✅ Fetched Figma design (if Figma URL) OR loaded screenshot
- ✅ Extracted exact design values (colors, typography, spacing)
- ✅ Downloaded all image assets to local paths
- ✅ Have visual reference for comparison

### 1. Initial Assessment

Ask clarifying questions:
```
What type of component is this?
- WordPress block pattern?
- Drupal paragraph type?
- Custom theme component?

What's the primary purpose?
- Hero section?
- Content display?
- Interactive element?
- Navigation?
```

### 2. Visual Hierarchy Analysis

Examine and document:
```
Layout Structure:
- Sections and their relationships
- Container widths (full-width, contained, etc.)
- Visual hierarchy (what's most prominent)

Content Elements:
- Headings (identify h1, h2, h3 levels)
- Body text and captions
- Images and media placement
- Buttons and CTAs
- Icons and decorative elements
```

### 3. Component Mapping

#### For WordPress:
```
Map to Core Blocks:
- Group: Container/wrapper
- Cover: Full-width sections with background images
- Heading: H1-H6 headings
- Paragraph: Body text
- Buttons/Button: CTAs
- Image: Individual images
- Gallery: Image collections
- Columns/Column: Multi-column layouts
- Spacer: Vertical spacing
- Separator: Dividers
```

#### For Drupal:
```
Map to Paragraph Fields:
- Text (plain): Short text fields
- Text (formatted, long): Body/description fields
- Link: CTA buttons, navigation
- Entity reference (Media): Images, videos
- Boolean: Toggle features
- List (text): Select options
- Entity reference (Taxonomy): Categories/tags
```

### 4. Responsive Behavior Planning

Determine how layout changes:
```
Mobile (320px-767px):
- Single column layouts
- Stacked elements
- Larger touch targets
- Simplified navigation

Tablet (768px-1023px):
- 2-column layouts where appropriate
- Adjusted typography
- Moderate spacing

Desktop (1024px+):
- Multi-column layouts
- Full typography scale
- Maximum spacing
- Hover states prominent
```

### 5. Styling Requirements

Extract specific values:
```
Colors:
  primary: #HEXCODE
  secondary: #HEXCODE
  text: #HEXCODE
  background: #HEXCODE

Typography:
  heading-1: [size]px / [line-height] / [weight]
  heading-2: [size]px / [line-height] / [weight]
  body: [size]px / [line-height] / [weight]

Spacing:
  section-padding: [value]
  element-margin: [value]
  gap: [value]
```

### 6. Accessibility Requirements

Identify needs:
```
Semantic Structure:
- Proper heading hierarchy
- Landmark regions
- Form labels
- Button text

ARIA Needs:
- Labels for icon-only buttons
- Descriptions for complex widgets
- Live regions for dynamic content
- Hidden content for screen readers

Contrast:
- Check all text against backgrounds
- Verify minimum 4.5:1 for body text
- Verify minimum 3:1 for large text/UI
```

### 7. Interactive Elements

Document behavior:
```
For each interactive element:
- What triggers it (click, hover, focus)
- What changes (visual, content, navigation)
- Animation/transition details
- Keyboard interaction requirements
- Accessible alternatives
```

## Output Format

When analysis is complete, provide structured output:

```yaml
component_analysis:
  type: "block_pattern" | "paragraph_type" | "theme_component"
  name: "descriptive-name"
  cms: "wordpress" | "drupal"

structure:
  sections:
    - name: "hero"
      elements:
        - type: "heading"
          level: "h1"
          content: "Main Heading Text"
        - type: "paragraph"
          content: "Supporting text"
        - type: "button"
          style: "primary"
          text: "Call to Action"

wordpress_blocks:
    - "core/cover"
    - "core/heading"
    - "core/paragraph"
    - "core/buttons"

drupal_fields:
    - name: "field_heading"
      type: "string"
      cardinality: 1
    - name: "field_body"
      type: "text_long"
      cardinality: 1
    - name: "field_cta"
      type: "link"
      cardinality: 1

styling:
  colors:
    primary: "#0073aa"
    secondary: "#23282d"
    text: "#1e1e1e"
    background: "#ffffff"

  typography:
    heading_1:
      mobile: "2rem / 1.2 / 700"
      tablet: "2.5rem / 1.2 / 700"
      desktop: "3rem / 1.2 / 700"
    body:
      mobile: "1rem / 1.6 / 400"
      tablet: "1.125rem / 1.6 / 400"
      desktop: "1.25rem / 1.6 / 400"

  spacing:
    section_padding:
      mobile: "2rem"
      tablet: "3rem"
      desktop: "4rem"
    element_gap: "1.5rem"

  layout:
    max_width: "1200px"
    columns:
      mobile: 1
      tablet: 2
      desktop: 3

responsive:
  breakpoints:
    mobile: "320px"
    tablet: "768px"
    desktop: "1024px"
  behavior:
    - "Stack columns on mobile"
    - "Reduce heading sizes"
    - "Adjust padding/margins"

interactions:
  - element: "CTA button"
    trigger: "hover"
    effect: "background color change"
    css: "transition: background-color 0.3s ease"
  - element: "Image"
    trigger: "click"
    effect: "Open lightbox"
    requires: "JavaScript"

accessibility:
  requirements:
    - "Heading hierarchy: h1 → h2"
    - "Alt text for hero image"
    - "Button has descriptive text"
    - "Color contrast: all text 4.5:1 or better"
    - "Focus indicators on interactive elements"

  concerns:
    - "Icon-only button needs aria-label"
    - "Decorative image should have empty alt"

implementation_notes:
  - "Use CSS Grid for desktop 3-column layout"
  - "Background image should be lazy-loaded"
  - "Consider reduced motion preferences"
  - "Test with keyboard navigation"
```

## Integration with Commands

This skill provides critical context for:

### `/design-to-block` Command
Provides:
- WordPress block selections
- Pattern structure
- Styling specifications
- Accessibility requirements

### `/design-to-paragraph` Command
Provides:
- Drupal field types and configuration
- Twig template structure
- CSS requirements
- Interactive behavior specs

### `/design-validate` Command
Provides:
- Design comparison reference
- Expected behavior documentation
- Accessibility requirements to check

## Example Activation

### Example 1: Figma URL

**User provides Figma URL:**
> "Create a WordPress block pattern from this Figma design: https://figma.com/design/ABC123?node-id=100-200"

**Skill Response:**
```
I'll fetch and analyze this Figma design for WordPress implementation.

[Step 1: Load Figma tools with ToolSearch]
[Step 2: Parse URL - fileKey: ABC123, nodeId: 100:200]
[Step 3: Call mcp__plugin_figma_figma__get_design_context]
[Step 4: Call mcp__plugin_figma_figma__get_screenshot]
[Step 5: Extract design specifications from Figma data]
[Step 6: Download image assets locally]

Design Analysis Complete:
- Type: Hero section with overlaid text
- Fetched from Figma: node-id=100:200
- WordPress Blocks Needed: Cover, Heading, Paragraph, Buttons
- Layout: Full-width (1200px max-width), centered content
- Colors (from Figma):
  - Background overlay: #000000 (40% opacity)
  - Text: #FFFFFF
  - Button: #0073AA
  - Button hover: #005A87
- Typography (from Figma):
  - Heading: Montserrat Bold, 48px/1.2, desktop → 32px mobile
  - Body: Inter Regular, 18px/1.6
- Spacing (from Figma):
  - Section padding: 120px vertical, 40px horizontal
  - Element gap: 24px
- Images (downloaded):
  - Hero background: /assets/images/patterns/hero-bg.jpg
- Responsive: Text scales down, padding reduces on mobile
- Accessibility:
  - Text contrast 7:1 (exceeds WCAG AA)
  - Need alt text for background image

Ready to generate the block pattern with exact Figma specifications.
```

### Example 2: Screenshot

**User uploads image and says:**
> "Create a WordPress block pattern from this hero design"

**Skill Response:**
```
I'll analyze this design for WordPress implementation.

[Step 1: Read image file]
[Step 2: Perform visual analysis]

Design Analysis Complete:
- Type: Hero section with overlaid text
- WordPress Blocks Needed: Cover, Heading, Paragraph, Buttons
- Layout: Full-width background image with centered content
- Colors (estimated from screenshot):
  - Dark overlay: ~#000000 (40% opacity)
  - Text: white
- Typography (estimated):
  - Heading: ~3rem on desktop, ~2rem mobile
  - Body: ~1.125rem
- Responsive: Text size reduces, padding adjusts
- Accessibility: Need alt text for background image, ensure text contrast

Note: Values estimated from screenshot. For exact specifications, provide Figma URL.

Ready to generate the block pattern. Shall I proceed?
```

## Best Practices

1. **ALWAYS Fetch Design Data First**: Never analyze without fetching actual design using Figma MCP or Read tool
2. **Use Exact Values from Figma**: When Figma URL provided, use exact px/rem values from Figma data, not estimates
3. **Download Assets Locally**: Never reference Figma CDN URLs in production code - download to theme/module
4. **Ask Before Assuming**: If design intent is unclear, ask the user
5. **Be Specific**: Provide exact values (px, rem, hex codes)
6. **Think Mobile-First**: Always consider mobile layout first
7. **Check Accessibility**: Flag potential issues early
8. **Document Interactions**: Don't overlook hover states and animations
9. **Map to Native Components**: Prefer platform-native solutions

## Common Patterns Recognition

Learn to quickly identify these patterns:

- **Hero**: Full-width section, background image, overlaid text, CTA
- **Card Grid**: Repeating items, image + text, equal heights
- **CTA Banner**: Contrasting background, centered text, prominent button
- **Testimonial**: Quote, author info, possibly image
- **Slideshow**: Multiple items, navigation arrows, pagination dots
- **Feature List**: Icons, headings, descriptions, grid/list layout
- **Team Grid**: Photos, names, titles, bio text

For each pattern, know the typical WordPress blocks or Drupal fields needed.
