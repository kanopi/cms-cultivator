# Test 04: Orchestration & Delegation Patterns

**Category:** Agent Orchestration
**Purpose:** Verify orchestrators delegate correctly to other agents
**Focus:** Task tool usage, parallel execution, delegation logic

---

## Test 4.1: Task Tool Verification

### Test 4.1.1: Orchestrators Have Task Tool

**Check Agent Frontmatter:**
```bash
# Should show Task tool for orchestrators
grep "^tools:" agents/workflow-specialist/AGENT.md
grep "^tools:" agents/live-audit-specialist/AGENT.md
grep "^tools:" agents/testing-specialist/AGENT.md
```

**Expected Output:**
```
tools: Read, Glob, Grep, Bash, Task, Write, Edit
tools: Read, Glob, Grep, Bash, Task
tools: Read, Glob, Grep, Bash, Task, Write
```

**Verification:**
- [ ] workflow-specialist has Task tool
- [ ] live-audit-specialist has Task tool
- [ ] testing-specialist has Task tool

---

### Test 4.1.2: Leaf Specialists Do NOT Have Task Tool

**Check Agent Frontmatter:**
```bash
# Should NOT show Task tool for leaf specialists
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
- [ ] All orchestrators have Task tool
- [ ] Clear separation between orchestrators and leaf specialists

---

## Test 4.2: Workflow Specialist Orchestration

### Test 4.2.1: Conditional Delegation - UI Changes

**Setup:**
- Git repo with staged changes
- Changes include: New React component with form inputs

**Test Procedure:**
```
User: Run /pr-create for the new LoginForm component
```

**Expected Delegation Pattern:**
```
workflow-specialist
  ├─→ Analyzes git diff (sees UI changes)
  ├─→ Generates commit message (uses skill)
  ├─→ Spawns accessibility-specialist (UI changes detected)
  │     └─→ Returns: a11y findings
  ├─→ Spawns testing-specialist (new component needs tests)
  │     └─→ Returns: test recommendations
  └─→ Compiles PR description with all findings
```

**Verification Checklist:**
- [ ] workflow-specialist spawned
- [ ] Task tool used to spawn other agents
- [ ] accessibility-specialist spawned (UI changes)
- [ ] testing-specialist spawned (new code)
- [ ] Findings from both specialists in PR description

**Delegation Log Validation:**
```
✓ "Analyzing git changes..."
✓ "Detected UI component changes"
✓ "Spawning accessibility-specialist to review..."
✓ "Spawning testing-specialist to generate tests..."
✓ "Compiling comprehensive PR description..."
```

---

### Test 4.2.2: Conditional Delegation - Security Code

**Setup:**
- Git repo with staged changes
- Changes include: Authentication middleware with password hashing

**Test Procedure:**
```
User: Run /pr-create for authentication middleware
```

**Expected Delegation Pattern:**
```
workflow-specialist
  ├─→ Analyzes git diff (sees security code)
  ├─→ Generates commit message (uses skill)
  ├─→ Spawns security-specialist (security-critical code)
  │     └─→ Returns: security review
  ├─→ Spawns testing-specialist (security needs tests)
  │     └─→ Returns: security test recommendations
  └─→ Compiles PR description with security focus
```

**Verification Checklist:**
- [ ] workflow-specialist spawned
- [ ] security-specialist spawned (security code detected)
- [ ] testing-specialist spawned (security tests needed)
- [ ] Security findings prominent in PR description
- [ ] Security testing checklist included

---

### Test 4.2.3: No Delegation - Simple Change

**Setup:**
- Git repo with staged changes
- Changes include: README.md typo fix only

**Test Procedure:**
```
User: Run /pr-create for README typo fix
```

**Expected Behavior (NO Delegation):**
```
workflow-specialist
  ├─→ Analyzes git diff (sees documentation only)
  ├─→ Generates commit message (uses skill)
  ├─→ Determines NO specialists needed
  └─→ Generates simple PR description without delegation
