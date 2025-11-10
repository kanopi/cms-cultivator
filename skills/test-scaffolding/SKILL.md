---
name: test-scaffolding
description: Automatically generate test scaffolding when user writes new code without tests or mentions needing tests. Supports unit, integration, e2e, and data tests for PHP and JavaScript. Invoke when user mentions "tests", "testing", "coverage", "write tests", or shows new untested code.
---

# Test Scaffolding Generator

Automatically generate test scaffolding for untested code.

## When to Use This Skill

Activate this skill when the user:
- Shows new code and says "I need tests for this"
- Asks "how do I test this?"
- Mentions "no tests yet" or "untested code"
- Says "I should write tests" or "need test coverage"
- Shows a class/function and asks about testing
- Mentions specific test types: "unit test", "integration test", "e2e test"

## Workflow

### 1. Analyze the Code to Test

**Identify**:
- Class name and namespace
- Methods to test (public methods)
- Dependencies (constructor parameters)
- Return types
- Drupal vs WordPress context

### 2. Determine Test Type

**Unit Tests** - For isolated logic:
- Services with minimal dependencies
- Utility functions
- Data transformation
- Business logic

**Integration Tests** - For component interaction:
- Controllers with database
- Form handlers
- API endpoints
- Complex workflows

**E2E Tests** - For user workflows:
- Login/authentication
- Multi-step forms
- Content creation
- Admin interfaces

### 3. Generate Appropriate Test Scaffold

## Unit Test Templates

### Drupal PHPUnit Unit Test

```php
<?php

namespace Drupal\Tests\mymodule\Unit;

use Drupal\Tests\UnitTestCase;
use Drupal\mymodule\Service\DataProcessor;

/**
 * Tests for DataProcessor service.
 *
 * @group mymodule
 * @coversDefaultClass \Drupal\mymodule\Service\DataProcessor
 */
class DataProcessorTest extends UnitTestCase {

  /**
   * The data processor service.
   *
   * @var \Drupal\mymodule\Service\DataProcessor
   */
  protected $dataProcessor;

  /**
   * {@inheritdoc}
   */
  protected function setUp(): void {
    parent::setUp();
    $this->dataProcessor = new DataProcessor();
  }

  /**
   * Test processData method with valid input.
   *
   * @covers ::processData
   */
  public function testProcessDataWithValidInput(): void {
    $input = ['name' => 'John', 'email' => 'john@example.com'];
    $result = $this->dataProcessor->processData($input);

    $this->assertIsArray($result);
    $this->assertEquals('John', $result['name']);
    $this->assertEquals('john@example.com', $result['email']);
  }

  /**
   * Test processData method with invalid input.
   *
   * @covers ::processData
   */
  public function testProcessDataWithInvalidInput(): void {
    $this->expectException(\InvalidArgumentException::class);
    $this->dataProcessor->processData([]);
  }

}
```

### WordPress PHPUnit Test

```php
<?php
/**
 * Tests for User_Manager class.
 *
 * @package MyPlugin\Tests
 */

namespace MyPlugin\Tests;

use WP_UnitTestCase;
use MyPlugin\User_Manager;

/**
 * User_Manager test case.
 */
class Test_User_Manager extends WP_UnitTestCase {

	/**
	 * User manager instance.
	 *
	 * @var User_Manager
	 */
	private $user_manager;

	/**
	 * Set up test.
	 */
	public function setUp(): void {
		parent::setUp();
		$this->user_manager = new User_Manager();
	}

	/**
	 * Test get_user_data with valid user.
	 */
	public function test_get_user_data_with_valid_user() {
		$user_id = $this->factory->user->create(
			array(
				'user_login' => 'testuser',
				'user_email' => 'test@example.com',
			)
		);

		$data = $this->user_manager->get_user_data( $user_id );

		$this->assertIsArray( $data );
		$this->assertEquals( 'testuser', $data['login'] );
		$this->assertEquals( 'test@example.com', $data['email'] );
	}

	/**
	 * Test get_user_data with invalid user.
	 */
	public function test_get_user_data_with_invalid_user() {
		$data = $this->user_manager->get_user_data( 99999 );
		$this->assertFalse( $data );
	}

	/**
	 * Clean up test.
	 */
	public function tearDown(): void {
		parent::tearDown();
	}

}
```

### JavaScript Unit Test (Jest)

```javascript
/**
 * Tests for userUtils module.
 */

import { formatUserName, validateEmail } from './userUtils';

describe('userUtils', () => {
  describe('formatUserName', () => {
    test('formats first and last name correctly', () => {
      const result = formatUserName({ firstName: 'John', lastName: 'Doe' });
      expect(result).toBe('John Doe');
    });

    test('handles missing last name', () => {
      const result = formatUserName({ firstName: 'John' });
      expect(result).toBe('John');
    });

    test('throws error for missing first name', () => {
      expect(() => formatUserName({})).toThrow('First name required');
    });
  });

  describe('validateEmail', () => {
    test('validates correct email', () => {
      expect(validateEmail('test@example.com')).toBe(true);
    });

    test('rejects invalid email', () => {
      expect(validateEmail('not-an-email')).toBe(false);
    });
  });
});
```

## Integration Test Templates

### Drupal Functional Test

