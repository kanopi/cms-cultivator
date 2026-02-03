---
description: Comprehensive live site audit using live-audit specialist (orchestrator)
argument-hint: "[url]"
allowed-tools: Task
---

Spawn the **live-audit-specialist** agent using:

```
Task(cms-cultivator:live-audit-specialist:live-audit-specialist,
     prompt="Perform comprehensive site audit by orchestrating 4 specialists in parallel.

Site context:
- Site URL: [use argument if provided, or 'local development']
- CMS: [Drupal/WordPress - detect from codebase if local]
- Environment: [production/staging/local]

CRITICAL: Spawn all 4 specialists IMMEDIATELY in a single message with 4 Task calls. Do NOT gather context yourself - it is provided above. Synthesize findings into unified report. Save to audit-live-site-YYYY-MM-DD-HHMM.md and suggest: '/export-audit-csv [report-file]'")
```

The live-audit specialist will:
1. **Spawn 4 specialists in parallel**:
   - **performance-specialist** - Core Web Vitals, asset optimization, caching
   - **accessibility-specialist** - WCAG 2.1 AA compliance, keyboard navigation, ARIA
   - **security-specialist** - OWASP vulnerabilities, authentication, CVE scanning
   - **code-quality-specialist** - Technical debt, coding standards, complexity

2. **Synthesize unified report**:
   - Executive summary with overall health score
   - Critical issues across all dimensions
   - Prioritized remediation roadmap (High → Medium → Low)
   - Estimated effort and business impact

3. **Generate deliverables**:
   - **Audit report file** (audit-live-site-YYYY-MM-DD-HHMM.md)
   - Technical audit report (for developers)
   - Executive summary (for stakeholders)
   - Prioritized action plan with timelines
   - Performance, accessibility, security, and quality scores

**This is a pure orchestrator** - It delegates all work to the 4 specialists and compiles their findings into a comprehensive assessment.

---

## Tool Usage

**Allowed operations:**
- ✅ Spawn live-audit-specialist orchestrator agent
- ✅ The orchestrator spawns 4 specialists in parallel (performance, accessibility, security, code-quality)
- ✅ Synthesize findings from all specialists into unified report
- ✅ Generate health scores and prioritized remediation roadmaps
- ✅ Create executive summaries for stakeholders

**Not allowed:**
- ❌ Do not modify code directly (provide recommendations in report)
- ❌ Do not run destructive tests
- ❌ Do not commit changes or create PRs

The live-audit-specialist coordinates all operations by orchestrating the 4 specialist agents.

---

## Agent Used

**live-audit-specialist** - Pure orchestrator agent that coordinates parallel audits from performance, accessibility, security, and code-quality specialists.

## What Makes This Different

**Before (manual audits):**
- Run tools separately
- Manually compile findings
- Miss cross-domain issues
- No unified prioritization

**With live-audit-specialist:**
- ✅ Parallel execution (4 specialists at once)
- ✅ Unified, prioritized findings
- ✅ Cross-domain issue identification
- ✅ Comprehensive health score
- ✅ Actionable remediation roadmap
- ✅ Executive + technical reports
- ✅ **Audit report saved to file** for reference and stakeholder sharing

---

## Exporting to Project Management Tools

After audit completes, export findings as CSV:

```bash
/export-audit-csv [report-filename]
```

Generates Teamwork-compatible CSV for importing tasks into project management tools (also works with Jira, Monday, Linear).
