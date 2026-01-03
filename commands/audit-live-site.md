---
description: Comprehensive live site audit using live-audit specialist (orchestrator)
argument-hint: "[url]"
allowed-tools: Task
---

Spawn the **live-audit-specialist** agent using:

```
Task(cms-cultivator:live-audit-specialist:live-audit-specialist,
     prompt="Perform a comprehensive site audit by orchestrating performance-specialist, accessibility-specialist, security-specialist, and code-quality-specialist in parallel. Site URL: [use argument if provided]. Synthesize findings into unified report with health score, prioritized issues, and remediation roadmap.")
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
   - Technical audit report (for developers)
   - Executive summary (for stakeholders)
   - Prioritized action plan with timelines
   - Performance, accessibility, security, and quality scores

**This is a pure orchestrator** - It delegates all work to the 4 specialists and compiles their findings into a comprehensive assessment.

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
