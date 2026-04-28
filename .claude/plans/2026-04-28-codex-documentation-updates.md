# Codex Documentation Updates + Full Doc Audit

## Context

CMS Cultivator added OpenAI Codex support in v1.0.0 (April 15, 2026), shipping:
- `.codex-plugin/plugin.json` — Codex plugin manifest
- `.codex/agents/` — 17 TOML agent translation files
- `skills/*/agents/openai.yaml` — invocation policies for 14 skills requiring confirmation

The README.md already reflects multi-platform support ("Works in Claude Code, Claude Desktop, and OpenAI Codex"), but the docs site (`docs/`) still frames the plugin as Claude Code-only. Additionally, `docs/contributing.md` references the removed `commands/` directory (deleted in v1.0.0).

**Codex installation mechanics (from official docs):**
- Codex reads `.codex-plugin/plugin.json` as the plugin manifest
- Skills invoke via natural language or `@skill-name` explicitly
- CLI marketplace: `codex plugin marketplace add owner/repo`
- Personal install: clone to `~/.codex/plugins/` + add `~/.agents/plugins/marketplace.json`
- Repo-scoped: copy to `$REPO_ROOT/plugins/` + add `$REPO_ROOT/.agents/plugins/marketplace.json`
- Config at `~/.codex/config.toml`

---

## Files to Change

### 1. `docs/index.md`
**Changes:**
- Line 6: "CMS Cultivator is a comprehensive Claude Code plugin providing 38 Agent Skills" → "CMS Cultivator is a plugin for Claude Code, Claude Desktop, and OpenAI Codex providing 38 Agent Skills"
- Requirements section (line 135): "Claude Code CLI" → "Claude Code CLI or OpenAI Codex"
- Add explicit feature bullet for Codex under the features list (alongside the Auto-Invoked / Natural Language bullets — add "Multi-Platform — Works in Claude Code, Claude Desktop, and OpenAI Codex")

### 2. `README.md`
**Changes:**
- Requirements section ("Claude Code CLI" under Required) → list as "Claude Code CLI or OpenAI Codex"
- Quick Start section: keep Claude Code `/plugin` commands as-is, add a "**Codex**" sub-block with:
  ```bash
  # Add the kanopi marketplace
  codex plugin marketplace add kanopi/claude-toolbox
  # Then open the plugin browser and install CMS Cultivator
  codex/plugins
  ```

### 3. `docs/installation.md` (major rewrite)
**Structure:** Restructure into two top-level sections: **Claude Code** and **OpenAI Codex**.

Keep the existing Methods 1–4 under a `## Claude Code` heading.

Add a `## OpenAI Codex` section with three methods:

**Codex Method 1: Via Marketplace (Recommended)**
```bash
# Add the Kanopi marketplace
codex plugin marketplace add kanopi/claude-toolbox
# Open the plugin browser
codex/plugins
# Browse to CMS Cultivator and select Install plugin
```

**Codex Method 2: Personal Installation (Manual)**
```bash
# Clone to personal Codex plugins directory
git clone https://github.com/kanopi/cms-cultivator ~/.codex/plugins/cms-cultivator
```
Then create/update `~/.agents/plugins/marketplace.json`:
```json
{
  "name": "kanopi-plugins",
  "plugins": [
    {
      "name": "cms-cultivator",
      "source": { "source": "local", "path": "./cms-cultivator" },
      "policy": { "installation": "AVAILABLE", "authentication": "ON_INSTALL" },
      "category": "Development"
    }
  ]
}
```
Restart Codex, then open `codex/plugins` and install.

**Codex Method 3: Repo-Scoped Installation**
Copy plugin to `$REPO_ROOT/plugins/cms-cultivator` and add `$REPO_ROOT/.agents/plugins/marketplace.json` (same structure as above). Commit to git for team sharing.

**Codex Verification:**
- Open a new thread and type `@cms-cultivator` to confirm it's available
- Or say "Does this follow Drupal coding standards?" — skills activate automatically

**Codex Invocation section:**
- Natural language: same as Claude Code
- Explicit: use `@cms-cultivator` or `@skill-name` (e.g. `@pr-create`)

**Prerequisites section:** Update to mention Codex as an alternative platform.

### 4. `docs/contributing.md` (moderate changes)
**Changes:**
- Prerequisites: "Claude Code CLI (for testing commands)" → "Claude Code CLI or OpenAI Codex (for testing skills)"
- Development setup step 4: Add Codex testing alternative alongside Claude Code link
- Remove the stale **"Adding a New Command"** section entirely (commands/ was deleted in v1.0.0)
- Replace with **"Adding a New Skill"** section matching the actual workflow from `CLAUDE.md`:
  1. Create `/skills/feature-name/SKILL.md` with YAML frontmatter
  2. Test locally (link to plugin in Claude Code or Codex)
  3. Run `./scripts/validate-frontmatter.sh`
  4. Update `docs/agents-and-skills.md` if applicable
- Frontmatter section: remove the stale "Commands" field list (commands were removed), keep Agents and Skills

### 5. `docs/agents-and-skills.md`
**Changes:**
- Lines 1-8: Fix the "three-tier architecture" description that lists "Slash Commands" as a tier — slash commands were removed in v1.0.0. Update to two-tier: Specialist Agents + Agent Skills
- Any other references to slash commands as the user-facing invocation method should be updated to reflect `/skill-name` explicit invocation in Claude Code and `@skill-name` in Codex

### 6. `docs/reference/agent-skills-reference.md`
**Changes:**
- Line 5: "replaced custom slash commands as the primary extensibility model for Claude Code plugins" → add "and OpenAI Codex"
- Lines 36-43: "Installing skills in Claude Code" → add a parallel paragraph for Codex: "Skills in Codex are installed via the plugin system. Install the plugin, then skills load automatically based on context."
- Line 68: "Skill-creator (available as a Claude Code plugin)" — add "(also available for OpenAI Codex)"

### 7. `docs/quick-start.md`
**Changes:**
- Add a brief note near the top (after the two-ways intro) clarifying that `/command` syntax is Claude Code; in Codex, use `@skill-name` for explicit invocation. Natural language works the same on both platforms.

---

## Files NOT Changing

- `docs/commands/overview.md` — already mentions Codex correctly
- `docs/commands/design-workflow.md` — Figma MCP config is genuinely Claude Code-specific; will add a note that design validation features require Claude Code
- `docs/project-management/teamwork-integration.md` — MCP-specific, Claude Code only; accurate as-is
- `docs/commands/live-site-auditing.md` — Chrome DevTools MCP is Claude Code-specific; accurate as-is
- `docs/wordpress-skills.md` — "Restart Claude Code" instructions are minor and accurate for that context; low priority

---

## Verification

After implementation:
1. `zensical build --clean` — verify no broken links
2. `zensical serve` — preview at http://localhost:8000, check Installation and Contributing pages
3. Confirm `docs/agents-and-skills.md` no longer references the three-tier slash command architecture
4. Confirm `docs/contributing.md` no longer references `commands/` directory
5. Confirm `docs/installation.md` has both Claude Code and Codex sections with accurate commands
