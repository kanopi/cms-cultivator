---
description: Comprehensive performance analysis and Core Web Vitals optimization
argument-hint: "[focus-area]"
allowed-tools: Read, Glob, Grep, Bash(npm:*), Bash(ddev exec npm:*), Bash(lighthouse:*), WebFetch
---

You are helping perform comprehensive performance analysis and optimization for web applications. This command combines performance auditing, Core Web Vitals optimization, Lighthouse reporting, and stakeholder reporting.

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

---

## MODE 1: Full Performance Audit (`/audit-perf`)

Run comprehensive performance analysis across all areas.

### Step 1: Identify Scope

- If a URL is provided, analyze that specific page
- If no URL, analyze recently changed files using `git diff`
- Look for performance-critical files: controllers, queries, templates, assets

### Step 2: Analyze All Performance Areas

#### Database Performance

**Query Optimization:**
- Check for slow queries (> 100ms)
- Identify missing indexes
- Look for SELECT * queries
- Check for unnecessary JOINs
- Verify proper query caching

**N+1 Query Detection:**
- Look for queries inside loops
- Check for missing eager loading
- Identify lazy loading issues
- Find unnecessary duplicate queries

**Drupal-Specific:**
- EntityQuery optimization
- Views query performance
- Database API usage
- Cache tag invalidation patterns

**WordPress-Specific:**
- WP_Query optimization
- Custom query analysis
- Transient usage
- Object cache implementation

#### Asset Performance

**Images:**
- Check image sizes (recommend WebP/AVIF)
- Verify responsive images
- Look for missing width/height attributes
- Check for lazy loading
- Identify oversized images

**CSS:**
- Check for unused CSS
- Identify render-blocking stylesheets
- Look for CSS file sizes (> 50KB warning)
- Check for critical CSS extraction
- Verify CSS minification

**JavaScript:**
- Check bundle sizes (> 200KB warning)
- Identify render-blocking scripts
- Look for unused JavaScript
- Check for code splitting
- Verify script minification and compression

**Fonts:**
- Check font file sizes
- Verify font-display strategy
- Look for font subsetting
- Check for local font hosting

#### Bundle Analysis

**JavaScript Bundles:**
- Analyze bundle composition
- Identify large dependencies
- Look for duplicate code
- Check for tree-shaking opportunities
- Verify dynamic imports

**Code Splitting:**
- Check for route-based splitting
- Look for component-level splitting
- Verify lazy loading implementation

#### Caching Strategy

**Browser Caching:**
- Check Cache-Control headers
- Verify cache durations
- Look for cache-busting strategies
- Check ETags implementation

**Application Caching:**
- Drupal: Cache tags, contexts, max-age
- WordPress: Transients, object cache
- Check for cache invalidation logic
- Verify fragment caching

**CDN Usage:**
- Check for CDN configuration
- Verify asset CDN delivery
- Look for edge caching

### Step 3: Core Web Vitals Analysis

**Largest Contentful Paint (LCP) - Target: < 2.5s**
- Identify LCP element
- Check server response time
- Analyze resource load time
- Look for render-blocking resources
- Check for lazy loading issues

**Interaction to Next Paint (INP) - Target: < 200ms**
- Identify long tasks (> 50ms)
- Check JavaScript execution time
- Look for input delay issues
- Analyze event handler performance

**First Input Delay (FID) - Target: < 100ms (legacy)**
- Check main thread blocking
- Analyze JavaScript execution
- Look for heavy event handlers

**Cumulative Layout Shift (CLS) - Target: < 0.1**
- Check for missing dimensions
- Look for dynamic content injection
- Identify font loading shifts
- Check for ad/iframe shifts

### Step 4: Output Comprehensive Report

