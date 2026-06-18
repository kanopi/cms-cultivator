---
name: audit-export
description: Export audit findings from markdown report files to Teamwork-compatible CSV format for project management tools (Jira, Monday, Linear also supported). Auto-activates when user asks to "export audit to CSV", "create tasks from audit", or provides an audit report file and asks to export it. Invoke when user provides audit report filename and wants CSV output for project management import.
---

# Audit Export

Export audit findings from CMS Cultivator markdown reports to CSV format for project management tools.

## Usage

- "Export this audit to CSV" (with audit report in context)
- "Create tasks from the security audit file: audit-security-2026-04-15.md"
- "Export audit-live-site-2026-04-15-1430.md to Teamwork CSV"

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

This skill runs fully in Tier 1 using only file operations:

1. **Identify report file** — From user's request (accept filename as argument or path)
2. **Read audit report** — Parse markdown file for findings using Read tool
3. **Parse severity levels** — Map section headings to priority phases:
   - `## Critical Issues` or `### CRITICAL` → Phase 1: Critical Issues (DUE DATE = today + 3 days)
   - `## High Priority` or `### HIGH` → Phase 2: High Priority (DUE DATE = today + 10 days)
   - `## Medium Priority` or `### MEDIUM` → Phase 3: Medium Priority (DUE DATE = today + 20 days)
   - `## Low Priority` or `### LOW` → Phase 4: Long-term Optimization (no due date)
4. **Extract tasks** — Each H3 heading within a priority section becomes a task
5. **Generate CSV** — Write Teamwork-compatible format
6. **Save file** — Output to `[original-name]-tasks.csv`

### Tier 2 — Claude Code Enhanced

Same as Tier 1. This skill does not require additional Claude Code tools — it runs identically in both tiers.

## CSV Format Requirements

**Columns**: TASKLIST, TASK, DESCRIPTION, ASSIGN TO, START DATE, DUE DATE, PRIORITY, ESTIMATED TIME, TAGS, STATUS

**Critical rules**:
1. **Every row must have a TASK value** — never create tasklist-only rows
2. **Repeat TASKLIST on every task row** — do not leave blank after first task
3. **Quote all DESCRIPTION values** — wrap entire description in double quotes
4. **Markdown in DESCRIPTION is allowed** — lists, headings, code blocks are preserved

## Task Description Template

Each extracted task uses this template in the DESCRIPTION column:

```
## Description
Teamwork Ticket(s): [To be assigned]
- [ ] Was AI used in this pull request?

> As a developer, I need to {goal}

{summary from audit}

## Acceptance Criteria
* {extracted from audit}

## Assumptions
* {known limitations}

## Steps to Validate
1. {testing instructions}

## Affected URL
{link if available}

## Deploy Notes
{file paths, cache clearing, config imports}
```

## Phase Organization

- **Phase 1: Critical Issues** — DUE DATE = today + 3 days, PRIORITY = Critical
- **Phase 2: High Priority** — DUE DATE = today + 10 days, PRIORITY = High
- **Phase 3: Medium Priority** — DUE DATE = today + 20 days, PRIORITY = Medium
- **Phase 4: Long-term Optimization** — No due date, PRIORITY = Low

## Tag Assignment

- Security-related keywords → `Security`
- Performance/optimization → `Performance`
- Accessibility/WCAG → `Accessibility`
- Code quality/standards → `Code Quality`

## Effort Estimation

- Pattern: "Estimated Effort: 2 hours" → `2h`
- Pattern: "15 minutes" → `15m`
- Default if not found: (blank)

## File Naming

- Input: `audit-live-site-2026-04-15-1430.md`
- Output: `audit-live-site-2026-04-15-1430-tasks.csv`

## Compatible Tools

Primary: **Teamwork** (full template format)
Also works with: Jira, Monday.com, Linear, Asana (CSV import with column mapping)

## Related Skills

- **accessibility-audit**, **performance-audit**, **security-audit**, **quality-audit** — Generate source audit reports
- **live-site-audit** — Generates comprehensive report covering all four dimensions
- **audit-report** — Generate client-facing executive summary before exporting tasks
