# Skills Overview

CMS Cultivator provides 38 Agent Skills organized into categories. Each skill integrates seamlessly with Drupal and WordPress projects and works across Claude Code, Claude Desktop, and OpenAI Codex.

---

## Skill Categories

### 🔄 [PR Workflow](pr-workflow.md)

Streamline pull request creation, review, and deployment.

| Skill | Description |
|---------|-------------|
| `/pr-create [ticket]` | Create pull request with generated description |
| `/pr-review [pr-number\|self] [focus]` | Review PR or analyze your own changes (size, breaking changes, test plan) |
| `/pr-commit-msg` | Generate conventional commit messages from staged changes |
| `/pr-release [focus]` | Generate changelog, deployment checklist, and update PR |

---

### ♿ [Accessibility](accessibility.md)

Ensure WCAG 2.1 Level AA compliance and create inclusive experiences.

| Skill | Description |
|---------|-------------|
| `/audit-a11y [focus]` | Comprehensive accessibility audit with WCAG 2.1 Level AA compliance |

**Usage modes**:
- `/audit-a11y` - Full audit with detailed findings
- `/audit-a11y [focus]` - Focused checks (contrast, aria, headings, forms, alt-text, keyboard)
- `/audit-a11y checklist` - Generate WCAG 2.1 AA compliance checklist
- `/audit-a11y report` - Generate stakeholder-friendly compliance report
- `/audit-a11y fix` - Generate specific code fixes for identified issues

---

### ⚡ [Performance](performance.md)

Optimize site speed and improve Core Web Vitals.

| Skill | Description |
|---------|-------------|
| `/audit-perf [options]` | Comprehensive performance analysis and Core Web Vitals optimization |
| `/audit-gtm [options]` | Google Tag Manager performance audit (container size, tag execution, CWV impact) |

**Usage modes**:
- `/audit-perf` - Full performance audit across all areas
- `/audit-perf [focus]` - Focused analysis (queries, n+1, assets, bundles, caching)
- `/audit-perf vitals` - Check all Core Web Vitals (LCP, INP/FID, CLS)
- `/audit-perf [metric]` - Optimize specific vital (lcp, inp, fid, cls)
- `/audit-perf lighthouse` - Generate Lighthouse performance report
- `/audit-perf report` - Generate stakeholder-friendly performance report
- `/audit-gtm` - Full GTM performance audit with tag profiling
- `/audit-gtm [focus]` - Focused GTM analysis (container, tags, triggers, consent)

**Requirements**: `/audit-gtm` requires Chrome DevTools MCP Server

---

### 🔒 [Security](security.md)

Scan for vulnerabilities, exposed secrets, and security misconfigurations.

| Skill | Description |
|---------|-------------|
| `/audit-security [focus]` | Comprehensive security audit with vulnerability scanning and compliance reporting |

**Usage modes**:
- `/audit-security` - Complete security audit with detailed findings
- `/audit-security [focus]` - Focused scans (deps, secrets, permissions)
- `/audit-security report` - Generate stakeholder-friendly compliance report

---

### 📝 [Documentation](documentation.md)

Generate and maintain project documentation.

| Skill | Description |
|---------|-------------|
| `/docs-generate [type]` | Generate documentation (API, README, guides, changelog) |

**Type options**: `api`, `readme`, `changelog`, `guide user`, `guide developer`, `guide deployment`, `guide admin`

---

### 🧪 [Testing](testing.md)

Generate tests and analyze test coverage.

| Skill | Description |
|---------|-------------|
| `/test-generate [type]` | Generate test scaffolding (unit, integration, e2e, data) |
| `/test-coverage` | Analyze test coverage and identify untested code paths |
| `/test-plan` | Generate comprehensive QA test plan from code changes |

**Type options**: `unit`, `integration`, `e2e`, `data`

---

### 🔧 [DevOps Setup](devops.md)

Automate Kanopi's Drupal/Pantheon DevOps onboarding for new projects.

| Skill | Description |
|---------|-------------|
| `/devops-setup [git-url]` | Full Kanopi DevOps onboarding (GitHub, Pantheon, CircleCI, code quality) |

**What it automates**:
- GitHub repo creation + branch protection + team access
- Pantheon Redis + New Relic via Terminus
- DDEV, CircleCI, Cypress, code quality tools, quicksilver scripts

