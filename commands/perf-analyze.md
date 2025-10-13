---
description: Analyze performance aspects (queries, N+1, assets, bundles, caching)
argument-hint: [focus-area]
allowed-tools: Read, Glob, Grep, Bash(npm:*), Bash(ddev exec npm:*), Bash(composer:*), Bash(ddev exec composer:*), Bash(ddev composer:*), Bash(ddev theme-build:*), Bash(ddev theme-watch:*), Bash(ddev theme-install:*), Bash(ddev critical-run:*), Bash(ddev critical-install:*)
---

You are helping analyze specific performance aspects of the application. This command combines database, asset, and caching analysis.

## Usage

- `/perf-analyze` - Run all performance analyses
- `/perf-analyze queries` - Database query analysis only
- `/perf-analyze n-plus-one` - N+1 query detection only
- `/perf-analyze assets` - Asset optimization analysis only
- `/perf-analyze bundles` - JavaScript bundle analysis only
- `/perf-analyze caching` - Caching effectiveness analysis only

## Quick Start (Kanopi Projects)

### Theme Asset Optimization

Kanopi projects use standardized DDEV commands for theme builds and performance testing:

```bash
# Build production assets (optimized for performance)
ddev theme-build

# Watch mode for development (unoptimized)
ddev theme-watch

# Install theme dependencies
ddev theme-install
```

**What theme-build does**:
- Minifies JavaScript bundles
- Compiles and minifies CSS/SCSS
- Optimizes images
- Generates source maps (if configured)
- Creates production-ready assets

**Analyzing Build Output**:
After running `ddev theme-build`, check:
- Bundle sizes in build output
- Source map files for bundle analysis
- Generated CSS size vs source SCSS
- Image optimization results

### Critical CSS Testing

Kanopi projects can use Critical for above-the-fold CSS optimization:

```bash
# Install Critical testing tools
ddev critical-install

# Run Critical CSS analysis
ddev critical-run
```

**What Critical checks**:
- **Above-the-fold CSS**: Identifies critical styles needed for initial render
- **Render Performance**: Measures First Contentful Paint (FCP) and Largest Contentful Paint (LCP)
- **CSS Coverage**: Identifies unused CSS in critical rendering path
- **Load Time Impact**: Tracks performance improvements from inlining critical CSS

**Example Critical Output**:
```
Critical CSS generated: 15.2 KB
Original CSS: 245 KB
Reduction: 93.8%

Performance Impact:
- First Contentful Paint: 0.8s → 0.3s (62% faster)
- Largest Contentful Paint: 2.1s → 1.2s (43% faster)
```

### Performance Testing Workflow

```bash
# 1. Build production assets
ddev theme-build

# 2. Analyze Critical CSS performance
ddev critical-run

# 3. Review bundle sizes and optimization opportunities
# Check webpack/vite build output for bundle analysis
```

**Common Issues Found**:
- Unminified JavaScript in production builds
- Large vendor bundles (moment.js, lodash)
- Unoptimized images
- Unused CSS loaded on every page
- Missing Critical CSS inlining

---

## Analysis Areas

### 1. DATABASE QUERY ANALYSIS

#### Objectives
- Identify slow queries (> 100ms)
- Detect inefficient patterns
- Find missing indexes
- Optimize Drupal EntityQuery / WordPress WP_Query

#### How to Analyze

**Enable Query Logging**:
```php
// Drupal
$settings['container_yamls'][] = DRUPAL_ROOT . '/sites/development.services.yml';

// WordPress
define('SAVEQUERIES', true);
```

**Look for**:
- Queries in loops
- SELECT * without WHERE clause
- Missing JOINs (N+1 pattern)
- Queries without indexes
- Subqueries that could be JOINs

#### Output Format

```markdown
## Database Query Analysis

### Slow Queries (> 100ms)

#### 1. User Listing Query (245ms)
**Location**: `UserController.php:45`
**Query**:
```sql
SELECT * FROM users
LEFT JOIN user_data ON users.id = user_data.user_id
WHERE users.status = 1
ORDER BY users.created DESC
LIMIT 50
```

**Issues**:
- SELECT * pulls unnecessary columns
- No index on users.status
- No index on users.created

**Optimization**:
```sql
-- Add indexes
CREATE INDEX idx_users_status_created ON users(status, created);

