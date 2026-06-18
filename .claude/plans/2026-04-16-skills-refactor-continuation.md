# CMS Cultivator Plugin Audit — Improvement Plan

## Context

The plugin is well-structured with 38 skills, 17 agents (AGENT.md + Codex TOML), solid test coverage (75 BATS tests), and comprehensive developer instructions. Three categories of issues were found during the audit, ranging from a broken CI job to a parity gap between Codex invocation guards (already in place) and their missing Claude Code equivalents.

**Audit basis:** Anthropic Skill Authoring Best Practices, Claude Code Plugins/Agents docs, Codex Plugins/Agents/Skills docs.

---

## P0 — Critical: Fix Broken CI Job

### Problem
`.github/workflows/test.yml` — the `frontmatter-validation` job (lines 35–73) loops over `commands/*.md`. The `commands/` directory was removed in v1.0.0. Bash passes the literal string `commands/*.md` to the loop body; every `grep -q` against that non-existent path fails; the job always exits 1 with "Found 3 frontmatter errors." This fires on every PR.

The `security-scan` job (lines 129–147) also references `commands/*.md` and `commands/` but uses `2>/dev/null` and exit-code semantics that cause it to silently pass — wrong paths, false confidence.

The existing `scripts/validate-frontmatter.sh` correctly validates `agents/*/AGENT.md` and `skills/*/SKILL.md` with YAML syntax checks but is **never called from CI**.

### Changes

**File: `.github/workflows/test.yml`**

1. Replace the entire `frontmatter-validation` job (lines 35–73):

```yaml
frontmatter-validation:
  name: Validate SKILL.md and AGENT.md Frontmatter
  runs-on: ubuntu-latest
  steps:
    - uses: actions/checkout@v4
    - run: pip install pyyaml
    - run: chmod +x scripts/validate-frontmatter.sh && ./scripts/validate-frontmatter.sh
```

2. Fix `security-scan` job — replace `commands/*.md` references on lines 133 and 142:

```yaml
# Line 133 — replace:
if grep -ri "password\s*=\|api_key\s*=\|secret\s*=" commands/*.md docs/*.md | ...
# with:
if grep -ri "password\s*=\|api_key\s*=\|secret\s*=" skills/ agents/ docs/ | ...

# Line 142 — replace:
if grep -r "^<<<<<<< \|^=======$\|^>>>>>>> " commands/ docs/ 2>/dev/null; then
# with:
if grep -r "^<<<<<<< \|^=======$\|^>>>>>>> " skills/ agents/ docs/ 2>/dev/null; then
```

### Verification
Push a test branch. The `frontmatter-validation` job must pass green. Temporarily break a `name:` field in any SKILL.md to confirm the job catches it, then revert.

---

## P1 — High: Add `disable-model-invocation` to 14 Side-Effect Skills

### Problem
Claude Code skill frontmatter supports `disable-model-invocation: true` — it prevents Claude from auto-loading a skill based on conversational context, requiring explicit `/skill-name` invocation. This is the Claude Code equivalent of the Codex `allow_implicit_invocation: false` field.

14 skills already have `allow_implicit_invocation: false` in their `openai.yaml` files (controlling Codex), but their SKILL.md frontmatter is missing the Claude Code guard. Without it, Claude Code can auto-trigger skills that clone repos, push to GitHub, create drupal.org issues, or permanently delete local clones.

### Changes

For each of the 14 skills below, add `disable-model-invocation: true` as a third line in the YAML frontmatter block (after `description:`):

```yaml
---
name: <skill-name>
description: <existing description>
disable-model-invocation: true
---
```

