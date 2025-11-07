# CMS Cultivator

![Maintained](https://img.shields.io/maintenance/yes/2025.svg)
[![Documentation](https://img.shields.io/badge/docs-mkdocs-blue.svg)](https://kanopi.github.io/cms-cultivator/)

**CMS Cultivator** is a comprehensive Claude Code plugin providing 14 specialized commands for Drupal and WordPress development. Streamline PR workflows, ensure accessibility compliance, optimize performance, enhance security, and maintain documentation across your projects.

## ✨ Features

- **🔄 4 PR Workflow Commands** - Streamline pull requests from commit to deployment
- **♿ 1 Accessibility Command** - Ensure WCAG 2.1 Level AA compliance
- **⚡ 1 Performance Command** - Optimize Core Web Vitals and page speed
- **🔒 1 Security Command** - Scan for vulnerabilities and security issues
- **🔍 1 Live Site Audit Command** - Comprehensive audits using Chrome DevTools
- **📝 1 Documentation Command** - Generate comprehensive project documentation
- **🧪 3 Testing Commands** - Create tests and analyze coverage
- **📊 2 Code Quality Commands** - Maintain standards and reduce technical debt

---

## 📚 Documentation

| Section | Description |
|---------|-------------|
| **[Getting Started](installation.md)** | Installation and initial setup |
| **[Quick Start](quick-start.md)** | Common workflows and examples |
| **[Commands](commands/overview.md)** | Complete command reference |
| **[Kanopi Tools](kanopi-tools/overview.md)** | Integration with Kanopi's DDEV add-ons |

---

## 🚀 Quick Example

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
- **Before committing**: `/pr-commit-msg` - Generate proper commit messages
- **Before PR**: `/pr-review self` - Self-review your changes
- **Creating PR**: `/pr-create` - Generate and create PR automatically
- **During development**: `/audit-perf queries` - Catch performance issues early
- **During QA**: `/audit-a11y` - Ensure accessibility compliance

### For Tech Leads
- **Code review**: `/pr-review 123` - Get AI-assisted code review
- **Performance audits**: `/audit-perf` - Identify bottlenecks
- **Security audits**: `/audit-security` - Comprehensive security scan

### For Project Managers
- **Stakeholder reports**: `/audit-perf report` - Executive-friendly reports
- **Compliance reports**: `/audit-a11y report` - Accessibility documentation
- **Security reports**: `/audit-security report` - Security posture and compliance

---

## 🛠 Platform Support

### Drupal Features
- Configuration change detection
- Custom module analysis
- Hook implementation detection
- Entity and field change tracking
- Database update detection
- Drupal caching analysis
- Drush command generation

### WordPress Features
- Theme and functions.php analysis
- Gutenberg block accessibility
- ACF field group detection
- Custom post type analysis
- WP_Query optimization
- Object cache analysis
- WP-CLI command generation

### Kanopi Projects
CMS Cultivator integrates seamlessly with [Kanopi's DDEV add-ons](kanopi-tools/overview.md):

- **Composer Scripts** - Quality checks, testing, and code standards
- **DDEV Commands** - Theme builds, database management, testing tools
- **Multi-platform** - Works with both Drupal and WordPress starters

---

## 📋 Requirements

- Claude Code CLI
- Git
- GitHub CLI (`gh`) for PR creation commands
- Optional: Lighthouse, WebPageTest for performance analysis

---

## 🤝 Contributing

This plugin is maintained by [Kanopi Studios](https://kanopi.com). For issues, feature requests, or contributions, please visit our [GitHub repository](https://github.com/kanopi/cms-cultivator).

---

## 📄 License

MIT License - see LICENSE file for details.

---

## 💡 Next Steps

1. **[Install the plugin](installation.md)** - Get started in minutes
2. **[Try Quick Start examples](quick-start.md)** - Learn common workflows
3. **[Explore Commands](commands/overview.md)** - Discover all 19 commands
4. **[Integrate Kanopi Tools](kanopi-tools/overview.md)** - Use with DDEV add-ons

---

**Total Commands**: 19 (4 PR + 1 A11y + 5 Perf + 3 Security + 1 Docs + 3 Testing + 2 Quality)
