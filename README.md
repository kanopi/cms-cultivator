# CMS Cultivator

![Maintained](https://img.shields.io/maintenance/yes/2025.svg)
[![Documentation](https://img.shields.io/badge/docs-zensical-blue.svg)](https://kanopi.github.io/cms-cultivator/)

Specialist agents, slash commands, and auto-invoked skills for Drupal/WordPress development.

**Full documentation:** [https://kanopi.github.io/cms-cultivator/](https://kanopi.github.io/cms-cultivator/)

---

## Quick Start

**Via Marketplace (Recommended)**

```bash
# Add the Claude Toolbox marketplace
/plugin marketplace add kanopi/claude-toolbox

# Install CMS Cultivator
/plugin install cms-cultivator@claude-toolbox
```

**Direct Install**

```bash
/plugin install https://github.com/kanopi/cms-cultivator
```

See [Installation Guide](https://kanopi.github.io/cms-cultivator/installation/) for complete setup instructions.

---

## Key Features

### PR Workflows
Generate commit messages, PR descriptions, changelogs, and review code.

**Commands:**
- `/pr-commit-msg` - Generate conventional commit messages
- `/pr-create [ticket]` - Create PR with generated description
- `/pr-review [pr-number|self]` - AI-assisted code review
- `/pr-release [ticket]` - Generate release PR with changelog

### Quality Analysis
Code standards, test coverage, accessibility, security audits.

**Commands:**
- `/quality-analyze [focus]` - Technical debt and code quality
- `/quality-standards` - Coding standards compliance (PHPCS, ESLint)
- `/test-generate [file]` - Generate test scaffolding
- `/test-coverage` - Analyze test coverage gaps
- `/test-plan` - Create comprehensive QA test plans

### Auditing
Comprehensive performance, accessibility, and security audits with flexible argument modes.

**Commands:**
- `/audit-a11y [options]` - WCAG 2.1 Level AA compliance
- `/audit-security [options]` - OWASP Top 10 vulnerability scanning
- `/audit-perf [options]` - Core Web Vitals and optimization
- `/quality-analyze [options]` - Code quality and technical debt
- `/audit-live-site [url]` - Comprehensive parallel audit (all specialists)
- `/export-audit-csv [report-file]` - Export audit findings to CSV for project management tools

### Design-to-Code
Figma → WordPress blocks, Drupal paragraphs with browser validation.

**Commands:**
- `/design-to-block <design> <block-name>` - Create WordPress block pattern
- `/design-to-paragraph <design> <paragraph-name>` - Create Drupal paragraph type
- `/design-validate <url>` - Validate implementation in Chrome

### Documentation
API docs, user guides, developer documentation, changelogs.

**Command:**
- `/docs-generate [focus]` - Generate comprehensive documentation

**See [docs site](https://kanopi.github.io/cms-cultivator/) for complete command reference and usage examples.**

---

## Flexible Audit Modes (NEW in v0.6)

Audit and quality commands now support multiple operation modes:

### Quick Checks (Pre-Commit)
```bash
/audit-a11y --quick --scope=current-pr
/audit-perf --quick --scope=current-pr --format=metrics
/audit-security --quick --scope=current-pr --min-severity=high
/quality-analyze --quick --scope=current-pr --max-complexity=10
```
- ⚡ Fast execution (~5 min)
- 🎯 Critical issues only
- 💰 Lower token costs
- ✅ Perfect for rapid iteration

### Standard Audits (PR Review)
```bash
/audit-a11y --standard --scope=current-pr
/audit-perf --standard --scope=backend
/audit-security --standard --scope=auth
/quality-analyze --standard --scope=recent-changes
```
- 🔍 Comprehensive analysis (~15 min)
- ✅ Full compliance checks
- 📊 Detailed reports

### Comprehensive Audits (Pre-Release)
```bash
/audit-a11y --comprehensive --format=summary
/audit-perf --comprehensive --target=good
/audit-security --comprehensive --format=sarif
/quality-analyze --comprehensive --format=refactoring-plan
```
- 🔬 Deep analysis (~30 min)
- 💎 Best practices included
- 📋 Stakeholder-ready reports

### CI/CD Integration
```bash
# Export as JSON for automated pipelines
/audit-a11y --standard --format=json > a11y.json
/audit-perf --standard --format=json > perf.json
/audit-security --standard --format=sarif > security.sarif
```
- 🤖 Machine-readable output
- ✅ Quality gates in CI/CD
- 🔒 Security tool integration (SARIF)

**Full guide:** [Using Argument Modes](https://kanopi.github.io/cms-cultivator/guides/using-argument-modes/)

---

## Architecture

### Specialist Agents

Commands spawn specialized agents that orchestrate complex workflows:

**Review/Audit Agents** (Green):
- accessibility-specialist, code-quality-specialist, security-specialist, performance-specialist

**Generation Agents** (Blue):
- documentation-specialist, testing-specialist, responsive-styling-specialist

**Orchestrators** (Purple):
- workflow-specialist, live-audit-specialist, design-specialist

**Browser Validation** (Orange):
- browser-validator-specialist

### Agent Skills

Model-invoked skills that activate during conversation:
- accessibility-checker, security-scanner, performance-analyzer
- commit-message-generator, test-scaffolding, coverage-analyzer
- documentation-generator, test-plan-generator, code-standards-checker
- design-analyzer, responsive-styling, browser-validator

### How It Works

```
/pr-create → workflow-specialist
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
- Claude Code CLI
- Git

**Optional:**
- GitHub CLI (`gh`) - For PR commands
- DDEV - For Kanopi projects
- Chrome browser - For design validation commands

---

## Learn More

Visit the [complete documentation](https://kanopi.github.io/cms-cultivator/) for:
- Detailed command reference with examples
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