```markdown
# Performance Audit Report

**Scope**: [URL or files audited]
**Date**: [current date]
**Performance Budget**: [if defined]

---

## Executive Summary

**Overall Performance Score**: [0-100]

**Core Web Vitals**:
- LCP: [X]s ([Pass/Needs Improvement/Poor])
- INP: [X]ms ([Pass/Needs Improvement/Poor])
- CLS: [X] ([Pass/Needs Improvement/Poor])

**Critical Issues**: [count]
**Warnings**: [count]
**Opportunities**: [count]

**Estimated Impact**: [X]s faster load time, [Y]% better user experience

---

## Core Web Vitals 🎯

### Largest Contentful Paint (LCP): [X]s
**Target**: < 2.5s (Good), < 4.0s (Needs Improvement)
**Status**: [✅ Pass / ⚠️ Needs Improvement / ❌ Poor]

**LCP Element**: [description]
**Location**: `path/to/file:line`

**Issues**:
1. [Issue description]
   - Impact: +[X]s
   - Fix: [How to improve]

**Optimizations**:
- Reduce server response time: -[X]s
- Eliminate render-blocking resources: -[X]s
- Optimize LCP resource load time: -[X]s
- Implement critical CSS: -[X]s

---

### Interaction to Next Paint (INP): [X]ms
**Target**: < 200ms (Good), < 500ms (Needs Improvement)
**Status**: [✅ Pass / ⚠️ Needs Improvement / ❌ Poor]

**Long Tasks**: [count] tasks > 50ms

**Issues**:
1. [Issue description]
   - Duration: [X]ms
   - Location: `path/to/file:line`
   - Fix: [How to improve]

**Optimizations**:
- Split long tasks: -[X]ms
- Defer non-critical JavaScript: -[X]ms
- Optimize event handlers: -[X]ms
- Use web workers: -[X]ms

---

### Cumulative Layout Shift (CLS): [X]
**Target**: < 0.1 (Good), < 0.25 (Needs Improvement)
**Status**: [✅ Pass / ⚠️ Needs Improvement / ❌ Poor]

**Layout Shifts**: [count] shifts detected

**Issues**:
1. [Element causing shift]
   - Shift value: [X]
   - Location: `path/to/file:line`
   - Fix: [How to fix]

**Optimizations**:
- Add width/height to images: -[X] CLS
- Reserve space for dynamic content: -[X] CLS
- Optimize font loading: -[X] CLS
- Fix ad/iframe dimensions: -[X] CLS

---

## Critical Issues 🔴

### Issue 1: [Issue Title]
**Category**: [Queries / Assets / Caching / etc.]
**Impact**: High - [X]s slower, [Y]% of users affected
**Location**: `path/to/file.php:123`

**Problem**:
[Clear description of the performance issue]

**Metrics**:
- Current: [measurement]
- Target: [target value]
- Impact: [estimated improvement]

**Current Code**:
```php
[problematic code]
```

**Optimized Code**:
```php
[optimized code]
```

**Implementation Steps**:
1. [Step-by-step fix instructions]

**Estimated Impact**: -[X]s load time

---

## Warnings ⚠️

[Same format as critical issues but lower priority]

---

## Opportunities 💡

[Optimization suggestions that aren't critical but would improve performance]

---

## Database Performance 🗄️

**Query Statistics**:
- Total queries: [count]
- Slow queries (> 100ms): [count]
- Average query time: [X]ms
- N+1 queries detected: [count]

### Slow Queries

**Query 1**: [X]ms
```sql
[query]
```
**Location**: `path/to/file:line`
**Fix**: [Add index, optimize JOIN, etc.]

### N+1 Queries

**Location**: `Controller.php:45`
```php
// Before - N+1 query
foreach ($posts as $post) {
    $author = $post->getAuthor(); // Query per post
}

// After - Eager loading
$posts = Post::with('author')->get(); // Single query
```

**Estimated Impact**: [X] queries eliminated, -[Y]ms

---

## Asset Performance 📦

### Images

**Total Size**: [X]MB
**Recommendations**:
- [ ] Convert to WebP/AVIF format
- [ ] Implement responsive images
- [ ] Add lazy loading
- [ ] Compress images (target: 80% quality)

**Largest Images**:
1. `image.jpg` - [X]MB (recommend [Y]KB)
2. `hero.png` - [X]MB (recommend [Y]KB)

### CSS

**Total Size**: [X]KB (minified)
**Unused CSS**: [Y]KB ([Z]%)

**Recommendations**:
- [ ] Extract critical CSS
- [ ] Remove unused CSS
- [ ] Defer non-critical CSS
- [ ] Minify and compress

**Render-Blocking Stylesheets**:
- `style.css` - [X]KB - Delays LCP by [Y]ms

### JavaScript

**Total Size**: [X]KB (minified)
**Unused JS**: [Y]KB ([Z]%)

**Bundle Analysis**:
- Main bundle: [X]KB
- Vendor bundle: [Y]KB
- Total bundles: [Z]

**Recommendations**:
- [ ] Implement code splitting
- [ ] Remove unused dependencies
- [ ] Defer non-critical scripts
- [ ] Minify and compress

**Largest Dependencies**:
1. `library-name` - [X]KB
2. `another-lib` - [Y]KB

---

## Caching Strategy 💾

### Browser Caching

**Cache Headers**:
- Static assets: [cache duration]
- HTML: [cache duration]
- API responses: [cache duration]

**Issues**:
- [ ] Missing Cache-Control headers on [files]
- [ ] Short cache duration on static assets
- [ ] No cache versioning strategy

### Application Caching

**Drupal**:
- [ ] Cache tags properly implemented
- [ ] Cache contexts optimized
- [ ] Cache max-age configured
- [ ] BigPipe/ESI for dynamic content

**WordPress**:
- [ ] Transients properly used
- [ ] Object cache configured
- [ ] Fragment caching implemented
- [ ] Page caching strategy

**Recommendations**:
1. [Specific caching improvement]
2. [Another recommendation]

---

## Performance Budget 📊

| Metric | Current | Budget | Status |
|--------|---------|--------|--------|
| LCP | [X]s | 2.5s | [✅/⚠️/❌] |
| INP | [X]ms | 200ms | [✅/⚠️/❌] |
| CLS | [X] | 0.1 | [✅/⚠️/❌] |
| Total JS | [X]KB | 200KB | [✅/⚠️/❌] |
| Total CSS | [X]KB | 50KB | [✅/⚠️/❌] |
| Images | [X]MB | 1MB | [✅/⚠️/❌] |
| Requests | [X] | 50 | [✅/⚠️/❌] |

---

## Testing Recommendations

### Manual Testing
- [ ] Test on 3G/4G network
- [ ] Test on low-end devices
- [ ] Monitor real user metrics (RUM)
- [ ] Use Chrome DevTools Performance panel

### Automated Testing
```bash
# Lighthouse CI
npm run lighthouse:ci

# WebPageTest
npm run webpagetest

