---
name: responsive-styling
description: Automatically generate mobile-first responsive CSS/SCSS when creating component styles or mentioning responsive design. Implements standard breakpoints (768px, 1024px), ensures WCAG AA color contrast, creates touch-friendly interfaces (44px minimum targets), adds proper focus indicators, supports reduced motion, scales typography responsively, and provides detailed technical specifications with exact values.
---

# Responsive Styling Skill

## Purpose
Generate mobile-first, responsive CSS/SCSS that works across all devices and follows accessibility best practices.

## When This Skill Activates

This skill automatically activates when:
- User asks to "make it responsive"
- User mentions breakpoints, mobile, tablet, or desktop
- Creating styles for a component
- User asks about media queries
- Responsive design is needed for implementation

## Core Principles

### 1. Mobile-First Approach
Always write base styles for mobile, then enhance for larger screens:

```scss
// ✅ CORRECT: Mobile-first
.component {
  font-size: 1rem;        // Base mobile style
  padding: 1rem;

  @media (min-width: 768px) {
    font-size: 1.125rem;  // Enhance for tablet
    padding: 2rem;
  }

  @media (min-width: 1024px) {
    font-size: 1.25rem;   // Enhance for desktop
    padding: 3rem;
  }
}

// ❌ WRONG: Desktop-first
.component {
  font-size: 1.25rem;

  @media (max-width: 1024px) {
    font-size: 1.125rem;
  }

  @media (max-width: 768px) {
    font-size: 1rem;
  }
}
```

### 2. Standard Breakpoints

Use consistent breakpoints:

```scss
// Mobile: 320px - 767px (base styles, no media query)
// Tablet: 768px - 1023px
$breakpoint-tablet: 768px;

// Desktop: 1024px+
$breakpoint-desktop: 1024px;

// Optional additional breakpoints
$breakpoint-mobile-large: 480px;
$breakpoint-tablet-large: 960px;
$breakpoint-desktop-large: 1280px;
```

### 3. Responsive Typography

Scale typography appropriately:

```scss
.heading-1 {
  // Mobile base
  font-size: 2rem;        // 32px
  line-height: 1.2;
  font-weight: 700;
  margin-bottom: 1rem;

  // Tablet
  @media (min-width: 768px) {
    font-size: 2.5rem;    // 40px
    margin-bottom: 1.5rem;
  }

  // Desktop
  @media (min-width: 1024px) {
    font-size: 3rem;      // 48px
    margin-bottom: 2rem;
  }
}

.body-text {
  // Mobile base
  font-size: 1rem;        // 16px
  line-height: 1.6;

  // Tablet
  @media (min-width: 768px) {
    font-size: 1.125rem;  // 18px
    line-height: 1.7;
  }

  // Desktop
  @media (min-width: 1024px) {
    font-size: 1.25rem;   // 20px
    line-height: 1.8;
  }
}
```

### 4. Responsive Spacing

Use fluid spacing that scales:

```scss
// Method 1: Stepped spacing
.section {
  // Mobile
  padding: 2rem 1rem;
  margin-bottom: 2rem;

  // Tablet
  @media (min-width: 768px) {
    padding: 3rem 2rem;
    margin-bottom: 3rem;
  }

  // Desktop
  @media (min-width: 1024px) {
    padding: 4rem 3rem;
    margin-bottom: 4rem;
  }
}

// Method 2: Fluid spacing with clamp
.section-fluid {
  // Scales smoothly between mobile and desktop
  padding: clamp(2rem, 5vw, 4rem) clamp(1rem, 3vw, 3rem);
  margin-bottom: clamp(2rem, 4vw, 4rem);
}
```

### 5. Responsive Layouts

#### Stacked to Columns
```scss
.card-grid {
  display: grid;
  gap: 1.5rem;

  // Mobile: single column
  grid-template-columns: 1fr;

  // Tablet: 2 columns
  @media (min-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
    gap: 2rem;
  }

  // Desktop: 3 columns
  @media (min-width: 1024px) {
    grid-template-columns: repeat(3, 1fr);
    gap: 3rem;
  }
}
```

