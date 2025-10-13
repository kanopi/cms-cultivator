---
description: Check and optimize Core Web Vitals (LCP, FID/INP, CLS)
argument-hint: [metric]
allowed-tools: Read, Glob, Grep, Bash(npm:*), Bash(ddev exec npm:*)
---

You are helping check and optimize Core Web Vitals. These metrics directly impact user experience and Google search rankings.

## Usage

- `/perf-vitals` - Check all three Core Web Vitals
- `/perf-vitals lcp` - Focus on Largest Contentful Paint only
- `/perf-vitals fid` - Focus on First Input Delay / Interaction to Next Paint only
- `/perf-vitals cls` - Focus on Cumulative Layout Shift only

## Core Web Vitals Overview

| Metric | Good | Needs Improvement | Poor |
|--------|------|-------------------|------|
| **LCP** (Largest Contentful Paint) | < 2.5s | 2.5s - 4.0s | > 4.0s |
| **FID** (First Input Delay) | < 100ms | 100ms - 300ms | > 300ms |
| **INP** (Interaction to Next Paint) | < 200ms | 200ms - 500ms | > 500ms |
| **CLS** (Cumulative Layout Shift) | < 0.1 | 0.1 - 0.25 | > 0.25 |

**Note**: INP is replacing FID as of March 2024

## Measurement

### How to Measure

**1. Chrome DevTools**:
```
1. Open DevTools (F12)
2. Go to Performance tab
3. Click record, reload page, stop
4. Look for LCP, FID, CLS in timings
```

**2. Lighthouse**:
```bash
# Chrome DevTools > Lighthouse > Generate report
# Or CLI:
npm install -g lighthouse
lighthouse https://example.com --view
```

**3. PageSpeed Insights**:
- Visit: https://pagespeed.web.dev/
- Enter URL
- Get field data (real users) + lab data (simulated)

**4. Web Vitals Extension**:
- Chrome extension shows real-time vitals
- Install from Chrome Web Store

---

## 1. LCP (LARGEST CONTENTFUL PAINT)

**Definition**: Time until largest content element becomes visible
**Target**: < 2.5 seconds
**Impact**: User-perceived load speed

### Common LCP Elements
- Hero images
- Header images
- Large text blocks
- Video poster images

### Identify LCP Element

```javascript
// Add to page to identify LCP element
new PerformanceObserver((list) => {
  const entries = list.getEntries();
  const lastEntry = entries[entries.length - 1];
  console.log('LCP Element:', lastEntry.element);
  console.log('LCP Time:', lastEntry.startTime);
}).observe({entryTypes: ['largest-contentful-paint']});
```

### Optimization Strategies

#### 1. Optimize Images

**Current Issue**: Large hero image (1.2MB, 2400x1600px)

**Fixes**:
```html
<!-- Before -->
<img src="hero.jpg" alt="Hero image">

<!-- After -->
<picture>
  <!-- WebP with responsive sizes -->
  <source
    srcset="hero-480.webp 480w,
            hero-768.webp 768w,
            hero-1200.webp 1200w"
    sizes="(max-width: 768px) 100vw, 1200px"
    type="image/webp">

  <!-- Fallback -->
  <img src="hero-1200.jpg"
       srcset="hero-480.jpg 480w,
               hero-768.jpg 768w,
               hero-1200.jpg 1200w"
       sizes="(max-width: 768px) 100vw, 1200px"
       alt="Hero image"
       fetchpriority="high">
</picture>
```

**Benefits**:
- WebP: 80% smaller than JPEG
- Responsive: Right size for device
- fetchpriority: Browser prioritizes loading
- **Result**: 1.2MB → 180KB (85% reduction)

---

#### 2. Preload Critical Resources

```html
<head>
  <!-- Preload LCP image -->
  <link rel="preload" as="image" href="hero-1200.webp"
        type="image/webp"
        imagesrcset="hero-480.webp 480w, hero-768.webp 768w, hero-1200.webp 1200w"
        imagesizes="(max-width: 768px) 100vw, 1200px">

  <!-- Preload critical fonts -->
  <link rel="preload" as="font" href="/fonts/inter-400.woff2"
        type="font/woff2" crossorigin>

  <!-- Preconnect to external domains -->
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://cdn.example.com">
</head>
```

