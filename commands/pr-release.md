---
description: Generate changelog, deployment checklist, and update PR for release
argument-hint: [version-or-focus]
allowed-tools: Bash(git:*), Bash(gh:*), Read, Glob
---

You are helping prepare a pull request for release. This command combines changelog generation, deployment checklist creation, and PR description updates.

## Usage

- `/pr-release` - Generate all release artifacts (changelog, deploy checklist, update PR)
- `/pr-release changelog` - Focus on changelog generation only
- `/pr-release deploy` - Focus on deployment checklist only
- `/pr-release update` - Focus on updating PR description only
- `/pr-release v1.2.0` - Generate changelog for specific version

## Step 1: Analyze Changes

Gather commit and change information:

```bash
# Get commits since last tag or since branching
git log $(git describe --tags --abbrev=0)..HEAD --oneline
# OR
git log origin/main..HEAD --oneline

# Get detailed changes
git diff origin/main..HEAD --stat
git diff origin/main..HEAD

# Check for specific change types
git diff origin/main..HEAD config/sync/  # Drupal config
git diff origin/main..HEAD acf-json/    # WordPress ACF
git diff origin/main..HEAD composer.json
git diff origin/main..HEAD package.json
```

## Release Artifacts

### 1. CHANGELOG GENERATION

#### Categorize Changes (Keep a Changelog Format)

**Added** - New features/functionality:
- New user-facing features
- New API endpoints
- New configuration options
- New dependencies

**Changed** - Updates to existing functionality:
- Updates to features
- Refactored code
- Updated dependencies
- Modified configurations

**Deprecated** - Marked for future removal:
- Deprecated functions
- Deprecated APIs
- Deprecated config options

**Removed** - Deleted features/functionality:
- Removed functions
- Removed API endpoints
- Removed dependencies

**Fixed** - Bug fixes:
- Bug fixes
- Error corrections
- Typo fixes

**Security** - Security-related changes:
- Security vulnerabilities patched
- Security enhancements
- Auth/authorization fixes

#### Version Number Guidance

If version not provided, suggest based on Semantic Versioning:
- **Major (X.0.0)**: Breaking changes, incompatible API changes
- **Minor (1.X.0)**: New features, backwards-compatible
- **Patch (1.0.X)**: Bug fixes, backwards-compatible

#### Generate Changelog Entry

```markdown
## [VERSION] - YYYY-MM-DD

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
- `get_event_location()` function (use `Event::getLocation()` in v2.0.0)

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

[Full Changelog](https://github.com/org/repo/compare/v1.0.0...v1.1.0)
```

---

### 2. DEPLOYMENT CHECKLIST

#### Detect Project Type & Changes

Identify:
- Drupal or WordPress project
- Config changes (Drupal config, ACF JSON)
- Database changes (migrations, update hooks)
- Dependencies (composer.json, package.json)
- Assets (CSS/JS requiring rebuild)
- Environment variables
- Cypress tests

#### Generate Comprehensive Checklist

```markdown
# Deployment Checklist - [PR Title]

**PR**: #[number]
**Target Environment**: [Production/Staging]
**Estimated Downtime**: [None/5min/30min]
**Deployment Date**: YYYY-MM-DD
**Deployed By**: _______________

---

## Pre-Deployment Checklist

### Code Preparation
- [ ] All CI/CD checks passing
- [ ] Code reviewed and approved
- [ ] PR merged to main
- [ ] No merge conflicts
- [ ] All tests passing
- [ ] Cypress tests passing (if applicable)

### Environment Preparation
- [ ] Backup database
- [ ] Backup codebase
- [ ] Verify disk space
- [ ] Check server resources
- [ ] Notify team of deployment window
- [ ] Set maintenance mode if needed

### Dependencies
- [ ] Review composer.json changes
- [ ] Review package.json changes
- [ ] Run: composer audit / npm audit
- [ ] Verify PHP/Node version compatibility

### Drupal-Specific Pre-Deployment
- [ ] Verify config changes: git diff origin/main..HEAD config/sync/
- [ ] Check for database updates in .install files
- [ ] Review entity/field changes
- [ ] Check hook_update_N() implementations

### WordPress-Specific Pre-Deployment
- [ ] Check ACF field changes in acf-json/
- [ ] Review CPT/taxonomy changes
- [ ] Verify template changes
- [ ] Check for database migrations

---

## Deployment Steps

### 1. Enable Maintenance Mode
```bash
# Drupal
drush state:set system.maintenance_mode 1 --input-format=integer
drush cr

# WordPress
wp maintenance-mode activate
```

### 2. Pull Latest Code
```bash
git fetch origin
git checkout main
git pull origin main
git log -1  # Verify correct commit
```

### 3. Install/Update Dependencies

**If composer.json changed:**
```bash
composer install --no-dev --optimize-autoloader
```

**If package.json changed:**
```bash
npm ci
```

### 4. Build Assets
**If frontend changes:**
```bash
npm run build
# or
npm run production
```

### 5. Drupal Deployment
**If Drupal:**
```bash
# Import configuration
drush config:import -y

# Run database updates
drush updatedb -y

# Run entity updates
drush entity:updates -y

# Rebuild cache
drush cache:rebuild
```

### 6. WordPress Deployment
**If WordPress:**
```bash
# Run migrations (if exist)
[specific migration commands]

