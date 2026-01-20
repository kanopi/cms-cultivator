# Markdown Style Guide for Zensical

This guide documents the markdown patterns that render correctly in Zensical (our static site generator). Following these patterns ensures proper rendering and visual hierarchy.

---

## The Problem

Some common markdown patterns that work in basic renderers cause rendering issues in Zensical:

### ❌ Nested Lists with Bold Items

**Don't do this:**

```markdown
**What gets analyzed:**

1. **Colors**
   - Brand colors (primary, secondary, accent)
   - Text colors
   - Background colors

2. **Typography**
   - Font families
   - Font sizes
```

**Problem:** Zensical flattens this into a single numbered sequence, losing the hierarchy.

**Renders as:**
```
1. Colors
2. Brand colors (primary, secondary, accent)
3. Text colors
4. Background colors
5. Typography
6. Font families
7. Font sizes
```

### ❌ Inline Bold Followed by Lists

**Don't do this:**

```markdown
**Natural Language (Agent Skills auto-activate):**
- "I need to commit my changes" → Generates commit message
- "Is this button accessible?" → Checks accessibility
```

**Problem:** The bold text and list run together as one long paragraph.

---

## The Solution

Use proper heading hierarchy instead of bold text in lists.

### ✅ Use Headings for Categories

**Do this instead:**

```markdown
**What gets analyzed:**

### Colors

- Brand colors (primary, secondary, accent)
- Text colors
- Background colors

### Typography

- Font families
- Font sizes
```

**Why it works:** Headings create proper semantic structure that Zensical respects.

### ✅ Use Headings for Inline Sections

**Do this instead:**

```markdown
#### Natural Language (Agent Skills auto-activate)

- "I need to commit my changes" → Generates commit message
- "Is this button accessible?" → Checks accessibility
```

**Why it works:** The heading separates the title from the list content.

---

## Heading Hierarchy Rules

### Level Selection

Choose heading levels based on document structure:

**For top-level categories (under `##`):**
```markdown
## Main Section

### Category 1
- Item A
- Item B

### Category 2
- Item C
- Item D
```

**For nested sections (under `###`):**
```markdown
### Main Category

#### Subcategory 1
- Item A
- Item B

#### Subcategory 2
- Item C
- Item D
```

**For step-by-step instructions:**
```markdown
### Adding a New Feature

#### 1. Create the file

```bash
touch newfile.md
```

#### 2. Add content

- Write documentation
- Add examples
- Test thoroughly
```

### Heading Level Guidelines

- `#` - Document title (used once at the top)
- `##` - Major sections (Overview, Installation, Usage, etc.)
- `###` - Subsections within major sections
- `####` - Categories, steps, or sub-subsections
- `#####` - Rarely needed, only for deeply nested content

---

## When to Use Which Pattern

### Use Bullet Lists When

- All items are equal in hierarchy
- Items are short and don't need sub-bullets
- You're listing simple features or options

**Example:**
```markdown
### Available Commands

- `/pr-create` - Create pull request
- `/audit-a11y` - Check accessibility
- `/audit-perf` - Analyze performance
```

### Use Headings When

- Items have sub-bullets or nested content
- Items need longer explanations
- You want clear visual separation
- Items are steps in a process

**Example:**
```markdown
### Installation Steps

#### 1. Install prerequisites

Install required dependencies:

```bash
npm install
```

#### 2. Configure settings

Edit your configuration file:

- Set API keys
- Configure endpoints
- Enable features
```

### Numbered Lists Are OK For

- Short, sequential steps without sub-content
- Simple procedures with no explanations

**Example:**
```markdown
### Quick Setup

1. Clone the repository
2. Run `npm install`
3. Start the server with `npm start`
```

---

## Conversion Examples

### Example 1: Analysis Categories

**Before (❌):**
```markdown
**What it validates:**

1. **Responsive Behavior**
   - Mobile (320px width)
   - Tablet (768px width)
   - Desktop (1024px+ width)

2. **Accessibility (WCAG AA)**
   - Color contrast
   - Keyboard navigation
   - ARIA usage
```

**After (✅):**
```markdown
**What it validates:**

### Responsive Behavior

- Mobile (320px width)
- Tablet (768px width)
- Desktop (1024px+ width)

### Accessibility (WCAG AA)

- Color contrast
- Keyboard navigation
- ARIA usage
```

### Example 2: Role-Based Sections