# Custom performance tests
npm run test:perf
```

---

## Priority Actions

**Week 1 (Critical):**
1. [Most impactful fix] - Est: -[X]s
2. [Second priority] - Est: -[X]s
3. [Third priority] - Est: -[X]s

**Week 2-3 (High Priority):**
1. [Important improvements]
2. [Additional optimizations]

**Week 4+ (Enhancements):**
1. [Nice-to-have optimizations]

**Total Estimated Impact**: -[X]s load time, +[Y] performance score

---

## Resources

- [Lighthouse Documentation](https://developers.google.com/web/tools/lighthouse)
- [Web Vitals](https://web.dev/vitals/)
- [WebPageTest](https://www.webpagetest.org/)
- [Chrome DevTools Performance](https://developer.chrome.com/docs/devtools/performance/)
```

---

## MODE 2: Focus Area Analysis (`/audit-perf [focus]`)

### Database Queries (`/audit-perf queries`)

Analyze database query performance and optimization opportunities.

**What to Check:**
- Slow queries (> 100ms)
- Missing indexes
- Unnecessary SELECT *
- Complex JOINs
- Query caching

**Output:**
```markdown
## Database Query Performance

**Total Queries**: [count]
**Average Query Time**: [X]ms
**Slow Queries**: [count] (> 100ms)

### Critical Slow Queries

**Query 1**: [X]ms - `posts.php:45`
```sql
SELECT * FROM posts
JOIN users ON posts.user_id = users.id
JOIN comments ON posts.id = comments.post_id
WHERE posts.status = 'published'
ORDER BY posts.created_at DESC
LIMIT 10
```

**Issues**:
- SELECT * pulls unnecessary columns
- Missing index on `posts.status`
- Unnecessary JOIN with comments

**Optimized**:
```sql
-- Add index
CREATE INDEX idx_posts_status ON posts(status);

-- Optimize query
SELECT posts.id, posts.title, posts.slug, users.name
FROM posts
JOIN users ON posts.user_id = users.id
WHERE posts.status = 'published'
ORDER BY posts.created_at DESC
LIMIT 10
```

**Impact**: [X]ms → [Y]ms (-[Z]% faster)

### Recommendations
1. Add indexes on frequently queried columns
2. Use SELECT with specific columns
3. Implement query result caching
4. Consider denormalization for read-heavy queries
```

---

### N+1 Queries (`/audit-perf n+1`)

Detect and fix N+1 query problems.

**What to Check:**
- Queries inside loops
- Missing eager loading
- Lazy loading issues
- Duplicate queries

**Output:**
```markdown
## N+1 Query Detection

**N+1 Patterns Found**: [count]
**Total Extra Queries**: [count]
**Estimated Impact**: -[X]ms with fixes

### Pattern 1: Post Authors

**Location**: `PostController.php:45`
**Severity**: High
**Extra Queries**: 50 (one per post)

**Current Code (N+1)**:
```php
$posts = Post::all(); // 1 query

foreach ($posts as $post) {
    echo $post->author->name; // N queries (50 queries)
}
// Total: 51 queries
```

**Fixed Code (Eager Loading)**:
```php
$posts = Post::with('author')->get(); // 2 queries total

foreach ($posts as $post) {
    echo $post->author->name; // No additional queries
}
// Total: 2 queries
```

**Impact**: 51 queries → 2 queries (-96% queries, -[X]ms)

### Drupal-Specific Fixes

**Entity Loading**:
```php
// Before - N+1
foreach ($nids as $nid) {
    $node = Node::load($nid); // Query per node
}

// After - Batch loading
$nodes = Node::loadMultiple($nids); // Single query
```

### WordPress-Specific Fixes

**WP_Query**:
```php
// Before - N+1
$posts = get_posts();
foreach ($posts as $post) {
    $thumbnail = get_the_post_thumbnail($post->ID); // Query per post
}

// After - Prime cache
$posts = get_posts();
update_post_thumbnail_cache(wp_list_pluck($posts, 'ID'));
foreach ($posts as $post) {
    $thumbnail = get_the_post_thumbnail($post->ID); // From cache
}
```

### Summary
- Total N+1 patterns: [count]
- Queries eliminated: [count]
- Performance improvement: -[X]ms
```

---

### Asset Optimization (`/audit-perf assets`)

Analyze and optimize static assets.

**Output:**
```markdown
## Asset Performance Analysis

### Summary
- Total Assets: [count]
- Total Size: [X]MB
- Unoptimized Assets: [count]
- Potential Savings: [Y]MB ([Z]%)

### Images

**Total**: [count] images, [X]MB
**Unoptimized**: [count] images

**Recommendations**:
1. Convert to modern formats (WebP/AVIF)
2. Implement responsive images
3. Add lazy loading
4. Compress to 80% quality

**Largest Images**:
| Image | Current | Optimized | Savings |
|-------|---------|-----------|---------|
| hero.jpg | 2.5MB | 150KB | -94% |
| product.png | 1.2MB | 80KB | -93% |

**Fix**:
```html
<!-- Before -->
<img src="hero.jpg" alt="Hero">

<!-- After -->
<picture>
  <source srcset="hero.avif" type="image/avif">
  <source srcset="hero.webp" type="image/webp">
  <img src="hero.jpg" alt="Hero"
       width="1920" height="1080"
       loading="lazy">
