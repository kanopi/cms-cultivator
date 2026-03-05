---
description: Comprehensive Google Tag Manager performance audit analyzing container size, tag execution, trigger efficiency, and Core Web Vitals impact
argument-hint: "[options]"
allowed-tools: Task, Bash(git:*), Read, mcp__chrome-devtools__*
---

## How This Command Works

This command collects live page data via Chrome DevTools MCP, then passes the data to the gtm-specialist agent for analysis and report generation.

**IMPORTANT**: MCP tools are only available in the main conversation context, NOT inside Task subagents. That's why data collection happens HERE, not inside the agent.

### Phase 1: Data Collection (you do this — 3 tool calls total)

**Step 1: Get the target URL**

Parse arguments for `--url=<value>`. If no URL provided, ask the user for one before continuing. Do not proceed without a URL.

**Step 2: Navigate to the target URL**

```
mcp__chrome-devtools__navigate_page(url="<target-url>")
```

If this call fails (tool not found, MCP not connected), skip to "If Chrome DevTools MCP is NOT available" below. If it succeeds, continue.

**Step 3: Run collector + get supplemental data (all in ONE message)**

Make these 3 tool calls in a SINGLE message so the user only sees one approval prompt:

```
mcp__chrome-devtools__evaluate_script(function="<compact inline collector — see below>")
mcp__chrome-devtools__list_network_requests()
mcp__chrome-devtools__list_console_messages()
```

**IMPORTANT**: Do NOT read the full collector script from `agents/gtm-specialist/scripts/gtm-audit-collector.js` — it is 50KB and too large to pass as a parameter. Instead, write a compact inline collector function directly in the evaluate_script call. The compact collector must collect: GTM container IDs, performance timing (TTFB/FCP/DCL/load), CWV (LCP/CLS), long tasks/TBT, head/body scripts with blocking status and vendor identification, resource timing for tracking domains, DataLayer contents, consent platform detection, vendor globals, GA4/Ads/UA IDs from page scripts, cookies, CMS/WordPress detection, and async GTM container source fetch with tag type parsing. Wrap each section in try/catch so one failure doesn't break the whole collection.

### Phase 2: Analysis (agent does this)

Pass ALL collected data to the gtm-specialist agent:

```
Task(cms-cultivator:gtm-specialist:gtm-specialist,
     prompt="Analyze this GTM audit data and generate a comprehensive report.

TARGET URL: <url>
DEPTH MODE: <quick/standard/comprehensive>
FORMAT: <report/json/summary>

## Collector Script Results (from Chrome DevTools MCP evaluate_script)

<paste the full JSON result from Step 5>

## Network Requests (from Chrome DevTools MCP list_network_requests)

<paste network request results from Step 6>

## Console Messages (from Chrome DevTools MCP list_console_messages)

<paste console message results from Step 6>

## Instructions

1. Parse the collector data above — do NOT run any mcp__chrome-devtools__ tools (they are not available to you)
2. Do NOT use Bash curl to re-fetch the page or container — all data is provided above
3. Run all 14 issue detection checks against the provided data
4. Generate the audit report and save to audit-gtm-DOMAIN-YYYY-MM-DD-HHMM.md (domain from URL, strip www., dots to hyphens)
5. Present the executive summary and file path")
```

### If Chrome DevTools MCP is NOT available

Collect data yourself using Bash curl at the command level, then pass it to the agent:

```
# Fetch page HTML
Bash(curl -sL "<url>") → save output as PAGE_HTML

# Extract GTM container ID from HTML, then fetch container
Bash(curl -s "https://www.googletagmanager.com/gtm.js?id=<GTM-ID>") → save output as CONTAINER_JS

# Pass to agent
Task(cms-cultivator:gtm-specialist:gtm-specialist,
     prompt="Chrome DevTools MCP was not available. Analyze this data collected via HTTP fallback.
       - Target URL: <url>
       - Depth mode: <mode>
       - Format: <format>
       Note in the report that CWV metrics are not available (HTTP-only collection).

       ## Page HTML
       <PAGE_HTML>

       ## GTM Container Source
       <CONTAINER_JS>")
```

---

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

---

## Tool Usage

**Allowed operations:**
- Collect page data via Chrome DevTools MCP (navigate, evaluate_script, network, console)
- Spawn gtm-specialist agent with collected data
- Analyze GTM integration code in codebase
- Generate performance reports with remediation plans

**Not allowed:**
- Do not modify GTM containers, tags, triggers, or variables
- Do not enter GTM admin credentials
- Do not modify tracking code without explicit approval

---

## Requirements

**Required**: Chrome DevTools MCP Server (for best results)

This command uses Chrome DevTools MCP for live page profiling. Without it, the audit falls back to HTTP-based analysis with reduced accuracy.

**Setup:**
1. Install Chrome DevTools MCP server
2. Configure in Claude Code settings
3. Open Chrome browser
4. Run the audit command

---

## Related Commands

- **[`/audit-perf`](audit-perf.md)** - General performance audit (Core Web Vitals, assets, queries)
- **[`/audit-live-site`](audit-live-site.md)** - Comprehensive live site audit (perf + a11y + security + quality)
- **[`/audit-security`](audit-security.md)** - Security audit (includes third-party script risks)

## Agent Used

**gtm-specialist** - GTM performance specialist with expertise in container optimization, tag execution profiling, trigger efficiency, and CWV impact mapping for Drupal and WordPress.

---

## Exporting to Project Management Tools

After audit completes, export findings as CSV:

```bash
/export-audit-csv [report-filename]
```

Generates Teamwork-compatible CSV for importing tasks into project management tools (also works with Jira, Monday, Linear).