**Requirements**: GitHub CLI (`gh`), Terminus CLI

---

### 📊 [Code Quality](code-quality.md)

Maintain code quality and reduce technical debt.

| Skill | Description |
|---------|-------------|
| `/quality-analyze [focus]` | Analyze code quality (refactoring, complexity, technical debt) |
| `/quality-standards` | Check code against standards (PHPCS, ESLint, Drupal/WordPress) |

**Focus options**: `refactor`, `complexity`, `debt`

---

### 🔍 [Live Site Auditing](live-site-auditing.md)

Comprehensive audits of live websites using Chrome DevTools.

| Skill | Description |
|---------|-------------|
| `/audit-live-site [url]` | Full site audit for performance, accessibility, SEO, and security |
| `/audit-structured-data <url> [options]` | Audit JSON-LD/Schema.org for SEO and AI discoverability |
| `/export-audit-csv [report-file]` | Export audit report to CSV for project management tools (Teamwork, Jira, Monday, etc.) |

**Requirements**: Chrome DevTools MCP Server

**What it audits**:
- Performance (Core Web Vitals: LCP, INP, CLS, FCP, TBT)
- Accessibility (WCAG 2.2 AA compliance)
- SEO (meta tags, structured data, sitemaps)
- Security (HTTPS, headers, mixed content)
- Structured data (JSON-LD, Schema.org, Rich Results eligibility)
- Best practices (console errors, optimization)

**Output**: Markdown report + CSV task list

---

### 📋 [Project Management](project-management.md)

Integrate with Teamwork for task tracking and project coordination.

| Skill | Description |
|---------|-------------|
| `/teamwork [operation] [args]` | Create, update, and manage Teamwork tasks with expert guidance |

**Operations**:
- `/teamwork create [options]` - Create task with automatic template selection
- `/teamwork update <ticket> [options]` - Update existing task
- `/teamwork export <report> [options]` - Export audit findings as tasks
- `/teamwork link <ticket> [options]` - Link git changes to ticket
- `/teamwork status <ticket>` - Quick status check

**Use cases**:
- Converting user stories to tracked tasks
- Exporting audit findings for project planning
- Linking PRs to Teamwork tickets
- Checking task status without leaving CLI

**Task Templates**: Big Task/Epic, Little Task, QA Handoff, Bug Report

**Requirements**: Teamwork MCP Server

---

## Platform-Specific Features

### Drupal Support
- Configuration change detection
- Custom module analysis
- Hook implementation detection
- Entity and field change tracking
- Database update detection (`hook_update_N`)
- Views and Entity Query optimization
- Drupal caching analysis (page cache, render cache, cache tags)
- Drush command generation

### WordPress Support
- Theme and functions.php analysis
- Gutenberg block accessibility and performance
- ACF field group detection
- Custom post type and taxonomy analysis
- Shortcode implementation
- WP_Query optimization
- Object cache analysis
- WP-CLI command generation

---

## Integration with Kanopi Tools

Skills automatically integrate with [Kanopi's DDEV add-ons](../kanopi-tools/overview.md):

- **Quality skills** use `ddev composer code-check`, `phpstan`, `rector-check`
- **Performance skills** suggest `ddev theme-build` and `ddev critical-run`
- **Security skills** use `ddev composer audit` and `npm audit`
- **Testing skills** leverage `ddev cypress-run` for E2E tests

---

## ⚙️ Setup & Configuration

Extend CMS Cultivator with additional skills.

| Skill | Description |
|---------|-------------|
| `/wp-add-skills [options]` | Install official WordPress agent-skills globally |

**Options:**
- `--list` - Show installed WordPress skills
- `--update` - Update skills to latest version

**What it installs:** 13 WordPress-specific skills for block development, REST API, WP-CLI, performance, and more.

**Learn more:** [WordPress Skills Guide](../wordpress-skills.md)

---

## Next Steps

- **[PR Workflow Skills](pr-workflow.md)** - Detailed PR workflow guide
- **[Accessibility Skills](accessibility.md)** - WCAG compliance guide
- **[Performance Skills](performance.md)** - Optimization strategies
- **[DevOps Setup](devops.md)** - Drupal/Pantheon onboarding automation
- **[Quick Start](../quick-start.md)** - Common workflow examples
