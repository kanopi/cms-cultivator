---
name: gtm-performance-audit
description: Automatically audit Google Tag Manager implementations for performance impact when user mentions GTM, tag manager, tracking tags, marketing tags, or asks about tag performance. Analyzes container configuration, measures tag execution timing, identifies blocking tags, audits custom HTML safety, evaluates trigger efficiency, and maps tag impact to Core Web Vitals. Invoke when user says "GTM is slow", "too many tags", "tag manager performance", "tracking tags impact", or asks about marketing tag overhead.
---

# GTM Performance Audit

Analyze Google Tag Manager implementations for performance impact using Chrome DevTools MCP.

## Philosophy

Tag managers are powerful but can silently degrade performance. Every tag has a cost.

### Core Beliefs

1. **Measure Tag Impact Individually**: Each tag's cost must be measured, not assumed
2. **Container Size Is a Leading Indicator**: Large containers correlate with poor performance
3. **Triggers Are the Multiplier**: Inefficient triggers amplify tag cost exponentially
4. **Server-Side Is the Future**: Move data collection off the main thread when possible

### Why GTM Audits Matter

- **Invisible Performance Tax**: Tags add up silently; no single tag seems costly
- **Core Web Vitals Impact**: GTM scripts affect LCP, INP, and CLS directly
- **Third-Party Risk**: Tags load external resources outside your control
- **Consent Compliance**: Tags firing before consent degrade trust and may violate regulations

## When This Skill Activates

Activate this skill when the user:
- Mentions "GTM", "Google Tag Manager", or "tag manager"
- Says "too many tags" or "tracking is slow"
- Asks "are our marketing tags slowing the site?"
- Mentions "container size" or "tag execution"
- References "dataLayer", "custom HTML tags", or "trigger efficiency"
- Asks about "tag performance" or "third-party script impact"
- Shows GTM-related code and asks about performance

## Decision Framework

Before auditing, determine the audit mode:

### What Data Is Available?

1. **Live page with GTM** → Full audit via Chrome DevTools MCP (best)
2. **Container JSON export + live page** → Container analysis + live profiling (comprehensive)
3. **Container ID only** → Infer from network requests on live page (limited)
4. **Code review only** → Analyze GTM integration code in codebase (minimal)

### What's the Goal?

- **Quick check** → Container size, tag count, obvious issues
- **Standard audit** → Full analysis with CWV impact mapping
- **Comprehensive** → Deep profiling with remediation plan and implementation steps

### Decision Tree

```
User asks about GTM performance
    |
    v
Ask for: target URL, GTM container ID (GTM-XXXX)
    |
    v
Optional: container JSON export, critical tags list
    |
    v
Phase 1: Baseline Performance (before GTM analysis)
    |
    v
Phase 2: GTM Container Analysis
    |
    v
Phase 3: Issue Detection (14 checks)
    |
    v
Phase 4: Report Generation
```

## Setup

Before starting the audit, gather from the user:

1. **Target URL** (required) - The page to audit
2. **GTM Container ID** (required) - Format: GTM-XXXXXXX
3. **Container JSON export** (optional) - Exported from GTM admin
4. **Critical tags list** (optional) - Tags that must not be removed

## Phase 1: Baseline Performance

Measure page performance to establish the GTM impact baseline.

### Navigation Timing

```javascript
// Use mcp__chrome-devtools__evaluate_script
() => {
  const timing = performance.getEntriesByType('navigation')[0];
  return {
    domContentLoaded: timing.domContentLoadedEventEnd - timing.startTime,
    loadComplete: timing.loadEventEnd - timing.startTime,
    ttfb: timing.responseStart - timing.startTime,
    domInteractive: timing.domInteractive - timing.startTime
  };
}
```

### Paint Metrics

```javascript
// Use mcp__chrome-devtools__evaluate_script
() => {
  const paint = performance.getEntriesByType('paint');
  const entries = {};
  paint.forEach(p => { entries[p.name] = p.startTime; });
  return entries;
}
```

