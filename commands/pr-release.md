---
description: Generate changelog, deployment checklist, and update PR for release using workflow specialist
argument-hint: [version-or-focus]
allowed-tools: Task
---

Spawn the **workflow-specialist** agent using:

```
Task(cms-cultivator:workflow-specialist:workflow-specialist,
     prompt="Prepare comprehensive release artifacts for the pull request. Include: changelog (Keep a Changelog format), deployment checklist (with CMS-specific steps), and PR description updates. User's focus: [use argument if provided, otherwise 'all']")
```

## Usage

- `/pr-release` - Generate all release artifacts (changelog, deploy checklist, update PR)
- `/pr-release changelog` - Focus on changelog generation only
- `/pr-release deploy` - Focus on deployment checklist only
- `/pr-release update` - Focus on updating PR description only
- `/pr-release 1.2.0` - Generate changelog for specific version

---

## How It Works

This command spawns the **workflow-specialist** agent, which orchestrates release preparation by:

1. **Analyzing changes** - Reviews commits since last release/tag
2. **Categorizing commits** - Groups by conventional commit type (feat, fix, etc.)
3. **Generating changelog** - Creates Keep a Changelog formatted entry
4. **Present changelog for your approval or edits** - Review and modify before proceeding
5. **Creating deployment checklist** - Platform-specific deployment steps
6. **Present checklist for your approval or edits** - Review and modify deployment steps
7. **Updating PR description** - Adds deploy notes and version info
8. **Present PR updates for your approval or edits** - Review final changes
9. **Recommending version bump** - Suggests major/minor/patch based on changes
10. **Create release PR with approved content** - Execute with all approved artifacts

### The Workflow Specialist Will Generate

**1. Changelog Entry** - Following [Keep a Changelog](https://keepachangelog.com/) format:
- Added - New features/functionality
- Changed - Updates to existing functionality
- Deprecated - Marked for future removal
- Removed - Deleted features/functionality
- Fixed - Bug fixes
- Security - Security-related changes

**2. Deployment Checklist** - Comprehensive deployment plan:
- Pre-deployment checks
- Step-by-step deployment instructions
- Post-deployment verification
- Rollback plan
- CMS-specific upgrade notes (Drupal/WordPress)

**3. PR Description Update** - Enhanced PR description with:
- Release version and date
- Changelog integration
- Deployment requirements
- Breaking changes warnings
- Migration steps

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

## Deployment Checklist Format

The workflow specialist generates platform-specific deployment checklists:

```markdown
# Deployment Checklist - [Version]

**Target Environment**: Production
**Estimated Downtime**: None/5min/30min
**Deployment Date**: YYYY-MM-DD

## Pre-Deployment
- [ ] All CI/CD checks passing
- [ ] Code reviewed and approved
- [ ] Backup database
- [ ] Backup codebase
- [ ] Review dependencies (composer.json, package.json)
- [ ] Run security audits (composer audit, npm audit)

## Deployment Steps
### 1. Enable Maintenance Mode
[Platform-specific commands]

### 2. Pull Latest Code
```bash
git pull origin main
git log -1  # Verify commit
```

### 3. Install/Update Dependencies
[If composer.json changed]
[If package.json changed]

### 4. Build Assets
[If frontend changes]

### 5. CMS-Specific Steps
**Drupal:**
- Import config: `drush config:import -y`
- Run updates: `drush updatedb -y`
- Entity updates: `drush entity:updates -y`
- Clear cache: `drush cache:rebuild`

**WordPress:**
- Run migrations: [specific migrations]
- Flush permalinks: `wp rewrite flush`
- Clear cache: `wp cache flush`

### 6. Environment Variables
[New variables needed]

### 7. Disable Maintenance Mode
[Platform-specific commands]

## Post-Deployment Verification
- [ ] Homepage loads
- [ ] Critical paths work
- [ ] No PHP errors in logs
- [ ] Automated tests pass
- [ ] Performance acceptable
- [ ] CMS status report clean

## Rollback Plan
[If deployment fails - step-by-step rollback]
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

## What the Workflow Specialist Analyzes

**Commit History:**
- All commits since last tag: `git log $(git describe --tags --abbrev=0)..HEAD`
- Or since branching: `git log origin/main..HEAD`

**File Changes:**
- Config files (Drupal/WordPress)
- Dependencies (composer.json, package.json)
- Database migrations and update hooks
- Template/theme changes

**Change Types:**
- Features (new functionality)
- Fixes (bug corrections)
- Breaking changes (incompatibilities)
- Security (vulnerabilities patched)
- Performance (optimizations)
- Deprecations (marked for removal)

**Deployment Requirements:**
- Database updates needed
- Config imports required
- Assets to rebuild
- Cache clearing
- Environment variables
- Module/plugin activations

---

## Output Format

When running `/pr-release` with no focus, the workflow specialist provides:

```markdown
# Release Preparation - [Version]

## 📋 CHANGELOG ENTRY
[Full Keep a Changelog formatted entry]

---

## 🚀 DEPLOYMENT CHECKLIST
[Complete deployment checklist with pre/post steps]

---

## 📝 PR DESCRIPTION UPDATE
**Current PR Description**: [If PR exists]
**Recommended Updates**: [What should change]
**Updated Description**: [Full updated version]

---

## NEXT STEPS
1. Review changelog - Verify categorization
2. Review checklist - Add project-specific steps
3. Update PR description - Apply changes if PR exists
4. Test on staging - Run checklist on staging first
5. Communicate - Notify team of deployment plan

**Ready to Deploy**: [✅ Yes | ⚠️ With cautions | ❌ Not ready]
```

---

## Best Practices

The workflow specialist follows industry standards:

1. **Changelog** - Write for humans, be specific, link to issues
2. **Version Numbers** - Strict semantic versioning
3. **Deployment** - Comprehensive steps, include rollback
4. **Communication** - Clear, actionable, prioritized
5. **Testing** - Test on staging before production

---

## Related Commands

- **[`/pr-create`](pr-create.md)** - Create initial PR
- **[`/pr-review`](pr-review.md)** - Review changes before release
- **[`/pr-commit-msg`](pr-commit-msg.md)** - Generate commit messages

## Agent Used

**workflow-specialist** - Orchestrates release artifact generation with changelog formatting, deployment planning, and PR description updates.

## What Makes This Different

**Before (manual release prep):**
- Manually write changelog from commits
- Create deployment checklist from memory
- Miss CMS-specific upgrade steps
- No version number guidance
- Inconsistent changelog format

**With workflow-specialist:**
- ✅ Automated changelog generation from commits
- ✅ Keep a Changelog compliant formatting
- ✅ Semantic versioning recommendations
- ✅ CMS-specific deployment steps detected
- ✅ Comprehensive pre/post deployment checks
- ✅ Rollback plan included
- ✅ PR description auto-updated
- ✅ Breaking changes highlighted
