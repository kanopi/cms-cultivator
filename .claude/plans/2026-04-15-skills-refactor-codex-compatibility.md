# CMS Cultivator v1.0 + Codex Compatibility

## Context

CMS Cultivator 0.9.x ships 27 slash commands, 20 skills, and 17 agents. v1.0 makes two structural changes:

1. **Consolidate commands → skills**: Skills are the universal invocation format across Claude Code (`/name`), Claude Desktop, and OpenAI Codex (`$name`). Removing `commands/` eliminates dual maintenance. The only loss is `allowed-tools` frontmatter enforcement — replaced by explicit confirmation steps in skill content for side-effect workflows.

2. **Add Codex compatibility layer**: `.codex-plugin/plugin.json` (manifest), `skills/*/agents/openai.yaml` (invocation policy per skill), and `.codex/agents/*.toml` (17 agent translations).

**Outcome**: 38 skills + 17 agents, one unified format.

---

## Dependency Order

```
Phase 1: Create 18 new skills (SKILL.md + agents/openai.yaml where needed)
     ↓
Phase 2: Update 17 AGENT.md files (skills arrays + descriptions + model fixes)
     ↓
Phase 3: Update BATS tests + validate-frontmatter.sh  ← must precede deletion
     ↓
Phase 4: Delete commands/ entirely
     ↓
Phase 5: Codex manifest (.codex-plugin/plugin.json) — independent, can merge with Phase 1-2 timing
     ↓
Phase 6: Codex agent files (.codex/agents/*.toml) — needs Phase 2 finalized skills arrays
     ↓
Phase 7: Docs + version bump
```

Phases 3 and 4 must stay in this order: BATS and the validation script reference `commands/`; deleting the directory before updating them causes failures.

---

## Phase 1: Create 18 New Skills

### 1a. 10 skills converted from commands (copy content, apply two-tier pattern)

| New skill dir | Source command | Needs openai.yaml | Reason |
|---|---|---|---|
| `accessibility-audit` | `audit-a11y.md` | yes | comprehensive, should not auto-fire |
| `performance-audit` | `audit-perf.md` | yes | same |
| `security-audit` | `audit-security.md` | yes | same |
| `quality-audit` | `quality-analyze.md` | yes | same |
| `live-site-audit` | `audit-live-site.md` | yes | same + chrome-devtools dep |
| `pr-review` | `pr-review.md` | no | informational, fine to auto-activate on PR context |
| `audit-export` | `export-audit-csv.md` | no | informational |
| `design-to-wp-block` | `design-to-block.md` | no | design context auto-activation is fine |
| `design-to-drupal-paragraph` | `design-to-paragraph.md` | no | same |
| `audit-report` | *(net-new, no source)* | yes | client-facing; must not auto-fire |

### 1b. 8 skills converted from "keep" commands

| New skill dir | Source command | Needs openai.yaml | Reason |
|---|---|---|---|
| `pr-create` | `pr-create.md` | yes | side effect: creates GitHub PR |
| `pr-release` | `pr-release.md` | yes | side effect: version bump, git tags |
| `devops-setup` | `devops-setup.md` | yes | irreversible multi-system setup |
| `drupal-contribute` | `drupal-contribute.md` | yes | side effects via sub-agents |
| `drupal-issue` | `drupal-issue.md` | yes | side effect: clipboard/browser actions |
| `drupal-mr` | `drupal-mr.md` | yes | side effect: git push |
| `drupal-cleanup` | `drupal-cleanup.md` | yes | destructive filesystem operations |
| `wp-add-skills` | `wp-add-skills.md` | yes | installs to `~/.claude/skills/` (Claude) or `~/.agents/skills/` (Codex) |

### Skill file structure

Each new skill creates:
```
skills/<name>/
  SKILL.md          ← converted/written content
  agents/openai.yaml  ← only for skills in the "yes" column above
```

**SKILL.md frontmatter** (same as existing skills):
```yaml
---
name: skill-name
description: <specific trigger terms + clear use case + "Invoke when...">
---
```

**agents/openai.yaml** template:
```yaml
policy:
  allow_implicit_invocation: false
interface:
  display_name: "CMS Cultivator: <Human Readable Name>"
  short_description: "<One concise sentence>"
```

For `live-site-audit` only, also add:
```yaml
dependencies:
  tools:
    - name: chrome-devtools
      required: false
```

