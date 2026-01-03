# API Documentation Templates

Complete templates for documenting code interfaces.

## Drupal Service API Documentation

```php
<?php

namespace Drupal\mymodule\Service;

use Drupal\Core\Entity\EntityTypeManagerInterface;

/**
 * Service for processing user data.
 *
 * This service handles validation, transformation, and storage of user data
 * from various sources including forms, APIs, and imports.
 *
 * @package Drupal\mymodule\Service
 *
 * Usage example:
 * @code
 * $data_processor = \Drupal::service('mymodule.data_processor');
 * $processed_data = $data_processor->processUserData($raw_data);
 * @endcode
 */
class DataProcessor {

  /**
   * The entity type manager.
   *
   * @var \Drupal\Core\Entity\EntityTypeManagerInterface
   */
  protected $entityTypeManager;

  /**
   * Constructs a DataProcessor object.
   *
   * @param \Drupal\Core\Entity\EntityTypeManagerInterface $entity_type_manager
   *   The entity type manager service.
   */
  public function __construct(EntityTypeManagerInterface $entity_type_manager) {
    $this->entityTypeManager = $entity_type_manager;
  }

  /**
   * Process raw user data.
   *
   * Validates and transforms raw user data into a structured format
   * suitable for storage. Performs data sanitization, validation,
   * and normalization.
   *
   * @param array $data
   *   Raw user data array containing:
   *   - 'name' (string): User's full name.
   *   - 'email' (string): User's email address.
   *   - 'age' (int, optional): User's age.
   *
   * @return array
   *   Processed data array with standardized keys and validated values.
   *
   * @throws \InvalidArgumentException
   *   If required fields are missing or invalid.
   *
   * @see \Drupal\mymodule\Validator\UserDataValidator
   *
   * @code
   * $raw_data = [
   *   'name' => 'John Doe',
   *   'email' => 'john@example.com',
   *   'age' => 30,
   * ];
   * $processed = $data_processor->processUserData($raw_data);
   * // Returns: ['name' => 'John Doe', 'email' => 'john@example.com', ...]
   * @endcode
   */
  public function processUserData(array $data): array {
    // Implementation...
  }

}
```

## WordPress Function API Documentation

```php
<?php
/**
 * Get formatted user data.
 *
 * Retrieves user data from the database and formats it for display.
 * Includes caching and permission checks.
 *
 * @since 1.0.0
 *
 * @param int    $user_id User ID to retrieve data for.
 * @param string $format  Output format: 'array', 'object', or 'json'. Default 'array'.
 *
 * @return array|object|string|false User data in specified format, or false on error.
 *
 * @throws InvalidArgumentException If user_id is not a positive integer.
 *
 * Example usage:
 * ```php
 * $user_data = my_plugin_get_user_data( 123, 'array' );
 * if ( $user_data ) {
 *     echo $user_data['name'];
 * }
 * ```
 */
function my_plugin_get_user_data( $user_id, $format = 'array' ) {
	// Implementation...
}
```

## Key Documentation Elements

### For Classes
- Purpose and responsibility
- Usage examples with @code blocks
- Dependencies and injection
- Package/namespace information

### For Methods
- What the method does (not how)
- Parameter documentation with types
- Return type documentation
- Exceptions that may be thrown
- See also references
- Code examples showing typical usage

### For Functions
- @since tag (WordPress convention)
- Parameter documentation
- Return type documentation
- Examples in docblock
- Related functions (@see tags)
