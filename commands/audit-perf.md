---
description: Comprehensive performance analysis and Core Web Vitals optimization using performance specialist
argument-hint: "[options]"
allowed-tools: Task, Bash(git:*)
---

Spawn the **performance-specialist** agent using:

```
Task(cms-cultivator:performance-specialist:performance-specialist,
     prompt="Analyze performance and optimize Core Web Vitals (LCP, INP, CLS) with the following parameters:
       - Depth mode: [quick/standard/comprehensive - parsed from arguments, default: standard]
       - Scope: [current-pr/module/file/entire - parsed from arguments, default: entire]
       - Format: [report/json/summary/checklist - parsed from arguments, default: report]
       - Target threshold: [good/needs-improvement - parsed from arguments, optional]
       - Focus area: [use legacy focus argument if provided, otherwise 'complete analysis']
       - Files to analyze: [file list based on scope]
     Check database queries, caching strategies, asset optimization, and rendering for both Drupal and WordPress projects. Save the comprehensive audit report to a file (audit-perf-YYYY-MM-DD-HHMM.md) and present the file path to the user.")
```

## Arguments

This command supports flexible argument modes for different use cases:

### Depth Modes
- `--quick` - Core Web Vitals only (~5 min) - LCP, INP, CLS status check
- `--standard` - CWV + major bottlenecks (default, ~15 min) - Comprehensive performance audit
- `--comprehensive` - Full profiling + recommendations (~30 min) - Deep analysis with detailed optimizations

### Scope Control
- `--scope=current-pr` - Only files changed in current PR (uses git diff)
- `--scope=module=<name>` - Specific module/directory (e.g., `--scope=module=src/api`)
- `--scope=file=<path>` - Single file (e.g., `--scope=file=src/queries.php`)
- `--scope=frontend` - Only frontend files (assets, CSS, JS, images)
- `--scope=backend` - Only backend files (database queries, caching, API)
- `--scope=entire` - Full codebase (default)

### Output Formats
- `--format=report` - Detailed report with metrics and recommendations (default)
- `--format=json` - Structured JSON for CI/CD integration
- `--format=summary` - Executive summary with key findings
- `--format=metrics` - Core Web Vitals metrics only (LCP, INP, CLS scores)

### Target Thresholds
- `--target=good` - Report only if metrics fail "good" thresholds (LCP > 2.5s, INP > 200ms, CLS > 0.1)
- `--target=needs-improvement` - Report if metrics need improvement (LCP > 4.0s, INP > 500ms, CLS > 0.25)

### Legacy Focus Areas (Still Supported)
For backward compatibility, single-word focus areas without `--` prefix are treated as legacy focus filters:
- `queries` - Focus on database query optimization
- `n+1` - Focus on N+1 query detection
- `assets` - Focus on asset optimization (images, fonts, CSS, JS)
- `bundles` - Focus on JavaScript bundle analysis
- `caching` - Focus on caching strategy review
- `vitals` - Focus on Core Web Vitals (LCP, INP, CLS)
- `lcp` - Focus on Largest Contentful Paint
- `inp` - Focus on Interaction to Next Paint
- `cls` - Focus on Cumulative Layout Shift

## Usage Examples

### Quick Checks
```bash
# Quick Core Web Vitals check on your changes
/audit-perf --quick --scope=current-pr

# Quick metrics check with JSON output
/audit-perf --quick --format=metrics

# Quick frontend performance check
/audit-perf --quick --scope=frontend
```

### Standard Audits
```bash
# Standard audit (same as legacy `/audit-perf`)
/audit-perf

# Standard audit on PR changes
/audit-perf --scope=current-pr

# Standard audit with JSON for CI/CD
/audit-perf --standard --format=json

# Backend performance audit
/audit-perf --standard --scope=backend
```

### Comprehensive Audits
```bash
# Comprehensive pre-release audit
/audit-perf --comprehensive

# Comprehensive audit with executive summary
/audit-perf --comprehensive --format=summary

# Comprehensive audit with target threshold
/audit-perf --comprehensive --target=good
```

