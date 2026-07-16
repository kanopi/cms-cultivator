# Skill Naming Convention

CMS Cultivator skills follow a noun-first, descriptive naming convention. This page explains the convention and provides a mapping from the old pre-v1.0 slash-command names to current skill names.

---

## The Convention

Skill names describe **what the skill does** as a thing, not as a command.

### Pattern

`<domain>-<purpose>` (e.g., `commit-message-generator`, `browser-validator`, `documentation-generator`)

The domain comes first (commit-message, design, drupal, test, documentation, etc.), the purpose second (generator, validator, analyzer, checker, manager, etc.).

### Why noun-first?

- **Discoverability.** A user looking for design tools types "design" and gets `design-analyzer`, `design-to-wp-block`, and `design-to-drupal-paragraph` together — they share a prefix.
- **Conversational fit.** When Claude says "I'm running the coverage analyzer", that reads naturally. "Running test-coverage" doesn't.
- **MCP and skill parity.** MCP tool names follow the same noun-first convention. Skills should feel consistent with the MCP layer they sit beside.
- **No verb soup.** Skills don't all start with `do-` or `run-`. The name reflects the thing produced or the system targeted.

---

## Pre-v1.0 Migration Mapping

Before v1.0, CMS Cultivator used a `commands/` directory with slash-command-style names. v1.0 moved to skills and renamed everything. If you have muscle memory or stale documentation referencing the old names, use this mapping.

| Pre-v1.0 name | Current skill name | Notes |
|---------------|--------------------|-------|
| `quality-standards` | `code-standards-checker` | |
| `pr-commit-msg` | `commit-message-generator` | |
| `pr-desc` | `pr-create` | The whole "draft PR description + create PR" flow is one skill now |
| `docs-generate` | `documentation-generator` | |
| `test-generate` | `test-scaffolding` | |
| `test-coverage` | `coverage-analyzer` | |
| `test-plan` | `test-plan-generator` | |
| `design-validate` | `browser-validator` | |
| `design-to-block` | `design-to-wp-block` | Made platform-explicit |
| `design-to-paragraph` | `design-to-drupal-paragraph` | Made platform-explicit |

### What hasn't changed

These names were already noun-first and didn't change:

- `pr-create`, `pr-review`, `pr-release`
- `wp-add-skills`

### What moved out in 2.0

As of 2.0, CMS Cultivator focuses on CMS development workflows. Delivery Record moved to its own public library: [kanopi/delivery-record](https://github.com/kanopi/delivery-record). Audit, DevOps, and PM capabilities moved to separate internal Kanopi libraries — their pre-v1.0 names are no longer mapped here.

---

## When You Hit a Wrong Name

If you invoke `/test-coverage` in Claude Code and nothing happens, that name was never registered — there are no command aliases. The skill is `coverage-analyzer`. You can also describe what you want in natural language and the right skill will activate automatically — for example, "what's not tested?" reliably triggers `coverage-analyzer`.

If you find a wrong name in the docs, please open an issue or PR. CI includes a check that every `/skill-name` reference in `docs/commands/*.md` matches an actual `skills/<name>/` directory, but the broader docs aren't covered by that check yet.

---

## See Also

- [Skills Overview](../commands/overview.md) — Full category index of current skill names
- [Agents & Skills](../agents-and-skills.md) — Two-tier architecture and skill descriptions
- [Contributing](../contributing.md) — How to add new skills (follow the naming convention)
