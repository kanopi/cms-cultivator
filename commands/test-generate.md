---
description: Generate test scaffolding (unit, integration, e2e, cypress tests)
argument-hint: [test-type]
allowed-tools: Read, Glob, Grep, Write
---

# Generate Test Scaffolding

Generate test scaffolding and boilerplate for PHPUnit, Jest, and Cypress tests.

## Quick Start

```bash
# Generate tests for all untested code
/test-generate

# Generate specific test types
/test-generate unit         # PHPUnit unit tests
/test-generate integration  # Integration tests
/test-generate e2e          # Cypress E2E tests
/test-generate data         # Test fixtures and data
```

## How It Works

This command uses the **test-scaffolding** Agent Skill to generate test boilerplate.

**For complete test templates and examples**, see:
→ [`skills/test-scaffolding/SKILL.md`](../skills/test-scaffolding/SKILL.md)

The skill provides detailed instructions for:
- Analyzing code to test (classes, methods, dependencies)
- Generating PHPUnit tests (Drupal/WordPress)
- Generating JavaScript tests (Jest)
- Generating Cypress E2E tests
- Creating test fixtures and mock data

## When to Use

**Use this command (`/test-generate`)** when:
- ✅ Need tests for entire module or feature
- ✅ Batch test generation across multiple files
- ✅ Setting up test suite for new project
- ✅ Comprehensive test coverage needed

**The skill auto-activates** when you say:
- "I need tests for this class"
- "How do I test this function?"
- "This code has no tests"

## Test Types

### Unit Tests
Test individual functions/methods in isolation
- **Drupal**: Kernel tests, Unit tests
- **WordPress**: WP_UnitTestCase
- **JavaScript**: Jest

### Integration Tests
Test how components work together
- **Drupal**: Functional tests, JavaScript tests
- **WordPress**: WP REST API tests
- **JavaScript**: Component integration tests

### E2E Tests
Test complete user workflows
- **Cypress**: Full browser automation
- Login flows, form submissions, navigation
- Admin interface testing

## Example: PHPUnit Test Generated

**For this service**:
```php
class DataProcessor {
  public function processData(array $data): array {
    // Implementation
  }
}
```

**Generates this test**:
```php
class DataProcessorTest extends UnitTestCase {
  protected $dataProcessor;

  protected function setUp(): void {
    parent::setUp();
    $this->dataProcessor = new DataProcessor();
  }

  /**
   * Test processData with valid input.
   */
  public function testProcessDataWithValidInput(): void {
    $input = ['name' => 'John'];
    $result = $this->dataProcessor->processData($input);

    $this->assertIsArray($result);
    $this->assertEquals('John', $result['name']);
  }

  /**
   * Test processData with invalid input.
   */
  public function testProcessDataWithInvalidInput(): void {
    $this->expectException(\InvalidArgumentException::class);
    $this->dataProcessor->processData([]);
  }
}
```

## What Gets Generated

### For Each Method
- ✅ Happy path test (valid input)
- ✅ Error case tests (invalid input)
- ✅ Edge case tests (empty, null, boundaries)
- ✅ Proper mocking for dependencies
- ✅ Setup and teardown methods

### Best Practices Included
- Descriptive test names
- One assertion per test (where appropriate)
- Arrange-Act-Assert pattern
- Independent tests (no dependencies)
- Proper cleanup in tearDown()

## Related Commands

- **[`/test-coverage`](test-coverage.md)** - Analyze test coverage gaps
- **[`/test-plan`](test-plan.md)** - Generate QA test plan
- **[`/quality-standards`](quality-standards.md)** - Check code standards

## Resources

- [PHPUnit Documentation](https://phpunit.de/)
- [Drupal Testing Guide](https://www.drupal.org/docs/testing)
- [WordPress PHPUnit](https://make.wordpress.org/core/handbook/testing/automated-testing/phpunit/)
- [Cypress Documentation](https://docs.cypress.io/)
- [test-scaffolding Agent Skill](../skills/test-scaffolding/SKILL.md)
