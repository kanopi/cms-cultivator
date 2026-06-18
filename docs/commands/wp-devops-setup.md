# WordPress Pantheon → Kanopi DevOps Setup

Onboard an existing **Pantheon-hosted WordPress** site to Kanopi's standardized DevOps
system. This is the **WordPress** counterpart to [DevOps Setup](devops.md) (which targets
Drupal).

## Skill

`wp-devops-setup [git-url]` — Convert a Pantheon WordPress site to the Composer-managed
`kanopi/wp-pantheon-starter` layout with DDEV, CircleCI → Pantheon deploys, code-quality
gates, and Quicksilver hooks.

## ⚠️ Irreversible Side Effects

Creates a private GitHub repo in the `kanopi/` org, configures branch protection/teams,
makes code changes across many files, adds Composer dependencies, and may create Kanopi
private Composer packages for premium plugins. Pauses for explicit confirmation before each
destructive phase.

## Target Architecture

- **Composer-managed** WordPress — core from `johnpbloch/wordpress-core`, contributed
  plugins/themes from [WPackagist](https://wpackagist.org); core and contrib are gitignored,
  only custom code is committed.
- **Web root `web/`**, DDEV (`type: wordpress`, Pantheon provider, `db-refresh`, image proxy).
- **CircleCI → Pantheon** via Kanopi orbs (`kanopi/ci-tools`, `kanopi/cms-updates`):
  `compile-theme` → `pantheon-deploy` (multidev on PRs, dev on `main`), `static-tests`
  (PHPCS/Rector/PHPStan), and Lighthouse/pa11y/BackstopJS gates, plus scheduled "update dev"
  and "automatic updates" pipelines.
- **`pantheon.yml`** with `web_docroot`, `enforce_https`, protected paths, and Quicksilver
  workflows (search-replace, WP-CFM config import, New Relic logging, post-deploy).
- **Premium plugins** sourced via Composer — vendor endpoint, existing Kanopi package, or a
  new private package.

## How It Works

The skill fetches reference files from
[`kanopi/wp-pantheon-starter`](https://github.com/kanopi/wp-pantheon-starter) and works
through confirmation-gated phases:

### Phase 1 — Git & GitHub Setup

Clone the site, create the private `kanopi/` repo, set remotes (`pantheon` + `origin`),
branch protection, team access, and CODEOWNERS.

### Phase 2 — Composerize WordPress

Author `composer.json` (core installer, WPackagist + Kanopi Packagist + vendor repos,
installer paths, vendor-dir), inventory existing plugins/themes into `wpackagist-*`
requirements, add quality tooling and Composer scripts, write `.gitignore`, and preserve the
existing DB table prefix and `wp-config.php` env detection.

### Phase 3 — DDEV Local Environment

Add `.ddev/config.yaml`, the Pantheon provider, a `db-refresh` command, and the uploads
image proxy.

### Phase 4 — Pantheon Config & Quicksilver

Add `pantheon.yml` and `web/private/scripts/` Quicksilver hooks. Only enable Redis/object
cache if the Pantheon plan supports it.

### Phase 5 — Premium Plugins

For each premium/committed plugin: require a vendor endpoint, require an existing Kanopi
package, or **invoke [`wp-plugin-to-private-package`](wp-private-package.md)** to publish a
new private package. This is the integration point — `wp-devops-setup` finds the premium
plugins; `wp-plugin-to-private-package` packages each one.

### Phase 6 — Theme Build & CircleCI Pipeline

Add the theme build tooling (`.nvmrc`, compiled CSS gitignored) and `.circleci/config.yml`
with the project anchors (`PANTHEON_UUID`, `TERMINUS_SITE`, `THEME_PATH`, `SLACK_HOOK`),
deploy scripts, static-tests, PR gates, and scheduled pipelines.

### Phase 7 — Docs & PR

Write `README.md` and `CLAUDE.md`, push the branch, and open a PR with a verification
checklist.

## Manual Follow-Up Tasks

1. **CircleCI context (`kanopi-code`)** — `TERMINUS_TOKEN`, `ACF_CLIENT_USER` /
   `ACF_CLIENT_PASSWORD` (if ACF), `GITHUB_TOKEN`.
2. **Slack webhook** — replace the `SLACK_HOOK` anchor in `.circleci/config.yml`.
3. **CircleCI SSH key** — add a deploy key to Pantheon.
4. **Scheduled pipelines** — create "update dev" and "automatic updates" in CircleCI.
5. **First multidev** — open a test PR and confirm the build, theme compile, and PR comments.

## Prerequisites

- **GitHub CLI** (`gh auth status`) with `kanopi` org write access
- **Terminus** authenticated to Pantheon + the site name/UUID
- **DDEV** and **Composer** installed
- Pantheon `TERMINUS_MACHINE_TOKEN` and the ACF Pro license (if used) from 1Password

## Related Skills

- **[`/wp-plugin-to-private-package`](wp-private-package.md)** — Package premium plugins (Phase 5)
- **[`/devops-setup`](devops.md)** — The Drupal/Pantheon equivalent
- **[`/pr-create`](pr-workflow.md)** — Open follow-up PRs
- **[`/quality-audit`](code-quality.md)** / **[`/security-audit`](security.md)** — Audit after onboarding
