# Quick Start

Get started with CMS Cultivator in minutes! This guide covers the most common workflows.

CMS Cultivator provides **two ways to work**:
1. **Talk naturally** - Agent Skills automatically help when you need it
2. **Use commands** - Explicit `/command` for full control

---

## Natural Conversation (Agent Skills)

Just describe what you need in plain English:

```
"I need to commit my changes"
→ Automatically generates commit message

"Is this button accessible?"
→ Checks accessibility instantly

"This database query is slow"
→ Analyzes for N+1 issues and suggests fixes

"Does this follow Drupal coding standards?"
→ Runs PHPCS and reports violations

"I need tests for this UserManager class"
→ Generates PHPUnit test scaffolding
```

**No need to remember command names!** Claude automatically helps based on context.

See [Agents & Skills Guide](agents-and-skills.md) for all 8 specialist agents and 9 available skills.

---

## Explicit Commands (Full Control)

When you want comprehensive analysis or specific workflows:

### Your First Commands

### 1. Create a Pull Request

When you're ready to create a pull request:

```bash
# From your feature branch
/pr-create PROJ-123
```

**What it does:**
- Analyzes your git changes
- Generates comprehensive PR description
- Detects Drupal/WordPress-specific changes
- Lists configuration changes, database updates, and more
- Creates the PR on GitHub via `gh` CLI

### 2. Review Your Own Changes

Before creating a PR, check your work:

```bash
/pr-review self
```

**What it analyzes:**
- PR size and complexity
- Breaking changes
- Code quality issues
- Security concerns
- Generates test plan

### 3. Run an Accessibility Audit

Check your code for WCAG compliance:

```bash
/audit-a11y
```

**What it checks:**
- Color contrast ratios
- ARIA attributes
- Semantic HTML
- Keyboard navigation
- Form labels and validation
- Alt text for images

### 4. Analyze Performance

Find performance bottlenecks:

```bash
/audit-perf
```

**What it analyzes:**
- Database queries and N+1 problems
- Asset sizes and optimization
- JavaScript bundle analysis
- Caching effectiveness

### 5. Check Security

Scan for vulnerabilities:

```bash
/audit-security
```

**What it scans:**
- Dependency vulnerabilities
- Exposed secrets
- OWASP Top 10 issues
- Permission problems

### 6. Verify Code Quality

Check coding standards:

```bash
/quality-standards
```

**What it checks:**
- PHPCS violations
- ESLint issues
- Drupal/WordPress standards

---

## Common Workflows

### Workflow 1: Before Creating a PR

```bash
# 1. Self-review your changes
/pr-review self

# 2. Run quality checks
/quality-standards

# 3. Check for security issues
/audit-security secrets

# 4. Create the PR (auto-generates description)
/pr-create PROJ-123
```

### Workflow 2: Making Commits

```bash
# 1. Stage your changes
git add .

# 2. Generate commit message
/pr-commit-msg

# 3. Commit with selected message
git commit -m "[selected message]"
```

### Workflow 3: Code Review

```bash
# 1. Review the PR
/pr-review 456

# 2. Focus on specific areas if needed
/pr-review 456 security      # Security review
/pr-review 456 breaking      # Breaking changes check
/pr-review 456 performance   # Performance review

# 3. Check specific concerns
/audit-a11y contrast
/audit-perf queries
/audit-security deps
```

### Workflow 4: Before Deployment

```bash
# 1. Run comprehensive audits
/audit-perf
/audit-a11y
/audit-security

# 2. Generate release artifacts
/pr-release changelog
/pr-release deploy

# 3. Create compliance reports
/audit-perf report
/audit-a11y report
/audit-security report
```

### Workflow 5: Working on Kanopi Projects

```bash
# 1. Run Kanopi quality checks
# (commands automatically use ddev composer scripts)
/quality-analyze     # Uses ddev composer code-check
/quality-standards   # Uses ddev composer code-sniff
/test-coverage       # Uses ddev cypress-run

# 2. Check performance
/audit-perf          # Suggests ddev theme-build
                     # and ddev critical-run

# 3. Security audit
/audit-security      # Uses ddev composer audit
```

---

## Command Categories Quick Reference

### 🔄 PR Workflow

```bash
/pr-create [ticket]             # Create PR with generated description
/pr-review [pr-number|self] [focus] # Review PR or analyze your own changes
/pr-commit-msg                     # Generate commit message
/pr-release [focus]                # Generate changelog and deployment docs
```

### ♿ Accessibility

```bash
/audit-a11y                        # Comprehensive WCAG audit
/audit-a11y --quick                # Fast critical issues check
/audit-a11y --scope=current-pr     # Analyze only PR files
/audit-a11y --format=summary       # Executive summary
/audit-a11y contrast               # Focus on color contrast
```

### ⚡ Performance

```bash
/audit-perf                        # Full-stack performance analysis
/audit-perf --quick                # Fast critical issues check
/audit-perf --scope=current-pr     # Analyze only PR files
/audit-perf --format=json          # Machine-readable output
/audit-perf queries                # Focus on database queries
```

