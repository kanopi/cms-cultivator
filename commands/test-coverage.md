---
description: Analyze test coverage and identify untested code paths using testing specialist
argument-hint: "[path]"
allowed-tools: Task
---

Spawn the **testing-specialist** agent using:

```
Task(cms-cultivator:testing-specialist:testing-specialist,
     prompt="Analyze test coverage and identify gaps. Path: [use argument if provided, otherwise 'entire codebase']. Analyze existing tests, identify untested code, calculate coverage metrics, prioritize testing gaps, and generate test recommendations for uncovered code.")
```

The testing specialist will:
1. **Analyze existing tests** - Review PHPUnit, Jest, Cypress tests
2. **Identify untested code** - Functions, classes, branches without coverage
3. **Calculate coverage metrics** - Line coverage, branch coverage, function coverage
4. **Prioritize testing gaps** - Critical paths, security-sensitive code, public APIs
5. **Generate test recommendations** - Specific tests needed for uncovered code

**Coverage types**: `unit`, `integration`, `e2e`, `critical-paths`

---

## Tool Usage

**Allowed operations:**
- ✅ Spawn testing-specialist agent
- ✅ Analyze existing test files (PHPUnit, Jest, Cypress)
- ✅ Run test coverage tools (PHPUnit --coverage, Jest --coverage)
- ✅ Calculate coverage metrics (line, branch, function coverage)
- ✅ Identify untested code paths
- ✅ Generate prioritized test recommendations

**Not allowed:**
- ❌ Do not write test files (use /test-generate for that)
- ❌ Do not modify existing tests
- ❌ Do not commit changes

The testing-specialist agent performs all coverage analysis operations.

---

## Agent Used

**testing-specialist** - Coverage analysis specialist with gap identification and test recommendation capabilities.
