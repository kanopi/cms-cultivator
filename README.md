# CMS Cultivator

![Maintained](https://img.shields.io/maintenance/yes/2026.svg)
[![Documentation](https://img.shields.io/badge/docs-zensical-blue.svg)](https://kanopi.github.io/cms-cultivator/)

Specialist agents and 38 auto-invoked skills for Drupal/WordPress development. Works in Claude Code, Claude Desktop, and OpenAI Codex.

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
- `pr-commit-msg` - Generate conventional commit messages
- `pr-create` - Create PR with generated description
- `pr-review` - AI-assisted code review
- `pr-release` - Generate release PR with changelog

### Quality Analysis
Code standards, test coverage, accessibility, security audits.

**Skills:**
- `quality-audit` - Technical debt and code quality
- `quality-standards` - Coding standards compliance (PHPCS, ESLint)
- `test-generate` - Generate test scaffolding
- `test-coverage` - Analyze test coverage gaps
- `test-plan` - Create comprehensive QA test plans

### Auditing
Comprehensive performance, accessibility, and security audits with flexible argument modes.

**Skills:**
- `accessibility-audit` - WCAG 2.1 Level AA compliance
- `security-audit` - OWASP Top 10 vulnerability scanning
- `performance-audit` - Core Web Vitals and optimization
- `quality-audit` - Code quality and technical debt
- `live-site-audit` - Comprehensive parallel audit (all specialists)
- `audit-export` - Export audit findings to CSV for project management tools
- `audit-report` - Generate client-facing executive summaries

### Design-to-Code
Figma → WordPress blocks, Drupal paragraphs with browser validation.

**Skills:**
- `design-to-wp-block` - Create WordPress block pattern
- `design-to-drupal-paragraph` - Create Drupal paragraph type
- `design-validate` - Validate implementation in Chrome

### Documentation
API docs, user guides, developer documentation, changelogs.

**Skill:**
- `docs-generate` - Generate comprehensive documentation

**See [docs site](https://kanopi.github.io/cms-cultivator/) for complete skill reference and usage examples.**

---

---

## Architecture

### Specialist Agents

Skills spawn specialized agents that orchestrate complex workflows:

**Review/Audit Agents:**
- accessibility-specialist, code-quality-specialist, security-specialist, performance-specialist, structured-data-specialist

**Generation Agents:**
- documentation-specialist, testing-specialist, responsive-styling-specialist

**Orchestrators:**
- workflow-specialist, live-audit-specialist, design-specialist

**Browser Validation:**
- browser-validator-specialist

### Agent Skills (38 total)

Model-invoked skills that activate during conversation, across Claude Code, Claude Desktop, and OpenAI Codex:
- accessibility-checker, security-scanner, performance-analyzer
- commit-message-generator, test-scaffolding, coverage-analyzer
- documentation-generator, test-plan-generator, code-standards-checker
- structured-data-analyzer, design-analyzer, responsive-styling, browser-validator
- accessibility-audit, performance-audit, security-audit, quality-audit
- live-site-audit, pr-review, audit-export, audit-report
- design-to-wp-block, design-to-drupal-paragraph, pr-create, pr-release
- devops-setup, drupal-contribute, drupal-issue, drupal-mr, drupal-cleanup, wp-add-skills

### How It Works

```
pr-create skill → workflow-specialist
    ├─→ Analyzes changes
    ├─→ Spawns testing-specialist (parallel)
    ├─→ Spawns security-specialist (parallel)
    ├─→ Spawns accessibility-specialist (parallel)
    ↓
Unified PR description → Create PR
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
