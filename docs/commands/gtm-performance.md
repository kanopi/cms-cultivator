# GTM Performance Commands

Audit Google Tag Manager implementations for performance impact with flexible argument modes.

## Command

`/audit-gtm [options]` - Comprehensive GTM performance audit analyzing container size, tag execution, trigger efficiency, and Core Web Vitals impact

## Requirements

**Required**: Chrome DevTools MCP Server

This command requires an active Chrome DevTools MCP connection to perform live page profiling.

## Flexible Argument Modes

### Quick Checks During Development
```bash
/audit-gtm --quick --url=https://example.com
/audit-gtm --quick --scope=current-pr
/audit-gtm --quick --container-id=GTM-ABC123
```
- Fast container health check (~5 min)
- Tag count and container size
- Obvious blocking tags

### Standard Audits (Default)
```bash
/audit-gtm --url=https://example.com
/audit-gtm --url=https://example.com --with-container-json=./export.json
/audit-gtm --standard --format=json --url=https://example.com
```
- Full analysis (~15 min)
- All 14 issue detection checks
- CWV impact mapping
- Tag inventory with timing

### Comprehensive Audits (Pre-Launch)
```bash
/audit-gtm --comprehensive --url=https://example.com
/audit-gtm --comprehensive --format=summary
/audit-gtm --comprehensive --with-container-json=./container.json
```
- Deep profiling (~30 min)
- Custom HTML code review
- Server-side migration candidates
- Full remediation roadmap

## Argument Options

### Depth Modes
- `--quick` - Container size + tag count (~5 min)
- `--standard` - Full analysis with CWV mapping (default, ~15 min)
- `--comprehensive` - Deep profiling + remediation plan (~30 min)

### Scope Control
- `--scope=current-pr` - Only GTM-related files changed in current PR
- `--scope=container=<GTM-ID>` - Specific GTM container
- `--scope=entire` - Full GTM analysis (default)

### Output Formats
- `--format=report` - Detailed report with tag inventory (default)
- `--format=json` - JSON for CI/CD integration
- `--format=summary` - Executive summary with key findings

### GTM-Specific Options
- `--container-id=<GTM-XXXX>` - GTM container ID to audit
- `--with-container-json=<path>` - Path to exported container JSON
- `--url=<target-url>` - Target URL for live profiling

## Legacy Focus Options (Still Supported)

For backward compatibility, focus areas without `--` prefix still work:
- `container` - Container size and structure
- `tags` - Individual tag performance
- `triggers` - Trigger efficiency
- `datalayer` - DataLayer analysis
- `custom-html` - Custom HTML tag audit
- `consent` - Consent mode compliance

## What Gets Audited

### 14-Point Issue Detection

1. **Synchronous script loading** - GTM loaded without async
2. **Blocking tags** - Tags blocking main thread >50ms
3. **Large payloads** - Tags or container >100KB
4. **Main thread blocking** - JavaScript execution blocking interactivity
5. **Missing conditional firing** - Tags firing on all pages unnecessarily
6. **Trigger optimization** - Expensive DOM selectors and broad rules
7. **Duplicate tags** - Same tracking pixel firing multiple times
8. **Orphaned tags** - Tags with no active triggers
9. **Expensive variables** - Variables with costly DOM lookups
10. **Missing async attribute** - Third-party scripts without async/defer
11. **Custom HTML best practices** - Inline scripts that could use built-in types
12. **Server-side candidates** - Tags eligible for server-side GTM
13. **Consent mode gaps** - Tags firing before consent granted
14. **Tag firing order** - Critical tags delayed by non-essential tags

### CMS-Specific Patterns

#### Drupal
- `google_tag` module configuration
- Template-level GTM injection
- DataLayer hook implementations
- Multiple container detection

#### WordPress
- GTM4WP plugin settings
- `header.php` manual injection
- WooCommerce enhanced ecommerce overhead
- Google Site Kit conflicts

## CI/CD Integration

Export results as JSON for automated pipelines:

```yaml
# GitHub Actions example
- name: Run GTM audit
  run: /audit-gtm --standard --format=json --url=${{ env.SITE_URL }} > gtm-results.json

- name: Check container size
  run: |
    SIZE=$(jq '.container.size_kb' gtm-results.json)
    if (( $(echo "$SIZE > 100" | bc -l) )); then
      echo "GTM container exceeds 100KB threshold"
      exit 1
    fi
```

## Common Workflows

**Pre-Commit (GTM config changes):**
```bash
/audit-gtm --quick --scope=current-pr
```

**PR Review:**
```bash
/audit-gtm --standard --url=https://staging.example.com
```

**Pre-Launch:**
```bash
/audit-gtm --comprehensive --url=https://example.com --with-container-json=./export.json
```

**Tag Cleanup Sprint:**
```bash
/audit-gtm --comprehensive --format=summary
```

## Related Commands

- **[Performance Audit](performance.md)** - General performance audit (Core Web Vitals, assets, queries)
- **[Live Site Audit](live-site-auditing.md)** - Comprehensive audit (perf + a11y + security + quality)
- **[Security Audit](security.md)** - Security audit (includes third-party script risks)

See [Commands Overview](overview.md) for all available commands.
