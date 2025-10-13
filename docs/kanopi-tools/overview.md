# Kanopi-Specific Tools for CMS Cultivator

This document catalogs all Kanopi-specific composer scripts and DDEV commands that CMS Cultivator integrates with automatically.

## Where Do These Commands Come From?

These tools are provided by:

### DDEV Add-ons

Custom commands from Kanopi's DDEV add-ons:
* [ddev-kanopi-drupal](https://github.com/kanopi/ddev-kanopi-drupal)
* [ddev-kanopi-wp](https://github.com/kanopi/ddev-kanopi-wp)

### Composer Scripts

Defined in Kanopi's starter project `composer.json`:
- [Drupal Starter](https://github.com/kanopi/drupal-starter)
- [WordPress Struts Starter](https://github.com/kanopi/struts)

## How to Get These Commands

### Install DDEV Add-ons

**For Drupal projects:**
```bash
ddev add-on get kanopi/ddev-kanopi-drupal
ddev restart
```

**For WordPress projects:**
```bash
ddev add-on get kanopi/ddev-kanopi-wp
ddev restart
```

This gives you both the DDEV custom commands AND the Composer scripts.

### Copy Composer Scripts

If you need the Composer scripts:

- [Drupal starter composer.json](https://github.com/kanopi/drupal-starter/blob/main/composer.json)
- [WordPress Struts composer.json](https://github.com/kanopi/struts/blob/main/composer.json)


1. **View the starter's composer.json**:
2. **Copy the `scripts` section** to your project's `composer.json`
3. **Install dependencies** if needed (PHPStan, Rector, PHPCS, etc.)

---

## Composer Scripts

### WordPress (Struts) - Available via `ddev composer [script]`

#### Code Quality & Standards
- **`phpcs`** - Run PHP Code Sniffer on wp-content (Drupal/DrupalPractice standards)
- **`phpcbf`** - Auto-fix code standard violations in wp-content
- **`phpstan`** - Run PHPStan static analysis on custom themes
- **`phpstan-ci`** - PHPStan with JUnit output for CI (→ phpstan-report.xml)

#### Rector (PHP Modernization)
- **`rector-check`** - Check plugins AND themes for rector suggestions (dry-run)
- **`rector-check-ci`** - Rector check with JUnit output for CI
- **`rector-fix`** - Apply rector fixes to plugins AND themes
- **`rector-fix-plugins`** - Apply rector only to plugins
- **`rector-fix-themes`** - Apply rector only to themes
- **`rector-plugins`** - Check plugins only (dry-run)
- **`rector-plugins-ci`** - Plugins check with JUnit for CI
- **`rector-themes`** - Check themes only (dry-run)
- **`rector-themes-ci`** - Themes check with JUnit for CI

### Drupal - Available via `ddev composer [script]`

#### Code Quality & Standards
- **`code-check`** - Run ALL checks: phpstan + rector + code-sniff
- **`code-fix`** - Fix ALL: modules + themes + rector + lint-php
- **`code-fix-modules`** - Run phpcbf on custom modules
- **`code-fix-themes`** - Run phpcbf on custom themes
- **`code-sniff`** - Check modules AND themes with phpcs
- **`code-sniff-ci`** - phpcs with JUnit output for CI
- **`code-sniff-modules`** - phpcs on custom modules only
- **`code-sniff-modules-ci`** - Modules phpcs with JUnit for CI
- **`code-sniff-themes`** - phpcs on custom themes only
- **`code-sniff-themes-ci`** - Themes phpcs with JUnit for CI
- **`lint-php`** - PHP syntax check (php -l) on custom code
- **`phpstan`** - Run PHPStan on custom modules and themes
- **`phpstan-ci`** - PHPStan with JUnit output for CI (→ phpstan-report.xml)

#### Rector (PHP Modernization)
- **`rector-check`** - Check modules AND themes (dry-run)
- **`rector-check-ci`** - Rector check with JUnit for CI
- **`rector-fix`** - Apply rector fixes to modules AND themes
- **`rector-fix-modules`** - Apply rector only to modules
- **`rector-fix-themes`** - Apply rector only to themes
- **`rector-modules`** - Check modules only (dry-run)
- **`rector-modules-ci`** - Modules check with JUnit for CI
- **`rector-themes`** - Check themes only (dry-run)
- **`rector-themes-ci`** - Themes check with JUnit for CI

#### Twig Linting (Drupal-specific)
- **`twig-fix`** - Auto-fix twig files in modules AND themes
- **`twig-fix-modules`** - Fix twig in modules only
- **`twig-fix-themes`** - Fix twig in themes only
- **`twig-lint`** - Lint twig in modules AND themes
- **`twig-lint-modules`** - Lint twig in modules only
- **`twig-lint-themes`** - Lint twig in themes only
- **`twig-lint-ci`** - Twig lint with JUnit for CI
- **`twig-lint-modules-ci`** - Modules twig with JUnit for CI
- **`twig-lint-themes-ci`** - Themes twig with JUnit for CI

---

## DDEV Custom Commands

### WordPress Commands - Available via `ddev [command]`

#### Database
- **`db-refresh`** (web) - Refresh database from Pantheon
- **`db-prep-migrate`** (web) - Prepare database for migration
- **`db-rebuild`** (host) - Rebuild database from scratch

#### Theme Development
- **`theme-build`** (web) - Build production assets (aliases: production, theme:build, thb)
- **`theme-watch`** (web) - Watch and rebuild assets on changes (aliases: theme:watch, thw, watch)
- **`theme-install`** (web) - Install theme dependencies (aliases: theme:install, thi)
- **`theme-activate`** (web) - Activate the custom theme (aliases: theme:activate, tha)
- **`theme-npm`** (web) - Run npm commands in theme directory (aliases: theme:npm, thn)
- **`theme-npx`** (web) - Run npx commands in theme directory (aliases: theme:npx, thx)
- **`theme-create-block`** (web) - Create a new Gutenberg block (aliases: theme:create-block, tcb)

#### WordPress Management
- **`wp-restore-admin-user`** (web) - Restore admin user credentials (aliases: wp:restore-admin, wra)
- **`wp-open`** (host) - Open WordPress site in browser (aliases: wp:open, wpo)
- **`project-wp`** (host) - Open WP admin in browser (aliases: project:wp, pw)

#### Testing
- **`critical-install`** (web) - Install Critical testing dependencies (aliases: critical:install, ci)
- **`critical-run`** (web) - Run Critical tests (aliases: critical:run, cr)
- **`cypress-install`** (host) - Install Cypress dependencies (aliases: cypress:install, cyi)
- **`cypress-run`** (host) - Run Cypress tests (aliases: cypress:run, cyr)
- **`cypress-users`** (host) - Manage Cypress test users (aliases: cypress:users, cyu)

#### Project Setup
- **`project-init`** (host) - Initialize new project (aliases: project:init, pi)
- **`project-configure`** (host) - Configure project settings (aliases: project:configure, pc)
- **`project-auth`** (host) - Configure authentication (aliases: project:auth, pa)
- **`project-lefthook`** (host) - Set up git hooks with Lefthook (aliases: project:lefthook, pl)

#### Pantheon Integration
- **`pantheon-terminus`** (host) - Run Terminus commands (aliases: pantheon:terminus, pt)
- **`pantheon-testenv`** (host) - Manage test environments (aliases: pantheon:testenv, pte)
- **`pantheon-tickle`** (web) - Keep Pantheon environment awake (aliases: pantheon:tickle, ptk)

#### Utilities
- **`phpmyadmin`** (host) - Open phpMyAdmin (aliases: pma)

### Drupal Commands - Available via `ddev [command]`

#### Database
- **`db-refresh`** (web) - Refresh database from Pantheon (aliases: db:refresh, dbr)
- **`db-prep-migrate`** (web) - Prepare database for migration (aliases: db:prep-migrate, dpm)
- **`db-rebuild`** (host) - Rebuild database from scratch (aliases: db:rebuild, dbrb)

#### Theme Development
- **`theme-build`** (web) - Build production assets (aliases: production, theme:build, thb)
- **`theme-watch`** (web) - Watch and rebuild assets (aliases: theme:watch, thw, watch)
- **`theme-install`** (web) - Install theme dependencies (aliases: theme:install, thi)
- **`theme-npm`** (web) - Run npm in theme directory (aliases: theme:npm, thn)
- **`theme-npx`** (web) - Run npx in theme directory (aliases: theme:npx, thx)

#### Drupal Recipes (Drupal 11+)
- **`recipe-apply`** (web) - Apply a Drupal recipe (aliases: recipe:apply, recipe, ra)
- **`recipe-unpack`** (web) - Unpack a recipe for customization (aliases: recipe:unpack, ru)
- **`recipe-uuid-rm`** (web) - Remove UUIDs from config (aliases: recipe:uuid-rm, rur)

#### Drupal Management
- **`drupal-open`** (web) - Open Drupal site in browser (aliases: drupal:open, do)
- **`drupal-uli`** (host) - Generate one-time login link (aliases: drupal:uli, uli)

#### Testing
- **`critical-install`** (web) - Install Critical testing (aliases: critical:install, ci)
- **`critical-run`** (web) - Run Critical tests (aliases: critical:run, cr)
- **`cypress-install`** (host) - Install Cypress (aliases: cypress:install, cyi)
- **`cypress-run`** (host) - Run Cypress tests (aliases: cypress:run, cyr)
- **`cypress-users`** (host) - Manage Cypress users (aliases: cypress:users, cyu)

#### Project Setup
- **`project-init`** (host) - Initialize project (aliases: project:init, pi)
- **`project-configure`** (host) - Configure project (aliases: project:configure, pc)
- **`project-auth`** (host) - Configure auth (aliases: project:auth, pa)
- **`project-lefthook`** (host) - Set up git hooks (aliases: project:lefthook, pl)
- **`project-nvm`** (host) - Set up NVM (aliases: project:nvm, pn)

#### Pantheon Integration
- **`pantheon-terminus`** (host) - Run Terminus (aliases: pantheon:terminus, pt)
- **`pantheon-testenv`** (host) - Manage test envs (aliases: pantheon:testenv, pte)
- **`pantheon-tickle`** (web) - Keep env awake (aliases: pantheon:tickle, ptk)

#### Utilities
- **`phpmyadmin`** (host) - Open phpMyAdmin (aliases: pma)

---

## Usage in Slash Commands

### Composer Scripts
```bash
# WordPress
ddev composer phpcs
ddev composer phpcbf
ddev composer phpstan
ddev composer rector-check

# Drupal
ddev composer code-check
ddev composer code-fix
ddev composer twig-lint
ddev composer rector-fix
```

### DDEV Commands
```bash
# Theme builds
ddev theme-build
ddev theme-watch

# Database operations
ddev db-refresh
ddev db-rebuild

# Drupal recipes
ddev recipe-apply core/recipes/standard

# Testing
ddev cypress-run
ddev critical-run
```

### Combined Workflows
```bash
# Full quality check
ddev composer code-check  # Runs phpstan + rector + code-sniff
ddev composer twig-lint

# Fix everything
ddev composer code-fix    # Fixes modules + themes + rector + lint
ddev composer twig-fix
```

---

## CI-Specific Scripts

For CI/CD pipelines, use the `-ci` variants that output JUnit XML:

- `ddev composer phpstan-ci` → phpstan-report.xml
- `ddev composer rector-check-ci` → rector-*-report.xml
- `ddev composer code-sniff-ci` → phpcs-*-report.xml
- `ddev composer twig-lint-ci` → twig-*-report.xml

These are perfect for integration with GitHub Actions or GitLab CI.
