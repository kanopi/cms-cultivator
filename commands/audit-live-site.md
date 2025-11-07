---
description: Comprehensive live site audit using Chrome DevTools for performance, accessibility, SEO, and security
argument-hint: [site-url]
allowed-tools: Read, Write, Glob, Grep
---

# Live Site Audit

**Role:** You are an experienced full-stack web developer and QA specialist with expertise in front-end and back-end development, accessibility (WCAG 2.2 AA), security, and technical SEO.

**Mission:** Perform a **comprehensive, pattern-based audit** of the specified website. Use **strategic sampling with pattern detection** to efficiently cover the entire site while providing actionable findings for all discovered pages.

---

## Usage

### Basic Audit
```bash
/audit-live-site https://example.com
```

### What Happens
1. Validates Chrome DevTools MCP is available
2. Discovers all pages (up to 50)
3. Categorizes pages by template
4. Performs 5-8 deep audits (full performance traces)
5. Performs 20-40 light audits (quick checks)
6. Analyzes patterns and consolidates findings
7. Generates 2 files:
   - `example-com-2025-01-07-audit.md`
   - `example-com-2025-01-07-audit-tasks.csv`

---

## Estimated Audit Time

| Phase | Pages | Time | Tokens |
|-------|-------|------|--------|
| Discovery | 1 | 5 min | ~5k |
| Deep audits | 5-8 | 25-35 min | ~50-60k |
| Light audits | 20-40 | 10-15 min | ~15-20k |
| Pattern analysis | - | 5 min | ~5k |
| Report generation | - | 5-10 min | ~10-15k |
| **Total** | **~30-50** | **50-70 min** | **~85-105k** |

**User notification:**
"This audit will take approximately 1 hour and use ~100k tokens. Proceed? (yes/no)"

---

## Step 0: Validate Prerequisites

Before starting the audit:

### 1. Check for Chrome DevTools MCP Server

**Required MCP tools:**
- `mcp__chrome-devtools__navigate_page`
- `mcp__chrome-devtools__take_snapshot`
- `mcp__chrome-devtools__list_network_requests`
- `mcp__chrome-devtools__list_console_messages`
- `mcp__chrome-devtools__evaluate_script`
- `mcp__chrome-devtools__performance_start_trace`
- `mcp__chrome-devtools__performance_stop_trace`
- `mcp__chrome-devtools__performance_analyze_insight`
- `mcp__chrome-devtools__emulate` (viewport, UA, DPR, CPU, network, cache control)
- `mcp__chrome-devtools__list_pages`
- `mcp__chrome-devtools__new_page`

**If Chrome DevTools MCP is not available:**
1. Inform user: "Chrome DevTools MCP Server is required for this audit"
2. Direct user to: https://github.com/modelcontextprotocol/servers
3. Provide installation instructions:
   ```bash
   # Install Chrome DevTools MCP Server
   npm install -g @modelcontextprotocol/server-chrome-devtools

   # Add to Claude Code MCP configuration
   # See: https://github.com/modelcontextprotocol/servers
   ```
4. **Do not proceed without Chrome DevTools MCP**

### 2. Confirm Site URL

- If no URL provided as argument, ask user for the site URL
- Validate URL format (must include protocol: `https://` or `http://`)
- Confirm scope:
  - Same registrable domain (include `www.` variant)
  - First-level submenus only
  - Up to 50 pages total

### 3. Set Measurement Profile

Apply to all audited pages:

- **Device:** Mobile emulation 360×800, DPR=2 (mid-range Android UA)
- **CPU throttle:** 4×
- **Network:** Slow 4G (~1.6 Mbps down / 750 Kbps up / 150 ms RTT)
- **Cache:** Disabled
- **Runs:** Cold run; report the worst value

**Apply emulation:**
```javascript
mcp__chrome-devtools__emulate({
  cpuThrottlingRate: 4,
  networkConditions: "Slow 4G"
})
```

---

## Audit Execution Plan

Create a todo list to track progress:

1. ☐ Discovery phase (5 min) - Extract all URLs
2. ☐ Categorize pages by template type
3. ☐ Deep audit: Homepage
4. ☐ Deep audit: Key content pages (2-3)
5. ☐ Deep audit: Different templates (1-2)
6. ☐ Deep audit: Interactive pages (1)
7. ☐ Light audits: Remaining pages (20-40)
8. ☐ Pattern analysis & consolidation
9. ☐ Generate markdown summary
10. ☐ Generate CSV tasks file

