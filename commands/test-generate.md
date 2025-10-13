---
description: Generate test scaffolding (unit, integration, e2e, cypress tests)
argument-hint: [test-type]
allowed-tools: Read, Glob, Grep, Write
---

# Test Generator

Generate test scaffolding and boilerplate for various test types including unit tests, integration tests, end-to-end tests, and Cypress tests.

## Usage

- `/test-generate` - Generate tests for all testable code
- `/test-generate unit` - Generate unit tests only
- `/test-generate integration` - Generate integration tests only
- `/test-generate e2e` - Generate end-to-end/Cypress tests only
- `/test-generate data` - Generate test fixtures and sample data only

## Test Types

### 1. Unit Tests (PHPUnit)

**Purpose**: Test individual functions, methods, and classes in isolation

**Drupal Unit Tests:**
- Kernel tests (with minimal Drupal bootstrap)
- Unit tests (no Drupal dependencies)
- Service tests (test custom services)

**WordPress Unit Tests:**
- WP_UnitTestCase tests
- Test functions and classes
- Mock WordPress functions

### 2. Integration Tests

**Purpose**: Test how components work together

**Drupal Integration:**
- Functional tests (BrowserTestBase)
- JavaScript tests (FunctionalJavascript)
- API endpoint tests

**WordPress Integration:**
- WP REST API tests
- WP_Ajax_UnitTestCase
- Database integration tests

### 3. End-to-End Tests (Cypress)

**Purpose**: Test complete user workflows in real browser

**Coverage:**
- User authentication flows
- Form submissions
- Navigation and routing
- Content creation workflows
- Admin interfaces

## Generation Process

### 1. Analyze Code to Test

Scan for untested or undertested code:

```bash
# Find PHP classes without tests
find web/modules/custom -name "*.php" | while read file; do
  basename=$(basename "$file" .php)
  if [ ! -f "tests/src/Unit/${basename}Test.php" ]; then
    echo "No test for: $file"
  fi
done

# Check test coverage
vendor/bin/phpunit --coverage-text

# Find JavaScript without tests
find web/themes/custom -name "*.js" ! -path "*/node_modules/*" ! -name "*.test.js"
```

### 2. Generate Unit Tests

#### Drupal Service Unit Test

**Source Code** (`web/modules/custom/mymodule/src/Service/DataProcessor.php`):
```php
<?php

namespace Drupal\mymodule\Service;

class DataProcessor {

  /**
   * Process user data.
   *
   * @param array $data
   *   Raw user data.
   *
   * @return array
   *   Processed data.
   */
  public function processData(array $data) {
    $processed = [];
    foreach ($data as $key => $value) {
      $processed[$key] = trim($value);
    }
    return $processed;
  }

  /**
   * Validate email address.
   *
   * @param string $email
   *   Email to validate.
   *
   * @return bool
   *   TRUE if valid.
   */
  public function validateEmail($email) {
    return (bool) filter_var($email, FILTER_VALIDATE_EMAIL);
  }

}
```

**Generated Test** (`tests/src/Unit/Service/DataProcessorTest.php`):
```php
<?php

namespace Drupal\Tests\mymodule\Unit\Service;

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
   * Tests processData method.
   *
   * @covers ::processData
   */
  public function testProcessData() {
    $input = [
      'name' => '  John Doe  ',
      'email' => ' john@example.com ',
    ];

    $expected = [
      'name' => 'John Doe',
      'email' => 'john@example.com',
    ];

    $result = $this->dataProcessor->processData($input);
    $this->assertEquals($expected, $result);
  }

  /**
   * Tests processData with empty array.
   *
   * @covers ::processData
   */
  public function testProcessDataEmpty() {
    $result = $this->dataProcessor->processData([]);
    $this->assertEmpty($result);
  }

  /**
   * Tests validateEmail with valid email.
   *
   * @covers ::validateEmail
   * @dataProvider validEmailProvider
   */
  public function testValidateEmailValid($email) {
    $result = $this->dataProcessor->validateEmail($email);
    $this->assertTrue($result);
  }

  /**
   * Tests validateEmail with invalid email.
   *
   * @covers ::validateEmail
   * @dataProvider invalidEmailProvider
   */
  public function testValidateEmailInvalid($email) {
    $result = $this->dataProcessor->validateEmail($email);
    $this->assertFalse($result);
  }

  /**
   * Data provider for valid emails.
   */
  public function validEmailProvider() {
    return [
      ['john@example.com'],
      ['jane.doe@example.co.uk'],
      ['user+tag@domain.com'],
    ];
  }

  /**
   * Data provider for invalid emails.
   */
  public function invalidEmailProvider() {
    return [
      ['invalid'],
      ['@example.com'],
      ['user@'],
      ['user @example.com'],
    ];
  }

}
```

