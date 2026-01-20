# CMS Cultivator

![Maintained](https://img.shields.io/maintenance/yes/2025.svg)
[![Documentation](https://img.shields.io/badge/docs-zensical-blue.svg)](https://kanopi.github.io/cms-cultivator/)

**CMS Cultivator** is a comprehensive Claude Code plugin providing specialized slash commands and auto-invoked Agent Skills for Drupal and WordPress development. Streamline PR workflows, ensure accessibility compliance, optimize performance, enhance security, and maintain documentation across your projects.

## ✨ Features

### Slash Commands (User-Invoked)
- **🔄 PR Workflow** - Streamline pull requests from commit to deployment
- **♿ Accessibility** - Ensure WCAG 2.1 Level AA compliance
- **⚡ Performance** - Optimize Core Web Vitals and page speed
- **🔒 Security** - Scan for vulnerabilities and security issues
- **🎨 Design Workflow** - Figma to WordPress blocks and Drupal paragraphs
- **🔍 Live Site Auditing** - Comprehensive audits using Chrome DevTools
- **📝 Documentation** - Generate comprehensive project documentation
- **🧪 Testing** - Create tests and analyze coverage
- **📊 Code Quality** - Maintain standards and reduce technical debt

### Agent Skills (Auto-Invoked)
- **🤖 Intelligent Skills** - Claude automatically helps during conversation
  - Commit message generation
  - Code standards checking
  - Test scaffolding
  - Documentation generation
  - And more...
- **💬 Natural Language** - No need to remember command names
- **🎯 Context-Aware** - Activates when you need help

[Learn about Agents & Skills →](agents-and-skills.md)

---

## 📚 Documentation

| Section | Description |
|---------|-------------|
| **[Getting Started](installation.md)** | Installation and initial setup |
| **[Quick Start](quick-start.md)** | Common workflows and examples |
| **[Commands](commands/overview.md)** | Complete command reference |
| **[Agents & Skills](agents-and-skills.md)** | Specialist agents and auto-invoked skills |
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

**Natural Language (Agent Skills auto-activate):**
- "I need to commit my changes" → Generates commit message
- "Is this button accessible?" → Checks accessibility
- "This query is slow" → Analyzes performance
- "Does this follow WordPress standards?" → Checks code standards
- "I need tests for this class" → Generates test scaffolding

**Explicit Commands:**
- **Before PR**: `/pr-review self` - Self-review your changes
- **Creating PR**: `/pr-create` - Generate and create PR automatically
- **Full audits**: `/audit-perf`, `/audit-a11y`, `/audit-security` - Comprehensive analysis

### For Tech Leads

**Natural Language:**
- "What code isn't tested?" → Coverage analysis
- "Is this secure?" → Security check
- "What should QA test?" → Test plan generation

**Explicit Commands:**
- **Code review**: `/pr-review 123` - Get AI-assisted code review
- **Performance audits**: `/audit-perf` - Identify bottlenecks
- **Quality analysis**: `/quality-analyze` - Technical debt assessment

### For Project Managers

**Explicit Commands (Reports):**
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
3. **[Explore Commands](commands/overview.md)** - Discover all available commands
4. **[Integrate Kanopi Tools](kanopi-tools/overview.md)** - Use with DDEV add-ons
