---
name: performance-audit
description: Comprehensive performance analysis and Core Web Vitals optimization for Drupal and WordPress projects. Spawns performance-specialist for full analysis. Invoke when user runs /audit-perf, requests a full performance audit, needs Core Web Vitals analysis (LCP, INP, CLS), or asks for comprehensive performance assessment. Supports --quick, --standard, --comprehensive depth modes and scope/format/target flags.
disable-model-invocation: true
---

# Performance Audit

Comprehensive performance analysis and Core Web Vitals optimization using the performance-specialist agent.

## Usage

- `/audit-perf` — Full performance audit (standard depth)
- `/audit-perf --quick --scope=current-pr` — Pre-commit Core Web Vitals check
- `/audit-perf --comprehensive --format=summary` — Pre-release deep audit with executive summary
- `/audit-perf --standard --format=json` — CI/CD integration output
- `/audit-perf queries` — Legacy focus area (still supported)

## Arguments

### Depth Modes
- `--quick` — Core Web Vitals only (~5 min)
- `--standard` — CWV + major bottlenecks (default, ~15 min)
- `--comprehensive` — Full profiling + recommendations (~30 min)

### Scope Control
- `--scope=current-pr` — Only files changed in current PR
- `--scope=frontend` — Only frontend files (CSS, JS, images)
- `--scope=backend` — Only backend files (PHP, SQL, caching)
- `--scope=module=<name>` — Specific module/directory
- `--scope=file=<path>` — Single file
- `--scope=entire` — Full codebase (default)

### Output Formats
- `--format=report` — Detailed report with metrics (default)
- `--format=json` — Structured JSON for CI/CD
- `--format=summary` — Executive summary
- `--format=metrics` — Core Web Vitals metrics only

### Target Thresholds
- `--target=good` — Report only if failing "good" thresholds (LCP > 2.5s, INP > 200ms, CLS > 0.1)
- `--target=needs-improvement` — Report if needing improvement (LCP > 4.0s, INP > 500ms, CLS > 0.25)

### Legacy Focus Areas (Still Supported)
`queries`, `n+1`, `assets`, `bundles`, `caching`, `vitals`, `lcp`, `inp`, `cls`

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() or bash tools are unavailable, perform performance analysis directly:

1. **Parse arguments** — Determine depth mode, scope, format, and any legacy focus area
2. **Identify files to analyze** — Use Glob to find PHP, CSS, JS, SCSS, and SQL files
3. **Analyze performance directly**:
   - Use Read and Grep to identify N+1 query patterns, missing cache tags, SELECT * queries
   - Check CSS for render-blocking patterns, unused selectors, missing critical CSS hints
   - Check JS for bundle size indicators, synchronous blocking, missing defer/async
   - Review image markup for missing dimensions, lazy loading, responsive images
   - Detect CMS-specific patterns (Drupal cache tags, WordPress transients)
4. **Generate report** — Format findings per requested output format, prioritized by impact
5. **Save report** — Write to `audit-perf-YYYY-MM-DD-HHMM.md` and present path to user

**Supported checks in Tier 1**: code-level query patterns, caching strategy, asset markup, CMS-specific anti-patterns.

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() available:

1. **Parse arguments** — Determine depth, scope, format, and target threshold
2. **Determine files** — For `--scope=current-pr`:
   ```bash
   git diff --name-only origin/main...HEAD | grep -E '\.(php|tsx?|jsx?|css|scss|sql)$'
   ```
3. **Spawn performance-specialist**:
   ```
   Task(cms-cultivator:performance-specialist:performance-specialist,
        prompt="Analyze performance and optimize Core Web Vitals with:
          - Depth mode: {depth}
          - Scope: {scope}
          - Format: {format}
          - Target threshold: {target or 'none'}
          - Focus area: {focus or 'complete analysis'}
          - Files to analyze: {file_list}
        Check database queries, caching strategies, asset optimization, and rendering for Drupal and WordPress. Save report to audit-perf-YYYY-MM-DD-HHMM.md and present the file path.")
   ```
4. **Present results** to user with file path

## Core Web Vitals Targets

| Metric | Good | Needs Improvement | Poor |
|--------|------|-------------------|------|
| LCP | < 2.5s | 2.5s–4.0s | > 4.0s |
| INP | < 200ms | 200ms–500ms | > 500ms |
| CLS | < 0.1 | 0.1–0.25 | > 0.25 |

## CMS-Specific Optimizations

**Drupal**: Cache tags/contexts/max-age, EntityQuery optimization, Views caching, BigPipe, CSS/JS aggregation

**WordPress**: Transient caching, WP_Query optimization (no_found_rows, update_post_term_cache), object cache (Redis/Memcached), conditional asset loading

## Performance Budgets

| Metric | Target |
|--------|--------|
| Total JS | < 200KB |
| Total CSS | < 100KB |
| Images | < 1MB total |
| HTTP Requests | < 50 |

## Related Skills

- **performance-analyzer** — Quick code-level performance checks (auto-activates on "slow" or "optimize")
- **audit-export** — Export findings to CSV for project management tools
- **audit-report** — Generate client-facing executive summary from audit file
