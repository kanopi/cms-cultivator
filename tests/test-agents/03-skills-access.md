# Test 03: Skills Access Verification

**Category:** Agent-Skill Integration
**Purpose:** Verify agents can access their assigned skills
**Expected Behavior:** Skills load only when agent uses them, not globally

---

## Test 3.1: Skill Loading Behavior

### Test 3.1.1: Skills Load Only in Agent Context

**Hypothesis:** Skills should only be accessible within agent execution, not globally in Claude Code

**Test Procedure:**
```
1. User: Ask Claude about accessibility in normal conversation
2. User: Run /audit-a11y command
```

**Expected Behavior:**
- [ ] In normal conversation: accessibility-checker skill does NOT auto-activate
- [ ] When /audit-a11y runs: accessibility-specialist spawns and skill loads
- [ ] Skill is scoped to agent, not main conversation

**Verification:**
- Skills should only activate when explicitly triggered by agents
- Main conversation should NOT see skill prompts unless skill description triggers it

---

## Test 3.2: Agent-Skill Mapping Verification

### Test 3.2.1: accessibility-specialist → accessibility-checker

**Setup:** HTML file with missing alt text

**Test Procedure:**
```
User: Run /audit-a11y on homepage.php
```

**Expected Behavior:**
- [ ] accessibility-specialist spawns
- [ ] Skill loaded: accessibility-checker
- [ ] Agent uses skill knowledge to:
  - [ ] Identify WCAG violations
  - [ ] Check specific accessibility patterns
  - [ ] Provide CMS-specific guidance

**Verification Log:**
```
✓ Agent spawned: accessibility-specialist
✓ Skills referenced: accessibility-checker
✓ Skill knowledge applied: WCAG 2.1 success criteria mentioned
✓ Output format matches skill specification
```

---

### Test 3.2.2: performance-specialist → performance-analyzer

**Setup:** Page with slow database queries

**Test Procedure:**
```
User: Run /audit-perf and analyze query performance
```

**Expected Behavior:**
- [ ] performance-specialist spawns
- [ ] Skill loaded: performance-analyzer
- [ ] Agent uses skill knowledge to:
  - [ ] Measure Core Web Vitals
  - [ ] Identify N+1 queries
  - [ ] Suggest caching strategies

**Verification Log:**
```
✓ Agent spawned: performance-specialist
✓ Skills referenced: performance-analyzer
✓ Skill knowledge applied: Core Web Vitals metrics mentioned
✓ Output format matches skill specification
```

---

### Test 3.2.3: security-specialist → security-scanner

**Setup:** PHP file with SQL injection vulnerability

**Test Procedure:**
```
User: Run /audit-security on database.php
```

**Expected Behavior:**
- [ ] security-specialist spawns
- [ ] Skill loaded: security-scanner
- [ ] Agent uses skill knowledge to:
  - [ ] Identify OWASP Top 10 issues
  - [ ] Detect SQL injection patterns
  - [ ] Recommend prepared statements

**Verification Log:**
```
✓ Agent spawned: security-specialist
✓ Skills referenced: security-scanner
✓ Skill knowledge applied: OWASP A03:2021 referenced
✓ Output format matches skill specification
```

---

### Test 3.2.4: testing-specialist → Multiple Skills

**Setup:** New feature code without tests

**Test Procedure:**
```
User: Run /test-generate for UserController.php
```

**Expected Behavior:**
- [ ] testing-specialist spawns
- [ ] Multiple skills loaded:
  - [ ] test-scaffolding
  - [ ] test-plan-generator
  - [ ] coverage-analyzer
- [ ] Agent uses ALL skills as needed

**Verification Log:**
```
✓ Agent spawned: testing-specialist
✓ Skills referenced: test-scaffolding, test-plan-generator, coverage-analyzer
✓ All skills accessible and used
✓ Output includes: test scaffolding + test plan + coverage report
```

---

### Test 3.2.5: workflow-specialist → commit-message-generator

**Setup:** Git repo with staged changes

**Test Procedure:**
```
User: Run /pr-commit-msg
```

**Expected Behavior:**
- [ ] workflow-specialist spawns
- [ ] Skill loaded: commit-message-generator
- [ ] Agent uses skill knowledge to:
  - [ ] Analyze git diff
  - [ ] Generate conventional commit message
  - [ ] Follow commit specification

**Verification Log:**
```
✓ Agent spawned: workflow-specialist
✓ Skills referenced: commit-message-generator
✓ Skill knowledge applied: Conventional commits format used
✓ Output format: feat|fix|refactor|etc: message
```

---

### Test 3.2.6: documentation-specialist → documentation-generator

**Setup:** PHP class without docblocks

**Test Procedure:**
```
User: Run /docs-generate for the Payment class
```

**Expected Behavior:**
- [ ] documentation-specialist spawns
- [ ] Skill loaded: documentation-generator
- [ ] Agent uses skill knowledge to:
  - [ ] Generate PHPDoc/JSDoc
  - [ ] Create function documentation
  - [ ] Add usage examples

**Verification Log:**
```
✓ Agent spawned: documentation-specialist
✓ Skills referenced: documentation-generator
✓ Skill knowledge applied: Proper docblock format used
✓ Output includes: @param, @return, descriptions
```

---

### Test 3.2.7: code-quality-specialist → code-standards-checker

**Setup:** PHP file with coding standards violations

**Test Procedure:**
```
User: Run /quality-standards on UserService.php
```

**Expected Behavior:**
- [ ] code-quality-specialist spawns
- [ ] Skill loaded: code-standards-checker
- [ ] Agent uses skill knowledge to:
  - [ ] Check PHPCS/ESLint rules
  - [ ] Identify standards violations
  - [ ] Suggest fixes

