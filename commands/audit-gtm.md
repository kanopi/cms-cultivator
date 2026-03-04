---
description: Comprehensive Google Tag Manager performance audit analyzing container size, tag execution, trigger efficiency, and Core Web Vitals impact
argument-hint: "[options]"
allowed-tools: Task, Bash(git:*)
---

Spawn the **gtm-specialist** agent using:

```
Task(cms-cultivator:gtm-specialist:gtm-specialist,
     prompt="Audit Google Tag Manager implementation for performance impact with the following parameters:
       - Depth mode: [quick/standard/comprehensive - parsed from arguments, default: standard]
       - Scope: [current-pr/container/entire - parsed from arguments, default: entire]
       - Format: [report/json/summary - parsed from arguments, default: report]
       - Container ID: [GTM-XXXX if provided via --container-id]
       - Container JSON: [file path if provided via --with-container-json]
       - Target URL: [URL if provided via --url]
       - Focus area: [use legacy focus argument if provided, otherwise 'complete analysis']
       - Files to analyze: [file list based on scope]
     Analyze container configuration, measure tag execution timing, identify blocking tags, evaluate trigger efficiency, and map impact to Core Web Vitals. Requires Chrome DevTools MCP. Save the comprehensive audit report to a file (audit-gtm-YYYY-MM-DD-HHMM.md) and present the file path to the user.")
```

## Arguments

This command supports flexible argument modes for different use cases:

### Depth Modes
- `--quick` - Container size + tag count (~5 min) - Quick health check
- `--standard` - Full analysis with CWV mapping (default, ~15 min) - Complete GTM audit
- `--comprehensive` - Deep profiling + remediation plan (~30 min) - Pre-launch audit

### Scope Control
- `--scope=current-pr` - Only GTM-related files changed in current PR (uses git diff)
- `--scope=container=<GTM-ID>` - Specific GTM container (e.g., `--scope=container=GTM-ABC123`)
- `--scope=entire` - Full GTM analysis including codebase integration (default)

### Output Formats
- `--format=report` - Detailed report with tag inventory and remediation plan (default)
- `--format=json` - Structured JSON for CI/CD integration
- `--format=summary` - Executive summary with key findings

### GTM-Specific Options
- `--container-id=<GTM-XXXX>` - GTM container ID to audit
- `--with-container-json=<path>` - Path to exported container JSON file
- `--url=<target-url>` - Target URL for live profiling

### Legacy Focus Areas (Still Supported)
For backward compatibility, single-word focus areas without `--` prefix are treated as legacy focus filters:
- `container` - Container size and structure analysis
- `tags` - Individual tag performance analysis
- `triggers` - Trigger efficiency evaluation
- `datalayer` - DataLayer analysis and optimization
- `custom-html` - Custom HTML tag security and performance audit
- `consent` - Consent mode compliance check

## Usage Examples

### Quick Checks
```bash
# Quick container health check
/audit-gtm --quick --url=https://example.com

# Quick check on PR changes affecting GTM
/audit-gtm --quick --scope=current-pr

# Quick check with specific container
/audit-gtm --quick --container-id=GTM-ABC123
```

### Standard Audits
```bash
# Standard audit (default)
/audit-gtm --url=https://example.com

# Standard audit with container JSON for deeper analysis
/audit-gtm --url=https://example.com --with-container-json=./gtm-export.json

# Standard audit with JSON output for CI/CD
/audit-gtm --standard --format=json --url=https://example.com
```

### Comprehensive Audits
```bash
# Comprehensive pre-launch audit
/audit-gtm --comprehensive --url=https://example.com

# Comprehensive audit with executive summary
/audit-gtm --comprehensive --format=summary

# Comprehensive audit with container export
/audit-gtm --comprehensive --url=https://example.com --with-container-json=./container.json
```

### Legacy Syntax (Still Works)
```bash
# Focus on specific area (legacy)
/audit-gtm container
/audit-gtm tags
/audit-gtm custom-html

# Combine legacy focus with new modes
/audit-gtm tags --quick
/audit-gtm consent --scope=current-pr
```

## Usage

**Full Audit:**
- `/audit-gtm` - Complete GTM performance analysis

**Focus Areas:**
- `/audit-gtm container` - Container size and structure
- `/audit-gtm tags` - Individual tag performance
- `/audit-gtm triggers` - Trigger efficiency
- `/audit-gtm datalayer` - DataLayer analysis
- `/audit-gtm custom-html` - Custom HTML tag audit
- `/audit-gtm consent` - Consent mode compliance

---

## Tool Usage

**Allowed operations:**
- Spawn gtm-specialist agent
- Analyze GTM integration code in codebase
- Profile tag execution via Chrome DevTools MCP
- Measure Core Web Vitals impact
- Generate performance reports with remediation plans

**Not allowed:**
- Do not modify GTM containers, tags, triggers, or variables
- Do not enter GTM admin credentials
- Do not modify tracking code without explicit approval

The gtm-specialist agent performs all audit operations.

---

## How It Works

