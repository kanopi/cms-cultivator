# Quick Start

Get started with CMS Cultivator in minutes! This guide covers the most common workflows.

CMS Cultivator provides **two ways to work**:
1. **Talk naturally** - Agent Skills automatically help when you need it
2. **Use skills explicitly** - In Claude Code, use `/skill-name`. In Codex, use `@skill-name`.

!!! note "Platform compatibility"
    Natural language activation works the same on Claude Code, Claude Desktop, and OpenAI Codex. Explicit invocation syntax differs: Claude Code uses `/pr-create`, Codex uses `@pr-create`.

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

See [Agents & Skills Guide](agents-and-skills.md) for the full list of specialist agents and skills.

---

## Explicit Invocation (Full Control)

When you want comprehensive analysis or specific workflows, invoke a skill by name. In Claude Code: `/skill-name`. In Codex: `@skill-name`. In Claude Desktop: type the skill name and Claude will load it.

### Your First Invocations

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
/accessibility-audit
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
/performance-audit
```

**What it analyzes:**
- Database queries and N+1 problems
- Asset sizes and optimization
- JavaScript bundle analysis
- Caching effectiveness

### 5. Check Security

Scan for vulnerabilities:

```bash
/security-audit
```

**What it scans:**
- Dependency vulnerabilities
- Exposed secrets
- OWASP Top 10 issues
- Permission problems

### 6. Verify Code Quality

Check coding standards:

```bash
/code-standards-checker
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
/code-standards-checker

# 3. Check for security issues
/security-audit secrets

# 4. Create the PR (auto-generates description)
/pr-create PROJ-123
```

### Workflow 2: Making Commits

```bash
# 1. Stage your changes
git add .

# 2. Generate commit message
/commit-message-generator

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
/accessibility-audit contrast
/performance-audit queries
/security-audit deps
```

### Workflow 4: Before Deployment

```bash
# 1. Run comprehensive audits
/performance-audit
/accessibility-audit
/security-audit

# 2. Generate release artifacts
/pr-release changelog
/pr-release deploy

# 3. Create compliance reports
/performance-audit report
/accessibility-audit report
/security-audit report
```

### Workflow 5: Working on Kanopi Projects

```bash
# 1. Run Kanopi quality checks
# (commands automatically use ddev composer scripts)
/quality-audit     # Uses ddev composer code-check
/code-standards-checker   # Uses ddev composer code-sniff
/coverage-analyzer       # Uses ddev cypress-run

# 2. Check performance
/performance-audit          # Suggests ddev theme-build
                     # and ddev critical-run

# 3. Security audit
/security-audit      # Uses ddev composer audit
```

---

## Command Categories Quick Reference

### 🔄 PR Workflow

```bash
/pr-create [ticket]             # Create PR with generated description
/pr-review [pr-number|self] [focus] # Review PR or analyze your own changes
/commit-message-generator                     # Generate commit message
/pr-release [focus]                # Generate changelog and deployment docs
```

### ♿ Accessibility

```bash
/accessibility-audit                        # Comprehensive WCAG audit
/accessibility-audit --quick                # Fast critical issues check
/accessibility-audit --scope=current-pr     # Analyze only PR files
/accessibility-audit --format=summary       # Executive summary
/accessibility-audit contrast               # Focus on color contrast
```

### ⚡ Performance

```bash
/performance-audit                        # Full-stack performance analysis
/performance-audit --quick                # Fast critical issues check
/performance-audit --scope=current-pr     # Analyze only PR files
/performance-audit --format=json          # Machine-readable output
/performance-audit queries                # Focus on database queries
```

### 🔒 Security

```bash
/security-audit                    # Comprehensive security audit
/security-audit --quick            # Fast critical issues scan
/security-audit --scope=current-pr # Scan only PR files
/security-audit --format=sarif     # SARIF format for CI/CD
/security-audit deps               # Focus on dependencies
```

### 🎨 Design Workflow

```bash
/design-to-wp-block              # Create WordPress block pattern from design
/design-to-drupal-paragraph          # Create Drupal paragraph type from design
/browser-validator              # Validate design implementation in browser
```

### 🔍 Live Site Auditing

```bash
/live-site-audit              # Comprehensive live site audit
                              # Runs performance, accessibility, security, and quality checks in parallel
```

### 📝 Documentation

```bash
/documentation-generator              # Analyze documentation status
/documentation-generator api          # Generate API documentation
/documentation-generator readme       # Update README
/documentation-generator changelog    # Generate changelog
/documentation-generator guide user   # Generate user guide
```

### 🧪 Testing

```bash
/test-scaffolding [type]       # Generate test scaffolding
/coverage-analyzer              # Analyze test coverage
/test-plan-generator                  # Generate QA test plan
```

### 📊 Code Quality

```bash
/quality-audit [focus]    # Code quality analysis
/code-standards-checker          # Check coding standards
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
/accessibility-audit --quick --scope=current-pr

# CI/CD integration
/security-audit --standard --format=json > results.json

# Executive report
/performance-audit --comprehensive --format=summary
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
/performance-audit queries        # Database queries only
/performance-audit n+1            # N+1 detection only
/performance-audit assets         # Asset optimization only
/performance-audit bundles        # JavaScript bundles only
/performance-audit caching        # Caching effectiveness only
```

### Accessibility Focus
```bash
/accessibility-audit contrast       # Color contrast only
/accessibility-audit aria           # ARIA attributes only
/accessibility-audit headings       # Heading structure only
/accessibility-audit forms          # Form accessibility only
/accessibility-audit keyboard       # Keyboard navigation only
```

### Security Focus
```bash
/security-audit deps       # Dependency vulnerabilities only
/security-audit secrets    # Exposed secrets only
/security-audit permissions # Permission issues only
```

### Quality Focus
```bash
/quality-audit refactor  # Refactoring opportunities
/quality-audit complexity # Code complexity analysis
/quality-audit debt      # Technical debt assessment
```

---

## Optional: WordPress Skills

Install official WordPress agent-skills for specialized WordPress development:

```bash
/wp-add-skills
```

**What you get:**
- 13 WordPress-specific skills
- Gutenberg block development
- REST API expertise
- WP-CLI automation
- Performance optimization
- Theme.json and block themes
- Plugin architecture guidance

**Installation time:** ~70 seconds

**Learn more:** [WordPress Skills Guide](wordpress-skills.md)

**Example questions after installation:**
```
"How do I create a custom Gutenberg block?"
"Show me how to configure theme.json"
"Create a custom REST endpoint"
"How do I optimize WordPress database queries?"
```

---

## Tips & Best Practices

### 1. Run Checks Early and Often
```bash
# Don't wait until the end of the sprint
/accessibility-audit              # Check accessibility during development
/performance-audit queries      # Catch N+1 queries early
/security-audit secrets  # Before committing code
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
/performance-audit queries      # Just check database queries
/accessibility-audit contrast     # Just check color contrast
```

### 4. Combine with Git Workflows
```bash
# Pre-commit
/commit-message-generator

# Pre-PR
/pr-review self
/code-standards-checker
/security-audit secrets

# Post-merge
/documentation-generator changelog
```

### 5. Generate Reports for Stakeholders
```bash
# Before client demos
/performance-audit report        # Performance metrics
/accessibility-audit report        # Accessibility compliance
/security-audit report    # Security posture
```

---

## Next Steps

- **[Explore All Commands](commands/overview.md)** - Detailed command reference
- **[Kanopi Tools Integration](kanopi-tools/overview.md)** - Use with DDEV add-ons
- **[Contributing](contributing.md)** - Help improve CMS Cultivator
