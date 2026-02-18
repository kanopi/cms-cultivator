# Claude Context for CMS Cultivator Development

This file provides context for Claude (or other AI assistants) when working on this project.

## Project Overview

**CMS Cultivator** is a Claude Code plugin providing specialized slash commands and Agent Skills for Drupal and WordPress development. It integrates with Kanopi's DDEV add-ons and standardized Composer scripts.

### Architecture: "Agents Orchestrate, Skills Guide, Commands Interface"

- **Specialist Agents** (`/agents/`) - Autonomous agents that orchestrate complex workflows by spawning other agents in parallel. Use fully qualified names when referencing: `cms-cultivator:agent-name:agent-name`
- **Agent Skills** (`/skills/`) - Detailed "how-to" documentation with complete workflows, examples, and instructions. Single source of truth.
- **Slash Commands** (`/commands/`) - User-facing interfaces that spawn agents or reference skills. Quick start guides.

## Key Architectural Decisions

### Hybrid Architecture: Agents + Commands + Skills

**Three complementary systems:**

1. **Specialist Agents** (`/agents/`)
   - Autonomous agents spawned by commands or other agents
   - Orchestrate complex workflows with parallel execution
   - Each agent has a specific domain expertise
   - **IMPORTANT:** When agents reference other agents via the Task tool, use fully qualified names: `cms-cultivator:agent-name:agent-name`
   - Examples: accessibility-specialist, security-specialist, performance-specialist, etc.

2. **Agent Skills** (`/skills/`)
   - Model-invoked (Claude decides when to use)
   - Complete technical documentation
   - Detailed workflows, examples, best practices
   - **Single source of truth** for implementation details

3. **Slash Commands** (`/commands/`)
   - User-invoked (explicit `/command` triggering)
   - Quick start guides
   - Reference agents and/or skills for detailed instructions
   - When to use command vs. skill

### Command Structure

Each command is a Markdown file in `/commands/` with YAML frontmatter:

```yaml
---
description: Brief one-line description
argument-hint: [optional-arg]
allowed-tools: Bash(git:*), Read, Glob, Grep, Write
---
```

**Commands reference skills:**
```markdown
## How It Works

This command uses the **skill-name** Agent Skill.

**For complete workflow and technical details**, see:
→ [`skills/skill-name/SKILL.md`](../skills/skill-name/SKILL.md)
```

**Important conventions:**
- Commands support both direct tool execution AND DDEV-wrapped execution
- Example: Allow both `composer` and `ddev composer` in `allowed-tools`
- Platform-agnostic: Commands work for both Drupal and WordPress projects
- Commands are concise (90-200 lines), skills are comprehensive (150-300 lines)

### Flexible Argument Mode System (v0.6.0+)

Four audit/quality commands support flexible argument modes for different use cases:

**Commands with flexible modes:**
- `/audit-a11y [options]`
- `/audit-perf [options]`
- `/audit-security [options]`
- `/quality-analyze [options]`

**Argument categories:**

1. **Depth Modes** - Control thoroughness:
   - `--quick` - Fast checks, critical issues only (~5 min)
   - `--standard` - Comprehensive analysis (default, ~15 min)
   - `--comprehensive` - Deep dive with best practices (~30 min)

2. **Scope Control** - Limit what's analyzed:
   - `--scope=current-pr` - Only files in current PR (requires `Bash(git:*)`)
   - `--scope=module=<name>` - Specific module/directory
   - `--scope=file=<path>` - Single file
   - `--scope=entire` - Full codebase (default)
   - Command-specific scopes (e.g., `--scope=frontend`, `--scope=auth`)

3. **Output Formats** - Control presentation:
   - `--format=report` - Detailed markdown (default)
   - `--format=json` - Machine-readable for CI/CD
   - `--format=summary` - Executive summary
   - `--format=checklist` - Simple pass/fail list
   - Command-specific formats (e.g., `--format=sarif` for security)

4. **Thresholds** - Quality gates:
   - Performance: `--target=good|needs-improvement`
   - Security: `--min-severity=high|medium|low`
   - Quality: `--max-complexity=N`, `--min-grade=A|B|C`

5. **Legacy Focus Areas** - Backward compatible:
   - Single-word arguments without `--` prefix still work
   - Examples: `/audit-a11y contrast`, `/audit-perf queries`, `/audit-security xss`
   - Can be combined with new modes: `/audit-a11y contrast --quick --scope=current-pr`

