# DDEV Commands

Kanopi's DDEV add-ons ship custom commands for project setup, databases,
theme builds, and testing.

!!! note "This page is a snapshot"
    Generated 2026-08-14 from the command headers in
    [ddev-kanopi-drupal](https://github.com/kanopi/ddev-kanopi-drupal) and
    [ddev-kanopi-wp](https://github.com/kanopi/ddev-kanopi-wp). Individual sites add
    and override commands, so **`ddev help` in the project is the live source** —
    trust it over this page. The `ddev-workflow` skill reads the project rather than
    this list.

Commands in `.ddev/commands/host/` run on your machine; those in
`.ddev/commands/web/` run inside the web container. `ddev <command>` dispatches to
the right side on its own.

## Host commands

| Command | Aliases | Platform | Description |
|---|---|---|---|
| `ddev cypress-install` | `cypress:install`, `cyi`, `install-cypress` | Both | Install the node packages for cypress on the developers local machine |
| `ddev cypress-run` | `cy`, `cypress`, `cypress-run`, `cyr` | Both | Run Cypress Commands |
| `ddev cypress-users` | `cypress:users`, `cyu` | Both | Create Cypress users |
| `ddev db-rebuild` | `db:rebuild`, `rebuild`, `dbreb` | Both | Runs composer install and database refresh. |
| `ddev drupal-uli` | `drupal:uli`, `uli` | Drupal | Logs you in to Drupal. |
| `ddev pantheon-terminus` | `pantheon:terminus`, `terminus` | Both | — |
| `ddev pantheon-testenv` | `pantheon:testenv`, `testenv` | Both | Initialize stack and testing environment in DDEV. |
| `ddev playwright-install` | `playwright:install`, `pwi` | Both | Install Playwright and browsers for e2e testing |
| `ddev playwright-run` | `playwright:run`, `pwr` | Both | Run Playwright e2e tests |
| `ddev playwright-users` | `playwright:users`, `pwu` | Both | **Drupal:** Create Playwright test users in Drupal · **WordPress:** Create Playwright test users in WordPress |
| `ddev project-auth` | `project:auth` | WordPress | Authorizes you into DDEV. |
| `ddev project-configure` | `configure`, `project:configure`, `prc` | Both | **Drupal:** Interactive configuration wizard for Kanopi Drupal DDEV · **WordPress:** Interactive configuration wizard for Kanopi WordPress DDEV |
| `ddev project-init` | `project:init`, `init` | Both | **Drupal:** Initialize local development. · **WordPress:** Initialize local WordPress development environment. |
| `ddev project-lefthook` | `project:lefthook` | Both | Initialize Lefthook. |
| `ddev project-nvm` | `project:nvm` | Drupal | Initializes NVM. |
| `ddev project-wp` | `project:wp` | WordPress | Install & WordPress if needed. |
| `ddev wp-open` | `open`, `wp:open` | WordPress | Open the site or admin in your default browser using ddev launch |

## Web container commands

| Command | Aliases | Platform | Description |
|---|---|---|---|
| `ddev critical-install` | `critical:install`, `install-critical-tools`, `cri` | Both | Initialize/reinstall tools needed for critical CSS. |
| `ddev critical-run` | `critical:run`, `critical`, `crr` | Both | Run Critical CSS Commands |
| `ddev db-prep-migrate` | `db:prep-migrate`, `migrate-prep-db` | Both | Create and configure the migration database inside the DDEV web container |
| `ddev db-refresh` | `db:refresh`, `refresh` | Both | **Drupal:** Downloads the database from the hosting provider. Supports both Pantheon and Acquia platforms. · **WordPress:** Downloads the database from the hosting provider. Supports Pantheon, WPEngine, Kinsta, and Remote SSH platforms. |
| `ddev drupal-open` | `drupal:open`, `open` | Drupal | Open the site or admin in your default browser |
| `ddev pantheon-tickle` | `pantheon:tickle`, `tickle` | Both | Continuously wake up a Pantheon environment. |
| `ddev recipe-apply` | `recipe:apply`, `recipe`, `ra` | Drupal | Apply a Drupal Recipe. |
| `ddev recipe-unpack` | `recipe:unpack`, `ru` | Drupal | Unpack a recipe package that's already required in your project |
| `ddev recipe-uuid-rm` | `recipe:uuid-rm`, `uuid-rm` | Drupal | Remove UUIDs and _core metadata from Drupal config files. |
| `ddev theme-activate` | `activate-theme`, `tha`, `theme:activate` | WordPress | — |
| `ddev theme-build` | `theme:build`, `production`, `thb`, `theme-production` | Both | Build production assets for the theme |
| `ddev theme-create-block` | `create-block`, `thcb`, `theme:create-block` | WordPress | Create a new WordPress block |
| `ddev theme-install` | `theme:install`, `install-theme-tools`, `thi` | Both | Install and set up theme development tools in DDEV |
| `ddev theme-npm` | `theme:npm` | Both | Runs NPM commands on the theme. |
| `ddev theme-npx` | `theme:npx` | Both | Runs NPX commands on the theme. |
| `ddev theme-watch` | `theme:watch`, `development`, `thw`, `theme-development` | Both | **Drupal:** Start theme development with file watching · **WordPress:** Run @wordpress/scripts in development mode for the theme |
| `ddev wp-restore-admin-user` | `restore-admin-user`, `wp:restore-admin-user` | WordPress | — |

## Related

- The `ddev-workflow` skill covers the lifecycle these commands sit in: what to run
  on a fresh clone, how to get a database, and how theme assets get built.
- [Kanopi Tools Overview](overview.md)
