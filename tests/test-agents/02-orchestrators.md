# Test 02: Orchestrator Agents

**Category:** Orchestration & Workflow Coordination
**Agents Tested:** 2 orchestrators
**Expected Behavior:** Agents perform inline quality checks (no subagent spawning)

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
4. ✅ Agent performs inline quality checks based on change type:
   - If UI changes → reviews accessibility concerns inline using Read/Grep
   - If security code → reviews security concerns inline using Read/Grep
   - If tests needed → reviews test coverage inline using Read/Glob
5. ✅ Agent compiles all findings into PR description

### Verification Checklist - Phase 1: Initial Spawn
- [ ] workflow-specialist spawned successfully
- [ ] Skill loaded: commit-message-generator
- [ ] Git analysis performed (git status, git diff)

### Verification Checklist - Phase 2: Inline Quality Checks
- [ ] Agent identifies relevant quality concerns from diff
- [ ] Agent uses Read/Grep to inspect code inline (NOT Task tool)
- [ ] No other agents spawned
- [ ] Quality findings noted from inline analysis:
  - [ ] Accessibility concerns (if UI changes)
  - [ ] Security concerns (if security code)
  - [ ] Test coverage (if new code)

### Verification Checklist - Phase 3: Compilation
- [ ] PR description includes inline quality findings
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
[From inline analysis]

### Accessibility Check
[From inline analysis]

### Testing
[From test coverage review]

### Checklist
- [ ] Tests pass
- [ ] Security reviewed
- [ ] Accessibility verified
```

### Inline Analysis Verification
```
Expected log output:
1. "Analyzing git changes..."
2. "Detected UI component changes — checking accessibility inline..."
3. "Detected authentication code — reviewing security concerns..."
4. "Checking test coverage for new code..."
5. "Compiling PR description with quality findings..."
```

---

## Test 2.2: Testing Specialist (Inline Quality Checks)

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
4. ✅ Agent generates security and accessibility test scenarios INLINE:
   - If security-critical → generates security test cases directly (SQL injection, XSS, CSRF patterns)
   - If UI component → generates accessibility test cases directly (keyboard nav, ARIA, contrast)
5. ✅ Agent generates comprehensive test suite with all scenarios integrated

### Verification Checklist - Phase 1: Initial Analysis
- [ ] testing-specialist spawned successfully
- [ ] Skills loaded: test-scaffolding, test-plan-generator, coverage-analyzer
- [ ] Code analysis performed

### Verification Checklist - Phase 2: Inline Scenario Generation
- [ ] Agent identifies security-critical code
- [ ] Agent generates security test scenarios inline (NOT via Task tool)
- [ ] Agent identifies UI components
- [ ] Agent generates accessibility test scenarios inline (NOT via Task tool)

### Verification Checklist - Phase 3: Test Generation
- [ ] Unit tests generated
- [ ] Integration tests generated
- [ ] Security test scenarios included inline (if security code)
- [ ] Accessibility test scenarios included inline (if UI code)
- [ ] Test coverage analysis provided

### Output Format Validation
```php
// Unit Tests
class UserAuthenticationTest extends TestCase {
  // [Generated unit tests]
}

// Security Tests (generated inline)
class UserAuthenticationSecurityTest extends TestCase {
  public function testSqlInjectionPrevention() {
    // [Security test — generated inline by testing-specialist]
  }
}

// Accessibility Tests (generated inline)
class LoginFormAccessibilityTest extends TestCase {
  public function testKeyboardNavigation() {
    // [A11y test — generated inline by testing-specialist]
  }
}
```

### Inline Generation Verification
```
Expected log output:
1. "Analyzing UserAuthentication class..."
2. "Detected security-sensitive authentication logic"
3. "Generating security test scenarios inline..."
4. "Detected login form UI component"
5. "Generating accessibility test scenarios inline..."
6. "Compiling comprehensive test suite..."
```

---

## Test 2.3: Orchestration Edge Cases

### Test 2.3.1: Workflow Specialist - No Quality Checks Needed

**Setup:** Simple typo fix in documentation

**Test Procedure:**
```
User: Run /pr-create for a README typo fix
```

**Expected Behavior:**
- [ ] workflow-specialist spawns
- [ ] Agent analyzes changes
- [ ] Agent determines NO quality checks needed (just docs)
- [ ] Agent generates simple PR description WITHOUT inline analysis
- [ ] No other agents spawned

**Verification:** Agent should be smart enough NOT to run quality checks when unnecessary.

---

### Test 2.3.2: Testing Specialist - No Security/A11y Code

**Setup:** Simple utility function with no security or UI concerns

**Test Procedure:**
```
User: Generate tests for the formatDate() utility function
```

**Expected Behavior:**
- [ ] testing-specialist spawns
- [ ] Agent analyzes code
- [ ] Agent determines NO security/a11y scenarios needed
- [ ] Agent generates unit tests WITHOUT inline security/a11y generation
- [ ] No other agents spawned

**Verification:** Agent should avoid unnecessary inline analysis.

---

## Summary: Orchestrator Test Results

| Agent | Spawn | Skills | Inline Checks | No Agent Spawning | Synthesis | Edge Cases |
|-------|-------|--------|---------------|-------------------|-----------|------------|
| workflow-specialist | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |
| testing-specialist | ☐ | ☐ | ☐ | ☐ | ☐ | ☐ |

**Pass Criteria:** All checkboxes must be ✅

---

## Orchestration Patterns Summary

### workflow-specialist
- **Quality Checks:** Inline (Read/Grep/Bash on own tools)
- **Spawns Agents:** Never — no Task tool
- **Pattern:** Sequential inline analysis then PR generation
- **Skills Used:** commit-message-generator

### testing-specialist
- **Quality Checks:** Inline (generates security/a11y test scenarios directly)
- **Spawns Agents:** Never — no Task tool
- **Pattern:** Analyze → generate tests → add inline specialist scenarios
- **Skills Used:** test-scaffolding, test-plan-generator, coverage-analyzer

---

## Note: live-site-audit Skill Spawning

The `/audit-live-site` command spawns 4 leaf specialists IN PARALLEL directly from the **main Claude Code session** (via the live-site-audit skill). This is NOT handled by an orchestrator agent — the main session does the synthesis after all agents complete. See `tests/test-agents/04-orchestration.md` Test 4.4 for details.

---

## Common Issues & Debugging

### Orchestrator Tries to Spawn Other Agents
- Check: Agent AGENT.md frontmatter should NOT have `Task` in tools line
- Check: Agent documentation should describe inline analysis, not delegation
- Fix: Agent should use Read/Grep/Bash to check code inline

### Inline Analysis Not Happening
- Check: Agent prompt includes instructions for inline security/a11y checks?
- Check: Agent identifies relevant code patterns before generating tests?

---

*Test Date: _________*
*Tester: _________*
*Results: _________*
