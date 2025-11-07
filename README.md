# CMS Cultivator

![Maintained](https://img.shields.io/maintenance/yes/2025.svg)
[![Documentation](https://img.shields.io/badge/docs-mkdocs-blue.svg)](https://kanopi.github.io/cms-cultivator/)

**CMS Cultivator** is a comprehensive Claude Code plugin providing specialized slash commands for Drupal and WordPress development. Streamline PR workflows, ensure accessibility compliance, optimize performance, enhance security, and maintain documentation across your projects.

---

## 📚 Documentation

**Complete documentation is available at:** **[https://kanopi.github.io/cms-cultivator/](https://kanopi.github.io/cms-cultivator/)**

### Quick Links

| Resource | Description |
|----------|-------------|
| **[Installation](https://kanopi.github.io/cms-cultivator/installation/)** | Get started in minutes |
| **[Quick Start](https://kanopi.github.io/cms-cultivator/quick-start/)** | Common workflows and examples |
| **[Commands](https://kanopi.github.io/cms-cultivator/commands/overview/)** | Complete command reference (14 commands) |
| **[Kanopi Tools](https://kanopi.github.io/cms-cultivator/kanopi-tools/overview/)** | Integration with DDEV add-ons |
| **[Contributing](https://kanopi.github.io/cms-cultivator/contributing/)** | Contribute to the project |

---

## ✨ Features

- **🔄 4 PR Workflow Commands** - From commit to deployment
- **♿ 1 Accessibility Command** - WCAG 2.1 Level AA compliance
- **⚡ 1 Performance Command** - Core Web Vitals optimization
- **🔒 1 Security Command** - Vulnerability scanning
- **🔍 1 Live Site Audit Command** - Comprehensive audits with Chrome DevTools
- **📝 1 Documentation Command** - API docs, guides, changelogs
- **🧪 3 Testing Commands** - Test generation and coverage
- **📊 2 Code Quality Commands** - Standards and technical debt

---

## 🚀 Quick Install

**Recommended: Via Marketplace**

Inside Claude Code CLI:

```bash
# Add the Claude Toolbox marketplace
/plugin marketplace add kanopi/claude-toolbox

# Install CMS Cultivator
/plugin install cms-cultivator@claude-toolbox
```

**Alternative: Direct Install**

Inside Claude Code CLI:

```bash
/plugin install https://github.com/kanopi/cms-cultivator
```

See [Installation Guide](https://kanopi.github.io/cms-cultivator/installation/) for project-specific installation and more options.

---

## 💡 Quick Example

```bash
# Create PR with generated description
/pr-create PROJ-123

# Review your changes before submitting
/pr-review self

# Run accessibility audit
/audit-a11y

# Analyze performance
/audit-perf

# Check security
/audit-security

# Analyze code quality
/quality-analyze
```

---

## 🎯 Use Cases

### For Developers
- `/pr-commit-msg` - Generate proper commit messages
- `/pr-create` - Generate and create PRs automatically
- `/pr-review self` - Self-review before submitting PR
- `/audit-perf queries` - Catch performance issues early
- `/audit-a11y` - Ensure accessibility compliance

### For Tech Leads
- `/pr-review 123` - AI-assisted code review
- `/audit-perf` - Identify bottlenecks
- `/audit-security` - Comprehensive security scan

### For Project Managers
- `/audit-perf report` - Executive-friendly reports
- `/audit-a11y report` - Accessibility documentation
- `/audit-security report` - Security posture and compliance

---

## 🛠 Platform Support

### Drupal & WordPress
- Configuration change detection
- Module/theme/plugin analysis
- Database query optimization
- Caching analysis
- Drush/WP-CLI integration

### Kanopi Projects
Seamless integration with [Kanopi's DDEV add-ons](https://kanopi.github.io/cms-cultivator/kanopi-tools/overview/):

- **Composer Scripts** - Quality checks, testing, code standards
- **DDEV Commands** - Theme builds, database management, testing tools

---

## 📋 Requirements

### Required

- **Claude Code CLI** - To run the plugin commands
- **Git** - For version control operations

### Optional

- **GitHub CLI (`gh`)** - For PR creation and management commands
- **DDEV** - For Kanopi projects with enhanced workflows
- **Python 3.x & pip** - For building/contributing to documentation
  - Required if you want to build documentation locally
  - Install MkDocs: `pip install mkdocs-material mkdocs-git-revision-date-localized-plugin`
- **BATS** - For running the test suite (contributors only)
  - macOS: `brew install bats-core`
  - Linux: `sudo apt-get install bats`

---

## 📖 Learn More

Visit the **[complete documentation](https://kanopi.github.io/cms-cultivator/)** for:

- Detailed command reference
- Platform-specific features
- Integration guides
- Best practices
- Troubleshooting

---

## 🤝 Contributing

Contributions welcome! See [Contributing Guide](https://kanopi.github.io/cms-cultivator/contributing/) for details.

---

## 📄 License

GPL-2.0-or-later - see [LICENSE](LICENSE.md) file for details.

---

## 💬 Support

- **Issues**: [GitHub Issues](https://github.com/kanopi/cms-cultivator/issues)
- **Documentation**: [https://kanopi.github.io/cms-cultivator/](https://kanopi.github.io/cms-cultivator/)

---

**Created and maintained by [Kanopi Studios](https://kanopi.com)**
