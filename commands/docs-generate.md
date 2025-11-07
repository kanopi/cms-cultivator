---
description: Generate documentation (API, README, guides, changelog)
argument-hint: [type]
allowed-tools: Bash(git:*), Read, Glob, Grep, Write, Bash(ddev:*), Bash(ddev composer:*)
---

# Documentation Generator

Generate and maintain all project documentation including API docs, README, user guides, and changelogs.

## Usage

- `/docs-generate` - Analyze what documentation is missing/outdated
- `/docs-generate api` - Generate API documentation (PHPDoc, JSDoc)
- `/docs-generate readme` - Update README.md with current project info
- `/docs-generate changelog` - Generate changelog from git history
- `/docs-generate guide` - Generate all four guides (user, developer, deployment, admin) as MkDocs site
- `/docs-generate guide user` - Generate end-user guide (MkDocs format)
- `/docs-generate guide developer` - Generate developer/technical guide (MkDocs format)
- `/docs-generate guide deployment` - Generate deployment guide (MkDocs format)
- `/docs-generate guide admin` - Generate admin configuration guide (MkDocs format)

## Quick Start (Kanopi Projects)

### Accessing the Site for Documentation

When documenting Drupal or WordPress sites, you may need to access the site:

```bash
# Drupal - Get one-time login link
ddev drupal-uli

# Drupal - Open site in browser
ddev drupal-open

# WordPress - Restore admin user credentials
ddev wp-restore-admin-user

# WordPress - Open site in browser
ddev wp-open

# Both platforms - Open admin dashboard
ddev project-wp    # WordPress admin
```

### Generating API Documentation

For Kanopi projects, use these commands to generate API docs:

```bash
# PHP Documentation (both Drupal and WordPress)
ddev exec vendor/bin/phpdoc -d web/modules/custom -t docs/api    # Drupal
ddev exec vendor/bin/phpdoc -d web/wp-content/themes -t docs/api # WordPress

# JavaScript Documentation
ddev exec npx jsdoc web/themes/custom/js -r -d docs/js-api      # Drupal theme
ddev exec npx jsdoc web/wp-content/themes/*/js -r -d docs/js-api # WordPress theme
```

### README Development Setup Section

When updating README.md for Kanopi projects, include these DDEV commands:

**Example README Section**:
```markdown
## Development Setup

1. Clone the repository
2. Start the development environment:
   ```bash
   ddev start
   ```

3. Install dependencies:
   ```bash
   ddev composer install
   ddev theme-install  # Install theme dependencies
   ```

4. Import database (if available):
   ```bash
   ddev db-refresh  # Pull from Pantheon
   ```

5. Build theme assets:
   ```bash
   ddev theme-build     # Production build
   ddev theme-watch     # Development mode
   ```

6. Access the site:
   - Drupal: `ddev drupal-uli` for login link
   - WordPress: `ddev wp-restore-admin-user` for admin credentials
```

---

## Documentation Types

### 1. API Documentation (`api`)

Generate comprehensive API documentation for custom code.

**Drupal:**
- Services (dependency injection)
- Hooks (hook implementations)
- Plugins (plugin definitions)
- Controllers, Forms, Entities
- Twig extensions

**WordPress:**
- Actions and Filters
- Shortcodes
- REST API endpoints
- Template tags
- Widget classes

**JavaScript:**
- Functions and classes
- React/Vue components
- jQuery plugins
- Event handlers

**Output:** PHPDoc/JSDoc formatted documentation with examples

See full documentation in original `/docs-api.md`

---

### 2. README (`readme`)

Update or generate README.md with current project information.

**Includes:**
- Project description
- Installation instructions
- Configuration details
- Development setup
- Testing procedures
- Deployment process
- Contributing guidelines
- Recent changes

**Analyzes:**
- Git commits (recent features)
- Package files (dependencies)
- Project structure
- Environment setup

**Output:** Complete README.md file

See full documentation in original `/docs-readme.md`

---

### 3. Changelog (`changelog`)

Generate changelog from git commit history.

**Format:** Keep a Changelog standard

**Sections:**
- **Added** - New features
- **Changed** - Changes in existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Security vulnerability fixes

**Detects:**
- Conventional Commits (feat:, fix:, etc.)
- Breaking changes
- Version tags
- Security updates

