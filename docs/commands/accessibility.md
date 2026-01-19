# Accessibility Commands

Ensure WCAG 2.1 Level AA compliance with flexible argument modes for different use cases.

## Command

`/audit-a11y [options]` - Comprehensive accessibility audit with WCAG 2.1 Level AA compliance

## Flexible Argument Modes

CMS Cultivator now supports multiple operation modes for accessibility audits:

### Quick Checks During Development
```bash
/audit-a11y --quick --scope=current-pr
/audit-a11y --quick --scope=current-pr --format=checklist
```
- ⚡ Fast execution (~5 min)
- 🎯 Critical WCAG AA failures only
- 💰 Lower token costs
- ✅ Perfect for pre-commit checks

### Standard Audits (Default)
```bash
/audit-a11y
/audit-a11y --scope=current-pr
```
- 🔍 Comprehensive analysis (~15 min)
- ✅ Full WCAG 2.1 Level AA compliance
- 📊 Detailed reports with remediation steps

### Comprehensive Audits (Pre-Release)
```bash
/audit-a11y --comprehensive
/audit-a11y --comprehensive --format=summary
```
- 🔬 Deep analysis (~30 min)
- 💎 WCAG AA + AAA + best practices
- 📋 Stakeholder-ready reports

## Argument Options

### Depth Modes
- `--quick` - Critical issues only (~5 min)
- `--standard` - Full WCAG AA audit (default, ~15 min)
- `--comprehensive` - Deep dive with AAA and best practices (~30 min)

### Scope Control
- `--scope=current-pr` - Only files changed in current PR
- `--scope=module=<name>` - Specific module/directory
- `--scope=file=<path>` - Single file
- `--scope=entire` - Full codebase (default)

### Output Formats
- `--format=report` - Detailed markdown (default)
- `--format=json` - JSON for CI/CD integration
- `--format=summary` - Executive summary
- `--format=checklist` - Simple pass/fail

## Legacy Focus Options (Still Supported)

For backward compatibility, focus areas without `--` prefix still work:
- `contrast` - Check color contrast only (WCAG 1.4.3)
- `aria` - Check ARIA attributes only
- `headings` - Check heading hierarchy only
- `forms` - Check form accessibility only
- `alt-text` - Check image alt text only
- `keyboard` - Check keyboard navigation only

## CI/CD Integration

Export results as JSON for automated pipelines:

```yaml
# GitHub Actions example
- name: Run accessibility audit
  run: /audit-a11y --standard --format=json > audit-results.json

- name: Check results
  run: |
    if [ $(jq '.summary.failures' audit-results.json) -gt 0 ]; then
      exit 1
    fi
```

## Common Workflows

**Pre-Commit:**
```bash
/audit-a11y --quick --scope=current-pr --format=checklist
```

**PR Review:**
```bash
/audit-a11y --standard --scope=current-pr
```

**Pre-Release:**
```bash
/audit-a11y --comprehensive --format=report
```

See [Commands Overview](overview.md) for detailed usage.