**Verification Log:**
```
✓ Agent spawned: code-quality-specialist
✓ Skills referenced: code-standards-checker
✓ Skill knowledge applied: PHPCS standards referenced
✓ Output includes: Violation type, line numbers, fixes
```

---

### Test 3.2.8: live-audit-specialist → No Skills

**Setup:** Any live site

**Test Procedure:**
```
User: Run /audit-live-site https://example.com
```

**Expected Behavior:**
- [ ] live-audit-specialist spawns
- [ ] NO skills loaded (pure orchestrator)
- [ ] Agent delegates all analysis to other agents
- [ ] Skills accessed via delegated agents only

**Verification Log:**
```
✓ Agent spawned: live-audit-specialist
✓ Skills referenced: [] (empty, pure orchestrator)
✓ No skill knowledge in agent (only orchestration)
✓ All analysis done by delegated specialists
```

---

## Test 3.3: Skill Isolation Tests

### Test 3.3.1: Skills Don't Leak Between Agents

**Test Procedure:**
```
1. User: Run /audit-a11y (spawns accessibility-specialist)
2. User: Run /audit-perf (spawns performance-specialist)
```

**Expected Behavior:**
- [ ] accessibility-specialist has ONLY accessibility-checker skill
- [ ] performance-specialist has ONLY performance-analyzer skill
- [ ] No skill sharing between agents
- [ ] Each agent has isolated skill context

**Verification:**
- accessibility-specialist should NOT mention performance metrics
- performance-specialist should NOT mention WCAG criteria
- Skills are scoped per agent, not shared

---

### Test 3.3.2: Orchestrators Access Skills via Delegation Only

**Test Procedure:**
```
User: Run /audit-live-site https://example.com
```

**Expected Behavior:**
- [ ] live-audit-specialist has NO skills
- [ ] Delegates to specialists who have skills:
  - accessibility-specialist (accessibility-checker)
  - performance-specialist (performance-analyzer)
  - security-specialist (security-scanner)
  - code-quality-specialist (code-standards-checker)
- [ ] Skills accessed indirectly via delegation

**Verification:**
- Pure orchestrator never directly uses skills
- All skill usage happens in delegated specialists
- Orchestrator only synthesizes specialist outputs

---

## Test 3.4: Skill Reference Validation

### Check Agent YAML Frontmatter

**Procedure:** Verify each agent's `skills:` field matches actual skill usage

```bash
# Extract skills from agent frontmatter
for agent in agents/*/AGENT.md; do
  echo "=== $(basename $(dirname $agent)) ==="
  sed -n 's/^skills: *//p' "$agent"
done
```

**Expected Output:**
```
=== accessibility-specialist ===
accessibility-checker

=== performance-specialist ===
performance-analyzer

=== security-specialist ===
security-scanner

=== testing-specialist ===
test-scaffolding, test-plan-generator, coverage-analyzer

=== workflow-specialist ===
commit-message-generator

=== documentation-specialist ===
documentation-generator

=== code-quality-specialist ===
code-standards-checker

=== live-audit-specialist ===
[]
```

### Verification Checklist
- [ ] All leaf specialists have exactly 1 skill (except testing-specialist with 3)
- [ ] testing-specialist has exactly 3 skills
- [ ] workflow-specialist has exactly 1 skill
- [ ] live-audit-specialist has 0 skills (empty array or empty)
- [ ] No agent lists skills they don't use

---

## Summary: Skills Access Test Results

| Agent | Skill(s) | Loaded | Used | Isolated |
|-------|----------|--------|------|----------|
| accessibility-specialist | accessibility-checker | ☐ | ☐ | ☐ |
| performance-specialist | performance-analyzer | ☐ | ☐ | ☐ |
| security-specialist | security-scanner | ☐ | ☐ | ☐ |
| testing-specialist | test-*, coverage-analyzer | ☐ | ☐ | ☐ |
| workflow-specialist | commit-message-generator | ☐ | ☐ | ☐ |
| documentation-specialist | documentation-generator | ☐ | ☐ | ☐ |
| code-quality-specialist | code-standards-checker | ☐ | ☐ | ☐ |
| live-audit-specialist | (none) | N/A | N/A | N/A |

**Pass Criteria:** All checkboxes must be ✅

---

## Skill Verification Commands

### Check Skill Files Exist
```bash
ls -1 skills/*/SKILL.md | wc -l
# Expected: 9
```

### Verify Skill-Agent Mapping
```bash
# Check each skill is referenced by at least one agent
for skill in skills/*/; do
  skill_name=$(basename "$skill")
  echo -n "Checking $skill_name: "
  grep -r "$skill_name" agents/*/AGENT.md >/dev/null && echo "✓" || echo "✗"
done
```

**Expected:** All skills show ✓

---

## Common Issues & Debugging

### Skill Not Loading
- Check: Skill name in agent YAML matches skill directory name
- Check: Skill SKILL.md file exists and is valid
- Check: Agent has permission to access skill

### Skill Leaking to Main Conversation
- Check: Skill description too broad (triggers auto-activation)
- Fix: Make skill description more specific to agent context
- Example: "Invoke when accessibility-specialist agent needs..."

### Agent Can't Access Skill
- Check: Skill listed in agent's `skills:` frontmatter
- Check: Skill file path correct (skills/skill-name/SKILL.md)
- Check: YAML syntax valid in agent frontmatter

---

*Test Date: _________*
*Tester: _________*
*Results: _________*
