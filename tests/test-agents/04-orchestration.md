# Test 04: Skill-Level Orchestration Patterns

**Category:** Orchestration
**Purpose:** Verify that skill-level spawning works correctly and agents do NOT attempt to spawn subagents
**Focus:** Skill-level sequential spawning, inline scenario generation, no recursive agent spawning

---

## Background: Claude Code Orchestration Model

In Claude Code, only the **main session** can spawn agents. Agents CANNOT spawn further agents
(the `Agent` tool is not available to spawned subagents). As of 2.0 there are **no orchestrating
agents** in CMS Cultivator — every agent is a leaf agent. Orchestration happens at the skill level:

- **Skill-level spawning**: Skills in the main session spawn agents sequentially (design pipeline)
- **Inline analysis**: The `testing-specialist` agent generates security-focused and
  accessibility-focused test scenarios inline using its own tools — it no longer has the Task
  tool and does not coordinate with other specialists
- **No recursive spawning**: No agent spawns another agent

---

## Test 4.1: Tool Configuration Verification

### Test 4.1.1: No Agent Has the Task Tool

**Check Agent Frontmatter:**
```bash
# Should return NO matches — no agent may list Task in its tools
grep -l "^tools:.*Task" agents/*/AGENT.md
```

**Expected Output:** (empty)

**Note:** The `tools:` frontmatter line controls what the agent THINKS it has, but Claude Code
does not make the `Agent` spawning tool available to subagents regardless. Also verify that
agents do not attempt to use Task for spawning — check their AGENT.md prose for spawning
instructions.

**Verification:**
- [ ] No agent lists Task in its tools frontmatter
- [ ] testing-specialist AGENT.md describes inline scenario generation (not Task spawning)
- [ ] design-specialist AGENT.md describes code generation only (not spawning)
- [ ] No AGENT.md prose instructs the agent to spawn other agents

---

## Test 4.2: Testing Specialist Inline Scenario Generation

### Test 4.2.1: Security-Sensitive Code

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
- [ ] Security test scenarios generated inline (NOT via spawning another agent)
- [ ] Both standard and security test scenarios in final output

---

### Test 4.2.2: UI Component Code

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
- [ ] Accessibility test scenarios generated inline (NOT via spawning another agent)
- [ ] Keyboard and screen reader test coverage included

---

### Test 4.2.3: Simple Utility Function

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

## Test 4.3: Design Skill Sequential Spawning

### Test 4.3.1: Design-to-WP-Block Sequential Flow

**Setup:** Figma URL or design screenshot

**Test Procedure:**
```
User: Run /design-to-wp-block [figma-url]
```

**Expected Sequential Pattern (spawned by the invoking SKILL in the main session, not by an agent):**
```
Step 1: Skill spawns design-specialist (code generation)
         └─→ Returns structured output: file paths, SCSS paths, design specs, test URL

Step 2: Skill spawns responsive-styling-specialist
         └─→ Uses SCSS paths + design specs from Step 1

Step 3: Skill spawns browser-validator-specialist
         └─→ Uses test URL from Step 1
```

**Verification Checklist:**
- [ ] design-specialist spawned first
- [ ] design-specialist returns structured output with SCSS paths and test URL
- [ ] responsive-styling-specialist spawned by the skill after Step 1 completes
- [ ] browser-validator-specialist spawned by the skill after Step 1 completes
- [ ] Steps 2 and 3 use output from Step 1 (not hardcoded paths)
- [ ] design-specialist itself does NOT spawn the follow-up agents

**Note:** The same flow applies to `/design-to-drupal-paragraph`.

---

## Test 4.4: Spawn Failure Handling

### Test 4.4.1: Pipeline Agent Not Available

**Scenario:** What if a spawned agent in the design pipeline fails to start?

**Test Setup:**
```
Temporarily rename agents/browser-validator-specialist directory
Run /design-to-wp-block [figma-url]
```

**Expected Behavior:**
- [ ] Skill attempts to spawn browser-validator-specialist (Step 3)
- [ ] Spawn fails (agent not found)
- [ ] Main session handles error gracefully
- [ ] Steps 1 and 2 output still delivered
- [ ] Skill notes that browser validation was skipped

---

## Summary: Orchestration Test Results

| Pattern | Test | Passed | Notes |
|---------|------|--------|-------|
| no agent has Task tool | Frontmatter check | ☐ | grep must return empty |
| testing → inline scenarios | Security code | ☐ | Generates scenarios inline |
| testing → inline scenarios | UI code | ☐ | Generates scenarios inline |
| testing → no scenarios | Utility code | ☐ | Should NOT generate extra scenarios |
| design skill → sequential | Figma design | ☐ | Skill spawns pipeline agents in sequence |
| design skill → failure handling | Missing agent | ☐ | Graceful degradation |

**Pass Criteria:** All checkboxes must be ✅

---

## Orchestration Architecture Diagram

```
MAIN SESSION (Can Spawn Agents)
==========================================================================

design-to-wp-block / design-to-drupal-paragraph skills
    ├── Step 1: Spawns design-specialist (code generation)
    ├── Step 2: Spawns responsive-styling-specialist (SCSS)
    └── Step 3: Spawns browser-validator-specialist (validation)

test-generate / test-plan / test-coverage skills
    └── Spawns testing-specialist (inline scenario generation, no subagent spawning)

pr-create / pr-review / pr-release / commit-message-generator skills
    └── Run directly in the main session (no agent spawned)


AGENTS (All Leaf — Cannot Spawn Further Agents)
==========================================================================

testing-specialist
    ├── Scenario generation: INLINE (security + accessibility scenarios)
    └── Pattern: Analyze code → tests → inline security/a11y scenarios

design-specialist
    ├── Spawning: NONE (code generation only)
    └── Pattern: Analyze design → generate files → return structured output

responsive-styling-specialist
    └── Pattern: Consume design specs → generate mobile-first SCSS

browser-validator-specialist
    └── Pattern: Load test URL → validate breakpoints + WCAG AA → report

documentation-specialist / drupalorg-issue-specialist / drupalorg-mr-specialist
    └── Pattern: Direct execution only
```

---

## Common Issues & Debugging

### Agent Tries to Spawn Another Agent
- Check: Does the agent's AGENT.md prose describe spawning/delegation?
- Fix: Update AGENT.md to describe inline analysis instead
- Note: Even if Task appears in tools frontmatter, the Agent spawn tool is unavailable to subagents in Claude Code

### Design Pipeline Runs Out of Order
- Check: Skill SKILL.md specifies sequential steps with Step 1 output feeding Steps 2 and 3?
- Fix: Steps 2 and 3 must consume design-specialist's structured output

### Over-Analysis
- Check: testing-specialist logic too broad (generating security/a11y scenarios unnecessarily)?
- Fix: Add conditional logic — only generate scenarios when code type warrants it

---

*Test Date: _________*
*Tester: _________*
*Results: _________*
