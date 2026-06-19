---
name: wp-plugin-to-private-package
description: Convert a committed (or otherwise non-Composer) WordPress premium plugin into a Kanopi private Composer package, then rewire the consuming site to install it via Composer. Follows Kanopi's WordPress Core and Plugins Installation Policy (§3 paid plugins, §4 Kanopi Private Packagist). Invoke when a user says "make this plugin a Kanopi package", "move this committed plugin to Composer", "publish this premium plugin to Kanopi Packagist", "stop committing this plugin", or uses /wp-plugin-to-private-package. Creates a private GitHub repo in the kanopi org, sets topics/teams, tags a release, and edits the consuming repo's composer.json/.gitignore. Irreversible side effects — requires explicit user confirmation.
disable-model-invocation: true
---

# WordPress Plugin → Kanopi Private Composer Package

Convert a premium WordPress plugin that is currently **committed to a project repo** (or
hand-installed) into a **Kanopi private Composer package**, then switch the project to
install it through Composer like any other dependency.

This implements Kanopi's **WordPress Core and Plugins Installation Policy**:

- **§3 — Paid plugins** should be installed from a Composer package; the client license
  must live in CI environment variables, never `wp-config.php`, and the Kanopi license is
  never used for a client's paid plugin.
- **§4 — Kanopi Private Packagist** is the home for premium plugins that offer no
  Composer/vendor endpoint. Repos tagged `composer-package` are auto-indexed by
  [`kanopi.github.io/composer`](https://kanopi.github.io/composer).

## ⚠️ Side Effect Warning

**This skill makes irreversible changes across multiple systems:**

- Creates a new **private GitHub repository** in the `kanopi/` organization
- Adds GitHub **topics**, grants **team write access**, and publishes a **release tag**
- Edits the consuming project's `composer.json`, `.gitignore`, `README.md`, and docs
- Removes the committed plugin from the project's git history (working copy is preserved
  until Composer reinstalls it)

**Explicit user confirmation is required before creating the GitHub repo and before
committing changes to the consuming repo.** Pause and confirm at each phase boundary.

## Usage

- "Make ACF Theme Code Pro a Kanopi Composer package"
- "Move this committed plugin to our private Packagist"
- "Stop committing this premium plugin — publish it instead"
- `/wp-plugin-to-private-package [path-to-plugin-dir]`

**Arguments**: Optional path to the committed plugin directory (e.g.
`web/wp-content/plugins/acf-theme-code-pro`). If omitted, ask.

## Prerequisites

- `gh` CLI authenticated with **write access to the `kanopi` org** (`gh auth status`)
- `git` configured
- `composer` available (locally or via DDEV — `ddev composer`) for the final install step
- The consuming repo already has, or will get, the Kanopi Satis repository entry in
  `composer.json` (see Phase 2)

## When NOT to Use This Skill

