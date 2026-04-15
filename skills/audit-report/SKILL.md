---
name: audit-report
description: Generate client-facing executive summaries from existing audit report files. Transforms technical CMS Cultivator audit findings into non-technical stakeholder reports. Invoke when user asks to "generate a client report from this audit", "create an executive summary", "make a non-technical version of this audit", or "summarize audit findings for stakeholders". Requires an existing audit report file as input.
---

# Audit Report

Generate client-facing executive summaries from CMS Cultivator audit report files, transforming technical findings into accessible stakeholder communication.

## Usage

- "Generate a client report from audit-live-site-2026-04-15-1430.md"
- "Create an executive summary from the security audit"
- "Make a non-technical report for the client from this accessibility audit"
- "Summarize the audit findings for stakeholders"

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

This skill runs fully in Tier 1 using only file operations:

1. **Identify audit file** — Accept filename from user's request or context
2. **Read audit report** — Use Read to load the markdown file
3. **Extract key metrics**:
   - Overall health score or compliance status
   - Issue counts by severity (Critical/High/Medium/Low)
   - Top 3-5 most impactful findings
   - Estimated remediation effort totals
4. **Transform technical language** — Convert developer terminology to business language:
   - "SQL injection vulnerability" → "Security gap that could allow unauthorized data access"
   - "WCAG 2.1 AA non-compliance" → "Accessibility barriers that may prevent users with disabilities from using the site"
   - "N+1 query pattern" → "Performance inefficiency causing slow page loads"
   - "Cyclomatic complexity" → "Code that is difficult to maintain and may contain hidden bugs"
5. **Structure executive summary** with sections tailored for stakeholders
6. **Save report** — Write to `[original-name]-client-report.md`

### Tier 2 — Claude Code Enhanced

Same as Tier 1. This skill does not require additional Claude Code tools — it runs identically in both tiers.

## Executive Summary Format

```markdown
# Site Health Report — [Site Name]
**Report Date**: [date]
**Prepared for**: [Client Name]
**Prepared by**: [Team/Agency Name]

## Overview

[2-3 sentences summarizing overall site health in plain language]

**Overall Health Score**: [score]/100

## Key Findings

### What's Working Well ✅
- [Positive finding 1]
- [Positive finding 2]

### Areas Requiring Attention

#### Urgent (Address Within 1 Week) 🔴
[Plain language description of critical issues and their business impact]

**Business Impact**: [Legal risk, lost revenue, user experience impact]
**Estimated Effort**: [X hours/days]

#### High Priority (Address This Month) 🟡
[Plain language description of high-priority issues]

**Business Impact**: [Impact description]
**Estimated Effort**: [X hours/days]

#### Planned Improvements (Next Quarter) 🟢
[Lower priority improvements]

## Recommended Actions

### Immediate (This Sprint)
1. [Action item with business justification]
2. [Action item]

### Short-Term (This Quarter)
1. [Action item]

### Long-Term (Roadmap)
1. [Action item]

## Investment Summary

| Priority | Issues | Est. Effort | Est. Cost* |
|----------|--------|-------------|------------|
| Urgent | [n] | [X hrs] | $ |
| High | [n] | [X hrs] | $ |
| Planned | [n] | [X hrs] | $ |

*Estimated at [agency rate]/hour. Actual costs will be confirmed in proposal.

## Next Steps

1. Review this report with your team
2. Prioritize issues based on business impact and budget
3. Schedule a follow-up meeting to discuss implementation roadmap
4. [Agency/team] will provide detailed proposals for approved work

---
*Technical details available in the accompanying developer audit report.*
```

## Language Translation Guide

| Technical Term | Client-Friendly Language |
|----------------|--------------------------|
| SQL injection | Security vulnerability allowing unauthorized data access |
| XSS vulnerability | Security gap that could allow malicious code injection |
| WCAG 2.1 AA | Accessibility standards ensuring site works for users with disabilities |
| Core Web Vitals | Google's page speed standards affecting search rankings |
| N+1 query | Database inefficiency causing slow page loads |
| Cache miss | Server inefficiency increasing page load times |
| Cyclomatic complexity | Code complexity increasing maintenance risk |
| Technical debt | Accumulated shortcuts requiring future cleanup |
| CVE | Known security vulnerability in a software component |

## Business Impact Framing

- **Legal risk**: WCAG non-compliance, GDPR issues, security vulnerabilities
- **Revenue impact**: Performance → conversion rates (100ms = +1% conversions)
- **SEO impact**: Core Web Vitals affect Google search rankings
- **Reputation risk**: Security breaches, data exposure
- **Maintenance cost**: Technical debt and complex code increase future costs

## Related Skills

- **live-site-audit** — Generates comprehensive source audit reports
- **accessibility-audit**, **performance-audit**, **security-audit**, **quality-audit** — Focused source audits
- **audit-export** — Export findings as project management tasks (CSV)
