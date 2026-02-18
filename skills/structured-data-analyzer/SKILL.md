---
name: structured-data-analyzer
description: Automatically check and suggest structured data improvements when user mentions JSON-LD, Schema.org, structured data, rich results, SEO markup, or shows HTML/template code that could benefit from structured data. Performs focused checks on specific pages, templates, or code snippets. Invoke when user asks "does this have structured data?", "add JSON-LD", "Schema.org markup", "rich results", "SEO schema", or shows template code for content types like articles, events, products, or FAQs.
---

# Structured Data Analyzer

Automatically check and suggest structured data (JSON-LD / Schema.org) improvements.

## Structured Data Philosophy

Structured data helps search engines and AI systems understand your content, enabling rich results and better discoverability.

### Core Beliefs

1. **JSON-LD First**: Google's recommended format; skip RDFa and Microdata
2. **Content-Driven**: Only add markup that reflects actual page content
3. **Valid Over Present**: Broken JSON-LD is worse than no JSON-LD
4. **Entity Linking**: Use stable `@id` references for cross-page coherence

### Scope Balance

- **Quick checks** (this skill): Fast feedback on specific pages, templates, or JSON-LD snippets
- **Comprehensive audits** (`/audit-structured-data` command): Full site-wide structured data audit with scoring, entity graph design, and report generation
- **Rich Results testing**: Google's Rich Results Test tool for production validation

This skill provides rapid feedback during development. For full site coverage, use the comprehensive audit command.

## When to Use This Skill

Activate this skill when the user:
- Asks "does this page have structured data?"
- Asks "add JSON-LD" or "add Schema.org markup"
- Mentions "structured data", "rich results", or "SEO schema"
- Shows HTML that contains or should contain JSON-LD
- Shows template code (Twig, PHP, JSX) for content types
- Asks "what Schema.org type should I use?"
- Mentions specific types: Article, Event, Product, FAQ, HowTo, BreadcrumbList

## Decision Framework

Before suggesting structured data, assess:

### What Content Type Is This Page?

1. **Article/Blog** → Article, BlogPosting, or NewsArticle
2. **Event listing** → Event with location, dates, offers
3. **Product page** → Product with Offer, price, availability
4. **FAQ section** → FAQPage with Question/Answer pairs
5. **How-to guide** → HowTo with steps
6. **Team/About page** → Person, Organization, AboutPage
7. **Service page** → Service or ProfessionalService
8. **Contact page** → ContactPage, Organization with contactPoint
9. **Homepage** → Organization/LocalBusiness + WebSite
10. **Any inner page** → BreadcrumbList

### What Properties Are Required?

**Always check Google's requirements per type:**

| Type | Required | Recommended |
|------|----------|-------------|
| Article | headline, author, datePublished, image | dateModified, publisher, description |
| Event | name, startDate, location | endDate, image, offers, organizer |
| Product | name | image, offers (price, availability) |
| FAQ | mainEntity[].name, .acceptedAnswer | - |
| HowTo | name, step[].text | image, totalTime |
| BreadcrumbList | itemListElement[].name, .item | - |
| Organization | name, url | logo, sameAs, contactPoint |

### What Platform Is This?

**Drupal:**
- Use Schema.org Metatag module for field-mapped structured data
- Use Metatag module as base
- Manual JSON-LD via Twig `<script>` blocks for custom needs

**WordPress:**
- Yoast SEO or RankMath provide automatic Organization, WebSite, Article
- Schema Pro for additional types
- Manual JSON-LD via `wp_head` action hook

### Decision Tree

```
User shows page/template/code
    ↓
Identify page content type
    ↓
Determine applicable Schema.org type(s)
    ↓
Check for existing JSON-LD (if page URL provided)
    ↓
If missing: Suggest JSON-LD with required properties
If present: Validate required + recommended properties
    ↓
Suggest @id convention for entity reuse
```

## Best Practices

### DO:

- Always include `@context: "https://schema.org"`
- Use `@id` for entities referenced from multiple pages
- Include all required properties per Google's documentation
- Place JSON-LD in the `<head>` section
- Use `@graph` array for multiple entities on one page
- Match JSON-LD content to visible page content
- Use ISO 8601 for dates (e.g., `2026-02-17T10:00:00-05:00`)

### DON'T:

- Add structured data for content not visible on the page
- Use RDFa or Microdata when JSON-LD is an option
- Duplicate entities without stable `@id` references
- Leave required properties empty or with placeholder values
- Add multiple conflicting Organization blocks
- Use deprecated Schema.org types

## Quick Structured Data Checks

### 1. Article / BlogPosting

**Template without structured data:**
```php
// Drupal Twig template for a blog post
<article>
  <h1>{{ node.label }}</h1>
  <span>By {{ author_name }} on {{ date }}</span>
  <div>{{ content.body }}</div>
</article>
```

**Add JSON-LD:**
```json
{
  "@context": "https://schema.org",
  "@type": "Article",
  "@id": "/blog/post-slug/#article",
  "headline": "Post Title",
  "author": {
    "@type": "Person",
    "@id": "/team/author-name/#person",
    "name": "Author Name"
  },
  "datePublished": "2026-02-17",
  "dateModified": "2026-02-17",
  "image": "https://example.com/image.jpg",
  "publisher": {
    "@type": "Organization",
    "@id": "/#organization"
  }
}
```

### 2. Event

