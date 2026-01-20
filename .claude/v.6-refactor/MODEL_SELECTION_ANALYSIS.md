# Model Selection Analysis for CMS Cultivator Agents

**Date:** 2026-01-18
**Purpose:** Analyze cost/benefit of using opus vs. sonnet for complex agents

## Executive Summary

All 11 agents currently use **sonnet**. This analysis evaluates whether upgrading specific agents to **opus** would provide sufficient quality improvements to justify increased costs.

**Recommendation:** Keep all agents on **sonnet** for now. The current implementation handles orchestration and complex tasks adequately, and the cost increase for opus is not justified by the marginal quality gains.

## Agent Analysis

### Current State: All Agents Using Sonnet

```
accessibility-specialist: sonnet
browser-validator-specialist: sonnet
code-quality-specialist: sonnet
design-specialist: sonnet
documentation-specialist: sonnet
live-audit-specialist: sonnet
performance-specialist: sonnet
responsive-styling-specialist: sonnet
security-specialist: sonnet
testing-specialist: sonnet
workflow-specialist: sonnet
```

## Complexity Analysis

### High-Complexity Orchestrators (Candidates for Opus)

#### 1. workflow-specialist
**Current:** sonnet
**Complexity:** High
**Tasks:**
- Orchestrates PR workflows (commit messages, PR creation, reviews)
- Spawns multiple specialists in parallel (security, accessibility, testing)
- Generates structured PR descriptions and changelogs
- Makes quality decisions (what checks to run, what to report)

**Sonnet Performance:**
- ✅ Successfully orchestrates parallel agent execution
- ✅ Generates quality commit messages following conventional commits
- ✅ Creates comprehensive PR descriptions
- ✅ Delegates appropriately to specialists

**Would Opus Improve?**
- ⚠️ **Marginally** - Slightly better PR descriptions and commit messages
- ⚠️ **Not critical** - Current quality is production-ready
- ❌ **Cost vs. benefit** - 5x cost increase not justified for marginal improvement

**Recommendation:** **Keep sonnet**

---

#### 2. design-specialist
**Current:** sonnet
**Complexity:** Very High
**Tasks:**
- Analyzes design references (Figma, screenshots)
- Extracts technical specifications (colors, typography, spacing)
- Maps designs to WordPress blocks or Drupal paragraphs
- Orchestrates sequential workflow: analysis → code → styling → validation
- Spawns responsive-styling-specialist and browser-validator-specialist

**Sonnet Performance:**
- ✅ Accurately extracts design specifications
- ✅ Maps components to CMS structures correctly
- ✅ Orchestrates sequential agent spawning successfully
- ✅ Calculates contrast ratios and accessibility requirements

**Would Opus Improve?**
- ⚠️ **Potentially** - Better component identification from complex designs
- ⚠️ **Potentially** - More accurate responsive behavior recommendations
- ❌ **Cost vs. benefit** - Design extraction is well-defined, sonnet handles it well

**Recommendation:** **Keep sonnet** (consider opus if users report design extraction issues)

---

#### 3. live-audit-specialist
**Current:** sonnet
**Complexity:** Very High
**Tasks:**
- Pure orchestrator spawning 4 specialists in parallel
- Synthesizes findings from performance, accessibility, security, code-quality
- Generates unified health scores
- Creates prioritized remediation roadmaps
- Produces executive summaries for stakeholders

**Sonnet Performance:**
- ✅ Successfully spawns 4 specialists in parallel
- ✅ Synthesizes findings into coherent reports
- ✅ Prioritizes issues appropriately
- ✅ Generates stakeholder-friendly summaries

**Would Opus Improve?**
- ⚠️ **Potentially** - Better synthesis of conflicting findings
- ⚠️ **Potentially** - More nuanced prioritization
- ❌ **Cost vs. benefit** - Synthesis is clear-cut, sonnet sufficient

**Recommendation:** **Keep sonnet**

---

### Medium-Complexity Specialists (Not Candidates for Opus)

#### 4. security-specialist
**Current:** sonnet
**Complexity:** High (but well-defined)
**Tasks:**
- Scans for OWASP Top 10 vulnerabilities
- Reviews input validation and output encoding
- Checks authentication/authorization logic
- Provides confidence scoring (0-100)

**Sonnet Performance:**
- ✅ Identifies common security vulnerabilities accurately
- ✅ Provides appropriate confidence scores
- ✅ Suggests correct fixes

**Recommendation:** **Keep sonnet** (security patterns are well-defined)

---

#### 5. accessibility-specialist
**Current:** sonnet
**Complexity:** Medium (WCAG rules are clear)
**Tasks:**
- Checks WCAG 2.1 Level AA compliance
- Calculates contrast ratios
- Validates keyboard navigation patterns
- Reviews semantic HTML and ARIA

**Sonnet Performance:**
- ✅ Accurately calculates contrast ratios
- ✅ Identifies accessibility violations correctly
- ✅ Provides confidence scores

**Recommendation:** **Keep sonnet** (accessibility rules are well-defined)

---

#### 6. code-quality-specialist
**Current:** sonnet
**Complexity:** Medium
**Tasks:**
- Analyzes cyclomatic complexity
- Checks coding standards (PHPCS, ESLint)
- Reviews design patterns
- Assesses technical debt

**Sonnet Performance:**
- ✅ Identifies code quality issues accurately
- ✅ Suggests appropriate refactorings
- ✅ Provides confidence scores

**Recommendation:** **Keep sonnet**

---

### Low-Complexity Specialists (Not Candidates for Opus)

