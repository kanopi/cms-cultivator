---
description: Generate documentation (API, README, guides, changelog)
argument-hint: [type]
allowed-tools: Bash(git:*), Read, Glob, Grep, Write, Bash(ddev:*), Bash(ddev composer:*)
---

# Generate Documentation

Generate API documentation, README files, user guides, developer guides, and changelogs.

## Quick Start

```bash
# Generate all documentation
/docs-generate

# Generate specific documentation types
/docs-generate api       # API docblocks
/docs-generate readme    # README.md
/docs-generate changelog # CHANGELOG.md
/docs-generate guide user      # User guide
/docs-generate guide developer # Developer guide
```

## How It Works

This command uses the **documentation-generator** Agent Skill to create documentation.

**For complete templates and examples**, see:
→ [`skills/documentation-generator/SKILL.md`](../skills/documentation-generator/SKILL.md)

The skill provides detailed instructions for:
- Generating API documentation (docblocks, parameter docs)
- Creating README files with installation and usage
- Writing user guides with screenshots and examples
- Producing developer guides with architecture info
- Maintaining changelogs following Keep a Changelog format

## When to Use

**Use this command (`/docs-generate`)** when:
- ✅ Need comprehensive project documentation
- ✅ Creating documentation for multiple components
- ✅ Setting up documentation structure
- ✅ Batch documentation generation

**The skill auto-activates** when you say:
- "I need to document this API"
- "How do I write a README?"
- "Need docblocks for this class"

## Documentation Types

### API Documentation
Complete docblocks for classes, methods, and functions
- Parameter descriptions with types
- Return value documentation
- Exception documentation
- Usage examples
- Platform-specific (Drupal/WordPress)

### README Files
Project overview and getting started
- Installation instructions
- Quick start guide
- Feature list
- Configuration
- Usage examples

### User Guides
End-user documentation
- Step-by-step instructions
- Screenshots and examples
- Common tasks
- Troubleshooting
- FAQs

### Developer Guides
Technical documentation for contributors
- Architecture overview
- Setup and development
- Coding standards
- Contributing guidelines

### Changelogs
Version history following Keep a Changelog
- Semantic versioning
- Added/Changed/Deprecated/Removed/Fixed/Security sections
- Migration guides

## Example: API Documentation

**Before** (undocumented):
```php
public function processData($data) {
  // Implementation
}
```

**After** (documented):
```php
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
 * @code
 * $raw_data = ['name' => 'John Doe', 'email' => 'john@example.com'];
 * $processed = $processor->processData($raw_data);
 * @endcode
 */
public function processData(array $data): array {
  // Implementation
}
```

## Related Commands

- **[`/test-generate`](test-generate.md)** - Generate tests for documented code
- **[`/pr-release`](pr-release.md)** - Generate release notes and changelog
- **[`/quality-analyze`](quality-analyze.md)** - Analyze documentation coverage

## Resources

- [Write the Docs](https://www.writethedocs.org/)
- [Drupal Documentation Standards](https://www.drupal.org/docs/develop/coding-standards/api-documentation-and-comment-standards)
- [WordPress Documentation Standards](https://developer.wordpress.org/coding-standards/inline-documentation-standards/)
- [Keep a Changelog](https://keepachangelog.com/)
- [documentation-generator Agent Skill](../skills/documentation-generator/SKILL.md)