```php
<?php

namespace Drupal\Tests\mymodule\Functional;

use Drupal\Tests\BrowserTestBase;

/**
 * Tests the user registration form.
 *
 * @group mymodule
 */
class UserRegistrationFormTest extends BrowserTestBase {

  /**
   * {@inheritdoc}
   */
  protected $defaultTheme = 'stark';

  /**
   * {@inheritdoc}
   */
  protected static $modules = ['mymodule', 'user'];

  /**
   * Test user can register successfully.
   */
  public function testUserRegistration(): void {
    $this->drupalGet('/user/register');
    $this->assertSession()->statusCodeEquals(200);
    $this->assertSession()->pageTextContains('Create new account');

    $edit = [
      'name' => 'testuser',
      'mail' => 'test@example.com',
    ];
    $this->submitForm($edit, 'Create new account');

    $this->assertSession()->pageTextContains('Registration successful');
  }

}
```

### WordPress Integration Test

```php
<?php
/**
 * Tests for REST API endpoints.
 *
 * @package MyPlugin\Tests
 */

namespace MyPlugin\Tests;

use WP_UnitTestCase;

/**
 * REST API test case.
 */
class Test_REST_API extends WP_UnitTestCase {

	/**
	 * Test GET /wp-json/myplugin/v1/users endpoint.
	 */
	public function test_get_users_endpoint() {
		// Create test user.
		$user_id = $this->factory->user->create();

		// Make REST request.
		$request  = new \WP_REST_Request( 'GET', '/myplugin/v1/users' );
		$response = rest_do_request( $request );

		$this->assertEquals( 200, $response->get_status() );

		$data = $response->get_data();
		$this->assertIsArray( $data );
		$this->assertNotEmpty( $data );
	}

}
```

## E2E Test Templates

### Cypress Test

```javascript
/**
 * E2E tests for user authentication.
 */

describe('User Authentication', () => {
  beforeEach(() => {
    cy.visit('/');
  });

  it('allows user to login successfully', () => {
    cy.get('[data-test="login-button"]').click();
    cy.url().should('include', '/login');

    cy.get('[name="username"]').type('testuser');
    cy.get('[name="password"]').type('password123');
    cy.get('[type="submit"]').click();

    cy.url().should('include', '/dashboard');
    cy.contains('Welcome, testuser').should('be.visible');
  });

  it('shows error for invalid credentials', () => {
    cy.get('[data-test="login-button"]').click();

    cy.get('[name="username"]').type('wronguser');
    cy.get('[name="password"]').type('wrongpass');
    cy.get('[type="submit"]').click();

    cy.contains('Invalid credentials').should('be.visible');
    cy.url().should('include', '/login');
  });

  it('allows user to logout', () => {
    // Login first
    cy.login('testuser', 'password123');

    // Then logout
    cy.get('[data-test="logout-button"]').click();
    cy.url().should('not.include', '/dashboard');
  });
});
```

## Generation Strategy

### 1. Start Simple
Generate basic test structure first:
- Test class/describe block
- Setup/teardown methods
- One or two simple test cases

### 2. Identify Test Cases
For each public method:
- Happy path (valid input)
- Error cases (invalid input)
- Edge cases (empty, null, boundary values)
- State changes (before/after)

### 3. Mock Dependencies
Identify what needs mocking:
- Database calls
- External APIs
- File system operations
- Time-dependent code

### 4. Add Assertions
Check:
- Return values
- State changes
- Side effects
- Error handling

## Integration with CMS Cultivator

This skill complements the `/test-generate` slash command:

- **This Skill**: Automatically triggered during conversation
  - "I need tests for this class"
  - "How do I test this function?"
  - Quick single-class test generation

- **`/test-generate` Command**: Explicit batch generation
  - Generate tests for entire module
  - Comprehensive test suite creation
  - Project-wide test coverage

## Quick Response Examples

**Example 1: Simple class**
```
User: "I wrote this UserManager class, need tests"
[Shows class with 3 methods]

Skill: "I'll generate PHPUnit tests for your UserManager class.
I see 3 public methods: createUser(), getUser(), deleteUser().
I'll create tests for the happy path and error cases for each.

[Generates test file]

This gives you 80% coverage to start. You may want to add edge case
tests for boundary conditions."
```

**Example 2: WordPress function**
```
User: "How do I test this WordPress function?"
[Shows custom function that uses WP_Query]

Skill: "For WordPress functions using WP_Query, you'll want an
integration test. I'll generate a WP_UnitTestCase test that:
1. Creates test posts using the factory
2. Calls your function
3. Verifies the query results

[Generates test code]

The test uses wp_insert_post() to create test data, then cleans up
automatically in tearDown()."
```

## Best Practices

1. **Test behavior, not implementation** - Test what code does, not how
2. **One assertion per test** - Keep tests focused
3. **Descriptive test names** - `testCreateUserWithValidData()` not `testCreateUser()`
4. **Arrange-Act-Assert** - Setup, execute, verify pattern
5. **Independent tests** - Tests shouldn't depend on each other
6. **Clean up** - Remove test data in tearDown()

## Common Patterns

### Testing Private Methods
Don't. Test public interface instead. If private method needs testing, consider extracting to separate class.

### Testing Static Methods
```php
// Avoid static methods when possible
// If you must, test directly
$result = MyClass::staticMethod($input);
$this->assertEquals($expected, $result);
```

### Testing Database Operations
```php
// Use transactions for rollback
protected function setUp(): void {
  parent::setUp();
  $this->database->beginTransaction();
}

protected function tearDown(): void {
  $this->database->rollbackTransaction();
  parent::tearDown();
}
```

## Resources

- [PHPUnit Documentation](https://phpunit.de/)
- [Drupal Testing Guide](https://www.drupal.org/docs/testing)
- [WordPress PHPUnit](https://make.wordpress.org/core/handbook/testing/automated-testing/phpunit/)
- [Cypress Documentation](https://docs.cypress.io/)
- [Jest Documentation](https://jestjs.io/)