-- Optimize query
SELECT users.id, users.name, users.email, users.created
FROM users
WHERE users.status = 1
ORDER BY users.created DESC
LIMIT 50
```

**Expected Improvement**: 245ms → ~15ms (94% faster)

---

#### 2. Event Data Query (180ms)
**Location**: `EventRepository.php:78`
**Issue**: Loading related data in separate queries (N+1 pattern)

**Before**:
```php
$events = Event::all(); // 1 query
foreach ($events as $event) {
    $event->location; // N queries
    $event->registrations; // N queries
}
// Total: 1 + N + N queries
```

**After**:
```php
$events = Event::with(['location', 'registrations'])->get(); // 3 queries
// Total: 3 queries
```

**Expected Improvement**: 180ms → ~25ms (86% faster)

### Query Performance Summary
- **Total Queries Analyzed**: 145
- **Slow Queries (> 100ms)**: 5
- **Queries Needing Optimization**: 12
- **N+1 Patterns Detected**: 3
- **Missing Indexes**: 8

### Drupal-Specific Recommendations
```php
// Use EntityQuery efficiently
$query = \Drupal::entityQuery('node')
  ->condition('type', 'event')
  ->condition('status', 1)
  ->sort('created', 'DESC')
  ->range(0, 50)
  ->accessCheck(TRUE);

// Load entities efficiently
$nids = $query->execute();
$nodes = \Drupal\node\Entity\Node::loadMultiple($nids);

// Use dependency injection, not static calls
// Bad: \Drupal::entityTypeManager()
// Good: $this->entityTypeManager in service
```

### WordPress-Specific Recommendations
```php
// Optimize WP_Query
$query = new WP_Query([
    'post_type' => 'event',
    'posts_per_page' => 50,
    'fields' => 'ids', // Only get IDs if that's all you need
    'no_found_rows' => true, // Skip counting if pagination not needed
    'update_post_meta_cache' => false, // Skip if not using meta
    'update_post_term_cache' => false, // Skip if not using terms
]);

// Use transients for expensive queries
$results = get_transient('expensive_query_results');
if (false === $results) {
    $results = $wpdb->get_results($expensive_query);
    set_transient('expensive_query_results', $results, HOUR_IN_SECONDS);
}
```

### Tools & Next Steps
- Use query profiler (Xdebug, Blackfire)
- Enable slow query log
- Review database indexes
- Profile with Query Monitor (WordPress) or Webprofiler (Drupal)
```

---

### 2. N+1 QUERY DETECTION

#### What is N+1?
Loading parent records, then loading related records in a loop = 1 + N queries

#### Common Patterns

**Pattern 1: Loop Loading**
```php
// BAD: N+1 queries
$users = User::all(); // 1 query
foreach ($users as $user) {
    echo $user->profile->bio; // N queries
}

// GOOD: Eager loading
$users = User::with('profile')->get(); // 2 queries
foreach ($users as $user) {
    echo $user->profile->bio;
}
```

**Pattern 2: Entity Loading in Twig (Drupal)**
```twig
{# BAD: N+1 #}
{% for nid in node_ids %}
  {% set node = drupal_entity('node', nid) %}
  {{ node.title }}
{% endfor %}

{# GOOD: Load all at once in preprocess #}
```

**Pattern 3: get_post_meta in Loop (WordPress)**
```php
// BAD: N+1
foreach ($posts as $post) {
    $meta = get_post_meta($post->ID, 'event_date', true); // N queries
}

// GOOD: Prime cache
update_meta_cache('post', wp_list_pluck($posts, 'ID'));
foreach ($posts as $post) {
    $meta = get_post_meta($post->ID, 'event_date', true); // From cache
}
```

#### Output Format

```markdown
## N+1 Query Detection

### Detected N+1 Patterns

#### 1. User Profile Loading (EventController.php:56)
**Severity**: High
**Current**: 1 + 50 queries = 51 queries
**Fix**: Eager load → 2 queries

**Before**:
```php
$events = Event::all();
foreach ($events as $event) {
    $organizer = $event->organizer; // N queries
}
```

**After**:
```php
$events = Event::with('organizer')->get();
foreach ($events as $event) {
    $organizer = $event->organizer; // From eager load
}
```

**Performance Gain**: ~450ms saved

---

#### 2. Term Loading (WordPress - EventWidget.php:34)
**Severity**: Medium
**Current**: 1 + 20 queries = 21 queries

**Before**:
```php
$posts = get_posts(['post_type' => 'event', 'numberposts' => 20]);
foreach ($posts as $post) {
    $terms = get_the_terms($post->ID, 'event_category'); // N queries
}
```

**After**:
```php
$posts = get_posts(['post_type' => 'event', 'numberposts' => 20]);
update_object_term_cache(wp_list_pluck($posts, 'ID'), 'event');
foreach ($posts as $post) {
    $terms = get_the_terms($post->ID, 'event_category'); // From cache
}
```

**Performance Gain**: ~180ms saved

### Summary
- **N+1 Patterns Found**: 3
- **Total Unnecessary Queries**: 121
- **Estimated Time Saved**: ~850ms
- **Pages Affected**: 5

### Prevention Tips
- Use ORM eager loading
- Prime caches before loops
- Use `loadMultiple()` in Drupal
- Avoid entity loading in Twig
- Use Query Monitor to detect
```

