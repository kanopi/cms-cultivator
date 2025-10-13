---
description: Run comprehensive performance analysis
allowed-tools: Read, Glob, Grep, Bash(npm:*), Bash(ddev exec npm:*), Bash(composer:*), Bash(ddev exec composer:*)
---

Perform a full-stack performance audit covering frontend, backend, and infrastructure.

## Instructions

1. **Analyze recent changes** using `git diff` if no URL provided
2. **Frontend analysis**:
   - Asset sizes (JS, CSS, images)
   - Number of requests
   - Render-blocking resources
   - Critical rendering path
3. **Backend analysis**:
   - Database queries
   - API response times
   - Server processing time
   - Memory usage
4. **Core Web Vitals**:
   - LCP (Largest Contentful Paint) < 2.5s
   - FID/INP (First Input Delay / Interaction to Next Paint) < 200ms
   - CLS (Cumulative Layout Shift) < 0.1
5. **Infrastructure**:
   - Caching configuration
   - CDN usage
   - Compression (gzip/brotli)
   - HTTP/2 or HTTP/3

## Output Format

```markdown
# Performance Audit Report

**URL/Scope**: [url or files analyzed]
**Date**: [date]

## Performance Score

**Overall**: [score]/100

- Performance: [score]/100
- Best Practices: [score]/100  
- SEO: [score]/100

## Core Web Vitals

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| LCP    | 3.2s    | <2.5s  | ❌ FAIL |
| FID    | 45ms    | <100ms | ✅ PASS |
| CLS    | 0.15    | <0.1   | ❌ FAIL |

## Critical Issues 🔴

### 1. Large JavaScript Bundle
**Impact**: Slow page load, high LCP
**Current**: 2.3MB total JS
**Target**: <500KB

**Analysis**:
- main.js: 1.8MB (unminified, contains unused code)
- vendor.js: 500KB (large dependencies)

**Recommendations**:
1. Enable production build with minification
2. Implement code splitting
3. Remove unused dependencies
4. Lazy load non-critical JS

**Expected Improvement**: 2-3s faster load time

---

### 2. Unoptimized Images
**Impact**: Slow LCP, high bandwidth
**Current**: 8.5MB total images
**Target**: <2MB

**Issues**:
- 15 images over 500KB
- No WebP format
- No lazy loading
- Missing responsive images

**Recommendations**:
1. Convert to WebP with JPEG fallback
2. Implement lazy loading
3. Use responsive images (srcset)
4. Compress images (target 80% quality)

**Expected Improvement**: 3-4s faster load time

---

### 3. N+1 Query Problem
**Impact**: Slow TTFB, high database load
**Current**: 47 queries per page load
**Target**: <10 queries

**Location**: `ProductController.php:45`

**Current Code**:
\`\`\`php
foreach ($products as $product) {
  $category = Category::find($product->category_id); // N+1!
}
\`\`\`

**Fixed Code**:
\`\`\`php
$products = Product::with('category')->get(); // Eager loading
foreach ($products as $product) {
  $category = $product->category;
}
\`\`\`

**Expected Improvement**: 500ms faster TTFB

## Moderate Issues 🟡

### No Page Caching
**Impact**: Repeated server processing
**Recommendation**: Enable Drupal page cache / WordPress object cache

### Missing Compression
**Impact**: 3x larger transfer sizes
**Recommendation**: Enable gzip or brotli compression

## Frontend Performance

**Total Page Weight**: 12.3MB
- HTML: 45KB
- CSS: 380KB (3 files)
- JavaScript: 2.3MB (15 files)
- Images: 8.5MB (32 files)
- Fonts: 450KB (4 fonts)
- Other: 625KB

**Requests**: 58 total
- Render-blocking: 8 resources
- Critical path length: 4 levels deep

**Timing**:
- TTFB: 850ms
- FCP: 2.1s
- LCP: 3.2s
- TTI: 4.5s
- Total Load: 6.8s

## Backend Performance

**Database**:
- Total queries: 47
- Slow queries (>100ms): 5
- Duplicate queries: 12
- N+1 queries detected: 3 locations

**Memory**:
- Peak usage: 128MB
- Baseline: 45MB
- Potential leaks: None detected

**Processing Time**:
- Average: 450ms
- P95: 1.2s
- P99: 2.5s

## Recommendations by Priority

### High Priority (Do First)
1. ✅ Enable production build / minification
2. ✅ Fix N+1 queries
3. ✅ Optimize images (WebP, compression)
4. ✅ Enable page caching

### Medium Priority
5. Implement code splitting
6. Add lazy loading for images
7. Enable HTTP/2
8. Add CDN for static assets

### Low Priority  
9. Optimize web fonts
10. Reduce third-party scripts
11. Improve server response time

## Expected Results

**After Critical Fixes**:
- LCP: 3.2s → 1.8s (44% improvement)
- Page Weight: 12.3MB → 3.5MB (72% reduction)
- Load Time: 6.8s → 3.2s (53% improvement)
- Database Queries: 47 → 8 (83% reduction)

## Testing Tools Used
- Lighthouse
- WebPageTest
- Chrome DevTools
- Query Monitor (WordPress) / Devel (Drupal)

## Next Steps
1. Implement high-priority fixes
2. Retest and measure improvements
3. Set up performance monitoring
4. Establish performance budget
```