---

## Important Notes

**Scope & Ethics:**
- Only audit sites you have permission to test
- Respects robots.txt for crawling
- Rate-limited to avoid server impact
- Does not store/transmit sensitive data
- Reports only public information

**Limitations:**
- Cannot audit authenticated pages (login required)
- May miss dynamic content behind interactions
- Server-side issues (database, caching) not detectable
- Cannot test actual form submissions

---

## Audit Coverage (Lighthouse-equivalent)

**Performance:** LCP, **INP** (not FID), CLS, FCP, **TBT** (use TBT instead of TTI), render-blocking resources, network dependency chains, DOM size, third-party impact.

**Accessibility (custom + axe-core optional):** Touch targets ≥48×48px, links with discernible text, image alt attributes, form labels, `<html lang>`, viewport meta, heading hierarchy, image aspect ratios.

**SEO:** Meta descriptions, titles, canonical, robots/sitemaps, structured data (Schema.org), basic internal linking and URL clarity.

**Best Practices/Security:** Console errors/warnings, HTTPS/HSTS, 404 & soft-404 detection, image optimization, CSP/Referrer-Policy/Permissions-Policy/X-Content-Type-Options, cookie flags, mixed content.

---

## Crawl Scope & Reliability Guards

### Scope
- **Domain:** Same registrable domain (incl. `www.`)
- **Sources:** Main nav, secondary header, footer menus, **first-level submenus**, `/sitemap.xml`, HTML sitemap
- **Limits:** Discover up to 50 pages
- **Exclusions:**
  - Downloads/external domains
  - `mailto:` and `tel:` links
  - Files > 5 MB
  - PDF, ZIP, and other non-HTML files

### Reliability Guards

**Robots.txt:**
- Respect for crawling
- Still report indexability anomalies

**Retry Logic:**
For each page navigation:
- **Timeout:** 30 seconds max
- **Retries:** Up to 3 attempts with exponential backoff (5s, 10s, 20s)
- **Failure handling:**
  - If page fails after 3 retries: Log issue and continue
  - If >20% of pages fail: Alert user and offer to continue or abort
  - If Chrome DevTools becomes unresponsive: Restart and resume from last checkpoint

**Soft-404 Detection:**
- Flag pages returning 200 with "not found" / empty templates
- Check for: minimal content, "page not found" text, navigation to homepage

**SPAs/Hidden Menus:**
- Programmatically open mega-menus/accordions before scraping
- Wait for dynamic content to load (up to 5 seconds)
- Scroll to trigger lazy-loaded navigation

### Consent Banner Detection & Handling

Try these selectors in order (first 5 seconds of page load):
1. `button:contains("Accept")`, `button:contains("Accept all")`
2. `[class*="consent"] button`, `[id*="cookie"] button`
3. `#onetrust-accept-btn-handler` (OneTrust)
4. `.cookie-notice button`, `.gdpr-notice button`
5. `button[class*="accept"]`, `button[id*="accept"]`

