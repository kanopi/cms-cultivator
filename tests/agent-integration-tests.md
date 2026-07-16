# Agent Integration Tests

**Purpose:** Verify that agents spawn correctly, can access their skills, skill-level orchestration (the design pipeline) works, and output formats are correct.

**Note:** These are runtime integration tests that require Claude Code to be running. They cannot be automated via BATS since agents run within the Claude Code environment.

**2.0 Note:** There are no orchestrating agents — every agent is a leaf agent. The audit specialists moved to separate internal Kanopi libraries. `testing-specialist` generates security-focused and accessibility-focused test scenarios inline instead of spawning specialists.

---

## Test Prerequisites

1. Claude Code installed and configured
2. CMS Cultivator plugin enabled: `claude plugins enable cms-cultivator`
3. Test project initialized (Drupal or WordPress with git repo)
4. Figma URL or design screenshot (for design pipeline tests)

---

## Test Execution Guide

### Manual Testing

Open Claude Code in a test project and run the scenarios in the numbered test files under `tests/test-agents/`.

---

## Test Categories

### 1. Agent Spawn Tests
Verify agents can be spawned and execute correctly.

### 2. Skills Access Tests
Verify agents can access and use their assigned skills.

### 3. Orchestration Tests
Verify skill-level spawning (design pipeline) works and that no agent spawns another agent. testing-specialist must generate security/a11y scenarios inline.

### 4. Output Format Tests
Verify agent output follows expected formats.

---

## Test Results Tracking

Record results in `tests/test-agents/test-results.log`:

```
[TIMESTAMP] [AGENT] [TEST] [PASS/FAIL] [NOTES]
```

Example:
```
2026-07-16T10:30:00 documentation-specialist spawn PASS Agent spawned successfully
2026-07-16T10:30:15 documentation-specialist skill-access PASS Accessed documentation-generator skill
2026-07-16T10:31:00 design-to-wp-block-skill orchestration PASS Spawned design pipeline agents sequentially
```

---

## Detailed Test Procedures

See individual test files:
- `tests/test-agents/01-leaf-specialists.md` - Test all specialist agents (spawn, skills, no delegation)
- `tests/test-agents/03-skills-access.md` - Test skill accessibility
- `tests/test-agents/04-orchestration.md` - Test skill-level orchestration patterns
- `tests/test-agents/05-output-formats.md` - Test output validation

> `tests/test-agents/02-orchestrators.md` is a retired stub — 2.0 has no orchestrating agents.

---

## Success Criteria

For each agent:
- ✅ Agent spawns without errors
- ✅ Agent can access assigned skills
- ✅ Agent produces expected output format
- ✅ Agent does NOT spawn other agents
- ✅ Design pipeline skills spawn agents sequentially from the main session

---

## Automated Validation (Future)

Future enhancements could include:
- Claude Code test runner that spawns agents programmatically
- Output format validators
- Performance benchmarks
- Regression test suite

---

*For detailed test scenarios, see test files in `tests/test-agents/` directory.*