#### WordPress Function Unit Test

**Source Code** (`wp-content/themes/mytheme/inc/helpers.php`):
```php
<?php
/**
 * Calculate reading time for post.
 *
 * @param int $post_id Post ID.
 * @return int Reading time in minutes.
 */
function mytheme_get_reading_time($post_id) {
  $content = get_post_field('post_content', $post_id);
  $word_count = str_word_count(strip_tags($content));
  $reading_time = ceil($word_count / 200);
  return max(1, $reading_time);
}
```

**Generated Test** (`tests/test-helpers.php`):
```php
<?php
/**
 * Tests for theme helper functions.
 */
class Test_Helpers extends WP_UnitTestCase {

  /**
   * Test reading time calculation.
   */
  public function test_mytheme_get_reading_time() {
    // Create post with known word count (200 words)
    $content = str_repeat('word ', 200);
    $post_id = $this->factory->post->create([
      'post_content' => $content,
    ]);

    $reading_time = mytheme_get_reading_time($post_id);

    // 200 words = 1 minute reading time
    $this->assertEquals(1, $reading_time);
  }

  /**
   * Test reading time with short content.
   */
  public function test_mytheme_get_reading_time_minimum() {
    // Create post with 10 words
    $content = str_repeat('word ', 10);
    $post_id = $this->factory->post->create([
      'post_content' => $content,
    ]);

    $reading_time = mytheme_get_reading_time($post_id);

    // Should return minimum of 1 minute
    $this->assertEquals(1, $reading_time);
  }

  /**
   * Test reading time with long content.
   */
  public function test_mytheme_get_reading_time_long() {
    // Create post with 1000 words
    $content = str_repeat('word ', 1000);
    $post_id = $this->factory->post->create([
      'post_content' => $content,
    ]);

    $reading_time = mytheme_get_reading_time($post_id);

    // 1000 words / 200 = 5 minutes
    $this->assertEquals(5, $reading_time);
  }

  /**
   * Test reading time strips HTML tags.
   */
  public function test_mytheme_get_reading_time_strips_html() {
    $content = '<p>' . str_repeat('word ', 200) . '</p>';
    $post_id = $this->factory->post->create([
      'post_content' => $content,
    ]);

    $reading_time = mytheme_get_reading_time($post_id);

    $this->assertEquals(1, $reading_time);
  }

}
```

#### JavaScript Unit Test (Jest)

**Source Code** (`web/themes/custom/mytheme/js/utils.js`):
```javascript
/**
 * Format currency amount.
 *
 * @param {number} amount - Amount to format.
 * @param {string} currency - Currency code (default: USD).
 * @returns {string} Formatted currency string.
 */
export function formatCurrency(amount, currency = 'USD') {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: currency,
  }).format(amount);
}

/**
 * Debounce function calls.
 *
 * @param {Function} func - Function to debounce.
 * @param {number} wait - Wait time in milliseconds.
 * @returns {Function} Debounced function.
 */
export function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}
```

