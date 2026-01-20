# Performance Commands

Optimize Core Web Vitals and page speed with flexible argument modes for different use cases.

## Command

`/audit-perf [options]` - Comprehensive performance analysis and Core Web Vitals optimization

## Flexible Argument Modes

CMS Cultivator now supports multiple operation modes for performance audits:

### Quick Checks During Development
```bash
/audit-perf --quick --scope=current-pr
/audit-perf --quick --format=metrics
/audit-perf --quick --scope=frontend
```
- ⚡ Fast execution (~5 min)
- 🎯 Core Web Vitals only (LCP, INP, CLS)
- 💰 Lower token costs
- ✅ Perfect for pre-commit checks

### Standard Audits (Default)
```bash
/audit-perf
/audit-perf --scope=current-pr
/audit-perf --standard --scope=backend
```
- 🔍 Comprehensive analysis (~15 min)
- ✅ CWV + database queries + assets + caching
- 📊 Detailed optimization recommendations

### Comprehensive Audits (Pre-Release)
```bash
/audit-perf --comprehensive
/audit-perf --comprehensive --format=summary
/audit-perf --comprehensive --target=good
```
- 🔬 Deep analysis (~30 min)
- 💎 Full profiling with performance budgets
- 📋 Stakeholder-ready reports with ROI

## Argument Options

### Depth Modes
- `--quick` - Core Web Vitals only (~5 min)
- `--standard` - CWV + major bottlenecks (default, ~15 min)
- `--comprehensive` - Full profiling + recommendations (~30 min)

### Scope Control
- `--scope=current-pr` - Only files changed in current PR
- `--scope=frontend` - Assets, CSS, JS, images, fonts only
- `--scope=backend` - Database queries, caching, PHP only
- `--scope=module=<name>` - Specific module/directory
- `--scope=file=<path>` - Single file
- `--scope=entire` - Full codebase (default)

### Output Formats
- `--format=report` - Detailed report with metrics (default)
- `--format=json` - JSON for CI/CD integration
- `--format=summary` - Executive summary with business impact
- `--format=metrics` - Core Web Vitals metrics only

### Target Thresholds
- `--target=good` - Report only if failing "good" thresholds (LCP > 2.5s, INP > 200ms, CLS > 0.1)
- `--target=needs-improvement` - Report if failing moderate thresholds (LCP > 4.0s, INP > 500ms, CLS > 0.25)

## Legacy Focus Options (Still Supported)

For backward compatibility, focus areas without `--` prefix still work:
- `queries` - Database query optimization
- `n+1` - N+1 query detection and fixes
- `assets` - Asset optimization (images, fonts, CSS, JS)
- `bundles` - JavaScript bundle analysis
- `caching` - Caching strategy review
- `vitals` - Check all Core Web Vitals (LCP, INP, CLS)
- `lcp` - Largest Contentful Paint optimization
- `inp` - Interaction to Next Paint optimization
- `cls` - Cumulative Layout Shift fixes

## CI/CD Integration

Export results as JSON for automated pipelines:

```yaml
# GitHub Actions example
- name: Run performance audit
  run: /audit-perf --standard --format=json > perf-results.json

- name: Check Core Web Vitals
  run: |
    LCP=$(jq '.core_web_vitals.lcp.value' perf-results.json)
    if (( $(echo "$LCP > 2.5" | bc -l) )); then
      echo "LCP exceeds 2.5s threshold"
      exit 1
    fi
```

## Common Workflows

**Pre-Commit:**
```bash
/audit-perf --quick --scope=current-pr --format=metrics
```

**PR Review:**
```bash
/audit-perf --standard --scope=current-pr
```

**Pre-Release:**
```bash
/audit-perf --comprehensive --target=good --format=summary
```

**Frontend Only:**
```bash
/audit-perf --standard --scope=frontend
```

**Backend Only:**
```bash
/audit-perf --standard --scope=backend
```
- `fid` - First Input Delay optimization (legacy)
- `cls` - Cumulative Layout Shift fixes

See [Commands Overview](overview.md) for detailed usage.