**Agent Mode Handling:**

When agents receive mode parameters, they must:
- Parse depth mode and adjust analysis thoroughness
- Apply scope filters to file selection
- Format output according to specified format
- Apply threshold filters to results
- Include mode handling in "How It Works" section

See `docs/guides/using-argument-modes.md` for complete usage guide.

### Agent Structure

Each agent is a Markdown file in `/agents/{agent-name}/AGENT.md` with YAML frontmatter:

```yaml
---
name: agent-name
description: Clear description of when this agent should be invoked
tools: Read, Glob, Grep, Bash
skills: related-skill-name
model: sonnet
---
```

**Agent Naming Convention:**

When agents spawn other agents using the Task tool, they must use **fully qualified names**:

```
Task(cms-cultivator:agent-name:agent-name, prompt="Task description")
```

**Format:** `plugin-name:agent-directory:agent-name`

**Examples:**
- `cms-cultivator:accessibility-specialist:accessibility-specialist`
- `cms-cultivator:security-specialist:security-specialist`
- `cms-cultivator:performance-specialist:performance-specialist`
- `cms-cultivator:live-audit-specialist:live-audit-specialist`

**Why fully qualified names?**
- Avoids naming conflicts with other plugins
- Explicit about which plugin's agent is being invoked
- Required by Claude Code's agent registry system

**Parallel Agent Execution:**

When spawning multiple agents, always do so in a single message with multiple Task calls:

```markdown
I'm spawning all four specialists in parallel:
```

Then make 4 Task calls:
```
Task(cms-cultivator:performance-specialist:performance-specialist, prompt="...")
Task(cms-cultivator:accessibility-specialist:accessibility-specialist, prompt="...")
Task(cms-cultivator:security-specialist:security-specialist, prompt="...")
Task(cms-cultivator:code-quality-specialist:code-quality-specialist, prompt="...")
```

### Kanopi Integration

Commands automatically reference Kanopi-specific tools when available:

- **Composer Scripts**: `ddev composer code-check`, `phpstan`, `rector-check`, etc.
- **DDEV Commands**: `ddev theme-build`, `ddev cypress-run`, `ddev critical-run`, etc.

**Pattern**: Add a "Quick Start (Kanopi Projects)" section showing Kanopi-specific commands, then provide generic instructions for non-Kanopi projects.

### Documentation Site

- Built with Zensical (modern static site generator from the creators of Material for MkDocs)
- Organized into 7 main sections
- Follows same pattern as Kanopi's DDEV add-on documentation
- Deployed to GitHub Pages via Actions workflow
- Configuration in `zensical.toml` (TOML format)

## Development Workflow

### Adding a New Feature

**Two scenarios:**

#### Scenario A: Feature with Both Command and Skill

1. **Create skill first**: `/skills/feature-name/SKILL.md`
   - Add YAML frontmatter with name and description
   - Write complete workflow (150-300 lines)
   - Include all code examples, patterns, best practices
   - Add Drupal and WordPress examples

2. **Create command**: `/commands/feature-name.md`
   - Add frontmatter with description and allowed-tools
   - Write quick start (90-200 lines)
   - Reference skill for detailed instructions
   - Add "When to Use" section explaining command vs. skill

3. **Update documentation**:
   - Add to `docs/agent-skills.md` (skill)
   - Add to `docs/commands/overview.md` (command)
   - Update README if needed

#### Scenario B: Command Only (No Skill)

For explicit workflows that shouldn't auto-activate (PR creation, releases, etc.):
1. Create command with full documentation
2. No corresponding skill needed

### Updating Existing Features

**IMPORTANT: Skills are the single source of truth**

To update a feature:
1. **Update the skill** (`/skills/feature-name/SKILL.md`)
2. Command automatically reflects changes (it references the skill)
3. No need to update both!

When updating command files:
- Keep them concise and reference-focused
- Don't duplicate content from skills
- Update "When to Use" if invocation patterns change

Example:
```yaml
allowed-tools: Bash(composer:*), Bash(ddev composer:*), Bash(npm:*), Bash(ddev exec npm:*)
```

### Documentation Updates

1. **Edit files** in `/docs/`
2. **Test locally**: `zensical serve`
3. **Build**: `zensical build --clean` (catches broken links)
4. **Commit**: Automatically deploys to GitHub Pages on push to main

