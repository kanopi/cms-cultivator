# CMS Cultivator

![Maintained](https://img.shields.io/maintenance/yes/2025.svg)
[![Documentation](https://img.shields.io/badge/docs-zensical-blue.svg)](https://kanopi.github.io/cms-cultivator/)

**CMS Cultivator** is a plugin for Claude Code, Claude Desktop, and OpenAI Codex providing Agent Skills for Drupal and WordPress development. Streamline PR workflows, convert designs into components, generate tests, contribute back to drupal.org, and maintain documentation.

!!! note "What changed in 2.0"
    As of 2.0, CMS Cultivator focuses on CMS development workflows. Delivery Record moved to its own public library: [kanopi/delivery-record](https://github.com/kanopi/delivery-record). Audit, DevOps, and PM capabilities moved to separate internal Kanopi libraries.

## ✨ Features

### Agent Skills
- **🔄 PR Workflow** - Streamline pull requests from commit to deployment, with worktree management for parallel tickets
- **🎨 Design Workflow** - Figma to WordPress blocks and Drupal paragraphs, with responsive styling and in-browser validation
- **🧪 Testing** - Create tests, generate QA test plans, and analyze coverage
- **📊 Code Quality** - Check coding standards and generate CI-safe Composer patches
- **📝 Documentation** - Generate comprehensive project documentation
- **🧱 Drupal Development** - Single Directory Component (SDC) and Twig best practices
- **🌐 Drupal.org Contribution** - Guided issue and merge request workflows for contributing back
- **🧩 WordPress Meta** - Install the official WordPress/agent-skills catalog alongside CMS Cultivator
- **🤖 Auto-Invoked** - Claude activates skills automatically during conversation
- **💬 Natural Language** - No need to remember command names
- **🎯 Context-Aware** - Activates when you need help
- **🌐 Multi-Platform** - Works in Claude Code, Claude Desktop, and OpenAI Codex

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
"I need to commit my changes"        → generates commit message
"Create a block from this design"    → builds a WordPress block pattern
"I need tests for this class"        → generates test scaffolding
"Does this follow Drupal standards?" → checks code standards
```

Explicit invocation:
```bash
/pr-create PROJ-123        # Create PR with generated description
/pr-review self            # Review your changes before submitting
/worktree-manager create 123 hero-block   # Start a ticket in a fresh worktree
/design-to-wp-block design.png hero-cta   # Design to WordPress block pattern
/browser-validator http://site.ddev.site/test-page   # Validate in a real browser
/drupal-contribute         # Contribute a fix back to drupal.org
```

---

## 🎯 Use Cases

### For Developers

#### Natural Language (Skills auto-activate)

- "I need to commit my changes" → Generates commit message
- "Does this follow WordPress standards?" → Checks code standards
- "I need tests for this class" → Generates test scaffolding
- "Props or slots for this SDC?" → Drupal component guidance
- "Implement this design" → Extracts specs from the Figma reference

#### Explicit Invocation

- **Before PR**: `/pr-review self` - Self-review your changes
- **Creating PR**: `/pr-create` - Generate and create PR automatically
- **Design-to-code**: `/design-to-wp-block`, `/design-to-drupal-paragraph` - Components from Figma

### For Tech Leads

#### Natural Language

- "What code isn't tested?" → Coverage analysis
- "What should QA test?" → Test plan generation
- "Patch this contrib module" → CI-safe Composer patch

#### Explicit Invocation

- **Code review**: `/pr-review 123` - Get AI-assisted code review
- **Release prep**: `/pr-release` - Changelog and deployment checklist
- **Contribution**: `/drupal-contribute` - Upstream fixes to drupal.org

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

- Claude Code CLI **or** OpenAI Codex
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
3. **[Explore Skills](commands/overview.md)** - Discover all available skills
4. **[Integrate Kanopi Tools](kanopi-tools/overview.md)** - Use with DDEV add-ons
