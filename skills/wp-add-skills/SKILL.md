---
name: wp-add-skills
description: Install official WordPress agent-skills from the WordPress/agent-skills GitHub repository. Invoke when user asks to install WordPress skills, says "add WordPress skills", "install WordPress agent skills", or uses /wp-add-skills. Has side effects: clones a repository, installs 13 skills to the global skills directory. Requires user confirmation before installation. Supports --list and --update flags.
---

# WP Add Skills

Install official WordPress agent-skills from the [WordPress/agent-skills](https://github.com/WordPress/agent-skills) repository.

## ⚠️ Side Effect Warning

**This skill installs software to your system:**
- Clones the WordPress/agent-skills repository (~28 seconds download)
- Runs npm build scripts (~14 seconds)
- Installs 13 skills to your global skills directory
- Temporary files are cleaned up after installation

**Installation paths differ by environment** (see Tier 1 vs Tier 2 below).

**Confirmation required** before installation begins.

## Usage

- "Install WordPress agent skills"
- `/wp-add-skills` — Install 13 WordPress skills
- `/wp-add-skills --list` — List installed WordPress skills
- `/wp-add-skills --update` — Update to latest version

## Prerequisites

- **Git** 2.0+ (`git --version`)
- **Node.js** v16+ (`node --version`) — v18 or v20 recommended
- **Disk space** — At least 100MB available in home directory
- **Write permissions** to the skills directory

## Environment Detection

### Tier 1 — Portable (Codex and other environments)

**Skills install path**: `~/.agents/skills/` (Codex standard path)

1. **Parse flags** — Determine if --list, --update, or install
2. **For --list**: Show installed skills in `~/.agents/skills/` that match WordPress pattern
3. **For install/update**:
   - Present confirmation:
     ```
     This will install 13 WordPress skills to ~/.agents/skills/
     Prerequisites needed: git 2.0+, Node.js v16+, ~100MB disk space
     
     Reply "confirm" to proceed, "cancel" to abort.
     ```
   - **⛔ STOP: Wait for confirmation**
   - After confirmation, provide manual installation steps if Bash unavailable:
     ```bash
     # Clone repository
     git clone --depth 1 https://github.com/WordPress/agent-skills /tmp/wp-skills-install
     
     # Build skills
     cd /tmp/wp-skills-install
     node skillpack-build.mjs --clean
     
     # Install to Codex path
     node skillpack-install.mjs --global --path ~/.agents/skills/
     
     # Cleanup
     rm -rf /tmp/wp-skills-install
     ```

### Tier 2 — Claude Code Enhanced

**Skills install path**: `~/.claude/skills/` (Claude Code path)

1. **Parse flags**
2. **For --list**:
   ```bash
   ls -la ~/.claude/skills/ | grep wp- || echo "No WordPress skills installed"
   ```
3. **For install/update**:
   - Check prerequisites:
     ```bash
     git --version && node --version && df -h ~ | tail -1
     ```
   - Present confirmation with prereq status:
     ```
     Installing 13 WordPress skills to ~/.claude/skills/
     
     Prerequisites:
     ✅ Git: {version}
     ✅ Node.js: {version}
     ✅ Disk space: {available}
     
     Reply "confirm" to proceed, "cancel" to abort.
     ```
   - **⛔ STOP: Wait for confirmation**
   - After confirmation, execute installation:
     ```bash
     # Step 1: Clone
     git clone --depth 1 https://github.com/WordPress/agent-skills /tmp/wp-skills-$(date +%s)
     
     # Step 2: Build
     cd /tmp/wp-skills-*
     node skillpack-build.mjs --clean
     
     # Step 3: Install to Claude Code path
     node skillpack-install.mjs --global
     
     # Step 4: Verify
     ls ~/.claude/skills/ | grep -c "" | xargs echo "Skills installed:"
     
     # Step 5: Cleanup
     rm -rf /tmp/wp-skills-*
     ```

## The 13 WordPress Skills

1. **wordpress-router** — WordPress project detection and routing
2. **wp-project-triage** — Auto-detect WordPress tooling, versions, configuration
3. **wp-block-development** — Gutenberg block development (block.json, InnerBlocks, transforms)
4. **wp-block-themes** — Block themes and theme.json
5. **wp-plugin-development** — Plugin architecture, hooks, actions, filters, security
6. **wp-rest-api** — REST API endpoints, authentication, custom routes
7. **wp-interactivity-api** — Frontend directives (@wordpress/interactivity)
8. **wp-abilities-api** — User capabilities and permissions system
9. **wp-wpcli-and-ops** — WP-CLI commands, automation, operations
10. **wp-performance** — Performance optimization, caching, database queries
11. **wp-phpstan** — Static analysis configuration for WordPress
12. **wp-playground** — WordPress Playground integration and testing
13. **wpds** — WordPress Design System components and patterns

## Installation Timing (~70 seconds total)

| Step | Duration |
|------|----------|
| Prerequisites check | ~2s |
| Clone repository | ~28s |
| Build skills | ~14s |
| Install globally | ~2s |
| Verify installation | ~1s |
| Cleanup | ~1s |

## Success Report

```
✅ Installation Complete!

Installed: 13 WordPress skills
Location: {skills-directory}
Total time: ~70 seconds

Next steps:
- Test: "How do I create a custom Gutenberg block?"
- List skills: wp-add-skills --list
```

## Troubleshooting

- **Node.js too old**: Update to v18 or v20 LTS
- **Permission denied**: `chmod 755 {skills-directory}`
- **Clone failed**: Check internet connection, try again
- **Skills don't appear**: Restart your AI session after installation

## Related Skills

- **wp-block-development** — One of the installed WordPress skills
- **wp-plugin-development** — One of the installed WordPress skills