</picture>
```

### CSS

**Total**: [X]KB minified
**Unused CSS**: [Y]KB ([Z]%)

**Recommendations**:
- Extract critical CSS for above-the-fold content
- Remove unused CSS rules
- Defer non-critical stylesheets
- Combine and minify CSS files

**Critical CSS Example**:
```html
<style>
  /* Inline critical CSS */
  .header { ... }
  .hero { ... }
</style>
<link rel="preload" href="styles.css" as="style" onload="this.rel='stylesheet'">
```

### JavaScript

**Total**: [X]KB minified
**Unused JS**: [Y]KB ([Z]%)

**Bundle Analysis**:
- Main: [X]KB
- Vendor: [Y]KB
- Polyfills: [Z]KB

**Recommendations**:
- Implement code splitting
- Use dynamic imports
- Tree shake unused code
- Defer non-critical scripts

**Code Splitting**:
```javascript
// Before - All in one bundle
import HeavyComponent from './HeavyComponent';

// After - Dynamic import
const HeavyComponent = lazy(() => import('./HeavyComponent'));
```

### Fonts

**Total**: [X]KB
**Font Files**: [count]

**Recommendations**:
- Use font-display: swap
- Subset fonts to required characters
- Use system fonts where possible
- Preload critical fonts

**Optimization**:
```css
@font-face {
  font-family: 'CustomFont';
  src: url('font.woff2') format('woff2');
  font-display: swap; /* Prevent invisible text */
  unicode-range: U+0020-00FF; /* Latin subset */
}
```

### Impact Summary
- Images: -[X]MB
- CSS: -[Y]KB
- JavaScript: -[Z]KB
- Fonts: -[W]KB
- **Total Savings**: -[T]MB (-[P]%)
```

---

### Bundle Analysis (`/audit-perf bundles`)

Analyze JavaScript bundle composition and optimization.

**Output:**
```markdown
## JavaScript Bundle Analysis

### Bundle Sizes

| Bundle | Size | Gzipped | Status |
|--------|------|---------|--------|
| main.js | 450KB | 120KB | ⚠️ Large |
| vendor.js | 380KB | 95KB | ⚠️ Large |
| polyfills.js | 45KB | 15KB | ✅ Good |
| **Total** | **875KB** | **230KB** | ❌ Over budget |

**Budget**: 200KB total (gzipped)
**Current**: 230KB (+15% over budget)

### Largest Dependencies

| Package | Size | Usage | Recommendation |
|---------|------|-------|----------------|
| moment.js | 68KB | Date formatting | Replace with date-fns (11KB) |
| lodash | 52KB | Utilities | Import specific functions only |
| chart.js | 48KB | Charts | Lazy load |

### Duplicate Code

**Found**: [count] instances
**Size**: [X]KB
**Savings**: -[Y]KB with deduplication

**Example**:
```javascript
// Both main.js and vendor.js include React
// Deduplicate using proper webpack config
```

### Code Splitting Opportunities

**Route-based Splitting**:
```javascript
// Before - Everything in main bundle
import Dashboard from './Dashboard';
import Admin from './Admin';
import Reports from './Reports';

// After - Split by route
const Dashboard = lazy(() => import('./Dashboard'));
const Admin = lazy(() => import('./Admin'));
const Reports = lazy(() => import('./Reports'));
```

**Estimated Impact**:
- Main bundle: 450KB → 180KB (-60%)
- Initial load: -270KB
- Page load: -[X]s

### Tree Shaking

**Unused Exports Detected**: [count]
**Size**: [X]KB

**Fix**:
```javascript
// Before - Imports entire library
import _ from 'lodash';

// After - Import only what's needed
import debounce from 'lodash/debounce';
import throttle from 'lodash/throttle';
```

### Recommendations

**Immediate Actions**:
1. Replace moment.js with date-fns: -57KB
2. Import lodash functions individually: -40KB
3. Lazy load chart.js: -48KB
4. Implement route-based code splitting: -270KB

**Estimated Impact**: 875KB → 460KB (-47%, -[X]s load time)
```

---

### Caching Strategy (`/audit-perf caching`)

Review and optimize caching implementation.

