---
description: Audit any website's structured data (JSON-LD/Schema.org) for SEO and AI discoverability
argument-hint: "<url> [options]"
allowed-tools: Task, Bash(git:*)
---

Spawn the **structured-data-specialist** agent using:

```
Task(cms-cultivator:structured-data-specialist:structured-data-specialist,
     prompt="Audit structured data (JSON-LD / Schema.org) with the following parameters:
       - URL: [use URL argument if provided, or detect from local project]
       - Depth mode: [quick/standard/comprehensive - parsed from arguments, default: standard]
       - Scope: [url/sitemap/content-type/entire/current-pr/codebase - parsed from arguments, default: url if URL provided, sitemap otherwise]
       - Format: [report/json/summary/checklist/pdf - parsed from arguments, default: report]
       - PDF flag: [true/false - if --pdf flag present or --format=pdf]
       - Min severity: [high/medium/low - parsed from arguments, default: medium]
       - Focus area: [use legacy focus argument if provided, otherwise 'complete analysis']
     Use Chrome DevTools MCP to navigate to pages, extract JSON-LD blocks, and analyze content types. Validate against Google Rich Results requirements. Generate quality score and grade. Save the comprehensive audit report to a file (audit-structured-data-YYYY-MM-DD-HHMM.md) and present the file path to the user. Suggest: '/export-audit-csv [report-file]'")
```

## Arguments

This command supports flexible argument modes for different use cases.

**The first argument should be the URL to audit:**
```bash
/audit-structured-data https://kanopi.com
```

### Depth Modes
- `--quick` - JSON-LD presence check on homepage + key pages (~5 min)
- `--standard` - Sitemap-based discovery, 10-15 pages, full analysis (default, ~15 min)
- `--comprehensive` - Full discovery, all content types, entity graph design (~30 min)

### Scope Control
- `--scope=url=<url>` - Single URL analysis (default if URL provided)
- `--scope=sitemap` - Crawl sitemap.xml and sample pages from each section
- `--scope=content-type=<type>` - Focus on specific Schema.org type (e.g., Article, Event)
- `--scope=entire` - Full site discovery (default for comprehensive)
- `--scope=current-pr` - Only template files changed in current PR (requires local code)
- `--scope=codebase` - CMS config/module code analysis (requires local code)

### Output Formats
- `--format=report` - Detailed markdown report with scoring (default)
- `--format=json` - Structured JSON for CI/CD integration
- `--format=summary` - Executive summary with key findings
- `--format=checklist` - Simple pass/fail structured data checklist
- `--format=pdf` - Professional PDF report (requires pandoc + Chrome/Chromium)

### PDF Output
- `--pdf` - Also generate PDF alongside the chosen format (e.g., `--format=report --pdf`)
- `--format=pdf` - Generate PDF as the primary output (markdown report is always created first)
- **No tools?** Upload the `.md` report to Google Docs and export as PDF (File → Download → PDF Document)

### Severity Thresholds
- `--min-severity=high` - Only critical and high severity issues
- `--min-severity=medium` - Medium and above (default)
- `--min-severity=low` - All issues including nice-to-haves

### Legacy Focus Areas (Still Supported)
For backward compatibility, single-word focus areas without `--` prefix are treated as legacy focus filters:
- `jsonld` - Focus on JSON-LD block validation
- `richresults` - Focus on Google Rich Results eligibility
- `ecommerce` - Focus on Product/Offer markup
- `articles` - Focus on Article/BlogPosting markup
- `events` - Focus on Event markup
- `faq` - Focus on FAQ markup
- `howto` - Focus on HowTo markup
- `breadcrumbs` - Focus on BreadcrumbList markup
- `organization` - Focus on Organization/WebSite markup

## Usage Examples

### Quick Checks
```bash
# Quick JSON-LD presence check on any URL
/audit-structured-data https://kanopi.com --quick

# Quick check with checklist output
/audit-structured-data https://example.com --quick --format=checklist
```