**Files to modify:**
1. `skills/devops-setup/SKILL.md`
2. `skills/live-site-audit/SKILL.md`
3. `skills/drupal-contribute/SKILL.md`
4. `skills/drupal-issue/SKILL.md`
5. `skills/wp-add-skills/SKILL.md`
6. `skills/drupal-mr/SKILL.md`
7. `skills/performance-audit/SKILL.md`
8. `skills/drupal-cleanup/SKILL.md`
9. `skills/audit-report/SKILL.md`
10. `skills/accessibility-audit/SKILL.md`
11. `skills/pr-create/SKILL.md`
12. `skills/security-audit/SKILL.md`
13. `skills/quality-audit/SKILL.md`
14. `skills/pr-release/SKILL.md`

### BATS Tests to Add

Add to `tests/test-plugin.bats`:

```bash
@test "skills with openai.yaml also have disable-model-invocation in SKILL.md" {
  for yaml_file in skills/*/agents/openai.yaml; do
    [ -f "$yaml_file" ] || continue
    skill_dir=$(basename "$(dirname "$(dirname "$yaml_file")")")
    skill_file="skills/$skill_dir/SKILL.md"
    if ! grep -q "^disable-model-invocation: true" "$skill_file"; then
      echo "$skill_file has openai.yaml but missing disable-model-invocation: true"
      return 1
    fi
  done
}
```

This test enforces the parity rule going forward: any skill that opts out of Codex implicit invocation must also opt out of Claude Code auto-invocation.

### Verification
In a Claude Code session with the plugin loaded, type "run a full site audit." The `live-site-audit` skill should NOT auto-activate. Explicitly invoke `/audit-live-site` — it should work. Run `bats tests/test-plugin.bats` to confirm the new test passes.

---

## P2 — Medium: Add TOML Agent Test Coverage

### Problem
The 75-test BATS suite thoroughly validates `agents/*/AGENT.md` files but has zero tests for the 17 `.codex/agents/*.toml` files. A missing required field, malformed triple-quoted string, or name/filename mismatch would not surface in CI.

### Changes

**File: `tests/test-plugin.bats`** — add a new section:

```bash
# ==============================================================================
# CODEX TOML AGENT TESTS
# ==============================================================================

@test "codex agents directory exists" {
  [ -d ".codex/agents" ]
}

@test "codex agent TOML count matches AGENT.md count (17)" {
  toml_count=$(find .codex/agents -name "*.toml" | wc -l)
  [ "$toml_count" -eq 17 ]
}

@test "every AGENT.md directory has a corresponding TOML agent" {
  for agent_dir in agents/*/; do
    agent_name=$(basename "$agent_dir")
    if [ ! -f ".codex/agents/${agent_name}.toml" ]; then
      echo "Missing TOML for agent: $agent_name"
      return 1
    fi
  done
}

@test "every TOML agent has a corresponding AGENT.md directory" {
  for toml_file in .codex/agents/*.toml; do
    agent_name=$(basename "$toml_file" .toml)
    if [ ! -d "agents/$agent_name" ]; then
      echo "TOML $toml_file has no matching agents/$agent_name/ directory"
      return 1
    fi
  done
}

@test "all TOML agents have required name field" {
  for toml_file in .codex/agents/*.toml; do
    if ! grep -q "^name = " "$toml_file"; then
      echo "Missing name field in $toml_file"; return 1
    fi
  done
}

@test "all TOML agents have required description field" {
  for toml_file in .codex/agents/*.toml; do
    if ! grep -q "^description = " "$toml_file"; then
      echo "Missing description in $toml_file"; return 1
    fi
  done
}

@test "all TOML agents have developer_instructions field" {
  for toml_file in .codex/agents/*.toml; do
    if ! grep -q "^developer_instructions" "$toml_file"; then
      echo "Missing developer_instructions in $toml_file"; return 1
    fi
  done
}

@test "TOML agent names match their filenames" {
  for toml_file in .codex/agents/*.toml; do
    file_name=$(basename "$toml_file" .toml)
    toml_name=$(grep "^name = " "$toml_file" | head -1 | sed 's/^name = "\(.*\)"/\1/')
    if [ "$file_name" != "$toml_name" ]; then
      echo "Name mismatch in $toml_file: file=$file_name, toml=$toml_name"; return 1
    fi
  done
}

@test "all TOML agents have model field" {
  for toml_file in .codex/agents/*.toml; do
    if ! grep -q "^model = " "$toml_file"; then
      echo "Missing model field in $toml_file"; return 1
    fi
  done
}
```

