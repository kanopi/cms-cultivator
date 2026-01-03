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

## Agent Used

**testing-specialist** - Test generation specialist with ability to orchestrate security and accessibility testing.