---

### 3. ASSET OPTIMIZATION

#### What to Analyze
- JavaScript bundle sizes
- CSS file sizes
- Image optimization
- Font loading
- Asset delivery (CDN, compression)

#### Target Metrics
- **JS Bundle**: < 200KB gzipped
- **CSS Bundle**: < 50KB gzipped
- **Images**: WebP format, lazy loading
- **Fonts**: woff2 format, font-display: swap

#### Output Format

```markdown
## Asset Optimization Analysis

### JavaScript Analysis

**Total JS Size**: 485KB (uncompressed) / 142KB (gzipped)
**Target**: < 200KB gzipped ✅

#### Bundle Breakdown
| Bundle | Size (gzipped) | % of Total |
|--------|----------------|------------|
| main.js | 85KB | 60% |
| vendor.js | 45KB | 32% |
| analytics.js | 12KB | 8% |

**Issues**:
- ✅ Size under target
- ⚠️ Could benefit from code splitting
- Moment.js (67KB) should be replaced with date-fns (2KB)

**Recommendations**:
1. Replace moment.js with date-fns
   ```bash
   npm uninstall moment
   npm install date-fns
   ```
   **Savings**: ~65KB

2. Implement code splitting for routes
   ```javascript
   // Before
   import EventCalendar from './EventCalendar';

   // After
   const EventCalendar = lazy(() => import('./EventCalendar'));
   ```
   **Benefit**: Reduce initial bundle by ~40KB

---

### CSS Analysis

**Total CSS Size**: 125KB (uncompressed) / 28KB (gzipped)
**Target**: < 50KB gzipped ✅

**Unused CSS**: ~35% (detected with PurgeCSS)

**Recommendations**:
1. Enable PurgeCSS in production build
   ```javascript
   // tailwind.config.js
   module.exports = {
     purge: ['./src/**/*.{js,jsx,ts,tsx}', './public/index.html'],
   }
   ```
   **Savings**: ~43KB uncompressed

2. Critical CSS inline in `<head>`
   **Benefit**: Faster First Contentful Paint

---

### Image Optimization

**Total Images**: 45
**Unoptimized**: 12

#### Issues
| Image | Current | Optimized | Savings |
|-------|---------|-----------|---------|
| hero.jpg | 850KB | 180KB (WebP) | 79% |
| team-photo.png | 1.2MB | 245KB (WebP) | 80% |
| logo.png | 145KB | 12KB (SVG) | 92% |

**Recommendations**:
1. **Convert to WebP** with fallbacks
   ```html
   <picture>
     <source srcset="hero.webp" type="image/webp">
     <img src="hero.jpg" alt="Hero image">
   </picture>
   ```

2. **Implement lazy loading**
   ```html
   <img src="image.jpg" loading="lazy" alt="Description">
   ```

3. **Responsive images**
   ```html
   <img src="small.jpg"
        srcset="small.jpg 480w, medium.jpg 768w, large.jpg 1200w"
        sizes="(max-width: 768px) 100vw, 768px"
        alt="Description">
   ```

**Total Savings**: ~1.8MB (75% reduction)

---

### Font Optimization

**Fonts Loaded**: 3 families, 8 weights = 485KB

**Issues**:
- Using woff format (should use woff2)
- No font-display strategy
- Loading unused weights

**Recommendations**:
1. **Use woff2 format**
   ```css
   @font-face {
     font-family: 'Inter';
     src: url('/fonts/inter.woff2') format('woff2');
     font-display: swap;
   }
   ```

2. **Limit weights** (use only 400, 600, 700)
   **Savings**: ~280KB

3. **Preload critical fonts**
   ```html
   <link rel="preload" href="/fonts/inter-400.woff2" as="font" type="font/woff2" crossorigin>
   ```

---

### CDN & Delivery

**Current**: Assets served from origin
**Recommendation**: Use CDN

**Benefits**:
- Faster global delivery
- Reduced origin server load
- Better caching
- Automatic compression

**CDN Options**:
- Cloudflare (Free tier available)
- AWS CloudFront
- Fastly

### Compression

- ✅ Gzip enabled
- ⚠️ Brotli not enabled (20-30% better than gzip)

**Enable Brotli**:
```nginx
# Nginx config
brotli on;
brotli_comp_level 6;
brotli_types text/plain text/css application/javascript;
```

### Summary
**Total Potential Savings**: ~2.4MB (68% reduction)
**Estimated LCP Improvement**: ~1.2s faster
```