---

#### 3. Eliminate Render-Blocking Resources

**CSS**:
```html
<!-- Inline critical CSS -->
<style>
  /* Critical above-the-fold CSS here */
  .hero { display: block; width: 100%; }
</style>

<!-- Load non-critical CSS asynchronously -->
<link rel="preload" href="styles.css" as="style"
      onload="this.onload=null;this.rel='stylesheet'">
<noscript><link rel="stylesheet" href="styles.css"></noscript>
```

**JavaScript**:
```html
<!-- Defer non-critical JS -->
<script src="analytics.js" defer></script>

<!-- Async for independent scripts -->
<script src="ads.js" async></script>

<!-- Move non-critical JS to end of body -->
```

---

#### 4. Server Response Time (TTFB)

**Target**: < 600ms

**Optimizations**:
- Enable caching (Redis, Varnish)
- Use CDN
- Optimize database queries
- Enable Gzip/Brotli compression
- Use HTTP/2 or HTTP/3
- Implement page caching (Drupal/WordPress)

**Drupal**:
```php
// Enable page cache, dynamic page cache
$config['system.performance']['cache']['page']['max_age'] = 3600;

// Use external cache (Redis)
$settings['cache']['default'] = 'cache.backend.redis';
```

**WordPress**:
```php
// Use caching plugin (WP Super Cache, W3 Total Cache)
// Or object cache (Redis Object Cache)
define('WP_CACHE', true);
```

---

### LCP Output Format

```markdown
## LCP (Largest Contentful Paint) Analysis

**Current LCP**: 4.2s ❌ (Target: < 2.5s)
**LCP Element**: Hero image (`hero.jpg`, 1920x1080px, 1.2MB)

### Issues Identified

1. **Large Image Size** (Priority: High)
   - Current: 1.2MB JPEG
   - Location: `index.html:25`
   - Impact: ~2.1s delay

2. **No Resource Prioritization** (Priority: High)
   - Missing `fetchpriority="high"` on LCP image
   - No preload for critical image
   - Impact: ~800ms delay

3. **Render-Blocking CSS** (Priority: Medium)
   - 3 CSS files block rendering (125KB)
   - Location: `<head>`
   - Impact: ~600ms delay

4. **Slow Server Response** (Priority: Medium)
   - TTFB: 850ms (Target: < 600ms)
   - No page caching enabled
   - Impact: ~250ms delay

### Optimization Plan

#### Phase 1: Image Optimization (Biggest Impact)
- [ ] Convert to WebP format
- [ ] Generate responsive sizes (480w, 768w, 1200w)
- [ ] Add `fetchpriority="high"`
- [ ] Implement preload
- **Expected LCP**: 4.2s → 2.8s (33% improvement)

#### Phase 2: Critical Path
- [ ] Inline critical CSS
- [ ] Defer non-critical CSS
- [ ] Move JS to end of body or use defer/async
- **Expected LCP**: 2.8s → 2.2s (21% improvement)

#### Phase 3: Server Performance
- [ ] Enable Redis/object cache
- [ ] Enable page caching
- [ ] Implement CDN
- **Expected LCP**: 2.2s → 1.9s (14% improvement)

### Final Expected LCP: 1.9s ✅ (Target: < 2.5s)
### Total Improvement: 55% faster
```

---

## 2. FID / INP (INTERACTIVITY)

**FID**: Time from first interaction to browser response
**INP**: Time from interaction to visual update (replacing FID)
**Target**: FID < 100ms, INP < 200ms

### Common Causes of Poor Interactivity
- Large JavaScript bundles
- Long-running JavaScript tasks (> 50ms)
- Main thread blocked
- Excessive third-party scripts

### Identify Issues

```javascript
// Detect long tasks (> 50ms)
new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    console.warn('Long task detected:', entry.duration, 'ms');
  }
}).observe({entryTypes: ['longtask']});
```

### Optimization Strategies

#### 1. Break Up Long Tasks