- The plugin **is** available on [WPackagist](https://wpackagist.org) → require
  `wpackagist-plugin/<slug>` directly (Policy §2.2). No private package needed.
- The vendor offers an **official Composer endpoint** (e.g. ACF Pro via
  `wpengine/advanced-custom-fields-pro`, or other paid plugins with their own repo) →
  use that endpoint with the client license in CI env vars (Policy §3.1–§3.3).
- A Kanopi private package **already exists** for this plugin → just `composer require` it.

Always run Phase 0 discovery first to rule these out.

## Workflow

### Phase 0 — Discovery & Preconditions

1. **Confirm `gh` auth & org access**: `gh auth status`. The user must be able to create
   repos in `kanopi`.
2. **Locate the plugin & read its version**: find the main plugin file and parse the
   `Version:` header — this becomes the package's release tag.
   ```bash
   PLUGIN_DIR=web/wp-content/plugins/<slug>
   grep -m1 -iE "^[[:space:]]*\*?[[:space:]]*Version:" "$PLUGIN_DIR"/*.php
   ```
3. **Check for an existing Kanopi package** (Policy §4.1) — don't duplicate:
   ```bash
   curl -s https://kanopi.github.io/composer/packages.json | grep -i "<slug>"
   gh search repos --owner kanopi "<plugin keywords>"
   ```
4. **Confirm it's not on a public/vendor source** (see "When NOT to Use" above).
5. **Decide the names** and confirm with the user:
   - **Composer package name**: `kanopi/<slug>` (this is what `composer require` uses).
   - **GitHub repo name**: Kanopi's written policy (§4.2) says `name-of-plugin`; the
     established org convention for premium plugins is the `wp-premium-<slug>` prefix
     (e.g. `wp-premium-acfml` → package `kanopi/acfml`). **The repo name and package
     name are independent** — Satis reads the `name` field from the repo's
     `composer.json`. Ask the user which repo-name convention they want.

   > **Naming is a judgment call — always confirm with the user before creating the repo.**

### Phase 1 — Create the Private Package Repo

**⛔ Confirm with the user before creating anything in the `kanopi` org.**

1. **Stage the plugin files** in a clean working directory (strip `.git`, `.DS_Store`):
   ```bash
   WORK=$(mktemp -d)/<slug> && mkdir -p "$WORK"
   cp -R "$PLUGIN_DIR"/. "$WORK"/
   find "$WORK" \( -name .git -o -name .DS_Store \) -exec rm -rf {} +
   ```
2. **Add the package `composer.json`** (Policy §4.3) — substitute the real slug:
   ```json
   {
       "name": "kanopi/<slug>",
       "type": "wordpress-plugin",
       "minimum-stability": "dev"
   }
   ```
3. **Init, commit, create the private repo, and push**:
   ```bash
   cd "$WORK" && git init -q && git checkout -q -b main && git add -A
   git commit -q -m "Add <Plugin Name> v<version> as Kanopi Composer package"
   gh repo create kanopi/<repo-name> --private --source=. --remote=origin \
     --description="<Plugin Name> - Composer package (premium plugin)" --push
   ```
4. **Add topics** (Policy §4.7) — `do-not-archive` matches current org practice for
   premium repos and protects against archival:
   ```bash
   gh api -X PUT repos/kanopi/<repo-name>/topics \
     -f names[]=wordpress -f names[]=wordpress-plugin \
     -f names[]=composer-package -f names[]=premium-plugin -f names[]=do-not-archive
   ```
5. **Grant team write access** (Policy §4.8):
   ```bash
   gh api -X PUT orgs/kanopi/teams/everyone/repos/kanopi/<repo-name> -f permission=push
   gh api -X PUT orgs/kanopi/teams/wp-contractors/repos/kanopi/<repo-name> -f permission=push
   # verify (note: piping gh through head/tail masks gh's exit code):
   gh api repos/kanopi/<repo-name>/teams --jq '.[] | "\(.slug): \(.permission)"'
   ```
6. **Create the release/tag at the plugin version** (Policy §4.9) — the tag MUST match the
   plugin's `Version:` header so Composer can resolve and roll back:
   ```bash
   gh release create <version> --repo kanopi/<repo-name> --title "<version>" \
     --notes "<Plugin Name> v<version> — matches the upstream plugin version at package creation."
   ```

### Phase 2 — Rewire the Consuming Repo

1. **Ensure the Kanopi Satis repository is registered** in the project `composer.json`
   (it usually already is on Kanopi projects):
   ```json
   "repositories": {
       "kanopi": { "type": "composer", "url": "https://kanopi.github.io/composer" }
   }
   ```
2. **Add the require** (alphabetically sorted if `sort-packages` is on):
   ```json
   "kanopi/<slug>": "^<major>.<minor>"
   ```
3. **Remove any `.gitignore` exception** that was keeping the committed plugin tracked,
   and add the plugin path to the Composer-managed ignore list so it is no longer
   versioned (Policy §6.2):
   ```gitignore
   /web/wp-content/plugins/<slug>/
   ```
4. **Untrack the committed files** (keep the working copy on disk until Composer
   reinstalls — do NOT delete from disk):
   ```bash
   git rm -r --cached --quiet "$PLUGIN_DIR"
   ```
5. **Update docs**: point `README.md` (premium-plugins section) and `CLAUDE.md` at the
   new package source, and document the update/maintenance procedure (Policy §7.2, §8.3).

### Phase 3 — Index, Install & Commit

1. **Wait for Satis to index the package.** Kanopi's Satis (`kanopi/composer` →
   `.github/workflows/main.yml`) rebuilds on a cron (every ~4 hours) and supports manual
   `workflow_dispatch`. The package is live when its metadata returns HTTP 200:
   ```bash
   curl -s -o /dev/null -w "%{http_code}\n" \
     "https://kanopi.github.io/composer/p2/kanopi/<slug>.json"
   ```
   A maintainer with access can trigger it immediately:
   `gh workflow run main.yml --repo kanopi/composer` (shared infra — let the user run this
   if you lack permission; otherwise it auto-indexes within the cron window).
2. **Install via Composer** — updates `composer.lock` and reinstalls the plugin from the
   package into `web/wp-content/plugins/<slug>/`:
   ```bash
   composer update kanopi/<slug>   # or: ddev composer update kanopi/<slug>
   ```
3. **Verify**: `git status` should now show the plugin directory ignored (no deletions
   pending); confirm the plugin activates in WP admin at the expected version.
4. **Commit** `composer.json`, `composer.lock`, `.gitignore`, `README.md`, `CLAUDE.md`,
   and the file removals **together** (so the lock file always contains the package).

   > Do **not** commit the consuming-repo changes before the `composer update` succeeds —
   > otherwise the lock file won't contain the package and CI would deploy without it.

## Maintenance & Lifecycle (Policy §8.3, §9.2)

- **Updating the plugin**: download the new version, commit the files to the
  `kanopi/<repo-name>` repo, create a matching version tag/release (e.g. `2.5.6`), then
  bump the constraint in the project and `composer update kanopi/<slug>`.
- **License**: the client still pays for their license yearly; if it expires on
  Production, warn the project manager (Policy §3, §4 closing notes).
- **Re-evaluate periodically**: if the plugin later becomes available on WPackagist or a
  vendor Composer endpoint, switch to that and retire the private package (Policy §9.2).
- **Offboarding**: if the client leaves Kanopi, remove the private package and install the
  plugin through committed code again.

## WordPress vs Drupal

This skill is **WordPress-specific** (WPackagist, `wp-content/plugins`, `wordpress-plugin`
Composer type). For Drupal premium modules, the equivalent is Composer + the vendor's
`packages.drupal.org`/private endpoint or a Kanopi private package of `type:drupal-module`.

## Related Skills

- **devops-setup** — Full Kanopi Drupal/Pantheon onboarding (the broader DevOps workflow)
- **pr-create** — Open the PR for the consuming-repo changes
- **code-standards-checker** — Validate the consuming repo after the switch
