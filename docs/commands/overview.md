# Skills Overview

CMS Cultivator provides Agent Skills organized into categories. Each skill integrates with Drupal and WordPress projects and works across Claude Code, Claude Desktop, and OpenAI Codex.

Skills activate in two ways:

- **Automatically** — Claude recognizes context and invokes the right skill without you asking. Say "I need to commit my changes" and `commit-message-generator` activates.
- **Explicitly** — Invoke any skill by name. In Claude Code: `/pr-create`. In Codex: `@pr-create`. In Claude Desktop: type the skill name and Claude will load it.

!!! tip "Naming convention"
    Skills are named after what they do, not after a verb-noun command pattern. The accessibility skill is `accessibility-audit`, not `accessibility-audit`. The commit message helper is `commit-message-generator`, not `commit-message-generator`. If you remember an old pre-v1.0 name, see the [Skill Naming Convention reference](../reference/skill-naming-convention.md) for the migration mapping.

---

## Skill Categories

### 🔄 [PR Workflow](pr-workflow.md)

Streamline pull request creation, review, and deployment. PR skills run directly from the main session — no orchestrator agent.

| Skill | Description |
|-------|-------------|
| `commit-message-generator` | Generate conventional commit messages from staged changes |
| `pr-create` | Create a pull request with a generated description (presents for approval before running `gh pr create`) |
| `pr-review` | Review a PR (`/pr-review 123`) or self-review your branch (`/pr-review self`) with focus areas: code, security, breaking, testing, size, performance |
| `pr-release` | Generate changelog (Keep a Changelog format), deployment checklist, and PR description update |

---

### ♿ [Accessibility](accessibility.md)

Ensure WCAG 2.1 Level AA compliance and create inclusive experiences.

| Skill | Description |
|-------|-------------|
| `accessibility-checker` | Quick accessibility check on a specific element, component, or page |
| `accessibility-audit` | Comprehensive WCAG 2.1 Level AA audit; spawns the accessibility specialist agent |

---

### ⚡ [Performance](performance.md)

Optimize site speed and improve Core Web Vitals.

| Skill | Description |
|-------|-------------|
| `performance-analyzer` | Quick performance analysis on specific code, queries, or assets |
| `performance-audit` | Comprehensive performance audit; spawns the performance specialist agent |
| `gtm-performance-audit` | Google Tag Manager performance audit (container size, tag execution, Core Web Vitals impact) — requires Chrome DevTools MCP |

---

### 🔒 [Security](security.md)

Scan for vulnerabilities, OWASP Top 10 issues, and security misconfigurations.

| Skill | Description |
|-------|-------------|
| `security-scanner` | Quick security check on specific code or patterns |
| `security-audit` | Comprehensive OWASP Top 10 audit; spawns the security specialist agent |

---

### 📊 [Code Quality](code-quality.md)

Maintain code quality, coding standards, and test coverage.

| Skill | Description |
|-------|-------------|
| `code-standards-checker` | Check code against project standards (PHPCS, ESLint, Drupal/WordPress) |
| `quality-audit` | Technical debt and code quality analysis; spawns the code quality specialist |
| `coverage-analyzer` | Test coverage gap analysis |

---

### 🧪 [Testing](testing.md)

Generate tests and QA test plans.

| Skill | Description |
|-------|-------------|
| `test-scaffolding` | Generate test scaffolding (unit, integration, e2e) for a class or function |
| `test-plan-generator` | Generate a comprehensive QA test plan from code changes |

---

### 📝 [Documentation](documentation.md)

Generate and maintain project documentation.

| Skill | Description |
|-------|-------------|
| `documentation-generator` | Generate documentation (API docs/PHPDoc/JSDoc, README, user guides, changelogs) |

---

### 🎨 [Design Workflow](design-workflow.md)

Convert Figma designs into WordPress blocks and Drupal paragraph types.

| Skill | Description |
|-------|-------------|
| `design-analyzer` | Extract technical requirements from a Figma URL or screenshot |
| `design-to-wp-block` | Create a WordPress block pattern from a design reference |
| `design-to-drupal-paragraph` | Create a Drupal paragraph type from a design reference |
| `responsive-styling` | Generate mobile-first responsive CSS/SCSS with WCAG AA contrast |
| `browser-validator` | Validate implementation in Chrome at 320px/768px/1024px breakpoints |

---

### 🔍 [Live Site Auditing](live-site-auditing.md)

Comprehensive site audits and reporting.

| Skill | Description |
|-------|-------------|
| `live-site-audit` | Multi-dimensional audit — spawns performance, accessibility, security, and code quality specialists in parallel |
| `structured-data-analyzer` | Audit JSON-LD / Schema.org markup for SEO and AI discoverability |
| `audit-export` | Convert audit findings (Markdown) into a Teamwork-compatible CSV |
| `audit-report` | Generate a client-facing executive summary from an existing audit report |

---

### 📋 [Project Planning](planning.md)

Generate FRDs, estimate work, and produce importable backlogs.