```

**Verification Checklist:**
- [ ] workflow-specialist spawned
- [ ] NO other agents spawned
- [ ] Task tool NOT used
- [ ] Simple PR description generated
- [ ] Agent smart enough to avoid unnecessary delegation

---

## Test 4.3: Testing Specialist Orchestration

### Test 4.3.1: Security-Sensitive Code

**Setup:** Authentication function needing tests

**Test Procedure:**
```
User: Generate tests for the validatePassword() function
```

**Expected Delegation Pattern:**
```
testing-specialist
  ├─→ Analyzes code (sees security function)
  ├─→ Generates standard unit tests (uses skill)
  ├─→ Spawns security-specialist for security test scenarios
  │     └─→ Returns: SQL injection tests, XSS tests
  └─→ Compiles comprehensive test suite
```

**Verification Checklist:**
- [ ] testing-specialist spawned
- [ ] Standard tests generated first
- [ ] security-specialist spawned for security tests
- [ ] Both test types in final output
- [ ] Security test scenarios from specialist

---

### Test 4.3.2: UI Component Code

**Setup:** Form component with accessibility concerns

**Test Procedure:**
```
User: Generate tests for the ContactForm component
```

**Expected Delegation Pattern:**
```
testing-specialist
  ├─→ Analyzes code (sees UI component)
  ├─→ Generates standard unit tests (uses skill)
  ├─→ Spawns accessibility-specialist for a11y test scenarios
  │     └─→ Returns: keyboard nav tests, screen reader tests
  └─→ Compiles comprehensive test suite
```

**Verification Checklist:**
- [ ] testing-specialist spawned
- [ ] Standard component tests generated
- [ ] accessibility-specialist spawned for a11y tests
- [ ] Accessibility test scenarios included
- [ ] Keyboard and screen reader test coverage

---

### Test 4.3.3: Simple Utility Function

**Setup:** Pure utility function with no special concerns

**Test Procedure:**
```
User: Generate tests for the formatDate() function
```

**Expected Behavior (NO Delegation):**
```
testing-specialist
  ├─→ Analyzes code (simple utility)
  ├─→ Generates unit tests (uses skill)
  └─→ No delegation needed
```

**Verification Checklist:**
- [ ] testing-specialist spawned
- [ ] Unit tests generated
- [ ] NO other agents spawned
- [ ] No unnecessary delegation

---

## Test 4.4: Live Audit Specialist Orchestration

### Test 4.4.1: Full Parallel Delegation

**Setup:** Any live website or staging environment

**Test Procedure:**
```
User: Run /audit-live-site https://staging.example.com
```

**Expected Delegation Pattern (ALWAYS):**
```
live-audit-specialist (pure orchestrator)
  ├─→ Gathers site context
  ├─→ Spawns ALL 4 specialists IN PARALLEL:
  │     ├─→ performance-specialist
  │     ├─→ accessibility-specialist
  │     ├─→ security-specialist
  │     └─→ code-quality-specialist
  ├─→ Waits for all to complete
  └─→ Synthesizes unified report
```

**Verification Checklist - Parallel Execution:**
- [ ] live-audit-specialist spawned
- [ ] Explicitly mentions spawning in parallel
- [ ] ALL 4 specialists spawned:
  - [ ] performance-specialist
  - [ ] accessibility-specialist
  - [ ] security-specialist
  - [ ] code-quality-specialist
- [ ] Spawned simultaneously (not sequential)
- [ ] Agent waits for all before synthesizing

**Parallel Execution Indicators:**
```
✓ "Spawning 4 specialists in parallel..."
✓ Multiple Task tool calls in single message
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

## Test 4.5: Delegation Failure Handling

### Test 4.5.1: Specialist Not Available

**Scenario:** What if a delegated specialist fails to spawn?

**Test Setup:**
```
Temporarily rename agents/accessibility-specialist directory
Run /audit-live-site
```

**Expected Behavior:**
- [ ] live-audit-specialist attempts to spawn accessibility-specialist
- [ ] Spawn fails (directory not found)
- [ ] Agent handles error gracefully
- [ ] Continues with other 3 specialists
- [ ] Notes accessibility audit failed in report

**Verification:**
- Orchestrators should handle delegation failures
- Should not crash entire audit
- Should note missing specialist in output

