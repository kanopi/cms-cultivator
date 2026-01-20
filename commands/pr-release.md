---
description: Generate changelog, deployment checklist, and update PR for release using workflow specialist
argument-hint: "[version-or-focus]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git tag:*), Bash(git describe:*), Bash(gh pr view:*), Bash(gh pr view:*), Task
---

## Usage

- `/pr-release` - Generate all release artifacts (changelog, deploy checklist, update PR)
- `/pr-release changelog` - Focus on changelog generation only
- `/pr-release deploy` - Focus on deployment checklist only
- `/pr-release update` - Focus on updating PR description only
- `/pr-release 1.2.0` - Generate changelog for specific version

---

## How It Works

Spawn the **workflow-specialist** agent to handle the complete release preparation workflow:

```
Task(cms-cultivator:workflow-specialist:workflow-specialist,
     prompt="Prepare release artifacts for the current branch. User's focus: [use argument if provided, otherwise 'all']. Follow the complete release workflow: (1) Analyze changes since last release, categorize commits by conventional commit type, detect CMS-specific changes and deployment requirements, (2) Generate changelog following Keep a Changelog format, (3) Create comprehensive deployment checklist with pre/post checks and rollback plan, (4) Present FULL changelog, deployment checklist, and PR update recommendations to user for approval, (5) After approval, update PR description via gh CLI and provide artifacts for manual use.")
```

### Workflow Steps (Automated)

The workflow specialist automatically executes these steps:

#### 1. Analysis
- Parse argument (version number or focus area: changelog/deploy/update/all)
- Gather git context: current branch, last tag/version, commits since last tag
- Categorize commits by conventional commit type (feat, fix, breaking, etc.)
- Detect CMS-specific changes (Drupal config, WordPress ACF, migrations)
- Assess deployment complexity and recommend version bump (major/minor/patch)

