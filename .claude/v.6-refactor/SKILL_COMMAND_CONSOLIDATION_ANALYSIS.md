# Skill-Command Consolidation Analysis

**Date:** 2026-01-18
**Purpose:** Identify redundancies between skills and commands, evaluate consolidation opportunities

## Executive Summary

CMS Cultivator has **17 commands** and **12 skills**. Analysis shows a **hybrid architecture with clear purpose separation**:
- **Commands:** Explicit, comprehensive workflows with side effects
- **Skills:** Conversational, focused assistance activated by user questions

**Recommendation:** **Keep the hybrid architecture.** Skills and commands serve different use cases and consolidation would reduce usability. The current separation is optimal.

---

## Current Architecture

### Commands (17)
User-invoked via `/command` syntax. Comprehensive workflows.

### Skills (12)
Model-invoked based on user questions. Quick, focused assistance.

---

## Mapping: Skills to Commands

### 1. accessibility-checker (skill) ↔ audit-a11y (command)

**Skill:** Quick accessibility check on specific elements
- Trigger: User asks "is this accessible?"
- Scope: Single element or component
- Output: Quick feedback with fixes

**Command:** Comprehensive accessibility audit
- Trigger: User runs `/audit-a11y`
- Scope: Entire project or large codebase section
- Output: Formal audit report with WCAG compliance

**Overlap:** Minimal - Different scopes and use cases
**Decision:** ✅ **Keep both**
- Skill for quick checks during development
- Command for formal audits before release

---

### 2. commit-message-generator (skill) ↔ pr-commit-msg (command)

**Skill:** Generate commit message when user mentions "commit"
- Trigger: Conversational ("I should commit this")
- Scope: Current staged changes
- Output: Single commit message

**Command:** Generate commit message explicitly
- Trigger: User runs `/pr-commit-msg`
- Scope: Current staged changes
- Output: Single commit message + creates commit

**Overlap:** High - Nearly identical functionality
**Decision:** ⚠️ **Consider consolidation** BUT...
- Skill allows conversational flow
- Command provides explicit invocation
- Both are useful in different contexts
- **Verdict:** ✅ **Keep both** (user preference matters)

---

### 3. code-standards-checker (skill) ↔ quality-standards (command)

**Skill:** Quick standards check on specific code
- Trigger: User asks "does this follow standards?"
- Scope: Specific files or recent changes
- Output: Quick violations list

**Command:** Comprehensive standards analysis
- Trigger: User runs `/quality-standards`
- Scope: Entire project
- Output: Full PHPCS/ESLint report with auto-fix suggestions

**Overlap:** Moderate - Different scopes
**Decision:** ✅ **Keep both**
- Skill for quick checks
- Command for project-wide enforcement

---

### 4. coverage-analyzer (skill) ↔ test-coverage (command)

**Skill:** Check if specific code is tested
- Trigger: User asks "is this tested?"
- Scope: Specific function or file
- Output: Quick coverage status

**Command:** Comprehensive coverage analysis
- Trigger: User runs `/test-coverage`
- Scope: Entire project
- Output: Full coverage report with gap recommendations

**Overlap:** Moderate - Different scopes
**Decision:** ✅ **Keep both**

---

### 5. documentation-generator (skill) ↔ docs-generate (command)

**Skill:** Generate docs for specific code
- Trigger: User asks "how do I document this?"
- Scope: Single function/class
- Output: PHPDoc/JSDoc for that code

**Command:** Comprehensive documentation generation
- Trigger: User runs `/docs-generate`
- Scope: Entire project (API docs, README, changelogs)
- Output: Full documentation suite

**Overlap:** Moderate - Different scopes
**Decision:** ✅ **Keep both**

---

### 6. performance-analyzer (skill) ↔ audit-perf (command)

**Skill:** Analyze specific performance issue
- Trigger: User says "this is slow"
- Scope: Specific code or query
- Output: Quick performance recommendations

**Command:** Comprehensive performance audit
- Trigger: User runs `/audit-perf`
- Scope: Entire project (Core Web Vitals, queries, assets)
- Output: Full performance report with optimizations

**Overlap:** Moderate - Different scopes
**Decision:** ✅ **Keep both**

---

### 7. security-scanner (skill) ↔ audit-security (command)