---

### Test 4.5.2: Specialist Returns Empty Results

**Scenario:** Specialist spawns but finds no issues

**Test Procedure:**
```
User: Run /audit-live-site on perfectly optimized site
```

**Expected Behavior:**
- [ ] All 4 specialists spawn
- [ ] Some may return "No issues found"
- [ ] Orchestrator handles empty results
- [ ] Synthesis includes positive findings
- [ ] Overall report still generated

**Verification:**
- Empty results from specialists should be OK
- Orchestrator should celebrate good findings
- Report should be positive, not empty

---

## Test 4.6: Orchestration Performance

### Test 4.6.1: Parallel vs Sequential Timing

**Hypothesis:** Parallel execution should be faster than sequential

**Test Procedure:**
```
1. Time a live-audit (parallel execution)
2. Compare to sequential execution (if possible)
```

**Expected:**
- [ ] Parallel execution spawns all at once
- [ ] Total time ≈ slowest specialist (not sum of all)
- [ ] Faster than running 4 commands sequentially

**Timing Example:**
```
Sequential: P(10s) + A(15s) + S(12s) + Q(8s) = 45s total
Parallel:   max(10s, 15s, 12s, 8s) = 15s total
```

---

## Summary: Orchestration Test Results

| Pattern | Test | Passed | Notes |
|---------|------|--------|-------|
| workflow → conditional | UI changes | ☐ | Should spawn a11y |
| workflow → conditional | Security code | ☐ | Should spawn security |
| workflow → conditional | Simple change | ☐ | Should NOT delegate |
| testing → conditional | Security code | ☐ | Should spawn security |
| testing → conditional | UI code | ☐ | Should spawn a11y |
| testing → conditional | Utility code | ☐ | Should NOT delegate |
| live-audit → always | Any site | ☐ | MUST spawn all 4 |
| live-audit → parallel | Execution | ☐ | All 4 simultaneously |
| live-audit → synthesis | Quality | ☐ | Unified report |

**Pass Criteria:** All checkboxes must be ✅

---

## Orchestration Architecture Diagram

```
ORCHESTRATORS (Can Delegate)
==========================================================================

workflow-specialist
    ├── Skills: commit-message-generator
    ├── Delegates to: [conditional]
    │   ├── accessibility-specialist (if UI changes)
    │   ├── security-specialist (if security code)
    │   └── testing-specialist (if new code)
    └── Pattern: Conditional parallel

testing-specialist
    ├── Skills: test-scaffolding, test-plan-generator, coverage-analyzer
    ├── Delegates to: [conditional]
    │   ├── security-specialist (if security code)
    │   └── accessibility-specialist (if UI code)
    └── Pattern: Conditional sequential/parallel

live-audit-specialist
    ├── Skills: NONE (pure orchestrator)
    ├── Delegates to: [always, all 4]
    │   ├── performance-specialist
    │   ├── accessibility-specialist
    │   ├── security-specialist
    │   └── code-quality-specialist
    └── Pattern: Always parallel

LEAF SPECIALISTS (Cannot Delegate)
==========================================================================

[accessibility|performance|security|documentation|code-quality]-specialist
    ├── Skills: [one specific skill]
    ├── Delegates to: NONE
    └── Pattern: Direct execution only
```

---

## Common Issues & Debugging

### Orchestrator Not Delegating
- Check: Agent has Task tool in frontmatter?
- Check: Agent documentation mentions delegation?
- Check: Delegation logic in agent prompt clear?

### Sequential Instead of Parallel
- Check: Agent spawns multiple agents in single message?
- Check: Agent documentation specifies parallel execution?
- Fix: Spawn all agents before waiting for results

### Over-Delegation
- Check: Agent logic too broad (spawning unnecessarily)?
- Fix: Add conditional logic to agent prompt
- Example: "Only spawn security-specialist IF code is security-critical"

### Under-Delegation
- Check: Agent missing delegation logic?
- Check: Agent doesn't recognize when to delegate?
- Fix: Improve detection patterns in agent prompt

---

*Test Date: _________*
*Tester: _________*
*Results: _________*