#### Flexbox Responsive
```scss
.flex-container {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;

  // Mobile: stack vertically
  flex-direction: column;

  // Tablet and up: horizontal
  @media (min-width: 768px) {
    flex-direction: row;
    gap: 2rem;
  }

  .flex-item {
    // Mobile: full width
    flex: 1 1 100%;

    // Tablet: 2 items per row
    @media (min-width: 768px) {
      flex: 1 1 calc(50% - 1rem);
    }

    // Desktop: 3 items per row
    @media (min-width: 1024px) {
      flex: 1 1 calc(33.333% - 1.333rem);
    }
  }
}
```

## WordPress-Specific Patterns

### Full-Width Sections
```scss
// Handle WordPress core padding
.wp-block-cover {
  // Full viewport width accounting for theme padding
  width: calc(100vw - var(--wp--style--root--padding-left) - var(--wp--style--root--padding-right));
  max-width: none;

  // Center it
  margin-left: calc(-1 * var(--wp--style--root--padding-left));
  margin-right: calc(-1 * var(--wp--style--root--padding-right));
}
```

### Responsive Block Patterns
```scss
// Pattern wrapper
.wp-block-group.pattern-name {
  // Mobile
  padding: 2rem 1rem;

  // Inner content container
  .wp-block-group__inner-container {
    max-width: 100%;
    margin: 0 auto;

    // Tablet
    @media (min-width: 768px) {
      max-width: 750px;
    }

    // Desktop
    @media (min-width: 1024px) {
      max-width: 1200px;
    }
  }
}
```

## Drupal-Specific Patterns

### Paragraph Responsive Styles
```scss
.paragraph--type--name {
  // Mobile base
  padding: 2rem 1rem;

  // Inner container
  .paragraph__content {
    max-width: 100%;
    margin: 0 auto;

    @media (min-width: 768px) {
      padding: 3rem 2rem;
      max-width: 750px;
    }

    @media (min-width: 1024px) {
      padding: 4rem 3rem;
      max-width: 1200px;
    }
  }
}
```

### Field Responsive Display
```scss
.field--name-field-items {
  display: grid;
  gap: 1rem;

  // Mobile: stack
  grid-template-columns: 1fr;

  // Tablet: 2 up
  @media (min-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
    gap: 1.5rem;
  }

  // Desktop: 3 up
  @media (min-width: 1024px) {
    grid-template-columns: repeat(3, 1fr);
    gap: 2rem;
  }
}
```

## Responsive Images

### Basic Responsive Image
```scss
img {
  max-width: 100%;
  height: auto;
  display: block;
}
```

### Responsive Background Images
```scss
.hero-background {
  background-size: cover;
  background-position: center;
  min-height: 300px;

  @media (min-width: 768px) {
    min-height: 400px;
  }

  @media (min-width: 1024px) {
    min-height: 600px;
  }
}
```

### Art Direction
```scss
.responsive-image {
  // Mobile: portrait crop
  aspect-ratio: 4/5;
  object-fit: cover;

  // Tablet: square
  @media (min-width: 768px) {
    aspect-ratio: 1/1;
  }

  // Desktop: landscape
  @media (min-width: 1024px) {
    aspect-ratio: 16/9;
  }
}
```

## Touch-Friendly Design

### Minimum Touch Targets
```scss
button,
a,
input,
select {
  // Minimum 44x44px for touch
  min-height: 44px;
  min-width: 44px;

  // Larger on very small screens
  @media (max-width: 375px) {
    min-height: 48px;
    min-width: 48px;
  }
}
```

### Spacing for Touch
```scss
.touch-menu {
  li {
    // More spacing on mobile
    margin-bottom: 0.5rem;

    a {
      // Larger tap area
      padding: 0.75rem 1rem;
      display: block;
    }
  }

  // Less spacing needed on desktop with mouse
  @media (min-width: 1024px) {
    li {
      margin-bottom: 0.25rem;

      a {
        padding: 0.5rem 1rem;
      }
    }
  }
}
```

## Accessibility in Responsive Design