**Before** (One 250ms task):
```javascript
function processItems(items) {
  items.forEach(item => {
    // Complex processing
    processItem(item);
  });
}
```

**After** (Multiple < 50ms tasks):
```javascript
async function processItems(items) {
  for (const item of items) {
    processItem(item);

    // Yield to browser every iteration
    if (navigator.scheduling?.isInputPending()) {
      await new Promise(r => setTimeout(r, 0));
    }
  }
}
```

---

#### 2. Code Splitting

**Before** (One large bundle):
```javascript
import HomePage from './pages/Home';
import AboutPage from './pages/About';
import ContactPage from './pages/Contact';
```

**After** (Route-based splitting):
```javascript
const HomePage = lazy(() => import('./pages/Home'));
const AboutPage = lazy(() => import('./pages/About'));
const ContactPage = lazy(() => import('./pages/Contact'));
```

**Benefit**: Initial bundle 40% smaller

---

#### 3. Defer Non-Critical JavaScript

```html
<!-- Critical: Inline or load synchronously -->
<script>
  // Small, critical JS here
</script>

<!-- Non-critical: Defer -->
<script src="analytics.js" defer></script>
<script src="features.js" defer></script>

<!-- Independent: Async -->
<script src="ads.js" async></script>
```

---

#### 4. Reduce Third-Party Impact

```javascript
// Load third-party scripts after page is interactive
if (document.readyState === 'complete') {
  loadThirdPartyScripts();
} else {
  window.addEventListener('load', loadThirdPartyScripts);
}

function loadThirdPartyScripts() {
  // Load analytics, ads, etc.
}
```

---

#### 5. Web Workers for Heavy Processing

```javascript
// Main thread
const worker = new Worker('processor.js');

worker.postMessage({data: largeDataset});

worker.onmessage = (e) => {
  const results = e.data;
  // Update UI with results
};

// processor.js (Web Worker)
self.onmessage = (e) => {
  const results = processData(e.data);
  self.postMessage(results);
};
```

---

### FID/INP Output Format

```markdown
## FID / INP (Interactivity) Analysis

**Current FID**: 185ms ⚠️ (Target: < 100ms)
**Current INP**: 340ms ❌ (Target: < 200ms)

### Long Tasks Detected

#### 1. Event Handler Processing (Task Duration: 280ms)
**Location**: `EventCalendar.js:45`
**Cause**: Processing 100 events in single task
**Impact**: Blocks main thread for 280ms

**Fix**:
```javascript
// Before: Blocks for 280ms
events.forEach(event => processEvent(event));

// After: Yields to browser
for (const event of events) {
  processEvent(event);
  await yieldToMain(); // Yield after each event
}

function yieldToMain() {
  return new Promise(resolve => {
    setTimeout(resolve, 0);
  });
}
```

**Expected Improvement**: 280ms → 50ms per task

---

#### 2. JavaScript Bundle Size (142KB gzipped)
**Issue**: Large initial bundle blocks main thread during parse/compile
**Parse Time**: ~450ms on mid-tier mobile

**Fix**:
- Implement code splitting by route
- Defer non-critical features
- Use dynamic imports

**Expected Improvement**: 450ms → 180ms (60% reduction)

---

#### 3. Third-Party Scripts (85KB, 6 scripts)
**Scripts**:
- Google Analytics (28KB)
- Facebook Pixel (22KB)
- Hotjar (18KB)
- Intercom (17KB)

**Impact**: ~320ms parse + execute time

**Fix**:
```javascript
// Load after page is interactive
window.addEventListener('load', () => {
  setTimeout(loadThirdParty, 2000);
});
```

**Expected Improvement**: Remove from critical path

---

### Optimization Plan

#### Phase 1: Break Up Long Tasks
- [ ] Implement yielding in event processing
- [ ] Split large synchronous operations
- **Expected INP**: 340ms → 220ms

#### Phase 2: Reduce Bundle Size
- [ ] Code splitting by route
- [ ] Defer non-critical JS
- **Expected INP**: 220ms → 180ms

#### Phase 3: Defer Third-Party
- [ ] Load after page interactive
- [ ] Use facade pattern for embeds
- **Expected FID**: 185ms → 85ms
- **Expected INP**: 180ms → 150ms

### Final Expected Metrics
- **FID**: 85ms ✅ (Target: < 100ms)
- **INP**: 150ms ✅ (Target: < 200ms)
### Total Improvement: 54% faster interactivity
```