### 🔒 Security

```bash
/audit-security                    # Comprehensive security audit
/audit-security --quick            # Fast critical issues scan
/audit-security --scope=current-pr # Scan only PR files
/audit-security --format=sarif     # SARIF format for CI/CD
/audit-security deps               # Focus on dependencies
```

### 🎨 Design Workflow

```bash
/design-to-block              # Create WordPress block pattern from design
/design-to-paragraph          # Create Drupal paragraph type from design
/design-validate              # Validate design implementation in browser
```

### 🔍 Live Site Auditing

```bash
/audit-live-site              # Comprehensive live site audit (orchestrator)
                              # Runs performance, accessibility, security, and quality checks in parallel
```

### 📝 Documentation

```bash
/docs-generate              # Analyze documentation status
/docs-generate api          # Generate API documentation
/docs-generate readme       # Update README
/docs-generate changelog    # Generate changelog
/docs-generate guide user   # Generate user guide
```

### 🧪 Testing

```bash
/test-generate [type]       # Generate test scaffolding
/test-coverage              # Analyze test coverage
/test-plan                  # Generate QA test plan
```

### 📊 Code Quality

```bash
/quality-analyze [focus]    # Code quality analysis
/quality-standards          # Check coding standards
```

---

## Argument Modes (Advanced)

Audit and quality commands support flexible argument modes for different use cases:

### Depth Modes
```bash
--quick                    # Fast critical issues only (~5 min)
--standard                 # Full analysis (default, ~15 min)
--comprehensive            # Deep dive with best practices (~30 min)
```

### Scope Control
```bash
--scope=current-pr         # Only files in current PR
--scope=module=<name>      # Specific module/directory
--scope=file=<path>        # Single file
--scope=entire             # Full codebase (default)
```

### Output Formats
```bash
--format=report            # Detailed markdown (default)
--format=json              # Machine-readable for CI/CD
--format=summary           # Executive summary
--format=checklist         # Simple pass/fail list
```

### Example Combinations
```bash
# Pre-commit check (fast)
/audit-a11y --quick --scope=current-pr

# CI/CD integration
/audit-security --standard --format=json > results.json

# Executive report
/audit-perf --comprehensive --format=summary
```

See [Using Argument Modes](guides/using-argument-modes.md) for complete guide.

---

## Focus Parameters

Many commands also accept legacy focus parameters to analyze specific areas:

### PR Review Focus
```bash
/pr-review self              # Full self-assessment
/pr-review self size         # Size and complexity
/pr-review self breaking     # Breaking changes
/pr-review self testing      # Test plan generation

/pr-review 456               # Full review
/pr-review 456 code          # Code quality focus
/pr-review 456 security      # Security focus
/pr-review 456 performance   # Performance focus
```

### Performance Focus
```bash
/audit-perf queries        # Database queries only
/audit-perf n+1            # N+1 detection only
/audit-perf assets         # Asset optimization only
/audit-perf bundles        # JavaScript bundles only
/audit-perf caching        # Caching effectiveness only
```

### Accessibility Focus
```bash
/audit-a11y contrast       # Color contrast only
/audit-a11y aria           # ARIA attributes only
/audit-a11y headings       # Heading structure only
/audit-a11y forms          # Form accessibility only
/audit-a11y keyboard       # Keyboard navigation only
```

### Security Focus
```bash
/audit-security deps       # Dependency vulnerabilities only
/audit-security secrets    # Exposed secrets only
/audit-security permissions # Permission issues only
```

### Quality Focus
```bash
/quality-analyze refactor  # Refactoring opportunities
/quality-analyze complexity # Code complexity analysis
/quality-analyze debt      # Technical debt assessment
```

---

## Tips & Best Practices

### 1. Run Checks Early and Often
```bash
# Don't wait until the end of the sprint
/audit-a11y              # Check accessibility during development
/audit-perf queries      # Catch N+1 queries early
/audit-security secrets  # Before committing code
```

### 2. Self-Review Before Creating PRs
```bash
# Catch issues before code review
/pr-review self          # Full self-assessment
# Fix any issues found
/pr-create PROJ-123   # Create PR when ready
```

### 3. Use Focus Parameters for Speed
```bash
# When you know what you're looking for
/pr-review 456 security  # Just security review
/audit-perf queries      # Just check database queries
/audit-a11y contrast     # Just check color contrast
```

### 4. Combine with Git Workflows
```bash
# Pre-commit
/pr-commit-msg

# Pre-PR
/pr-review self
/quality-standards
/audit-security secrets

# Post-merge
/docs-generate changelog
```

### 5. Generate Reports for Stakeholders
```bash
# Before client demos
/audit-perf report        # Performance metrics
/audit-a11y report        # Accessibility compliance
/audit-security report    # Security posture
```

---

## Next Steps

- **[Explore All Commands](commands/overview.md)** - Detailed command reference
- **[Kanopi Tools Integration](kanopi-tools/overview.md)** - Use with DDEV add-ons
- **[Contributing](contributing.md)** - Help improve CMS Cultivator