### Agent Skill Best Practices

When creating or updating Agent Skills, follow these guidelines:

#### Good Skill Description Examples

✅ **Good** (Specific trigger terms + clear use case):
```yaml
name: commit-message-generator
description: Automatically generate conventional commit messages when user has staged changes and mentions committing. Analyzes git diff and status to create properly formatted commit messages following conventional commits specification. Invoke when user mentions "commit", "staged", "committing", or asks for help with commit messages.
```

✅ **Good** (Clear activation context):
```yaml
name: security-scanner
description: Automatically scan code for security vulnerabilities when user asks if code is secure or shows potentially unsafe code. Performs focused security checks on specific code, functions, or patterns. Invoke when user asks "is this secure?", "security issue?", mentions XSS, SQL injection, or shows security-sensitive code.
```

❌ **Bad** (Too vague, no trigger terms):
```yaml
name: helper
description: Helps with code stuff when needed.
```

❌ **Bad** (Too broad, unclear when to activate):
```yaml
name: code-analyzer
description: Analyzes code quality, performance, security, accessibility, and more.
```

#### Key Elements of Good Skill Descriptions

1. **Specific trigger terms**: List exact phrases that should activate the skill
   - Example: "commit", "staged", "committing", "ready to commit"

2. **Clear use case**: What problem does this solve?
   - Example: "Generate conventional commit messages for staged changes"

3. **When to invoke**: Explicit conditions for activation
   - Example: "Invoke when user mentions X, Y, or shows Z"

4. **Scope boundaries**: What this skill does NOT do
   - Example: "Performs focused checks on specific elements" (not comprehensive audits)

#### Skill vs. Command Decision Guide

**Create an Agent Skill when:**
- ✅ Users might ask about this conversationally
- ✅ Quick, focused assistance on specific code/elements
- ✅ Common question that shouldn't require command knowledge
- ✅ Can be triggered by natural language patterns

**Create only a Slash Command when:**
- ✅ Explicit workflow with side effects (PR creation, releases)
- ✅ Comprehensive project-wide analysis (full audits)
- ✅ Requires specific targeting (PR number, file paths)
- ✅ Batch operations across many files
- ✅ Formal reports for stakeholders

**Create both (Skill + Command) when:**
- ✅ Users need both quick checks AND comprehensive analysis
- ✅ Example: accessibility-checker (quick) + /audit-a11y (comprehensive)

## File Organization

```
cms-cultivator/
├── .claude-plugin/
│   └── plugin.json          # Claude Code plugin metadata (version, description)
├── .github/workflows/
│   ├── docs.yml             # Zensical deployment
│   └── test.yml             # BATS test automation
├── commands/                # 24 slash command files (*.md)
│   ├── pr-*.md              # PR workflow commands
│   ├── audit-*.md           # Audit commands (comprehensive)
│   ├── test-*.md            # Testing commands
│   ├── quality-*.md         # Quality commands
│   └── docs-generate.md     # Documentation command
├── skills/                  # Agent Skill directories
│   ├── commit-message-generator/
│   ├── code-standards-checker/
│   ├── test-scaffolding/
│   ├── documentation-generator/
│   ├── test-plan-generator/
│   ├── accessibility-checker/
│   ├── performance-analyzer/
│   ├── security-scanner/
│   ├── coverage-analyzer/
│   ├── structured-data-analyzer/
│   └── README.md            # Skills overview
├── docs/                    # Zensical documentation site
│   ├── commands/            # Command category pages
│   ├── kanopi-tools/        # Kanopi integration docs
│   ├── agent-skills.md      # Agent Skills guide
│   ├── index.md             # Home page
│   ├── quick-start.md       # Getting started guide
│   └── contributing.md      # Contribution guidelines
├── tests/
│   └── test-plugin.bats     # 54 BATS tests
├── zensical.toml            # Zensical configuration
├── CHANGELOG.md             # Version history (Keep a Changelog format)
├── CLAUDE.md                # This file (AI assistant context)
└── README.md                # Project overview, points to docs site
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
- For flexible mode commands, document all argument options:
  - Depth modes (--quick, --standard, --comprehensive)
  - Scope control options
  - Output format options
  - Command-specific thresholds
  - Legacy focus areas (for backward compatibility)
- For simple commands, document all focus parameters and their options

### Documentation

- Write in active voice
- Use admonitions for warnings/tips/notes
- Include "Quick Start" sections at the top for common use cases
- Link between related docs
- Use emoji sparingly (only in headings for visual navigation)

### Markdown Style for Zensical

**IMPORTANT:** Follow the [Markdown Style Guide](docs/reference/markdown-style-guide.md) when creating or updating documentation.

**Key rules for proper Zensical rendering:**

1. **Use headings, not bold text for structure:**
   - ❌ DON'T: `1. **Category Name**` with sub-bullets
   - ✅ DO: `### Category Name` with bullet list

