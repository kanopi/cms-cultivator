---
description: Generate test scaffolding (unit, integration, e2e) using testing specialist
argument-hint: "[test-type]"
allowed-tools: Task
---

Spawn the **testing-specialist** agent using:

```
Task(cms-cultivator:testing-specialist:testing-specialist,
     prompt="Generate comprehensive test scaffolding. Test type: [use argument if provided, otherwise 'all types']. Analyze code to test, generate test files (PHPUnit/Jest/Cypress), create test cases, and delegate to security-specialist and accessibility-specialist for specialized test scenarios when needed.")
```

The testing specialist will:
1. **Analyze code to test** - Identify functions, classes, and components needing coverage
2. **Generate test files** - PHPUnit (PHP), Jest (JavaScript), Cypress (E2E)
3. **Create test cases** - Unit tests, integration tests, edge cases
4. **Delegate for specialized tests**:
   - Spawn **security-specialist** for security-focused test scenarios
   - Spawn **accessibility-specialist** for a11y test scenarios
5. **Follow CMS patterns** - Drupal kernel tests, WordPress test frameworks

**Test types**: `unit`, `integration`, `e2e`, `security`, `accessibility`

---

## Tool Usage

**Allowed operations:**
- ✅ Spawn testing-specialist agent
- ✅ Agent spawns security-specialist for security test scenarios
- ✅ Agent spawns accessibility-specialist for a11y test scenarios
- ✅ Generate test files (PHPUnit, Jest, Cypress)
- ✅ Create test cases (unit, integration, e2e)
- ✅ Write test scaffolding with descriptive test names

**Not allowed:**
- ❌ Do not modify existing test files
- ❌ Do not run tests (provide instructions to run tests)
- ❌ Do not commit generated tests (provide for review)

The testing-specialist agent performs all test generation operations and orchestrates specialized testing agents.

---

## Agent Used

**testing-specialist** - Test generation specialist with ability to orchestrate security and accessibility testing.
