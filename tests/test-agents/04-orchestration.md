# Test 04: Orchestration & Delegation Patterns

**Category:** Agent Orchestration
**Purpose:** Verify that skill-level spawning works correctly and agents do NOT attempt to spawn subagents
**Focus:** Skill-level parallel spawning, inline quality checks, no recursive agent spawning

---

## Background: Claude Code Orchestration Model

In Claude Code, only the **main session** can spawn agents. Agents CANNOT spawn further agents
(the `Agent` tool is not available to spawned subagents). CMS Cultivator's orchestration model:

- **Skill-level spawning**: Skills in the main session spawn agents in parallel or sequentially
- **Inline analysis**: Orchestrator agents (workflow-specialist, testing-specialist) do quality checks inline using their own tools
- **No recursive spawning**: No agent spawns another agent

---

## Test 4.1: Tool Configuration Verification

### Test 4.1.1: Orchestrators Do NOT Have Task Tool

**Check Agent Frontmatter:**
```bash
# Should NOT show Task tool for orchestrator agents
grep "^tools:" agents/workflow-specialist/AGENT.md
grep "^tools:" agents/testing-specialist/AGENT.md
grep "^tools:" agents/design-specialist/AGENT.md
```

**Expected Output:**
```
tools: Read, Glob, Grep, Bash, Task, Write, Edit
tools: Read, Glob, Grep, Bash, Task, Write, Edit
tools: Read, Glob, Grep, Bash, Write, Edit, ToolSearch, figma MCP, chrome-devtools MCP, playwright MCP
```

**Note:** The `tools: Task` frontmatter line controls what the agent THINKS it has, but Claude Code
does not make the `Agent` spawning tool available to subagents regardless. Verify that agents do not
attempt to use Task for spawning — check their AGENT.md prose for spawning instructions.

**Verification:**
- [ ] workflow-specialist AGENT.md describes inline quality checks (not Task spawning)
- [ ] testing-specialist AGENT.md describes inline scenario generation (not Task spawning)
- [ ] design-specialist AGENT.md describes code generation only (not spawning)

---

### Test 4.1.2: Leaf Specialists Do NOT Have Task Tool

**Check Agent Frontmatter:**
```bash
grep "^tools:" agents/accessibility-specialist/AGENT.md
grep "^tools:" agents/performance-specialist/AGENT.md
grep "^tools:" agents/security-specialist/AGENT.md
grep "^tools:" agents/documentation-specialist/AGENT.md
grep "^tools:" agents/code-quality-specialist/AGENT.md
```

**Expected Output:**
```
tools: Read, Glob, Grep, Bash
tools: Read, Glob, Grep, Bash
tools: Read, Glob, Grep, Bash
tools: Read, Glob, Grep, Bash, Write, Edit
tools: Read, Glob, Grep, Bash
```

**Verification:**
- [ ] No leaf specialist has Task tool
- [ ] Clear separation between orchestrators and leaf specialists

---

## Test 4.2: Workflow Specialist Inline Quality Checks

### Test 4.2.1: Inline Checks - UI Changes

**Setup:**
- Git repo with staged changes
- Changes include: New form component with inputs

**Test Procedure:**
```
User: Run /pr-create for the new LoginForm component
```

**Expected Pattern:**
```
workflow-specialist
  ├─→ Analyzes git diff (sees UI changes)
  ├─→ Generates commit message (uses skill)
  ├─→ Reviews accessibility concerns inline (Read/Grep on changed files)
  ├─→ Reviews test coverage inline (Read/Glob for test files)
  └─→ Compiles PR description with inline findings
```

**Verification Checklist:**
- [ ] workflow-specialist spawned
- [ ] Read/Grep tools used on changed files
- [ ] NO other agents spawned (no Task tool calls)
- [ ] Accessibility findings included in PR description
- [ ] Test coverage review included

**Log Validation:**
```
✓ "Analyzing git changes..."
✓ "Detected UI component changes — reviewing accessibility inline..."
✓ "Checking test coverage..."
✓ "Compiling PR description..."
✗ NOT: "Spawning accessibility-specialist..."
✗ NOT: "Spawning testing-specialist..."
```

---

### Test 4.2.2: Inline Checks - Security Code

**Setup:**
- Git repo with staged changes
- Changes include: Authentication middleware with password hashing

**Test Procedure:**
```
User: Run /pr-create for authentication middleware
```

**Expected Pattern:**
```
workflow-specialist
  ├─→ Analyzes git diff (sees security code)
  ├─→ Generates commit message (uses skill)
  ├─→ Reviews security concerns inline (Read/Grep on changed files)
  └─→ Compiles PR description with security focus
```

**Verification Checklist:**
- [ ] workflow-specialist spawned
- [ ] Security concerns reviewed inline using Read/Grep
- [ ] NO security-specialist spawned
- [ ] Security findings prominent in PR description
- [ ] Security testing checklist included

---

### Test 4.2.3: No Checks - Simple Change

**Setup:**
- Git repo with staged changes
- Changes include: README.md typo fix only

**Test Procedure:**
```
User: Run /pr-create for README typo fix
```