**Output:** CHANGELOG.md file

See full documentation in original `/docs-changelog.md`

---

### 4. Guides (`guide [type]`)

Generate comprehensive documentation for different audiences as **MkDocs-formatted pages**.

**Important:** All guide documentation is generated in **MkDocs format** and placed in the `docs/` directory. If `mkdocs.yml` exists, the command will automatically add the new pages to the navigation.

#### Generate All Guides (`guide`)

Generates all four guides at once:

```bash
/docs-generate guide
```

**Creates:**
- `docs/guides/user-guide.md` - User guide
- `docs/guides/developer-guide.md` - Developer guide
- `docs/guides/deployment-guide.md` - Deployment guide
- `docs/guides/admin-guide.md` - Admin guide
- Updates `mkdocs.yml` navigation (if it exists)

#### User Guide (`guide user`)
**Audience:** Content editors, site administrators
**Output:** `docs/guides/user-guide.md` (MkDocs format)

**Includes:**
- Getting started
- Logging in and dashboard
- Creating/editing content
- Managing media
- Publishing workflows
- Common tasks
- Troubleshooting
- FAQ

#### Developer Guide (`guide developer`)
**Audience:** Developers, technical leads
**Output:** `docs/guides/developer-guide.md` (MkDocs format)

**Includes:**
- Architecture overview
- Development environment setup
- Coding standards
- Git workflow
- Testing procedures
- API documentation
- Common development tasks
- Debugging techniques

#### Deployment Guide (`guide deployment`)
**Audience:** DevOps engineers, deployment managers
**Output:** `docs/guides/deployment-guide.md` (MkDocs format)

**Includes:**
- Deployment prerequisites
- Environment configuration
- Deployment procedures (staging/production)
- Rollback procedures
- Post-deployment verification
- Troubleshooting deployments

#### Admin Guide (`guide admin`)
**Audience:** Site administrators, system administrators
**Output:** `docs/guides/admin-guide.md` (MkDocs format)

**Includes:**
- Initial configuration
- User and permission management
- Security configuration
- Performance optimization
- Maintenance procedures
- Monitoring and logging

### MkDocs Integration

When generating guides, the command will:

1. **Create `docs/guides/` directory** if it doesn't exist
2. **Generate markdown files** in MkDocs-compatible format with proper frontmatter
3. **Update `mkdocs.yml`** navigation automatically (if file exists):

```yaml
nav:
  - Home: index.md
  - Guides:
    - User Guide: guides/user-guide.md
    - Developer Guide: guides/developer-guide.md
    - Deployment Guide: guides/deployment-guide.md
    - Admin Guide: guides/admin-guide.md
```

4. **Use MkDocs extensions** like admonitions, code highlighting, and tabbed content
5. **Include cross-references** between guides and other documentation

**Example generated guide structure:**

```markdown
# User Guide

## Getting Started

!!! note "Prerequisites"
    Before you begin, ensure you have access credentials.

### Logging In

=== "Drupal"
    Navigate to `/user/login` and enter your credentials.

=== "WordPress"
    Navigate to `/wp-admin` and enter your credentials.

## Creating Content

...
```

---

## Running Documentation Analysis

When run without arguments, analyzes documentation status:

```bash
/docs-generate
```

**Output:**

```markdown
# Documentation Status Report

**Project**: MyProject
**Date**: 2024-01-15

## Summary

| Documentation | Status | Last Updated | Priority |
|---------------|--------|--------------|----------|
| README.md | 🟡 Outdated | 6 months ago | High |
| CHANGELOG.md | 🔴 Missing | Never | High |
| API Docs | 🟠 Incomplete | 3 months ago | Medium |
| User Guide | 🟢 Current | 2 weeks ago | Low |
| Developer Guide | 🔴 Missing | Never | High |

## Recommendations

### High Priority (This Week)
1. ✅ Update README.md - Project structure changed
2. ✅ Generate CHANGELOG.md - No changelog for last 3 releases
3. ✅ Create Developer Guide - Needed for onboarding

### Medium Priority (This Month)
4. Complete API documentation (67% coverage)
5. Update User Guide screenshots
6. Add deployment troubleshooting section

### Low Priority (Next Quarter)
7. Add video tutorials
8. Translate documentation
9. Create architecture diagrams

## Missing Documentation

### Critical APIs Without Documentation
- `DataProcessor::processPayment()` - No docblock
- `UserService::authenticateUser()` - No examples
- `ApiController::createUser()` - No parameter docs

### Outdated Sections
- README.md installation steps (DDEV not mentioned)
- User Guide uses old UI screenshots
- Developer Guide references Drupal 9 (now on 10)

## Recent Changes Not Documented
- Added 2FA authentication (3 weeks ago)
- New REST API endpoints (2 weeks ago)
- Performance improvements (1 week ago)
```