### GTM Resource Identification

```javascript
// Use mcp__chrome-devtools__evaluate_script
() => {
  const resources = performance.getEntriesByType('resource');
  const gtmResources = resources.filter(r =>
    r.name.includes('googletagmanager.com') ||
    r.name.includes('google-analytics.com') ||
    r.name.includes('gtag/js') ||
    r.name.includes('gtm.js')
  );
  return gtmResources.map(r => ({
    name: r.name,
    duration: r.duration,
    transferSize: r.transferSize,
    initiatorType: r.initiatorType,
    startTime: r.startTime
  }));
}
```

### Network Waterfall

Use `mcp__chrome-devtools__list_network_requests` to capture:
- All requests initiated by GTM
- Third-party domains loaded via tags
- Request timing and sizes
- Blocking vs. async loading patterns

### Console Errors

Use `mcp__chrome-devtools__list_console_messages` to check for:
- GTM-related JavaScript errors
- Tag execution failures
- DataLayer errors
- Consent-related warnings

### Core Web Vitals Measurement

```javascript
// Use mcp__chrome-devtools__evaluate_script
() => {
  return new Promise((resolve) => {
    const metrics = {};

    // LCP
    new PerformanceObserver((list) => {
      const entries = list.getEntries();
      metrics.lcp = entries[entries.length - 1].startTime;
    }).observe({ type: 'largest-contentful-paint', buffered: true });

    // CLS
    let clsValue = 0;
    new PerformanceObserver((list) => {
      for (const entry of list.getEntries()) {
        if (!entry.hadRecentInput) clsValue += entry.value;
      }
      metrics.cls = clsValue;
    }).observe({ type: 'layout-shift', buffered: true });

    // Resolve after collecting
    setTimeout(() => resolve(metrics), 3000);
  });
}
```

Use `mcp__chrome-devtools__performance_start_trace` and `mcp__chrome-devtools__performance_stop_trace` for detailed profiling data including main thread blocking time.

## Phase 2: GTM Container Analysis

### If Container JSON Available

Parse the exported JSON to extract:
- **Container size** (bytes)
- **Tag count** by type (Custom HTML, Google Analytics, Floodlight, etc.)
- **Trigger count** and types (Page View, Click, Custom Event, etc.)
- **Variable count** and types (DataLayer, DOM Element, JavaScript, etc.)
- **Tag firing sequences** and dependencies
- **Custom HTML content** (inline scripts)

### If Only Container ID Available

Infer container details from network data:
- Count tags from network requests
- Identify third-party domains loaded
- Measure script sizes and timing
- Check for known tag patterns (GA4, Meta Pixel, etc.)

### DataLayer Analysis

```javascript
// Use mcp__chrome-devtools__evaluate_script
() => {
  if (typeof dataLayer === 'undefined') return { error: 'No dataLayer found' };
  return {
    eventCount: dataLayer.length,
    events: dataLayer.map(item => ({
      event: item.event || 'push',
      keys: Object.keys(item)
    })),
    totalSize: JSON.stringify(dataLayer).length
  };
}
```

## Phase 3: Issue Detection

Run all 14 check categories:

### 1. Synchronous Script Loading

**What**: GTM container loaded with sync instead of async
**Impact**: Blocks HTML parsing, delays LCP
**Check**: Look for `<script src="...gtm.js">` without `async` or `defer`
**Fix**: Ensure GTM snippet uses async loading pattern

### 2. Blocking Tags

**What**: Tags that block the main thread for >50ms
**Impact**: Increases INP, degrades interactivity
**Check**: Profile main thread during tag execution
**Fix**: Defer non-critical tags, use tag sequencing

### 3. Large Payloads

**What**: Tags or container >100KB compressed
**Impact**: Increases load time, wastes bandwidth
**Check**: Measure transfer sizes of GTM resources
**Fix**: Remove unused tags, optimize custom HTML, consider server-side

### 4. Main Thread Blocking

