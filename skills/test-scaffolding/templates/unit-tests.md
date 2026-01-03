# Unit Test Templates

Complete templates for unit testing isolated logic.

## When to Use Unit Tests

**Unit Tests** are for isolated logic:
- Services with minimal dependencies
- Utility functions
- Data transformation
- Business logic
- No database or external dependencies

## Drupal PHPUnit Unit Test

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

## WordPress PHPUnit Test

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

## JavaScript Unit Test (Jest)

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

## Unit Test Best Practices

### Test Structure (Arrange-Act-Assert)

```php
public function testMethodName(): void {
  // Arrange - Set up test data
  $input = ['key' => 'value'];

  // Act - Execute the method
  $result = $this->service->process($input);

  // Assert - Verify the result
  $this->assertEquals('expected', $result);
}
```

### Descriptive Test Names

✅ **Good**: `testProcessDataWithEmptyArray()`
✅ **Good**: `testValidateEmailWithInvalidFormat()`
❌ **Bad**: `testProcess()`
❌ **Bad**: `test1()`

### One Assertion Per Test (Generally)

```php
// Good - Focused test
public function testGetUserReturnsCorrectEmail(): void {
  $user = $this->manager->getUser(1);
  $this->assertEquals('test@example.com', $user->email);
}

// Also OK - Related assertions
public function testGetUserReturnsValidUserObject(): void {
  $user = $this->manager->getUser(1);
  $this->assertIsObject($user);
  $this->assertInstanceOf(User::class, $user);
}
```

### Mock Dependencies

```php
protected function setUp(): void {
  parent::setUp();

  // Mock dependencies
  $this->database = $this->createMock(DatabaseInterface::class);
  $this->logger = $this->createMock(LoggerInterface::class);

  // Inject mocks
  $this->service = new MyService($this->database, $this->logger);
}
```

### Test Edge Cases

For each method, test:
- **Happy path**: Valid input → expected output
- **Error cases**: Invalid input → exception
- **Edge cases**: Empty, null, boundary values
- **State changes**: Before/after verification

## Common PHPUnit Assertions

```php
// Equality
$this->assertEquals($expected, $actual);
$this->assertSame($expected, $actual); // Strict comparison

// Type checks
$this->assertIsArray($value);
$this->assertIsString($value);
$this->assertInstanceOf(MyClass::class, $object);

// Boolean
$this->assertTrue($condition);
$this->assertFalse($condition);
$this->assertNull($value);

// Strings
$this->assertStringContains('substring', $string);
$this->assertStringStartsWith('prefix', $string);

// Arrays
$this->assertArrayHasKey('key', $array);
$this->assertContains('value', $array);
$this->assertCount(3, $array);

// Exceptions
$this->expectException(InvalidArgumentException::class);
$this->expectExceptionMessage('Error message');
```

## Common Jest Assertions

```javascript
// Equality
expect(value).toBe(expected); // Strict equality
expect(value).toEqual(expected); // Deep equality

// Type checks
expect(value).toBeNull();
expect(value).toBeUndefined();
expect(value).toBeDefined();

// Boolean
expect(condition).toBeTruthy();
expect(condition).toBeFalsy();

// Numbers
expect(value).toBeGreaterThan(5);
expect(value).toBeLessThan(10);

// Strings
expect(string).toContain('substring');
expect(string).toMatch(/regex/);

// Arrays
expect(array).toContain('value');
expect(array).toHaveLength(3);

// Exceptions
expect(() => func()).toThrow();
expect(() => func()).toThrow('Error message');
```