## Complete Documentation Workflow

Generate all documentation at once:

```bash
# Analyze what's needed
/docs-generate

# Generate everything
/docs-generate api           # API documentation
/docs-generate readme        # Project README
/docs-generate changelog     # Version changelog
/docs-generate guide         # All 4 guides in MkDocs format

# Or generate guides individually
/docs-generate guide user
/docs-generate guide developer
/docs-generate guide deployment
/docs-generate guide admin
```

**For MkDocs Sites:**

After generating guides, build and preview your documentation:

```bash
# Build documentation site
mkdocs build

# Preview documentation locally
mkdocs serve
# Visit http://localhost:8000

# Deploy to GitHub Pages
mkdocs gh-deploy
```

## Smart Updates

The command detects what needs updating:

**README Updates:**
- New dependencies added
- Configuration format changed
- Installation steps modified
- New features added

**API Docs Updates:**
- New public methods
- Changed function signatures
- Deprecated functions
- Missing docblocks

**Changelog Updates:**
- Commits since last release
- Breaking changes
- Security fixes
- New features

## Integration with Other Commands

**Documentation in PR Workflow:**
```bash
/pr-review self             # Review changes before PR
/docs-generate changelog    # Update changelog
/docs-generate api          # Update API docs for new code
/pr-create                  # Create PR with docs
```

**Release Documentation:**
```bash
/docs-generate changelog    # Generate changelog entry
/docs-generate readme       # Update README with new version
/pr-release                 # Create release PR
```

## Best Practices

1. **Document as You Code** - Add docblocks when writing functions
2. **Update with Changes** - Run `/docs-generate readme` after major changes
3. **Changelog Every Release** - Use `/docs-generate changelog` for each version
4. **Review Regularly** - Check documentation status monthly
5. **Keep Examples Current** - Update code examples when APIs change
6. **Version Documentation** - Tag documentation with releases

## Configuration

### Documentation Standards

**PHP (Drupal/WordPress):**
```php
/**
 * Brief description.
 *
 * Detailed description with context.
 *
 * @param string $param1
 *   Description of parameter.
 * @param array $options
 *   Array of options with keys:
 *   - key1: (string) Description.
 *   - key2: (int) Description.
 *
 * @return mixed
 *   Description of return value.
 *
 * @throws \Exception
 *   When something goes wrong.
 *
 * @see related_function()
 *
 * @example
 * @code
 * $result = my_function('value', ['key1' => 'test']);
 * @endcode
 */
```

**JavaScript:**
```javascript
/**
 * Brief description.
 *
 * Detailed description.
 *
 * @param {string} param1 - Description.
 * @param {Object} options - Configuration options.
 * @param {string} options.key1 - Description.
 * @returns {Promise<Object>} Description.
 * @throws {Error} When something goes wrong.
 *
 * @example
 * myFunction('value', { key1: 'test' })
 *   .then(result => console.log(result));
 */
```

## Automated Tools

### API Documentation
```bash
# PHP
composer require --dev phpdocumentor/phpdocumentor
vendor/bin/phpdoc -d web/modules/custom -t docs/api

# JavaScript
npm install --save-dev jsdoc
npx jsdoc web/themes/custom/js -r -d docs/js-api
```

### Changelog
```bash
# Conventional Changelog
npm install -g conventional-changelog-cli
conventional-changelog -p angular -i CHANGELOG.md -s
```

## Resources

- [PHPDoc Documentation](https://phpdoc.org/)
- [JSDoc Documentation](https://jsdoc.app/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Drupal API Documentation Standards](https://www.drupal.org/docs/develop/coding-standards/api-documentation-and-comment-standards)
- [WordPress Inline Documentation Standards](https://developer.wordpress.org/coding-standards/inline-documentation-standards/)
- [Write the Docs](https://www.writethedocs.org/)