---

### 4. JAVASCRIPT BUNDLE ANALYSIS

#### Deep Dive into Bundle Size

Use webpack-bundle-analyzer or similar:
```bash
npm install --save-dev webpack-bundle-analyzer
npm run build -- --analyze
```

#### Output Format

```markdown
## JavaScript Bundle Detailed Analysis

### Bundle Visualization
```
main.bundle.js (142KB gzipped, 485KB uncompressed)
├── react (40KB) ✅ Necessary
├── react-dom (120KB) ✅ Necessary
├── moment (67KB) ⚠️ REPLACE with date-fns
├── lodash (71KB) ⚠️ Use lodash-es, import specific functions
├── axios (14KB) ✅ Reasonable
├── app code (173KB) ⚠️ Could be split
```

### Largest Dependencies

| Package | Size | Alternative | Savings |
|---------|------|-------------|---------|
| moment | 67KB | date-fns | 65KB |
| lodash | 71KB | lodash-es (tree-shakeable) | 50KB |
| - | - | - | - |
| **Total Savings** | - | - | **115KB** |

### Duplicate Dependencies

**Found**: 2 versions of react-router
- v5.2.0 (45KB)
- v6.0.0 (38KB)

**Fix**: Update all packages to use same version
```bash
npm dedupe
```

### Code Splitting Opportunities

**Current**: Single bundle loaded on every page
**Recommendation**: Split by route

```javascript
// Implement route-based splitting
const Home = lazy(() => import('./pages/Home'));
const Events = lazy(() => import('./pages/Events'));
const Admin = lazy(() => import('./pages/Admin'));

// Admin bundle only loads for admins
<Route path="/admin" element={<Suspense fallback={<Loading />}><Admin /></Suspense>} />
```

**Benefit**: Initial load ~40KB smaller (28% reduction)

### Tree Shaking Audit

**Issues Found**:
- Importing entire lodash: `import _ from 'lodash'`
- Importing all of Material-UI

**Fixes**:
```javascript
// Before
import _ from 'lodash';
import { Button } from '@material-ui/core';

// After
import debounce from 'lodash/debounce';
import Button from '@material-ui/core/Button';
```

### Summary
- **Current Bundle**: 142KB gzipped
- **After Optimizations**: ~85KB gzipped (40% reduction)
- **Initial Load Improvement**: ~1.8s faster on 3G
```

---

### 5. CACHING EFFECTIVENESS

#### Cache Layers to Analyze
1. **Browser cache** (HTTP headers)
2. **Application cache** (Drupal/WordPress)
3. **Database query cache**
4. **Object cache** (Redis/Memcached)
5. **CDN cache**
6. **Opcode cache** (OPcache)

#### Output Format

```markdown
## Caching Analysis

### 1. Browser Cache (HTTP Headers)

**Current Headers**:
```
Cache-Control: no-cache
Expires: Thu, 01 Jan 1970 00:00:00 GMT
```

**Issues**: ❌ Assets not being cached by browser

**Fix**:
```nginx
# Static assets - cache for 1 year
location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
    expires 1y;
    add_header Cache-Control "public, immutable";
}

# HTML - cache briefly
location ~* \.html$ {
    expires 1h;
    add_header Cache-Control "public, must-revalidate";
}
```

**Benefit**: Repeat visits ~2s faster

---

### 2. Application Cache (Drupal)

**Page Cache**: ✅ Enabled for anonymous users
**Dynamic Page Cache**: ✅ Enabled
**Internal Cache**: ⚠️ Database (should use Redis)

**Current Hit Rate**: 45% (should be > 80%)

**Issues**:
- Cache tags not used effectively
- Frequent cache clears
- No external cache backend

**Fix**:
```php
// settings.php
$settings['cache']['default'] = 'cache.backend.redis';
$settings['redis.connection']['interface'] = 'PhpRedis';
$settings['redis.connection']['host'] = 'localhost';
$settings['redis.connection']['port'] = 6379;

