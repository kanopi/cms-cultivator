---
name: documentation-generator
description: Automatically generate documentation when user mentions needing API docs, README files, user guides, developer guides, or changelogs. Analyzes code and generates appropriate documentation based on context. Invoke when user mentions "document", "docs", "README", "API documentation", "guide", "changelog", or "how to document".
---

# Documentation Generator

Automatically generate documentation for code, APIs, and projects.

## When to Use This Skill

Activate this skill when the user:
- Says "I need to document this"
- Asks "how do I write docs for this API?"
- Mentions "README", "documentation", or "user guide"
- Shows code and asks "what docs should I write?"
- Says "need API documentation"
- Asks about changelog or release notes
- Mentions "developer guide" or "setup instructions"

## Workflow

### 1. Determine Documentation Type

**API Documentation** - For code interfaces:
- Functions, methods, classes
- Parameters and return types
- Examples and usage

**README** - For project overview:
- Installation instructions
- Quick start guide
- Features and requirements

**User Guide** - For end users:
- How to use features
- Screenshots and examples
- Troubleshooting

**Developer Guide** - For contributors:
- Architecture overview
- Setup and development
- Coding standards

**Changelog** - For releases:
- Version history
- What changed
- Migration guides

### 2. Analyze the Code/Project

**For API Docs**:
- Scan function signatures
- Identify parameters and return types
- Find existing comments
- Detect dependencies

**For README**:
- Check for package managers (composer.json, package.json)
- Identify framework (Drupal, WordPress, etc.)
- Find entry points and main features

**For Guides**:
- Understand user workflows
- Identify key features
- Note prerequisites

## Documentation Templates

### API Documentation (PHP)

#### Drupal Service API Documentation

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

#### WordPress Function API Documentation

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

### README Template

```markdown
# Project Name

Brief description of what this project does and who it's for.

[![Maintenance](https://img.shields.io/maintenance/yes/2025.svg)]()
[![License](https://img.shields.io/badge/license-GPL--2.0-blue.svg)](LICENSE)

## Features

- ✨ Key feature 1
- 🚀 Key feature 2
- 🔒 Key feature 3

## Requirements

- PHP 8.1 or higher
- Drupal 10.x or WordPress 6.x
- Composer 2.x

## Installation

### Composer (Recommended)

```bash
composer require vendor/package-name
```

### Manual Installation

1. Download the latest release
2. Extract to your modules/plugins directory
3. Enable the module/plugin

## Quick Start

```php
// Example usage
$service = \Drupal::service('mymodule.data_processor');
$result = $service->process($data);
```

## Configuration

1. Navigate to Admin > Configuration > My Module
2. Configure your settings
3. Save configuration

## Usage

### Basic Example

```php
$processor = new DataProcessor();
$result = $processor->processData([
  'name' => 'John Doe',
  'email' => 'john@example.com',
]);
```

### Advanced Example

[More complex usage with options]

## API Reference

See [API Documentation](docs/api.md) for complete API reference.

## Testing

```bash
# Run tests
vendor/bin/phpunit

# Run with coverage
vendor/bin/phpunit --coverage-html coverage
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for version history.

## License

