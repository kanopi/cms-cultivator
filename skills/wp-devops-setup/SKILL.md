---
name: wp-devops-setup
description: Convert an existing Pantheon WordPress site to Kanopi's DevOps system — the Composer-managed kanopi/wp-pantheon-starter layout with DDEV, CircleCI → Pantheon deploys, code-quality tooling, Quicksilver hooks, and visual/a11y/perf gates. Invoke when a user asks to "onboard a Pantheon WordPress site", "set up Kanopi DevOps for this WordPress site", "convert this WP site to wp-pantheon-starter", "add CircleCI/DDEV to this WordPress Pantheon site", or uses /wp-devops-setup. This is the WordPress counterpart to devops-setup (which targets Drupal). Irreversible multi-system setup — creates GitHub repos, configures Pantheon, and makes code changes; requires explicit user confirmation at each phase.
disable-model-invocation: true
---

# WordPress Pantheon → Kanopi DevOps Setup

Onboard an existing **Pantheon-hosted WordPress** site to Kanopi's standardized DevOps
system: a Composer-managed [`kanopi/wp-pantheon-starter`](https://github.com/kanopi/wp-pantheon-starter)
layout, DDEV local environment, CircleCI → Pantheon deploy pipeline, code-quality gates,
and Quicksilver deploy hooks.

This is the **WordPress** counterpart to the `devops-setup` skill (which targets
Drupal via `kanopi/drupal-starter`). Use this when the CMS is WordPress.

## ⚠️ Side Effect Warning

**This skill makes irreversible changes across multiple systems:**

- Creates a new **GitHub repository** in the `kanopi/` organization
- Configures branch protection rules and GitHub teams
- Makes code changes across many files and creates a new branch + PR
- Adds Composer dependencies and converts core/plugins to Composer management
- May create **Kanopi private Composer packages** for premium plugins (see Phase 5)

**Explicit user confirmation is required before each destructive phase.** Pause and
confirm before creating the GitHub repo, before any Pantheon changes, and before pushing
code.

## Usage

- "Set up Kanopi DevOps for this Pantheon WordPress site"
- "Onboard this WordPress site to our CircleCI/Pantheon pipeline"
- "Convert this WP site to the wp-pantheon-starter layout"
- `/wp-devops-setup [git-url]`

**Arguments**: Optional Pantheon git URL (SSH) or existing GitHub URL. If omitted, ask.

## Prerequisites

- **Git** and **GitHub CLI** (`gh auth status`) with `kanopi` org write access
- **Terminus** CLI authenticated to Pantheon, plus the Pantheon **site name + UUID**
- **DDEV** installed locally
- **Composer** available (locally or via `ddev composer`)
- The Pantheon site's **`TERMINUS_MACHINE_TOKEN`** and the **ACF Pro license** (if the site
  uses ACF Pro) from 1Password
