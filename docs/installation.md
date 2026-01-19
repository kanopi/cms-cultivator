# Installation

CMS Cultivator can be installed globally for all projects or per-project for team collaboration.

---

## Prerequisites

Before installing CMS Cultivator, ensure you have:

- **Claude Code CLI** installed and configured
- **Git** for version control
- **GitHub CLI** (`gh`) for PR creation commands (optional)
- **DDEV** (for Kanopi projects) - [Install DDEV](https://ddev.readthedocs.io/en/stable/)

---

## Installation Methods

!!! info "Global vs Project Installation"
    - **Methods 1-3** (Marketplace, Direct, Manual) install plugins **globally** - available in all your projects
    - **Method 4** (Project-Specific) installs plugins **per-project** - only available when working in that specific project directory

### Method 1: Via Marketplace (Recommended)

This is the easiest method and enables automatic updates. **Installs globally for all projects.**

#### Step 1: Start Claude Code

```bash
cd /path/to/your/project
claude
```

#### Step 2: Add the Claude Toolbox Marketplace

Inside Claude Code CLI:

```bash
/plugin marketplace add kanopi/claude-toolbox
```

#### Step 3: Install CMS Cultivator

```bash
/plugin install cms-cultivator@claude-toolbox
```

#### Step 4: Verify Installation

```bash
/plugin
```

Select "Manage Plugins" and you should see `cms-cultivator` in the list of installed plugins.

#### Updating Via Marketplace

Inside Claude Code CLI:

```bash
/plugin update cms-cultivator@claude-toolbox
```

---

### Method 2: Direct from GitHub

Install directly without adding a marketplace. **Installs globally for all projects.**

Inside Claude Code CLI:

```bash
/plugin install https://github.com/kanopi/cms-cultivator
```

This method installs the latest version from the main branch.

#### Updating Direct Installation

Inside Claude Code CLI:

```bash
/plugin update cms-cultivator
```

---

### Method 3: Manual Installation (Development)

For plugin development or testing local changes. **Installs globally for all projects.**

#### Step 1: Clone the Repository

```bash
cd ~/.claude/plugins
git clone https://github.com/kanopi/cms-cultivator.git
```

!!! note "Plugin Directory Location"
    The plugins directory is typically `~/.claude/plugins/`. Some systems may use `~/.config/claude/plugins/`. Check your system:
    ```bash
    ls -la ~/.claude/plugins/ 2>/dev/null || ls -la ~/.config/claude/plugins/
    ```

#### Step 2: Enable the Plugin

Inside Claude Code CLI:

```bash
/plugin enable cms-cultivator
```

#### Updating Manual Installation

```bash
cd ~/.claude/plugins/cms-cultivator
git pull origin main
```

Then inside Claude Code CLI:

```bash
/plugin reload cms-cultivator
```

---

### Method 4: Project-Specific Installation

Share plugins with your team by configuring them in your project repository. **Installs per-project - only available in this specific project.**

#### Step 1: Create `.claude/settings.json`

In your project root, create or edit `.claude/settings.json`:

```json
{
  "extraKnownMarketplaces": [
    {
      "name": "claude-toolbox",
      "url": "https://github.com/kanopi/claude-toolbox"
    }
  ],
  "enabledPlugins": {
    "cms-cultivator@claude-toolbox": true
  }
}
```

#### Step 2: Commit to Repository

```bash
git add .claude/settings.json
git commit -m "Add CMS Cultivator plugin configuration"
git push
```

#### Team Member Setup

When team members clone the repository and trust the folder, Claude Code will automatically:

1. Add the Kanopi marketplace
2. Install CMS Cultivator
3. Enable the plugin for the project

#### Project-Specific Configuration

Team members can override project settings in `.claude/settings.local.json` (not committed to git):

```json
{
  "enabledPlugins": {
    "cms-cultivator@claude-toolbox": false
  }
}
```

---

## Verifying Installation

### Test a Command

Open Claude Code in any project and try a command:

```bash
/quality-standards
```

All slash commands should now be available!

### List Available Commands

In Claude Code, type `/` to see all available commands. CMS Cultivator commands are organized by category:

- **PR Workflow**: `/pr-create`, `/pr-review`, `/pr-commit-msg`, `/pr-release`
- **Accessibility**: `/audit-a11y` (with flexible modes)
- **Performance**: `/audit-perf` (with flexible modes)
- **Security**: `/audit-security` (with flexible modes)
- **Live Site Auditing**: `/audit-live-site` (orchestrator)
- **Design Workflow**: `/design-to-block`, `/design-to-paragraph`, `/design-validate`
- **Testing**: `/test-generate`, `/test-coverage`, `/test-plan`
- **Code Quality**: `/quality-analyze`, `/quality-standards`
- **Documentation**: `/docs-generate`

---

## Optional Dependencies

### GitHub CLI (for PR Commands)

To use `/pr-create` and other PR commands:

=== "macOS"

    ```bash
    brew install gh
    gh auth login
    ```

=== "Linux"

    ```bash
    # Debian/Ubuntu
    sudo apt install gh

    # Fedora/RHEL
    sudo dnf install gh

    gh auth login
    ```

=== "Windows"

    ```powershell
    winget install --id GitHub.cli
    gh auth login
    ```

### Lighthouse (for Performance Analysis)

For `/audit-perf lighthouse`:

```bash
npm install -g lighthouse
```

---

## Configuration

### Global Configuration

Global plugin settings are stored in:
- **Settings**: `~/.claude/settings.json`
- **Local overrides**: `~/.claude/settings.local.json`

!!! note "Configuration Directory"
    According to official documentation, Claude Code uses `~/.claude/` for global configuration. Some systems may use `~/.config/claude/`. Check which directory exists on your system.

### Project Configuration

Project-specific settings:
- **Team settings**: `.claude/settings.json` (committed to git)
- **Personal overrides**: `.claude/settings.local.json` (gitignored)

Example `.gitignore` entry:
```
.claude/settings.local.json
```

---

## Uninstalling

### Remove from Marketplace

Inside Claude Code CLI:

```bash
/plugin uninstall cms-cultivator@claude-toolbox
```

### Remove Manual Installation

Inside Claude Code CLI:

```bash
/plugin disable cms-cultivator
```

Then remove the files:

```bash
rm -rf ~/.claude/plugins/cms-cultivator
```

### Remove from Project

Remove or edit `.claude/settings.json` in your project:

```json
{
  "enabledPlugins": {
    "cms-cultivator@claude-toolbox": false
  }
}
```

---

## Troubleshooting

### Commands Not Showing Up

Inside Claude Code CLI:

```bash
# Check plugin status
/plugin

# Verify plugin is enabled
/plugin enable cms-cultivator

# Reload plugin
/plugin reload cms-cultivator
```

### Marketplace Not Found

If the marketplace fails to load:

```bash
# Verify marketplace URL
curl https://raw.githubusercontent.com/kanopi/claude-toolbox/main/.claude-plugin/marketplace.json
```

Inside Claude Code CLI:

```bash
# Remove and re-add marketplace
/plugin marketplace remove claude-toolbox
/plugin marketplace add kanopi/claude-toolbox
```

### Permission Denied

```bash
# Ensure the plugins directory exists
mkdir -p ~/.claude/plugins

# Check ownership
ls -la ~/.claude/plugins/

# Fix permissions if needed
chmod -R 755 ~/.claude/plugins/cms-cultivator
```

### Plugin Not Loading

```bash
# Check for errors in plugin.json
cat ~/.claude/plugins/cms-cultivator/.claude-plugin/plugin.json

# Verify directory structure
ls ~/.claude/plugins/cms-cultivator/commands/

# Check plugin integrity
cd ~/.claude/plugins/cms-cultivator
git status
```

### Project Settings Not Working

1. **Verify trust**: Ensure the project folder is trusted in Claude Code
2. **Check JSON syntax**: Validate `.claude/settings.json` with a JSON linter
3. **Restart Claude Code**: Close and reopen Claude Code after changing settings
4. **Check marketplace availability**: Ensure `extraKnownMarketplaces` is configured correctly

---

## Kanopi Projects Setup

If you're working on Kanopi projects with DDEV add-ons, see the [Kanopi Tools guide](kanopi-tools/overview.md) for additional integration features:

- **Composer Scripts**: `ddev composer code-check`, `phpstan`, `rector-check`
- **DDEV Commands**: `ddev theme-build`, `ddev cypress-run`, `ddev critical-run`
- **Database Tools**: `ddev db-refresh`, `ddev db-backup`

---

## Next Steps

- **[Quick Start Guide](quick-start.md)** - Learn common workflows
- **[Commands Overview](commands/overview.md)** - Explore all 14 commands
- **[Kanopi Tools](kanopi-tools/overview.md)** - Integrate with DDEV add-ons
- **[Contributing](contributing.md)** - Contribute to the project

---

**Installation Support:**
- **Issues**: [GitHub Issues](https://github.com/kanopi/cms-cultivator/issues)
- **Marketplace**: [Claude Toolbox](https://github.com/kanopi/claude-toolbox)
