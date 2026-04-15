# Claude Context for CMS Cultivator Development

This file provides context for Claude (or other AI assistants) when working on this project.

## Project Overview

**CMS Cultivator** is a Claude Code plugin providing specialized Agent Skills for Drupal and WordPress development. It integrates with Kanopi's DDEV add-ons and standardized Composer scripts. Skills work across Claude Code, Claude Desktop, and OpenAI Codex.

### Architecture: "Agents Orchestrate, Skills Guide"

- **Specialist Agents** (`/agents/`) - Autonomous agents that orchestrate complex workflows by spawning other agents in parallel. Use fully qualified names when referencing: `cms-cultivator:agent-name:agent-name`
- **Agent Skills** (`/skills/`) - Detailed "how-to" documentation with complete workflows, examples, and instructions. Single source of truth and universal invocation format.

## Key Architectural Decisions

### Architecture: Agents + Skills

**Two complementary systems:**

1. **Specialist Agents** (`/agents/`)
   - Autonomous agents spawned by skills or other agents
   - Orchestrate complex workflows with parallel execution
   - Each agent has a specific domain expertise
   - **IMPORTANT:** When agents reference other agents via the Task tool, use fully qualified names: `cms-cultivator:agent-name:agent-name`
   - Examples: accessibility-specialist, security-specialist, performance-specialist, etc.

2. **Agent Skills** (`/skills/`)
   - Model-invoked (Claude decides when to use)
   - Complete technical documentation
   - Detailed workflows, examples, best practices
   - **Single source of truth** for implementation details
   - Universal invocation format across Claude Code, Claude Desktop, and OpenAI Codex

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

Skills automatically reference Kanopi-specific tools when available:

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

1. **Create skill**: `/skills/feature-name/SKILL.md`
   - Add YAML frontmatter with name and description
   - Write complete workflow (150-300 lines)
   - Include all code examples, patterns, best practices
   - Add Drupal and WordPress examples

2. **Update documentation**:
   - Add to `docs/agents-and-skills.md`
   - Update `skills/README.md`
   - Update README if needed

### Updating Existing Features

**IMPORTANT: Skills are the single source of truth**

To update a feature:
1. **Update the skill** (`/skills/feature-name/SKILL.md`)
2. No need to update anything else — the skill is the authoritative source

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

#### When to Create a New Skill

**Create an Agent Skill when:**
- ✅ Users might ask about this conversationally
- ✅ Quick, focused assistance on specific code/elements
- ✅ Common question that shouldn't require explicit invocation
- ✅ Can be triggered by natural language patterns
- ✅ Explicit workflow with side effects (PR creation, releases)
- ✅ Comprehensive project-wide analysis (full audits)
- ✅ Batch operations across many files
- ✅ Formal reports for stakeholders

## File Organization

```
cms-cultivator/
├── .claude-plugin/
│   └── plugin.json          # Claude Code plugin metadata (version, description)
├── .codex-plugin/
│   └── plugin.json          # OpenAI Codex plugin manifest
├── .codex/
│   └── agents/              # 17 .toml Codex agent translation files
├── .github/workflows/
│   ├── docs.yml             # Zensical deployment
│   └── test.yml             # BATS test automation
├── agents/                  # Specialist agent directories
│   ├── accessibility-specialist/
│   ├── security-specialist/
│   ├── performance-specialist/
│   ├── teamwork-specialist/
│   └── ...                  # 17 total agents
├── skills/                  # Agent Skill directories (38 total)
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
│   ├── commands/            # Skill category documentation pages
│   ├── kanopi-tools/        # Kanopi integration docs
│   ├── agents-and-skills.md # Agents & Skills guide
│   ├── index.md             # Home page
│   ├── quick-start.md       # Getting started guide
│   └── contributing.md      # Contribution guidelines
├── scripts/
│   └── validate-frontmatter.sh  # Frontmatter validation script
├── tests/
│   └── test-plugin.bats     # 75 BATS tests
├── zensical.toml            # Zensical configuration
├── CHANGELOG.md             # Version history (Keep a Changelog format)
├── CLAUDE.md                # This file (AI assistant context)
└── README.md                # Project overview, points to docs site
```

## Important Files to NOT Modify

- **Plugin metadata**: `.claude-plugin/plugin.json`
- **GitHub Actions**: `.github/workflows/docs.yml` (stable deployment)

## Code Conventions

### Skill Files

- Use `## Heading 2` for major sections
- Use `###  Heading 3` for subsections
- Include code examples with proper syntax highlighting (```bash, ```php, ```javascript)
- Provide both Drupal AND WordPress examples where applicable
- Skills are comprehensive (150-300 lines)

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

**Description**: Brief imperative statement describing when and how to invoke the skill. Include trigger terms and use cases.

**Required fields for skills:**
- `name`: Kebab-case skill identifier matching the directory name
- `description`: When to invoke, what it does, specific trigger phrases

## Testing Approach

### Frontmatter Validation

Before committing changes, validate all frontmatter:

```bash
./scripts/validate-frontmatter.sh
```

This script validates:
- Frontmatter presence and YAML syntax
- Required fields for agents and skills
- Non-empty values
- Name consistency between files and directories
- `openai.yaml` policy files for Codex compatibility

See [Contributing Guide](docs/contributing.md#validating-frontmatter) for details.

### Manual Testing

1. **Install locally**: `ln -s $(pwd) ~/.config/claude/plugins/cms-cultivator`
2. **Enable**: `claude plugins enable cms-cultivator`
3. **Test skill**: Open Claude Code and use natural language to trigger the skill
4. **Verify**:
   - Skill activates on expected trigger phrases
   - Output is formatted correctly
   - Examples work for both Drupal and WordPress
   - Kanopi integration works (if applicable)

### Documentation Testing

```bash
zensical build --clean  # Catches broken links, missing pages
zensical serve          # Preview at http://localhost:8000
```

### Cross-Platform Testing

Test skills with:
- Drupal project (with and without Kanopi add-on)
- WordPress project (with and without Kanopi add-on)
- Non-DDEV setup (direct tool execution)

## Common Patterns

### Platform Detection Pattern

Skills should work on both platforms. Use conditional examples:

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

## Dependencies

### Runtime Dependencies (User's Machine)

- Claude Code CLI
- Git
- GitHub CLI (`gh`) - for PR skills
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

### When adding Kanopi integration to skills

1. Check if the tool exists in Kanopi add-ons (see `docs/kanopi-tools/overview.md`)
2. Add a "Quick Start (Kanopi Projects)" section
3. Don't remove generic instructions

### When documentation builds fail

- Run `zensical build --clean` to see errors
- Check for broken links in navigation (`zensical.toml`)
- Verify all referenced files exist in `docs/`
- Check frontmatter YAML syntax in skill files
- Verify TOML syntax in `zensical.toml`

## Future Enhancements

Ideas for future development:

1. **Additional Skills**: Database migration analysis, deployment verification, etc.
2. **Enhanced Kanopi Integration**: Auto-detect Kanopi projects and adjust output
3. **Configuration File**: `.cms-cultivator.yml` for project-specific settings
4. **MCP Integration**: Connect to Model Context Protocol servers for enhanced capabilities
5. **Interactive Modes**: Multi-step workflows with user input

---

Last updated: 2026-04-15