### Legacy Syntax (Still Works)
```bash
# Focus on specific area (legacy)
/audit-perf queries
/audit-perf vitals
/audit-perf assets

# Combine legacy focus with new modes
/audit-perf queries --quick
/audit-perf vitals --scope=current-pr
```

## Usage

**Full Audit:**
- `/audit-perf` - Complete performance analysis across all areas

**Focus Areas:**
- `/audit-perf queries` - Database query optimization
- `/audit-perf n+1` - N+1 query detection and fixes
- `/audit-perf assets` - Asset optimization (images, fonts, CSS, JS)
- `/audit-perf bundles` - JavaScript bundle analysis
- `/audit-perf caching` - Caching strategy review

**Core Web Vitals:**
- `/audit-perf vitals` - Check all Core Web Vitals (LCP, INP/FID, CLS)
- `/audit-perf lcp` - Largest Contentful Paint optimization
- `/audit-perf inp` - Interaction to Next Paint optimization
- `/audit-perf fid` - First Input Delay optimization (legacy)
- `/audit-perf cls` - Cumulative Layout Shift fixes

**Reporting:**
- `/audit-perf lighthouse` - Generate Lighthouse performance report
- `/audit-perf report` - Generate stakeholder-friendly performance report

**Quick Code Analysis:**
For quick performance analysis of specific queries or functions during conversation, the **performance-analyzer** Agent Skill auto-activates when you mention "slow" or "optimize". See: [`skills/performance-analyzer/SKILL.md`](../skills/performance-analyzer/SKILL.md)

---

## Tool Usage

**Allowed operations:**
- ✅ Spawn performance-specialist agent
- ✅ Run Lighthouse for Core Web Vitals analysis
- ✅ Analyze database queries and caching strategies
- ✅ Check asset optimization (CSS, JS, images)
- ✅ Review code for performance anti-patterns
- ✅ Generate performance reports with optimization recommendations

**Not allowed:**
- ❌ Do not modify code directly (provide optimizations in report)
- ❌ Do not run load testing or stress testing
- ❌ Do not install performance tools (suggest installation if needed)

The performance-specialist agent performs all audit operations.

---

## How It Works

This command spawns the **performance-specialist** agent, which uses the **performance-analyzer** skill and performs comprehensive performance audits focused on Core Web Vitals.

### 1. Parse Arguments

The command first parses the arguments to determine the audit parameters:

**Depth mode:**
- Check for `--quick`, `--standard`, or `--comprehensive` flags
- Default: `--standard` (if not specified)

**Scope:**
- Check for `--scope=<value>` flag
- If `--scope=current-pr`: Get changed files using `git diff --name-only origin/main...HEAD`
- If `--scope=frontend`: Target CSS, JS, images, fonts
- If `--scope=backend`: Target PHP, database queries, caching
- If `--scope=module=<name>`: Target specific directory
- If `--scope=file=<path>`: Target single file
- Default: `--scope=entire` (analyze entire codebase)

**Format:**
- Check for `--format=<value>` flag
- Options: `report` (default), `json`, `summary`, `metrics`
- Default: `--format=report`

**Target threshold:**
- Check for `--target=<value>` flag
- Options: `good` (strict), `needs-improvement` (moderate)
- Used for CI/CD pass/fail criteria

**Legacy focus area:**
- If argument doesn't start with `--`, treat as legacy focus area
- Examples: `queries`, `n+1`, `assets`, `vitals`, `lcp`, `inp`, `cls`
- Can be combined with new flags: `/audit-perf queries --quick`

### 2. Determine Files to Analyze

Based on the scope parameter:

**For `current-pr`:**
```bash
git diff --name-only origin/main...HEAD | grep -E '\.(php|tsx?|jsx?|css|scss|sql)$'
```

