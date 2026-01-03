# Test 02: Orchestrator Agents

**Category:** Orchestration & Delegation
**Agents Tested:** 3 orchestrators
**Expected Behavior:** Agents spawn, access skills, CAN delegate to other agents

---

## Test 2.1: Workflow Specialist

### Setup
- Git repo with staged changes
- Changes include: code modifications, new tests, and UI changes

### Test Procedure
```
User: Run /pr-create and generate a comprehensive PR description
```

### Expected Behavior
1. ✅ Command spawns `workflow-specialist` agent
2. ✅ Agent accesses `commit-message-generator` skill
3. ✅ Agent analyzes git changes
4. ✅ Agent SHOULD delegate to specialists based on change type:
   - If UI changes → spawn `accessibility-specialist`
   - If security code → spawn `security-specialist`
   - If tests needed → spawn `testing-specialist`
5. ✅ Agent compiles all findings into PR description

### Verification Checklist - Phase 1: Initial Spawn
- [ ] workflow-specialist spawned successfully
- [ ] Skill loaded: commit-message-generator
- [ ] Git analysis performed (git status, git diff)

### Verification Checklist - Phase 2: Delegation
- [ ] Agent mentions spawning specialist(s)
- [ ] Task tool used to spawn other agents
- [ ] Multiple agents executed (check for parallel execution)
- [ ] Agent types spawned:
  - [ ] accessibility-specialist (if UI changes)
  - [ ] security-specialist (if security code)
  - [ ] testing-specialist (if tests needed)

### Verification Checklist - Phase 3: Compilation
- [ ] PR description includes findings from all specialists
- [ ] Conventional commit message generated
- [ ] Testing checklist included
- [ ] Security considerations mentioned (if applicable)

### Output Format Validation
```markdown
## PR Description

### Summary
- Adds user authentication feature
- Includes security hardening
- Adds comprehensive tests

### Changes
[Generated from git analysis]

### Security Review
[From security-specialist]

### Accessibility Check
[From accessibility-specialist]

### Testing
[From testing-specialist]

### Checklist
- [ ] Tests pass
- [ ] Security reviewed
- [ ] Accessibility verified
```

### Delegation Verification
```
Expected log output:
1. "Spawning accessibility-specialist to review UI changes..."
2. "Spawning security-specialist to review authentication code..."
3. "Spawning testing-specialist to verify test coverage..."
4. [parallel execution of 3 agents]
5. "Compiling findings from specialists..."
```

---

## Test 2.2: Testing Specialist (Semi-Orchestrator)

### Setup
- New feature code without tests
- Code includes UI component and security-sensitive logic

### Test Procedure
```
User: Run /test-generate for the UserAuthentication class
```

### Expected Behavior
1. ✅ Command spawns `testing-specialist` agent
2. ✅ Agent accesses test-scaffolding skill
3. ✅ Agent analyzes code to be tested
4. ✅ Agent SHOULD delegate for specialized tests:
   - If security-critical → spawn `security-specialist` for security test scenarios
   - If UI component → spawn `accessibility-specialist` for a11y test scenarios
5. ✅ Agent generates comprehensive test suite

### Verification Checklist - Phase 1: Initial Analysis
- [ ] testing-specialist spawned successfully
- [ ] Skills loaded: test-scaffolding, test-plan-generator, coverage-analyzer
- [ ] Code analysis performed

### Verification Checklist - Phase 2: Conditional Delegation
- [ ] Agent identifies security-critical code
- [ ] Agent spawns security-specialist (if applicable)
- [ ] Agent identifies UI components
- [ ] Agent spawns accessibility-specialist (if applicable)

### Verification Checklist - Phase 3: Test Generation
- [ ] Unit tests generated
- [ ] Integration tests generated
- [ ] Security test scenarios included (if security code)
- [ ] Accessibility test scenarios included (if UI code)
- [ ] Test coverage analysis provided

### Output Format Validation
```php
// Unit Tests
class UserAuthenticationTest extends TestCase {
  // [Generated unit tests]
}

// Security Tests (from security-specialist)
class UserAuthenticationSecurityTest extends TestCase {
  public function testSqlInjectionPrevention() {
    // [Security-focused test]
  }
}

// Accessibility Tests (from accessibility-specialist)
class LoginFormAccessibilityTest extends TestCase {
  public function testKeyboardNavigation() {
    // [A11y-focused test]
  }
}
```

### Delegation Verification
```
Expected log output:
1. "Analyzing UserAuthentication class..."
2. "Detected security-sensitive authentication logic"
3. "Spawning security-specialist for security test scenarios..."
4. "Detected login form UI component"
5. "Spawning accessibility-specialist for a11y test scenarios..."
6. "Generating comprehensive test suite..."
```

---

## Test 2.3: Live Audit Specialist (Pure Orchestrator)

### Setup
- Live website or staging environment
- Mix of accessibility, performance, security, and code quality issues

### Test Procedure
```
User: Run /audit-live-site https://example.com
```

### Expected Behavior
1. ✅ Command spawns `live-audit-specialist` agent
2. ✅ Agent has NO skills (pure orchestrator)
3. ✅ Agent MUST delegate to ALL 4 leaf specialists IN PARALLEL:
   - `performance-specialist`
   - `accessibility-specialist`
   - `security-specialist`
   - `code-quality-specialist`
4. ✅ Agent waits for all specialists to complete
5. ✅ Agent synthesizes findings into unified report