This command spawns the **gtm-specialist** agent, which uses the **gtm-performance-audit** skill and performs comprehensive GTM audits using Chrome DevTools MCP.

### 1. Parse Arguments

The command first parses the arguments to determine the audit parameters:

**Depth mode:**
- Check for `--quick`, `--standard`, or `--comprehensive` flags
- Default: `--standard` (if not specified)

**Scope:**
- Check for `--scope=<value>` flag
- If `--scope=current-pr`: Get GTM-related changed files using `git diff --name-only origin/main...HEAD`
- If `--scope=container=<id>`: Focus on specific container
- Default: `--scope=entire` (analyze full GTM setup)

**Format:**
- Check for `--format=<value>` flag
- Options: `report` (default), `json`, `summary`
- Default: `--format=report`

**GTM options:**
- Check for `--container-id=<value>`, `--url=<value>`, `--with-container-json=<value>`
- Pass through to agent

**Legacy focus area:**
- If argument doesn't start with `--`, treat as legacy focus area
- Examples: `container`, `tags`, `triggers`, `datalayer`, `custom-html`, `consent`
- Can be combined with new flags: `/audit-gtm tags --quick`

### 2. Determine Files to Analyze

Based on the scope parameter:

**For `current-pr`:**
```bash
git diff --name-only origin/main...HEAD | grep -iE '(gtm|google.tag|tag.manager|datalayer)'
```

**For `container=<id>`:**
Focus analysis on the specified container.

**For `entire`:**
Analyze all GTM integration points in the codebase plus live page profiling.

### 3. Spawn GTM Specialist

Pass all parsed parameters to the agent:
```
Task(cms-cultivator:gtm-specialist:gtm-specialist,
     prompt="Run GTM performance audit with:
       - Depth mode: {depth}
       - Scope: {scope}
       - Format: {format}
       - Container ID: {container_id or 'detect from page'}
       - Container JSON: {json_path or 'none'}
       - Target URL: {url or 'ask user'}
       - Focus area: {focus or 'complete analysis'}
       - Files to analyze: {file_list}")
```

### The GTM Specialist Will

1. **Establish Baseline Performance**:
   - Navigate to target URL via Chrome DevTools MCP
   - Measure navigation timing, paint metrics, CWV
   - Capture GTM resource loading waterfall

2. **Analyze GTM Container**:
   - Evaluate container size and tag inventory
   - Parse container JSON if provided
   - Identify tag types, triggers, and variables

3. **Run 14 Issue Detection Checks**:
   - Synchronous script loading
   - Blocking tags (>50ms main thread)
   - Large payloads (>100KB)
   - Main thread blocking
   - Missing conditional firing
   - Trigger optimization
   - Duplicate tags
   - Orphaned tags
   - Expensive variables
   - Missing async attributes
   - Custom HTML best practices
   - Server-side candidates
   - Consent mode gaps
   - Tag firing order

4. **Map CWV Impact**:
   - Correlate tag execution with LCP delta
   - Measure INP impact from tag scripts
   - Check CLS impact from tag-injected elements

5. **Generate Actionable Report**:
   - Executive summary with key metrics
   - Tag inventory table with timing
   - Prioritized findings with GTM-specific fix steps
   - Network waterfall visualization
   - Implementation checklist

6. **Platform-specific analysis**:
   - **Drupal**: google_tag module config, template injection, hook implementations
   - **WordPress**: GTM4WP settings, header.php injection, WooCommerce integration

---

## Requirements

**Required**: Chrome DevTools MCP Server

This command requires an active Chrome DevTools MCP connection to perform live page profiling, tag execution measurement, and network waterfall capture.

**Setup:**
1. Install Chrome DevTools MCP server
2. Configure in Claude Code settings
3. Open Chrome browser with target page
4. Run the audit command

---

## Related Commands

- **[`/audit-perf`](audit-perf.md)** - General performance audit (Core Web Vitals, assets, queries)
- **[`/audit-live-site`](audit-live-site.md)** - Comprehensive live site audit (perf + a11y + security + quality)
- **[`/audit-security`](audit-security.md)** - Security audit (includes third-party script risks)

## Agent Used

**gtm-specialist** - GTM performance specialist with expertise in container optimization, tag execution profiling, trigger efficiency, and CWV impact mapping for Drupal and WordPress.

## What Makes This Different

**Before (manual GTM review):**
- Check GTM admin for tag count manually
- No execution timing data
- Miss blocking tags and consent gaps
- Generic "reduce tags" advice

**With gtm-specialist:**
- Automated container analysis with tag inventory
- Real execution timing per tag via Chrome DevTools
- 14-point issue detection with CWV impact mapping
- GTM-specific fix steps with exact navigation paths
- CMS-specific patterns (Drupal/WordPress)
- Prioritized remediation checklist

---

## Exporting to Project Management Tools

After audit completes, export findings as CSV:

```bash
/export-audit-csv [report-filename]
```

Generates Teamwork-compatible CSV for importing tasks into project management tools (also works with Jira, Monday, Linear).