**Generated Test** (`web/themes/custom/mytheme/js/utils.test.js`):
```javascript
import { formatCurrency, debounce } from './utils';

describe('formatCurrency', () => {
  test('formats USD correctly', () => {
    expect(formatCurrency(1234.56)).toBe('$1,234.56');
  });

  test('formats EUR correctly', () => {
    expect(formatCurrency(1234.56, 'EUR')).toContain('1,234.56');
  });

  test('handles zero', () => {
    expect(formatCurrency(0)).toBe('$0.00');
  });

  test('handles negative numbers', () => {
    expect(formatCurrency(-100)).toContain('-');
    expect(formatCurrency(-100)).toContain('100');
  });

  test('rounds to 2 decimal places', () => {
    expect(formatCurrency(10.999)).toBe('$11.00');
  });
});

describe('debounce', () => {
  jest.useFakeTimers();

  test('executes function after wait time', () => {
    const func = jest.fn();
    const debouncedFunc = debounce(func, 1000);

    debouncedFunc();
    expect(func).not.toHaveBeenCalled();

    jest.advanceTimersByTime(1000);
    expect(func).toHaveBeenCalledTimes(1);
  });

  test('cancels previous calls', () => {
    const func = jest.fn();
    const debouncedFunc = debounce(func, 1000);

    debouncedFunc();
    debouncedFunc();
    debouncedFunc();

    jest.advanceTimersByTime(1000);
    expect(func).toHaveBeenCalledTimes(1);
  });

  test('passes arguments correctly', () => {
    const func = jest.fn();
    const debouncedFunc = debounce(func, 1000);

    debouncedFunc('arg1', 'arg2');
    jest.advanceTimersByTime(1000);

    expect(func).toHaveBeenCalledWith('arg1', 'arg2');
  });
});
```

### 3. Generate Integration Tests

#### Drupal Functional Test

```php
<?php

namespace Drupal\Tests\mymodule\Functional;

use Drupal\Tests\BrowserTestBase;

/**
 * Tests user registration flow.
 *
 * @group mymodule
 */
class UserRegistrationTest extends BrowserTestBase {

  /**
   * {@inheritdoc}
   */
  protected $defaultTheme = 'stark';

  /**
   * {@inheritdoc}
   */
  protected static $modules = ['mymodule', 'user'];

  /**
   * Tests user can register with valid data.
   */
  public function testUserRegistration() {
    // Go to registration page
    $this->drupalGet('/user/register');
    $this->assertSession()->statusCodeEquals(200);

    // Fill in form
    $edit = [
      'name' => 'testuser',
      'mail' => 'test@example.com',
    ];
    $this->submitForm($edit, 'Create new account');

    // Verify success message
    $this->assertSession()->pageTextContains('registration successful');

    // Verify user created
    $user = user_load_by_name('testuser');
    $this->assertNotNull($user);
    $this->assertEquals('test@example.com', $user->getEmail());
  }

  /**
   * Tests registration fails with invalid email.
   */
  public function testUserRegistrationInvalidEmail() {
    $this->drupalGet('/user/register');

    $edit = [
      'name' => 'testuser',
      'mail' => 'invalid-email',
    ];
    $this->submitForm($edit, 'Create new account');

    // Verify error message
    $this->assertSession()->pageTextContains('not a valid email');

    // Verify user not created
    $user = user_load_by_name('testuser');
    $this->assertNull($user);
  }

}
```

### 4. Generate Cypress E2E Tests

```javascript
// cypress/e2e/user-login.cy.js

describe('User Login Flow', () => {
  beforeEach(() => {
    // Reset database state
    cy.task('db:seed');
    cy.visit('/user/login');
  });

  it('displays login form', () => {
    cy.get('form#user-login-form').should('be.visible');
    cy.get('input[name="name"]').should('be.visible');
    cy.get('input[name="pass"]').should('be.visible');
    cy.get('button[type="submit"]').should('contain', 'Log in');
  });

  it('logs in with valid credentials', () => {
    cy.get('input[name="name"]').type('admin');
    cy.get('input[name="pass"]').type('admin');
    cy.get('button[type="submit"]').click();

    // Verify redirect to user page
    cy.url().should('include', '/user/');
    cy.get('.page-title').should('contain', 'admin');

    // Verify logged in state
    cy.get('.user-menu').should('contain', 'Log out');
  });

  it('shows error with invalid credentials', () => {
    cy.get('input[name="name"]').type('baduser');
    cy.get('input[name="pass"]').type('badpass');
    cy.get('button[type="submit"]').click();

    // Should stay on login page
    cy.url().should('include', '/user/login');

    // Show error message
    cy.get('.messages--error').should('contain', 'Unrecognized username or password');
  });

  it('shows validation errors for empty fields', () => {
    cy.get('button[type="submit"]').click();

    cy.get('input[name="name"]:invalid').should('exist');
    cy.get('input[name="pass"]:invalid').should('exist');
  });

  it('allows password reset', () => {
    cy.get('a').contains('Forgot password').click();
    cy.url().should('include', '/user/password');

    cy.get('input[name="name"]').type('admin');
    cy.get('button[type="submit"]').click();

    cy.get('.messages--status').should('contain', 'password reset');
  });

  it('is accessible', () => {
    // Run accessibility checks
    cy.injectAxe();
    cy.checkA11y();
  });
});
```

