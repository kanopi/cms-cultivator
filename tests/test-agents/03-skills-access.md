# Test 03: Skills Access Verification

**Category:** Agent-Skill Integration
**Purpose:** Verify agents can access their assigned skills
**Expected Behavior:** Skills load only when agent uses them, not globally

> **Note:** As of 2.0, every agent is a leaf agent with directly assigned
> skills — there are no pure orchestrators without skills. The audit
> specialists and their skills moved to separate internal Kanopi libraries.

---

## Test 3.1: Skill Loading Behavior

### Test 3.1.1: Skills Load Only in Agent Context

**Hypothesis:** Skills should only be accessible within agent execution, not globally in Claude Code

**Test Procedure:**
```
1. User: Ask Claude about documentation practices in normal conversation
2. User: Run /docs-generate command
```

**Expected Behavior:**
- [ ] In normal conversation: documentation-generator skill does NOT auto-activate
- [ ] When /docs-generate runs: documentation-specialist spawns and skill loads
- [ ] Skill is scoped to agent, not main conversation

**Verification:**
- Skills should only activate when explicitly triggered by agents
- Main conversation should NOT see skill prompts unless skill description triggers it

---

## Test 3.2: Agent-Skill Mapping Verification

### Test 3.2.1: documentation-specialist → documentation-generator

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

### Test 3.2.2: testing-specialist → Multiple Skills

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
- [ ] Security-focused and accessibility-focused scenarios generated inline (no other agent spawned)

**Verification Log:**
```
✓ Agent spawned: testing-specialist
✓ Skills referenced: test-scaffolding, test-plan-generator, coverage-analyzer
✓ All skills accessible and used
✓ Output includes: test scaffolding + test plan + coverage report
```

---

### Test 3.2.3: design-specialist → Design Skills

**Setup:** Figma URL or design mockup

**Test Procedure:**
```
User: Run /design-to-wp-block [figma-url]
```

**Expected Behavior:**
- [ ] design-specialist spawns
- [ ] Design skills loaded (design-analyzer, responsive-styling, design-to-wp-block, design-to-drupal-paragraph)
- [ ] Agent uses skill knowledge to:
  - [ ] Extract design specs (colors, typography, spacing)
  - [ ] Generate CMS-specific code (block pattern or paragraph type)
  - [ ] Return structured output for the follow-up pipeline steps

**Verification Log:**
```
✓ Agent spawned: design-specialist
✓ Skills referenced: design-analyzer, design-to-wp-block / design-to-drupal-paragraph
✓ Skill knowledge applied: exact design values extracted
✓ Output format matches skill specification (structured file paths + specs)
```

---

### Test 3.2.4: responsive-styling-specialist → responsive-styling

**Setup:** Component markup needing styles

**Test Procedure:**
```
User: Generate mobile-first responsive SCSS for the card component
```

**Expected Behavior:**
- [ ] responsive-styling-specialist spawns
- [ ] Skill loaded: responsive-styling
- [ ] Agent uses skill knowledge to:
  - [ ] Apply mobile-first breakpoints (768px, 1024px)
  - [ ] Enforce WCAG AA contrast and 44px touch targets
  - [ ] Add focus indicators and reduced motion support

**Verification Log:**
```
✓ Agent spawned: responsive-styling-specialist
✓ Skills referenced: responsive-styling
✓ Skill knowledge applied: mobile-first breakpoints used
✓ Output format matches skill specification
```

---

### Test 3.2.5: browser-validator-specialist → browser-validator

**Setup:** Implemented component reachable at a test URL

**Test Procedure:**
```
User: Test this component in the browser
```

**Expected Behavior:**
- [ ] browser-validator-specialist spawns
- [ ] Skill loaded: browser-validator
- [ ] Agent uses skill knowledge to:
  - [ ] Test breakpoints (320px, 768px, 1024px)
  - [ ] Run WCAG AA checks (contrast, keyboard, ARIA)
  - [ ] Report console errors and remediation steps

**Verification Log:**
```
✓ Agent spawned: browser-validator-specialist
✓ Skills referenced: browser-validator
✓ Skill knowledge applied: breakpoint matrix tested
✓ Output format matches skill specification
```

---

### Test 3.2.6: drupalorg-issue-specialist → Issue Skills

**Setup:** Contributed Drupal module with a bug to report

**Test Procedure:**
```
User: Help me create a drupal.org issue for this bug
```

