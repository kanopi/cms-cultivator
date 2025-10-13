---
description: Generate Lighthouse performance report
allowed-tools: Bash(npm:*), Bash(lighthouse:*), Read, Write
---

Run Lighthouse audit and provide actionable recommendations.

## Instructions

1. **Run Lighthouse** on target URL or suggest running it
2. **Analyze results** across all categories
3. **Prioritize opportunities** by impact
4. **Provide specific fixes**

## Output Format

```markdown
# Lighthouse Performance Report

**URL**: [url]
**Date**: [date]
**Device**: Desktop / Mobile

## Scores

- 🎯 Performance: [score]/100
- ✅ Accessibility: [score]/100
- 🔍 Best Practices: [score]/100
- 📱 SEO: [score]/100
- ⚡ PWA: [score]/100

## Core Web Vitals

- **LCP**: [value]s ([good/needs improvement/poor])
- **TBT**: [value]ms (Total Blocking Time)
- **CLS**: [value] ([good/needs improvement/poor])

## Opportunities (Potential Savings)

### 1. Eliminate render-blocking resources
**Savings**: 1,200ms
**Resources**:
- style.css (450ms)
- main.js (750ms)

**How to Fix**:
\`\`\`html
<!-- Inline critical CSS -->
<style>/* critical CSS */</style>

<!-- Async non-critical CSS -->
<link rel="preload" href="style.css" as="style" onload="this.onload=null;this.rel='stylesheet'">

<!-- Defer JavaScript -->
<script src="main.js" defer></script>
\`\`\`

### 2. Properly size images  
**Savings**: 850ms, 4.2MB
**Images to resize**: [list]

### 3. Enable text compression
**Savings**: 650ms, 2.1MB

## Diagnostics

- Total page weight: [size]
- DOM size: [elements] elements
- JavaScript execution time: [ms]
- Main thread work: [ms]
- Avoid enormous network payloads: [size]

## Passed Audits ✅

- Uses HTTPS
- Valid robots.txt
- Avoids document.write()
- [etc...]

## Recommendations

1. **Quick Wins** (< 1 hour each):
   - Enable compression
   - Add cache headers
   - Defer offscreen images

2. **Medium Effort** (2-4 hours each):
   - Code split JavaScript
   - Optimize images
   - Eliminate render-blocking CSS

3. **Long Term**:
   - Migrate to HTTP/2
   - Implement service worker
   - Optimize third-party scripts

## Performance Budget

Set performance budgets:
\`\`\`json
{
  "resourceSizes": [
    { "resourceType": "script", "budget": 500 },
    { "resourceType": "image", "budget": 2000 },
    { "resourceType": "stylesheet", "budget": 200 }
  ],
  "timings": [
    { "metric": "interactive", "budget": 4000 },
    { "metric": "first-contentful-paint", "budget": 2000 }
  ]
}
\`\`\`
```
