# Audit Export & Reporting

After running an audit, you have two cross-cutting skills for turning the findings into something you can hand to a project manager or a client.

These skills are platform-neutral — they accept the Markdown report from any audit (accessibility, security, performance, code quality, live-site, GTM, structured data) and produce a different output shape.

---

## Available Skills

### audit-export

**Purpose:** Convert audit findings from a Markdown report file into a Teamwork-compatible CSV ready for import. Also produces formats compatible with Jira, Monday, and Linear.

**Auto-invoked triggers:** "export this audit to CSV", "create Teamwork tasks from this audit", "make tickets from these findings", providing an audit report filename with an export request.

**Inputs:** A Markdown audit report (typically produced by `accessibility-audit`, `security-audit`, `performance-audit`, `quality-audit`, `live-site-audit`, `gtm-performance-audit`, or `structured-data-analyzer`).

**Outputs:** A CSV file with one row per finding, columns mapping to Teamwork task fields:

- Tasklist (audit category)
- Task name (finding title)
- Description (full finding context, reproduction steps, fix suggestions)
- Priority (mapped from severity: Critical→P0, High→P1, Medium→P2, Low→P3)
- Estimated time (rough from severity + complexity)
- Tags (severity, category, source-skill)
- Status (always `Active` for new tasks)

**What it doesn't do:** It does not call the Teamwork MCP and create the tasks. The CSV is for import via the Teamwork UI (Project → Settings → Import/Export). For direct task creation from audits, use `teamwork-exporter` instead.

**Example:**

```
"Export ./audit-reports/security-audit-2026-05-14.md to CSV"
```

---

### audit-report

**Purpose:** Generate a client-facing executive summary from an existing audit report. The detailed Markdown audit is great for developers; the report version is what you share with stakeholders.

**Auto-invoked triggers:** "generate a client report from this audit", "create an executive summary", "make a non-technical version of this audit", "summarize this audit for stakeholders".

**Inputs:** A Markdown audit report.

**Outputs:** A polished client-facing summary with:

- High-level findings stated in business terms (impact, not technical detail)
- Top 3–5 recommended priorities for next sprint
- Trend context if a previous audit exists ("issues down 30% since last review")
- Visual-friendly structure (sections, callouts, scannable bullets)
- Glossary for unavoidable technical terms

**Tone:** confident, opportunity-framed, jargon-light. Designed to be readable by a non-technical stakeholder in under 5 minutes.

---

## How These Fit Together

| Goal | Use |
|------|-----|
| "Get me a backlog I can import into Teamwork" | `audit-export` |
| "Give me a summary I can send to the client" | `audit-report` |
| "Just create the Teamwork tasks directly" | `teamwork-exporter` |
| "Convert FRD requirements (not audit findings) into a CSV backlog" | `csv-exporter` |

`audit-export` and `audit-report` operate on **audit reports** as input. `teamwork-exporter` is the live-call equivalent that creates tasks via the Teamwork MCP. `csv-exporter` operates on **FRDs**, not audits.

---

## Workflow

A typical engagement uses these skills sequentially:

```
1. Run a comprehensive audit
   → /accessibility-audit, /security-audit, /performance-audit, /live-site-audit
   → Markdown report saved locally

2. Generate a client-facing summary
   → /audit-report ./audit-report.md
   → Polished executive summary

3. Generate a backlog for the team
   → /audit-export ./audit-report.md
   → Teamwork-importable CSV

4. (Optional) Import the CSV into Teamwork
   → Project → Settings → Import/Export → Import Tasks from CSV
```

If you'd rather skip the CSV step and have Claude create tasks directly via the Teamwork MCP, use `teamwork-exporter` instead of `audit-export`.

---

## Related Skills

- **[accessibility-audit](accessibility.md)**, **[security-audit](security.md)**, **[performance-audit](performance.md)**, **[quality-audit](code-quality.md)**, **[live-site-audit](live-site-auditing.md)** — produce the reports these skills consume
- **[teamwork-exporter](project-management.md)** — direct task creation via the Teamwork MCP (no CSV)
- **[csv-exporter](planning.md)** — converts FRD requirements (not audits) into CSV backlogs

---

## See Also

- **[Skills Overview](overview.md)**
- **[Live Site Auditing](live-site-auditing.md)** — the most common source for audit-export and audit-report input
