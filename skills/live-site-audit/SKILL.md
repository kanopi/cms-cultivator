---
name: live-site-audit
description: Comprehensive live site audit orchestrating performance, accessibility, security, and code quality specialists in parallel. Invoke when user runs /audit-live-site, requests a comprehensive site health assessment, needs a full multi-dimensional audit, or wants a unified audit report with health score and remediation roadmap. Generates audit-live-site-YYYY-MM-DD-HHMM.md report file.
disable-model-invocation: true
---

# Live Site Audit

Comprehensive multi-dimensional site audit that orchestrates four specialist agents in parallel for performance, accessibility, security, and code quality analysis.

## Usage

- `/audit-live-site` — Full audit of local project
- `/audit-live-site https://example.com` — Audit a live site URL
- `/audit-live-site staging.example.com` — Audit staging environment

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() or browser tools are unavailable:

1. **Detect context** — Determine site URL (from argument or local project) and CMS (Drupal/WordPress)
2. **Run sequential analysis** — Perform all four audit dimensions directly using Read, Grep, Glob:
   - **Performance**: Database query patterns, caching strategy, asset markup, Core Web Vitals indicators
   - **Accessibility**: Semantic HTML, ARIA attributes, color values, keyboard patterns
   - **Security**: OWASP Top 10 code patterns, input validation, output encoding
   - **Code Quality**: Complexity, code smells, standards compliance, technical debt
3. **Synthesize findings** — Combine results into unified prioritized report
4. **Calculate health score** — Score each dimension (0–100) and compute overall health
5. **Save report** — Write to `audit-live-site-YYYY-MM-DD-HHMM.md` and present path

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() available:

**Spawn all 4 specialists in parallel** (single message with 4 Task calls):

```
Task(cms-cultivator:live-audit-specialist:live-audit-specialist,
     prompt="Perform comprehensive site audit by orchestrating 4 specialists in parallel.

Site context:
- Site URL: {url from argument or 'local development'}
- CMS: {Drupal/WordPress - detect from codebase if local}
- Environment: {production/staging/local}

CRITICAL: Spawn all 4 specialists IMMEDIATELY in a single message with 4 Task calls. Do NOT gather context yourself - it is provided above. Synthesize findings into unified report. Save to audit-live-site-YYYY-MM-DD-HHMM.md and suggest: 'Use the audit-export skill to export findings as CSV tasks.'")
```

The live-audit-specialist will:
1. **Spawn 4 specialists in parallel**:
   - **performance-specialist** — Core Web Vitals, asset optimization, caching
   - **accessibility-specialist** — WCAG 2.1 AA compliance, keyboard navigation, ARIA
   - **security-specialist** — OWASP vulnerabilities, authentication, CVE scanning
   - **code-quality-specialist** — Technical debt, coding standards, complexity

2. **Synthesize unified report** with:
   - Executive summary with overall health score
   - Critical issues across all dimensions
   - Cross-domain issue identification
   - Prioritized remediation roadmap (High → Medium → Low)
   - Estimated effort and business impact

3. **Generate deliverables**:
   - Audit report file (`audit-live-site-YYYY-MM-DD-HHMM.md`)
   - Technical audit report for developers
   - Executive summary for stakeholders
   - Performance, accessibility, security, and quality scores

## Report Format

```markdown
# Site Audit Report — [Site URL]
**Date**: [date]
**CMS**: [Drupal/WordPress]
**Overall Health Score**: [0-100]

## Executive Summary
- Performance: [score/100]
- Accessibility: [score/100]
- Security: [score/100]
- Code Quality: [score/100]

## Critical Issues (All Dimensions)
[Issues requiring immediate action]

## Prioritized Remediation Roadmap
### Phase 1: Critical (This Sprint)
### Phase 2: High Priority (This Quarter)
### Phase 3: Medium Priority (Next Quarter)
### Phase 4: Long-term Optimization
```

## Chrome DevTools Integration

When chrome-devtools MCP is available (Claude Code only), the audit can include:
- Real browser performance measurement (actual LCP, INP, CLS values)
- Live accessibility testing with axe-core
- Network request analysis
- Screenshots at multiple breakpoints

## After the Audit

Export findings to project management CSV:

Use the **audit-export** skill: provide the report file path to generate a Teamwork-compatible CSV with tasks organized by priority phase.

## Related Skills

- **accessibility-audit** — Focused WCAG 2.1 AA audit only
- **performance-audit** — Focused Core Web Vitals audit only
- **security-audit** — Focused OWASP vulnerability audit only
- **quality-audit** — Focused code quality audit only
- **audit-export** — Export findings to CSV
- **audit-report** — Generate client-facing executive summary