**For `frontend`:**
```bash
find . -type f \( -name "*.css" -o -name "*.scss" -o -name "*.js" -o -name "*.tsx" -o -name "*.jsx" \)
```

**For `backend`:**
```bash
find . -type f \( -name "*.php" -o -name "*.sql" \)
```

**For `module=<name>` or `file=<path>`:**
Analyze the specified directory or single file.

**For `entire`:**
Analyze all relevant files in the codebase.

### 3. Spawn Performance Specialist

Pass all parsed parameters to the agent:
```
Task(cms-cultivator:performance-specialist:performance-specialist,
     prompt="Run performance audit focused on Core Web Vitals with:
       - Depth mode: {depth}
       - Scope: {scope}
       - Format: {format}
       - Target threshold: {target or 'none'}
       - Focus area: {focus or 'complete analysis'}
       - Files to analyze: {file_list}")
```

### The Performance Specialist Will

1. **Analyze Core Web Vitals**:
   - **LCP** (Largest Contentful Paint) - Target < 2.5s
   - **INP** (Interaction to Next Paint) - Target < 200ms
   - **CLS** (Cumulative Layout Shift) - Target < 0.1
   - **FCP** (First Contentful Paint), **TTFB** (Time to First Byte)

2. **Optimize database performance**:
   - Identify slow queries (> 100ms)
   - Detect N+1 query patterns
   - Recommend indexes and query optimization
   - Check for unnecessary JOINs and SELECT *

3. **Analyze asset performance**:
   - Image optimization (WebP/AVIF, lazy loading, responsive images)
   - CSS optimization (critical CSS, unused CSS, minification)
   - JavaScript optimization (code splitting, tree shaking, bundle size)
   - Font optimization (font-display, subsetting, preloading)

4. **Review caching strategy**:
   - Browser caching (Cache-Control headers)
   - Application caching (CMS-specific)
   - CDN configuration
   - Cache invalidation patterns

5. **Platform-specific analysis**:
   - **Drupal**: Cache tags, EntityQuery, Views, render arrays, BigPipe
   - **WordPress**: Transients, WP_Query, object cache, fragment caching

6. **Generate actionable reports**:
   - Core Web Vitals status with pass/fail thresholds
   - Prioritized optimizations by impact
   - Code examples (before/after)
   - Performance budget recommendations

---

## Core Web Vitals Explained

### Largest Contentful Paint (LCP) - Target: < 2.5s

**What it measures**: Time until the largest content element (image, text block) renders.

**Common issues**:
- Slow server response time (TTFB > 600ms)
- Render-blocking resources (CSS, JS)
- Large resource size (images > 500KB)
- Client-side rendering delays

**Optimizations**:
- Reduce server response time (caching, database optimization)
- Eliminate render-blocking resources (inline critical CSS, defer JS)
- Optimize LCP resource (compress images, use modern formats)
- Use CDN for faster delivery

### Interaction to Next Paint (INP) - Target: < 200ms

**What it measures**: Responsiveness to user interactions throughout page life.

**Common issues**:
- Long JavaScript execution tasks (> 50ms)
- Heavy event handlers
- Main thread blocking
- Unoptimized frameworks

**Optimizations**:
- Split long tasks into smaller chunks
- Defer non-critical JavaScript
- Use web workers for heavy computation
- Debounce/throttle event handlers
- Optimize JavaScript execution

### Cumulative Layout Shift (CLS) - Target: < 0.1

**What it measures**: Visual stability - unexpected layout shifts during loading.

**Common issues**:
- Images without dimensions (width/height)
- Web fonts causing text shifts
- Dynamic content injection without reserved space
- Ads/iframes without dimensions

**Optimizations**:
- Set explicit width/height on images
- Use font-display: swap with fallback font metrics
- Reserve space for dynamic content (ads, embeds)
- Use CSS aspect-ratio or min-height
- Avoid inserting content above existing content

---

## Performance Analysis Areas

### Database Performance