| Skill | Description |
|-------|-------------|
| `frd-generator` | Generate a Functional Requirements Document with 10-section structure and platform-specific subsections |
| `story-point-estimator` | Fibonacci-based estimation with hour conversion and velocity calculations |
| `csv-exporter` | Convert FRD requirements into a Teamwork-ready CSV backlog |

---

### 📂 [Project Management — Teamwork](project-management.md)

Direct Teamwork integration. Skills call the Teamwork MCP from the main session.

| Skill | Description |
|-------|-------------|
| `teamwork-task-creator` | Create a Teamwork task with template selection (Big Task/Epic, Little Task, QA Handoff, Bug Report) |
| `teamwork-integrator` | Look up Teamwork tasks (read-only) and surface project context |
| `teamwork-exporter` | Batch-export audit findings as Teamwork tasks with priority mapping |

**Requires:** Teamwork MCP server.

---

### 🗂 [PM Workflows](pm-workflows.md)

Client communication, meeting prep, status updates, and full QA review.

| Skill | Description |
|-------|-------------|
| `client-request-triage` | Triage a client Teamwork task — research options, draft a reply |
| `pm-meeting-prep` | Aggregate context from Teamwork, Slack, Gmail, and Fathom into a meeting briefing |
| `project-heartbeat` | Draft a client-facing project status update ready to post to Teamwork |
| `qa-review` | Full QA validation of a multidev environment from a Teamwork task |

**Requires:** Teamwork MCP plus Slack / Gmail / Fathom / CoWork depending on the skill.

---

### 🧭 [Strategy](strategy.md)

Strategist-focused discovery audits. Distinct from developer audits — output is client-safe and presentation-ready.

| Skill | Description |
|-------|-------------|
| `strategist-site-audit` | Audit a site against the 21 Laws of UX, review content hierarchy, run Lighthouse, produce a Markdown summary plus an iterable HTML Artifact |

**Requires:** CoWork browser automation.

---

### 🌐 [Drupal.org Contribution](../drupal-contribution.md)

Contribute back to drupal.org — issues, merge requests, and full workflows.

| Skill | Description |
|-------|-------------|
| `drupal-contribute` | Full drupal.org contribution workflow: open an issue and set up a merge request |
| `drupal-issue` | Create, update, or manage an issue on drupal.org (guided clipboard + browser) |
| `drupal-mr` | Create and manage a merge request via `git.drupalcode.org` |
| `drupal-cleanup` | List and clean up cloned drupal.org repositories in the local cache |
| `drupalorg-issue-helper` | Quick help formatting drupal.org issue templates |
| `drupalorg-contribution-helper` | Quick help with drupal.org git workflows |

---

### 🚀 [DevOps Setup](devops.md)

Automate Kanopi's Drupal/Pantheon onboarding.

| Skill | Description |
|-------|-------------|
| `devops-setup` | Full Kanopi DevOps onboarding (GitHub repo, Pantheon, CircleCI, code quality, quicksilver) |

**Requires:** GitHub CLI (`gh`), Terminus CLI.

---

### 🧩 Setup & Configuration

| Skill | Description |
|-------|-------------|
| `wp-add-skills` | Install official `WordPress/agent-skills` (block development, REST API, WP-CLI, performance) from the WordPress org's repository |
| `wp-plugin-to-private-package` | Convert a committed WordPress premium plugin into a Kanopi private Composer package and rewire the site to install it via Composer (Installation Policy §3–§4) |

---

### 🧠 Strategic Thinking (cross-cutting)

| Skill | Description |
|-------|-------------|
| `strategic-thinking` | Guide significant decisions using Brené Brown's 5 Cs (Context, Color, Connective Tissue, Cost, Consequence). Activates conversationally — no dedicated category page. |

---

## Platform-Specific Features

### Drupal Support

- Configuration change detection (`config/sync/`)
- Custom module analysis
- Hook implementation detection
- Entity and field change tracking
- Database update detection (`hook_update_N`)
- Views and Entity Query optimization
- Drupal caching analysis (page cache, render cache, cache tags)
- Drush command generation

### WordPress Support

- Theme and `functions.php` analysis
- Gutenberg block accessibility and performance
- ACF field group detection
- Custom post type and taxonomy analysis
- Shortcode implementation
- `WP_Query` optimization
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

## Next Steps

- **[PR Workflow Skills](pr-workflow.md)** — Detailed PR workflow guide
- **[Accessibility Skills](accessibility.md)** — WCAG compliance guide
- **[Performance Skills](performance.md)** — Optimization strategies
- **[Strategy](strategy.md)** — Discovery-phase audits
- **[Project Planning](planning.md)** — FRDs and backlogs
- **[PM Workflows](pm-workflows.md)** — Client communication and QA review
- **[DevOps Setup](devops.md)** — Drupal/Pantheon onboarding automation
- **[Quick Start](../quick-start.md)** — Common workflow examples
- **[Skill Naming Convention](../reference/skill-naming-convention.md)** — Why skills are named the way they are
