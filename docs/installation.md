# Installation

## Prerequisites

Before installing CMS Cultivator, ensure you have:

- **Claude Code CLI** installed and configured
- **Git** for version control
- **GitHub CLI** (`gh`) for PR creation commands (optional)
- **DDEV** (for Kanopi projects) - [Install DDEV](https://ddev.readthedocs.io/en/stable/)

---

## Install as Claude Code Plugin

### Step 1: Clone the Plugin

Clone the plugin to your Claude Code plugins directory:

```bash
cd ~/.config/claude/plugins
git clone https://github.com/kanopi/cms-cultivator.git cms-cultivator
```

### Step 2: Enable the Plugin

Enable the plugin in Claude Code:

```bash
claude plugins enable cms-cultivator
```

### Step 3: Verify Installation

Check that the plugin is enabled and loaded:

```bash
claude plugins list
```

You should see `cms-cultivator` in the list of enabled plugins.

### Step 4: Test a Command

Open Claude Code and try a command:

```bash
# In Claude Code CLI
/quality-standards
```

All 25 slash commands are now available in any Claude Code session!

---

## Updating

To update to the latest version:

```bash
cd ~/.config/claude/plugins/cms-cultivator
git pull
claude plugins reload cms-cultivator
```

---

## Uninstalling

To remove the plugin:

```bash
claude plugins disable cms-cultivator
rm -rf ~/.config/claude/plugins/cms-cultivator
```

---

## Optional: GitHub CLI Setup

For PR creation commands (`/pr-create-pr`), install GitHub CLI:

### macOS
```bash
brew install gh
gh auth login
```

### Linux
```bash
# Debian/Ubuntu
sudo apt install gh

# Fedora/RHEL
sudo dnf install gh

gh auth login
```

### Windows
```powershell
winget install --id GitHub.cli
gh auth login
```

---

## Optional: Lighthouse Setup

For advanced performance analysis (`/perf-lighthouse-report`):

```bash
npm install -g lighthouse
```

---

## Kanopi Projects Setup

If you're working on Kanopi projects with DDEV add-ons, see the [Kanopi Tools guide](kanopi-tools/overview.md) for integration instructions.

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

### Permission Denied

If you get permission errors:

```bash
# Ensure the plugins directory exists
mkdir -p ~/.config/claude/plugins

# Check ownership
ls -la ~/.config/claude/plugins/

# Fix permissions if needed
chmod -R 755 ~/.config/claude/plugins/cms-cultivator
```

### Plugin Not Loading

```bash
# Check for errors in plugin.json
cat ~/.config/claude/plugins/cms-cultivator/.claude-plugin/plugin.json

# Verify directory structure
ls ~/.config/claude/plugins/cms-cultivator/commands/
```

---

## Next Steps

- **[Quick Start Guide](quick-start.md)** - Learn common workflows
- **[Commands Overview](commands/overview.md)** - Explore all 25 commands
- **[Kanopi Tools](kanopi-tools/overview.md)** - Integrate with DDEV add-ons