**What gets checked**:
- Query execution time (slow queries > 100ms)
- N+1 query patterns (queries in loops)
- Missing indexes
- Unnecessary JOINs
- SELECT * queries
- Query result caching

**CMS-specific**:
- **Drupal**: EntityQuery usage, Views configuration, cache tags
- **WordPress**: WP_Query optimization, transient caching, meta queries

### Asset Performance

**Images**:
- File sizes and format (recommend WebP/AVIF)
- Responsive images (srcset, sizes)
- Lazy loading implementation
- Missing width/height attributes

**CSS**:
- Total size and unused CSS
- Render-blocking stylesheets
- Critical CSS extraction
- Minification and compression

**JavaScript**:
- Bundle sizes and composition
- Unused code
- Code splitting opportunities
- Render-blocking scripts

**Fonts**:
- Font file sizes
- font-display strategy
- Font subsetting
- Preload critical fonts

### Caching Strategy

**Browser Caching**:
- Cache-Control headers
- Cache durations
- Cache versioning/busting

**Application Caching**:
- **Drupal**: Cache tags, contexts, max-age, BigPipe
- **WordPress**: Transients, object cache, page cache
- Fragment caching
- Cache invalidation logic

**CDN**:
- CDN configuration
- Asset delivery
- Edge caching

---

## Output Formats

### Comprehensive Audit Report

```markdown
# Performance Audit Report

**Performance Score**: [0-100]

**Core Web Vitals**:
- LCP: [X]s ([Pass/Needs Improvement/Poor])
- INP: [X]ms ([Pass/Needs Improvement/Poor])
- CLS: [X] ([Pass/Needs Improvement/Poor])

## Critical Issues (High Impact)
[Issues severely impacting performance - fix immediately]

## High Priority Optimizations
[Significant improvements - address soon]

## Medium Priority Optimizations
[Moderate impact - plan for future]

## Performance Budget
[Recommended targets for page weight, requests, Core Web Vitals]

## Priority Actions
[Ordered list with effort estimates and expected impact]
```

### Focus Area Reports

When using focused checks (`/audit-perf queries`, `/audit-perf assets`, etc.), the performance specialist provides detailed analysis for that specific area only.

### Core Web Vitals Report

Focused report on LCP, INP, and CLS with specific optimizations for each metric.

### Lighthouse Report

Comprehensive Lighthouse audit with all metrics, opportunities, and diagnostics.

### Stakeholder Report

Executive-friendly report with business impact (conversion rates, revenue), competitor comparison, ROI analysis, and phased remediation roadmap.

---

## CMS-Specific Optimizations

### Drupal Performance

**Cache System**:
```php
// Proper cache configuration
$build['#cache'] = [
  'tags' => ['node:' . $node->id()],
  'contexts' => ['user.roles', 'url.query_args'],
  'max-age' => 3600,
];
```

**Query Optimization**:
```php
// Efficient EntityQuery
$query = \Drupal::entityQuery('node')
  ->condition('type', 'article')
  ->range(0, 10)
  ->sort('created', 'DESC');
```

**Lazy Builders** (for expensive operations):
```php
$build['expensive'] = [
  '#lazy_builder' => ['my_module.lazy_builder:build', [$id]],
  '#create_placeholder' => TRUE,
];
```

**Common Drupal Issues**:
- Missing cache tags on custom code
- Views without query caching
- Entity loads in loops (N+1)
- BigPipe not utilized
- CSS/JS aggregation disabled

### WordPress Performance

**Transient Caching**:
```php
$data = get_transient('my_expensive_data');
if (false === $data) {
    $data = expensive_function();
    set_transient('my_expensive_data', $data, HOUR_IN_SECONDS);
}
```

**WP_Query Optimization**:
```php
$query = new WP_Query([
    'post_type' => 'post',
    'posts_per_page' => 10,
    'no_found_rows' => true, // Skip pagination count
    'update_post_term_cache' => false, // Skip if not needed
]);
```