**Two-tier pattern** (required for all 18 new skills):
```markdown
## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)
[Workflow using only Read, Grep, Glob, and file analysis.
For side-effect skills: explicit "waiting for confirmation" step before any action.]

### Tier 2 — Claude Code Enhanced
[Uses Task() to spawn specialist agents, bash tools, MCP servers.]
```

For the 9 side-effect skills (`pr-create`, `pr-release`, `devops-setup`, `drupal-mr`, `drupal-contribute`, `drupal-issue`, `drupal-cleanup`, `wp-add-skills`), both tiers must explicitly state what irreversible actions will be taken and require user confirmation before executing.

**`wp-add-skills` platform detection**: Tier 1 installs to `~/.agents/skills/` (Codex path); Tier 2 installs to `~/.claude/skills/` (Claude Code path). Detect platform via environment variable or context.

**`audit-report`** (net-new, no source command): Write from scratch. Purpose: generate client-facing executive summaries from existing audit report files. Should accept a report file path as input and produce a non-technical summary. Tier 1 reads and transforms the file; Tier 2 can use formatting tools.

### 10 commands being deleted (already covered by existing skills — no new SKILL.md needed)

`audit-gtm.md`, `audit-structured-data.md`, `design-validate.md`, `docs-generate.md`, `pr-commit-msg.md`, `quality-standards.md`, `teamwork.md`, `test-coverage.md`, `test-generate.md`, `test-plan.md`

These commands redirect to existing skills. No new files needed; just delete.

---

## Phase 2: Update 17 AGENT.md Files

Current `skills:` field is a comma-separated single line (e.g., `skills: accessibility-checker`). Keep this format — just add skill names.

### Skills array additions

| Agent | Current skills | Add |
|---|---|---|
| `accessibility-specialist` | `accessibility-checker` | `accessibility-audit` |
| `performance-specialist` | `performance-analyzer` | `performance-audit` |
| `security-specialist` | `security-scanner` | `security-audit` |
| `code-quality-specialist` | `code-standards-checker` | `quality-audit` |
| `live-audit-specialist` | `[]` | `strategic-thinking` (and `audit-report` once created) |
| `workflow-specialist` | `commit-message-generator, strategic-thinking` | `pr-create, pr-review, pr-release` |
| `design-specialist` | `design-analyzer, responsive-styling, strategic-thinking` | `design-to-wp-block, design-to-drupal-paragraph` |
| `browser-validator-specialist` | `browser-validator` | *(no change)* |
| `testing-specialist` | `test-scaffolding, test-plan-generator, coverage-analyzer` | *(no change)* |
| `teamwork-specialist` | `teamwork-task-creator, teamwork-integrator, teamwork-exporter` | `audit-export` |
| `drupalorg-issue-specialist` | `drupalorg-issue-helper` | `drupal-issue` |
| `drupalorg-mr-specialist` | `drupalorg-contribution-helper` | `drupal-mr` |
| `drupal-pantheon-devops-specialist` | `[]` | `devops-setup` |
| `documentation-specialist` | `documentation-generator` | *(no change)* |
| `structured-data-specialist` | `structured-data-analyzer` | *(no change)* |
| `gtm-specialist` | `gtm-performance-audit` | *(no change)* |
| `responsive-styling-specialist` | `responsive-styling` | *(no change)* |

### Other agent changes

- **`drupalorg-issue-specialist`**: Change `model: sonnet` → `model: haiku` (simpler workflow, cost savings)
- **All agents**: Review description field against "good description" examples in CLAUDE.md — must include specific trigger terms, clear use case, and "Invoke when..." clause. Flag any that are vague ("helps with X") for rewrite.
- **`live-audit-specialist`**: Description is already detailed; no change needed.

---

## Phase 3: Update BATS Tests + validate-frontmatter.sh

### BATS test rewrite (`tests/test-plugin.bats`)

The current 54 tests are heavily commands-oriented. After v1.0, `commands/` is gone. Changes needed:

