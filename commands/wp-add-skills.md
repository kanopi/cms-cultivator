---
description: Install official WordPress agent-skills from WordPress/agent-skills repository
argument-hint: "[--update] [--list]"
allowed-tools: Bash(git:*), Bash(node:*), Bash(npm:*), Bash(mkdir:*), Bash(rm:*), Bash(ls:*), Bash(date:*), Bash(df:*), Bash(command:*), Read
---

# /wp-add-skills

Install the official WordPress agent-skills repository globally, making 13 WordPress-specific skills available to Claude Code.

## How It Works

This command installs WordPress development skills from the official [WordPress/agent-skills](https://github.com/WordPress/agent-skills) repository to your global Claude skills directory (`~/.claude/skills/`).

**Installation process (6 steps, ~70 seconds):**

1. **Prerequisites check** - Verifies git, Node.js v16+, write permissions, disk space
2. **Clone repository** - Shallow clone from GitHub (~28 seconds)
3. **Build skills** - Runs skillpack-build script (~14 seconds)
4. **Install globally** - Copies skills to ~/.claude/skills/ (~2 seconds)
5. **Verify installation** - Checks all 13 skills are present
6. **Cleanup** - Removes temporary files

**What gets installed:** 13 WordPress-specific skills for block development, REST API, WP-CLI, performance, and more.

**Learn more:** [WordPress Skills Guide](../docs/wordpress-skills.md)

## Quick Start

**Install WordPress skills:**
```bash
/wp-add-skills
```

**List installed skills:**
```bash
/wp-add-skills --list
```

**Update to latest version:**
```bash
/wp-add-skills --update
```

## Usage

### First-time installation

```bash
/wp-add-skills
```

**What happens:**
- Checks prerequisites (git, Node.js, permissions, disk space)
- Clones WordPress/agent-skills repository
- Builds and installs 13 skills
- Cleans up temporary files
- Reports success with timing

**Time:** ~70 seconds

### List installed skills

```bash
/wp-add-skills --list
```

Shows all installed WordPress skills in `~/.claude/skills/` with verification status.

### Update existing skills

```bash
/wp-add-skills --update
```

Re-installs skills from latest repository version, overwriting existing skills.

## Prerequisites

Before running this command, ensure you have:

### 1. Git

**Check:**
```bash
git --version
```

**Required:** Git 2.0+

**Install:** [https://git-scm.com/downloads](https://git-scm.com/downloads)

### 2. Node.js

**Check:**
```bash
node --version
```

**Required:** Node.js v16+

**Recommended:** Node.js v18 or v20

**Install:** [https://nodejs.org/](https://nodejs.org/)

### 3. Disk Space

**Required:** At least 100MB available in home directory

**Check:**
```bash
df -h ~
```

### 4. Write Permissions

The command needs write access to `~/.claude/skills/`

This directory will be created automatically if it doesn't exist.

## Installation Process

When you run `/wp-add-skills`, Claude will:

### Step 1: Check Prerequisites (~2 seconds)

```
📋 Checking prerequisites...
✅ Git found: v2.39.0
✅ Node.js found: v20.10.0
✅ Skills directory: ~/.claude/skills/
✅ Write permissions: OK
✅ Disk space: 2.4GB available
```

### Step 2: Clone Repository (~28 seconds)

```
📦 Cloning WordPress agent-skills repository...
   Cloning into '/tmp/wordpress-agent-skills-1234567890'...
   → Time: 28s
```

Uses shallow clone (`--depth 1`) for faster download.

### Step 3: Build Skills (~14 seconds)

```
🔨 Building skill packages...
   Running skillpack-build.mjs --clean
   → 13 skills built
   → Time: 14s
```

### Step 4: Install Globally (~2 seconds)

```
📥 Installing to ~/.claude/skills/...
   Running skillpack-install.mjs --global
   → 13 skills installed
```

### Step 5: Verify Installation (~1 second)

```
✅ Verifying installation...
   → All skills present
   → All SKILL.md files valid
```

### Step 6: Cleanup (~1 second)

```
🧹 Cleaning up temporary files...
   Removed: /tmp/wordpress-agent-skills-1234567890
```

### Success Report

```
✅ Installation Complete!

Installed: 13 WordPress skills
Location: ~/.claude/skills/
Total time: 78 seconds

Next steps:
- Test: "How do I create a custom Gutenberg block?"
- List skills: /wp-add-skills --list
- Learn more: https://github.com/WordPress/agent-skills
```

## Arguments

### --list

Show all installed WordPress skills.

**Usage:**
```bash
/wp-add-skills --list
```

**Output:**
```
📋 Installed WordPress Skills

Found 13 WordPress skills in ~/.claude/skills/:

✅ wordpress-router - WordPress project detection
✅ wp-abilities-api - Capabilities system
✅ wp-block-development - Gutenberg blocks
✅ wp-block-themes - Block themes and theme.json
✅ wp-interactivity-api - Frontend directives
✅ wp-performance - Performance optimization
✅ wp-phpstan - Static analysis
✅ wp-playground - WordPress Playground integration
✅ wp-plugin-development - Plugin architecture
✅ wp-rest-api - REST API endpoints
✅ wp-wpcli-and-ops - WP-CLI automation
✅ wpds - WordPress Design System
✅ wp-project-triage - Auto-detect tooling

Commands:
  Update: /wp-add-skills --update
  Repo: https://github.com/WordPress/agent-skills
```

### --update

Update existing skills to latest version.

**Usage:**
```bash
/wp-add-skills --update
```

**What happens:**
- Checks if WordPress skills are already installed
- If yes: Proceeds with installation (overwrites existing skills)
- If no: Suggests running without `--update` flag

**Note:** This completely replaces existing skills with the latest version from the repository.

## What Gets Installed

**13 WordPress Skills** installed to `~/.claude/skills/`:

1. **wordpress-router** - WordPress project detection and routing
2. **wp-project-triage** - Auto-detect WordPress tooling, versions, and configuration
3. **wp-block-development** - Gutenberg block development (block.json, InnerBlocks, transforms)
4. **wp-block-themes** - Block themes and theme.json
5. **wp-plugin-development** - Plugin architecture, hooks, actions, filters, security
6. **wp-rest-api** - REST API endpoints, authentication, custom routes
7. **wp-interactivity-api** - Frontend directives (@wordpress/interactivity)
8. **wp-abilities-api** - User capabilities and permissions system
9. **wp-wpcli-and-ops** - WP-CLI commands, automation, operations
10. **wp-performance** - Performance optimization, caching, database queries
11. **wp-phpstan** - Static analysis configuration for WordPress
12. **wp-playground** - WordPress Playground integration and testing
13. **wpds** - WordPress Design System components and patterns

**Repository:** [https://github.com/WordPress/agent-skills](https://github.com/WordPress/agent-skills)

**License:** GPL-2.0-or-later (compatible with CMS Cultivator)

**Size:** < 5MB after installation and cleanup

## Troubleshooting

### Error: Git not found

**Problem:** Git is not installed or not in PATH.

**Solution:** Install Git from [https://git-scm.com/downloads](https://git-scm.com/downloads)

**Verify:**
```bash
git --version
```

### Error: Node.js not found

**Problem:** Node.js is not installed or not in PATH.

**Solution:** Install Node.js v18+ from [https://nodejs.org/](https://nodejs.org/)

**Verify:**
```bash
node --version
```

### Warning: Node.js version too old

**Problem:** Node.js version is below v16.

**Solution:** Update Node.js to v18 or v20 (LTS versions).

**Check version:**
```bash
node --version
```

### Error: Permission denied

**Problem:** Cannot write to `~/.claude/skills/` directory.

**Solution:** Check directory permissions:
```bash
ls -la ~/.claude/
mkdir -p ~/.claude/skills
chmod 755 ~/.claude/skills
```

### Error: Insufficient disk space

**Problem:** Less than 100MB available in home directory.

**Solution:** Free up disk space and try again.

**Check space:**
```bash
df -h ~
```

### Error: Clone failed

**Problem:** Cannot clone repository from GitHub.

**Solutions:**
- Check internet connection
- Verify GitHub is accessible
- Try again (temporary network issue)
- Check firewall/proxy settings

### Error: Build failed

**Problem:** skillpack-build.mjs script failed.

**Solutions:**
- Check Node.js version is v16+
- Verify npm is installed: `npm --version`
- Check build error messages for details
- Try updating Node.js

### Error: Install failed

**Problem:** skillpack-install.mjs script failed.

**Solutions:**
- Check permissions on ~/.claude/skills/
- Verify disk space available
- Check install error messages

### Skills don't appear

**Problem:** Installation succeeded but skills not activating.

**Solutions:**
1. Verify skills installed:
   ```bash
   /wp-add-skills --list
   ```

2. Check skills directory:
   ```bash
   ls -la ~/.claude/skills/ | grep wp-
   ```

3. Restart Claude Code session

4. Verify you're in a WordPress project (wordpress-router detects context)

## Related Commands

### CMS Cultivator Commands

- [Commands Overview](../docs/commands/overview.md) - All available commands
- [Quick Start Guide](../docs/quick-start.md) - Getting started with CMS Cultivator

### WordPress Resources

- [WordPress/agent-skills Repository](https://github.com/WordPress/agent-skills) - Official skills repository
- [WordPress Developer Resources](https://developer.wordpress.org/) - WordPress documentation
- [Claude Code Documentation](https://docs.claude.com/) - Claude Code guides
