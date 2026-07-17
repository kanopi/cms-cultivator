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

"Create a hero block from this design"
→ Builds a WordPress block pattern from the Figma reference

"Does this follow Drupal coding standards?"
→ Runs PHPCS and reports violations

"I need tests for this UserManager class"
→ Generates PHPUnit test scaffolding

"Should this heading be a prop or a slot?"
→ Drupal SDC guidance activates
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

### 3. Start a Ticket in a Fresh Worktree

Work on multiple tickets — or run multiple AI sessions — in parallel:

```bash
/worktree-manager create 1234 hero-block
```

**What it does:**
- Creates a sibling worktree with a Kanopi-style branch (`feature/tw1234-hero-block`)
- Runs DDEV setup with automatic project isolation
- Reports the directory, branch, and local URL

### 4. Convert a Design to a Component

Turn a Figma design or screenshot into a working component:

```bash
/design-to-wp-block design.png hero-cta          # WordPress block pattern
/design-to-drupal-paragraph design.png hero_cta  # Drupal paragraph type
```

**What it does:**
- Extracts colors, typography, spacing, and layout
- Generates the pattern or paragraph configuration plus mobile-first SCSS
- Validates the result in a real browser at 320px/768px/1024px

### 5. Verify Code Quality

Check coding standards:

```bash
/code-standards-checker
```

**What it checks:**
- PHPCS violations
- ESLint issues
- Drupal/WordPress standards

### 6. Contribute Back to Drupal.org

Upstream a fix to a contrib module:

```bash
/drupal-contribute
```

**What it does:**
- Drafts the drupal.org issue for you to paste in
- Sets up the issue fork and branch on `git.drupalcode.org`
- Opens the merge request with a pre-drafted description

---

## Common Workflows

### Workflow 1: Before Creating a PR

```bash
# 1. Self-review your changes
/pr-review self

# 2. Run quality checks
/code-standards-checker

# 3. Create the PR (auto-generates description)
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
```

### Workflow 4: Design to Deployed Component

```bash
# 1. Generate the component from a design reference
/design-to-wp-block hero-design.png hero-banner

# 2. Validate in the browser
/browser-validator http://site.ddev.site/test-hero-banner/

# 3. Commit and create the PR
/commit-message-generator
/pr-create PROJ-123
```

### Workflow 5: Working on Kanopi Projects

```bash
# 1. Run Kanopi quality checks
# (skills automatically use ddev composer scripts)
/code-standards-checker   # Uses ddev composer code-sniff
/coverage-analyzer        # Uses ddev cypress-run

# 2. Patch a contrib dependency safely
/composer-patch-generator # CI-safe patches with extra.patches wiring
```

---

## Command Categories Quick Reference

### 🔄 PR Workflow

```bash
/pr-create [ticket]                 # Create PR with generated description
/pr-review [pr-number|self] [focus] # Review PR or analyze your own changes
/commit-message-generator           # Generate commit message
/pr-release [focus]                 # Generate changelog and deployment docs
/worktree-manager [create|list|remove] # Parallel tickets via git worktrees
```

### 🎨 Design Workflow

```bash
/design-to-wp-block                  # Create WordPress block pattern from design
/design-to-drupal-paragraph          # Create Drupal paragraph type from design
/browser-validator                   # Validate design implementation in browser
```

### 🧪 Testing

```bash
/test-scaffolding [type]       # Generate test scaffolding
/coverage-analyzer             # Analyze test coverage
/test-plan-generator           # Generate QA test plan
```

### 📊 Code Quality

```bash
/code-standards-checker        # Check coding standards
/composer-patch-generator      # CI-safe Composer package patches
```

### 📝 Documentation

```bash
/documentation-generator              # Analyze documentation status
/documentation-generator api          # Generate API documentation
/documentation-generator readme       # Update README
/documentation-generator changelog    # Generate changelog
/documentation-generator guide user   # Generate user guide
```

### 🌐 Drupal.org Contribution

```bash
/drupal-contribute             # Full issue + MR workflow
/drupal-issue                  # Issue creation and updates
/drupal-mr                     # Merge request setup
/drupal-cleanup                # Clean up the local clone cache
```

---

## Focus Parameters

Some skills accept focus parameters to analyze specific areas:

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

### Release Focus
```bash
/pr-release changelog        # Changelog only
/pr-release deploy           # Deployment checklist only
/pr-release update           # Update PR description
```

---

## Optional: WordPress Skills

Install official WordPress agent-skills for specialized WordPress development:

```bash
/wp-add-skills
```

**What you get:**
- WordPress-specific skills from the core WordPress team
- Gutenberg block development
- REST API expertise
- WP-CLI automation
- Performance optimization
- Theme.json and block themes
- Plugin architecture guidance

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

### 1. Self-Review Before Creating PRs
```bash
# Catch issues before code review
/pr-review self          # Full self-assessment
# Fix any issues found
/pr-create PROJ-123   # Create PR when ready
```

### 2. Use Focus Parameters for Speed
```bash
# When you know what you're looking for
/pr-review 456 security  # Just security review
/pr-review self size     # Just size and complexity
```

### 3. Validate in a Real Browser
```bash
# After implementing UI work
/browser-validator http://site.ddev.site/test-page
```

### 4. Combine with Git Workflows
```bash
# Pre-commit
/commit-message-generator

# Pre-PR
/pr-review self
/code-standards-checker

# Post-merge
/documentation-generator changelog
```

---

## Next Steps

- **[Explore All Commands](commands/overview.md)** - Detailed command reference
- **[Kanopi Tools Integration](kanopi-tools/overview.md)** - Use with DDEV add-ons
- **[Contributing](contributing.md)** - Help improve CMS Cultivator
