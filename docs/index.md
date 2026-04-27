# CMS Cultivator

![Maintained](https://img.shields.io/maintenance/yes/2025.svg)
[![Documentation](https://img.shields.io/badge/docs-zensical-blue.svg)](https://kanopi.github.io/cms-cultivator/)

**CMS Cultivator** is a comprehensive Claude Code plugin providing 38 Agent Skills for Drupal and WordPress development. Streamline PR workflows, ensure accessibility compliance, optimize performance, enhance security, and maintain documentation across your projects.

## ✨ Features

### 38 Agent Skills
- **🔄 PR Workflow** - Streamline pull requests from commit to deployment
- **♿ Accessibility** - Ensure WCAG 2.1 Level AA compliance
- **⚡ Performance** - Optimize Core Web Vitals and page speed
- **🔒 Security** - Scan for vulnerabilities and security issues
- **🎨 Design Workflow** - Figma to WordPress blocks and Drupal paragraphs
- **🔍 Live Site Auditing** - Comprehensive audits using Chrome DevTools
- **📝 Documentation** - Generate comprehensive project documentation
- **🧪 Testing** - Create tests and analyze coverage
- **📊 Code Quality** - Maintain standards and reduce technical debt
- **🤖 Auto-Invoked** - Claude activates skills automatically during conversation
- **💬 Natural Language** - No need to remember command names
- **🎯 Context-Aware** - Activates when you need help

[Learn about Agents & Skills →](agents-and-skills.md)

---

## 📚 Documentation

| Section | Description |
|---------|-------------|
| **[Getting Started](installation.md)** | Installation and initial setup |
| **[Quick Start](quick-start.md)** | Common workflows and examples |
| **[Skills](commands/overview.md)** | Complete skills reference |
| **[Agents & Skills](agents-and-skills.md)** | Specialist agents and auto-invoked skills |
| **[Kanopi Tools](kanopi-tools/overview.md)** | Integration with Kanopi's DDEV add-ons |

---

## 🚀 Quick Example

Natural language (skills auto-activate):
```
"I need to commit my changes"       → generates commit message
"Is this button accessible?"        → checks accessibility
"This query is slow"                → analyzes performance
"Does this follow Drupal standards?" → checks code standards
```

Explicit invocation:
```bash
/pr-create PROJ-123   # Create PR with generated description
/pr-review self       # Review your changes before submitting
/audit-a11y           # Run accessibility audit
/audit-perf           # Analyze performance
/audit-security       # Check security
/quality-analyze      # Analyze code quality
```

---

## 🎯 Use Cases

### For Developers

#### Natural Language (Skills auto-activate)

- "I need to commit my changes" → Generates commit message
- "Is this button accessible?" → Checks accessibility
- "This query is slow" → Analyzes performance
- "Does this follow WordPress standards?" → Checks code standards
- "I need tests for this class" → Generates test scaffolding

#### Explicit Invocation

- **Before PR**: `/pr-review self` - Self-review your changes
- **Creating PR**: `/pr-create` - Generate and create PR automatically
- **Full audits**: `/audit-perf`, `/audit-a11y`, `/audit-security` - Comprehensive analysis

### For Tech Leads

#### Natural Language

- "What code isn't tested?" → Coverage analysis
- "Is this secure?" → Security check
- "What should QA test?" → Test plan generation

#### Explicit Invocation

- **Code review**: `/pr-review 123` - Get AI-assisted code review
- **Performance audits**: `/audit-perf` - Identify bottlenecks
- **Quality analysis**: `/quality-analyze` - Technical debt assessment

### For Project Managers

#### Explicit Invocation (Reports)

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
3. **[Explore Skills](commands/overview.md)** - Discover all 38 available skills
4. **[Integrate Kanopi Tools](kanopi-tools/overview.md)** - Use with DDEV add-ons
