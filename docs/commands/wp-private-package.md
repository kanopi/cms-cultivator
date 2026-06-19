# WordPress Plugin → Kanopi Private Package

Convert a premium WordPress plugin that is currently **committed to a project repo** (or
hand-installed) into a **Kanopi private Composer package**, then switch the project to
install it through Composer like any other dependency.

## Skill

`wp-plugin-to-private-package [path-to-plugin-dir]` — Publish a committed premium plugin to
Kanopi's private Packagist and rewire the consuming site to install it via Composer.

## Why This Skill Exists

Kanopi's **WordPress Core and Plugins Installation Policy** requires plugins to be managed
by Composer wherever possible:

- **§2** — Free/contributed plugins come from [WPackagist](https://wpackagist.org).
- **§3** — Paid plugins should be installed from a Composer package, with the client
  license stored in CI environment variables (never `wp-config.php`).
- **§4** — Premium plugins that offer no Composer/vendor endpoint live in
  [Kanopi's private Packagist](https://kanopi.github.io/composer). Repos tagged
  `composer-package` are auto-indexed.

This skill automates the §4 path: it turns a committed plugin into a private package and
removes it from the project's git history.

## ⚠️ Irreversible Side Effects

This skill creates a **private GitHub repository** in the `kanopi/` org, sets topics and
team access, publishes a **release tag**, and edits the consuming repo's
`composer.json` / `.gitignore` / docs. It pauses for explicit confirmation before creating
the repo and before committing consuming-repo changes.

## When NOT to Use

- The plugin is on **WPackagist** → require `wpackagist-plugin/<slug>` directly.
- The vendor offers an **official Composer endpoint** (e.g. ACF Pro via
  `wpengine/advanced-custom-fields-pro`) → use it with the client license in CI env vars.
- A Kanopi private package **already exists** → just `composer require` it.

## How It Works

### Phase 0 — Discovery & Preconditions

- Confirms `gh` auth and `kanopi` org access
- Reads the plugin's `Version:` header (becomes the release tag)
- Checks Kanopi Packagist and the org for an existing package (no duplicates)
- Rules out WPackagist / vendor-endpoint availability
- Confirms naming: package `kanopi/<slug>`; repo name per the convention the user chooses
  (written policy `name-of-plugin` vs. the established `wp-premium-<slug>` prefix)

### Phase 1 — Create the Private Package Repo

- Stages the plugin files in a clean working directory
- Adds the package `composer.json` (`kanopi/<slug>`, `type: wordpress-plugin`,
  `minimum-stability: dev`)
- Creates the private `kanopi/<repo-name>` repo and pushes
- Sets topics (`wordpress`, `wordpress-plugin`, `composer-package`, `premium-plugin`,
  `do-not-archive`)
- Grants `everyone` + `wp-contractors` write access
- Publishes a release tag matching the plugin version

### Phase 2 — Rewire the Consuming Repo

- Ensures the Kanopi Satis `repositories` entry exists in `composer.json`
- Adds the `kanopi/<slug>` require
- Removes any `.gitignore` exception and ignores the plugin path
- `git rm --cached` the committed files (working copy preserved)
- Updates `README.md` and `CLAUDE.md` to document the new source

### Phase 3 — Index, Install & Commit

- Waits for Satis to index the package (cron every ~4 hours; metadata returns HTTP 200)
- Runs `composer update kanopi/<slug>` to update the lock file and reinstall the plugin
- Verifies the plugin is ignored and activates in WP admin
- Commits `composer.json`, `composer.lock`, `.gitignore`, docs, and the removals together

## Maintenance & Lifecycle

- **Update**: commit the new plugin version to the package repo, tag a matching release,
  bump the constraint, and `composer update`.
- **License**: the client still pays yearly; warn the PM if it expires on Production.
- **Re-evaluate**: switch to WPackagist/vendor endpoint if the plugin becomes available
  there, and retire the private package.
- **Offboarding**: remove the private package and commit the plugin again if the client
  leaves Kanopi.

## Prerequisites

- **GitHub CLI** — authenticated with `kanopi` org write access (`gh auth status`)
- **Git** — installed and configured
- **Composer** — locally or via DDEV (`ddev composer`) for the install step

## Related Skills

- **[`/devops-setup`](devops.md)** — Full Kanopi Drupal/Pantheon onboarding
- **[`/pr-create`](pr-workflow.md)** — Open the PR for the consuming-repo changes
- **[WordPress Meta Skills](wordpress-meta.md)** — Install official WordPress agent-skills
