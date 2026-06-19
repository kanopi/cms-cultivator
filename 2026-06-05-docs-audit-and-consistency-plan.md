# Docs Audit & Consistency Plan

**Date:** 2026-06-05
**Branch:** 1.x

---

## Summary

The category pages (`docs/commands/`) are accurate and well-organized. The main problems are: two agents undocumented in `agents-and-skills.md`, hardcoded counts scattered across docs and tests, several broken/stale references, and an 816-line page that tries to document agents and skills simultaneously with redundant verbose examples.

---

## Principle: No Hardcoded Counts

Counts go stale every time a skill or agent is added. Do not put counts in documentation prose or test assertions. If a BATS test needs to verify parity between two sets (e.g. agents vs. Codex TOMLs), compute both dynamically and compare them.

---

## Issues Found

### 1. Missing agents in `agents-and-skills.md`

Two agents exist in `/agents/` but are absent from every section of `agents-and-skills.md`:

- `drupalorg-issue-specialist`
- `drupalorg-mr-specialist`

Needs to be added to:
- Leaf Specialists list
- "Agent-to-Skill Mapping (Spawned By)" table
- "Agent-to-Skill Mapping (Uses Skills)" table

Reference: `drupal-contribution.md` already documents them correctly — copy that pattern.

---

### 2. Hardcoded counts in docs

| File | Line | Count | Fix |
|---|---|---|---|
| `docs/wordpress-skills.md` | 223 | "CMS Cultivator Skills (14)" | Remove the count, use a heading without a number |
| `docs/wordpress-skills.md` | 233 | "WordPress Skills (13)" | Remove the count |
| `docs/testing.md` | 100 | "Command count matches expected (25)" | Update example output or remove the count from the label |

---

### 3. Hardcoded counts in BATS tests (`tests/test-plugin.bats`)

| Line | Test | Fix |
|---|---|---|
| 93–95 | `[ "$count" -eq 46 ]` skill count | Remove assertion or replace with `[ "$count" -gt 0 ]` |
| 177–178, 190–191 | `[ "$count" -eq 14 ]` agent count | Same |
| 867–869 | `[ "$toml_count" -eq 14 ]` Codex TOML count | Replace with dynamic parity check: compare TOML count to agent dir count |

The Codex TOML parity test is worth keeping — it catches a missing translation file — but rewrite it as `[ "$toml_count" -eq "$agent_count" ]` so it never needs manual updating.

---

### 4. `commands/overview.md` — tip text has a self-referential typo (line 11)

```
The accessibility skill is `accessibility-audit`, not `accessibility-audit`.
The commit message helper is `commit-message-generator`, not `commit-message-generator`.
```

Both sides of "not" are identical. Either fix to show the actual old pre-v1.0 names (from `reference/skill-naming-convention.md`), or remove the tip if old names are no longer relevant.

---

### 5. `wordpress-skills.md` — broken links

- Line 365: `[CMS Cultivator Skills](agent-skills.md)` → should be `agents-and-skills.md`
- Line 366: `[Drupal Skills](drupal-org-integration.md)` → should be `drupal-contribution.md`

---

### 6. `agents-and-skills.md` — duplicate section heading and skill numbering

- Two separate sections both called "Agent-to-Skill Mapping" (lines 112 and 130) — confusing to navigate
- Skill number "10." appears twice (structured-data-analyzer and teamwork-task-creator)

Fix: rename the second mapping section to "Agent Knowledge Sources (Uses Skills)" and renumber the skills list.

---

### 7. `agents-and-skills.md` — verbose skill examples duplicate category pages

Skills 1–14 are documented with long fake chat transcripts (~600 lines). These duplicate what `docs/commands/` category pages already cover. Skills added later (pr-create, pr-review, design workflow, etc.) are only in the table at the bottom.

**Recommended approach:** Strip the verbose individual skill sections. Keep:
- The agent architecture description (valuable, not duplicated elsewhere)
- Both agent mapping tables (with drupalorg agents added)
- The skills reference table at the bottom
- The "How to Use" and "Skill Activation Tips" sections (brief, useful)

This takes the page from ~816 lines to ~200–250 lines without losing anything that isn't already documented in a better place.

---

### 8. `agents-and-skills.md` — "Disabling Skills" section is incomplete

Lines 795–802 show empty code blocks and don't describe a real mechanism. Either document the real mechanism or remove the section.

---

## Prioritized Work

| Priority | Change | File | Effort |
|---|---|---|---|
| P0 | Add drupalorg specialists to agent tables | `agents-and-skills.md` | Small |
| P1 | Remove hardcoded counts from docs | `wordpress-skills.md`, `testing.md` | Tiny |
| P1 | Fix BATS hardcoded count assertions | `tests/test-plugin.bats` | Small |
| P1 | Fix self-referential tip text | `commands/overview.md` | Tiny |
| P1 | Fix broken links | `wordpress-skills.md` | Tiny |
| P1 | Fix duplicate heading + skill numbering | `agents-and-skills.md` | Tiny |
| P2 | Strip verbose skill examples, keep table + architecture | `agents-and-skills.md` | Medium |
| P2 | Remove or fix "Disabling Skills" section | `agents-and-skills.md` | Tiny |

---

## What Does NOT Need Changing

- `docs/commands/*.md` — all category pages are accurate and up-to-date
- `docs/drupal-contribution.md` and `drupal-contribution-skills.md` — comprehensive and correct
- `docs/index.md` — accurate feature list
- `docs/reference/agent-skills-reference.md` — external Anthropic skills context, useful
- All `skills/*/SKILL.md` files — not in scope (this is doc-layer only)
- All `agents/*/AGENT.md` files — not in scope