**Output:**
```markdown
## Caching Strategy Analysis

### Browser Caching

**Cache Headers Analysis**:
| Resource Type | Cache-Control | Status |
|--------------|---------------|--------|
| Static Assets | max-age=31536000 | ✅ Good |
| HTML | no-cache | ✅ Good |
| API | no-store | ⚠️ Could cache |
| Images | max-age=86400 | ⚠️ Too short |
| CSS/JS | max-age=3600 | ❌ Too short |

**Issues**:
1. CSS/JS should have longer cache (1 year with versioning)
2. Images should have longer cache
3. API responses could use short-term caching

**Fix**:
```apache
# .htaccess
<IfModule mod_expires.c>
  ExpiresActive On
  ExpiresByType image/* "access plus 1 year"
  ExpiresByType text/css "access plus 1 year"
  ExpiresByType application/javascript "access plus 1 year"
  ExpiresByType text/html "access plus 0 seconds"
</IfModule>

<IfModule mod_headers.c>
  <FilesMatch "\.(js|css|jpg|jpeg|png|gif|svg|woff|woff2)$">
    Header set Cache-Control "public, max-age=31536000, immutable"
  </FilesMatch>
</IfModule>
```

### Application Caching

**Drupal Analysis**:
```php
// Current Issues
- Missing cache tags on custom controllers
- No cache contexts for user-specific content
- Cache max-age not set appropriately

// Recommendations
public function build() {
  $build = [
    '#markup' => $this->generateContent(),
    '#cache' => [
      'tags' => ['node_list', 'taxonomy_term_list'],
      'contexts' => ['user.roles', 'url.query_args'],
      'max-age' => 3600,
    ],
  ];
  return $build;
}
```

**WordPress Analysis**:
```php
// Current Issues
- Transients not used for expensive queries
- No object cache implementation
- Missing fragment caching

// Recommendations
// Use transients for expensive queries
$results = get_transient('expensive_query_' . $args_hash);
if (false === $results) {
  $results = $wpdb->get_results($expensive_query);
  set_transient('expensive_query_' . $args_hash, $results, HOUR_IN_SECONDS);
}

// Implement object cache (Redis/Memcached)
wp_cache_set('key', $value, 'group', 3600);
$value = wp_cache_get('key', 'group');
```

### CDN Configuration

**Current Setup**: [CDN provider or None]

**Recommendations**:
- [ ] Enable CDN for static assets
- [ ] Configure edge caching
- [ ] Set appropriate cache rules
- [ ] Implement cache invalidation strategy

### Cache Invalidation

**Current Strategy**: [Manual/Automatic/Time-based]

**Issues**:
- Cache not invalidated on content updates
- No granular invalidation (clears everything)
- Long cache times without versioning

**Drupal Cache Invalidation**:
```php
// Invalidate specific cache tags
Cache::invalidateTags(['node:' . $node->id()]);

// Invalidate all node list caches
Cache::invalidateTags(['node_list']);
```

**WordPress Cache Invalidation**:
```php
// Clear specific transients
delete_transient('expensive_query_' . $args_hash);

// Clear all post-related caches
wp_cache_delete('post_' . $post_id, 'posts');
```

### Impact Analysis

**Current Cache Hit Rate**: [X]%
**Potential Cache Hit Rate**: [Y]%
**Estimated Performance Gain**: -[Z]ms average response time
```

---

## MODE 3: Core Web Vitals (`/audit-perf vitals`)

Check and optimize Core Web Vitals metrics.

**All Vitals (`/audit-perf vitals`)**:
```markdown
## Core Web Vitals Analysis

### Summary
| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| LCP | [X]s | < 2.5s | [✅/⚠️/❌] |
| INP | [X]ms | < 200ms | [✅/⚠️/❌] |
| CLS | [X] | < 0.1 | [✅/⚠️/❌] |

**Overall Status**: [Pass/Needs Improvement/Poor]
**Passing Metrics**: [count]/3
**Estimated Effort**: [X] hours

[Include detailed analysis for each metric as shown in individual sections below]
```

### LCP Optimization (`/audit-perf lcp`)

**Output:**
```markdown
## Largest Contentful Paint (LCP) Optimization

**Current LCP**: [X]s
**Target**: < 2.5s (Good), < 4.0s (Needs Improvement)
**Status**: [✅ Pass / ⚠️ Needs Improvement / ❌ Poor]

### LCP Element
**Element**: [description, e.g., "Hero image"]
**Selector**: `.hero-image`
**Location**: `index.html:45`
**Size**: [X]KB
**Load Time**: [Y]s

### Breakdown

**Total LCP Time**: [X]s
- Server response (TTFB): [A]s
- Resource load delay: [B]s
- Resource load time: [C]s
- Element render delay: [D]s

### Issues & Fixes

#### 1. Slow Server Response ([X]s)
**Issue**: Server taking [X]s to respond
**Target**: < 600ms

**Fixes**:
```php
// Enable opcode caching
opcache.enable=1
opcache.memory_consumption=256

// Use application caching
$cached = Cache::get('homepage');
if (!$cached) {
  $cached = $this->generateHomepage();
  Cache::put('homepage', $cached, 3600);
}
```

**Impact**: -[Y]s

#### 2. Render-Blocking Resources
**Issue**: CSS/JS blocking LCP element

**Fixes**:
```html
<!-- Inline critical CSS -->
<style>
  .hero-image { /* critical styles */ }
</style>

<!-- Preload LCP resource -->
<link rel="preload" as="image" href="hero.jpg">

<!-- Defer non-critical CSS -->
<link rel="preload" href="styles.css" as="style" onload="this.rel='stylesheet'">
```

**Impact**: -[Y]s

#### 3. Large LCP Resource ([X]KB)
**Issue**: LCP image is [X]KB

**Fixes**:
```html
<!-- Optimize image -->
<picture>
  <source srcset="hero-800w.avif 800w,
                  hero-1200w.avif 1200w,
                  hero-1920w.avif 1920w"
          type="image/avif">
  <source srcset="hero-800w.webp 800w,
                  hero-1200w.webp 1200w,
                  hero-1920w.webp 1920w"
          type="image/webp">
  <img src="hero-1920w.jpg"
       srcset="hero-800w.jpg 800w,
               hero-1200w.jpg 1200w,
               hero-1920w.jpg 1920w"
       sizes="100vw"
       alt="Hero"
       width="1920"
       height="1080"
       fetchpriority="high">
</picture>
```

**Impact**: -[Y]s

### Optimization Summary
- Improve server response: -[A]s
- Eliminate render-blocking: -[B]s
- Optimize image: -[C]s
- **Total Improvement**: -[X]s
- **New LCP**: [Y]s ([Pass/Needs Improvement/Poor])
```

