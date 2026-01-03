# Agent Integration Tests

**Purpose:** Verify that agents spawn correctly, can access their skills, orchestrators delegate properly, and output formats are correct.

**Note:** These are runtime integration tests that require Claude Code to be running. They cannot be automated via BATS since agents run within the Claude Code environment.

---

## Test Prerequisites

1. Claude Code installed and configured
2. CMS Cultivator plugin enabled: `claude plugins enable cms-cultivator`
3. Test project initialized (Drupal or WordPress with git repo)
4. Git repo with staged changes (for workflow tests)

---

## Test Execution Guide

### Quick Test All Agents

```bash
# From project root with cms-cultivator enabled
cd tests/test-agents

# Run all test scenarios
./run-all-tests.sh
```

### Manual Testing

Open Claude Code in a test project and run commands from `tests/test-agents/test-scenarios.md`.

---

## Test Categories

### 1. Agent Spawn Tests
Verify agents can be spawned and execute correctly.

### 2. Skills Access Tests
Verify agents can access and use their assigned skills.

### 3. Orchestration Tests
Verify orchestrators can delegate to other agents.

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
2026-01-02T10:30:00 accessibility-specialist spawn PASS Agent spawned successfully
2026-01-02T10:30:15 accessibility-specialist skill-access PASS Accessed accessibility-checker skill
2026-01-02T10:31:00 workflow-specialist orchestration PASS Delegated to testing-specialist
```

---

## Detailed Test Procedures

See individual test files:
- `tests/test-agents/01-leaf-specialists.md` - Test leaf specialist agents
- `tests/test-agents/02-orchestrators.md` - Test orchestrator agents
- `tests/test-agents/03-skills-access.md` - Test skill accessibility
- `tests/test-agents/04-orchestration.md` - Test delegation patterns
- `tests/test-agents/05-output-formats.md` - Test output validation

---

## Success Criteria

For each agent:
- ✅ Agent spawns without errors
- ✅ Agent can access assigned skills
- ✅ Agent produces expected output format
- ✅ Orchestrators successfully delegate to other agents
- ✅ Parallel execution works for orchestrators

---

## Automated Validation (Future)

Future enhancements could include:
- Claude Code test runner that spawns agents programmatically
- Output format validators
- Performance benchmarks
- Regression test suite

---

*For detailed test scenarios, see test files in `tests/test-agents/` directory.*