### Verification Checklist - Phase 1: Orchestration Setup
- [ ] live-audit-specialist spawned successfully
- [ ] Agent confirms it's a pure orchestrator
- [ ] No skills loaded for this agent

### Verification Checklist - Phase 2: Parallel Delegation
- [ ] Agent spawns ALL 4 specialists
- [ ] Specialists spawned in parallel (not sequential)
- [ ] Task tool used 4 times
- [ ] Specialists spawned:
  - [ ] performance-specialist
  - [ ] accessibility-specialist
  - [ ] security-specialist
  - [ ] code-quality-specialist

### Verification Checklist - Phase 3: Synthesis
- [ ] Agent waits for all specialists to complete
- [ ] Findings from all 4 specialists included
- [ ] Unified executive summary generated
- [ ] Issues prioritized across all categories
- [ ] Remediation roadmap provided

### Output Format Validation
```markdown
# Live Site Audit Report

## Executive Summary
- Overall Health Score: 72/100
- Critical Issues: 3
- High Priority: 8
- Medium Priority: 15
- Low Priority: 22

## Critical Issues (All Specialists)
1. [SECURITY] SQL Injection vulnerability - database.php:89
2. [A11Y] Missing alt text blocks screen readers - index.php:42
3. [PERF] 8s page load time exceeds threshold

## Performance Findings
[From performance-specialist]

## Accessibility Findings
[From accessibility-specialist]

## Security Findings
[From security-specialist]

## Code Quality Findings
[From code-quality-specialist]

## Remediation Roadmap
Priority 1: Fix critical security issues (Est: 4h)
Priority 2: Address accessibility blockers (Est: 6h)
Priority 3: Optimize performance (Est: 8h)
Priority 4: Refactor code quality (Est: 16h)
```

### Parallel Execution Verification
```
Expected log output (concurrent):
1. "Gathering site context..."
2. "Spawning 4 specialists in parallel..."
3. "  └─→ performance-specialist"
4. "  └─→ accessibility-specialist"
5. "  └─→ security-specialist"
6. "  └─→ code-quality-specialist"
7. [All 4 agents run simultaneously]
8. "All specialists completed. Synthesizing findings..."
```

---

## Test 2.4: Orchestration Edge Cases

### Test 2.4.1: Workflow Specialist - No Delegation Needed

**Setup:** Simple typo fix in documentation

**Test Procedure:**
```
User: Run /pr-create for a README typo fix
```

**Expected Behavior:**
- [ ] workflow-specialist spawns
- [ ] Agent analyzes changes
- [ ] Agent determines NO specialists needed (just docs)
- [ ] Agent generates simple PR description WITHOUT delegation
- [ ] No other agents spawned

**Verification:** Agent should be smart enough NOT to delegate when unnecessary.

---

### Test 2.4.2: Testing Specialist - No Security/A11y Code

**Setup:** Simple utility function with no security or UI concerns

**Test Procedure:**
```
User: Generate tests for the formatDate() utility function
```

**Expected Behavior:**
- [ ] testing-specialist spawns
- [ ] Agent analyzes code
- [ ] Agent determines NO specialists needed
- [ ] Agent generates unit tests WITHOUT delegation
- [ ] No other agents spawned

**Verification:** Agent should avoid unnecessary delegation.

---

### Test 2.4.3: Live Audit Specialist - Always Delegates

**Setup:** Any live site

**Test Procedure:**
```
User: Run /audit-live-site [any-url]
```

**Expected Behavior:**
- [ ] live-audit-specialist spawns
- [ ] Agent ALWAYS delegates (pure orchestrator)
- [ ] All 4 specialists spawned REGARDLESS of site
- [ ] Cannot skip delegation

**Verification:** Pure orchestrators MUST always delegate.

---

## Summary: Orchestrator Test Results

| Agent | Spawn | Skills | Delegates | Parallel | Synthesis | Edge Cases |
|-------|-------|--------|-----------|----------|-----------|------------|
| workflow-specialist | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| testing-specialist | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| live-audit-specialist | ☐ | N/A | ☐ | ☐ | ☐ | ☐ |

**Pass Criteria:** All checkboxes must be ✅

---

## Delegation Patterns Summary

### workflow-specialist
- **Delegation:** Conditional (based on change type)
- **Delegates To:** testing, security, accessibility
- **Pattern:** Parallel when multiple specialists needed
- **Skills Used:** commit-message-generator

### testing-specialist
- **Delegation:** Conditional (based on code type)
- **Delegates To:** security, accessibility
- **Pattern:** Sequential or parallel depending on needs
- **Skills Used:** test-scaffolding, test-plan-generator, coverage-analyzer

### live-audit-specialist
- **Delegation:** Always (pure orchestrator)
- **Delegates To:** performance, accessibility, security, code-quality
- **Pattern:** Parallel (all 4 simultaneously)
- **Skills Used:** None

---

## Common Issues & Debugging

### Orchestrator Doesn't Delegate
- Check: Does agent have Task tool in frontmatter?
- Check: Agent prompt mentions orchestration/delegation?
- Check: Target specialist exists and is valid?

### Delegation Not Parallel
- Check: Agent documentation specifies parallel execution?
- Check: Multiple Task tool calls in single message?

### Specialists Not Accessible
- Check: Target specialist names correct?
- Check: Target specialists exist in agents/ directory?

---

*Test Date: _________*
*Tester: _________*
*Results: _________*
