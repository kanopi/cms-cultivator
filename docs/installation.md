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

#### Step 1: Add the Kanopi Marketplace

```bash
claude plugins marketplace add kanopi-claude-plugins https://github.com/kanopi/kanopi-claude-plugins
```

#### Step 2: Install CMS Cultivator

```bash
claude plugins install kanopi-claude-plugins/cms-cultivator
```

#### Step 3: Verify Installation

```bash
claude plugins list
```

You should see `cms-cultivator` in the list of installed plugins.

#### Updating Via Marketplace

```bash
claude plugins update kanopi-claude-plugins/cms-cultivator
```

---

### Method 2: Direct from GitHub

Install directly without adding a marketplace. **Installs globally for all projects.**

```bash
claude plugins install https://github.com/kanopi/cms-cultivator
```

This method installs the latest version from the main branch.

#### Updating Direct Installation

```bash
claude plugins update cms-cultivator
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

```bash
claude plugins enable cms-cultivator
```

#### Updating Manual Installation

```bash
cd ~/.claude/plugins/cms-cultivator
git pull origin main
claude plugins reload cms-cultivator
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
      "name": "kanopi-claude-plugins",
      "url": "https://github.com/kanopi/kanopi-claude-plugins"
    }
  ],
  "enabledPlugins": {
    "cms-cultivator@kanopi-claude-plugins": true
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
    "cms-cultivator@kanopi-claude-plugins": false
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

All 25 slash commands should now be available!

### List Available Commands

In Claude Code, type `/` to see all available commands. CMS Cultivator commands are organized by category:

- **PR Workflow**: `/pr-*`
- **Accessibility**: `/a11y-*`, `/fix-a11y-*`
- **Performance**: `/perf-*`
- **Security**: `/security-*`
- **Testing**: `/test-*`
- **Quality**: `/quality-*`
- **Documentation**: `/docs-*`

---

## Optional Dependencies

### GitHub CLI (for PR Commands)

To use `/pr-create-pr` and other PR commands:

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

For `/perf-lighthouse-report`:

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

```bash
claude plugins uninstall kanopi-claude-plugins/cms-cultivator
```

### Remove Manual Installation

```bash
claude plugins disable cms-cultivator
rm -rf ~/.claude/plugins/cms-cultivator
```

### Remove from Project

Remove or edit `.claude/settings.json` in your project:

```json
{
  "enabledPlugins": {
    "cms-cultivator@kanopi-claude-plugins": false
  }
}
```

---

## Troubleshooting

### Commands Not Showing Up

```bash
# Check plugin status
claude plugins list

# Verify plugin is enabled
claude plugins enable cms-cultivator

# Reload plugin
claude plugins reload cms-cultivator
```

### Marketplace Not Found

If the marketplace fails to load:

```bash
# Verify marketplace URL
curl https://raw.githubusercontent.com/kanopi/kanopi-claude-plugins/main/marketplace.json

# Remove and re-add marketplace
claude plugins marketplace remove kanopi-claude-plugins
claude plugins marketplace add kanopi-claude-plugins https://github.com/kanopi/kanopi-claude-plugins
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
- **[Commands Overview](commands/overview.md)** - Explore all 25 commands
- **[Kanopi Tools](kanopi-tools/overview.md)** - Integrate with DDEV add-ons
- **[Contributing](contributing.md)** - Contribute to the project

---

**Installation Support:**
- **Issues**: [GitHub Issues](https://github.com/kanopi/cms-cultivator/issues)
- **Marketplace**: [Kanopi Claude Plugins](https://github.com/kanopi/kanopi-claude-plugins)