### INP Optimization (`/audit-perf inp`)

**Output:**
```markdown
## Interaction to Next Paint (INP) Optimization

**Current INP**: [X]ms
**Target**: < 200ms (Good), < 500ms (Needs Improvement)
**Status**: [✅ Pass / ⚠️ Needs Improvement / ❌ Poor]

### Long Tasks Detected: [count]

### Critical Long Tasks

#### Task 1: JavaScript Execution ([X]ms)
**Location**: `app.js:line 234`
**Duration**: [X]ms
**Impact**: Blocks user interactions

**Issue**:
```javascript
// Heavy synchronous processing
function processData(data) {
  // 500ms of synchronous work
  data.forEach(item => {
    heavyComputation(item);
  });
}
```

**Fix**:
```javascript
// Split into smaller tasks
async function processData(data) {
  for (const item of data) {
    await scheduler.yield(); // Give browser time to respond
    heavyComputation(item);
  }
}

// Or use web worker
const worker = new Worker('processor.js');
worker.postMessage(data);
```

**Impact**: [X]ms → [Y]ms (-[Z]%)

#### Task 2: Event Handler ([X]ms)
**Location**: `EventHandler.js:45`
**Duration**: [X]ms

**Fix**:
```javascript
// Before - Heavy event handler
button.addEventListener('click', () => {
  // Expensive operation (150ms)
  updateUI();
  recalculateLayout();
  fetchData();
});

// After - Debounce and optimize
button.addEventListener('click', debounce(() => {
  // Defer non-critical work
  requestIdleCallback(() => {
    recalculateLayout();
  });

  // Critical only
  updateUI();
  fetchData();
}, 100));
```

**Impact**: -[Y]ms

### Recommendations
1. Split long tasks (> 50ms) into smaller chunks
2. Use web workers for heavy computation
3. Implement debouncing for frequent events
4. Defer non-critical work with requestIdleCallback
5. Optimize JavaScript execution

**Estimated Impact**: [X]ms → [Y]ms (-[Z]%)
```

### CLS Optimization (`/audit-perf cls`)

**Output:**
```markdown
## Cumulative Layout Shift (CLS) Optimization

**Current CLS**: [X]
**Target**: < 0.1 (Good), < 0.25 (Needs Improvement)
**Status**: [✅ Pass / ⚠️ Needs Improvement / ❌ Poor]

### Layout Shifts Detected: [count]

### Critical Shifts

#### Shift 1: Images without dimensions ([shift-value])
**Elements**: [count] images
**Total Shift**: [X]

**Issue**:
```html
<!-- Images without dimensions cause layout shift -->
<img src="product.jpg" alt="Product">
```

**Fix**:
```html
<!-- Add explicit dimensions -->
<img src="product.jpg" alt="Product"
     width="800" height="600">

<!-- Or use aspect-ratio CSS -->
<img src="product.jpg" alt="Product"
     style="aspect-ratio: 4/3;">
```

**Impact**: -[Y] CLS

#### Shift 2: Web Fonts ([shift-value])
**Fonts**: [font names]
**Shift**: [X]

**Issue**: Font loading causes text to re-layout

**Fix**:
```css
/* Use font-display: optional to prevent layout shift */
@font-face {
  font-family: 'CustomFont';
  src: url('font.woff2') format('woff2');
  font-display: optional; /* or 'swap' with fallback metrics */
}

/* Match fallback font metrics */
@font-face {
  font-family: 'CustomFont-fallback';
  src: local('Arial');
  size-adjust: 95%;
  ascent-override: 105%;
  descent-override: 25%;
}

body {
  font-family: 'CustomFont', 'CustomFont-fallback', Arial, sans-serif;
}
```

**Impact**: -[Y] CLS

#### Shift 3: Dynamic Content Injection ([shift-value])
**Location**: `DynamicAd.js:23`
**Shift**: [X]

**Issue**: Ad/content injected without reserved space

**Fix**:
```html
<!-- Reserve space before content loads -->
<div class="ad-container" style="min-height: 250px;">
  <!-- Ad loads here -->
</div>

<style>
  .ad-container {
    min-height: 250px;
    /* Or use aspect-ratio */
    aspect-ratio: 16 / 9;
  }
</style>
```

**Impact**: -[Y] CLS

#### Shift 4: Animations/Transitions ([shift-value])

**Issue**: Using layout-triggering properties

**Fix**:
```css
/* Before - Causes layout shift */
.element {
  transition: height 0.3s;
}

/* After - Use transform (doesn't trigger layout) */
.element {
  transform: scaleY(0);
  transition: transform 0.3s;
}
.element.expanded {
  transform: scaleY(1);
}
```

**Impact**: -[Y] CLS

### Optimization Summary
- Fix images without dimensions: -[A] CLS
- Optimize font loading: -[B] CLS
- Reserve space for dynamic content: -[C] CLS
- Use transform instead of layout properties: -[D] CLS
- **Total Improvement**: -[X] CLS
- **New CLS**: [Y] ([Pass/Needs Improvement/Poor])
```

---

## MODE 4: Lighthouse Report (`/audit-perf lighthouse`)

Generate comprehensive Lighthouse performance report.

