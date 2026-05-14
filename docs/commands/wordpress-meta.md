# WordPress Meta Skills

Skills that extend CMS Cultivator with additional WordPress-specific tooling from other sources.

---

## Available Skills

### wp-add-skills

**Purpose:** Install the official `WordPress/agent-skills` collection from the WordPress org's GitHub repository. These are WordPress-specific skills authored by the core WordPress team — block development, REST API helpers, WP-CLI workflows, Playground, Interactivity API, performance, accessibility, and more.

**Auto-invoked triggers:** "add WordPress skills", "install the official WordPress agent-skills", "expand CMS Cultivator with WordPress tooling".

**Workflow:**

1. Confirms the install target (global `~/.claude/skills/` or repo-scoped `.claude/skills/`)
2. Clones or updates [WordPress/agent-skills](https://github.com/WordPress/agent-skills) from GitHub
3. Symlinks (or copies, depending on preference) each skill into the chosen target
4. Lists the newly-available skills

**Options:**

- `--list` — Show currently installed WordPress skills
- `--update` — Update installed skills to the latest version from the WordPress repo
- `--scope=global|project` — Choose install scope (default: global)

**What it installs:**

The full WordPress/agent-skills catalog, which currently includes skills for:

- Block development (`block.json`, registration, attributes, dynamic rendering)
- Block themes (`theme.json`, template parts, patterns, style variations)
- REST API (route registration, controllers, schemas, permissions)
- WP-CLI workflows
- WordPress Playground
- Interactivity API
- WordPress Design System (WPDS)
- Abilities API
- PHPStan for WordPress
- Plugin development
- Performance investigation
- Project triage

The exact list updates as the WordPress team adds skills upstream.

---

## Why This Skill Exists

CMS Cultivator's own skills are CMS-platform-neutral where possible (PR workflows, design-to-code, FRD planning, PM workflows, etc.) — they work on Drupal and WordPress alike.

For deep WordPress-specific tooling — Gutenberg block internals, theme.json semantics, REST API patterns — the WordPress core team maintains its own `agent-skills` repository. Rather than duplicate that work, `wp-add-skills` makes those skills available alongside CMS Cultivator's skills with one command.

You don't need this skill if you're not doing deep WordPress work. CMS Cultivator's built-in `design-to-wp-block` and other WP-aware skills cover the common cases.

---

## Related Skills

- **[design-to-wp-block](design-workflow.md)** — Built-in WP block creation from Figma designs
- **[Skills Overview](overview.md)** — CMS Cultivator's own skill catalog

## See Also

- **[WordPress Skills Guide](../wordpress-skills.md)** — Longer-form guide on combining the official WP skills with CMS Cultivator
- **[WordPress/agent-skills](https://github.com/WordPress/agent-skills)** — Upstream repository
