# Skill Naming Convention

CMS Cultivator skills follow a noun-first, descriptive naming convention. This page explains the convention and provides a mapping from the old pre-v1.0 slash-command names to current skill names.

---

## The Convention

Skill names describe **what the skill does** as a thing, not as a command.

### Pattern

`<domain>-<purpose>` (e.g., `accessibility-audit`, `security-scanner`, `documentation-generator`)

The domain comes first (accessibility, security, performance, design, drupal, teamwork, etc.), the purpose second (audit, scanner, generator, analyzer, integrator, exporter, etc.).

### Why noun-first?

- **Discoverability.** A user looking for accessibility tools types "accessib" and gets `accessibility-audit` and `accessibility-checker` together — they share a prefix.
- **Conversational fit.** When Claude says "I'm running the accessibility audit", that reads naturally. "Running audit-a11y" doesn't.
- **MCP and skill parity.** MCP tool names follow the same noun-first convention (e.g., `mcp__teamwork__twprojects-list_tasks`, not `mcp__teamwork__list-tasks-twprojects`). Skills should feel consistent with the MCP layer they sit beside.
- **No verb soup.** Skills don't all start with `audit-` or `do-`. The name reflects the thing produced or the system targeted.

### What about depth pairs?

Some domains have both a **focused** skill (quick, conversational) and a **comprehensive** skill (full audit):

| Domain | Focused | Comprehensive |
|--------|---------|---------------|
| Accessibility | `accessibility-checker` | `accessibility-audit` |
| Security | `security-scanner` | `security-audit` |
| Performance | `performance-analyzer` | `performance-audit` |

The focused skill is what activates when you ask "is this accessible?" about a specific element. The comprehensive skill activates when you ask for a full audit. Both are first-class skills with their own SKILL.md.

---

## Pre-v1.0 Migration Mapping

Before v1.0, CMS Cultivator used a `commands/` directory with slash-command-style names. v1.0 moved to skills and renamed everything. If you have muscle memory or stale documentation referencing the old names, use this mapping.

| Pre-v1.0 name | Current skill name | Notes |
|---------------|--------------------|-------|
| `audit-a11y` | `accessibility-audit` | Comprehensive audit; for element-level checks use `accessibility-checker` |
| `audit-perf` | `performance-audit` | Comprehensive audit; for query/asset-level analysis use `performance-analyzer` |
| `audit-security` | `security-audit` | Comprehensive audit; for code-level checks use `security-scanner` |
| `audit-quality` / `quality-analyze` | `quality-audit` | |
| `quality-standards` | `code-standards-checker` | |
| `audit-live-site` | `live-site-audit` | |
| `audit-gtm` | `gtm-performance-audit` | |
| `audit-structured-data` | `structured-data-analyzer` | |
| `pr-commit-msg` | `commit-message-generator` | |
| `pr-desc` | `pr-create` | The whole "draft PR description + create PR" flow is one skill now |
| `docs-generate` | `documentation-generator` | |
| `test-generate` | `test-scaffolding` | |
| `test-coverage` | `coverage-analyzer` | |
| `test-plan` | `test-plan-generator` | |
| `design-validate` | `browser-validator` | |
| `design-to-block` | `design-to-wp-block` | Made platform-explicit |
| `design-to-paragraph` | `design-to-drupal-paragraph` | Made platform-explicit |
| `teamwork create` | `teamwork-task-creator` | |
| `teamwork status` | `teamwork-integrator` | Read-only lookups |
| `teamwork export` | `teamwork-exporter` | Batch audit export |

### What hasn't changed

These names were already noun-first and didn't change:

- `pr-create`, `pr-review`, `pr-release`
- `devops-setup`
- `wp-add-skills`
- `accessibility-checker`, `security-scanner`, `performance-analyzer`

---

## When You Hit a Wrong Name

If you invoke `/audit-a11y` in Claude Code and nothing happens, that name was never registered — there are no command aliases. The skill is `accessibility-audit`. You can also describe what you want in natural language and the right skill will activate automatically — for example, "audit this page for accessibility" reliably triggers `accessibility-audit`.

If you find a wrong name in the docs, please open an issue or PR. CI includes a check that every `/skill-name` reference in `docs/commands/*.md` matches an actual `skills/<name>/` directory, but the broader docs aren't covered by that check yet.

---

## See Also

- [Skills Overview](../commands/overview.md) — Full category index of current skill names
- [Agents & Skills](../agents-and-skills.md) — Two-tier architecture and skill descriptions
- [Contributing](../contributing.md) — How to add new skills (follow the naming convention)