**Output:**
```markdown
## Lighthouse Performance Report

**URL**: [tested URL]
**Date**: [date]
**Device**: [Desktop/Mobile]
**Lighthouse Version**: [version]

---

### Performance Score: [X]/100

**Category Scores**:
- Performance: [X]/100
- Accessibility: [X]/100
- Best Practices: [X]/100
- SEO: [X]/100

---

### Metrics

| Metric | Value | Score | Target |
|--------|-------|-------|--------|
| First Contentful Paint | [X]s | [Y] | < 1.8s |
| Largest Contentful Paint | [X]s | [Y] | < 2.5s |
| Total Blocking Time | [X]ms | [Y] | < 200ms |
| Cumulative Layout Shift | [X] | [Y] | < 0.1 |
| Speed Index | [X]s | [Y] | < 3.4s |

---

### Opportunities (Impact on load time)

1. **[Opportunity Title]** - Potential savings: [X]s
   - [Description]
   - [How to fix]

2. **Eliminate render-blocking resources** - Potential savings: [X]s
   - [List of blocking resources]
   - Inline critical CSS, defer non-critical resources

3. **Properly size images** - Potential savings: [X]s
   - [List of oversized images]
   - Serve responsive images, compress images

4. **Minify JavaScript** - Potential savings: [X]KB
   - [List of unminified files]
   - Use build tools to minify code

---

### Diagnostics

- **Total Requests**: [count]
- **Total Size**: [X]MB
- **DOM Size**: [count] elements
- **JavaScript Execution Time**: [X]s
- **Main Thread Work**: [X]s

---

### Passed Audits ✅

- [List of passing audits]

---

### Commands to Run

```bash
# Install Lighthouse
npm install -g lighthouse

# Run Lighthouse
lighthouse https://example.com --output html --output-path ./report.html

# Run Lighthouse CI
npm install -g @lhci/cli
lhci autorun --upload.target=temporary-public-storage

# Lighthouse in Chrome DevTools
# Press F12 > Lighthouse tab > Generate report
```

---

### Recommendations Priority

**High Priority** (largest impact):
1. [Recommendation with biggest impact]
2. [Second highest impact]

**Medium Priority**:
1. [Medium impact items]

**Low Priority** (nice to have):
1. [Lower impact items]

**Estimated Total Impact**: +[X] performance score, -[Y]s load time
```

---

## MODE 5: Stakeholder Report (`/audit-perf report`)

Generate executive-friendly performance report.