```json
{
  "@context": "https://schema.org",
  "@type": "Event",
  "@id": "/events/event-slug/#event",
  "name": "Event Title",
  "startDate": "2026-03-15T09:00:00-05:00",
  "endDate": "2026-03-15T17:00:00-05:00",
  "location": {
    "@type": "Place",
    "name": "Venue Name",
    "address": {
      "@type": "PostalAddress",
      "streetAddress": "123 Main St",
      "addressLocality": "City",
      "addressRegion": "ST",
      "postalCode": "12345"
    }
  },
  "organizer": {
    "@type": "Organization",
    "@id": "/#organization"
  },
  "description": "Event description",
  "image": "https://example.com/event-image.jpg"
}
```

### 3. FAQ Page

```json
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "What is your return policy?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "You can return items within 30 days."
      }
    },
    {
      "@type": "Question",
      "name": "How long does shipping take?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Standard shipping takes 3-5 business days."
      }
    }
  ]
}
```

### 4. Organization (Homepage)

```json
{
  "@context": "https://schema.org",
  "@type": "Organization",
  "@id": "/#organization",
  "name": "Company Name",
  "url": "https://example.com",
  "logo": "https://example.com/logo.png",
  "sameAs": [
    "https://twitter.com/company",
    "https://linkedin.com/company/company",
    "https://github.com/company"
  ],
  "contactPoint": {
    "@type": "ContactPoint",
    "telephone": "+1-555-555-5555",
    "contactType": "customer service"
  }
}
```

### 5. BreadcrumbList

```json
{
  "@context": "https://schema.org",
  "@type": "BreadcrumbList",
  "itemListElement": [
    {
      "@type": "ListItem",
      "position": 1,
      "name": "Home",
      "item": "https://example.com"
    },
    {
      "@type": "ListItem",
      "position": 2,
      "name": "Blog",
      "item": "https://example.com/blog"
    },
    {
      "@type": "ListItem",
      "position": 3,
      "name": "Post Title"
    }
  ]
}
```

## Response Format

```markdown
## Structured Data Analysis

### Current Status
[What JSON-LD exists / what's missing]

### Recommendations

**1. Add [Type] markup**
- **Why:** [Business value - rich results, AI discoverability]
- **Required properties:** [list]
- **JSON-LD:**
  ```json
  { ... }
  ```

**2. Fix [issue]**
- **Issue:** [what's wrong]
- **Fix:** [specific change]

### @id Convention
- Organization: `/#organization`
- WebSite: `/#website`
- Person: `/team/slug/#person`
- Article: `/blog/slug/#article`

### Testing
- [Google Rich Results Test](https://search.google.com/test/rich-results)
- [Schema.org Validator](https://validator.schema.org/)
```

## Platform-Specific Guidance

### Drupal Implementation

**Using Schema.org Metatag module:**
```bash
composer require drupal/schema_metatag
drush en schema_metatag schema_article schema_event schema_organization
```

Configure at: `/admin/config/search/metatag` → Add Schema.org mappings per content type.

**Manual JSON-LD in Twig:**
```twig
{# In node--article.html.twig or html.html.twig #}
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "Article",
  "headline": "{{ node.label }}",
  "datePublished": "{{ node.getCreatedTime|date('c') }}"
}
</script>
```

### WordPress Implementation

**Using Yoast SEO (automatic):**
Yoast automatically generates Organization, WebSite, Article, and Person schemas. Customize at: Settings → Yoast SEO → Schema.

**Manual JSON-LD via functions.php:**
```php
add_action('wp_head', function() {
  if (is_single()) {
    $post = get_post();
    $schema = [
      '@context' => 'https://schema.org',
      '@type' => 'Article',
      'headline' => get_the_title(),
      'datePublished' => get_the_date('c'),
      'author' => [
        '@type' => 'Person',
        'name' => get_the_author(),
      ],
    ];
    echo '<script type="application/ld+json">' . wp_json_encode($schema) . '</script>';
  }
});
```

## Integration with /audit-structured-data Command

- **This Skill**: Focused checks on specific pages, templates, or JSON-LD snippets
  - "Does this page have structured data?"
  - "What Schema.org type should I use for this event page?"
  - "Add JSON-LD to this template"
  - Single page or template analysis

- **`/audit-structured-data` Command**: Comprehensive site-wide audit
  - Full sitemap crawl and page sampling
  - Quality scoring and grading
  - Cross-page entity graph design
  - Rich Results validation for all types
  - CMS module/plugin audit
  - Formal report for stakeholders

## Common Patterns

### Entity Reuse via @id

When the same entity (Organization, Person) appears on multiple pages, use `@id` references instead of duplicating:

```json
// On homepage - define the full entity
{
  "@type": "Organization",
  "@id": "/#organization",
  "name": "Company",
  "url": "https://example.com",
  "logo": "https://example.com/logo.png"
}

// On blog post - reference by @id
{
  "@type": "Article",
  "publisher": { "@id": "/#organization" }
}
```

### @graph Pattern

Use `@graph` to include multiple entities in a single JSON-LD block:

```json
{
  "@context": "https://schema.org",
  "@graph": [
    {
      "@type": "Organization",
      "@id": "/#organization",
      "name": "Company"
    },
    {
      "@type": "WebSite",
      "@id": "/#website",
      "name": "Company Website",
      "publisher": { "@id": "/#organization" }
    },
    {
      "@type": "BreadcrumbList",
      "itemListElement": [...]
    }
  ]
}
```

## Resources

- [Google Structured Data Documentation](https://developers.google.com/search/docs/appearance/structured-data)
- [Google Rich Results Test](https://search.google.com/test/rich-results)
- [Schema.org Full Type Hierarchy](https://schema.org/docs/full.html)
- [Schema.org Validator](https://validator.schema.org/)
