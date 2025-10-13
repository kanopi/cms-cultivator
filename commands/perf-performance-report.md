---
description: Generate comprehensive performance report for stakeholders
allowed-tools: Read, Glob, Grep, Write
---

Create executive-level performance report with recommendations.

## Instructions

1. **Compile all performance data**
2. **Create stakeholder-friendly summary**
3. **Provide ROI estimates**
4. **Include implementation roadmap**

## Output Format

```markdown
# Performance Report

**Project**: [Project Name]
**Date**: [Date]
**Auditor**: [Name]

## Executive Summary

This report summarizes performance analysis of [Project Name]. The site was evaluated for speed, efficiency, and user experience.

**Overall Performance Score**: 45/100 ⚠️ Poor

**Key Findings**:
- Page load time: 6.8s (target: <3s)
- Core Web Vitals failing
- 12.3MB total page weight (target: <3MB)
- 47 database queries per page (target: <10)

**Business Impact**:
- 53% of users abandon sites loading >3s
- Each 1s delay = 7% conversion loss
- Current 6.8s load = ~28% conversion loss
- **Estimated revenue impact**: [$X,000/month]

## Performance Scores

| Metric | Score | Status |
|--------|-------|--------|
| Performance | 45/100 | ❌ Poor |
| Accessibility | 87/100 | ✅ Good |
| Best Practices | 72/100 | ⚠️ Fair |
| SEO | 91/100 | ✅ Good |

## Core Web Vitals

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| LCP | 3.8s | <2.5s | ❌ Fail |
| INP | 280ms | <200ms | ⚠️ Needs Improvement |
| CLS | 0.18 | <0.1 | ⚠️ Needs Improvement |

## Critical Issues

1. **Large JavaScript Bundle** (2.3MB)
   - Impact: Slow loading, poor interactivity
   - Priority: High
   - Effort: 8 hours

2. **Unoptimized Images** (8.5MB)
   - Impact: Slow LCP, high bandwidth
   - Priority: High
   - Effort: 4 hours

3. **N+1 Database Queries**
   - Impact: Slow server response
   - Priority: High
   - Effort: 6 hours

4. **No Caching Strategy**
   - Impact: Unnecessary server load
   - Priority: Medium
   - Effort: 4 hours

## Performance Goals

**Target Metrics**:
- Page Load: <3s
- LCP: <2.5s
- INP: <200ms
- CLS: <0.1
- Page Weight: <3MB
- Database Queries: <10

## Implementation Roadmap

### Phase 1: Quick Wins (Week 1)
**Effort**: 8 hours
**Expected Improvement**: 30%

- Enable production build/minification
- Enable compression (gzip/brotli)
- Add cache headers to static assets
- Optimize hero image

**Expected Results**:
- Page load: 6.8s → 4.2s
- Page weight: 12.3MB → 6.5MB

### Phase 2: Major Optimizations (Week 2-3)
**Effort**: 18 hours
**Expected Improvement**: 50%

- Fix N+1 query problems
- Implement code splitting
- Convert images to WebP
- Add lazy loading
- Enable page caching

**Expected Results**:
- Page load: 4.2s → 2.8s
- LCP: 3.8s → 2.1s
- Database queries: 47 → 8

### Phase 3: Fine-Tuning (Week 4)
**Effort**: 12 hours
**Expected Improvement**: 15%

- Implement CDN
- Optimize web fonts
- Reduce third-party scripts
- Add service worker

**Expected Results**:
- Page load: 2.8s → 2.3s
- Performance score: 45 → 85

## Total Investment

**Time**: 38 hours (~1 week)
**Cost**: [$X based on hourly rate]

## Expected ROI

**Current State**:
- Monthly visitors: [X]
- Conversion rate: 2%
- Revenue per conversion: [$X]
- Monthly revenue: [$X]

**After Optimization**:
- Estimated conversion lift: +28%
- New conversion rate: 2.56%
- Additional monthly revenue: [$X]

**ROI**: [X]% in first month

## Monitoring & Maintenance

**Recommendations**:
1. Set up Real User Monitoring (RUM)
2. Configure performance budgets
3. Implement automated Lighthouse CI
4. Monthly performance reviews
5. Performance regression testing

## Competitive Analysis

| Competitor | Load Time | Performance Score |
|------------|-----------|-------------------|
| Us (Current) | 6.8s | 45 |
| Competitor A | 2.1s | 92 |
| Competitor B | 3.4s | 78 |
| Us (Target) | 2.3s | 85 |

## Conclusion

Significant performance improvements are achievable with focused effort. The estimated ROI makes this a high-priority initiative that will improve user experience and business metrics.

## Next Steps

1. Approve proposed roadmap
2. Allocate development resources
3. Begin Phase 1 quick wins
4. Set up monitoring infrastructure
5. Schedule regular performance audits

---

**Prepared By**: [Name]
**Contact**: [Email]
**Date**: [Date]
```
