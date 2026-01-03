# Agent Integration Test Suite

Comprehensive runtime tests for CMS Cultivator's 8 specialist agents.

---

## Overview

These tests verify:
- ✅ Agents spawn correctly
- ✅ Agents can access their skills
- ✅ Orchestrators delegate to other agents
- ✅ Task tool works correctly
- ✅ Agent output formats are valid

---

## Test Files

### 01-leaf-specialists.md
Tests all 5 leaf specialist agents (agents that work independently):
- accessibility-specialist
- performance-specialist
- security-specialist
- documentation-specialist
- code-quality-specialist

**Focus:** Spawn verification, skill access, no delegation

---

### 02-orchestrators.md
Tests all 3 orchestrator agents (agents that delegate to others):
- workflow-specialist (conditional delegation)
- testing-specialist (conditional delegation)
- live-audit-specialist (always delegates)

**Focus:** Delegation logic, parallel execution, synthesis

---

### 03-skills-access.md
Tests agent-skill integration:
- Skills load only in agent context
- Correct skill mapping per agent
- Skill isolation between agents
- Pure orchestrators have no skills

**Focus:** Skill accessibility, scoping, isolation

---

### 04-orchestration.md
Tests delegation patterns:
- Conditional delegation (workflow, testing)
- Always-delegate pattern (live-audit)
- Parallel execution verification
- Delegation failure handling

**Focus:** Task tool usage, orchestration logic

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
- Staged git changes (for workflow tests)

---

## Test Results Tracking

### Log Format

```
[TIMESTAMP] [AGENT] [TEST] [PASS/FAIL] [NOTES]
```

### Example Log Entry

```
2026-01-02T10:30:00 accessibility-specialist spawn PASS Agent spawned successfully
2026-01-02T10:30:15 accessibility-specialist skill-access PASS Accessed accessibility-checker
2026-01-02T10:31:00 workflow-specialist orchestration PASS Delegated to testing-specialist
2026-01-02T10:31:30 live-audit-specialist parallel PASS All 4 agents spawned in parallel
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

3. **Orchestrators** (02-orchestrators.md)
   - Test delegation logic
   - Verify conditional vs. always-delegate
   - Check parallel execution

4. **Orchestration Patterns** (04-orchestration.md)
   - Deep dive into delegation
   - Test edge cases
   - Verify failure handling

5. **Output Formats** (05-output-formats.md)
   - Validate report quality
   - Check CMS-specificity
   - Score output formats

---

## Success Criteria

### Per-Agent Checklist

For each of 8 agents, verify:
- [ ] Agent spawns without errors
- [ ] Agent accesses assigned skills
- [ ] Agent produces expected output format
- [ ] Orchestrators delegate correctly (if applicable)
- [ ] No unexpected behavior

### Overall Success

- **Minimum Pass Rate:** 95% (76/80 checks)
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

# Add test files with issues
# - Missing alt text (a11y)
# - N+1 queries (perf)
# - SQL injection (security)
# - Undocumented code (docs)
# - Standards violations (quality)
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

# Add test files with issues
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
ls agents/accessibility-specialist/AGENT.md

# Check agent frontmatter
head -20 agents/accessibility-specialist/AGENT.md
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
grep "^skills:" agents/accessibility-specialist/AGENT.md
```

---

### Delegation Not Working

**Check:**
1. Agent has Task tool in frontmatter?
2. Agent is an orchestrator (not leaf specialist)?
3. Target agent exists and is valid?

**Debug:**
```bash
# Verify Task tool
grep "^tools:" agents/workflow-specialist/AGENT.md | grep Task

# Check target agents exist
ls agents/accessibility-specialist agents/security-specialist agents/testing-specialist
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
| **Agents Tested** | 8/8 | __/8 |
| **Spawn Success Rate** | 100% | __% |
| **Skill Access Rate** | 100% | __% |
| **Delegation Success** | 100% | __% |
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
   - Parallel execution timing
   - Memory usage tracking

4. **Regression Test Suite**
   - Golden output comparisons
   - Breaking change detection
   - Version compatibility tests

---

## Contributing Test Cases

To add new test cases:

1. Choose appropriate test file (01-05)
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

1. Update relevant test file (01-05)
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
- **Implementation Plan:** `AGENT_IMPLEMENTATION_PLAN.md`

---

**Happy Testing!**

For questions or issues, see the troubleshooting section or review the implementation plan.