**Asset Loading** (defer/async):
```php
wp_enqueue_script(
    'my-script',
    get_template_directory_uri() . '/js/script.js',
    ['jquery'],
    '1.0',
    ['strategy' => 'defer', 'in_footer' => true]
);
```

**Common WordPress Issues**:
- Missing object cache (Redis/Memcached)
- No transient caching
- Assets loaded globally (not conditionally)
- Image lazy loading not implemented
- WP_Query with `posts_per_page => -1` (loads all)

---

## Quick Start (Kanopi Projects)

### Pre-Audit Checks

```bash
# Check code quality
ddev composer phpstan          # Static analysis
ddev composer rector-check     # Code modernization

# Check dependencies
ddev composer audit
ddev exec npm audit
```

### Run Performance Tests

```bash
# Install tools
ddev exec npm install --save-dev lighthouse @lhci/cli webpack-bundle-analyzer

# Run Lighthouse
ddev exec npx lighthouse [url] --output html --output-path ./report.html

# Run Lighthouse CI
ddev exec npx lhci autorun

# Analyze bundles
ddev exec npx webpack-bundle-analyzer

# Custom performance tests
ddev composer test-performance
```

---

## Performance Testing Tools

**Automated Tools**:
- **Lighthouse** - Comprehensive audit (built into Chrome)
- **WebPageTest** - Real-world performance testing
- **Chrome DevTools** - Performance panel and profiling
- **PageSpeed Insights** - Google's analysis tool

**Monitoring Tools**:
- **Google Analytics 4** - Core Web Vitals tracking
- **New Relic** - Application performance monitoring
- **Datadog** - Full-stack monitoring

**Analysis Tools**:
- **Webpack Bundle Analyzer** - JavaScript bundle analysis
- **Coverage Tool** - Unused code detection
- **Chrome DevTools Coverage** - CSS/JS coverage

**Testing Conditions**:
- Test on 3G/4G networks (throttling)
- Test on low-end devices
- Test from different geographic locations
- Test with cache disabled and enabled

---

## Performance Budgets

The performance specialist recommends budgets based on industry standards:

| Metric | Budget | Impact |
|--------|--------|--------|
| LCP | < 2.5s | Pass Core Web Vitals |
| INP | < 200ms | Pass Core Web Vitals |
| CLS | < 0.1 | Pass Core Web Vitals |
| Total JS | < 200KB | Faster page load |
| Total CSS | < 100KB | Reduced render blocking |
| Images | < 1MB | Faster LCP |
| Requests | < 50 | Reduced connection overhead |

**Research shows**:
- 100ms improvement = +1% conversion
- Amazon: 100ms delay = 1% revenue loss
- Google: 500ms slower = 20% traffic loss

---

## Related Commands

- **[`/pr-create`](pr-create.md)** - PR creation includes performance checks
- **[`/pr-review`](pr-review.md)** - PR reviews include performance analysis
- **[`/audit-live-site`](audit-live-site.md)** - Comprehensive audits include performance

## Agent Used

**performance-specialist** - Core Web Vitals specialist with expertise in database optimization, caching strategies, and CMS-specific performance patterns for Drupal and WordPress.

## What Makes This Different

**Before (manual perf review):**
- Run Lighthouse yourself
- Miss CMS-specific optimizations
- No database query analysis
- Generic recommendations

**With performance-specialist:**
- ✅ Comprehensive Core Web Vitals analysis
- ✅ CMS-specific optimization (Drupal/WordPress)
- ✅ Database query optimization and N+1 detection
- ✅ Caching strategy review
- ✅ Asset optimization with bundle analysis
- ✅ Performance budget recommendations
- ✅ Prioritized fixes by impact
- ✅ Code examples (before/after)
- ✅ Stakeholder reports with ROI

---

## Exporting to Project Management Tools

After audit completes, export findings as CSV:

```bash
/export-audit-csv [report-filename]
```

Generates Teamwork-compatible CSV for importing tasks into project management tools (also works with Jira, Monday, Linear).
