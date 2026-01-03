# Integration Test Templates

Complete templates for testing component interactions.

## When to Use Integration Tests

**Integration Tests** are for component interaction:
- Controllers with database
- Form handlers
- API endpoints
- Complex workflows
- Multiple components working together

## Drupal Functional Test

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

## WordPress Integration Test

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

	/**
	 * Test POST /wp-json/myplugin/v1/users endpoint.
	 */
	public function test_post_users_endpoint() {
		// Authenticate as admin.
		wp_set_current_user( $this->factory->user->create( array( 'role' => 'administrator' ) ) );

		$request = new \WP_REST_Request( 'POST', '/myplugin/v1/users' );
		$request->set_body_params(
			array(
				'name'  => 'Test User',
				'email' => 'test@example.com',
			)
		);

		$response = rest_do_request( $request );

		$this->assertEquals( 201, $response->get_status() );
		$this->assertArrayHasKey( 'id', $response->get_data() );
	}

}
```

## Drupal Kernel Test (Database Interaction)

```php
<?php

namespace Drupal\Tests\mymodule\Kernel;

use Drupal\KernelTests\KernelTestBase;
use Drupal\node\Entity\Node;
use Drupal\node\Entity\NodeType;

/**
 * Tests the content processing service.
 *
 * @group mymodule
 */
class ContentProcessorTest extends KernelTestBase {

  /**
   * {@inheritdoc}
   */
  protected static $modules = ['system', 'user', 'node', 'mymodule'];

  /**
   * The content processor service.
   *
   * @var \Drupal\mymodule\Service\ContentProcessor
   */
  protected $contentProcessor;

  /**
   * {@inheritdoc}
   */
  protected function setUp(): void {
    parent::setUp();

    $this->installEntitySchema('user');
    $this->installEntitySchema('node');
    $this->installSchema('node', ['node_access']);

    // Create a content type.
    NodeType::create([
      'type' => 'article',
      'name' => 'Article',
    ])->save();

    $this->contentProcessor = $this->container->get('mymodule.content_processor');
  }

  /**
   * Test processing node content.
   */
  public function testProcessNodeContent(): void {
    // Create a test node.
    $node = Node::create([
      'type' => 'article',
      'title' => 'Test Article',
      'body' => 'Test content',
    ]);
    $node->save();

    // Process the node.
    $result = $this->contentProcessor->process($node);

    $this->assertTrue($result);
    $this->assertEquals('processed', $node->get('field_status')->value);
  }

}
```

## Integration Test Best Practices

### Database Setup and Teardown

**Drupal Kernel Tests:**
```php
protected function setUp(): void {
  parent::setUp();

  // Install required schemas
  $this->installEntitySchema('user');
  $this->installEntitySchema('node');
  $this->installSchema('system', ['sequences']);
}
```

**WordPress Tests:**
```php
public function setUp(): void {
  parent::setUp();
  // WordPress automatically handles database transactions
}

public function tearDown(): void {
  // Cleanup happens automatically
  parent::tearDown();
}
```

### Test Data Creation

**Use Factories:**
```php
// WordPress
$user_id = $this->factory->user->create();
$post_id = $this->factory->post->create(['post_title' => 'Test']);

// Drupal
$node = Node::create(['type' => 'article', 'title' => 'Test']);
$node->save();
```

### Test Isolation

Each test should:
- ✅ Set up its own data
- ✅ Be independent of other tests
- ✅ Clean up after itself (automatic in most frameworks)
- ❌ Never depend on test execution order

### Test API Endpoints

```php
// Test authentication
public function testEndpointRequiresAuthentication() {
  $request = new WP_REST_Request('POST', '/myplugin/v1/data');
  $response = rest_do_request($request);

  $this->assertEquals(401, $response->get_status());
}

// Test validation
public function testEndpointValidatesInput() {
  wp_set_current_user($this->factory->user->create());

  $request = new WP_REST_Request('POST', '/myplugin/v1/data');
  $request->set_body_params(['invalid' => 'data']);

  $response = rest_do_request($request);

  $this->assertEquals(400, $response->get_status());
}
```

### Test Form Handlers

**Drupal:**
```php
public function testFormSubmission(): void {
  $this->drupalGet('/admin/config/mymodule/settings');

  $edit = [
    'api_key' => 'test-key',
    'enabled' => TRUE,
  ];

  $this->submitForm($edit, 'Save configuration');

  $this->assertSession()->pageTextContains('Configuration saved');

  // Verify config was saved
  $config = $this->config('mymodule.settings');
  $this->assertEquals('test-key', $config->get('api_key'));
}
```

**WordPress:**
```php
public function test_settings_form_submission() {
  $_POST['api_key'] = 'test-key';
  $_POST['nonce'] = wp_create_nonce('mymodule_settings');

  $result = mymodule_save_settings();

  $this->assertTrue($result);
  $this->assertEquals('test-key', get_option('mymodule_api_key'));
}
```

## Testing Database Queries

### Test Query Results

```php
public function testGetUsersByRole() {
  // Create test users
  $admin_id = $this->factory->user->create(['role' => 'administrator']);
  $editor_id = $this->factory->user->create(['role' => 'editor']);
  $subscriber_id = $this->factory->user->create(['role' => 'subscriber']);

  // Execute query
  $admins = mymodule_get_users_by_role('administrator');

  // Verify results
  $this->assertCount(1, $admins);
  $this->assertEquals($admin_id, $admins[0]->ID);
}
```

### Test Query Performance

```php
public function testQueryPerformance() {
  // Create bulk test data
  for ($i = 0; $i < 100; $i++) {
    $this->factory->post->create();
  }

  $start = microtime(true);
  $results = mymodule_get_posts();
  $duration = microtime(true) - $start;

  // Verify query is fast enough (under 100ms)
  $this->assertLessThan(0.1, $duration);
}
```

## Testing Workflows

```php
public function testCompleteCheckoutWorkflow() {
  // Step 1: Create cart
  $cart = mymodule_create_cart();
  $this->assertNotEmpty($cart->id);

  // Step 2: Add items
  mymodule_add_to_cart($cart->id, 'product-1', 2);
  mymodule_add_to_cart($cart->id, 'product-2', 1);

  $cart = mymodule_get_cart($cart->id);
  $this->assertCount(2, $cart->items);

  // Step 3: Apply discount
  $result = mymodule_apply_discount($cart->id, 'SAVE10');
  $this->assertTrue($result);

  // Step 4: Process payment
  $order = mymodule_checkout($cart->id, [
    'payment_method' => 'test',
  ]);

  $this->assertEquals('completed', $order->status);
  $this->assertNotEmpty($order->transaction_id);
}
```

## Common Integration Test Scenarios

### Authentication/Authorization
```php
public function testUnauthorizedUserCannotAccessAdminPage() {
  $user = $this->drupalCreateUser(); // No admin permission
  $this->drupalLogin($user);
  $this->drupalGet('/admin/config/mymodule');
  $this->assertSession()->statusCodeEquals(403);
}
```

### Data Persistence
```php
public function testDataPersistsAcrossRequests() {
  // Save data
  update_option('mymodule_data', 'test-value');

  // Retrieve in "new request"
  $value = get_option('mymodule_data');
  $this->assertEquals('test-value', $value);
}
```

### Email Sending
```php
public function testEmailSentOnRegistration() {
  // WordPress uses pre_wp_mail filter for testing
  add_filter('pre_wp_mail', function($null) {
    return ['to' => 'test@example.com'];
  });

  $result = mymodule_send_welcome_email('test@example.com');
  $this->assertTrue($result);
}
```
