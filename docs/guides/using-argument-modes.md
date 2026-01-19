# Using Argument Modes

Complete guide to using flexible argument modes in CMS Cultivator commands.

## Overview

Four commands support advanced argument modes for flexible auditing and analysis:

- **`/audit-a11y [options]`** - Accessibility audits
- **`/audit-perf [options]`** - Performance audits
- **`/audit-security [options]`** - Security audits
- **`/quality-analyze [options]`** - Code quality analysis

These modes allow you to:
- 🚀 Run quick pre-commit checks
- 🔍 Perform comprehensive pre-release audits
- 🎯 Focus on specific code areas
- 📊 Export results in different formats
- 💰 Control token usage and execution time

---

## Argument Types

### 1. Depth Modes

Control how thorough the analysis is:

| Mode | Time | Use Case | Coverage |
|------|------|----------|----------|
| `--quick` | ~5 min | Pre-commit checks | Critical issues only |
| `--standard` | ~15 min | PR reviews (default) | Comprehensive analysis |
| `--comprehensive` | ~30 min | Pre-release audits | Deep dive + best practices |

**Examples:**
```bash
# Quick accessibility check
/audit-a11y --quick

# Standard performance audit (default, can omit --standard)
/audit-perf

# Comprehensive security audit
/audit-security --comprehensive
```

---

### 2. Scope Control

Control what code is analyzed:

| Scope | Description | Use Case |
|-------|-------------|----------|
| `--scope=current-pr` | Only PR files | Fast PR validation |
| `--scope=module=<name>` | Specific directory | Module-focused audit |
| `--scope=file=<path>` | Single file | Targeted analysis |
| `--scope=entire` | Full codebase (default) | Complete audit |

**Command-specific scopes:**

**Performance:**
- `--scope=frontend` - CSS, JS, images, fonts only
- `--scope=backend` - Database queries, caching, PHP only

**Security:**
- `--scope=user-input` - Forms, queries, file uploads, APIs
- `--scope=auth` - Authentication/authorization logic
- `--scope=api` - API endpoints and integrations

**Quality:**
- `--scope=recent-changes` - Files changed since main branch

**Examples:**
```bash
# Check only PR files
/audit-a11y --scope=current-pr

# Check specific module
/audit-perf --scope=module=src/components

# Check frontend performance only
/audit-perf --scope=frontend

# Check authentication security
/audit-security --scope=auth

# Check recent code changes
/quality-analyze --scope=recent-changes
```

---

### 3. Output Formats

Control how results are presented:

| Format | Description | Use Case |
|--------|-------------|----------|
| `--format=report` | Detailed markdown (default) | Development review |
| `--format=json` | Structured JSON | CI/CD integration |
| `--format=summary` | Executive summary | Stakeholder reports |
| `--format=checklist` | Simple pass/fail | Quick validation |

**Command-specific formats:**

**Performance:**
- `--format=metrics` - Core Web Vitals scores only

**Security:**
- `--format=sarif` - SARIF format for security tools

**Quality:**
- `--format=refactoring-plan` - Prioritized refactoring recommendations

**Examples:**
```bash
# Get JSON for CI/CD
/audit-a11y --format=json

# Get executive summary
/audit-perf --format=summary

# Get simple checklist
/audit-a11y --format=checklist

# Get SARIF for security tools
/audit-security --format=sarif

# Get refactoring plan
/quality-analyze --format=refactoring-plan
```

---

### 4. Threshold Controls

Set quality gates and severity filters:

**Performance:**
- `--target=good` - Report only if failing "good" thresholds
- `--target=needs-improvement` - Report if failing moderate thresholds

**Security:**
- `--min-severity=high` - Only high/critical issues
- `--min-severity=medium` - Medium+ issues (default)
- `--min-severity=low` - All findings

**Quality:**
- `--max-complexity=N` - Report functions with complexity > N
- `--min-grade=A|B|C` - Report files below grade threshold

**Examples:**
```bash
# Only report if failing "good" thresholds
/audit-perf --target=good

# Only report high-severity security issues
/audit-security --min-severity=high

# Report functions with complexity > 10
/quality-analyze --max-complexity=10

# Report files below B grade
/quality-analyze --min-grade=B
```

---

### 5. Legacy Focus Areas (Backward Compatible)

Single-word arguments without `--` prefix still work for backward compatibility:

**Accessibility:**
- `contrast`, `keyboard`, `aria`, `semantic-html`, `headings`, `forms`, `alt-text`

**Performance:**
- `queries`, `n+1`, `assets`, `bundles`, `caching`, `vitals`, `lcp`, `inp`, `cls`

**Security:**
- `injection`, `xss`, `csrf`, `auth`, `encryption`, `dependencies`

