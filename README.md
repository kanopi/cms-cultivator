# CMS Cultivator

![Maintained](https://img.shields.io/maintenance/yes/2025.svg)
[![Documentation](https://img.shields.io/badge/docs-mkdocs-blue.svg)](https://kanopi.github.io/cms-cultivator/)

**CMS Cultivator** is a comprehensive Claude Code plugin providing **11 specialist agents**, **17 specialized commands**, and **12 Agent Skills** for Drupal and WordPress development. Agents orchestrate complex workflows with parallel execution, while commands and skills provide explicit control and conversational assistance. Streamline PR workflows, ensure accessibility compliance, optimize performance, enhance security, maintain documentation, and accelerate design-to-code workflows across your projects.

---

## 📚 Documentation

**Complete documentation is available at:** **[https://kanopi.github.io/cms-cultivator/](https://kanopi.github.io/cms-cultivator/)**

### Quick Links

| Resource | Description |
|----------|-------------|
| **[Installation](https://kanopi.github.io/cms-cultivator/installation/)** | Get started in minutes |
| **[Quick Start](https://kanopi.github.io/cms-cultivator/quick-start/)** | Common workflows and examples |
| **[Commands](https://kanopi.github.io/cms-cultivator/commands/overview/)** | Complete command reference (17 commands) |
| **[Agents & Skills](https://kanopi.github.io/cms-cultivator/agents-and-skills/)** | 11 specialist agents + 12 auto-invoked skills |
| **[Kanopi Tools](https://kanopi.github.io/cms-cultivator/kanopi-tools/overview/)** | Integration with DDEV add-ons |
| **[Contributing](https://kanopi.github.io/cms-cultivator/contributing/)** | Contribute to the project |

---

## ✨ Features

### 11 Specialist Agents 🆕
- **🤖 Agent-Orchestrated Architecture** - Commands spawn specialized agents
- **⚡ Parallel Execution** - Multiple agents work simultaneously
- **🎯 Smart Orchestration** - Agents collaborate and delegate tasks
- **🧩 Modular & Composable** - Each agent has one clear responsibility
- Agents: workflow, accessibility, performance, security, testing, documentation, live-audit, code-quality, design, browser-validator, responsive-styling

### Slash Commands (User-Invoked)
- **🔄 4 PR Workflow Commands** - From commit to deployment
- **♿ 1 Accessibility Command** - WCAG 2.1 Level AA compliance
- **⚡ 1 Performance Command** - Core Web Vitals optimization
- **🔒 1 Security Command** - Vulnerability scanning
- **🔍 1 Live Site Audit Command** - Comprehensive audits with Chrome DevTools
- **🎨 3 Design Workflow Commands** - Design-to-code with browser validation
- **📝 1 Documentation Command** - API docs, guides, changelogs
- **🧪 3 Testing Commands** - Test generation and coverage
- **📊 2 Code Quality Commands** - Standards and technical debt

### Agent Skills (Auto-Invoked)
- **🤖 12 Intelligent Skills** - Claude automatically helps during conversation
- **💬 Natural Language** - No need to remember command names
- **🎯 Context-Aware** - Activates when you need assistance
- Skills for: commits, testing, docs, security, performance, accessibility, design analysis, responsive styling, browser validation, and more

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

# Design-to-code workflows
/design-to-block design.png hero-cta
/design-to-paragraph design.png content-section
/design-validate http://site.ddev.site/test-page
```

---

## 🏗 Architecture

CMS Cultivator uses an **agent-orchestrated architecture** with 11 specialized agents that collaborate to provide comprehensive CMS development support.

### 11 Specialist Agents

Commands spawn specialized agents that handle complex workflows:

**Leaf Specialists** (work independently):
- **accessibility-specialist** - WCAG compliance and a11y audits
- **performance-specialist** - Core Web Vitals and optimization
- **security-specialist** - Vulnerability scanning and security audits
- **documentation-specialist** - API docs, guides, changelogs
- **code-quality-specialist** - Code standards and technical debt
- **browser-validator-specialist** - Browser-based validation with Chrome DevTools MCP
- **responsive-styling-specialist** - Mobile-first CSS/SCSS generation

**Orchestrators** (delegate to other agents):
- **workflow-specialist** - PR creation, reviews, deployment (delegates to testing, security, accessibility)
- **live-audit-specialist** - Comprehensive site audits (delegates to performance, accessibility, security, code-quality)
- **testing-specialist** - Test generation and coverage (delegates to security, accessibility)
- **design-specialist** - Design-to-code workflows (delegates to responsive-styling, browser-validator)

### How It Works

```
User runs /pr-create
    ↓
Spawns workflow-specialist
    ↓
    ├─→ Analyzes git changes
    ├─→ Generates commit message (skill)
    ├─→ Spawns testing-specialist (if tests needed)
    ├─→ Spawns security-specialist (if security-critical)
    ├─→ Spawns accessibility-specialist (if UI changes)
    ↓
Compiles findings into PR description
    ↓
Creates PR via GitHub CLI
```

### Agent Benefits

**For Users:**
- 🚀 **Parallel Execution** - Multiple specialists work simultaneously
- 🎯 **Comprehensive Checks** - Orchestrators ensure nothing is missed
- 📊 **Unified Reporting** - Clear findings from multiple specialists

**For Developers:**
- 🧩 **Modular Design** - Each specialist has one clear responsibility
- 🔧 **Composable** - Agents can be combined in new ways
- ✅ **Maintainable** - Clean separation of concerns

### Skills as Knowledge, Agents as Execution

- **12 Agent Skills** provide detailed "how-to" knowledge
- **11 Specialist Agents** execute workflows using those skills
- **17 Slash Commands** provide user-facing interfaces

---

## 🎯 Use Cases

### For Developers

**Talk naturally** - Agent Skills auto-activate:
- "I need to commit" → Generates commit message
- "Is this accessible?" → Checks accessibility
- "Need tests for this" → Generates test scaffolding

**Or use commands** - Explicit control:
- `/pr-create` - Generate and create PRs
- `/pr-review self` - Self-review before PR
- `/audit-perf`, `/audit-a11y` - Full audits

### For Tech Leads

**Talk naturally:**
- "What's not tested?" → Coverage analysis
- "Is this secure?" → Security check

**Or use commands:**
- `/pr-review 123` - AI-assisted code review
- `/quality-analyze` - Technical debt assessment

### For Project Managers

**Generate reports:**
- `/audit-perf report` - Executive-friendly reports
- `/audit-a11y report` - Accessibility documentation
- `/audit-security report` - Security compliance

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