**Expected Behavior:**
```
workflow-specialist
  ├─→ Analyzes git diff (sees documentation only)
  ├─→ Generates commit message (uses skill)
  ├─→ Determines NO inline checks needed
  └─→ Generates simple PR description
```

**Verification Checklist:**
- [ ] workflow-specialist spawned
- [ ] NO other agents spawned
- [ ] No unnecessary quality checks run
- [ ] Simple PR description generated

---

## Test 4.3: Testing Specialist Inline Scenario Generation

### Test 4.3.1: Security-Sensitive Code

**Setup:** Authentication function needing tests

**Test Procedure:**
```
User: Generate tests for the validatePassword() function
```

**Expected Pattern:**
```
testing-specialist
  ├─→ Analyzes code (sees security function)
  ├─→ Generates standard unit tests (uses skill)
  ├─→ Generates security test scenarios INLINE (SQL injection, XSS, boundary checks)
  └─→ Compiles comprehensive test suite
```

**Verification Checklist:**
- [ ] testing-specialist spawned
- [ ] Standard tests generated first
- [ ] Security test scenarios generated inline (NOT via spawning security-specialist)
- [ ] Both standard and security test scenarios in final output

---

### Test 4.3.2: UI Component Code

**Setup:** Form component with accessibility concerns

**Test Procedure:**
```
User: Generate tests for the ContactForm component
```

**Expected Pattern:**
```
testing-specialist
  ├─→ Analyzes code (sees UI component)
  ├─→ Generates standard unit tests (uses skill)
  ├─→ Generates accessibility test scenarios INLINE (keyboard nav, ARIA, focus)
  └─→ Compiles comprehensive test suite
```

**Verification Checklist:**
- [ ] testing-specialist spawned
- [ ] Standard component tests generated
- [ ] Accessibility test scenarios generated inline (NOT via spawning accessibility-specialist)
- [ ] Keyboard and screen reader test coverage included

---

### Test 4.3.3: Simple Utility Function

**Setup:** Pure utility function with no special concerns

**Test Procedure:**
```
User: Generate tests for the formatDate() function
```

**Expected Behavior:**
```
testing-specialist
  ├─→ Analyzes code (simple utility)
  ├─→ Generates unit tests (uses skill)
  └─→ No security/a11y scenarios needed
```

**Verification Checklist:**
- [ ] testing-specialist spawned
- [ ] Unit tests generated
- [ ] NO other agents spawned
- [ ] No unnecessary inline security/a11y analysis

---

## Test 4.4: live-site-audit Skill Spawning

### Test 4.4.1: Full Parallel Spawning from Main Session

**Setup:** Any live website or staging environment

**Test Procedure:**
```
User: Run /audit-live-site https://staging.example.com
```

**Expected Pattern (main session, NOT a subagent):**
```
live-site-audit skill (main session)
  ├─→ Spawns ALL 4 specialists IN PARALLEL:
  │     ├─→ performance-specialist
  │     ├─→ accessibility-specialist
  │     ├─→ security-specialist
  │     └─→ code-quality-specialist
  ├─→ Waits for all to complete
  └─→ Main session synthesizes unified report
```

**Verification Checklist - Parallel Execution:**
- [ ] 4 Agent() calls made in a single message (parallel)
- [ ] ALL 4 specialists spawned:
  - [ ] performance-specialist
  - [ ] accessibility-specialist
  - [ ] security-specialist
  - [ ] code-quality-specialist
- [ ] Spawned simultaneously (not sequential)
- [ ] Main session synthesizes (no additional orchestrator agent)

**Parallel Execution Indicators:**
```
✓ Multiple Agent tool calls in single message
✓ NOT: spawning via a live-audit-specialist subagent
✓ NOT: "First performance, then accessibility, then..."
✓ YES: "All specialists running concurrently..."
```

---

### Test 4.4.2: Synthesis Quality

**Verification:** After all specialists return findings

**Expected Synthesis Features:**
- [ ] Executive summary with overall health score
- [ ] Issues categorized by severity (Critical → Low)
- [ ] Issues from ALL 4 specialists included
- [ ] Cross-category prioritization (not per-specialist)
- [ ] Remediation roadmap with time estimates
- [ ] Positive findings acknowledged

**Output Structure Validation:**
```markdown
# Expected Structure:

## Executive Summary
[Overall health, scores across all categories]

## Critical Issues (All Specialists Combined)
[Issues from performance, a11y, security, code quality]

## By Specialist (Detailed Findings)
### Performance Findings
### Accessibility Findings
### Security Findings
### Code Quality Findings

## Prioritized Remediation Roadmap
[Ordered by impact, not by specialist]
```

---

## Test 4.5: Design Skill Sequential Spawning

### Test 4.5.1: Design-to-WP-Block Sequential Flow

**Setup:** Figma URL or design screenshot

**Test Procedure:**
```
User: Run /design-to-wp-block [figma-url]
```

**Expected Sequential Pattern (main session):**
```
Step 1: Spawns design-specialist (code generation)
         └─→ Returns structured output: file paths, SCSS paths, design specs, test URL

Step 2: Spawns responsive-styling-specialist
         └─→ Uses SCSS paths + design specs from Step 1

Step 3: Spawns browser-validator-specialist
         └─→ Uses test URL from Step 1
```