**What**: JavaScript execution blocks main thread
**Impact**: Poor INP, delayed interaction response
**Check**: Use performance trace to measure long tasks
**Fix**: Break up long-running tag scripts, use Web Workers where possible

### 5. Missing Conditional Firing

**What**: Tags fire on all pages when only needed on specific pages
**Impact**: Unnecessary processing and network requests
**Check**: Analyze trigger conditions vs. page types
**Fix**: Add page path or event conditions to triggers

### 6. Trigger Optimization

**What**: Triggers using expensive DOM selectors or all-pages rules
**Impact**: Excessive event listener overhead
**Check**: Review trigger configurations for broad matching
**Fix**: Use specific CSS selectors, limit to relevant pages

### 7. Duplicate Tags

**What**: Same tracking pixel or analytics tag firing multiple times
**Impact**: Inflated metrics, wasted resources, double-counting
**Check**: Compare tag endpoints and parameters
**Fix**: Remove duplicates, consolidate similar tags

### 8. Orphaned Tags

**What**: Tags with no active triggers (paused or misconfigured)
**Impact**: Container bloat, maintenance burden
**Check**: Cross-reference tags with their trigger assignments
**Fix**: Remove or archive orphaned tags

### 9. Expensive Variables

**What**: Variables using DOM lookups or complex JavaScript on every evaluation
**Impact**: Repeated expensive computations
**Check**: Review variable types and computation cost
**Fix**: Cache values in dataLayer, use simpler variable types

### 10. Missing Async Attribute

**What**: Third-party scripts injected by tags without async/defer
**Impact**: Render-blocking, delays page load
**Check**: Inspect Custom HTML tags for script injection patterns
**Fix**: Add async attribute to injected scripts

### 11. Custom HTML Best Practices

**What**: Custom HTML tags with inline scripts that could use built-in tag types
**Impact**: Security risk, harder to maintain, potentially blocking
**Check**: Analyze Custom HTML content for convertible patterns
**Fix**: Convert to built-in tag templates where possible

### 12. Server-Side Candidates

**What**: Tags that could run server-side instead of client-side
**Impact**: Reduces client-side JavaScript, improves performance
**Check**: Identify tags sending data to first-party or server endpoints
**Fix**: Migrate eligible tags to server-side GTM container

### 13. Consent Mode Gaps

**What**: Tags firing before consent is granted
**Impact**: Privacy violations, regulatory risk
**Check**: Verify consent mode integration and tag firing sequence
**Fix**: Implement Google Consent Mode, add consent triggers

### 14. Tag Firing Order

**What**: Critical tags delayed by non-essential tags in the sequence
**Impact**: Important data collection delayed
**Check**: Review tag priority settings and sequencing
**Fix**: Set proper priority values, use tag sequencing groups

## Phase 4: Report Generation

### Executive Summary

```markdown
## GTM Performance Audit Summary

**Container**: GTM-XXXXXXX
**URL Tested**: https://example.com
**Date**: YYYY-MM-DD

### Key Metrics
- Container Size: XXX KB (compressed)
- Total Tags: NN (XX active, YY paused)
- GTM Load Time: XXXms
- Main Thread Blocking: XXXms
- Estimated CWV Impact: [Low/Medium/High]

### Quick Wins
1. [Quick win with estimated impact]
2. [Quick win with estimated impact]
3. [Quick win with estimated impact]
```

### Detailed Findings

Each finding should include:
- **Description**: What the issue is
- **Measurement**: Quantified impact (ms, KB, count)
- **CWV Impact**: Which Core Web Vital is affected and by how much
- **GTM Fix Steps**: Specific steps to fix in GTM admin
- **Risk Assessment**: Low/Medium/High risk of the fix
- **Priority**: Critical/High/Medium/Low

### Tag Inventory Table