#### 2. Changelog Generation
- Generate changelog entry following [Keep a Changelog](https://keepachangelog.com/) format
- Group changes by category (Added, Changed, Fixed, Security, Breaking, etc.)
- Include ticket numbers and references
- Add CMS-specific upgrade notes (Drupal/WordPress)
- Suggest semantic version number

#### 3. Deployment Checklist Generation
- Create comprehensive deployment plan:
  - Pre-deployment checks
  - Step-by-step deployment instructions
  - Post-deployment verification
  - Rollback plan
  - CMS-specific upgrade notes (Drupal: config import, WordPress: permalink flush)

#### 4. User Approval (CRITICAL)
- **Present full changelog** - Complete Keep a Changelog entry
- **Present deployment checklist** - All deployment steps
- **Present PR update recommendations** - Proposed changes to PR description
- **Wait for explicit approval** before proceeding
- Allow user to request edits or approve as-is

#### 5. PR Update
- Update PR description (if PR exists) with release information
- Provide release artifacts for manual use:
  - Changelog entry for CHANGELOG.md
  - Deployment checklist for ops team
  - Updated PR description

### Tool Usage

The workflow-specialist orchestrates all operations:
- Analyze git history and existing CHANGELOG.md
- Parse semantic versioning from commits and tags
- Generate semantic version-based changelog entries
- Create deployment checklists with CMS-specific steps
- Present full artifacts for user approval
- Update PR description via gh CLI (with user confirmation)
- Provide artifacts for manual use

**Prerequisites:**
- Current branch should be a release branch
- Commits should follow conventional commit format
- gh CLI must be installed and authenticated (for PR updates)

**Important notes:**
- This command generates artifacts but does NOT create git tags/releases
- Does NOT merge PR or deploy to production
- User is responsible for creating release tags after review

---

## Quick Start

```bash
# 1. Ensure you're on your release branch
git checkout release/1.2.0

# 2. Run this command
/pr-release

# Or specify version:
/pr-release 1.2.0

# Or focus on specific artifact:
/pr-release changelog
```

---

## Semantic Versioning Guidance

The workflow specialist suggests version numbers based on [Semantic Versioning](https://semver.org/):

**Major (X.0.0)** - Breaking changes:
- Incompatible API changes
- Removed functions/endpoints
- Database schema breaking changes
- Minimum dependency version increases

**Minor (1.X.0)** - New features (backwards-compatible):
- New functionality added
- New API endpoints
- Deprecated features (not removed)
- Optional new dependencies

**Patch (1.0.X)** - Bug fixes (backwards-compatible):
- Bug fixes
- Security patches
- Documentation updates
- Performance improvements (no API changes)

---

## Changelog Format

The workflow specialist generates changelogs in Keep a Changelog format:

```markdown
## [1.2.0] - 2025-01-15

### Added
- New event registration functionality allowing users to RSVP (#123)
- Custom Gutenberg block for event cards
- Cypress E2E tests for registration flow
- Google Maps integration with new env var: GOOGLE_MAPS_API_KEY

### Changed
- Updated user profile layout for mobile responsiveness (#145)
- Refactored event query for 30% performance improvement
- Updated Drupal core 10.1.0 → 10.2.1 (security update)

### Deprecated
- `get_event_location()` function (use `Event::getLocation()` in 2.0.0)

### Removed
- jQuery dependency from event calendar
- Legacy event templates

### Fixed
- Event date display bug in Safari (#156)
- Timezone handling for multi-timezone events (#167)
- PHP 8.2 deprecation warnings

### Security
- Patched XSS in event description field (SA-2024-001)
- Updated symfony/http-kernel for CVE-2024-12345
- Added CSRF token validation to registration form

### Drupal-Specific Upgrade Notes
- Run: `drush updatedb` for database updates
- Run: `drush config:import` for config changes
- Run: `drush entity:updates` if prompted
- Clear cache: `drush cache:rebuild`

### WordPress-Specific Upgrade Notes
- Flush permalinks: Settings > Permalinks > Save
- Re-sync ACF fields from acf-json/
- Clear object cache
- Regenerate thumbnails if image sizes changed

[Full Changelog](https://github.com/org/repo/compare/1.0.0...1.1.0)
```

---

## CMS-Specific Detection

### Drupal Projects

The workflow specialist detects and documents:

**Config Changes** (`config/sync/*.yml`):
- New configuration entities
- Modified field definitions
- Permission changes
- Deployment: `drush config:import`

**Database Updates** (`hook_update_N()`):
- Schema changes
- Data migrations
- Deployment: `drush updatedb`

**Module Changes**:
- New dependencies in `*.info.yml`
- Service definitions
- Route changes
- Deployment: Module enablement, cache clear

### WordPress Projects

The workflow specialist detects and documents:

**ACF Changes** (`acf-json/`):
- New field groups
- Modified fields
- Deployment: Re-sync ACF fields

**CPT/Taxonomy Changes**:
- New post types
- New taxonomies
- Deployment: Flush permalinks

**Theme Changes**:
- Template modifications
- New theme support
- Deployment: Clear object cache

**Database Migrations**:
- Custom table changes
- Deployment: Run WP-CLI migrations

---

## Focus Area Options

### `/pr-release changelog`
Generates only the changelog entry. Analyzes commits, categorizes by type, and formats per Keep a Changelog.

### `/pr-release deploy`
Generates only the deployment checklist. Includes pre-deployment checks, step-by-step instructions, and rollback plan.

### `/pr-release update`
Generates only PR description updates. Compares current PR description with actual changes and provides updated version.

### `/pr-release 1.2.0`
Generates full release artifacts for specific version number. Includes changelog, checklist, and PR updates.

### `/pr-release` (no argument)
Generates all three artifacts in a unified report. Prompts for version number if not determinable from branch/commits.

---

## Related Commands

- **[`/pr-create`](pr-create.md)** - Create initial PR
- **[`/pr-review`](pr-review.md)** - Review changes before release
- **[`/pr-commit-msg`](pr-commit-msg.md)** - Generate commit messages