---

## 3. CLS (CUMULATIVE LAYOUT SHIFT)

**Definition**: Visual stability - elements shouldn't unexpectedly move
**Target**: < 0.1
**Formula**: Impact Fraction × Distance Fraction

### Common Causes
- Images without dimensions
- Ads/embeds without reserved space
- Web fonts causing FOIT/FOUT
- Dynamically injected content
- Animations/transitions

### Identify Layout Shifts

```javascript
// Log layout shifts
new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (!entry.hadRecentInput) {
      console.log('Layout shift:', entry.value, entry.sources);
    }
  }
}).observe({entryTypes: ['layout-shift']});
```

### Optimization Strategies

#### 1. Always Include Image/Video Dimensions

```html
<!-- Bad: No dimensions -->
<img src="photo.jpg" alt="Photo">

<!-- Good: Dimensions specified -->
<img src="photo.jpg" alt="Photo"
     width="800" height="600">

<!-- Better: Aspect ratio with CSS -->
<img src="photo.jpg" alt="Photo"
     width="800" height="600"
     style="aspect-ratio: 800/600; width: 100%; height: auto;">
```

**CSS approach**:
```css
img {
  aspect-ratio: attr(width) / attr(height);
  width: 100%;
  height: auto;
}
```

---

#### 2. Reserve Space for Ads and Embeds

```html
<!-- Bad: No placeholder -->
<div id="ad-slot"></div>

<!-- Good: Reserved space -->
<div id="ad-slot" style="min-height: 250px;">
  <!-- Ad loads here -->
</div>

<!-- Better: Skeleton/placeholder -->
<div class="ad-placeholder">
  <div class="skeleton"></div>
</div>
```

---

#### 3. Font Loading Strategy

```css
@font-face {
  font-family: 'Inter';
  src: url('/fonts/inter.woff2') format('woff2');
  /* Prevent FOIT (flash of invisible text) */
  font-display: swap;
}
```

**Preload fonts**:
```html
<link rel="preload" as="font"
      href="/fonts/inter-400.woff2"
      type="font/woff2"
      crossorigin>
```

**Fallback font matching**:
```css
body {
  /* Fallback font similar to web font */
  font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
  /* Adjust fallback to match web font metrics */
  font-size-adjust: 0.5;
}
```

---

#### 4. Transform/Opacity for Animations

```css
/* Bad: Causes layout shift */
.dropdown {
  transition: height 0.3s;
}

/* Good: No layout shift */
.dropdown {
  transition: transform 0.3s, opacity 0.3s;
  transform: translateY(-100%);
}

.dropdown.open {
  transform: translateY(0);
}
```

---

#### 5. Dynamic Content Injection

```javascript
// Bad: Injects without placeholder
fetch('/api/content').then(html => {
  document.querySelector('#container').innerHTML = html;
});

// Good: Reserved space
<div id="container" style="min-height: 300px;">
  <div class="skeleton-loader"></div>
</div>
```

---

### CLS Output Format

```markdown
## CLS (Cumulative Layout Shift) Analysis

**Current CLS**: 0.28 ❌ (Target: < 0.1)

### Layout Shifts Identified

#### 1. Hero Image (Shift: 0.15, Largest shift)
**Location**: `index.html:25`
**Cause**: Image loaded without width/height attributes
**Impact**: 1200px × 600px image shifts content down

**Fix**:
```html
<!-- Before -->
<img src="hero.jpg" alt="Hero">

<!-- After -->
<img src="hero.jpg" alt="Hero"
     width="1200" height="600"
     style="width: 100%; height: auto;">
```

**CLS Reduction**: 0.15

---

#### 2. Web Font Loading (Shift: 0.08)
**Cause**: Custom font taller than fallback
**Impact**: Text reflows when font loads

**Fix**:
```css
@font-face {
  font-family: 'Inter';
  src: url('/fonts/inter.woff2') format('woff2');
  font-display: swap; /* Prevent FOIT */
}

