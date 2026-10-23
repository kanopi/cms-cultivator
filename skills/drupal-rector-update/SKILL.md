---
name: drupal-rector-update
description: "Migrate a Drupal project's Rector configuration to the modern Composer-based sets approach (Rector 2.5–2.6.4 with palantirnet/drupal-rector 1.x), where set selection is driven automatically by the installed drupal/core version instead of a hand-maintained list. Use whenever someone wants to set up, update, modernize, or fix Rector on a Drupal site, mentions rector.php, DrupalSetProvider, withComposerBased, composer-based sets, or automatic version selection for Rector, or says things like 'update rector', 'get rector onto the new approach', 'stop maintaining rector set lists', or 'add rector to this Drupal site'. Has side effects: edits composer.json and rector.php and can rewrite custom module/theme code. Migrates Rector configuration only — running an existing Rector setup (rector-check, rector-fix, a failing Rector check) belongs to code-standards-checker."
---

# Drupal Rector — Composer-based sets

Move a Drupal project from hand-maintained Rector set lists to the Composer-based sets introduced in Rector 2.5 and `palantirnet/drupal-rector` 1.0. Instead of importing `Drupal10SetList`/`Drupal11SetList` and editing the list every time core moves, the config registers a set *provider* and tells Rector to pick sets from what is actually installed. Upgrade core, run Rector, done — the config never changes again.

