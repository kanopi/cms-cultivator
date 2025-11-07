# Performance Commands

Optimize Core Web Vitals and page speed with a single comprehensive command.

## Command

`/audit-perf [focus]` - Comprehensive performance analysis and Core Web Vitals optimization

## Usage Modes

- `/audit-perf` - Full performance audit across all areas
- `/audit-perf [focus]` - Focused analysis (queries, n+1, assets, bundles, caching)
- `/audit-perf vitals` - Check all Core Web Vitals (LCP, INP/FID, CLS)
- `/audit-perf [metric]` - Optimize specific vital (lcp, inp, fid, cls)
- `/audit-perf lighthouse` - Generate Lighthouse performance report
- `/audit-perf report` - Generate stakeholder-friendly performance report

## Focus Options

- `queries` - Database query optimization
- `n+1` - N+1 query detection and fixes
- `assets` - Asset optimization (images, fonts, CSS, JS)
- `bundles` - JavaScript bundle analysis
- `caching` - Caching strategy review

## Metric Options

- `vitals` - Check all Core Web Vitals
- `lcp` - Largest Contentful Paint optimization
- `inp` - Interaction to Next Paint optimization
- `fid` - First Input Delay optimization (legacy)
- `cls` - Cumulative Layout Shift fixes

See [Commands Overview](overview.md) for detailed usage.
