# PR Workflow Commands

Streamline pull request creation, review, and deployment with 4 specialized commands.

---

## Commands

### `/pr-create [ticket-number]`

Create pull request directly on GitHub with generated description.

**Usage:**
```bash
/pr-create 123
```

**What it does:**
1. Analyzes git changes (commits, diffs, files)
2. Detects Drupal/WordPress-specific changes
3. Generates comprehensive PR description
4. Shows preview and asks for confirmation
5. Creates PR on GitHub via `gh` CLI

**What it detects:**
- Drupal configuration changes
- Database updates and migrations
- WordPress ACF changes
- Custom post types and taxonomies
- Gutenberg blocks
- File changes and dependencies
- Breaking changes

**Requires:** GitHub CLI (`gh`) authenticated

---

### `/pr-review [pr-number|self] [focus]`

Review a pull request or analyze your own changes before creating a PR.

**Review someone's PR:**
```bash
/pr-review 456                    # Full comprehensive review
/pr-review 456 code               # Focus on code quality
/pr-review 456 security           # Focus on security issues
/pr-review 456 breaking           # Focus on breaking changes
```

**Analyze your own changes (pre-PR):**
```bash
/pr-review self                   # Full self-assessment
/pr-review self size              # Check PR size/complexity
/pr-review self breaking          # Check for breaking changes
/pr-review self testing           # Generate test plan
```

**Focus options:**
- `code` - Code quality, readability, maintainability
- `security` - Security vulnerabilities, input validation
- `breaking` - Breaking changes detection and migration paths
- `testing` - Test plan generation
- `size` - Size and complexity assessment
- `performance` - Performance optimization opportunities

**What it analyzes:**
- Code quality and maintainability
- Security vulnerabilities (SQL injection, XSS, CSRF)
- Breaking changes and migration paths
- PR size and complexity
- Test coverage
- Drupal/WordPress best practices
- Deployment considerations

**Outputs:**
- Comprehensive review report
- Size and complexity analysis
- Breaking changes with severity ratings
- Detailed test plan
- Actionable recommendations

---

### `/pr-commit-msg`

Generate conventional commit messages from staged changes.

**Usage:**
```bash
# Stage your changes first
git add .

# Generate commit message options
/pr-commit-msg
```

**What it generates:**
- 3-5 commit message options
- Follows conventional commits format
- Platform-specific types (Drupal/WordPress)
- Explanations for each option

**Commit types:**
- `feat`, `fix`, `docs`, `refactor`, `perf`, `test`
- `config` (Drupal), `module` (Drupal), `theme`, `plugin` (WordPress)

---

### `/pr-release [focus]`

Generate changelog, deployment checklist, and update PR for release.

**Usage:**
```bash
/pr-release               # Generate all artifacts
/pr-release changelog     # Focus on changelog only
/pr-release deploy        # Focus on deployment checklist only
/pr-release update        # Update PR with release info
/pr-release v1.2.0        # Generate for specific version
```

**Focus options:**
- `changelog` - Generate changelog from commits (Keep a Changelog format)
- `deploy` - Create comprehensive deployment checklist
- `update` - Update existing PR description

**What it generates:**
- **Changelog**: Following Keep a Changelog format (Added, Changed, Fixed, Security, etc.)
- **Deployment Checklist**: Pre-deployment checks, deployment steps, post-deployment verification, rollback plan
- **PR Updates**: Updated PR description with release notes

---

## Workflows

### Complete PR Workflow

```bash
# 1. During development - commit frequently
git add feature.php
/pr-commit-msg            # Generate conventional commit

# 2. Before creating PR - self-review
/pr-review self           # Analyze your own changes
/quality-standards        # Check code standards
/security-scan secrets    # Check for exposed secrets

# 3. Create PR
/pr-create PROJ-123    # Generates description and creates PR

# 4. After PR created - someone reviews
/pr-review 456            # Comprehensive review of PR #456

# 5. Before release
/pr-release               # Generate changelog and deployment checklist
```

### Quick PR Creation

```bash
# Fastest path to PR
/pr-create 123         # Auto-generates description and creates PR
```

### Self-Review Before Submitting

```bash
# Check your work first
/pr-review self           # Full self-assessment
# Fix any issues found
/pr-create 123         # Create PR when ready
```

### Reviewing Someone's PR

```bash
# Full review
/pr-review 456

# Focus on specific areas
/pr-review 456 security   # Security-focused review
/pr-review 456 breaking   # Breaking changes check
```

### Release Preparation

```bash
# Generate all release artifacts
/pr-release v2.0.0

# Or generate individually
/pr-release changelog     # First, create changelog
/pr-release deploy        # Then, create deployment plan
/pr-release update        # Finally, update PR description
```

---

## Integration with Kanopi Tools

PR workflow commands automatically integrate with Kanopi's DDEV commands:

### Pre-Review Quality Checks

```bash
# Before /pr-review self
ddev composer code-check      # Drupal quality checks (phpstan + rector + phpcs)
ddev composer phpstan         # WordPress static analysis
ddev composer phpcs           # WordPress code standards
ddev composer audit           # PHP dependency vulnerabilities
ddev exec npm audit           # JavaScript vulnerabilities
```

### Test Plan Automation

The `/pr-review` command includes these automated test commands:

```bash
# Automated tests to include in test plan
ddev composer code-check      # Code quality (Drupal)
ddev composer phpstan         # Static analysis (WordPress)
ddev cypress-run              # E2E tests (if configured)
ddev critical-run             # Performance tests (if configured)
```

See [Kanopi Tools](../kanopi-tools/overview.md) for more information.

---

## Command Comparison

### When to use each command:

**`/pr-create`**
- You're ready to create a PR
- Want PR description auto-generated
- Have `gh` CLI installed and authenticated

**`/pr-review [pr-number]`**
- Reviewing someone else's PR
- Need comprehensive code review
- Want to check for breaking changes or security issues

**`/pr-review self`**
- Before creating your PR
- Want to self-assess your changes
- Need size/complexity check
- Want to catch issues early

**`/pr-commit-msg`**
- Making a commit
- Want consistent commit message format
- Following conventional commits

**`/pr-release`**
- Preparing for release
- Need changelog and deployment plan
- Want structured release process

---

## Best Practices

### Commit Messages
- Use conventional commits format
- Be specific and descriptive
- Reference tickets/issues
- Keep subject under 50 characters

### PR Creation
- Self-review with `/pr-review self` first
- Run quality checks before creating PR
- Keep PRs focused (< 400 lines optimal)
- Include comprehensive description

### PR Review
- Review promptly (within 24 hours)
- Be constructive and specific
- Separate critical issues from suggestions
- Acknowledge good work

### Releases
- Generate changelog from commits
- Create detailed deployment checklist
- Test on staging first
- Have rollback plan ready

---

## Next Steps

- **[Quick Start](../quick-start.md)** - Common workflow examples
- **[Commands Overview](overview.md)** - All commands
- **[Code Quality Commands](code-quality.md)** - Maintain code quality
- **[Security Commands](security.md)** - Security scanning