> **Rector is capped at `<2.6.5` for now.** Rector 2.6.5 disabled `withSetProviders()` and made `drupal: true` load `DrupalRector\Set\DrupalSetList::COMPOSER_BASED` instead — a constant no `palantirnet/drupal-rector` release ships yet ([palantirnet/drupal-rector#419](https://github.com/palantirnet/drupal-rector/pull/419) adds it). On 2.6.5+ this config loads **no Drupal rules, with no error**. Lift the cap, and switch the config to the new set, once a drupal-rector release includes `DrupalSetList::COMPOSER_BASED`.

## ⚠️ Side effects

- **Edits `composer.json` / `composer.lock`** (adds/updates `palantirnet/drupal-rector`, constrains `rector/rector` to `>=2.5.0 <2.6.5`).
- **May upgrade PHPStan to 2.x** (`phpstan/phpstan`, `mglaman/phpstan-drupal`, and companions) when an older version is present, since every Rector 2.x requires it. This can regenerate the PHPStan baseline and surface new analysis errors — always flagged and confirmed with the user first, never silent.
- **Rewrites `rector.php`** in the project root.
- **`rector process` rewrites source files** in your custom modules/themes. Only run it on a clean git working tree so every change is reviewable and reversible.

Confirm with the user before any `composer require` / `composer update` in steps 3-4, before applying (not dry-running) Rector, and before committing.

### Approval gate

Before the first Composer change (step 3, or step 4 when PHPStan is already 2.x), present the plan under this header and stop until the user replies:

```
=== RECTOR MIGRATION READY FOR APPROVAL ===

## Composer changes
<packages to require/update, with from → to versions; PHPStan 1 → 2 flagged here>

## rector.php
<create from template, or the replacements and preserved customizations>

## Next
Dry-run `rector process --dry-run` and show the diff before anything is applied.

===================================

Reply "approve" to make the Composer changes and write rector.php, or provide your edits.
```

Applying Rector (step 7) needs a second, separate go-ahead after the dry-run diff has been shown.

| Pressure / rationalization | Correct behavior |
|---|---|
| "The user said just apply it — skip the dry-run" | Present the approval header and wait. The dry-run is the review; `rector process` without `--dry-run` only runs after the user has seen its diff. |
| "PHPStan 1 → 2 is a required step, so the upgrade doesn't need asking" | It rewrites `composer.lock` across the dev tree and stales the baseline. It goes in the approval block like every other Composer change. |
| "The tree is only a little dirty — carry on" | Stop at step 2. A dirty tree makes Rector's rewrites unreviewable. |

## What changes

**Before** — every minor hand-listed, and stale the moment core moves:
```php
$rectorConfig->sets([
  Drupal10SetList::DRUPAL_10,
  Drupal11SetList::DRUPAL_11,
]);
```

**After** — a provider plus one composer-based toggle, version-agnostic:
```php
->withSetProviders(DrupalSetProvider::class)
->withComposerBased(twig: true, phpunit: true, symfony: true, drupal: true)
```

Rector reads installed `drupal/core` and loads every set up to and including that minor (11.4 → the 11.0–11.4 rules). Same mechanism it already uses for Symfony, Doctrine, Twig, and PHPUnit. The opt-in *breaking* rename sets (`Drupal11SetList::DRUPAL_11x_BREAKING`) are **not** loaded: since drupal-rector 1.1.2 the provider keeps them in a separate `drupal (breaking)` group that `drupal: true` does not select. Add them explicitly with `withSets()` only once the code no longer has to run on an older minor.

This is the **backward-compatibility-safe** setup: it fixes what is deprecated on *your* installed core. Looking ahead to the next major before upgrading is a different job — keep the explicit `Drupal{N}SetList` + `setDrupalVersion()` for that.

## Workflow

Run through these in order. Prefer editing over regenerating: keep the customizations the project already has.

### 1. Detect the environment

- **Document root** — check `composer.json` `extra.installer-paths`, or look for `web/` vs `docroot/`. This decides the `withPaths()` entries. (Drupal Rector auto-finds the docroot for *set selection* via `webflo/drupal-finder`, but `withPaths()` still needs the correct custom-code paths.)
- **Custom code paths** — confirm `<docroot>/modules/custom` and `<docroot>/themes/custom` exist; include only paths that exist.
- **DDEV** — if a `.ddev/` directory exists, run every `composer` and `vendor/bin/rector` command through `ddev` (e.g. `ddev composer …`, `ddev exec vendor/bin/rector …`). Otherwise run them directly. All commands below are shown bare — prefix with `ddev exec` / `ddev` when DDEV is present.
- **Existing Rector** — read any existing `rector.php` and note what to preserve (see step 5). Check the current package: `composer show palantirnet/drupal-rector 2>/dev/null` and `composer show rector/rector 2>/dev/null`.
- **Drupal version** — `composer show drupal/core --format=json` (or read `composer.lock`). Composer-based Drupal sets need a project on Drupal 10+.
- **PHPStan version** — `composer show phpstan/phpstan 2>/dev/null | grep versions` and `composer show mglaman/phpstan-drupal 2>/dev/null | grep versions`. Every Rector 2.x depends on **PHPStan 2**, so a project still on PHPStan 1.x (usually one still on Rector 1.x) must be upgraded first (step 3).

### 2. Ensure a clean, recoverable state

```bash
git status --porcelain
```
If the tree is dirty, stop and tell the user, starting with the line `WORKING TREE NOT CLEAN — commit or stash before continuing.` Do not run any Composer or Rector command until they have. Rector edits code in place; a clean tree is the undo button.

### 3. Bring PHPStan up to 2.x (required, and flag it)

Rector 2.x — including the 2.5–2.6.4 range step 4 installs — runs on **PHPStan 2**. A project still on PHPStan 1.x is the single most common reason the install in step 4 conflicts. The fix is to move PHPStan forward, not to sidestep it — so include the upgrade in the approval block when an older version is present, **tell the user plainly what it implies**, and run it only after they approve.

If the installed `phpstan/phpstan` is 2.x already, skip this step. If it is 1.x (or `mglaman/phpstan-drupal` is 1.x), **surface a clear flag in the approval block**, e.g.:

> ⚠️ PHPStan 1.x detected. Rector 2.x (which drupal-rector 1.x needs) requires PHPStan 2, so I'll upgrade `phpstan/phpstan` and the Drupal PHPStan extensions to 2.x once you approve. This regenerates your PHPStan baseline and can surface new static-analysis errors that were previously suppressed — review the PHPStan run before committing.

After approval, upgrade the whole PHPStan family together (only the packages the project actually has — `mglaman/phpstan-drupal` only if step 1 found it):

```bash
if composer show mglaman/phpstan-drupal >/dev/null 2>&1; then
  composer require --dev --with-all-dependencies "phpstan/phpstan:^2" "mglaman/phpstan-drupal:^2"
else
  composer require --dev --with-all-dependencies "phpstan/phpstan:^2"
fi

# Pull companions up too, if present, so the versions stay consistent.
companions=""
for pkg in phpstan/extension-installer phpstan/phpstan-deprecation-rules phpstan/phpstan-phpunit; do
  composer show "$pkg" >/dev/null 2>&1 && companions="$companions $pkg"
done
if [ -n "$companions" ]; then
  composer update --with-all-dependencies $companions || {
    echo "Companion PHPStan packages failed to update. Stop and show the Composer output above to the user."
    exit 1
  }
fi
```

`mglaman/phpstan-drupal` 2.x supports Drupal 10 and up, so this is safe on current sites. Two things to do after:

- **Regenerate the baseline** if the project keeps one (`phpstan-baseline.neon`): `vendor/bin/phpstan analyse --generate-baseline`. The v1→v2 rule changes mean the old baseline will be stale.
- **Run PHPStan once** (`vendor/bin/phpstan analyse` or the project's lint script) and report new errors to the user. Don't fix them silently as part of the Rector work — they're a separate concern; just flag them.

**If Composer refuses the upgrade** (typical cause: `drupal/core-dev` on an older Drupal 10 pinning PHPStan 1), do **not** force it. Stop and flag it clearly: PHPStan must reach 2.x before the new Rector setup can install, and this project has a blocker that needs a human decision (raise the Drupal 10 dev-dependency floor, or use the standalone-runner recipe at `vendor/palantirnet/drupal-rector/docs/running-against-drupal-10.md`). Surface the exact Composer conflict message so the user can act on it.

### 4. Require the package (and verify what resolved)

`palantirnet/drupal-rector` 1.0.0 shipped as a **stable** release on 2 July 2026 (with the composer-based sets), and patch releases have followed. So its constraint is simply `^1.0` — no stability flag needed. Do **not** pin `@beta`; that's leftover from the pre-release window and would hold the package back.

Require Rector explicitly in the same command. drupal-rector only asks for `rector/rector: ^2`, so on its own it neither lifts a project stuck on Rector 2.0–2.4 (where `withComposerBased(drupal:)` is a fatal unknown parameter) nor stops a fresh install landing on 2.6.5+ (where the config silently loads nothing — see the cap note at the top):

```bash
composer require --dev --with-all-dependencies \
  "palantirnet/drupal-rector:^1.0" "rector/rector:>=2.5.0 <2.6.5"
```

The cap is written into `composer.json`, so a later `composer update` cannot drift past it. Tell the user it is there and why, so nobody lifts it before drupal-rector ships `DrupalSetList::COMPOSER_BASED`.

Then verify what actually resolved. Run the check **in the same context as the install** (i.e. through `ddev exec` if you installed via DDEV) so it inspects the real `vendor/`. Ask the autoloader, not the filesystem — it's authoritative regardless of where the class file lives:

```bash
# Provider class present? (authoritative — uses the real autoloader)
php -r "require 'vendor/autoload.php'; echo class_exists('DrupalRector\\\\Set\\\\DrupalSetProvider') ? \"provider: OK\n\" : \"provider: MISSING\n\";"

# What resolved? Rector must be 2.5.0–2.6.4.
composer show palantirnet/drupal-rector | grep -E "^versions"
composer show rector/rector | grep -E "^versions"
```

`provider: OK` plus Rector in 2.5.0–2.6.4 means the install is right. Anything else, stop and show the user the resolved versions. If the require fails to resolve, the cause is almost always the PHPStan 1 pin that step 3 handles — re-check that step. If a conflict still remains, surface the exact Composer message: it's typically another dev dependency (e.g. `drupal/core-dev`) pinning an incompatible Rector/PHPStan. Don't force or downgrade around it; flag the specific blocker for a human decision, and note the standalone-runner fallback at `vendor/palantirnet/drupal-rector/docs/running-against-drupal-10.md`.

> Confirm from the *resolved* versions, not from a version string in a blog post or this skill — the package is moving quickly (patch releases within days of 1.0.0).

### 5. Write `rector.php` — preserving customizations

If there is **no** `rector.php`, drop in the template at `assets/rector.php` and fix the docroot (`web` → `docroot`) and custom paths for this project.

If one **already exists**, edit it to the new approach while carrying over everything project-specific:

**Replace** (this is the whole point):
- Manual Drupal set imports/usage — `Drupal8SetList` / `Drupal9SetList` / `Drupal10SetList` / `Drupal11SetList`, and any `->sets([...])` / `$rectorConfig->import(...)` that lists Drupal sets.

  → with `->withSetProviders(DrupalSetProvider::class)` and `->withComposerBased(…, drupal: true)`.

**Preserve** verbatim (migrate into the new config, don't drop):
- `withPaths()` targets (custom module/theme paths).
- `withSkip()` entries and any `$rectorConfig->skip([...])`.
- Individual `ruleWithConfiguration(...)` / `rule(...)` registrations the team added.
- `DrupalRectorSettings` singleton (BC wrapping, `setMinimumCoreVersionSupported()`) — see the note in `assets/rector.php`. Default is BC **disabled**, which is right for site projects; contrib modules may want it on. The builder API gives no `$rectorConfig` to call `->singleton()` on, so carry an existing registration over the way `vendor/palantirnet/drupal-rector/README.md` documents for the installed release — don't paste the old closure-style call into the builder chain.
- PHP version handling (`withPhpSets()` / `SetList::PHP_*`) and any non-Drupal `withSets()`.
- File header/license comments.

**Do not add** `HookConvertRector` here — see the gotcha below.

Fold the framework toggles (`twig`, `phpunit`, `symfony`) into `withComposerBased()` alongside `drupal` unless the user wants only Drupal.

### 6. Confirm Drupal rules loaded, then dry-run

A config that loads no Drupal rules still runs cleanly and reports nothing to change, which reads as success. Check the loaded rules before trusting an empty diff:

```bash
vendor/bin/rector list-rules --output-format=json \
  | jq '[.rectors[] | select(startswith("DrupalRector\\"))] | length'
```

Zero means the composer-based sets did not load — check the resolved Rector version against the cap and the `withSetProviders()` / `withComposerBased(drupal: true)` lines before going further. Never report "no deprecations found" from a run that loaded no Drupal rules.

```bash
vendor/bin/rector process --dry-run
```

Summarize the diff for the user: which files, roughly what kinds of transforms. Flag anything that looks wrong — Drupal Rector is thorough but has known rough edges around `use` statement placement and doc-comment whitespace, and it prefers static `\Drupal::service()` rewrites over dependency injection. It's automated source rewriting, so reviewing the diff is the job, not a formality.

### 7. Apply (only after the user says go)

```bash
vendor/bin/rector process
```

Then let coding-standards tooling clean up formatting Rector may have disturbed (e.g. `phpcbf`, or the project's `composer` lint-fix script), and confirm the site still boots / tests pass.

### 8. Commit

Suggest a focused commit — config change and generated code changes separated if the team prefers:
```bash
git add composer.json composer.lock rector.php
git commit -m "Move Rector to Composer-based Drupal sets"
```
Follow the project's conventions (see the commit-message-generator skill if one is wanted).

## Gotchas

- **Hook conversion is a separate pass.** `HookConvertRector` (procedural hooks → `#[Hook]` classes) must never share a config with the deprecation sets — Rector 2.x can't re-process the new file it writes, so deprecated calls inside a moved hook body would be copied over unfixed. Run deprecations first, then, only if the user wants OOP hooks, a second pass:
  ```bash
  vendor/bin/rector process web/modules/custom/MODULE \
    --config=vendor/palantirnet/drupal-rector/rector-hook-convert.php
  ```
- **Rector cap: `>=2.5.0 <2.6.5`.** 2.6.5 turned `withSetProviders()` into a no-op and moved `drupal: true` to a drupal-rector constant that has not shipped. Lift the cap only when a drupal-rector release includes `DrupalSetList::COMPOSER_BASED`, and update this skill and `assets/rector.php` to the new set at the same time.
- **PHPStan must be 2.x.** Every Rector 2.x needs PHPStan 2, so step 3 proposes upgrading the PHPStan family when it finds 1.x — and gates it behind approval, because the jump regenerates the baseline and can surface new analysis errors. Those errors are a separate task from the Rector work; report them, don't quietly fix or suppress them. Only if Composer can't complete the upgrade (e.g. `drupal/core-dev` pinning PHPStan 1 on older Drupal 10) do you stop and hand the blocker back to the user.
- **Constraint: `^1.0`.** 1.0.0 is stable (shipped 2 July 2026 with the composer-based sets), so `^1.0` resolves to the newest stable 1.x — no `@beta` or stability flags. Pair it with the Rector cap above. Verify via the autoloader (`class_exists(...)`), not a guessed file path, and run the check in the same context (DDEV) as the install.
- **BC-safe vs look-ahead.** Composer-based sets fix your *installed* core. They are not the tool for pre-upgrade prep to the next major; that stays explicit `Drupal{N}SetList` + `setDrupalVersion()`.
- **Point at custom code only.** Never let `withPaths()` include contrib or core.
- **Drupal 8/9 sites.** The composer-based flow targets 10+. Legacy sites can still use the classic manual set lists, but the better move is getting current.

## Files

- `assets/rector.php` — annotated starting config for the Composer-based approach. Copy in for a fresh setup; use as the reference shape when editing an existing config.
