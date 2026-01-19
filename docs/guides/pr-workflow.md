# Pull Request Workflow Guide

This guide walks through the complete PR workflow using CMS Cultivator, from creating commits to reviewing and releasing code.

---

## Overview

The PR workflow consists of four main stages:

1. **Commit Creation** - Generate conventional commit messages
2. **PR Creation** - Create pull requests with auto-generated descriptions
3. **Release Management** - Generate changelogs and release documentation
4. **Code Review** - Review your own code or others' PRs

---

## Stage 1: Creating Commits

### Use `/pr-commit-msg`

As you work on your feature, create meaningful commits along the way using `/pr-commit-msg`.

**Workflow:**

```bash
# 1. Make changes to your code
# ... edit files ...

# 2. Stage the changes you want to commit
git add src/components/LoginForm.jsx
git add tests/LoginForm.test.js

# 3. Generate a commit message
/pr-commit-msg
```

**What it does:**
- Analyzes your staged changes with `git diff --staged`
- Generates a conventional commit message following the format: `type(scope): description`
- Follows your project's existing commit style
- Includes detailed body text explaining the changes

**Example output:**

```
feat(auth): add remember-me functionality to login form

- Add persistent session cookie option
- Update login form UI with checkbox
- Add tests for remember-me flow
- Update authentication service to handle long-lived sessions
```

**Tips:**
- Create **small, focused commits** - easier to review and revert if needed
- Stage related changes together - don't mix unrelated fixes
- Commit frequently as you complete logical units of work
- Use the generated message as-is or edit to add context

### Conventional Commit Types

The workflow specialist generates commits following [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, missing semicolons)
- `refactor:` - Code refactoring (no functional changes)
- `perf:` - Performance improvements
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks (dependencies, build config)

**Example workflow:**

```bash
# Feature development
git add src/features/notifications/
/pr-commit-msg
# Generates: feat(notifications): add real-time notification system
git commit -m "[paste generated message]"

# Bug fix
git add src/utils/dateFormatter.js
/pr-commit-msg
# Generates: fix(utils): correct timezone handling in date formatter
git commit -m "[paste generated message]"

# Tests
git add tests/notifications.test.js
/pr-commit-msg
# Generates: test(notifications): add unit tests for notification delivery
git commit -m "[paste generated message]"

# Documentation
git add README.md docs/api/notifications.md
/pr-commit-msg
# Generates: docs(api): document notification system endpoints
git commit -m "[paste generated message]"
```

---

## Stage 2: Creating Pull Requests

### Use `/pr-create [ticket-number]`

When your feature branch is ready, create a pull request with an auto-generated description.

**Workflow:**

```bash
# 1. Ensure all changes are committed
git status

# 2. Push your branch to remote
git push origin feature/user-notifications

# 3. Create the PR
/pr-create PROJ-123
```

**What it does:**
- Analyzes all commits in your branch since it diverged from main
- Detects the type of changes (features, fixes, refactoring)
- Identifies platform-specific changes (Drupal/WordPress)
- Detects configuration changes, database updates, schema changes
- Generates comprehensive PR description
- Creates the PR on GitHub using `gh` CLI

**Generated PR description includes:**

1. **Summary** - Overview of what changed and why
2. **Changes** - Detailed list of modifications
3. **Type of Change** - Feature, bug fix, refactoring, etc.
4. **Testing** - How to test the changes
5. **Checklist** - Pre-merge checklist items
6. **Platform-Specific Notes**:
   - **Drupal**: Configuration changes, database updates, module dependencies
   - **WordPress**: Theme changes, plugin dependencies, ACF fields
7. **Breaking Changes** - If any exist
8. **Deployment Notes** - Special deployment considerations

**Example:**

```bash
/pr-create PROJ-123

# Analyzes commits:
# - feat(auth): add remember-me functionality
# - fix(auth): correct session cookie expiration
# - test(auth): add remember-me test coverage
# - docs(auth): document remember-me feature

# Generates PR:
# Title: "feat(auth): Add remember-me functionality [PROJ-123]"
# Description: [comprehensive multi-section description]
# Creates PR via gh CLI
```

**Customizing the PR:**

After creation, you can:
- Edit the description on GitHub if needed
- Add reviewers, labels, milestones
- Link to related issues

**Tips:**
- Include the ticket number so it's automatically linked
- Review the generated description before the PR is created
- The command analyzes **all commits** in your branch, not just the latest one
- Make sure your branch is pushed before running the command

---

## Stage 3: Release Management

### Use `/pr-release`

For projects that use release PRs, generate changelog and release documentation.

**When to use:**
- Preparing for a versioned release (v1.2.0, v2.0.0, etc.)
- Creating release branches
- Updating CHANGELOG.md
- Generating deployment documentation

**Workflow:**