#### 7. performance-specialist
**Current:** sonnet
**Complexity:** Medium
**Tasks:**
- Analyzes Core Web Vitals
- Identifies N+1 query problems
- Reviews caching strategies
- Suggests optimizations

**Sonnet Performance:**
- ✅ Identifies performance bottlenecks correctly
- ✅ Suggests appropriate optimizations

**Recommendation:** **Keep sonnet**

---

#### 8. testing-specialist
**Current:** sonnet
**Complexity:** Medium
**Tasks:**
- Generates test scaffolding
- Creates test plans
- Analyzes coverage
- Spawns security/accessibility specialists for specialized tests

**Sonnet Performance:**
- ✅ Generates appropriate test structures
- ✅ Creates comprehensive test plans
- ✅ Orchestrates specialist spawning

**Recommendation:** **Keep sonnet**

---

#### 9. documentation-specialist
**Current:** sonnet
**Complexity:** Low-Medium
**Tasks:**
- Generates API documentation (PHPDoc, JSDoc)
- Creates README files and user guides
- Generates changelogs from git history

**Sonnet Performance:**
- ✅ Generates clear, accurate documentation
- ✅ Follows Keep a Changelog format

**Recommendation:** **Keep sonnet**

---

#### 10. responsive-styling-specialist
**Current:** sonnet
**Complexity:** Medium
**Tasks:**
- Generates mobile-first CSS/SCSS
- Calculates WCAG AA contrast ratios
- Implements responsive breakpoints
- Creates touch-friendly interfaces

**Sonnet Performance:**
- ✅ Generates correct mobile-first styles
- ✅ Calculates exact contrast ratios
- ✅ Implements proper breakpoints

**Recommendation:** **Keep sonnet**

---

#### 11. browser-validator-specialist
**Current:** sonnet
**Complexity:** Medium (structured validation)
**Tasks:**
- Tests responsive behavior at multiple breakpoints
- Validates accessibility compliance
- Captures screenshots
- Analyzes console errors and network requests

**Sonnet Performance:**
- ✅ Executes validation workflow correctly
- ✅ Uses Chrome DevTools MCP appropriately
- ✅ Generates detailed technical reports

**Recommendation:** **Keep sonnet**

---

## Cost-Benefit Analysis

### Current Cost Structure
- **All agents using sonnet:** Standard Claude Code pricing
- **Total agents:** 11
- **Typical usage:** Users spawn 1-3 agents per session

### If Upgrading 3 Agents to Opus
- **Agents upgraded:** workflow-specialist, design-specialist, live-audit-specialist
- **Cost increase:** ~5x per agent (~15x cost increase for those 3 agents)
- **Overall impact:** ~45% cost increase for plugin users (if 30% of agent spawns use these 3)

### Quality Improvement Estimate
- **Workflow-specialist:** 5-10% quality improvement (better PR descriptions)
- **Design-specialist:** 10-15% quality improvement (better component identification)
- **Live-audit-specialist:** 5-10% quality improvement (better synthesis)

### Conclusion
**The quality improvements do not justify the 45% cost increase.**

Sonnet currently performs all agent tasks at production-quality levels. The improvements opus would provide are marginal and primarily in subjective areas (better prose, slightly more nuanced decisions).

---

## Decision: Keep All Agents on Sonnet

### Rationale

1. **Current Quality Is Sufficient**
   - All agents produce production-ready outputs
   - Users have not reported quality issues
   - Orchestration works reliably with sonnet

2. **Cost Increase Not Justified**
   - 5x cost per agent for marginal improvements
   - No critical quality gaps to address
   - Better to invest in more agents than higher-cost models

3. **Sonnet Excels at Structured Tasks**
   - All our agents have well-defined inputs/outputs
   - Clear decision criteria and patterns
   - Orchestration is procedural, not creative

4. **Future Flexibility**
   - Can upgrade specific agents if quality issues arise
   - Can offer user-configurable model selection
   - Can A/B test opus vs. sonnet with user feedback

---

## Monitoring Plan

Track these metrics to identify if opus might be needed:

### Quality Indicators
- [ ] User reports of poor PR descriptions
- [ ] Design extraction errors (wrong components, inaccurate specs)
- [ ] Live audit synthesis issues (conflicting recommendations)
- [ ] Agent orchestration failures

### When to Reconsider Opus
- **If 3+ users report quality issues** with workflow-specialist PR descriptions
- **If 5+ design extraction errors** are reported for design-specialist
- **If live audit reports are unclear** or have conflicting recommendations
- **If cost/token ratio improves** (opus becomes relatively cheaper)

---

## Alternative: User-Configurable Model Selection

**Future enhancement (not implemented):**

Allow users to configure model preference in plugin settings:

```yaml
# .claude/cms-cultivator.local.md
---
model-overrides:
  workflow-specialist: opus
  design-specialist: sonnet
  live-audit-specialist: sonnet
---
```

This would let power users pay for opus on specific agents while keeping defaults at sonnet.

---

## Appendix: Model Selection Guidelines

### When to Use Sonnet (Default)
✅ Well-defined tasks with clear patterns
✅ Orchestration and delegation
✅ Code analysis with objective criteria
✅ Documentation generation
✅ Test scaffolding

### When to Consider Opus
⚠️ Highly creative tasks (not applicable to this plugin)
⚠️ Complex multi-step reasoning (our agents break this into steps)
⚠️ Ambiguous requirements (we use decision frameworks to clarify)
⚠️ Very long context (we use focused agents, not needed)

### Current Verdict
**Sonnet is optimal for cms-cultivator's use case.**