### Focus Indicators
```scss
a, button, input, select {
  &:focus {
    outline: 2px solid currentColor;
    outline-offset: 2px;
  }

  // More prominent on mobile
  @media (max-width: 767px) {
    &:focus {
      outline-width: 3px;
    }
  }
}
```

### Text Readability
```scss
.content {
  // Mobile: shorter line length
  max-width: 100%;

  // Desktop: optimal reading width
  @media (min-width: 768px) {
    max-width: 65ch; // ~65 characters per line
  }
}
```

### Reduced Motion
```scss
// Respect user's motion preferences
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Common Responsive Patterns

### Hide/Show Elements
```scss
// Show only on mobile
.mobile-only {
  display: block;

  @media (min-width: 768px) {
    display: none;
  }
}

// Hide on mobile
.desktop-only {
  display: none;

  @media (min-width: 768px) {
    display: block;
  }
}

// Tablet and up
.tablet-up {
  display: none;

  @media (min-width: 768px) {
    display: block;
  }
}
```

### Responsive Navigation
```scss
.main-nav {
  // Mobile: hamburger menu
  @media (max-width: 767px) {
    .menu-toggle {
      display: block;
    }

    .menu-items {
      display: none;

      &.is-open {
        display: block;
        position: fixed;
        top: 60px;
        left: 0;
        right: 0;
        background: white;
        padding: 1rem;
      }
    }
  }

  // Desktop: horizontal menu
  @media (min-width: 768px) {
    .menu-toggle {
      display: none;
    }

    .menu-items {
      display: flex;
      gap: 2rem;
    }
  }
}
```

### Responsive Typography System
```scss
// Define fluid typography
:root {
  // Scales from 16px to 20px
  --font-size-base: clamp(1rem, 0.9rem + 0.5vw, 1.25rem);

  // Scales from 32px to 48px
  --font-size-h1: clamp(2rem, 1.5rem + 2vw, 3rem);

  // Scales from 24px to 32px
  --font-size-h2: clamp(1.5rem, 1.25rem + 1vw, 2rem);

  // Scales from 20px to 24px
  --font-size-h3: clamp(1.25rem, 1.125rem + 0.5vw, 1.5rem);
}

body {
  font-size: var(--font-size-base);
}

h1 {
  font-size: var(--font-size-h1);
}

h2 {
  font-size: var(--font-size-h2);
}

h3 {
  font-size: var(--font-size-h3);
}
```

## Testing Checklist

When generating responsive styles, ensure:

- [ ] Mobile base styles defined first
- [ ] Breakpoints use min-width (mobile-first)
- [ ] Touch targets are 44px minimum
- [ ] Text is readable at all sizes
- [ ] Images scale properly
- [ ] Layouts don't break at any width
- [ ] Horizontal scrolling is prevented
- [ ] Focus indicators are visible
- [ ] Reduced motion is respected
- [ ] Content is accessible at 320px width
- [ ] Layout works up to 2560px width

## Output Format

When generating responsive styles, provide:

```scss
/* Component Name */

/* Mobile base styles (320px - 767px) */
.component {
  /* All base styles here */
}

/* Tablet (768px - 1023px) */
@media (min-width: 768px) {
  .component {
    /* Tablet enhancements */
  }
}

/* Desktop (1024px+) */
@media (min-width: 1024px) {
  .component {
    /* Desktop enhancements */
  }
}

/* Accessibility */
@media (prefers-reduced-motion: reduce) {
  /* Reduced motion styles */
}
```

## Common Mistakes to Avoid

❌ **Desktop-first** (using max-width)
❌ **Magic numbers** (random breakpoints)
❌ **Forgetting touch targets**
❌ **Fixed pixel widths** that don't scale
❌ **Tiny text on mobile** (<16px)
❌ **Horizontal scrolling**
❌ **Ignoring landscape mobile**
❌ **Breaking at intermediate sizes**

✅ **Mobile-first** (using min-width)
✅ **Consistent breakpoints**
✅ **44px minimum touch targets**
✅ **Flexible widths** with max-width
✅ **16px minimum text**
✅ **Contained content**
✅ **Test at 320px, 768px, 1024px**
✅ **Test at all widths**