GPL-2.0-or-later. See [LICENSE](LICENSE) for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/org/repo/issues)
- **Documentation**: [Full Docs](https://example.com/docs)

## Credits

Created and maintained by [Your Organization](https://example.com)
```

### User Guide Template

```markdown
# User Guide: Feature Name

This guide will help you use [Feature Name] to accomplish [goal].

## Overview

[Feature Name] allows you to [main purpose]. This is useful when you need to [use case].

## Getting Started

### Prerequisites

Before you begin, ensure you have:
- [ ] Access to the admin dashboard
- [ ] Proper user permissions
- [ ] Required plugins enabled

### Step 1: Initial Setup

1. Navigate to **Settings > Feature Name**
2. Click **Enable Feature**
3. Configure your preferences:
   - Option 1: Description
   - Option 2: Description

![Screenshot of settings page](images/settings.png)

### Step 2: Using the Feature

To use [Feature Name]:

1. Go to **Dashboard > Feature Name**
2. Click **Create New**
3. Fill in the required fields:
   - **Title**: Enter a descriptive title
   - **Description**: Provide details
   - **Options**: Select appropriate options

4. Click **Save**

![Screenshot of creation form](images/create-form.png)

## Common Tasks

### Task 1: [Task Name]

**To accomplish [task]:**

1. Step one
2. Step two
3. Step three

**Expected Result**: You should see [result]

### Task 2: [Another Task]

[Instructions for another common task]

## Troubleshooting

### Issue: Feature not appearing

**Solution**: Check that:
- Feature is enabled in settings
- You have proper permissions
- Cache has been cleared

### Issue: Data not saving

**Solution**:
1. Check PHP error logs
2. Verify database permissions
3. Ensure all required fields are filled

## Tips and Best Practices

💡 **Tip**: Always back up before making changes

⚡ **Performance**: For better performance, consider [optimization]

🔒 **Security**: Ensure you [security practice]

## FAQs

**Q: Can I [common question]?**
A: Yes, you can [answer].

**Q: What if [scenario]?**
A: In that case, [solution].

## Need Help?

- Check the [Troubleshooting](#troubleshooting) section
- Visit our [Support Forum](https://example.com/support)
- Contact support at support@example.com
```

### Changelog Template

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/2.0.0.html).

## [Unreleased]

### Added
- New features that have been added

### Changed
- Changes to existing functionality

### Deprecated
- Features that will be removed in future versions

### Removed
- Features that have been removed

### Fixed
- Bug fixes

### Security
- Security fixes and improvements

## [1.2.0] - 2025-01-15

### Added
- New data processing feature (#123)
- Support for bulk operations
- Export to CSV functionality

### Changed
- Improved performance of user queries (30% faster)
- Updated dependencies to latest versions
- Redesigned settings page for better UX

### Fixed
- Fixed permission check on admin pages (#145)
- Resolved race condition in batch processing
- Corrected email template formatting

### Security
- Added input sanitization for user-submitted data
- Updated authentication token handling

## [1.1.0] - 2024-12-01

### Added
- User profile enhancements
- Custom field support

### Fixed
- Database query optimization
- Cache invalidation issues

## [1.0.0] - 2024-11-01

Initial release

### Added
- Core data processing functionality
- Basic user management
- Admin interface
- REST API endpoints
- PHPUnit test coverage

[Unreleased]: https://github.com/org/repo/compare/1.2.0...HEAD
[1.2.0]: https://github.com/org/repo/compare/1.1.0...1.2.0
[1.1.0]: https://github.com/org/repo/compare/1.0.0...1.1.0
[1.0.0]: https://github.com/org/repo/releases/tag/1.0.0
```

## Generation Strategy

### 1. Gather Information

Ask clarifying questions:
- "What documentation type do you need?"
- "Who is the audience? (developers, end users, admins?)"
- "What specific features should be documented?"

### 2. Analyze Code

For API docs:
- Read function signatures
- Extract existing comments
- Identify dependencies
- Find usage examples

### 3. Structure Document

Follow standard patterns:
- Overview/introduction
- Prerequisites
- Main content (organized logically)
- Examples
- Troubleshooting
- Resources

### 4. Add Examples

Include:
- Code examples
- Screenshots (placeholder references)
- Before/after comparisons
- Common use cases

## Integration with CMS Cultivator

This skill complements the `/docs-generate` slash command:

- **This Skill**: Automatically triggered during conversation
  - "How do I document this function?"
  - "Need docs for this API"
  - Quick single-function documentation

- **`/docs-generate` Command**: Explicit batch generation
  - Generate full project documentation
  - Create comprehensive README
  - Build complete user guides

## Example Interactions

**Example 1: API documentation**
```
User: "I need to document this service class"
[Shows DataProcessor class]

Skill: "I'll generate API documentation for your DataProcessor service.
I see it has 3 public methods and uses dependency injection.
I'll create docblocks with:
- Class description
- Constructor documentation
- Method documentation with params and returns
- Usage examples

[Generates documented code]

This follows Drupal documentation standards with @param, @return,
and usage examples."
```

**Example 2: README**
```
User: "Need a README for my custom module"

Skill: "I'll create a comprehensive README for your module.
Let me check the project structure...

I see:
- Drupal 10 module
- Custom services
- Configuration forms
- Admin routes

I'll generate a README with:
- Installation via Composer
- Feature list
- Configuration steps
- API usage examples
- Links to extended docs

[Generates README.md]
```

## Best Practices

1. **Clear and Concise** - Write for your audience's level
2. **Examples** - Always include working code examples
3. **Up to Date** - Document current functionality, not planned features
4. **Structured** - Use consistent headings and format
5. **Searchable** - Include keywords users will search for
6. **Complete** - Cover common use cases and edge cases

## Resources

- [Write the Docs](https://www.writethedocs.org/)
- [Drupal Documentation Standards](https://www.drupal.org/docs/develop/coding-standards/api-documentation-and-comment-standards)
- [WordPress Inline Documentation Standards](https://developer.wordpress.org/coding-standards/inline-documentation-standards/)
- [Keep a Changelog](https://keepachangelog.com/)