**Before (❌):**
```markdown
### For Developers

**Natural Language:**
- "I need to commit" → Generates message
- "Is this accessible?" → Checks a11y

**Explicit Commands:**
- `/pr-create` - Create PR
- `/audit-a11y` - Full audit
```

**After (✅):**
```markdown
### For Developers

#### Natural Language

- "I need to commit" → Generates message
- "Is this accessible?" → Checks a11y

#### Explicit Commands

- `/pr-create` - Create PR
- `/audit-a11y` - Full audit
```

### Example 3: Step-by-Step Instructions

**Before (❌):**
```markdown
### Adding a New Command

1. **Create command file** in `/commands/`:
   ```bash
   touch commands/new-command.md
   ```

2. **Add frontmatter** at the top:
   ```yaml
   ---
   description: Command description
   ---
   ```

3. **Write documentation**:
   - Clear usage instructions
   - Example outputs
   - Platform considerations
```

**After (✅):**
```markdown
### Adding a New Command

#### 1. Create command file in `/commands/`

```bash
touch commands/new-command.md
```

#### 2. Add frontmatter at the top

```yaml
---
description: Command description
---
```

#### 3. Write documentation

- Clear usage instructions
- Example outputs
- Platform considerations
```

---

## Bold Text Usage

### Use Bold For

**Emphasis within sentences:**
```markdown
This command requires **Git** and **GitHub CLI** to function.
```

**Labels in lists:**
```markdown
- **Before PR**: `/pr-review self` - Self-review your changes
- **Creating PR**: `/pr-create` - Generate and create PR
```

**Definition terms:**
```markdown
- **Drupal**: Configuration changes, database updates
- **WordPress**: Theme changes, plugin dependencies
```

### Don't Use Bold For

**Section headings** (use actual headings):
```markdown
❌ **Installation Steps:**
✅ ### Installation Steps
```

**Category labels in lists** (use headings):
```markdown
❌ 1. **Colors**
   - Brand colors
✅ ### Colors
   - Brand colors
```

---

## Code Block Formatting

### Always Specify Language

**Do this:**
````markdown
```bash
npm install
```

```yaml
---
title: Example
---
```

```php
<?php
function example() {
  return true;
}
?>
```
````

**Not this:**
````markdown
```
npm install
```
````

### Add Context Before Code

**Good:**
```markdown
Install dependencies:

```bash
npm install
```
```

**Better:**
```markdown
#### 1. Install dependencies

```bash
npm install
```
```

---

## Links and References

### Internal Links

Use relative paths from the docs root:

```markdown
See [Installation Guide](../installation.md) for setup.
See [Commands Overview](../commands/overview.md) for all commands.
```

### Section Links

```markdown
Jump to [Accessibility Compliance](#accessibility-compliance) below.
```

### External Links

```markdown
Learn more about [Conventional Commits](https://www.conventionalcommits.org/).
```

---

## Admonitions

Zensical supports Material for MkDocs-style admonitions:

```markdown
!!! note
    This is a note admonition.

!!! warning
    This is a warning admonition.

!!! tip
    This is a tip admonition.

!!! danger
    This is a danger admonition.
```

Use them for important callouts, not for general content structure.

---

## Tables

Keep tables simple:

```markdown
| Command | Description |
|---------|-------------|
| `/pr-create` | Create pull request |
| `/audit-a11y` | Check accessibility |
```

For complex content, use headings and lists instead of tables.

---

## Checklist for New Documentation

Before committing documentation, verify:

- [ ] No numbered lists with bold items and sub-bullets
- [ ] No inline bold text followed by lists (use headings)
- [ ] Heading hierarchy is logical (# → ## → ### → ####)
- [ ] Code blocks specify language
- [ ] Internal links use relative paths
- [ ] No excessive nesting (max 4 heading levels)
- [ ] Bold used for emphasis, not structure
- [ ] Admonitions used sparingly
- [ ] Build succeeds: `zensical build --clean`

---

## Testing Your Changes

Always test locally before committing:

```bash
# Preview with hot reload
zensical serve

# Build and check for errors
zensical build --clean
```

The `--clean` flag catches:
- Broken internal links
- Invalid markdown syntax
- Missing referenced files
- Heading hierarchy issues

---

## Related Documentation

- [Contributing Guide](../contributing.md) - General contribution guidelines
- [Documentation Generation](../commands/documentation.md) - Using `/docs-generate`
- [Zensical Documentation](https://zensical.org/) - Official Zensical docs
