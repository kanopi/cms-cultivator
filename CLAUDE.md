# Claude Context for CMS Cultivator Development

This file provides context for Claude (or other AI assistants) when working on this project.

## Project Overview

**CMS Cultivator** is a Claude Code plugin providing 25 specialized commands for Drupal and WordPress development. It integrates with Kanopi's DDEV add-ons and standardized Composer scripts.

## Key Architectural Decisions

### Command Structure

Each command is a Markdown file in `/commands/` with YAML frontmatter:

```yaml
---
description: Brief one-line description
argument-hint: [optional-arg]
allowed-tools: Bash(git:*), Read, Glob, Grep, Write
---
```

**Important conventions:**
- Commands support both direct tool execution AND DDEV-wrapped execution
- Example: Allow both `composer` and `ddev composer` in `allowed-tools`
- Platform-agnostic: Commands work for both Drupal and WordPress projects

### Kanopi Integration

Commands automatically reference Kanopi-specific tools when available:

- **Composer Scripts**: `ddev composer code-check`, `phpstan`, `rector-check`, etc.
- **DDEV Commands**: `ddev theme-build`, `ddev cypress-run`, `ddev critical-run`, etc.

**Pattern**: Add a "Quick Start (Kanopi Projects)" section showing Kanopi-specific commands, then provide generic instructions for non-Kanopi projects.

### Documentation Site

- Built with MkDocs Material theme
- Organized into 7 main sections
- Follows same pattern as Kanopi's DDEV add-on documentation
- Deployed to GitHub Pages via Actions workflow

## Development Workflow

### Adding a New Command

1. **Create command file**: `/commands/new-command.md`
2. **Add frontmatter** with description and allowed-tools
3. **Write documentation** with examples for both Drupal and WordPress
4. **Add Kanopi integration** if applicable
5. **Update command overview**: `docs/commands/overview.md`
6. **Update README** command count if changing categories

### Updating Commands

When updating command files:
- Preserve the existing structure and examples
- Add "Quick Start (Kanopi Projects)" sections for Kanopi tool integration
- Don't remove generic instructions (non-Kanopi projects need them)
- Update `allowed-tools` to include both direct and DDEV-wrapped variants

Example:
```yaml
allowed-tools: Bash(composer:*), Bash(ddev composer:*), Bash(npm:*), Bash(ddev exec npm:*)
```

### Documentation Updates

1. **Edit files** in `/docs/`
2. **Test locally**: `mkdocs serve`
3. **Build**: `mkdocs build --strict` (catches broken links)
4. **Commit**: Automatically deploys to GitHub Pages on push to main

## File Organization

```
cms-cultivator/
├── .claude-plugin/
│   └── plugin.json          # Claude Code plugin metadata
├── .github/workflows/
│   └── docs.yml             # MkDocs deployment
├── commands/                # 19 command files (*.md)
├── docs/                    # MkDocs documentation
│   ├── commands/           # Command reference pages
│   ├── kanopi-tools/       # Kanopi integration docs
│   └── reference/          # Technical reference
├── mkdocs.yml              # MkDocs configuration
└── README.md               # Simplified, points to docs site
```

## Important Files to NOT Modify

- **Plugin metadata**: `.claude-plugin/plugin.json`
- **Command frontmatter**: Changing `allowed-tools` affects what Claude can execute
- **GitHub Actions**: `.github/workflows/docs.yml` (stable deployment)

## Code Conventions

### Command Files

