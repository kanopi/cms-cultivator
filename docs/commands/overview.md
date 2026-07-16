# Skills Overview

CMS Cultivator provides Agent Skills organized into categories. Each skill integrates with Drupal and WordPress projects and works across Claude Code, Claude Desktop, and OpenAI Codex.

Skills activate in two ways:

- **Automatically** — Claude recognizes context and invokes the right skill without you asking. Say "I need to commit my changes" and `commit-message-generator` activates.
- **Explicitly** — Invoke any skill by name. In Claude Code: `/pr-create`. In Codex: `@pr-create`. In Claude Desktop: type the skill name and Claude will load it.

!!! note "What changed in 2.0"
    As of 2.0, CMS Cultivator focuses on CMS development workflows. Delivery Record moved to its own public library: [kanopi/delivery-record](https://github.com/kanopi/delivery-record). Audit, DevOps, and PM capabilities moved to separate internal Kanopi libraries.

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
| `worktree-manager` | Create, list, and tear down git worktrees with Kanopi branch naming and automatic DDEV isolation so multiple tickets (and AI sessions) run in parallel from one clone |

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

### 🧪 [Testing](testing.md)

Generate tests and QA test plans.

| Skill | Description |
|-------|-------------|
| `test-scaffolding` | Generate test scaffolding (unit, integration, e2e) for a class or function |
| `test-plan-generator` | Generate a comprehensive QA test plan from code changes |
| `coverage-analyzer` | Test coverage gap analysis |

---

### 📊 [Code Quality](code-quality.md)

Maintain coding standards and manage dependencies.

| Skill | Description |
|-------|-------------|
| `code-standards-checker` | Check code against project standards (PHPCS, ESLint, Drupal/WordPress) |
| `composer-patch-generator` | Generate CI-safe patches for Composer packages (correct `diff -ruN` format, `extra.patches` wiring, verification) |

---

### 📝 [Documentation](documentation.md)

Generate and maintain project documentation.

| Skill | Description |
|-------|-------------|
| `documentation-generator` | Generate documentation (API docs/PHPDoc/JSDoc, README, user guides, changelogs) |

---

### 🧱 Drupal Development

Component-building guidance for Drupal themes and modules.

| Skill | Description |
|-------|-------------|
| `drupal-sdc-twig` | Best practices for Single Directory Components with Twig — props vs slots, `attributes`, `include` vs `embed`, escaping, schema, accessibility |

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

### 🧩 [WordPress Meta](wordpress-meta.md)

Extend CMS Cultivator with WordPress-specific tooling from other sources.

| Skill | Description |
|-------|-------------|
| `wp-add-skills` | Install official `WordPress/agent-skills` (block development, REST API, WP-CLI, performance) from the WordPress org's repository |

---

## Platform-Specific Features

### Drupal Support

- Configuration change detection (`config/sync/`)
- Custom module analysis
- Hook implementation detection
- Entity and field change tracking
- Database update detection (`hook_update_N`)
- Single Directory Component (SDC) guidance
- Drush command generation

### WordPress Support

- Theme and `functions.php` analysis
- Gutenberg block pattern generation
- ACF field group detection
- Custom post type and taxonomy analysis
- Shortcode implementation
- WP-CLI command generation

---

## Integration with Kanopi Tools

Skills automatically integrate with [Kanopi's DDEV add-ons](../kanopi-tools/overview.md):

- **Quality skills** use `ddev composer code-check`, `phpstan`, `rector-check`
- **Design skills** suggest `ddev theme-build` and `ddev theme-watch`
- **Testing skills** leverage `ddev cypress-run` for E2E tests
- **Worktree management** derives DDEV project names per worktree for isolation

---

## Next Steps

- **[PR Workflow Skills](pr-workflow.md)** — Detailed PR workflow guide
- **[Design Workflow Skills](design-workflow.md)** — Figma-to-component workflows
- **[Testing Skills](testing.md)** — Tests and QA plans
- **[Drupal.org Contribution](drupal-contribution-skills.md)** — Contribute back to drupal.org
- **[Quick Start](../quick-start.md)** — Common workflow examples
- **[Skill Naming Convention](../reference/skill-naming-convention.md)** — Why skills are named the way they are
