# PR Workflow Commands

Streamline pull request creation, review, and deployment with 6 specialized commands.

---

## Commands

### `/pr-desc [ticket-number]`

Generate comprehensive PR descriptions from git changes.

**Usage:**
```bash
/pr-desc              # Generate from current branch
/pr-desc PROJ-123     # Include ticket number
```

**What it detects:**
- Drupal configuration changes
- Database updates
- WordPress ACF changes
- Custom post types
- File changes and additions
- Breaking changes

---

### `/pr-create-pr [ticket-number]`

Create pull request directly on GitHub with generated description.

**Usage:**
```bash
/pr-create-pr 123
```

**Requires:** GitHub CLI (`gh`) authenticated

---

### `/pr-review [pr-number|url]`

Review existing pull requests with detailed AI-assisted feedback.

**Usage:**
```bash
/pr-review 456
/pr-review https://github.com/org/repo/pull/456
```

---

### `/pr-commit-msg`

Generate conventional commit messages from staged changes.

**Usage:**
```bash
# Stage your changes first
git add .

# Generate commit message
/pr-commit-msg
```

---

### `/pr-analysis [focus]`

Analyze PR size, breaking changes, and generate test plan.

**Usage:**
```bash
/pr-analysis              # Run all analyses
/pr-analysis size         # Focus on size only
/pr-analysis breaking     # Focus on breaking changes only
/pr-analysis testing      # Focus on test plan only
```

**Focus options:**
- `size` - PR size and complexity assessment
- `breaking` - Breaking changes detection
- `testing` - Test plan generation

---

### `/pr-release [focus]`

Generate changelog, deployment checklist, and update PR.

**Usage:**
```bash
/pr-release               # Generate all artifacts
/pr-release changelog     # Focus on changelog only
/pr-release deploy        # Focus on deployment checklist only
/pr-release update        # Update PR with release info
```

**Focus options:**
- `changelog` - Generate changelog from commits
- `deploy` - Create deployment checklist
- `update` - Update PR description

---

## Workflows

### Complete PR Workflow

```bash
# 1. During development
/pr-commit-msg            # For each commit

# 2. Before creating PR
/quality-standards        # Check code standards
/security-scan secrets    # Check for exposed secrets
/pr-desc PROJ-123         # Generate PR description

# 3. Create PR
/pr-create-pr 123

# 4. Before release
/pr-analysis              # Analyze changes
/pr-release               # Generate release artifacts
```

---

## Integration with Kanopi Tools

PR workflow commands automatically integrate with Kanopi's DDEV commands:

```bash
# The /pr-analysis command includes these checks:
ddev composer code-check      # Drupal quality checks
ddev composer phpstan         # Static analysis
ddev composer phpcs           # Code standards
ddev cypress-run              # E2E tests (if configured)
```

See [Kanopi Tools](../kanopi-tools/overview.md) for more information.

---

## Next Steps

- **[Quick Start](../quick-start.md)** - Common workflow examples
- **[Commands Overview](overview.md)** - All commands
- **[Accessibility Commands](accessibility.md)** - WCAG compliance