**Output:**
```markdown
# Performance Report

**Project**: [Project Name]
**Date**: [Date]
**Prepared By**: [Name]
**Period**: [Time range if applicable]

---

## Executive Summary

### Current Performance

**Overall Status**: [Excellent / Good / Needs Improvement / Poor]

**Core Web Vitals**:
- **LCP**: [X]s - [✅ Pass / ⚠️ Needs Work / ❌ Poor]
- **INP**: [X]ms - [✅ Pass / ⚠️ Needs Work / ❌ Poor]
- **CLS**: [X] - [✅ Pass / ⚠️ Needs Work / ❌ Poor]

**Performance Score**: [X]/100

**Key Findings**:
- [Positive finding or achievement]
- [Main area needing improvement]
- [Impact on business metrics]

---

## Business Impact

### User Experience
- **Page Load Time**: [X]s (Industry avg: [Y]s)
- **Time to Interactive**: [X]s
- **User Satisfaction**: [Estimated based on metrics]

### Conversion & Revenue
- **Bounce Rate Impact**: [X]% users leave if load > 3s
- **Conversion Impact**: 1s improvement = +[Y]% conversion
- **Revenue Impact**: Potential +$[Z] with improvements

**Industry Benchmarks**:
- Amazon: 100ms delay = 1% revenue loss
- Google: 500ms slower = 20% traffic loss
- Your site: [X]s vs competitors [Y]s

---

## Performance Comparison

### Competitor Analysis

| Site | LCP | INP | CLS | Score |
|------|-----|-----|-----|-------|
| Your Site | [X]s | [Y]ms | [Z] | [S] |
| Competitor A | [X]s | [Y]ms | [Z] | [S] |
| Competitor B | [X]s | [Y]ms | [Z] | [S] |
| Industry Avg | [X]s | [Y]ms | [Z] | [S] |

**Ranking**: [Your position] out of [total]

---

## Priority Improvements

### High Impact (Quick Wins)

#### 1. [Improvement Name]
**Business Impact**: High
**Technical Effort**: Low
**Timeline**: 1 week
**Expected Benefit**: -[X]s load time, +[Y]% conversion

**Description**: [Non-technical explanation]

**ROI**: [Estimated return on investment]

#### 2. [Second Priority]
[Same format]

### Medium Impact

[Same format for medium priority items]

### Long-term Enhancements

[Same format for long-term items]

---

## Technical Summary

### Critical Issues: [count]
1. [Issue affecting Core Web Vitals]
2. [Database performance issue]
3. [Asset optimization needed]

### Warnings: [count]
[List of warnings]

### Opportunities: [count]
[List of optimization opportunities]

---

## Recommendations & Roadmap

### Phase 1: Quick Wins (Weeks 1-2)
**Focus**: High-impact, low-effort improvements

**Tasks**:
1. Optimize images: -[X]MB, -[Y]s load time
2. Enable compression: -[Z]KB transfer
3. Implement browser caching: -[W]s repeat visits

**Investment**: [X] hours
**Expected Impact**: -[Y]s load time, +[Z]% performance score
**ROI**: [Estimated conversion/revenue impact]

### Phase 2: Core Improvements (Weeks 3-6)
**Focus**: Address Core Web Vitals failures

**Tasks**:
1. Fix LCP issues: [specific actions]
2. Reduce JavaScript execution: [specific actions]
3. Eliminate layout shifts: [specific actions]

**Investment**: [X] hours
**Expected Impact**: Pass all Core Web Vitals
**ROI**: [Estimated impact]

### Phase 3: Advanced Optimization (Weeks 7-12)
**Focus**: Performance excellence

**Tasks**:
1. Implement advanced caching strategies
2. Optimize critical rendering path
3. Set up performance monitoring

**Investment**: [X] hours
**Expected Impact**: Top-tier performance
**ROI**: [Long-term benefits]

---

## Monitoring & Maintenance

### Real User Monitoring (RUM)
**Recommendation**: Implement RUM to track actual user experience

**Suggested Tools**:
- Google Analytics 4 (Core Web Vitals)
- New Relic
- Datadog
- Custom solution

**Metrics to Track**:
- Core Web Vitals by page
- Performance by device/browser
- Geographic performance
- Conversion correlation

### Performance Budget

**Proposed Budgets**:
| Metric | Current | Budget | Status |
|--------|---------|--------|--------|
| LCP | [X]s | 2.5s | [✅/❌] |
| INP | [X]ms | 200ms | [✅/❌] |
| CLS | [X] | 0.1 | [✅/❌] |
| Page Size | [X]MB | 2MB | [✅/❌] |
| Requests | [X] | 50 | [✅/❌] |

### Ongoing Maintenance

**Monthly Tasks**:
- [ ] Review performance metrics
- [ ] Check for regression
- [ ] Update dependencies
- [ ] Optimize new features

**Quarterly Tasks**:
- [ ] Full performance audit
- [ ] Competitor comparison
- [ ] Performance budget review
- [ ] Technology evaluation

---

## Investment & ROI

### Estimated Investment

**Phase 1**: [X] hours @ $[rate] = $[total]
**Phase 2**: [X] hours @ $[rate] = $[total]
**Phase 3**: [X] hours @ $[rate] = $[total]
**Total**: [X] hours / $[total]

### Expected Returns

**Conversion Impact**:
- Current conversion rate: [X]%
- Expected improvement: +[Y]%
- Additional conversions: +[Z]/month
- Revenue impact: +$[W]/month

**SEO Impact**:
- Core Web Vitals are ranking signals
- Expected organic traffic: +[X]%
- Additional visitors: +[Y]/month

**User Satisfaction**:
- Reduced bounce rate: -[X]%
- Improved engagement: +[Y]%
- Better brand perception

**Total ROI**: [X]x return in [Y] months

---

## Appendix: Technical Details

### Test Methodology
- **Tool**: Lighthouse [version]
- **Device**: [Desktop/Mobile]
- **Network**: [3G/4G/Cable]
- **Location**: [Geographic location]
- **Date**: [Date of test]

### Detailed Metrics
[Technical performance data]

### Full Audit Report
[Link to complete technical audit]

---

**Questions?**
Contact: [Name]
Email: [Email]
Date: [Date]
Version: 1.0
```

---

## Quick Start (Kanopi Projects)

### Pre-Audit Performance Checks

Run Kanopi's performance tools before detailed audit:

```bash
# Drupal - Check for common performance issues
ddev composer phpstan          # Static analysis
ddev composer rector-check     # Code modernization

# Both - Check dependencies
ddev composer audit
ddev exec npm audit

# Run Lighthouse
ddev exec npx lighthouse [url] --output html --output-path ./report.html
```

### Performance Testing Tools

```bash
# Install tools
ddev exec npm install --save-dev lighthouse @lhci/cli webpack-bundle-analyzer

# Run Lighthouse CI
ddev exec npx lhci autorun

# Analyze bundles
ddev exec npx webpack-bundle-analyzer

# Custom performance tests
ddev composer test-performance
```

---

## Analysis Guidelines

- **Focus on user impact** - Prioritize metrics that affect actual users
- **Measure real-world performance** - Use RUM data when available
- **Consider business context** - Balance technical perfection with business needs
- **Provide actionable recommendations** - Every issue should have a clear fix
- **Estimate impact** - Quantify expected improvements
- **Be specific** - Include file paths, line numbers, and code examples

---

## Performance Tools Reference

**Automated Tools**:
- **Lighthouse**: Comprehensive audit tool
- **WebPageTest**: Real-world performance testing
- **Chrome DevTools**: Performance panel and profiling
- **PageSpeed Insights**: Google's performance analysis

**Monitoring Tools**:
- **Google Analytics 4**: Core Web Vitals tracking
- **New Relic**: Application performance monitoring
- **Datadog**: Full-stack monitoring
- **Custom RUM**: Real User Monitoring

**Analysis Tools**:
- **Webpack Bundle Analyzer**: JavaScript bundle analysis
- **Coverage Tool**: Unused code detection
- **Chrome DevTools Coverage**: CSS/JS coverage

**Testing Conditions**:
- Test on 3G/4G networks
- Test on low-end devices
- Test from different geographic locations
- Test with cache disabled and enabled

**Remember**: Performance is a feature, not a nice-to-have. Every 100ms improvement in load time can increase conversion by 1%.