```bash
# 1. Switch to release branch
git checkout -b release/v1.2.0

# 2. Generate release documentation
/pr-release

# Or focus on specific aspects:
/pr-release changelog      # Just the changelog
/pr-release deploy         # Deployment checklist
/pr-release breaking       # Breaking changes analysis
```

**What it does:**
- Analyzes git history since last release tag
- Generates changelog following [Keep a Changelog](https://keepachangelog.com/) format
- Groups changes by type (Added, Changed, Fixed, Deprecated, Removed, Security)
- Creates deployment checklist
- Identifies breaking changes
- Suggests migration steps
- Generates release PR description

**Generated changelog example:**

```markdown
## [1.2.0] - 2025-01-19

### Added
- Real-time notification system with WebSocket support
- User preferences panel for notification settings
- Email notification templates

### Changed
- Updated authentication flow to support remember-me
- Improved session management performance
- Refactored notification delivery system

### Fixed
- Session cookie expiration on remember-me login
- Timezone handling in date formatter
- Memory leak in notification polling

### Security
- Fixed XSS vulnerability in notification messages
- Updated authentication library to v2.1.0
```

**Deployment checklist example:**

```markdown
## Deployment Checklist

### Pre-Deployment
- [ ] Run database migrations
- [ ] Clear application cache
- [ ] Update environment variables (see .env.example)
- [ ] Backup database

### Deployment Steps
1. Deploy code to staging
2. Run `drush updb -y` (Drupal) or `wp migration run` (WordPress)
3. Clear caches
4. Test notification system
5. Deploy to production
6. Monitor logs for errors

### Post-Deployment
- [ ] Verify notifications are working
- [ ] Check WebSocket connections
- [ ] Monitor performance metrics
- [ ] Send test notifications

### Rollback Plan
If issues occur:
1. Revert to previous release tag
2. Restore database backup
3. Clear caches
```

**Tips:**
- Run this on a dedicated release branch
- Review and edit the generated changelog before committing
- Include the changelog in your release PR
- Tag the release after merging: `git tag v1.2.0`

---

## Stage 4: Code Review

### Use `/pr-review [pr-number|self]`

Review pull requests or validate your own changes before creating a PR.

### Self-Review (Before Creating PR)

**Workflow:**

```bash
# Before running /pr-create, validate your changes
/pr-review self
```

**What it analyzes:**
- PR size and complexity
- Code quality issues
- Security concerns
- Breaking changes
- Missing tests
- Documentation gaps
- Performance implications

**Example output:**

```markdown
## Self-Review Analysis

### Summary
- **Size**: Medium (847 lines changed)
- **Complexity**: Moderate
- **Risk Level**: Low

### Code Quality
✅ Follows coding standards
✅ No complex functions detected
⚠️  Consider adding JSDoc comments to new exported functions

### Security
✅ No security concerns detected
✅ Proper input validation in place

### Testing
⚠️  Missing test coverage:
- NotificationPreferences.jsx (new component)
- notification.service.js (2 new methods)

### Recommendations
1. Add unit tests for NotificationPreferences component
2. Add tests for getPreferences() and updatePreferences() methods
3. Consider adding JSDoc to exported notification utilities
```

**Use focused reviews:**

```bash
/pr-review self size         # Check size and complexity
/pr-review self breaking     # Check for breaking changes
/pr-review self testing      # Generate test plan
/pr-review self security     # Security-focused review
/pr-review self performance  # Performance review
```

### Reviewing Others' PRs

**Workflow:**

```bash
# Review a specific PR
/pr-review 456
```

**What it analyzes:**
- All commits in the PR
- Changed files and their purposes
- Code quality and standards compliance
- Security implications
- Breaking changes
- Test coverage
- Documentation updates

**Example output:**

```markdown
## PR Review: feat(auth): Add OAuth2 support (#456)

### Overview
- **Author**: @developer
- **Changes**: 1,234 lines across 15 files
- **Commits**: 8 commits over 3 days

### Summary
Adds OAuth2 authentication support with Google and GitHub providers.

### Code Quality
✅ Well-structured and follows project patterns
✅ Good separation of concerns
⚠️  Some functions could benefit from error handling improvements

### Security Review
⚠️  **Important**: Verify OAuth client secrets are not committed
✅ Proper token validation implemented
✅ CSRF protection in place
⚠️  Consider adding rate limiting to OAuth endpoints

### Architecture
✅ Clean abstraction for auth providers
✅ Follows existing authentication patterns
✅ Backward compatible with existing auth

### Testing
✅ Unit tests for OAuth flow
✅ Integration tests for each provider
⚠️  Missing: E2E tests for complete OAuth flow

### Recommendations
1. Add rate limiting to `/auth/oauth/callback` endpoint
2. Create E2E test for Google OAuth flow
3. Add error handling for network failures in token exchange
4. Document OAuth setup in README

### Breaking Changes
None detected

### Approval Recommendation
**Request Changes** - Address security concerns before merging
```

**Use focused reviews:**

```bash
/pr-review 456 code          # Code quality focus
/pr-review 456 security      # Security focus
/pr-review 456 performance   # Performance focus
/pr-review 456 breaking      # Breaking changes check
```

**Tips:**
- Review your own code first before asking others
- Use focused reviews to check specific concerns
- Address all issues before merging
- Re-review after changes are made

---

## Complete Workflow Example

Here's a typical workflow from start to finish:

```bash
# === Development Phase ===

# Create feature branch
git checkout -b feature/oauth-support

# Make changes, commit frequently
git add src/auth/oauth/
/pr-commit-msg
git commit -m "feat(auth): add OAuth provider abstraction"

git add src/auth/oauth/google.js
/pr-commit-msg
git commit -m "feat(auth): implement Google OAuth provider"

git add src/auth/oauth/github.js
/pr-commit-msg
git commit -m "feat(auth): implement GitHub OAuth provider"

git add tests/auth/oauth.test.js
/pr-commit-msg
git commit -m "test(auth): add OAuth provider tests"

git add docs/auth/oauth.md
/pr-commit-msg
git commit -m "docs(auth): document OAuth setup and usage"

# === Pre-PR Phase ===

# Self-review before creating PR
/pr-review self

# Fix any issues found
git add src/auth/oauth/error-handling.js
/pr-commit-msg
git commit -m "fix(auth): improve OAuth error handling"

# Self-review again
/pr-review self

# === PR Creation ===

# Push branch
git push origin feature/oauth-support

# Create PR
/pr-create PROJ-456

# === PR Review Phase ===

# After PR is created, others review
# Reviewer runs: /pr-review 456

# Address feedback
git add src/auth/oauth/rate-limit.js
/pr-commit-msg
git commit -m "feat(auth): add rate limiting to OAuth endpoints"

git push origin feature/oauth-support

# === Release Phase (when ready) ===

# Create release branch
git checkout main
git pull
git checkout -b release/v2.0.0

# Generate release docs
/pr-release

# Review and commit changelog
git add CHANGELOG.md
git commit -m "docs: update changelog for v2.0.0"

# Create release PR
git push origin release/v2.0.0
/pr-create PROJ-500

# After release PR is merged
git checkout main
git pull
git tag v2.0.0
git push origin v2.0.0
```

---

## Best Practices

### Commit Frequently
- Small, focused commits are easier to review and revert
- Each commit should represent a logical unit of work
- Don't wait until the end to commit everything at once

### Self-Review First
- Always run `/pr-review self` before creating a PR
- Fix issues proactively rather than during code review
- Saves time and reduces review iterations

### Write Descriptive PRs
- Use the auto-generated description as a starting point
- Add context that reviewers need to understand the changes
- Link to related issues and documentation
- Include screenshots for UI changes

### Keep PRs Manageable
- Aim for PRs under 500 lines of changes
- Break large features into smaller, reviewable chunks
- Create separate PRs for refactoring vs. new features

### Document Breaking Changes
- Clearly document any breaking changes in PR description
- Provide migration instructions
- Consider deprecation warnings before removal

### Test Before Merging
- Ensure all tests pass
- Add tests for new functionality
- Test edge cases and error scenarios

---

## Troubleshooting

### "No staged changes" error with `/pr-commit-msg`

**Problem:** Command returns "No staged changes found"

**Solution:**
```bash
# Stage your changes first
git add <files>
# Then generate commit message
/pr-commit-msg
```

### PR creation fails with "Branch not pushed"

**Problem:** `/pr-create` can't find remote branch

**Solution:**
```bash
# Push your branch to remote first
git push origin <branch-name>
# Then create PR
/pr-create PROJ-123
```

### "No GitHub CLI authentication" error

**Problem:** `gh` CLI is not authenticated

**Solution:**
```bash
# Authenticate GitHub CLI
gh auth login
# Follow prompts to authenticate
# Then retry PR creation
```

### Self-review shows old changes

**Problem:** `/pr-review self` analyzes wrong commits

**Solution:**
```bash
# Ensure you're on the correct branch
git branch
# Ensure branch is up to date
git fetch origin
# Re-run review
/pr-review self
```

---

## Related Commands

- **[`/pr-commit-msg`](../commands/pr-workflow.md#pr-commit-msg)** - Generate conventional commit messages
- **[`/pr-create`](../commands/pr-workflow.md#pr-create)** - Create pull request with auto-generated description
- **[`/pr-review`](../commands/pr-workflow.md#pr-review)** - Review PR or self-review changes
- **[`/pr-release`](../commands/pr-workflow.md#pr-release)** - Generate changelog and release documentation

---

## Additional Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