## Test Configuration Files

### PHPUnit Configuration

Generate `phpunit.xml`:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="https://schema.phpunit.de/9.5/phpunit.xsd"
         bootstrap="vendor/autoload.php"
         colors="true">
  <testsuites>
    <testsuite name="unit">
      <directory>./tests/src/Unit</directory>
    </testsuite>
    <testsuite name="kernel">
      <directory>./tests/src/Kernel</directory>
    </testsuite>
    <testsuite name="functional">
      <directory>./tests/src/Functional</directory>
    </testsuite>
  </testsuites>

  <coverage>
    <include>
      <directory suffix=".php">./web/modules/custom</directory>
      <directory suffix=".php">./web/themes/custom</directory>
    </include>
    <exclude>
      <directory>./vendor</directory>
      <directory>./tests</directory>
    </exclude>
  </coverage>

  <php>
    <env name="SIMPLETEST_BASE_URL" value="http://localhost:8080"/>
    <env name="SIMPLETEST_DB" value="mysql://db:db@localhost/db"/>
    <env name="BROWSERTEST_OUTPUT_DIRECTORY" value="./sites/simpletest/browser_output"/>
  </php>
</phpunit>
```

### Jest Configuration

Generate `jest.config.js`:
```javascript
module.exports = {
  testEnvironment: 'jsdom',
  testMatch: [
    '**/__tests__/**/*.js',
    '**/*.test.js',
    '**/*.spec.js',
  ],
  coverageDirectory: './coverage',
  collectCoverageFrom: [
    'web/themes/custom/**/*.js',
    'web/modules/custom/**/*.js',
    '!**/node_modules/**',
    '!**/vendor/**',
    '!**/*.test.js',
  ],
  transform: {
    '^.+\\.js$': 'babel-jest',
  },
  setupFilesAfterEnv: ['<rootDir>/jest.setup.js'],
};
```

### Cypress Configuration

Generate `cypress.config.js`:
```javascript
const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    baseUrl: 'http://localhost:8080',
    specPattern: 'cypress/e2e/**/*.cy.{js,jsx,ts,tsx}',
    supportFile: 'cypress/support/e2e.js',
    video: true,
    screenshotOnRunFailure: true,
    setupNodeEvents(on, config) {
      // Implement node event listeners
      on('task', {
        'db:seed'() {
          // Reset database to known state
          return null;
        },
      });
    },
  },

  component: {
    devServer: {
      framework: 'react',
      bundler: 'webpack',
    },
  },
});
```

## Running Tests

```bash
# PHPUnit - Unit tests
vendor/bin/phpunit --testsuite=unit

# PHPUnit - All tests
vendor/bin/phpunit

# PHPUnit - With coverage
vendor/bin/phpunit --coverage-html ./coverage

# Jest - JavaScript tests
npm test

# Jest - Watch mode
npm test -- --watch

# Jest - Coverage
npm test -- --coverage

# Cypress - Interactive mode
npm run cypress:open

# Cypress - Headless mode
npm run cypress:run

# Run all tests
composer test && npm test && npm run cypress:run
```

## Best Practices

1. **Test Organization** - Mirror source code structure
2. **Test Naming** - Use descriptive test names (test what, not how)
3. **AAA Pattern** - Arrange, Act, Assert
4. **One Assertion** - Ideally one logical assertion per test
5. **Test Data** - Use factories/fixtures for test data
6. **Mock External Dependencies** - Don't test third-party code
7. **Coverage Goals** - Aim for >80% code coverage
8. **Fast Tests** - Unit tests should run in milliseconds

## Resources

- [PHPUnit Documentation](https://phpunit.de/)
- [Drupal Testing](https://www.drupal.org/docs/automated-testing)
- [WordPress Testing Handbook](https://make.wordpress.org/core/handbook/testing/)
- [Jest Documentation](https://jestjs.io/)
- [Cypress Documentation](https://www.cypress.io/)