**Quality:**
- `complexity`, `debt`, `patterns`, `maintainability`, `standards`

**Examples:**
```bash
# Legacy syntax still works
/audit-a11y contrast
/audit-perf queries
/audit-security xss
/quality-analyze complexity

# Combine legacy focus with new modes
/audit-a11y contrast --quick
/audit-perf queries --scope=current-pr
/audit-security xss --min-severity=high
```

---

## Common Workflows

### Pre-Commit Workflow

Fast validation before committing changes:

```bash
# Accessibility check
/audit-a11y --quick --scope=current-pr --format=checklist

# Performance check
/audit-perf --quick --scope=current-pr --format=metrics

# Security check
/audit-security --quick --scope=current-pr --min-severity=high

# Quality check
/quality-analyze --quick --scope=current-pr --max-complexity=10
```

**Characteristics:**
- ⚡ Fast (~5 min per command)
- 🎯 Critical issues only
- 💰 Lower token costs
- ✅ Catches major problems early

---

### PR Review Workflow

Standard validation for pull requests:

```bash
# Accessibility review
/audit-a11y --standard --scope=current-pr

# Performance review
/audit-perf --standard --scope=current-pr

# Security review
/audit-security --standard --scope=current-pr

# Quality review
/quality-analyze --standard --scope=current-pr
```

**Characteristics:**
- 🔍 Comprehensive (~15 min per command)
- ✅ Full compliance checks
- 📊 Detailed reports with remediation
- 🎯 Focused on changed files only

---

### Pre-Release Workflow

Thorough validation before production deployment:

```bash
# Comprehensive accessibility audit
/audit-a11y --comprehensive --format=summary

# Comprehensive performance audit
/audit-perf --comprehensive --target=good --format=summary

# Comprehensive security audit
/audit-security --comprehensive --format=summary

# Comprehensive quality analysis
/quality-analyze --comprehensive --format=refactoring-plan
```

**Characteristics:**
- 🔬 Deep analysis (~30 min per command)
- 💎 Best practices included
- 📋 Stakeholder-ready reports
- ✅ Production-ready confidence

---

### CI/CD Integration Workflow

Automated quality gates in pipelines:

**GitHub Actions Example:**

```yaml
name: Quality Gates

on: [pull_request]

jobs:
  accessibility:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Accessibility Audit
        run: /audit-a11y --standard --format=json > a11y.json

      - name: Check Failures
        run: |
          FAILURES=$(jq '.summary.failures' a11y.json)
          if [ "$FAILURES" -gt 0 ]; then
            echo "Accessibility failures found"
            exit 1
          fi

  performance:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Performance Audit
        run: /audit-perf --standard --format=json > perf.json

      - name: Check Core Web Vitals
        run: |
          LCP=$(jq '.core_web_vitals.lcp.value' perf.json)
          if (( $(echo "$LCP > 2.5" | bc -l) )); then
            echo "LCP exceeds 2.5s threshold"
            exit 1
          fi

  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Security Audit
        run: /audit-security --standard --format=sarif > security.sarif

      - name: Upload SARIF
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: security.sarif

  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Quality Analysis
        run: /quality-analyze --standard --format=json > quality.json

      - name: Check Complexity
        run: |
          AVG=$(jq '.summary.average_complexity' quality.json)
          if (( $(echo "$AVG > 10" | bc -l) )); then
            echo "Complexity exceeds threshold"
            exit 1
          fi
```

---

## Combining Arguments

Arguments can be combined for powerful, targeted audits:

### Example Combinations

**Quick security check on user input with high severity only:**
```bash
/audit-security --quick --scope=user-input --min-severity=high
```

**Comprehensive accessibility audit on current PR with executive summary:**
```bash
/audit-a11y --comprehensive --scope=current-pr --format=summary
```

**Standard performance audit on backend with JSON output:**
```bash
/audit-perf --standard --scope=backend --format=json
```

**Quick quality check on module with strict complexity threshold:**
```bash
/quality-analyze --quick --scope=module=src/api --max-complexity=8
```

**Legacy focus combined with new modes:**
```bash
/audit-a11y contrast --quick --scope=current-pr
/audit-perf queries --standard --format=json
/audit-security xss --comprehensive --min-severity=medium
```

---

## Best Practices

### 1. Start Quick, Go Deep

Use `--quick` during development, `--comprehensive` before release:

```bash
# During development (multiple times per day)
/audit-a11y --quick --scope=current-pr

# Before creating PR (once per PR)
/audit-a11y --standard --scope=current-pr

# Before release (once per release)
/audit-a11y --comprehensive
```

### 2. Scope Early and Often