# Flush permalinks (if CPT/tax changes)
wp rewrite flush

# Clear cache
wp cache flush
```

### 7. Environment Variables
**If new env vars:**
```
[List specific variables to add]
GOOGLE_MAPS_API_KEY=your_key_here
```

### 8. Disable Maintenance Mode
```bash
# Drupal
drush state:set system.maintenance_mode 0 --input-format=integer
drush cr

# WordPress
wp maintenance-mode deactivate
```

---

## Post-Deployment Verification

### Automated Checks
- [ ] Run smoke tests
- [ ] Run Cypress: npm run cypress:run
- [ ] Check homepage loads
- [ ] Verify critical paths work
- [ ] Check error logs

### Manual Verification
- [ ] Test specific functionality changed
- [ ] Verify affected URLs
- [ ] Test as different user roles
- [ ] Check responsive design
- [ ] Verify forms work
- [ ] Check email notifications

### Drupal Verification
- [ ] Config clean: drush config:status
- [ ] No pending updates: drush updatedb:status
- [ ] No entity updates: drush entity:updates
- [ ] Status report: /admin/reports/status

### WordPress Verification
- [ ] Site Health: /wp-admin/site-health.php
- [ ] Permalinks working
- [ ] ACF fields display correctly
- [ ] CPTs accessible

### Performance
- [ ] Page load times acceptable
- [ ] No PHP errors/warnings
- [ ] Database queries performant
- [ ] Caching working

---

## Rollback Plan

If deployment fails:
```bash
# 1. Enable maintenance mode

# 2. Revert code
git reset --hard [previous-commit]

# 3. Restore database from backup (if needed)

# 4. Clear caches

# 5. Disable maintenance mode
```

---

## Sign-Off

**Deployed By**: _____________
**Date/Time**: _____________
**Deployment Status**: [ ] Success [ ] Failed [ ] Rolled Back
**Issues**: _____________
```

---

### 3. PR DESCRIPTION UPDATE

If PR already exists and needs updating based on new changes:

#### Detect What Changed

```bash
# Get current PR
gh pr view <pr-number>

# Compare current description with actual changes
gh pr view <pr-number> --json body

# Check for new commits/changes
git log origin/main..HEAD --oneline
```

#### Update PR Description

Generate updated description following the same template as `/pr-desc`:

```markdown
## Description
[Updated comprehensive summary]

## Acceptance Criteria
- [ ] [Updated/new criteria]

## Assumptions
[Any new assumptions]

## Steps to Validate
1. [Updated validation steps]

## Affected URL
- [URLs where changes visible]

## Deploy Notes

### Pre-deployment
- [ ] [Pre-deploy steps]

### Deployment Steps
[Updated based on actual changes - Drupal/WordPress specific]

### Post-deployment
- [ ] [Post-deploy verification]

### Rollback Plan
[Updated rollback procedure]
```

#### Show Changes & Confirm

```markdown
## Current PR Description
[Show existing]

---

## Proposed Updated Description
[Show new with changes highlighted]

---

## Summary of Changes
- Added: [What was added to description]
- Updated: [What was modified]
- Removed: [What was removed]
```

Ask: "Would you like me to update the PR with these changes?"

If approved:
```bash
gh pr edit <pr-number> --body "$(cat <<'EOF'
[Updated description]
EOF
)"
```

---

## Combined Output Format

When running `/pr-release` with no arguments, provide all three artifacts:

```markdown
# Release Preparation - [PR Title / Version]

## 📋 CHANGELOG ENTRY

[Full changelog as detailed above]

---

## 🚀 DEPLOYMENT CHECKLIST

[Full deployment checklist as detailed above]

---

## 📝 PR DESCRIPTION UPDATE

**Current PR Description**:
[Show current if PR exists]

**Recommended Updates**:
[List what should be updated in PR description]

**Updated Description**:
[Show full updated description]

---

## NEXT STEPS

1. **Review changelog entry** - Verify categorization is accurate
2. **Review deployment checklist** - Add project-specific steps
3. **Update PR description** - Apply changes if PR already exists
4. **Test deployment** - Run checklist on staging first
5. **Communicate** - Notify team of deployment plan

**Ready to Deploy**: [✅ Yes | ⚠️ With cautions | ❌ Not ready]
```

## Focus Area Execution

### `/pr-release changelog`
Output only the changelog entry section

### `/pr-release deploy`
Output only the deployment checklist section

### `/pr-release update`
Output only the PR description update section

### `/pr-release v1.2.0`
Generate changelog for specific version number provided

### `/pr-release` (no argument)
Output all three sections in combined report

## Best Practices

1. **Changelog**: Write for humans, be specific, link to issues
2. **Deployment**: Be comprehensive, include rollback plan
3. **PR Updates**: Keep accurate, reflect actual changes
4. **Version Numbers**: Follow semantic versioning strictly
5. **Communication**: Notify team early about deployments

## Industry Standards

- **Keep a Changelog**: https://keepachangelog.com/
- **Semantic Versioning**: https://semver.org/
- **Deployment Best Practices**: Test on staging first, have rollback ready

Remember: Good release preparation prevents production incidents. Take time to be thorough.
