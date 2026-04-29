# Installation

CMS Cultivator can be installed in Claude Code, Claude Desktop, or OpenAI Codex — globally for all projects or per-project for team collaboration.

---

## Prerequisites

Before installing CMS Cultivator, ensure you have:

- **Claude Code CLI** or **OpenAI Codex** installed and configured
- **Git** for version control
- **GitHub CLI** (`gh`) for PR creation commands (optional)
- **DDEV** (for Kanopi projects) - [Install DDEV](https://ddev.readthedocs.io/en/stable/)

---

## Claude Code Installation

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

## OpenAI Codex Installation

CMS Cultivator includes a `.codex-plugin/plugin.json` manifest and Codex-compatible TOML agent files. Install it via the Codex plugin system.

### Codex Method 1: Via Marketplace (Recommended)

Add the Kanopi marketplace and install from the Codex plugin browser.

#### Step 1: Add the Kanopi Marketplace

```bash
codex plugin marketplace add kanopi/claude-toolbox
```

#### Step 2: Open the Plugin Browser

```bash
codex/plugins
```

Browse to CMS Cultivator, open its details, and select **Install plugin**.

#### Step 3: Start a New Thread

After installation, start a new Codex thread. Skills activate automatically from context, or invoke explicitly with `@skill-name` (e.g. `@pr-create`).

#### Updating Via Marketplace

```bash
codex plugin marketplace upgrade
```

---

### Codex Method 2: Personal Installation (Manual)

Install directly to your personal Codex plugins directory. **Installs globally for all your projects.**

#### Step 1: Clone the Repository

```bash
git clone https://github.com/kanopi/cms-cultivator ~/.codex/plugins/cms-cultivator
```

#### Step 2: Create a Personal Marketplace File

Create or update `~/.agents/plugins/marketplace.json`:

```json
{
  "name": "kanopi-plugins",
  "interface": {
    "displayName": "Kanopi Plugins"
  },
  "plugins": [
    {
      "name": "cms-cultivator",
      "source": {
        "source": "local",
        "path": "./cms-cultivator"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Development"
    }
  ]
}
```

#### Step 3: Restart Codex and Install

Restart Codex, then open `codex/plugins`, find CMS Cultivator under the Kanopi Plugins marketplace, and install it.

#### Updating Manual Installation

```bash
cd ~/.codex/plugins/cms-cultivator
git pull origin main
```

Then restart Codex to pick up the changes.

---

### Codex Method 3: Repo-Scoped Installation

Share the plugin with your team by configuring it in your project repository. **Installs per-project - only available in this specific project.**

#### Step 1: Add the Plugin to Your Repo

```bash
git clone https://github.com/kanopi/cms-cultivator plugins/cms-cultivator
```

Or add it as a git submodule:

```bash
git submodule add https://github.com/kanopi/cms-cultivator plugins/cms-cultivator
```

#### Step 2: Create a Repo Marketplace File

Create `$REPO_ROOT/.agents/plugins/marketplace.json`:

```json
{
  "name": "project-plugins",
  "plugins": [
    {
      "name": "cms-cultivator",
      "source": {
        "source": "local",
        "path": "./plugins/cms-cultivator"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Development"
    }
  ]
}
```

#### Step 3: Commit to Repository

```bash
git add .agents/plugins/marketplace.json plugins/cms-cultivator
git commit -m "Add CMS Cultivator plugin for Codex"
git push
```

#### Team Member Setup

When team members open the project in Codex, they run `codex/plugins`, find CMS Cultivator under the project marketplace, and install it.

---

### Disabling the Codex Plugin

To keep the plugin installed but turn it off, edit `~/.codex/config.toml`:

```toml
[plugins."cms-cultivator@kanopi-plugins"]
enabled = false
```

Then restart Codex.

---

## Verifying Installation

### Test a Skill

**Claude Code** — open in any project and try a skill by name or natural language:

```bash
/quality-standards
```

**Codex** — start a new thread and invoke explicitly or by natural language:

```
@quality-standards
```

Or just say: "Does this follow Drupal coding standards?" — skills activate automatically in conversation on both platforms.

### List Available Skills

In Claude Code, type `/` to see all available skills. In Codex, type `@` to see installed plugin skills. CMS Cultivator skills are organized by category:

- **PR Workflow**: `/pr-create`, `/pr-review`, `/pr-commit-msg`, `/pr-release`
- **Accessibility**: `/audit-a11y` (with flexible modes)
- **Performance**: `/audit-perf` (with flexible modes)
- **Security**: `/audit-security` (with flexible modes)
- **Live Site Auditing**: `/audit-live-site` (parallel multi-specialist audit)
- **Design Workflow**: `/design-to-wp-block`, `/design-to-drupal-paragraph`
- **Testing**: auto-invoked (say "I need tests for this class")
- **Code Quality**: `/quality-analyze`, `/quality-standards`
- **Documentation**: auto-invoked (say "document this function")

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
ls ~/.claude/plugins/cms-cultivator/skills/

# Check plugin integrity
cd ~/.claude/plugins/cms-cultivator
git status
```

### Project Settings Not Working (Claude Code)

1. **Verify trust**: Ensure the project folder is trusted in Claude Code
2. **Check JSON syntax**: Validate `.claude/settings.json` with a JSON linter
3. **Restart Claude Code**: Close and reopen Claude Code after changing settings
4. **Check marketplace availability**: Ensure `extraKnownMarketplaces` is configured correctly

### Codex Plugin Not Appearing

1. **Verify marketplace file**: Check that `marketplace.json` is valid JSON and `source.path` is correct
2. **Restart Codex**: Codex reads marketplace files on startup
3. **Check config**: Verify `~/.codex/config.toml` doesn't have the plugin set to `enabled = false`

---

## Kanopi Projects Setup

If you're working on Kanopi projects with DDEV add-ons, see the [Kanopi Tools guide](kanopi-tools/overview.md) for additional integration features:

- **Composer Scripts**: `ddev composer code-check`, `phpstan`, `rector-check`
- **DDEV Commands**: `ddev theme-build`, `ddev cypress-run`, `ddev critical-run`
- **Database Tools**: `ddev db-refresh`, `ddev db-backup`

---

## Next Steps

- **[Quick Start Guide](quick-start.md)** - Learn common workflows
- **[Skills Overview](commands/overview.md)** - Explore all 38 skills
- **[Kanopi Tools](kanopi-tools/overview.md)** - Integrate with DDEV add-ons
- **[Contributing](contributing.md)** - Contribute to the project

---

**Installation Support:**
- **Issues**: [GitHub Issues](https://github.com/kanopi/cms-cultivator/issues)
- **Marketplace**: [Claude Toolbox](https://github.com/kanopi/claude-toolbox)