/* Match fallback metrics to web font */
body {
  font-family: 'Inter', -apple-system, sans-serif;
  font-size-adjust: 0.52; /* Adjust to match Inter */
}
```

**CLS Reduction**: 0.08

---

#### 3. Ad Banner (Shift: 0.05)
**Location**: Sidebar
**Cause**: No reserved space for ad
**Impact**: Content shifts when ad loads

**Fix**:
```html
<!-- Reserve space -->
<div class="ad-container" style="min-height: 250px;">
  <div id="ad-slot"></div>
</div>
```

**CLS Reduction**: 0.05

---

### Optimization Plan

#### Phase 1: Add Image Dimensions
- [ ] Add width/height to all images
- [ ] Use aspect-ratio CSS
- **Expected CLS**: 0.28 → 0.13

#### Phase 2: Font Loading
- [ ] Add font-display: swap
- [ ] Preload critical fonts
- [ ] Match fallback font metrics
- **Expected CLS**: 0.13 → 0.05

#### Phase 3: Reserve Space
- [ ] Add min-height to ad containers
- [ ] Add placeholders for dynamic content
- **Expected CLS**: 0.05 → 0.03

### Final Expected CLS: 0.03 ✅ (Target: < 0.1)
### Total Improvement: 89% reduction in shifts
```

---

## Combined Output Format

When running `/perf-vitals` without focus:

```markdown
# Core Web Vitals Report

## 📊 CURRENT METRICS

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| **LCP** | 4.2s | < 2.5s | ❌ Poor |
| **FID** | 185ms | < 100ms | ⚠️ Needs Work |
| **INP** | 340ms | < 200ms | ❌ Poor |
| **CLS** | 0.28 | < 0.1 | ❌ Poor |

---

## 1. LCP OPTIMIZATION
[Full LCP analysis]
**Expected**: 4.2s → 1.9s (55% improvement)

## 2. FID/INP OPTIMIZATION
[Full interactivity analysis]
**Expected**: FID 185ms → 85ms, INP 340ms → 150ms

## 3. CLS OPTIMIZATION
[Full CLS analysis]
**Expected**: 0.28 → 0.03 (89% reduction)

---

## FINAL PROJECTED METRICS

| Metric | Before | After | Improvement | Status |
|--------|--------|-------|-------------|--------|
| **LCP** | 4.2s | 1.9s | 55% ↓ | ✅ Pass |
| **FID** | 185ms | 85ms | 54% ↓ | ✅ Pass |
| **INP** | 340ms | 150ms | 56% ↓ | ✅ Pass |
| **CLS** | 0.28 | 0.03 | 89% ↓ | ✅ Pass |

**Overall**: All Core Web Vitals will pass ✅

---

## IMPLEMENTATION PRIORITY

### High Priority (Do First)
1. Add image dimensions (fixes CLS)
2. Optimize LCP image (WebP, responsive)
3. Break up long JavaScript tasks (fixes INP)

### Medium Priority
4. Code splitting
5. Font optimization
6. Reserve space for ads/embeds

### Low Priority (Polish)
7. Preconnect to third-party domains
8. Fine-tune font fallbacks
9. Implement service worker

**Estimated Implementation Time**: 12-16 hours
**Expected User Experience Improvement**: 50-60% faster perceived performance
```

## Focus Area Execution

- `/perf-vitals lcp` → LCP analysis only
- `/perf-vitals fid` → FID/INP analysis only
- `/perf-vitals cls` → CLS analysis only
- `/perf-vitals` → All three metrics

## Testing Tools

- **Chrome DevTools**: Performance tab, Lighthouse
- **PageSpeed Insights**: https://pagespeed.web.dev/
- **Web Vitals Extension**: Chrome Web Store
- **WebPageTest**: https://webpagetest.org/
- **Lighthouse CI**: Continuous monitoring

Remember: Core Web Vitals are user-centric metrics that directly impact SEO rankings and user experience. Optimizing these should be a top priority.
