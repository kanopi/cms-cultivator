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

When running in Claude Code with the Agent tool available:

**Step 1: Spawn all 4 specialists in parallel** — send a single message containing all 4 Agent calls:

```
Agent(subagent_type="cms-cultivator:performance-specialist:performance-specialist",
      prompt="Analyze performance for {URL}. Working directory: {cwd}.
      Check: Core Web Vitals, LCP/INP/CLS, render-blocking assets, image optimization,
      caching strategy, TTFB. Return structured findings with severity levels and
      specific file paths or URLs where issues are found.")

Agent(subagent_type="cms-cultivator:accessibility-specialist:accessibility-specialist",
      prompt="Audit WCAG 2.1 AA compliance for {URL}. Working directory: {cwd}.
      Check: semantic HTML, ARIA, keyboard navigation, color contrast (4.5:1), alt text,
      form labels, skip links, focus indicators, touch targets. Return structured findings
      with WCAG criterion references and severity levels.")

Agent(subagent_type="cms-cultivator:security-specialist:security-specialist",
      prompt="Scan for OWASP Top 10 vulnerabilities at {URL}. Working directory: {cwd}.
      Check: XSS, SQL injection, CSRF, auth issues, security headers, exposed endpoints,
      sensitive file exposure, dependency vulnerabilities. Return structured findings
      with severity levels and specific remediation steps.")

Agent(subagent_type="cms-cultivator:code-quality-specialist:code-quality-specialist",
      prompt="Analyze code quality in {cwd}.
      Check: PHPCS standards, cyclomatic complexity, design patterns, SOLID principles,
      technical debt, code smells, documentation coverage. Return structured findings
      with severity levels and file paths.")
```

**Step 2: Wait for all 4 specialists to return results.**

**Step 3: Synthesize directly** — do not spawn another agent. Using all four specialist outputs:

1. Calculate per-category health scores (0–100) and overall weighted score (Performance 25%, Accessibility 25%, Security 30%, Code Quality 20%)
2. Identify cross-domain issues (problems that appear in multiple specialist reports)
3. Deduplicate and categorize all issues: Critical → High → Medium → Low
4. Build a phased remediation roadmap
5. Write the report to `audit-live-site-YYYY-MM-DD-HHMM.md` in the working directory
6. Present the executive summary, health score, and file path to the user
7. Suggest: "Use the audit-export skill to export findings as CSV tasks."

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