**Skill:** Check if specific code is secure
- Trigger: User asks "is this secure?"
- Scope: Specific code snippet
- Output: Quick security check with fixes

**Command:** Comprehensive security audit
- Trigger: User runs `/audit-security`
- Scope: Entire project (OWASP Top 10, CVE scanning)
- Output: Full security audit report

**Overlap:** Moderate - Different scopes
**Decision:** ✅ **Keep both**

---

### 8. test-plan-generator (skill) ↔ test-plan (command)

**Skill:** Generate test scenarios for specific feature
- Trigger: User asks "what should I test?"
- Scope: Specific feature or code changes
- Output: Quick test scenario list

**Command:** Comprehensive QA test plan
- Trigger: User runs `/test-plan`
- Scope: Entire feature or PR
- Output: Formal QA test plan with checklists

**Overlap:** High - Similar functionality
**Decision:** ✅ **Keep both**
- Skill for quick conversational planning
- Command for formal QA deliverables

---

### 9. test-scaffolding (skill) ↔ test-generate (command)

**Skill:** Generate tests for specific code
- Trigger: User says "I need tests for this"
- Scope: Specific function/class
- Output: Test scaffolding for that code

**Command:** Comprehensive test generation
- Trigger: User runs `/test-generate`
- Scope: Entire module or feature
- Output: Full test suite with security/accessibility tests

**Overlap:** Moderate - Different scopes
**Decision:** ✅ **Keep both**

---

## Skills WITHOUT Corresponding Commands

### 10. design-analyzer (skill)
- **Purpose:** Extract technical specs from design references
- **Trigger:** User uploads image or mentions Figma
- **Used by:** design-specialist agent
- **Status:** ✅ **Keep** (supports design-to-block, design-to-paragraph commands)

### 11. responsive-styling (skill)
- **Purpose:** Generate mobile-first CSS/SCSS
- **Trigger:** User asks to "make it responsive"
- **Used by:** responsive-styling-specialist agent
- **Status:** ✅ **Keep** (supports design workflows)

### 12. browser-validator (skill)
- **Purpose:** Validate implementations in real browsers
- **Trigger:** User says "test this" after implementation
- **Used by:** browser-validator-specialist agent
- **Corresponding command:** design-validate
- **Status:** ✅ **Keep** (skill allows conversational validation)

---

## Commands WITHOUT Corresponding Skills

### 13. pr-create
- **Purpose:** Orchestrate PR creation with quality checks
- **Why no skill:** Complex multi-phase workflow with side effects
- **Status:** ✅ **Keep as command only** (too complex for conversational activation)

### 14. pr-release
- **Purpose:** Generate changelog and deployment checklist for releases
- **Why no skill:** Formal release workflow with structured outputs
- **Status:** ✅ **Keep as command only**

### 15. pr-review
- **Purpose:** Orchestrate comprehensive PR review
- **Why no skill:** Requires PR number, spawns multiple specialists
- **Status:** ✅ **Keep as command only**

### 16. audit-live-site
- **Purpose:** Orchestrate 4 specialists in parallel for full site audit
- **Why no skill:** Complex orchestration, requires URL
- **Status:** ✅ **Keep as command only**

### 17. design-to-block
- **Purpose:** Create WordPress block pattern from design
- **Why no skill:** Multi-phase workflow (analysis → code → styling → validation)
- **Status:** ✅ **Keep as command only**

### 18. design-to-paragraph
- **Purpose:** Create Drupal paragraph type from design
- **Why no skill:** Multi-phase workflow (analysis → YAML → Twig → styling → validation)
- **Status:** ✅ **Keep as command only**

### 19. quality-analyze
- **Purpose:** Comprehensive code quality analysis and technical debt assessment
- **Why no skill:** Project-wide analysis, not conversational
- **Status:** ✅ **Keep as command only**

---

## Consolidation Analysis

### Pattern Recognition

#### ✅ **Good Separation:** Skill for Quick Checks + Command for Comprehensive Analysis

This pattern works well:
- **accessibility-checker** (skill) → Quick WCAG check on elements
- **audit-a11y** (command) → Full project accessibility audit

Users get:
- 💬 Conversational quick feedback during development
- 📋 Formal audit reports before release