- Reference layout: [`kanopi/wp-pantheon-starter`](https://github.com/kanopi/wp-pantheon-starter)
  (`main` branch) — fetch config templates from here at runtime rather than hand-writing them

## Target Architecture (what "done" looks like)

- **Composer-managed** WordPress: core from `johnpbloch/wordpress-core`, contributed plugins
  from [WPackagist](https://wpackagist.org) (`wpackagist-plugin/*`), themes likewise. Core
  and contributed code are **gitignored**; only custom code (theme/mu-plugins) is committed.
- **Web root `web/`** (`web_docroot: true`), `composer/installers` paths route plugins to
  `web/wp-content/plugins/{$name}` and themes to `web/wp-content/themes/{$name}`.
- **DDEV** (`type: wordpress`, `docroot: web`, nginx-fpm, Pantheon provider) with a
  `db-refresh` command and an image proxy to a live Pantheon environment.
- **CircleCI → Pantheon** using Kanopi orbs (`kanopi/ci-tools`, `kanopi/cms-updates`):
  `compile-theme` (builds assets, persists to workspace) → `pantheon-deploy` (multidev on
  PRs, dev on `main`), plus `static-tests` (PHPCS/Rector/PHPStan) and Lighthouse/pa11y/
  BackstopJS gates on PRs, and scheduled "update dev" + "automatic updates" pipelines.
- **`pantheon.yml`** with `web_docroot: true`, `enforce_https: full`, protected paths, and
  Quicksilver `workflows` (search-replace, WP-CFM config import, New Relic logging,
  post-deploy).
- **Premium plugins** sourced via Composer — vendor endpoint where one exists, otherwise a
  Kanopi private package (delegated to the `wp-plugin-to-private-package` skill).

## Workflow Phases

Confirm with the user at the start of each phase. Where possible, fetch reference files
from `kanopi/wp-pantheon-starter` instead of hand-authoring them.

### Phase 1 — Git & GitHub Setup

- Clone the site from the provided Pantheon git URL (or existing GitHub repo).
- Create a new **private** GitHub repo under `kanopi/`.
- Configure remotes: `pantheon` (original) + `origin` (new kanopi repo); push `main`.
- Configure repo settings: squash-merge only, auto-delete head branches, branch protection
  on `main` (required PR review, status checks, conversation resolution).
- Add the GitHub team (write access) and `.github/CODEOWNERS` (`* @kanopi/<team>`).

### Phase 2 — Composerize WordPress

- Create the root `composer.json` from the starter:
  - `johnpbloch/wordpress-core` + `kanopi/wp-core-installer` (deploys core into `web/`),
    `composer/installers`, `cweagans/composer-patches`, `pantheon-systems/pantheon-mu-plugin`.
  - `repositories`: WPackagist, the **Kanopi private Packagist** (`https://kanopi.github.io/composer`),
    and any vendor endpoints (e.g. ACF's `connect.advancedcustomfields.com`).
  - `extra.installer-paths` for plugins/themes/mu-plugins; `extra.wordpress-install-dir: web`.
  - `config.vendor-dir` per the starter (this project uses
    `web/wp-content/mu-plugins/vendor`, so quality-tool binaries live under its `bin/`).
- Inventory the existing `wp-content/plugins` and `wp-content/themes`; for each contributed
  plugin/theme, add the matching `wpackagist-plugin/*` / `wpackagist-theme/*` requirement.
- Add the require-dev quality tools: `automattic/vipwpcs` (PHPCS WordPress-VIP-Go),
  `szepeviktor/phpstan-wordpress`, `rector/rector`, `php-stubs/acf-pro-stubs` (if ACF),
  `ergebnis/composer-normalize`, `roave/security-advisories`.
- Add the Composer scripts targeting the custom theme: `phpcs`/`phpcbf` (WordPress-VIP-Go),
  `phpstan` (level 5 + WP/ACF stubs), `rector-check`/`rector-fix`, plus `-ci` variants that
  emit JUnit to `test-results/`.
- **`.gitignore`**: ignore `web/wp-content/plugins/*` and `themes/*` (Composer-managed),
  keep custom theme/mu-plugins, ignore the compiled theme CSS (CI builds it), ignore
  `vendor/`, `auth.json`, and the generated `wp-config-ddev.php`.
- Preserve the existing **DB table prefix** (read it — e.g. this project uses `next_`, not
  `wp_`). Branch `wp-config.php` env detection: Pantheon → DDEV (`wp-config-ddev.php`) →
  local (`wp-config-local.php`) → fallback.

### Phase 3 — DDEV Local Environment

- Add `.ddev/config.yaml` (`type: wordpress`, `docroot: web`, matching `php_version` and
  `database` version from `pantheon.yml`, `nodejs_version` matching the theme `.nvmrc`).
- Configure the **Pantheon provider** (`.ddev/providers/pantheon.yaml`) and a `db-refresh`
  command that pulls the live DB and runs search-replace.
- Configure the uploads **image proxy** (NGINX) to a live Pantheon environment via
  `HOSTING_ENV` / `PROXY_URL` web-environment vars.
- Document `auth.json` placement and `TERMINUS_MACHINE_TOKEN` global config in the README.

### Phase 4 — Pantheon Config & Quicksilver

- Add `pantheon.yml`: `api_version: 1`, `web_docroot: true`, matching `php_version` and
  `database.version`, `enforce_https: full`, `build_step: false`, and `protected_web_paths`
  (`/private/`, autodiscover URLs).
- Add Quicksilver scripts under `web/private/scripts/` and wire them in `pantheon.yml`
  `workflows` (clone_database/create_cloud_development_environment → search-replace;
  sync_code/deploy → WP-CFM config import, New Relic logging, post-deploy).
- **Object cache**: only enable Redis / add `object-cache.php` if the Pantheon plan supports
  it. On a basic plan, do **not** add wp-redis/object-cache.php or a `pantheon.yml`
  `object_cache` block.

### Phase 5 — Premium Plugins (delegate to `wp-plugin-to-private-package`)

For each premium/committed plugin found in Phase 2's inventory, choose a Composer source —
**never leave a paid plugin committed or hand-installed**:

1. **Official vendor Composer endpoint** → require it directly and put the client license in
   CircleCI env vars (never `wp-config.php`). Example: ACF Pro via
   `wpengine/advanced-custom-fields-pro`, authed with `ACF_CLIENT_USER` (license key) +
   `ACF_CLIENT_PASSWORD` (registered URL).
2. **Already on Kanopi private Packagist** → just `composer require kanopi/<slug>`.
3. **No Composer source anywhere** → **invoke the `wp-plugin-to-private-package` skill** to
   publish it as a Kanopi private package (`kanopi/<slug>`), then require it. That skill
   handles the private repo, topics, team access, version release, and rewiring
   `composer.json`/`.gitignore`.

> This is the integration point: `wp-devops-setup` discovers the premium plugins;
> `wp-plugin-to-private-package` packages each one. Run it once per plugin that needs it.

### Phase 6 — Theme Build & CircleCI Pipeline

- Add the theme build tooling per the starter (`.nvmrc`, gulp/Dart-Sass or the theme's
  existing build; compiled CSS gitignored). Pin CI Node to the theme `.nvmrc`.
- Add `.circleci/config.yml` from the starter and fill the anchors:
  `PANTHEON_UUID`, `TERMINUS_SITE`, `THEME_PATH`, PHP/Node image tags. Leave the
  `SLACK_HOOK` anchor as `"${SLACK_WEBHOOK}"` — the Slack webhook is a secret and must
  not be hardcoded (see Manual Follow-Up); it resolves at runtime from the env var.
  - `compile-theme` builds assets and `persist_to_workspace`s the compiled CSS;
    `pantheon-deploy` `attach_workspace`s it and `rm .gitignore` so built assets ship.
  - `static-tests` runs `phpcs-ci`/`rector-ci`/`phpstan-ci` on PRs (non-`main`).
  - PR gates: Lighthouse, pa11y, BackstopJS (visual regression vs the dev baseline).
  - Scheduled (created in CircleCI, see Manual Follow-Up — names must match the
    config's `<< pipeline.schedule.name >>` guards): "update dev" (clone live content →
    dev) **nightly**, and "automatic updates"
    (`cms-updates/run-update cms: wordpress … update-method: composer`) **weekly**.
- Add `.circleci/scripts/` helpers (`pantheon/dev-multidev`, `github/add-commit-comment`)
  from the starter.

### Phase 7 — Docs & PR

- Write/refresh `README.md` (URLs, DDEV setup, Composer/premium-plugin notes, deploy flow,
  CircleCI env vars, code-quality commands) and `CLAUDE.md` (dev commands + non-obvious
  conventions: vendor-dir, table prefix, ACF source, compiled-CSS-is-built-in-CI, etc.).
- Push the feature branch, open a PR with a full description, and output the verification
  checklist + manual follow-up tasks.

## Manual Follow-Up Tasks (always required)

1. **CircleCI context** — set `kanopi-code` context vars: `TERMINUS_TOKEN`,
   `ACF_CLIENT_USER`, `ACF_CLIENT_PASSWORD` (if ACF), `GITHUB_TOKEN`.
2. **Slack webhook (project-level secret)** — set `SLACK_WEBHOOK` (the
   `circleci/slack@3.4.2` orb's default webhook env var) in this project's CircleCI
   **Project Settings → Environment Variables**, *not* the shared `kanopi-code` context
   (which spans all projects). The `SLACK_HOOK` anchor stays `"${SLACK_WEBHOOK}"`; never
   commit the literal webhook URL.
3. **CircleCI SSH key** — add a deploy SSH key to Pantheon.
4. **Scheduled pipelines** — create two schedules in CircleCI (Project Settings →
   Triggers, or the API). The names must match the config's
   `<< pipeline.schedule.name >>` guards exactly:
   - **`update dev`** — nightly (daily, e.g. 09:00 UTC) — clones live content → dev.
   - **`automatic updates`** — weekly (e.g. Mondays 09:00 UTC) — Composer core/plugin updates.
5. **First multidev** — open a test PR and confirm the multidev builds, the theme compiles,
   and the Lighthouse/pa11y/BackstopJS comments post.

## WordPress vs Drupal

| | WordPress (this skill) | Drupal (`devops-setup`) |
|---|---|---|
| Reference layout | `kanopi/wp-pantheon-starter` | `kanopi/drupal-starter` |
| Core package | `johnpbloch/wordpress-core` | `drupal/core-recommended` |
| Contrib source | WPackagist | `packages.drupal.org` |
| Config import | WP-CFM (Quicksilver) | Drupal config sync |
| Code standard | WordPress-VIP-Go (PHPCS) | Drupal/DrupalPractice (PHPCS) |
| Updates orb | `cms-updates` `cms: wordpress` | `cms-updates` `cms: drupal` |

## Related Skills

- **wp-plugin-to-private-package** — Package premium/committed plugins as Kanopi private
  Composer packages (invoked in Phase 5)
- **devops-setup** — The Drupal/Pantheon equivalent of this skill
- **pr-create** — Open PRs for follow-up changes
- **quality-audit** / **security-audit** — Audit the site after onboarding
