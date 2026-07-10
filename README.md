# CMS Cultivator

![Maintained](https://img.shields.io/maintenance/yes/2026.svg)
[![Documentation](https://img.shields.io/badge/docs-zensical-blue.svg)](https://kanopi.github.io/cms-cultivator/)

Specialist agents and auto-invoked skills for Drupal/WordPress development. Works in Claude Code, Claude Desktop, and OpenAI Codex.

**Full documentation:** [https://kanopi.github.io/cms-cultivator/](https://kanopi.github.io/cms-cultivator/)

---

## Quick Start

**Claude Code — Via Marketplace (Recommended)**

```bash
# Add the Claude Toolbox marketplace
/plugin marketplace add kanopi/claude-toolbox

# Install CMS Cultivator
/plugin install cms-cultivator@claude-toolbox
```

**Claude Code — Direct Install**

```bash
/plugin install https://github.com/kanopi/cms-cultivator
```

**OpenAI Codex — Via Marketplace**

```bash
# Add the Kanopi marketplace
codex plugin marketplace add kanopi/claude-toolbox

# Open the plugin browser and install CMS Cultivator
codex/plugins
```

See [Installation Guide](https://kanopi.github.io/cms-cultivator/installation/) for complete setup instructions.

---

## Key Features

### PR Workflows
Generate commit messages, PR descriptions, changelogs, and review code.

**Skills:**
- `commit-message-generator` - Generate conventional commit messages
- `pr-create` - Create PR with generated description
- `pr-review` - AI-assisted code review
- `pr-release` - Generate release PR with changelog

### Delivery Records
Per-output attestation: one schema-typed, human-signed markdown file per significant AI-assisted output (code, FRD, audit, discovery, design handoff, strategy, client comms). [Schema reference](https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1/).

**Skills:**
- `delivery-record` - Draft a Delivery Record, require a named reviewer + checkpoint notes, write the file, and index it in Teamwork
- `delivery-record-verify` - Validate a record against the schema and the threshold rule (read-only; CI-friendly)

### Quality Analysis
Code standards, test coverage, accessibility, security audits.

**Skills:**
- `quality-audit` - Technical debt and code quality
- `code-standards-checker` - Coding standards compliance (PHPCS, ESLint)
- `test-scaffolding` - Generate test scaffolding
- `coverage-analyzer` - Analyze test coverage gaps
- `test-plan-generator` - Create comprehensive QA test plans

### Auditing
Comprehensive performance, accessibility, and security audits with flexible argument modes.

**Skills:**
- `accessibility-audit` - WCAG 2.1 Level AA compliance
- `security-audit` - OWASP Top 10 vulnerability scanning
- `performance-audit` - Core Web Vitals and optimization
- `quality-audit` - Code quality and technical debt
- `gtm-performance-audit` - Google Tag Manager performance impact (Chrome DevTools MCP)
- `structured-data-analyzer` - JSON-LD / Schema.org structured data for SEO
- `live-site-audit` - Comprehensive parallel audit (all specialists)
- `audit-export` - Export audit findings to CSV for project management tools
- `audit-report` - Generate client-facing executive summaries

### Design-to-Code
Figma → WordPress blocks, Drupal paragraphs with browser validation.

**Skills:**
- `design-to-wp-block` - Create WordPress block pattern
- `design-to-drupal-paragraph` - Create Drupal paragraph type
- `browser-validator` - Validate implementation in Chrome
- `drupal-sdc-twig` - Best practices for Drupal Single Directory Components (Twig)

### Development Workflow
Parallel work with git worktrees and safe changes to Composer-managed dependencies.

**Skills:**
- `worktree-manager` - Create, list, and tear down git worktrees (Kanopi branch conventions, DDEV isolation)
- `composer-patch-generator` - Generate and maintain CI-safe patches for Composer packages (cweagans/composer-patches)

### Drupal.org Contribution
Create issues and merge requests on drupal.org from your local environment.

**Skills:**
- `drupal-contribute` - Full contribution workflow (issue + merge request)
- `drupal-issue` - Create, update, and comment on drupal.org issues
- `drupal-mr` - Create merge requests via git.drupalcode.org
- `drupal-cleanup` - List and clean up cloned drupal.org repositories

### DevOps & Onboarding
Automate Kanopi's Pantheon DevOps setup for Drupal and WordPress.

**Skills:**
- `devops-setup` - Drupal/Pantheon DevOps onboarding (DDEV, CircleCI, code quality)
- `wp-devops-setup` - WordPress/Pantheon DevOps onboarding (wp-pantheon-starter)
- `wp-plugin-to-private-package` - Convert a premium WordPress plugin into a private Composer package
- `wp-add-skills` - Install official WordPress agent-skills

### Documentation
API docs, user guides, developer documentation, changelogs.

**Skill:**
- `documentation-generator` - Generate comprehensive documentation

### Project Planning
Generate Functional Requirements Documents, estimate work, and export task backlogs.

**Skills:**
- `frd-generator` - Generate comprehensive Functional Requirements Documents
- `story-point-estimator` - Fibonacci-based story point estimation with hour conversions
- `csv-exporter` - Convert FRD requirements into Teamwork-ready CSV backlogs

### PM Workflows
Aggregate context from Teamwork, Slack, Gmail, and Fathom for client communication and QA review. Requires connected MCP servers.

**Skills:**
- `client-request-triage` - Review a client task, research solutions, and draft a reply (Teamwork + web search)
- `pm-meeting-prep` - Aggregate context for an upcoming check-in (Teamwork + Slack + Gmail + Fathom)
- `project-heartbeat` - Draft a client-facing project status update (Teamwork + Slack + Fathom)
- `qa-review` - Full QA validation of a multidev environment from a Teamwork task (Teamwork + CoWork browser automation)

### Strategy
Strategist-focused discovery audits — not developer audits. Requires CoWork.

**Skills:**
- `strategist-site-audit` - Audit a site against the 21 UX Laws (lawsofux.com), review content hierarchy, synthesise qualitative data, run Lighthouse, and produce a Project Knowledge Summary (Markdown) plus an iterable client-facing HTML Artifact (CoWork)
- `strategic-thinking` - Guide decisions through Brené Brown's 5 Cs of Strategic Thinking

**See [docs site](https://kanopi.github.io/cms-cultivator/) for complete skill reference and usage examples.**

---

---

## Architecture

### Specialist Agents

Skills spawn specialized agents for focused, parallel work:

**Review/Audit Agents:**
- accessibility-specialist, code-quality-specialist, security-specialist, performance-specialist, structured-data-specialist

**Generation Agents:**
- documentation-specialist, testing-specialist, responsive-styling-specialist, design-specialist

**Browser Validation:**
- browser-validator-specialist

PR workflows (`pr-create`, `pr-review`, `pr-release`, `commit-message-generator`) run directly from the main session without an orchestrator agent — each skill contains its complete workflow.

### Agent Skills

Model-invoked skills that activate during conversation, across Claude Code, Claude Desktop, and OpenAI Codex:
- **PR & development workflow:** commit-message-generator, pr-create, pr-review, pr-release, worktree-manager, composer-patch-generator
- **Delivery records:** delivery-record, delivery-record-verify
- **Code quality & testing:** code-standards-checker, quality-audit, test-scaffolding, test-plan-generator, coverage-analyzer, documentation-generator
- **Auditing:** accessibility-checker, accessibility-audit, performance-analyzer, performance-audit, security-scanner, security-audit, structured-data-analyzer, gtm-performance-audit, live-site-audit, audit-export, audit-report
- **Design-to-code:** design-analyzer, design-to-wp-block, design-to-drupal-paragraph, responsive-styling, browser-validator, drupal-sdc-twig
- **Drupal.org contribution:** drupal-contribute, drupal-issue, drupal-mr, drupal-cleanup, drupalorg-contribution-helper, drupalorg-issue-helper
- **DevOps & onboarding:** devops-setup, wp-devops-setup, wp-plugin-to-private-package, wp-add-skills
- **Project planning:** frd-generator, story-point-estimator, csv-exporter
- **PM workflows:** teamwork-task-creator, teamwork-integrator, teamwork-exporter, client-request-triage, pm-meeting-prep, project-heartbeat, qa-review
- **Strategy:** strategic-thinking, strategist-site-audit

### How It Works

```
pr-create skill (main session)
    ├─→ Analyzes git changes
    ├─→ Reviews test coverage inline
    ├─→ Checks security concerns inline
    ├─→ Checks accessibility concerns inline
    ↓
Unified PR description → user approval → gh pr create

live-site-audit skill (main session)
    ├─→ Spawns performance-specialist (parallel)
    ├─→ Spawns accessibility-specialist (parallel)
    ├─→ Spawns security-specialist (parallel)
    ├─→ Spawns code-quality-specialist (parallel)
    ↓
Synthesize findings → Unified audit report
```

---

## Kanopi Integration

Integrates with [Kanopi's DDEV add-ons](https://kanopi.github.io/cms-cultivator/kanopi-tools/overview/) for:
- Composer scripts (code-check, phpstan, rector)
- DDEV commands (theme-build, cypress-run, critical-run)
- Drupal and WordPress project standards

---

## Requirements

**Required:**
- Claude Code CLI **or** OpenAI Codex
- Git

**Optional:**
- GitHub CLI (`gh`) - For PR skills
- DDEV - For Kanopi projects
- Chrome browser - For design validation skills

---

## Learn More

Visit the [complete documentation](https://kanopi.github.io/cms-cultivator/) for:
- Detailed skill reference with examples
- Agent and skill descriptions
- Platform-specific features (Drupal/WordPress)
- Kanopi integration guides
- Best practices and troubleshooting

---

## Contributing

Contributions welcome! See [Contributing Guide](https://kanopi.github.io/cms-cultivator/contributing/).

---

## License

GPL-2.0-or-later - see [LICENSE](LICENSE.md) for details.

---

## Support

- **Issues**: [GitHub Issues](https://github.com/kanopi/cms-cultivator/issues)
- **Docs**: [https://kanopi.github.io/cms-cultivator/](https://kanopi.github.io/cms-cultivator/)

---

**Created and maintained by [Kanopi Studios](https://kanopi.com)**