Use `--scope=current-pr` to catch issues early:

```bash
# Good: Fast feedback on your changes
/audit-security --quick --scope=current-pr

# Slower: Analyzes entire codebase
/audit-security --quick
```

### 3. Use JSON for Automation

Always use `--format=json` in CI/CD:

```bash
# Good: Machine-readable for automation
/audit-perf --standard --format=json > results.json

# Not ideal: Markdown harder to parse
/audit-perf --standard > results.md
```

### 4. Set Appropriate Thresholds

Use severity and quality thresholds to reduce noise:

```bash
# During development: Focus on critical issues
/audit-security --quick --min-severity=high

# Before release: Catch everything
/audit-security --comprehensive --min-severity=low
```

### 5. Combine Formats

Use different formats for different audiences:

```bash
# For developers (detailed)
/audit-a11y --comprehensive --format=report

# For stakeholders (high-level)
/audit-a11y --comprehensive --format=summary

# For CI/CD (structured)
/audit-a11y --comprehensive --format=json
```

---

## Performance Considerations

### Execution Time by Mode

| Mode | Time | Token Usage | Use Case |
|------|------|-------------|----------|
| `--quick` | ~5 min | Low | Pre-commit, rapid iteration |
| `--standard` | ~15 min | Medium | PR reviews, regular checks |
| `--comprehensive` | ~30 min | High | Pre-release, deep analysis |

### Scope Impact on Performance

| Scope | Files Analyzed | Speed | Token Usage |
|-------|----------------|-------|-------------|
| `--scope=file=<path>` | 1 | Fastest | Minimal |
| `--scope=current-pr` | 5-20 | Fast | Low |
| `--scope=module=<name>` | 10-100 | Medium | Medium |
| `--scope=entire` | All | Slowest | High |

### Optimization Tips

1. **Use scopes to limit analysis:**
   ```bash
   /audit-a11y --quick --scope=current-pr  # Faster
   /audit-a11y --quick                     # Slower
   ```

2. **Choose appropriate depth:**
   ```bash
   /audit-perf --quick      # 5 min
   /audit-perf --standard   # 15 min
   /audit-perf --comprehensive  # 30 min
   ```

3. **Use targeted focus areas:**
   ```bash
   /audit-security xss --quick  # Faster than full audit
   /audit-security --quick      # Full OWASP Top 3
   ```

---

## Troubleshooting

### "Argument not recognized"

**Problem:** Using incorrect argument syntax

**Solution:** Ensure arguments start with `--` for new modes:
```bash
# Wrong
/audit-a11y quick

# Correct
/audit-a11y --quick

# Legacy (also correct)
/audit-a11y contrast
```

### "No files found in scope"

**Problem:** Scope filter matches no files

**Solution:** Verify scope path and that files exist:
```bash
# Check what files git diff returns
git diff --name-only origin/main...HEAD

# Then use that scope
/audit-a11y --scope=current-pr
```

### "JSON output invalid"

**Problem:** Output includes non-JSON content

**Solution:** Redirect only JSON to file:
```bash
# Correct
/audit-perf --format=json > results.json

# Verify JSON
jq . results.json
```

---

## FAQ

### Can I combine multiple scopes?

No, only one scope can be active at a time. Use the most appropriate scope for your needs.

### What's the default if I don't specify a mode?

Defaults are:
- Depth: `--standard`
- Scope: `--scope=entire`
- Format: `--format=report`

### Do new modes work with legacy focus areas?

Yes! You can combine them:
```bash
/audit-a11y contrast --quick --scope=current-pr
```

### Can I use these modes in scripts?

Absolutely! They're designed for both interactive and automated use:
```bash
#!/bin/bash
/audit-a11y --quick --scope=current-pr --format=json > a11y.json
/audit-perf --quick --scope=current-pr --format=json > perf.json
/audit-security --quick --scope=current-pr --format=json > security.json
```

### How do I know which mode to use?

Follow this decision tree:
- Pre-commit? → `--quick --scope=current-pr`
- PR review? → `--standard --scope=current-pr`
- Pre-release? → `--comprehensive`
- CI/CD? → Add `--format=json`

---

## Additional Resources

- [Accessibility Commands](../commands/accessibility.md) - Full accessibility audit documentation
- [Performance Commands](../commands/performance.md) - Full performance audit documentation
- [Security Commands](../commands/security.md) - Full security audit documentation
- [Code Quality Commands](../commands/code-quality.md) - Full quality analysis documentation
- [Commands Overview](../commands/overview.md) - All available commands

---

## Feedback

Have suggestions for new argument modes or improvements? Please [open an issue](https://github.com/kanopi/cms-cultivator/issues) on GitHub.
