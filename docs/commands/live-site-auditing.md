# Live Site Auditing

Comprehensive audit of live websites using Chrome DevTools for performance, accessibility, SEO, and security analysis.

## Command

`/audit-live-site [url]` - Full site audit for performance, accessibility, SEO, and security

## Requirements

**Chrome DevTools MCP Server** is required for this command.

Install from: https://github.com/modelcontextprotocol/servers

```bash
npm install -g @modelcontextprotocol/server-chrome-devtools
```

Then configure in Claude Code MCP settings.

## What It Audits

### Performance (Core Web Vitals)
- **LCP** (Largest Contentful Paint) - Target: <2.5s
- **INP** (Interaction to Next Paint) - Target: <200ms
- **CLS** (Cumulative Layout Shift) - Target: <0.1
- **FCP** (First Contentful Paint) - Target: <1.8s
- **TBT** (Total Blocking Time) - Target: <200ms
- Render-blocking resources
- Network dependency chains
- Third-party impact

### Accessibility (WCAG 2.2 AA)
- Touch targets ≥48×48px
- Links with discernible text
- Image alt attributes
- Form labels
- HTML lang attribute
- Viewport meta tag
- Heading hierarchy
- Image aspect ratios

### SEO
- Meta descriptions and titles
- Canonical URLs
- Robots.txt and sitemaps
- Structured data (Schema.org)
- Internal linking
- URL structure

### Security & Best Practices
- HTTPS/HSTS
- Security headers (CSP, Referrer-Policy, etc.)
- Mixed content detection
- Console errors and warnings
- 404 and soft-404 detection
- Image optimization
- Cookie security flags

## Audit Strategy

**Efficient multi-phase approach:**

1. **Discovery (5 min)** - Crawl up to 50 pages from navigation, sitemap
2. **Deep audits (25-35 min)** - 5-8 pages with full performance traces
3. **Light audits (10-15 min)** - 20-40 pages with quick checks
4. **Pattern analysis (5 min)** - Consolidate site-wide findings

**Total time:** ~50-70 minutes, ~100k tokens

## Measurement Profile

All audits use consistent, realistic conditions:

- **Device:** Mobile (360×800px, DPR=2)
- **CPU:** 4× throttling (simulates mid-range device)
- **Network:** Slow 4G (1.6 Mbps down, 750 Kbps up, 150ms RTT)
- **Cache:** Disabled (cold load)

## Outputs

### 1. Markdown Summary Report

**Filename:** `[site-name]-[YYYY-MM-DD]-audit.md`

Contains:
- Executive summary (5 key findings)
- Top priority actions table
- Per-page findings (deep audited pages)
- Template group patterns
- What's working
- Risks and recommendations

### 2. CSV Task List

**Filename:** `[site-name]-[YYYY-MM-DD]-audit-tasks.csv`

Import-ready task list with:
- Consolidated, actionable tasks (15-25 total)
- Site-wide issues grouped together
- Priority levels (high/medium/low)
- Time estimates
- Detailed evidence and fix instructions

**Format:** Compatible with Monday.com, Asana, Jira, Linear, and other project management tools.

## Consolidation Approach

**Creates efficient, actionable tasks:**

❌ **Avoids:** 50 duplicate tasks for same issue across pages
✅ **Creates:** 1 site-wide task with evidence from all affected pages

**Example:**
- "Site-wide - Touch targets below 48px minimum (101 violations across 30 pages)"
- Evidence lists all affected pages and specific elements

## Usage Example

```bash
# Audit a live site
/audit-live-site https://example.com

# What happens:
# 1. Validates Chrome DevTools MCP is available
# 2. Discovers pages from navigation and sitemap
# 3. Runs deep audits on homepage + key pages
# 4. Runs light audits on remaining pages
# 5. Analyzes patterns and consolidates findings
# 6. Generates markdown report and CSV task list
```

## Common Use Cases

**Pre-launch audit:**
- Run before site goes live
- Identify critical issues
- Create launch checklist

**Post-launch validation:**
- Verify deployment success
- Check for regressions
- Monitor Core Web Vitals

**Regular monitoring:**
- Quarterly audits
- Track improvements over time
- Catch new issues early

**Client deliverable:**
- Professional audit report
- Import-ready task list
- Clear prioritization

## Limitations

- Cannot audit pages behind authentication
- May miss dynamic content behind complex interactions
- Cannot detect server-side issues (database, caching)
- Cannot test actual form submissions
- Respects robots.txt (won't crawl blocked areas)

## Best Practices

1. **Get permission** - Only audit sites you have authorization to test
2. **Use staging first** - Test on staging before production audits
3. **Schedule wisely** - Avoid peak traffic times
4. **Review manually** - Validate automated findings
5. **Track over time** - Regular audits show trends

See [Commands Overview](overview.md) for all available commands.