2. **Use headings for section titles:**
   - ❌ DON'T: `**Section Title:**` followed by list
   - ✅ DO: `#### Section Title` followed by list

3. **Heading hierarchy:**
   - `#` - Document title (once at top)
   - `##` - Major sections
   - `###` - Subsections
   - `####` - Categories, steps, or sub-subsections

4. **Step-by-step instructions:**
   - ❌ DON'T: `1. **Step Name**: Description` with sub-bullets
   - ✅ DO: `#### 1. Step Name` with description and bullet list

5. **Code blocks:**
   - Always specify language: ` ```bash `, ` ```php `, ` ```yaml `
   - Add context before code blocks

**See the complete guide for detailed examples and conversion patterns.**

### Frontmatter Standards

**Description**: Brief imperative statement (e.g., "Generate PR description from git changes")

**Argument-hint**: Show optional args in square brackets:
- For flexible mode commands: `[options]` (audit-a11y, audit-perf, audit-security, quality-analyze)
- For simple focus commands: `[focus-area]`
- For commands with specific args: `[ticket-number]`, `[file-path]`, etc.

**Allowed-tools**: List all tools, including both variants:
- Git operations: `Bash(git:*)` (required for `--scope=current-pr`)
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
zensical build --clean  # Catches broken links, missing pages
zensical serve          # Preview at http://localhost:8000
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

### Argument Mode Pattern (Audit/Quality Commands)

For commands with flexible argument modes (`/audit-a11y`, `/audit-perf`, `/audit-security`, `/quality-analyze`):

```markdown
## Usage

**Quick checks (pre-commit):**
```bash
/audit-a11y --quick --scope=current-pr
```

**Standard analysis (PR review, default):**
```bash
/audit-a11y --standard --scope=current-pr
# or simply:
/audit-a11y --scope=current-pr
```

**Comprehensive audit (pre-release):**
```bash
/audit-a11y --comprehensive --format=summary
```

**CI/CD integration:**
```bash
/audit-a11y --standard --format=json > results.json
```

## Arguments

### Depth Modes
- `--quick` - Critical issues only (~5 min)
- `--standard` - Full audit (default, ~15 min)
- `--comprehensive` - Deep analysis (~30 min)

### Scope Control
- `--scope=current-pr` - Only PR files
- `--scope=module=<name>` - Specific module
- `--scope=entire` - Full codebase (default)

### Output Formats
- `--format=report` - Detailed markdown (default)
- `--format=json` - JSON for CI/CD
- `--format=summary` - Executive summary

### Legacy Focus Areas (Still Supported)
- `focus1`, `focus2`, `focus3` - Single-word focus areas
- Can combine with new modes: `/command focus1 --quick`
```

### Simple Focus Parameter Pattern (Other Commands)

For commands without flexible modes:

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
- Zensical

Install: `pip install zensical`

## Resources

### External Documentation

- [Claude Code Documentation](https://docs.claude.com/en/docs/claude-code)
- [Zensical](https://zensical.org/)
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

- Run `zensical build --clean` to see errors
- Check for broken links in navigation (`zensical.toml`)
- Verify all referenced files exist in `docs/`
- Check frontmatter YAML syntax in command files
- Verify TOML syntax in `zensical.toml`

## Future Enhancements

Ideas for future development:

1. **Additional Commands**: Database migration analysis, deployment verification, etc.
2. **Enhanced Kanopi Integration**: Auto-detect Kanopi projects and adjust output
3. **Configuration File**: `.cms-cultivator.yml` for project-specific settings
4. **MCP Integration**: Connect to Model Context Protocol servers for enhanced capabilities
5. **Command Aliases**: Shorter versions of common commands
6. **Interactive Modes**: Multi-step workflows with user input

---

Last updated: 2026-02-17
