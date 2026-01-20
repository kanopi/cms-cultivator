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

## Phase 1: Analysis

**Goal**: Understand changes since last release

**Tool Usage in this phase:**
- ✅ Gather git context (current branch, tags, commits, PR info)
- ✅ Run git log and git diff to analyze changes
- ✅ Detect CMS-specific changes (config, migrations, etc.)
- ✅ Categorize commits by conventional commit type
- ❌ Do not generate changelog yet
- ❌ Do not update PR yet

Spawn the **workflow-specialist** agent with:

```
Task(cms-cultivator:workflow-specialist:workflow-specialist,
     prompt="Analyze changes for release preparation. First, gather git context: current branch, last tag/version, commits since last tag, recent commits, and current PR status. Review commits since last tag, categorize by conventional commit type (feat, fix, breaking), detect CMS-specific changes (Drupal config, WordPress ACF), and assess deployment requirements. User's focus: [use argument if provided, otherwise 'all']. DO NOT generate release artifacts yet - this is analysis phase only.")
```

The workflow specialist will:
1. Analyze commit history since last tag
2. Categorize commits (Added, Changed, Fixed, Security, Breaking, etc.)
3. Detect CMS-specific changes (config, migrations, dependencies)
4. Assess deployment complexity
5. Recommend version bump (major/minor/patch)

## Phase 2: Changelog Generation

**Goal**: Create Keep a Changelog formatted entry

**Tool Usage in this phase:**
- ✅ Generate changelog from analyzed commits
- ✅ Format per Keep a Changelog specification
- ✅ Include semantic versioning recommendation
- ❌ Do not update PR yet
- ❌ Do not create tags

The workflow specialist will:
1. Generate changelog entry following [Keep a Changelog](https://keepachangelog.com/) format
2. Group changes by category (Added, Changed, Fixed, Security, etc.)
3. Include ticket numbers and references
4. Add CMS-specific upgrade notes
5. Suggest semantic version number

## Phase 3: Deployment Checklist Generation

**Goal**: Create comprehensive deployment plan

**Tool Usage in this phase:**
- ✅ Generate platform-specific deployment steps
- ✅ Include pre/post deployment checks
- ✅ Create rollback plan
- ❌ Do not deploy anything
- ❌ Do not update PR yet

The workflow specialist will:
1. Create deployment checklist with:
   - Pre-deployment checks
   - Step-by-step deployment instructions
   - Post-deployment verification
   - Rollback plan
   - CMS-specific upgrade notes (Drupal/WordPress)

## Phase 4: Review & Approval

**CRITICAL - DO NOT SKIP**

**Goal**: Get user approval before updating PR

The workflow specialist will:
1. **Present full changelog** - Complete Keep a Changelog entry
2. **Present deployment checklist** - All deployment steps
3. **Present PR update recommendations** - Proposed changes to PR description

4. **Ask user**: "Ready to update PR with these release artifacts? You can request edits or approve."

5. **Wait for explicit approval** - Do not proceed without user confirmation

**Tool Usage in this phase:**
- ✅ Display generated artifacts to user
- ✅ Wait for approval
- ❌ Do not update PR without approval
- ❌ Do not create tags

## Phase 5: PR Update

**DO NOT START WITHOUT USER APPROVAL**

**Goal**: Update PR description with release information

After user approval, the workflow specialist will:
1. **Update PR description** (if PR exists) with:
   - Release version and date
   - Changelog integration
   - Deployment requirements
   - Breaking changes warnings
   - Migration steps

2. **Provide release artifacts** for manual use:
   - Changelog entry for CHANGELOG.md
   - Deployment checklist for ops team
   - Updated PR description

**Tool Usage in this phase:**
- ✅ Update PR description via gh CLI (with user permission)
- ✅ Provide artifacts for manual copying
- ❌ Do not create release tags (user responsibility)
- ❌ Do not merge or deploy

---

## Tool Usage

**Allowed operations:**
- ✅ Spawn workflow-specialist agent (orchestrator)
- ✅ Analyze git history and existing CHANGELOG.md
- ✅ Generate semantic version-based changelog entries
- ✅ Create deployment checklists with CMS-specific steps
- ✅ Update PR description via gh CLI (with user confirmation)
- ✅ Parse semantic versioning from commits and tags

**Not allowed:**
- ❌ Do not create git tags or releases (user responsibility after review)
- ❌ Do not merge PR or deploy to production
- ❌ Do not modify code files
- ❌ Do not commit changes (provide artifacts for review)

The workflow-specialist orchestrates all release preparation operations.

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