### Verification
Run `bats tests/test-plugin.bats` — all 9 new tests should pass. Temporarily rename one TOML file or remove a `name =` line to confirm tests catch the regression.

---

## P3 — Low: Progressive Disclosure for Long Skills

### Problem
Anthropic recommends keeping SKILL.md bodies under 500 lines. Two skills are long enough that extracting reference material into supporting files would reduce load-time token cost and improve readability:

- `skills/security-scanner/SKILL.md` — ~369 lines. The `## Quick Security Checks` (PHP code examples, ~90 lines) and `## Common Vulnerabilities` sections (~40 lines) are reference material loaded into context even for quick inline checks.
- `skills/strategic-thinking/SKILL.md` — ~306 lines. The `## Example Interactions` section (~77 lines) contains worked examples only needed when demonstrating the framework.

### Changes

**security-scanner:**
- Create: `skills/security-scanner/security-patterns.md` containing the full `## Quick Security Checks` and `## Common Vulnerabilities` sections
- In `SKILL.md`, replace those sections with a pointer:
  ```markdown
  ## Quick Security Checks
  For detailed vulnerability patterns and fix examples by category, see [security-patterns.md](security-patterns.md).
  Key categories: SQL injection, XSS, CSRF, insecure auth, sensitive data exposure, file uploads.
  ```

**strategic-thinking:**
- Create: `skills/strategic-thinking/5cs-examples.md` containing the `## Example Interactions` section
- In `SKILL.md`, replace with a pointer:
  ```markdown
  ## Example Interactions
  For worked examples of the 5 Cs framework in action, see [5cs-examples.md](5cs-examples.md).
  ```

### Verification
Confirm `bats tests/test-plugin.bats` still passes (existing tests should be unaffected). Manually test the skills in Claude Code — they should still reference examples via progressive loading.

---

## P4 — Low: Update skills/README.md

### Problem
`skills/README.md` intro correctly says "38 Agent Skills" but the numbered list documents only ~27 skills. Nine newly added skills are absent.

### Changes

**File: `skills/README.md`** — add entries for the 9 missing skills:
- `browser-validator`
- `design-analyzer`
- `drupalorg-contribution-helper`
- `drupalorg-issue-helper`
- `responsive-styling`
- `structured-data-analyzer`
- `teamwork-exporter`
- `teamwork-integrator`
- `teamwork-task-creator`

Follow the existing format for each entry (triggers, purpose, related command/agent).

### Verification
Count entries in the numbered list matches 38. `bats tests/test-plugin.bats` still passes.

---

## Critical Files

| Priority | File | Change |
|----------|------|--------|
| P0 | `.github/workflows/test.yml` | Replace broken job; fix security-scan paths |
| P1 | `skills/pr-create/SKILL.md` + 13 others | Add `disable-model-invocation: true` |
| P1 | `tests/test-plugin.bats` | Add openai.yaml parity test |
| P2 | `tests/test-plugin.bats` | Add 9 TOML agent tests |
| P3 | `skills/security-scanner/SKILL.md` | Extract to `security-patterns.md` |
| P3 | `skills/strategic-thinking/SKILL.md` | Extract to `5cs-examples.md` |
| P4 | `skills/README.md` | Document 9 missing skills |

## Existing Infrastructure to Reuse

- `scripts/validate-frontmatter.sh` — already correct, just needs to be wired into CI (P0)
- `skills/*/agents/openai.yaml` — already identifies which skills need guards (P1)
- BATS test patterns in `tests/test-plugin.bats` — follow existing loop-and-grep patterns for new tests (P1, P2)