**Expected Behavior:**
- [ ] drupalorg-issue-specialist spawns
- [ ] Skills loaded: drupalorg-issue-helper, drupal-issue
- [ ] Agent uses skill knowledge to:
  - [ ] Structure the issue per drupal.org conventions
  - [ ] Include required sections (summary, steps to reproduce, proposed resolution)

**Verification Log:**
```
✓ Agent spawned: drupalorg-issue-specialist
✓ Skills referenced: drupalorg-issue-helper, drupal-issue
✓ Skill knowledge applied: drupal.org issue template followed
✓ Output format matches skill specification
```

---

### Test 3.2.7: drupalorg-mr-specialist → Contribution Skills

**Setup:** Local fix for a contributed Drupal project

**Test Procedure:**
```
User: Create a merge request for this fix on drupal.org
```

**Expected Behavior:**
- [ ] drupalorg-mr-specialist spawns
- [ ] Skills loaded: drupalorg-contribution-helper, drupal-mr
- [ ] Agent uses skill knowledge to:
  - [ ] Use correct issue-fork branch naming
  - [ ] Provide git.drupalcode.org commands
  - [ ] Flag the manual issue-fork creation step

**Verification Log:**
```
✓ Agent spawned: drupalorg-mr-specialist
✓ Skills referenced: drupalorg-contribution-helper, drupal-mr
✓ Skill knowledge applied: drupal.org MR workflow followed
✓ Output format matches skill specification
```

---

## Test 3.3: Skill Isolation Tests

### Test 3.3.1: Skills Don't Leak Between Agents

**Test Procedure:**
```
1. User: Run /docs-generate (spawns documentation-specialist)
2. User: Run /test-generate (spawns testing-specialist)
```

**Expected Behavior:**
- [ ] documentation-specialist has ONLY its documentation skill
- [ ] testing-specialist has ONLY its testing skills
- [ ] No skill sharing between agents
- [ ] Each agent has isolated skill context

**Verification:**
- documentation-specialist should NOT produce test scaffolding
- testing-specialist should NOT produce API documentation
- Skills are scoped per agent, not shared

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

**Dynamic parity check — every referenced skill must exist:**

```bash
for agent in agents/*/AGENT.md; do
  name=$(basename $(dirname "$agent"))
  for skill in $(sed -n 's/^skills: *//p' "$agent" | tr -d ',' ); do
    [ -f "skills/$skill/SKILL.md" ] \
      && echo "✓ $name → $skill" \
      || echo "✗ $name → $skill (MISSING)"
  done
done
```

### Verification Checklist
- [ ] Every agent lists at least one skill
- [ ] Every skill referenced in agent frontmatter exists in `skills/`
- [ ] No agent lists skills it doesn't use
- [ ] Frontmatter mappings match the tables in this file

---

## Summary: Skills Access Test Results

| Agent | Skill(s) | Loaded | Used | Isolated |
|-------|----------|--------|------|----------|
| documentation-specialist | documentation-generator | ☐ | ☐ | ☐ |
| testing-specialist | test-*, coverage-analyzer | ☐ | ☐ | ☐ |
| design-specialist | design-analyzer, design-to-* | ☐ | ☐ | ☐ |
| responsive-styling-specialist | responsive-styling | ☐ | ☐ | ☐ |
| browser-validator-specialist | browser-validator | ☐ | ☐ | ☐ |
| drupalorg-issue-specialist | drupalorg-issue-helper, drupal-issue | ☐ | ☐ | ☐ |
| drupalorg-mr-specialist | drupalorg-contribution-helper, drupal-mr | ☐ | ☐ | ☐ |

**Pass Criteria:** All checkboxes must be ✅

---

## Common Issues & Debugging

### Skill Not Loading
- Check: Skill name in agent YAML matches skill directory name
- Check: Skill SKILL.md file exists and is valid
- Check: Agent has permission to access skill

### Skill Leaking to Main Conversation
- Check: Skill description too broad (triggers auto-activation)
- Fix: Make skill description more specific to agent context
- Example: "Invoke when documentation-specialist agent needs..."

### Agent Can't Access Skill
- Check: Skill listed in agent's `skills:` frontmatter
- Check: Skill file path correct (skills/skill-name/SKILL.md)
- Check: YAML syntax valid in agent frontmatter

---

*Test Date: _________*
*Tester: _________*
*Results: _________*
