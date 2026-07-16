# Agent Integration Test Suite

Comprehensive runtime tests for CMS Cultivator's specialist agents.

> **2.0 Note:** As of 2.0 there are no orchestrating agents — every agent is a
> leaf agent. The audit specialists (accessibility, performance, security, code
> quality, structured data, GTM, DevOps) moved to separate internal Kanopi
> libraries, along with their audit skills. `testing-specialist` generates
> security-focused and accessibility-focused test scenarios inline instead of
> spawning specialists.

---

## Overview

These tests verify:
- ✅ Agents spawn correctly
- ✅ Agents can access their skills
- ✅ Skill-level orchestration (design pipeline) works correctly
- ✅ No agent spawns other agents
- ✅ Agent output formats are valid

---

## Test Files

### 01-leaf-specialists.md
Tests all specialist agents (every agent is a leaf agent in 2.0):
- documentation-specialist
- testing-specialist
- design-specialist
- responsive-styling-specialist
- browser-validator-specialist
- drupalorg-issue-specialist
- drupalorg-mr-specialist

**Focus:** Spawn verification, skill access, no delegation

---

### 02-orchestrators.md
Retired stub — 2.0 has no orchestrating agents. Kept only so historical links
resolve; it points to the current tests in 01 and 04.

---

### 03-skills-access.md
Tests agent-skill integration:
- Skills load only in agent context
- Correct skill mapping per agent
- Skill isolation between agents

**Focus:** Skill accessibility, scoping, isolation

---

### 04-orchestration.md
Tests skill-level orchestration patterns:
- No agent has the Task tool
- Inline scenario generation (testing-specialist)
- Design pipeline sequential spawning (design skills spawn design-specialist,
  then responsive-styling-specialist and browser-validator-specialist from the
  main session)
- Spawn failure handling

**Focus:** Skill-level spawning, inline analysis, no recursive spawning

---

### 05-output-formats.md
Tests agent output quality:
- Report structure standards
- CMS-specific guidance
- Code examples (before/after)
- Prioritization and severity
- Professional formatting

**Focus:** Output validation, quality scoring

---

## Quick Start

### Run All Tests Manually

1. Open Claude Code in a test project
2. Run through test scenarios in each file
3. Check off verification checklists
4. Record results in test-results.log

### Prerequisites

- Claude Code installed
- CMS Cultivator plugin enabled
- Test project (Drupal or WordPress with git)
- Figma URL or design screenshot (for design pipeline tests)

---

## Test Results Tracking

### Log Format

```
[TIMESTAMP] [AGENT] [TEST] [PASS/FAIL] [NOTES]
```

### Example Log Entry

```
2026-07-16T10:30:00 documentation-specialist spawn PASS Agent spawned successfully
2026-07-16T10:30:15 documentation-specialist skill-access PASS Accessed documentation-generator
2026-07-16T10:31:00 testing-specialist inline-scenarios PASS Security + a11y scenarios generated inline
2026-07-16T10:32:00 design-to-wp-block-skill orchestration PASS Spawned pipeline agents sequentially
```

### Create Log File

```bash
touch test-results.log
```

---

## Test Execution Order

Recommended order for systematic testing:

1. **Leaf Specialists First** (01-leaf-specialists.md)
   - Verify basic agent spawning works
   - Confirm skill access working
   - Establish baseline functionality

2. **Skills Access** (03-skills-access.md)
   - Verify skill-agent mapping
   - Confirm skill isolation
   - Check skill loading behavior

3. **Orchestration Patterns** (04-orchestration.md)
   - Verify no agent spawns agents
   - Test inline scenario generation
   - Test design pipeline sequential spawning

4. **Output Formats** (05-output-formats.md)
   - Validate report quality
   - Check CMS-specificity
   - Score output formats

---

## Success Criteria

### Per-Agent Checklist

For each agent, verify:
- [ ] Agent spawns without errors
- [ ] Agent accesses assigned skills
- [ ] Agent produces expected output format
- [ ] Agent does NOT spawn other agents
- [ ] No unexpected behavior

### Overall Success