// Use cache tags properly
$build['#cache'] = [
  'tags' => ['node:123', 'user:456'],
  'contexts' => ['user', 'url.query_args'],
  'max-age' => 3600,
];
```

**Expected Hit Rate**: 85%+

---

### 3. Application Cache (WordPress)

**Object Cache**: ❌ Not enabled (using database)
**Page Cache**: ⚠️ Plugin-based (WP Super Cache)
**Transients**: ⚠️ Stored in database (slow)

**Fix**:
```php
// Install Redis Object Cache plugin
// wp-config.php
define('WP_REDIS_HOST', 'localhost');
define('WP_REDIS_PORT', 6379);

// Use transients effectively
$data = get_transient('expensive_data');
if (false === $data) {
    $data = expensive_operation();
    set_transient('expensive_data', $data, HOUR_IN_SECONDS);
}
```

**Benefit**: ~500ms saved on cached pages

---

### 4. Database Query Cache

**MySQL Query Cache**: ⚠️ Deprecated in MySQL 8.0+
**Alternative**: Application-level caching

**Recommendation**:
- Cache query results in Redis
- Use prepared statements (cached by MySQL)
- Enable OPcache for PHP (caches compiled code)

---

### 5. CDN Cache

**Status**: ❌ Not using CDN
**Recommendation**: Implement CDN for static assets

**Benefits**:
- 40-80% faster global delivery
- Reduced origin server load
- DDoS protection
- Automatic image optimization (Cloudflare Polish)

---

### 6. OPcache Status

**Current**: ✅ Enabled
**Hit Rate**: 99.2% ✅ Excellent
**Memory Usage**: 45% of 128MB

**Recommendation**: Increase memory to 256MB for headroom

```ini
; php.ini
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=10000
```

---

### Cache Effectiveness Summary

| Cache Layer | Status | Hit Rate | Recommendation |
|-------------|--------|----------|----------------|
| Browser | ❌ Missing | N/A | Add cache headers |
| App Cache (Drupal/WP) | ⚠️ DB-based | 45% | Use Redis |
| Object Cache | ❌ Disabled | N/A | Enable Redis |
| Query Cache | ⚠️ Deprecated | N/A | App-level caching |
| CDN | ❌ Not used | N/A | Implement Cloudflare |
| OPcache | ✅ Good | 99.2% | Increase memory |

**Priority Actions**:
1. Enable Redis object cache (Highest impact)
2. Add browser cache headers
3. Implement CDN
4. Optimize cache tags/contexts
5. Monitor cache hit rates

**Expected Performance Gain**: 2-3s faster page loads
```

---

## Combined Output Format

When running `/perf-analyze` without focus area:

```markdown
# Performance Analysis Report

## 1. 📊 DATABASE QUERIES
[Full analysis]
**Found**: 5 slow queries, 3 N+1 patterns

## 2. 🔍 N+1 DETECTION
[Full analysis]
**Found**: 121 unnecessary queries

## 3. 📦 ASSET OPTIMIZATION
[Full analysis]
**Potential Savings**: 2.4MB (68%)

## 4. 📊 BUNDLE ANALYSIS
[Full analysis]
**Optimization Potential**: 40% reduction

## 5. 💾 CACHING
[Full analysis]
**Hit Rate**: 45% (needs improvement)

---

## OVERALL SUMMARY

**Total Issues Found**: 23
- Database: 8
- N+1 Queries: 3
- Assets: 12

**Estimated Performance Gain**: 3-4s faster page loads
**Priority**: Database optimization + Redis cache

**Ready for Production**: ⚠️ Optimize first
```

## Focus Area Execution

- `/perf-analyze queries` → Section 1 only
- `/perf-analyze n-plus-one` → Section 2 only
- `/perf-analyze assets` → Section 3 only
- `/perf-analyze bundles` → Section 4 only
- `/perf-analyze caching` → Section 5 only
- `/perf-analyze` → All sections

## Tools Recommended

- **Query Profiling**: Xdebug, Blackfire, Query Monitor (WP), Webprofiler (Drupal)
- **Bundle Analysis**: webpack-bundle-analyzer
- **Asset Optimization**: ImageOptim, Squoosh, PurgeCSS
- **Caching**: Redis, Memcached, Cloudflare
- **Monitoring**: New Relic, Datadog, Scout APM

Remember: Measure first, optimize second. Use profiling tools to find actual bottlenecks, not assumed ones.