**Keep this pattern for:**
- Accessibility (checker + audit-a11y)
- Security (scanner + audit-security)
- Performance (analyzer + audit-perf)
- Code standards (checker + quality-standards)
- Coverage (analyzer + test-coverage)
- Documentation (generator + docs-generate)

---

#### ⚠️ **High Overlap:** commit-message-generator (skill) + pr-commit-msg (command)

**Current state:**
- Both generate commit messages for staged changes
- Nearly identical functionality
- Main difference: Activation method (conversational vs. explicit)

**Options:**
1. **Consolidate to skill only** - Remove command, skill handles all commit message generation
2. **Consolidate to command only** - Remove skill, users explicitly run `/pr-commit-msg`
3. **Keep both** - Users choose their preferred method

**Recommendation:** ✅ **Keep both**

**Rationale:**
- Some users prefer conversational flow ("I should commit this")
- Some users prefer explicit commands (`/pr-commit-msg`)
- Minimal cost to maintain both (they reference same workflow)
- Removing either would frustrate users who prefer that method

---

#### ⚠️ **High Overlap:** test-plan-generator (skill) + test-plan (command)

**Current state:**
- Both generate test scenarios
- Skill: Quick conversational test scenarios
- Command: Formal QA test plans

**Recommendation:** ✅ **Keep both**
- Developers want quick scenarios ("what should I test?")
- QA teams want formal test plans (`/test-plan`)

---

## User Survey Recommendation

Before consolidating any skills/commands, survey users on:

### Question 1: Commit Message Preference
"When you need to create a commit message, which do you prefer?"
- [ ] Conversational: "I should commit this" (skill activates)
- [ ] Explicit: `/pr-commit-msg` command
- [ ] Both options are useful

### Question 2: Quick Checks vs. Full Audits
"Do you use both quick checks and full audits?"
- [ ] Yes, I use quick checks during development and full audits before release
- [ ] No, I only use quick checks
- [ ] No, I only use full audits
- [ ] I wasn't aware of the difference

### Question 3: Skill Activation Frequency
"How often do skills activate when you don't expect them?"
- [ ] Never (good)
- [ ] Rarely (acceptable)
- [ ] Sometimes (annoying)
- [ ] Often (frustrating)

---

## Final Recommendation

### ✅ Keep the Hybrid Architecture

**Rationale:**

1. **Skills and Commands Serve Different Purposes**
   - Skills: Conversational, quick, focused
   - Commands: Explicit, comprehensive, formal

2. **Minimal Redundancy**
   - Only 2 high-overlap pairs (commit-message, test-plan)
   - Both pairs serve different user workflows
   - Consolidation would reduce flexibility

3. **User Choice is Valuable**
   - Some users prefer conversational
   - Some users prefer explicit
   - Both are valid workflows

4. **Low Maintenance Cost**
   - Skills and commands reference same agents/workflows
   - No code duplication
   - Documentation is shared

5. **Pattern is Intentional**
   - Quick check (skill) + Full audit (command) is powerful
   - Matches user mental models
   - Reduces cognitive load (ask question vs. remember command)

---

## Implementation Actions

### ✅ No Consolidation Needed

Keep all 12 skills and 17 commands as-is.

### 📋 Documentation Improvements

**Add to plugin README:**

```markdown
## Skills vs. Commands: When to Use Each

### Quick Checks During Development (Skills)
Ask questions naturally, get instant feedback:
- "Is this accessible?" → accessibility-checker skill
- "Is this secure?" → security-scanner skill
- "Is this tested?" → coverage-analyzer skill

### Comprehensive Audits Before Release (Commands)
Run explicit commands for formal reports:
- `/audit-a11y` → Full accessibility audit
- `/audit-security` → Full security audit
- `/test-coverage` → Full coverage report
```

### 📊 Future Analytics

Track skill activation frequency to identify:
- Which skills are most useful
- Which skills activate unexpectedly (false positives)
- Which commands could benefit from skill equivalents

---

## Conclusion

**Decision: Keep all 12 skills and 17 commands.**

The hybrid architecture is optimal because:
- ✅ Clear separation of concerns (quick vs. comprehensive)
- ✅ User choice (conversational vs. explicit)
- ✅ Low maintenance overhead
- ✅ Matches user mental models
- ✅ No significant redundancies

**No consolidation recommended.**