### Standard Audits
```bash
# Standard audit (default depth)
/audit-structured-data https://kanopi.com

# Standard audit with sitemap crawl
/audit-structured-data https://kanopi.com --scope=sitemap

# Standard audit focused on articles
/audit-structured-data https://kanopi.com articles

# Standard audit with JSON output for CI/CD
/audit-structured-data https://kanopi.com --format=json
```

### Comprehensive Audits
```bash
# Comprehensive pre-launch audit
/audit-structured-data https://kanopi.com --comprehensive

# Comprehensive with executive summary
/audit-structured-data https://kanopi.com --comprehensive --format=summary

# Comprehensive focused on events
/audit-structured-data https://kanopi.com --comprehensive --scope=content-type=Event
```

### PDF Reports
```bash
# Generate PDF report
/audit-structured-data https://kanopi.com --format=pdf

# Comprehensive audit with PDF output
/audit-structured-data https://kanopi.com --comprehensive --format=pdf

# Standard report + also generate PDF
/audit-structured-data https://kanopi.com --pdf
```

### Local Code Analysis (When Available)
```bash
# Audit structured data in PR changes
/audit-structured-data --scope=current-pr

# Audit CMS modules/plugins for structured data
/audit-structured-data --scope=codebase
```

### Legacy Syntax (Still Works)
```bash
# Focus on specific area
/audit-structured-data https://kanopi.com richresults
/audit-structured-data https://kanopi.com ecommerce

# Combine legacy focus with new modes
/audit-structured-data https://kanopi.com articles --quick
```

## Usage

**URL-Based Audit (Primary):**
- `/audit-structured-data <url>` - Full structured data audit on any website
- `/audit-structured-data <url> --quick` - Quick JSON-LD presence check
- `/audit-structured-data <url> --comprehensive` - Deep audit with entity graph

**Focus Areas:**
- `/audit-structured-data <url> jsonld` - JSON-LD block validation
- `/audit-structured-data <url> richresults` - Rich Results eligibility check
- `/audit-structured-data <url> ecommerce` - Product/Offer markup audit
- `/audit-structured-data <url> articles` - Article/BlogPosting markup
- `/audit-structured-data <url> organization` - Organization/WebSite markup

**Quick Code Analysis:**
For quick structured data checks on specific pages or templates during conversation, the **structured-data-analyzer** Agent Skill auto-activates when you mention "JSON-LD", "Schema.org", or "structured data". See: [`skills/structured-data-analyzer/SKILL.md`](../skills/structured-data-analyzer/SKILL.md)

---

## Tool Usage

**Allowed operations:**
- Spawn structured-data-specialist agent
- Extract JSON-LD blocks from live pages via Chrome DevTools MCP
- Validate structured data against Google Rich Results requirements
- Analyze content types and recommend Schema.org markup
- Design cross-page entity graph with @id conventions
- Generate scored audit reports with concrete JSON-LD examples
- Run git diff for --scope=current-pr

**Not allowed:**
- Do not modify code directly (provide JSON-LD examples in report)
- Do not install CMS modules/plugins (recommend in report)
- Do not submit to Google Rich Results Test (provide link)

The structured-data-specialist agent performs all audit operations.

---

## How It Works

This command spawns the **structured-data-specialist** agent, which uses the **structured-data-analyzer** skill and performs comprehensive structured data audits focused on JSON-LD and Schema.org.

### 1. Parse Arguments

The command first parses the arguments to determine the audit parameters:

**URL:**
- First non-flag argument is treated as the URL to audit
- If no URL provided and local code exists, detect site URL from config

**Depth mode:**
- Check for `--quick`, `--standard`, or `--comprehensive` flags
- Default: `--standard`

**Scope:**
- Check for `--scope=<value>` flag
- If URL provided without scope: defaults to `--scope=url=<url>`
- If `--scope=current-pr`: Get changed template files using `git diff --name-only origin/main...HEAD`
- Default: `--scope=sitemap` for standard/comprehensive without URL

**Format:**
- Check for `--format=<value>` flag
- Default: `--format=report`

**Severity threshold:**
- Check for `--min-severity=<value>` flag
- Default: `--min-severity=medium`

**Legacy focus area:**
- If argument doesn't start with `--` and isn't a URL, treat as legacy focus area