**DELETE these test groups** (reference `commands/` directly):
- "COMMAND FILE STRUCTURE TESTS" (lines 59–76) — 4 tests including hardcoded count of 27
- "COMMAND FRONTMATTER TESTS" (lines 83–137) — 5 tests
- "COMMAND NAMING CONVENTION TESTS" (lines 143–198) — 10 tests (pr-4, a11y-1, etc.)
- "COMMAND CONTENT TESTS" (lines 204–227) — 2 tests
- "ALLOWED-TOOLS VALIDATION TESTS" (lines 233–264) — 2 tests
- "COMMAND-TO-AGENT INTEGRATION TESTS" (lines 548–674) — 15 tests referencing commands/*.md
- File hygiene and security tests that loop over `commands/*.md` (lines 877–924)
- Performance tests on `commands/` (lines 968–980)

**ADD new tests**:
```bash
# Skill structure
@test "skills directory exists" { [ -d "skills" ] }
@test "skill count matches expected (38)" {
  count=$(find skills -mindepth 1 -maxdepth 1 -type d | wc -l)
  [ "$count" -eq 38 ]
}
@test "all skill directories have SKILL.md file" { ... }
@test "all skills have name and description in frontmatter" { ... }
@test "skill names match directory names" { ... }

# openai.yaml structure
@test "skills that should not auto-fire have agents/openai.yaml" {
  # Check the 13 skills that need allow_implicit_invocation: false
  expected=("accessibility-audit" "performance-audit" "security-audit" "quality-audit"
            "live-site-audit" "pr-create" "pr-release" "devops-setup" "drupal-contribute"
            "drupal-issue" "drupal-mr" "drupal-cleanup" "wp-add-skills" "audit-report")
  for skill in "${expected[@]}"; do
    [ -f "skills/$skill/agents/openai.yaml" ]
  done
}
@test "openai.yaml files have allow_implicit_invocation: false" { ... }

# Codex manifest
@test "codex plugin manifest exists" { [ -f ".codex-plugin/plugin.json" ] }
@test "codex manifest is valid JSON" { run jq empty .codex-plugin/plugin.json; [ "$status" -eq 0 ] }
@test "codex agents directory has 17 toml files" {
  count=$(find .codex/agents -name "*.toml" | wc -l)
  [ "$count" -eq 17 ]
}

# Skill-to-agent integration (replaces command-to-agent tests)
@test "accessibility-specialist references accessibility-audit skill" { ... }
@test "workflow-specialist references pr-create and pr-review skills" { ... }
# ... etc.
```

**KEEP unchanged**: plugin manifest tests, agent structure/frontmatter tests, agent skills mapping tests, documentation tests, license/metadata tests.

**Net result**: Remove ~25 tests, add ~20 new tests. Target: ~49 tests total.

### validate-frontmatter.sh updates

Current structure: validates `commands/*.md`, `agents/*/AGENT.md`, `skills/*/SKILL.md`.

Changes:
1. **Remove the "Validating Commands" section entirely** (lines 79–139) — `commands/` directory will not exist
2. **Add "Validating Codex Agent Files" section** after the skills section:
```bash
echo "⚙️  Validating Codex Invocation Policy (skills/*/agents/openai.yaml)"
for file in skills/*/agents/openai.yaml; do
  # Check: file is valid YAML, has policy.allow_implicit_invocation field
done
```

---

## Phase 4: Delete commands/ Directory

After Phase 3 passes, delete all 27 files in `commands/`. No files survive.

```bash
rm -rf commands/
```

---

## Phase 5: Codex Manifest

Create `.codex-plugin/plugin.json`:

```json
{
  "name": "cms-cultivator",
  "version": "1.0.0",
  "description": "38 skills + 17 agents for Drupal and WordPress. Works in Claude Code, Claude Desktop, and OpenAI Codex.",
  "author": {
    "name": "Kanopi Studios",
    "email": "code@kanopi.com",
    "url": "https://kanopi.com"
  },
  "homepage": "https://kanopi.github.io/cms-cultivator/",
  "repository": "https://github.com/kanopi/cms-cultivator",
  "license": "GPL-2.0-or-later",
  "keywords": ["drupal", "wordpress", "accessibility", "performance", "security", "cms", "codex"],
  "skills": "./skills/",
  "interface": {
    "displayName": "CMS Cultivator",
    "shortDescription": "Drupal & WordPress skills: audits, PR workflows, design-to-code, Drupal.org contribution",
    "developerName": "Kanopi Studios",
    "category": "Development",
    "composerIcon": "./assets/icon-64.png",
    "websiteURL": "https://kanopi.github.io/cms-cultivator/"
  }
}
```

Note: `assets/icon-64.png` is a placeholder. Add to `.gitignore` or create a stub. Icon creation is a separate follow-up task.

Also update `.claude-plugin/plugin.json`: bump `version` to `"1.0.0"`, update `description` to match new reality (38 skills, no commands).

---

## Phase 6: Codex Agent Files

Create `.codex/agents/` directory with one `.toml` per specialist agent. Do this after Phase 2 so `skills` arrays are finalized.

Template per file:
```toml
name = "accessibility-specialist"
description = "<value from AGENT.md description: frontmatter>"
model = "claude-sonnet-4-6"   # or claude-haiku-4-5-20251001 for drupalorg-issue-specialist
developer_instructions = """
<AGENT.md body, frontmatter stripped>
"""

[[skills.config]]
path = "accessibility-checker"

[[skills.config]]
path = "accessibility-audit"
```

17 files total, one per agent directory. The `[[skills.config]]` entries come from the finalized `skills:` field in each AGENT.md after Phase 2.

---

## Phase 7: Documentation + Version Bump

### Files to update

| File | Change |
|---|---|
| `CLAUDE.md` | Remove all `commands/` references; update architecture section to "Agents Orchestrate, Skills Guide"; add `.codex-plugin/` and `.codex/` to file organization; note `agents/openai.yaml` controls Codex invocation; remove "Commands" from "File Organization" tree |
| `README.md` | Update stat to "38 skills + 17 agents"; add "Works in Claude Code, Claude Desktop, and OpenAI Codex"; update audience quick-starts |
| `CHANGELOG.md` | Add v1.0.0 entry describing: commands→skills migration, Codex compatibility layer, 18 new skills, agent skills array updates |
| `skills/README.md` | Add 18 new skills to the listing |
| `docs/commands/overview.md` | Rename/repurpose to `docs/skills/overview.md` or update to reflect skills-only architecture |
| `docs/installation.md` | Add Codex installation section alongside Claude Code section |
| `docs/agents-and-skills.md` | Update skill count to 38; add new skills to tables |

### docs/ reorganization

The `docs/commands/` directory has pages for each command category. After v1.0 these become skills pages. Options:
- Rename `docs/commands/` → `docs/skills/` and update all cross-links
- Or keep `docs/commands/` path but update content to say "these are now skills"

Update `zensical.toml` nav to reflect the renamed section. Run `zensical build --clean` to catch broken links.

---

## Critical Files Summary

| File/Directory | Action |
|---|---|
| `commands/` (27 files) | DELETE entirely (Phase 4) |
| `skills/<18 new dirs>/SKILL.md` | CREATE (Phase 1) |
| `skills/<13 dirs>/agents/openai.yaml` | CREATE (Phase 1) |
| `.codex-plugin/plugin.json` | CREATE (Phase 5) |
| `.codex/agents/*.toml` (17 files) | CREATE (Phase 6) |
| `.claude-plugin/plugin.json` | UPDATE version + description (Phase 7) |
| `agents/*/AGENT.md` (17 files) | UPDATE skills arrays + descriptions + drupalorg-issue model (Phase 2) |
| `tests/test-plugin.bats` | REWRITE ~25 old tests, ADD ~20 new tests (Phase 3) |
| `scripts/validate-frontmatter.sh` | REMOVE commands section, ADD openai.yaml validation (Phase 3) |
| `CLAUDE.md` | UPDATE architecture section (Phase 7) |
| `README.md` | UPDATE messaging + stats (Phase 7) |
| `CHANGELOG.md` | ADD v1.0.0 entry (Phase 7) |
| `skills/README.md` | UPDATE listing (Phase 7) |
| `docs/` (multiple files) | UPDATE for skills-only architecture (Phase 7) |

---

## Verification

1. `./scripts/validate-frontmatter.sh` — all 38 skills and 17 agents pass; no commands section
2. `bats tests/test-plugin.bats` — all ~49 tests pass including new skill/Codex assertions
3. Check all 13 `agents/openai.yaml` files have `allow_implicit_invocation: false`
4. Check `drupalorg-issue-specialist/AGENT.md` has `model: haiku`
5. Verify `live-audit-specialist/AGENT.md` has `strategic-thinking` in skills field
6. Manual: install plugin locally, verify `/accessibility-audit` invokes correctly
7. Manual: verify `pr-create` skill requires explicit confirmation before creating PR (Tier 1 path)
8. Manual: verify `accessibility-checker` skill still auto-activates on "is this accessible?"
9. `jq empty .codex-plugin/plugin.json` — valid JSON
10. `zensical build --clean` — zero broken links