**If banner persists:**
- Note in findings: "Consent banner may affect measurements"
- Continue audit (don't block on banner)

---

## Efficient Audit Strategy (IMPORTANT: Follow This Approach)

**The goal is comprehensive coverage with efficient execution. Do NOT audit every page with full performance traces.**

### Phase 1: Discovery (5 minutes)

1. Navigate to homepage
2. Extract ALL URLs from:
   - Main navigation (including dropdowns/mega-menus)
   - Footer navigation
   - Secondary headers
   - `/sitemap.xml` (if available)
   - HTML sitemap (if available)
3. Categorize pages by template type:
   - Homepage
   - Top-level sections (About, Services, Contact, etc.)
   - Content pages (articles, products, locations, etc.)
   - Utility pages (search, 404, privacy, sitemap, etc.)
4. Limit to 50 pages total

**Discovery script:**
```javascript
mcp__chrome-devtools__evaluate_script({
  function: `() => {
    const links = new Set();
    const baseUrl = window.location.origin;

    // Get all links
    document.querySelectorAll('a[href]').forEach(a => {
      const href = a.getAttribute('href');
      if (!href) return;

      // Resolve relative URLs
      const url = new URL(href, window.location.href);

      // Same origin only
      if (url.origin === baseUrl) {
        // Remove hash and trailing slash
        const clean = url.origin + url.pathname.replace(/\/$/, '');
        links.add(clean);
      }
    });

    return {
      total: links.size,
      urls: Array.from(links).slice(0, 50).sort()
    };
  }`
})
```

### Phase 2: Strategic Deep Audits (Representative Sampling)

Perform **full performance audits** on 5-8 strategically selected pages:

1. **Homepage** (always audit - highest traffic)
2. **2-3 key content pages** from main sections (e.g., top services, main program pages)
3. **1-2 pages with different templates** (landing pages, listing pages)
4. **1 form/interactive page** if present

For each deep audit page, run:
- Full performance trace with `performance_start_trace` + `performance_analyze_insight`
- Network requests analysis
- Console messages
- Full accessibility checks
- Custom JavaScript checks

### Phase 3: Light Audits (Pattern Detection)

For remaining 20-40 pages, run **light audits** focusing on:
- Navigate to page
- Console messages (errors/warnings)
- Quick accessibility check (custom JS script only)
- Skip full performance traces (too time-consuming)

**Light audit script:**
```javascript
mcp__chrome-devtools__evaluate_script({
  function: `() => {
    const visible = el => {
      const r = el.getBoundingClientRect();
      const cs = getComputedStyle(el);
      return cs.display !== 'none' && cs.visibility !== 'hidden' && r.width > 0 && r.height > 0;
    };
    return {
      url: window.location.href,
      title: document.title,
      h1Count: document.querySelectorAll('h1').length,
      imagesWithoutAlt: Array.from(document.images).filter(img => visible(img) && !img.alt).length,
      smallTouchTargets: Array.from(document.querySelectorAll('a, button')).filter(el => {
        if (!visible(el)) return false;
        const r = el.getBoundingClientRect();
        return (r.width < 48 || r.height < 48);
      }).length,
      hasMetaDesc: !!document.querySelector('meta[name="description"]'),
      hasCanonical: !!document.querySelector('link[rel="canonical"]'),
      inputsWithoutLabels: Array.from(document.querySelectorAll('input:not([type="hidden"])')).filter(input => {
        if (!visible(input)) return false;
        return !(input.id && document.querySelector(\`label[for="\${input.id}"]\`)) && !input.getAttribute('aria-label');
      }).length
    };
  }`
})
```

### Phase 4: Pattern Analysis & Consolidation (CRITICAL)

#### Site-Wide Patterns (>80% of pages)

Look for:
1. **Recurring JavaScript errors:** Same error on every page → 1 consolidated task
2. **Universal accessibility issues:** Touch targets, alt text, labels across all pages
3. **Missing security headers:** Server configuration affects all pages
4. **Third-party scripts:** Same vendors loading on every page

**Template:**
"Site-wide - [Issue] affecting [X]% of pages ([Y] total instances across [Z] pages)"

#### Template-Specific Patterns (grouped by page type)

Look for:
1. **Content pages:** Same layout/performance profile → group findings
2. **Listing pages:** Same markup/schema issues → group findings
3. **Form pages:** Same validation/accessibility patterns → group findings

**Template:**
"[Template type] pages - [Issue] affecting [X] pages in this template"

#### Example Consolidation:

❌ **Bad** (50 separate tasks):
- /page1 - Touch target below 48px
- /page2 - Touch target below 48px
- /page3 - Touch target below 48px
[... 47 more duplicate tasks]

✅ **Good** (1 consolidated task):
- Site-wide - Touch targets below 48px minimum (101 violations across 50 pages)
  Evidence: All pages affected - navigation buttons (23 instances), social icons (18), carousel controls (15), card links (45)

---

## Procedure (Per Deep Audit Page)

### A) Navigate & Load

```javascript
mcp__chrome-devtools__navigate_page({ url: "[URL]", timeout: 30000 })
```

Wait for page to fully load (check `document.readyState === 'complete'`).

### B) Performance Trace & Insights

```javascript
// Start trace with reload
mcp__chrome-devtools__performance_start_trace({ reload: true, autoStop: true })

// After trace completes, analyze key insights (select most relevant)
mcp__chrome-devtools__performance_analyze_insight({
  insightSetId: "[from trace]",
  insightName: "LCPBreakdown"
})

mcp__chrome-devtools__performance_analyze_insight({
  insightSetId: "[from trace]",
  insightName: "RenderBlocking"
})

mcp__chrome-devtools__performance_analyze_insight({
  insightSetId: "[from trace]",
  insightName: "ThirdParties"
})

// Only if CLS > 0.1
mcp__chrome-devtools__performance_analyze_insight({
  insightSetId: "[from trace]",
  insightName: "CLSCulprits"
})
```

**Report metrics:**
- **LCP** (Largest Contentful Paint): Target <2.5s
- **INP** (Interaction to Next Paint): Target <200ms (NOT FID)
- **CLS** (Cumulative Layout Shift): Target <0.1
- **FCP** (First Contentful Paint): Target <1.8s
- **TBT** (Total Blocking Time): Target <200ms (NOT TTI)

### C) Network Analysis

```javascript
mcp__chrome-devtools__list_network_requests({
  pageSize: 100,
  resourceTypes: ['document','stylesheet','script','image','font','xhr','fetch']
})
```

**Flag these issues:**
- 404 & soft-404s
- Slow assets (>3s load time)
- Uncompressed/oversized resources
- Missing cache headers
- Mixed content (HTTP resources on HTTPS page)
- Third-party weight (>500KB from single domain)

### D) Console Messages

```javascript
mcp__chrome-devtools__list_console_messages({
  types: ['error','warn']
})
```

**Record:**
- Uncaught errors
- Deprecation warnings
- Security warnings
- Failed resource loads
- Include file path and line:column when present

### E) Custom JavaScript Checks (Full version for deep audits)

```javascript
mcp__chrome-devtools__evaluate_script({
  function: `() => {
    const visible = el => {
      const r = el.getBoundingClientRect();
      const cs = getComputedStyle(el);
      return cs.display !== 'none' && cs.visibility !== 'hidden' && r.width > 0 && r.height > 0;
    };

    const links = Array.from(document.querySelectorAll('a'));
    const images = Array.from(document.images);
    const inputs = Array.from(document.querySelectorAll('input:not([type="hidden"])'));
    const touchTargets = Array.from(document.querySelectorAll('a, button, input[type="button"], input[type="submit"], [role="button"], [onclick]'));

    return {
      // Meta
      url: window.location.href,
      title: document.title,
      metaDescription: document.querySelector('meta[name="description"]')?.content || null,
      ogTitle: document.querySelector('meta[property="og:title"]')?.content || null,
      ogDescription: document.querySelector('meta[property="og:description"]')?.content || null,
      ogImage: document.querySelector('meta[property="og:image"]')?.content || null,

      // Accessibility - Touch Targets
      smallTouchTargets: touchTargets.filter(el => {
        if (!visible(el) || el.hasAttribute('disabled') || el.getAttribute('aria-hidden')==='true') return false;
        const r = el.getBoundingClientRect();
        return (r.width < 48 || r.height < 48);
      }).length,

      // Accessibility - Text & Labels
      h1Count: document.querySelectorAll('h1').length,
      imagesWithoutAlt: images.filter(img => visible(img) && !img.alt).length,
      inputsWithoutLabels: inputs.filter(input => {
        if (!visible(input)) return false;
        return !(input.id && document.querySelector(\`label[for="\${input.id}"]\`)) && !input.getAttribute('aria-label') && !input.getAttribute('aria-labelledby');
      }).length,
      linksWithoutText: links.filter(link => {
        const t = link.textContent.trim();
        const aria = link.getAttribute('aria-label');
        const title = link.getAttribute('title');
        return !t && !aria && !title;
      }).length,

      // Accessibility - Images
      imagesWithIncorrectAspectRatio: images.filter(img => {
        if (!img.naturalWidth || !img.naturalHeight || !visible(img)) return false;
        const displayedRatio = img.width / img.height;
        const naturalRatio = img.naturalWidth / img.naturalHeight;
        return Math.abs(displayedRatio - naturalRatio) > 0.05;
      }).length,

      // Analytics / Tracking
      hasGoogleAnalytics: typeof window.gtag !== 'undefined' || typeof window.ga !== 'undefined',
      hasGTM: typeof window.google_tag_manager !== 'undefined',
      hasFacebookPixel: typeof window.fbq !== 'undefined',

      // Schema / Structured Data
      structuredDataCount: document.querySelectorAll('script[type="application/ld+json"]').length,
      structuredDataTypes: Array.from(document.querySelectorAll('script[type="application/ld+json"]')).map(script => {
        try {
          const data = JSON.parse(script.textContent);
          return data['@type'] || data['@graph']?.[0]?.['@type'] || 'Unknown';
        } catch { return 'Invalid JSON'; }
      }),

      // Content Quality
      hasLoremIpsum: document.body.textContent.toLowerCase().includes('lorem ipsum'),
      hasTestData: /(^|\b)(test|placeholder|example\.com|fake)(\b|$)/i.test(document.body.textContent),
      wordCount: document.body.textContent.trim().split(/\s+/).length,

      // Mobile & i18n
      hasViewportMeta: !!document.querySelector('meta[name="viewport"]'),
      viewportContent: document.querySelector('meta[name="viewport"]')?.content || null,
      hasLangAttribute: !!document.documentElement.getAttribute('lang'),
      langValue: document.documentElement.getAttribute('lang'),

      // SEO
      canonical: document.querySelector('link[rel="canonical"]')?.href || null,
      robots: document.querySelector('meta[name="robots"]')?.content || null,
      hasH1: document.querySelectorAll('h1').length > 0,

      // Security
      hasHttpsLinks: links.some(link => link.href.startsWith('http://')),

      // Performance hints
      domSize: document.querySelectorAll('*').length,
      hasLazyLoading: images.some(img => img.loading === 'lazy'),
      hasDeferredScripts: Array.from(document.scripts).some(s => s.defer || s.async)
    };
  }`
})
```

---

## From Insights to Tasks (Performance & Beyond)

For each performance insight (RenderBlocking, LCPBreakdown, ThirdParties, etc.):

1. **Summarize issue** with context
2. **Include estimated savings** (if provided by insight)
3. **Create consolidated CSV tasks** with priority:
   - **High:** >500ms potential savings OR critical accessibility/security issue
   - **Medium:** 200-500ms savings OR important but not blocking
   - **Low:** <200ms savings OR nice-to-have improvements

**Key principle:** Create ONE task per issue type when it affects multiple pages. Include evidence from all affected pages in the Description field.

---

## Deliverables

Generate TWO files using the Write tool:

### File 1: Markdown Summary

**Filename:** `[site-name]-[YYYY-MM-DD]-audit.md`

**Template:**

```markdown
# Site Audit: [Site Name]

**Date:** [YYYY-MM-DD]
**Auditor:** Claude (CMS Cultivator)
**Pages Audited:** [X deep audits / Y light audits / Z total discovered]
**Audit Duration:** [XX] minutes

---

## Executive Summary

[5 bullets - plain language only; no counts/totals]

- [Finding 1]
- [Finding 2]
- [Finding 3]
- [Finding 4]
- [Finding 5]

---

## Top Priority Actions

| URL | Issue | Fix | Priority |
|-----|-------|-----|----------|
| [URL or "Site-wide"] | [Brief issue] | [1 sentence fix] | high |
| ... | ... | ... | ... |

[10-15 most critical actions]

---

## Per-Page Findings

### Homepage ([URL])

**Performance:**
- LCP: [X]s (target: <2.5s)
- INP: [X]ms (target: <200ms)
- CLS: [X] (target: <0.1)
- FCP: [X]s (target: <1.8s)
- TBT: [X]ms (target: <200ms)

**Key Issues:**
- [Issue 1]
- [Issue 2]
- [Issue 3]

---

### [Page 2 Name] ([URL])

[Repeat structure for each deeply audited page]

---

### Template Groups

#### Content Pages (20 pages audited)

**Common patterns:**
- [Pattern 1]
- [Pattern 2]
- [Pattern 3]

**Representative examples:**
- /page-1
- /page-2
- /page-3

---

## What's Working

[3-5 bullets of positive findings]

- [Success 1]
- [Success 2]
- [Success 3]

---

## Risks

[3-5 bullets of major concerns]

- [Risk 1]
- [Risk 2]
- [Risk 3]

---

## Recommendations Summary

**Immediate (Next Sprint):**
1. [Action 1]
2. [Action 2]
3. [Action 3]

**Short-term (Next 1-2 months):**
1. [Action 1]
2. [Action 2]
3. [Action 3]

**Long-term (Ongoing):**
1. [Action 1]
2. [Action 2]
3. [Action 3]

---

## Methodology

**Tools:** Chrome DevTools MCP Server via Claude Code
**Measurement Profile:** Mobile (360×800), 4× CPU throttle, Slow 4G, cache disabled
**Coverage:** [X] pages discovered, [Y] pages audited ([Z] deep / [W] light)
**Standards:** WCAG 2.2 AA, Core Web Vitals, Lighthouse methodology

---

**Report generated:** [Date & Time]
```

---

### File 2: CSV Tasks

**Filename:** `[site-name]-[YYYY-MM-DD]-audit-tasks.csv`

**Column Order (STRICT - do not reorder):**

| Column | Format | Notes |
|--------|--------|-------|
| **Tasklist** | `Audit - [Category]` | Category = Security, Performance, SEO, Accessibility, Content, Usability, Technical, Compliance, Analytics, or Code quality |
| **Task** | `[URL or "Site-wide"] - [Brief finding]` | Example: `Site-wide - Touch targets below 48x48px minimum` OR `/service/cardiology/ - Form inputs without labels` |
| **Description** | Multi-line text | See format below |
| **Assign to** | (blank) | Leave empty |
| **Start date** | (blank) | Leave empty |
| **Due date** | (blank) | Leave empty |
| **Priority** | `high`, `medium`, or `low` | high=Critical/blocking, medium=Major/important, low=Minor/nice-to-have |
| **Estimated time** | `30m`, `2h`, `1h 30m`, `45m` | Realistic middle-ground estimates in h/m |
| **Tags** | (blank) | Leave empty |
| **Status** | `Active` | Always "Active" |

---

### Description Field Format

**Structure:**
```
URL: [absolute URL or "Site-wide"]

[1-2 sentence fix instruction]

Metric savings: [if applicable]
- LCP: -1.2s
- CLS: -0.15
- File size: -450KB

Evidence: [technical details with all affected pages]
[Specific selectors, line numbers, or file paths]
[List ALL affected pages for site-wide issues]
```

**Example (Site-wide task):**
```
URL: https://example.com/ (affects all pages)

Increase touch target sizes for navigation elements to meet WCAG 2.2 AA minimum 48×48px requirement. Update CSS for .nav-item, .social-icon, and .carousel-btn classes.

Evidence: Violations across site:
- Navigation items: 23 violations on /, 24 on /about, 22 on /services [15 pages total]
- Social icons: 6 violations per page [all 30 pages]
- Carousel controls: 4 violations per page [8 pages with carousels]
Total: 101 violations across 30 pages
```

**Example (Page-specific task):**
```
URL: https://example.com/contact

Add labels to form inputs to meet WCAG 2.2 AA requirements. Associate labels with inputs using for/id attributes or wrap inputs in labels.

Evidence: Missing labels on contact form:
- Name input (line 45)
- Email input (line 52)
- Phone input (line 59)
- Message textarea (line 66)
```

---

### CSV Export Validation

Before exporting, validate each row:

**Required field checks:**
- ✅ Task: Must start with "Site-wide -" or contain valid URL
- ✅ Description: Must start with "URL: " on line 1
- ✅ Priority: Must be exactly "high", "medium", or "low"
- ✅ Estimated time: Must match pattern `/^\d+[hm](\s+\d+[hm])?$/`
- ✅ Status: Must be exactly "Active"

**Quality checks:**
- ❌ No banned phrases: "review", "audit", "investigate", "look into", "ensure", "consider"
- ❌ No vague fixes: Each task must reference specific files/selectors/URLs
- ✅ Site-wide tasks (≥80% pages affected) include "Evidence:" section with all URLs
- ✅ Estimated time is realistic (30m-8h range)

**Consolidation check:**
- If >3 tasks have identical Issue + Fix → Merge into one Site-wide task

**Allowed verbs:**
add, remove, replace, compress, convert, defer, preconnect, preload, inline, lazy-load, set, enable, disable, minify, fix, rewrite, relabel, map, canonicalize, block, allow, update, implement

**Banned phrases:**
review, audit, investigate, look into, ensure, consider

---

### Pre-Export Normalizer

1. **De-dupe aggressively** — Identical fixes MUST be combined into ONE row when evidence/selectors match and ≥80% pages are affected
2. **Explode** compound findings into separate rows ONLY if they require different expertise/implementation
3. **Down-scope** vague rows until they reference a **specific page or "Site-wide"** and include concrete **evidence**
4. **Reject** rows violating allowed verbs/banned phrases

**Example normalizations:**

❌ **Before (vague):** "Review form security and validation"
✅ **After (specific):** "Add CSRF tokens to contact form submission (line 145)"

❌ **Before (compound):** "Fix performance and accessibility issues"
✅ **After (separate tasks):**
- "Defer non-critical JavaScript to improve TBT by 450ms"
- "Add alt text to 23 product images"

---

## CRITICAL: Consolidation Requirements

**Aim for 15-25 tasks total**, not 50+ duplicate tasks.

### When to Consolidate (≥80% of pages affected)

**Site-wide patterns:**
1. **Recurring JavaScript errors** → 1 task with all error instances
2. **Touch target violations** → 1 task with total count across all pages
3. **Missing security headers** → 1 server configuration task
4. **Third-party scripts** → 1 task per vendor affecting all pages
5. **Missing alt text** → 1 task with total count and example pages
6. **Form label issues** → 1 task if same pattern across all forms
7. **Heading hierarchy** → 1 task if site-wide template issue
8. **Missing meta descriptions** → 1 task with list of all affected pages

**Template-specific patterns:**
- Same issue on all content pages → 1 task for content template
- Same issue on all listing pages → 1 task for listing template
- Same issue on all form pages → 1 task for form template

### When NOT to Consolidate (<80% of pages)

- **Page-specific content issues** (unique to one page)
- **Different root causes** (same symptom, different fixes)
- **Different expertise required** (backend vs. frontend)
- **Different urgency levels** (some critical, some minor)

---

## Categories (for Tasklist field)

- **Security** - HTTPS, headers, mixed content, vulnerabilities
- **Performance** - Core Web Vitals, resource optimization, caching
- **SEO** - Meta tags, structured data, sitemaps, canonicals
- **Accessibility** - WCAG violations, keyboard nav, screen readers
- **Content** - Missing content, lorem ipsum, test data
- **Usability** - UX issues, navigation, mobile experience
- **Technical** - Console errors, 404s, broken functionality
- **Compliance** - GDPR, cookies, privacy policy
- **Analytics** - Tracking setup, conversion tracking
- **Code quality** - Deprecated APIs, best practices

---

## Common Issues & Troubleshooting

### Issue: Chrome DevTools MCP not found
**Fix:** Install from https://github.com/modelcontextprotocol/servers

**Installation steps:**
```bash
npm install -g @modelcontextprotocol/server-chrome-devtools
```

Then add to Claude Code MCP configuration.

---

### Issue: Site blocks automated access
**Fix:**
- Check robots.txt for crawl restrictions
- May need manual override if site has aggressive bot protection
- Consider auditing from staging environment

---

### Issue: Too many pages discovered (>50)
**Fix:**
- Audit prioritizes based on navigation hierarchy
- Focus on main navigation and top-level sections
- Skip deep pagination and archive pages

---

### Issue: Consent banner blocks content
**Fix:**
- Script attempts to accept common banner selectors
- If persistent, note limitation in findings
- Banner may affect measurements (document this)

---

### Issue: SPA pages don't load content
**Fix:**
- Wait for `document.readyState === 'complete'`
- Add 2-3 second delay after navigation
- May need to trigger navigation interactions

---

### Issue: Performance trace fails
**Fix:**
- Retry up to 3 times with exponential backoff
- Skip trace and note limitation if persistent failure
- Continue with other audit checks (console, accessibility)

---

## Site URL

**Instructions:** Replace `[SITE-URL]` with the actual site URL to audit.

Audit this site: **[SITE-URL]**

---

## Execution Flow

1. ✅ Validate prerequisites (Chrome DevTools MCP)
2. ✅ Confirm site URL with user
3. ✅ Set measurement profile (mobile, throttled)
4. ✅ Create todo list for progress tracking
5. ✅ Phase 1: Discovery (5 min) - Extract 30-50 URLs
6. ✅ Phase 2: Deep audits (25-35 min) - 5-8 pages with full traces
7. ✅ Phase 3: Light audits (10-15 min) - 20-40 pages quick checks
8. ✅ Phase 4: Pattern analysis (5 min) - Consolidate findings
9. ✅ Generate markdown summary file
10. ✅ Generate CSV tasks file
11. ✅ Validate CSV (no banned phrases, proper consolidation)
12. ✅ Present files to user

---

**Begin the comprehensive audit now.**