### 2. Navigate and Extract

The structured-data-specialist uses Chrome DevTools MCP to:

1. **Navigate to each page** using `navigate_page`
2. **Extract JSON-LD** using `evaluate_script` to find all `<script type="application/ld+json">` blocks
3. **Parse and validate** each JSON-LD block
4. **Identify page content type** from snapshot and page structure

### 3. Analyze and Score

For each page:
- Parse existing JSON-LD and validate syntax
- Check required properties per Schema.org type
- Check recommended properties
- Assess Rich Results eligibility
- Identify applicable but missing types

Compute quality score:
```
Score = Coverage (40%) + Completeness (30%) + Validity (20%) + Graph Design (10%)
Grade: A (90-100), B (75-89), C (60-74), D (40-59), F (0-39)
```

### 4. Generate Report

Create `audit-structured-data-YYYY-MM-DD-HHMM.md` with:
- Quality score and grade
- Existing structured data inventory
- Prioritized recommendations with severity ratings
- Concrete JSON-LD examples tailored to actual site content
- Cross-page entity graph (comprehensive mode)
- CMS-specific recommendations

---

## What the Structured Data Specialist Checks

1. **JSON-LD Discovery**: Extract all `<script type="application/ld+json">` blocks from live pages
2. **Syntax Validation**: Verify JSON-LD parses correctly
3. **Type Coverage**: Check which Schema.org types are present vs applicable
4. **Required Properties**: Validate Google's required properties per type
5. **Recommended Properties**: Check for recommended properties that improve rich results
6. **Rich Results Eligibility**: Per-type assessment of eligibility
7. **Entity Graph**: Evaluate @id usage and cross-page entity linking
8. **CMS Detection**: Identify CMS and structured data modules from page output
9. **Quality Scoring**: Composite score (Coverage, Completeness, Validity, Graph Design)

---

## Schema.org Types Analyzed

### High-Impact (Every Site Should Have)
- **Organization** / **LocalBusiness** - Company info, logo, social profiles
- **WebSite** - Site name, search functionality (SearchAction)
- **BreadcrumbList** - Navigation path on all inner pages

### Content-Specific
- **Article** / **BlogPosting** / **NewsArticle** - Blog and news content
- **Event** - Events with dates, location, tickets
- **Product** / **Offer** - Ecommerce products with pricing
- **FAQPage** - Frequently asked questions
- **HowTo** - Step-by-step instructions
- **Service** - Service offerings
- **Person** - Team/staff pages
- **VideoObject** - Video content
- **JobPosting** - Job listings
- **Review** / **AggregateRating** - Reviews and ratings
- **Course** - Educational courses

---

## Related Commands

- **[`/audit-live-site`](audit-live-site.md)** - Comprehensive parallel audit (performance, accessibility, security, quality)
- **[`/audit-perf`](audit-perf.md)** - Core Web Vitals and performance optimization
- **[`/export-audit-csv`](export-audit-csv.md)** - Export audit findings to CSV for project management tools

## Agent Used

**structured-data-specialist** - JSON-LD/Schema.org specialist with expertise in Rich Results validation, cross-page entity graph design, and CMS-specific structured data patterns for Drupal and WordPress.

## What Makes This Different

**Before (manual structured data audit):**
- Manually inspect page source for JSON-LD
- Check one page at a time
- Miss cross-page entity linking opportunities
- No scoring or prioritization
- Generic recommendations

**With structured-data-specialist:**
- Automated extraction from live pages via Chrome DevTools
- Sitemap-based discovery covers the full site
- Quality scoring and grading (A-F)
- Rich Results validation against Google's requirements
- Cross-page entity graph design with @id conventions
- Concrete JSON-LD examples tailored to your actual content
- CMS-specific module/plugin recommendations
- Prioritized by business impact (Critical/High/Medium/Low)

---

## Exporting to Project Management Tools

After audit completes, export findings as CSV:

```bash
/export-audit-csv [report-filename]
```

Generates Teamwork-compatible CSV for importing tasks into project management tools (also works with Jira, Monday, Linear).
