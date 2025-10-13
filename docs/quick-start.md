# Quick Start

Get started with CMS Cultivator in minutes! This guide covers the most common workflows.

---

## Your First Commands

### 1. Generate a PR Description

When you're ready to create a pull request:

```bash
# From your feature branch
/pr-desc PROJ-123
```

**What it does:**
- Analyzes your git changes
- Generates comprehensive PR description
- Detects Drupal/WordPress-specific changes
- Lists configuration changes, database updates, and more

### 2. Run an Accessibility Audit

Check your code for WCAG compliance:

```bash
/a11y-audit
```

**What it checks:**
- Color contrast ratios
- ARIA attributes
- Semantic HTML
- Keyboard navigation
- Form labels and validation
- Alt text for images

### 3. Analyze Performance

Find performance bottlenecks:

```bash
/perf-analyze
```

**What it analyzes:**
- Database queries and N+1 problems
- Asset sizes and optimization
- JavaScript bundle analysis
- Caching effectiveness

### 4. Check Security

Scan for vulnerabilities:

```bash
/security-scan
```

**What it scans:**
- Dependency vulnerabilities
- Exposed secrets
- OWASP Top 10 issues
- Permission problems

### 5. Verify Code Quality

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
# 1. Generate commit message
/pr-commit-msg

# 2. Run quality checks
/quality-standards

# 3. Check for security issues
/security-scan secrets

# 4. Generate PR description
/pr-desc PROJ-123

# 5. Create the PR
/pr-create-pr 123
```

### Workflow 2: Code Review

```bash
# 1. Analyze the PR
/pr-analysis

# 2. Review the code
/pr-review 456

# 3. Check specific concerns
/a11y-check
/perf-analyze queries
/security-scan deps
```

### Workflow 3: Before Deployment

```bash
# 1. Run comprehensive audits
/perf-performance-audit
/a11y-audit
/security-audit

# 2. Generate release artifacts
/pr-release changelog
/pr-release deploy

# 3. Create compliance reports
/perf-performance-report
/a11y-report
/security-report
```

### Workflow 4: Working on Kanopi Projects

```bash
# 1. Run Kanopi quality checks
# (commands automatically use ddev composer scripts)
/quality-analyze     # Uses ddev composer code-check
/quality-standards   # Uses ddev composer code-sniff
/test-coverage       # Uses ddev cypress-run

# 2. Check performance
/perf-analyze        # Suggests ddev theme-build
                     # and ddev critical-run

# 3. Security audit
/security-audit      # Uses ddev composer audit
```

---

## Command Categories Quick Reference

### 🔄 PR Workflow

```bash
/pr-desc [ticket]           # Generate PR description
/pr-create-pr [ticket]      # Create PR on GitHub
/pr-review [pr-number]      # Review existing PR
/pr-commit-msg              # Generate commit message
/pr-analysis [focus]        # Analyze size, breaking changes, tests
/pr-release [focus]         # Generate changelog and deployment docs
```

### ♿ Accessibility

```bash
/a11y-audit                 # Comprehensive WCAG audit
/a11y-report                # Generate compliance report
/a11y-checklist             # WCAG 2.1 AA checklist
/a11y-check [focus]         # Check specific aspects
/fix-a11y-issues            # Generate code fixes
```

### ⚡ Performance

```bash
/perf-performance-audit     # Full-stack performance analysis
/perf-lighthouse-report     # Lighthouse audit
/perf-performance-report    # Executive performance report
/perf-analyze [focus]       # Detailed performance analysis
/perf-vitals [metric]       # Core Web Vitals optimization
```

### 🔒 Security

```bash
/security-audit             # Comprehensive security audit
/security-scan [focus]      # Scan for specific issues
/security-report            # Security compliance report
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

## Focus Parameters

Many commands accept optional focus parameters to analyze specific areas:

### Performance Focus
```bash
/perf-analyze queries      # Database queries only
/perf-analyze n-plus-one   # N+1 detection only
/perf-analyze assets       # Asset optimization only
/perf-analyze bundles      # JavaScript bundles only
/perf-analyze caching      # Caching effectiveness only
```

### Accessibility Focus
```bash
/a11y-check contrast       # Color contrast only
/a11y-check aria           # ARIA attributes only
/a11y-check headings       # Heading structure only
/a11y-check forms          # Form accessibility only
/a11y-check keyboard       # Keyboard navigation only
```

### Security Focus
```bash
/security-scan deps        # Dependency vulnerabilities only
/security-scan secrets     # Exposed secrets only
/security-scan permissions # Permission issues only
```

### Quality Focus
```bash
/quality-analyze refactor  # Refactoring opportunities
/quality-analyze complexity # Code complexity analysis
/quality-analyze debt      # Technical debt assessment
```

### PR Analysis Focus
```bash
/pr-analysis size          # Size and complexity
/pr-analysis breaking      # Breaking changes
/pr-analysis testing       # Test plan generation
```

---

## Tips & Best Practices

### 1. Run Checks Early and Often
```bash
# Don't wait until the end of the sprint
/a11y-audit              # Check accessibility during development
/perf-analyze queries    # Catch N+1 queries early
/security-scan secrets   # Before committing code
```

### 2. Use Focus Parameters for Speed
```bash
# When you know what you're looking for
/perf-analyze queries    # Just check database queries
/a11y-check contrast     # Just check color contrast
/security-scan deps      # Just check dependencies
```

### 3. Combine with Git Workflows
```bash
# Pre-commit
/pr-commit-msg

# Pre-PR
/quality-standards
/security-scan secrets
/pr-desc

# Post-merge
/docs-generate changelog
```

### 4. Generate Reports for Stakeholders
```bash
# Before client demos
/perf-performance-report  # Performance metrics
/a11y-report              # Accessibility compliance
/security-report          # Security posture
```

---

## Next Steps

- **[Explore All Commands](commands/overview.md)** - Detailed command reference
- **[Kanopi Tools Integration](kanopi-tools/overview.md)** - Use with DDEV add-ons
- **[Contributing](contributing.md)** - Help improve CMS Cultivator