- **Minimum Pass Rate:** 95%
- **Critical Tests:** 100% (all agent spawn tests must pass)
- **Output Quality:** ≥32/40 per agent (80% quality score)

---

## Common Test Setup

### Drupal Test Project

```bash
# Create test Drupal project
composer create-project drupal/recommended-project test-drupal
cd test-drupal
git init
git add .
git commit -m "Initial commit"

# Enable plugin
claude plugins enable cms-cultivator

# Add test material
# - Undocumented code (docs)
# - New feature code without tests (testing)
# - Design mockup or Figma URL (design pipeline)
# - Contributed module checkout (drupal.org workflows)
```

### WordPress Test Project

```bash
# Create test WordPress project
composer create-project roots/bedrock test-wordpress
cd test-wordpress
git init
git add .
git commit -m "Initial commit"

# Enable plugin
claude plugins enable cms-cultivator

# Add test material (undocumented code, untested code, design mockup)
```

---

## Troubleshooting

### Agent Doesn't Spawn

**Check:**
1. Plugin enabled? `claude plugins list`
2. Command file exists in `commands/`?
3. Task tool in allowed-tools frontmatter?
4. Agent directory exists in `agents/`?

**Debug:**
```bash
# Verify agent exists
ls agents/documentation-specialist/AGENT.md

# Check agent frontmatter
head -20 agents/documentation-specialist/AGENT.md
```

---

### Skill Not Accessible

**Check:**
1. Skill referenced in agent frontmatter?
2. Skill file exists?
3. Skill name matches exactly?

**Debug:**
```bash
# List all skills
ls -1 skills/*/SKILL.md

# Check agent skill reference
grep "^skills:" agents/documentation-specialist/AGENT.md
```

---

### Agent Attempts to Spawn Another Agent

**Check:**
1. Agent frontmatter should NOT list Task in tools
2. AGENT.md prose should describe inline analysis, not delegation

**Debug:**
```bash
# Must return no matches
grep -l "^tools:.*Task" agents/*/AGENT.md
```

---

### Output Format Issues

**Check:**
1. Agent following output guidelines?
2. CMS-specific guidance included?
3. File paths and line numbers present?
4. Before/after code examples?

**Review:** Compare against examples in `05-output-formats.md`

---

## Test Metrics

Track these metrics across all tests:

| Metric | Target | Actual |
|--------|--------|--------|
| **Agents Tested** | All | __ |
| **Spawn Success Rate** | 100% | __% |
| **Skill Access Rate** | 100% | __% |
| **No-Delegation Rate** | 100% | __% |
| **Output Quality Score** | ≥32/40 | __/40 |
| **Overall Pass Rate** | ≥95% | __% |

---

## Automated Testing (Future)

Future enhancements could include:

1. **Claude Code Test Runner**
   - Programmatic agent spawning
   - Automated output validation
   - Continuous integration

2. **Output Format Validators**
   - JSON schema validation
   - Markdown linting
   - Structure verification

3. **Performance Benchmarks**
   - Agent spawn time
   - Pipeline execution timing
   - Memory usage tracking

4. **Regression Test Suite**
   - Golden output comparisons
   - Breaking change detection
   - Version compatibility tests

---

## Contributing Test Cases

To add new test cases:

1. Choose appropriate test file (01, 03, 04, or 05)
2. Follow existing format
3. Include:
   - Setup instructions
   - Test procedure
   - Expected behavior
   - Verification checklist
   - Output format example
4. Add to summary checklist
5. Update README

---

## Test Maintenance

### When to Update Tests

- New agent added
- Agent behavior changes
- New skill added
- Output format changes
- Bug fixes affecting agents

### How to Update

1. Update relevant test file (01, 03, 04, or 05)
2. Update verification checklists
3. Update expected output examples
4. Re-run affected tests
5. Update pass criteria if needed

---

## Resources

- **Main Testing Guide:** `tests/agent-integration-tests.md`
- **BATS Unit Tests:** `tests/test-plugin.bats`
- **Agent Documentation:** `agents/*/AGENT.md`
- **Skill Documentation:** `skills/*/SKILL.md`

---

**Happy Testing!**

For questions or issues, see the troubleshooting section.