**Verification Checklist:**
- [ ] design-specialist spawned first
- [ ] design-specialist returns structured output with SCSS paths and test URL
- [ ] responsive-styling-specialist spawned after Step 1 completes
- [ ] browser-validator-specialist spawned after Step 1 completes
- [ ] Steps 2 and 3 use output from Step 1 (not hardcoded paths)

---

## Test 4.6: Delegation Failure Handling

### Test 4.6.1: Specialist Not Available

**Scenario:** What if a spawned specialist fails to start?

**Test Setup:**
```
Temporarily rename agents/accessibility-specialist directory
Run /audit-live-site
```

**Expected Behavior:**
- [ ] Main session attempts to spawn accessibility-specialist
- [ ] Spawn fails (agent not found)
- [ ] Main session handles error gracefully
- [ ] Continues with other 3 specialists
- [ ] Notes accessibility audit failed in report

---

### Test 4.6.2: Specialist Returns Empty Results

**Scenario:** Specialist spawns but finds no issues

**Test Procedure:**
```
User: Run /audit-live-site on a well-optimized site
```

**Expected Behavior:**
- [ ] All 4 specialists spawn
- [ ] Some may return "No issues found"
- [ ] Main session handles empty results
- [ ] Synthesis includes positive findings
- [ ] Overall report still generated

---

## Summary: Orchestration Test Results

| Pattern | Test | Passed | Notes |
|---------|------|--------|-------|
| workflow → inline checks | UI changes | ☐ | Read/Grep inline, no spawning |
| workflow → inline checks | Security code | ☐ | Read/Grep inline, no spawning |
| workflow → no checks | Simple change | ☐ | Should NOT run checks |
| testing → inline scenarios | Security code | ☐ | Generates scenarios inline |
| testing → inline scenarios | UI code | ☐ | Generates scenarios inline |
| testing → no scenarios | Utility code | ☐ | Should NOT generate extra scenarios |
| live-site-audit skill → parallel | Any site | ☐ | MUST spawn all 4 from main session |
| live-site-audit skill → synthesis | Quality | ☐ | Unified report in main session |
| design skill → sequential | Figma design | ☐ | 3 agents in sequence |

**Pass Criteria:** All checkboxes must be ✅

---

## Orchestration Architecture Diagram

```
MAIN SESSION (Can Spawn Agents)
==========================================================================

live-site-audit skill
    ├── Spawns in parallel: performance, accessibility, security, code-quality
    └── Synthesizes inline after all complete

design-to-wp-block / design-to-drupal-paragraph skills
    ├── Step 1: Spawns design-specialist (code generation)
    ├── Step 2: Spawns responsive-styling-specialist (SCSS)
    └── Step 3: Spawns browser-validator-specialist (validation)

pr-create / pr-review / pr-commit-msg / pr-release skills
    └── Spawns workflow-specialist (inline quality checks, no subagent spawning)

test-generate / test-plan / test-coverage skills
    └── Spawns testing-specialist (inline scenario generation, no subagent spawning)


AGENTS (Cannot Spawn Further Agents)
==========================================================================

workflow-specialist
    ├── Tools: Read, Glob, Grep, Bash, Write, Edit
    ├── Quality checks: INLINE (no subagent spawning)
    └── Pattern: Analyze code → inline checks → PR generation

testing-specialist
    ├── Tools: Read, Glob, Grep, Bash, Write, Edit
    ├── Scenario generation: INLINE (no subagent spawning)
    └── Pattern: Analyze code → tests → inline security/a11y scenarios

design-specialist
    ├── Tools: Read, Glob, Grep, Bash, Write, Edit, ToolSearch, figma, playwright, chrome-devtools
    ├── Spawning: NONE (code generation only)
    └── Pattern: Analyze design → generate files → return structured output

LEAF SPECIALISTS (Cannot Delegate)
==========================================================================

[accessibility|performance|security|documentation|code-quality]-specialist
    ├── Tools: [read/grep/bash only]
    ├── Spawns: NONE
    └── Pattern: Direct execution only
```

---

## Common Issues & Debugging

### Agent Tries to Spawn Another Agent
- Check: Does the agent's AGENT.md prose describe spawning/delegation?
- Fix: Update AGENT.md to describe inline analysis instead
- Note: Even if Task is in tools frontmatter, the Agent spawn tool is unavailable to subagents in Claude Code

### Skill Not Spawning in Parallel
- Check: Are Agent() calls made in a single message (not sequential)?
- Fix: Skill SKILL.md should instruct parallel Agent calls in one message

### Sequential Instead of Parallel (live-site-audit)
- Check: Skill SKILL.md specifies parallel execution?
- Fix: Spawn all 4 agents before waiting for any results

### Over-Analysis
- Check: Agent logic too broad (running inline checks unnecessarily)?
- Fix: Add conditional logic — only check when code type warrants it

---

*Test Date: _________*
*Tester: _________*
*Results: _________*