- Use `## Heading 2` for major sections
- Use `###  Heading 3` for subsections
- Include code examples with proper syntax highlighting (```bash, ```php, ```javascript)
- Provide both Drupal AND WordPress examples where applicable
- Document all focus parameters and their options

### Documentation

- Write in active voice
- Use admonitions for warnings/tips/notes
- Include "Quick Start" sections at the top for common use cases
- Link between related docs
- Use emoji sparingly (only in headings for visual navigation)

### Frontmatter Standards

**Description**: Brief imperative statement (e.g., "Generate PR description from git changes")

**Argument-hint**: Show optional args in square brackets: `[focus-area]`, `[ticket-number]`

**Allowed-tools**: List all tools, including both variants:
- Git operations: `Bash(git:*)`
- GitHub CLI: `Bash(gh:*)`
- Composer: `Bash(composer:*), Bash(ddev composer:*)`
- File operations: `Read, Glob, Grep, Write, Edit`
- DDEV commands: `Bash(ddev:*), Bash(ddev theme-build:*)` (specific or wildcard)

## Testing Approach

### Manual Testing

1. **Install locally**: `ln -s $(pwd) ~/.config/claude/plugins/cms-cultivator`
2. **Enable**: `claude plugins enable cms-cultivator`
3. **Test command**: Open Claude Code and run `/command-name`
4. **Verify**:
   - Command executes without errors
   - Output is formatted correctly
   - Examples work for both Drupal and WordPress
   - Kanopi integration works (if applicable)

### Documentation Testing

```bash
mkdocs build --strict  # Catches broken links, missing pages
mkdocs serve          # Preview at http://localhost:8000
```

### Cross-Platform Testing

Test commands with:
- Drupal project (with and without Kanopi add-on)
- WordPress project (with and without Kanopi add-on)
- Non-DDEV setup (direct tool execution)

## Common Patterns

### Platform Detection Pattern

Commands should work on both platforms. Use conditional examples:

```markdown
**Drupal:**
```bash
drush cr
```

**WordPress:**
```bash
wp cache flush
```
```

### Kanopi Integration Pattern

```markdown
## Quick Start (Kanopi Projects)

```bash
# For Kanopi projects, use standardized commands
ddev composer code-check
```

---

## Manual Analysis (Non-Kanopi Projects)

For projects without Kanopi tooling, analyze files directly:
...
```

### Focus Parameter Pattern

```markdown
## Usage

- `/command` - Run all analyses
- `/command focus1` - Focus on specific area
- `/command focus2` - Focus on different area

**Focus options**: `focus1`, `focus2`, `focus3`
```

## Dependencies

### Runtime Dependencies (User's Machine)

- Claude Code CLI
- Git
- GitHub CLI (`gh`) - for PR commands
- Optional: DDEV - for Kanopi projects
- Optional: Lighthouse - for performance commands

### Documentation Build Dependencies

- Python 3.x
- mkdocs-material
- mkdocs-git-revision-date-localized-plugin

Install: `pip install mkdocs-material mkdocs-git-revision-date-localized-plugin`

## Resources

### External Documentation

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [MkDocs Material](https://squidfunk.github.io/mkdocs-material/)
- [Kanopi DDEV Drupal Add-on](https://github.com/kanopi/ddev-kanopi-drupal)
- [Kanopi DDEV WordPress Add-on](https://github.com/kanopi/ddev-kanopi-wp)

### Internal References

- [Kanopi Tools Overview](docs/kanopi-tools/overview.md)
- [Tool Execution Context](docs/reference/tools-analysis.md)
- [Contributing Guide](docs/contributing.md)

## Troubleshooting for AI Assistants

### When adding Kanopi integration to commands

1. Check if the tool exists in Kanopi add-ons (see `docs/kanopi-tools/overview.md`)
2. Add to `allowed-tools` frontmatter with `ddev composer:*` or `ddev:*` patterns
3. Add "Quick Start (Kanopi Projects)" section
4. Don't remove generic instructions

### When command suggestions fail

- Verify `allowed-tools` includes necessary patterns
- Check if tool needs DDEV (`ddev exec`) or runs locally
- See `docs/reference/tools-analysis.md` for tool execution contexts

### When documentation builds fail

- Run `mkdocs build --strict` to see errors
- Check for broken links in navigation (`mkdocs.yml`)
- Verify all referenced files exist in `docs/`
- Check frontmatter YAML syntax in command files

## Future Enhancements

Ideas for future development:

1. **Additional Commands**: Database migration analysis, deployment verification, etc.
2. **Enhanced Kanopi Integration**: Auto-detect Kanopi projects and adjust output
3. **Configuration File**: `.cms-cultivator.yml` for project-specific settings
4. **MCP Integration**: Connect to Model Context Protocol servers for enhanced capabilities
5. **Command Aliases**: Shorter versions of common commands
6. **Interactive Modes**: Multi-step workflows with user input

---

Last updated: 2025-10-13