```markdown
| Tag Name | Type | Trigger | Size | Exec Time | Status |
|----------|------|---------|------|-----------|--------|
| GA4 | Google Analytics | All Pages | 45KB | 120ms | Active |
| Meta Pixel | Custom HTML | All Pages | 32KB | 85ms | Active |
| Hotjar | Custom HTML | Page View | 28KB | 200ms | Active |
```

### Network Waterfall

Show timing of GTM-related requests:
```
0ms     100ms    200ms    300ms    400ms    500ms
|--------|--------|--------|--------|--------|
[==GTM Container (45KB)==]
         [====GA4 (32KB)====]
         [==Meta Pixel==]
                  [====Hotjar (28KB)====]
                           [=LinkedIn=]
```

### Implementation Checklist

```markdown
## Remediation Checklist

### Critical (Do This Week)
- [ ] Remove duplicate GA4 tag (saves ~120ms)
- [ ] Add async to Custom HTML script injections

### High Priority (Do This Sprint)
- [ ] Add page path conditions to 5 all-pages tags
- [ ] Convert 3 Custom HTML tags to built-in templates
- [ ] Remove 4 orphaned tags (saves ~15KB)

### Medium Priority (Plan for Next Sprint)
- [ ] Evaluate server-side GTM for conversion tags
- [ ] Implement consent mode v2
- [ ] Optimize dataLayer push frequency

### Low Priority (Backlog)
- [ ] Consolidate similar event triggers
- [ ] Review variable caching strategy
```

## Required MCP Integration

This skill requires **Chrome DevTools MCP**. Tools used:

- `mcp__chrome-devtools__evaluate_script` - Execute JavaScript for timing, dataLayer, resource analysis
- `mcp__chrome-devtools__list_network_requests` - Capture GTM network waterfall
- `mcp__chrome-devtools__list_console_messages` - Check for GTM errors
- `mcp__chrome-devtools__navigate_page` - Navigate to target URL
- `mcp__chrome-devtools__take_snapshot` - Get page structure for tag detection
- `mcp__chrome-devtools__performance_start_trace` - Start performance profiling
- `mcp__chrome-devtools__performance_stop_trace` - Stop profiling and get results
- `mcp__chrome-devtools__new_page` - Open fresh tab for clean measurement

## CMS-Specific GTM Patterns

### Drupal

**Common GTM Integration**:
- `google_tag` module (most common)
- Custom `html.html.twig` injection
- Config at `/admin/config/services/google-tag`

**Check for**:
- Module configuration: `drush config:get google_tag.settings`
- Container ID in config vs. hardcoded in templates
- Multiple containers (module + theme + custom module)
- DataLayer integration via `hook_google_tag_snippets_alter()`

### WordPress

**Common GTM Integration**:
- GTM4WP plugin (most common)
- Google Site Kit plugin
- Manual `header.php` injection
- Theme `functions.php` via `wp_head` action

**Check for**:
- Plugin settings: GTM4WP → Settings → Container ID
- Multiple injection points (plugin + theme + another plugin)
- DataLayer population via WooCommerce integration
- Custom event tracking in theme JavaScript

## Guardrails

- **Read-only**: Never modify GTM containers, tags, triggers, or variables
- **No credentials**: Never ask for or enter GTM admin credentials
- **Conservative estimates**: When unsure of impact, estimate conservatively
- **Preserve functionality**: Recommendations must not break tracking
- **Privacy-aware**: Flag consent issues but don't disable tags

## Integration with /audit-gtm Command

- **This Skill**: Focused GTM analysis during conversation
  - "Are our marketing tags slow?"
  - "How big is our GTM container?"
  - Single-tag or quick analysis

- **`/audit-gtm` Command**: Comprehensive GTM performance audit
  - Full container analysis
  - All 14 check categories
  - Detailed report with remediation plan

## Quick Tips

- **Container under 50KB compressed** is healthy; over 100KB needs attention
- **More than 30 active tags** usually indicates cleanup opportunity
- **Custom HTML tags** are the biggest performance risk - audit these first
- **All Pages triggers** are the most common source of waste
- **dataLayer pushes** before GTM loads are queued and processed in order
