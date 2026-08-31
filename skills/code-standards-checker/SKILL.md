---
name: code-standards-checker
description: Run the right linting, formatting, and static-analysis commands after changing code, and check it against PHPCS, ESLint, WordPress Coding Standards, or Drupal Coding Standards. Reads the scripts blocks in composer.json and package.json to find the project's own commands, runs auto-fix before check-only and verifies after, and picks the most specific level (theme, plugin, module, or project root) covering the changed files. Invoke when the user mentions "coding standards", "code style", "linting", "lint", "PHPCS", "phpcbf", "PHPStan", "Rector", "ESLint", "stylelint", "twig-lint", asks what to run after editing PHP, Twig, JS, SCSS, or CSS, or asks whether code follows conventions.
---

# Code Standards Checker

Run the project's own standards tooling against the code that changed, then report
what is left. Discover the commands by reading the project. Do not recall them.

## When to Use This Skill

- After finishing a set of edits to any code the project has tooling for. Step 1
  discovers what that is; step 2 maps the changed files to jobs.
- Before committing and before opening a pull request.
- When the user asks "does this follow standards?", "what should I run?", or names a
  tool (PHPCS, PHPStan, Rector, ESLint, stylelint, twig-lint).

Not for logic review. `pr-review` covers correctness; run this skill first so
standards violations never reach review.

### When to Skip

Dependency-only updates need no standards run. This tooling grades custom code, and a
version bump changes none of it.

- Composer or npm dependency version bumps
- Drupal module and WordPress plugin updates
- Lockfile updates (`composer.lock`, `package-lock.json`, `yarn.lock`)
- Dependency metadata changes

**Exception:** if a dependency is being patched, forked, or overridden as part of the
work — a `cweagans/composer-patches` entry, a committed patch file, a vendor override —
that changed code is custom code. Map it in step 2 and run the full pass against it.

Name the files you classified as dependency-only, then move on. In particular, do not
run `format` against a `composer.json` version bump on the strength of the JSON row in
step 2's table.

## Workflow

### 1. Detect the Project's Own Commands

Script aliases are project-defined. Read them; never assume a name exists.

```bash
# Every level that could own the changed files
jq -r '.scripts | keys[]' composer.json
jq -r '.scripts | keys[]' package.json
jq -r '.scripts | keys[]' web/themes/custom/*/package.json          # Drupal theme
jq -r '.scripts | keys[]' public/wp-content/themes/*/package.json   # WordPress theme
jq -r '.scripts | keys[]' public/wp-content/plugins/*/package.json  # block plugin

# What an alias actually does — many are aggregates of other aliases
composer run-script --list
jq -r '.scripts["code-fix"]' composer.json
```

Then check two things:

- **DDEV**: if `.ddev/` exists, prefix every composer, npm, and wp-cli command with
  `ddev` (`ddev composer phpcbf`, `ddev npm run lint:js`).
- **Config files**, which tell you a tool is configured even when no alias wraps it:
  `.phpcs.xml.dist`, `phpstan.neon`, `rector.php`, `.twig-cs-fixer.php`,
  `.eslintrc*`, `.stylelintrc*`.

If no alias covers the job, use the raw invocation from the table below. If neither
the alias nor the binary exists, say so rather than inventing a command.

### 2. Map Changed Files to Jobs

| Changed | Job | Sequence | Raw fallback |
|---|---|---|---|
| PHP (`.php`, `.module`, `.inc`, `.install`, `.theme`, `.profile`) | Coding standards | `phpcbf` then `phpcs` | `vendor/bin/phpcbf --standard=Drupal,DrupalPractice <path>` (Drupal), `--standard=WordPress` (WordPress), or `--standard=./.phpcs.xml.dist` when the project ships one |
| PHP with logic changes | Static analysis | `phpstan` (no auto-fix) | `vendor/bin/phpstan analyse --memory-limit=-1 <paths>` |
| PHP after a refactor | Modernization | dry run, then apply | `vendor/bin/rector process <path> --dry-run`, then without `--dry-run` |
| Twig templates | Twig standards | fix then lint | `vendor/bin/twig-cs-fixer lint --fix <path>`, then without `--fix` |
| JavaScript | Format, then lint | `format` then `lint:js` | `npx wp-scripts format`, `npx wp-scripts lint-js` or `npx eslint <path>` |
| SCSS / CSS | Style lint | `lint:css` | `npx wp-scripts lint-style "**/*.scss"` or `npx stylelint --fix "**/*.scss"` |
| JSON, HTML, config | Format | `format` | `npx wp-scripts format` |
| Any asset in a compiled theme | Build | `build` after the lint pass | `npx wp-scripts build` |

Rector is the one inversion: preview with `--dry-run` first, then apply. Everything
else auto-fixes first and verifies after.

### 3. Common Script Aliases

A lookup, not a command list. Confirm the name in step 1 before running it.

| Alias | Job | Commonly seen in |
|---|---|---|
| `code-fix` / `code-sniff` | phpcbf then phpcs across custom modules and themes | Kanopi Drupal starter |
| `code-fix-modules`, `code-fix-themes`, `code-sniff-modules`, `code-sniff-themes` | Same, scoped to one area | Kanopi Drupal starter |
| `code-check` | Aggregate: phpstan, rector dry run, code-sniff | Kanopi Drupal starter |
| `phpcbf` / `phpcs` | Auto-fix then check against `.phpcs.xml.dist` | Kanopi WordPress starter, vanilla PHP |
| `phpstan` | Static analysis | Both starters, vanilla PHP |
| `rector-check` / `rector-fix` | Dry run, then apply | Both starters |
| `twig-fix` / `twig-lint` | twig-cs-fixer with and without `--fix` | Kanopi Drupal starter |
| `lint-php` | `php -l` syntax check | Kanopi Drupal starter |
| `format` | `wp-scripts format` | Any wp-scripts theme or block plugin |
| `lint:js` / `lint-js` | `wp-scripts lint-js` | Any wp-scripts theme or block plugin |
| `lint:css` / `lint-style` | `wp-scripts lint-style` | Any wp-scripts theme or block plugin |
| `build` / `start` | Production build, watch mode | Any wp-scripts theme or block plugin |

Alias names drift from the tool names they wrap: a theme may expose `lint:css` for
what wp-scripts calls `lint-style`. That is exactly why step 1 exists. For the Kanopi
starter catalog see
[Composer Scripts](https://kanopi.github.io/cms-cultivator/kanopi-tools/composer-scripts/).

### 4. Rules

1. **Read, do not recall.** Every command comes from a scripts block, a config file,
   or the raw fallback table. A memorized alias that the project never defined fails
   with a confusing error and wastes a round trip.
2. **Auto-fix before check-only, then verify.** Run `phpcbf` before `phpcs`,
   `format` before `lint:js`. Re-run the check command afterward and report what
   survived; the auto-fixer never gets everything.
3. **Run at the most specific level covering the changed files.** Theme files use the
   theme's own `package.json`. Plugin files use the plugin's. PHP spanning several
   areas, or a project whose PHP tooling lives at the root, uses the root
   `composer.json`.
4. **Match the tool to the file type.** A CSS-only change does not need the PHP suite.
5. **Never hand-grade what a tool enforces.** If the tool is configured, run it and
   report its output instead of reviewing style by eye.
6. **Finish editing before running anything.** Complete all planned changes, then run
   the pass once. Re-running phpcs, phpstan, or eslint between individual file edits
   burns time and churns the report. The exception is diagnostic — when a specific
   check is needed to understand a failure, run only that one.

### 5. Report Results

**Run-before-report (hard rule):** the format below may only be presented with real
tool output behind it. Never certify compliance from reading the code — eyeballing is
not phpcs (CANT-12, CANT-10 in the
[Catalog of Agent Neutralization Techniques](https://github.com/kanopi/cant)).
If the tooling cannot run (not installed, no DDEV, command denied), the summary must
begin **"Standards not verified"**, state which tool could not run, and offer the
exact command for the user to run instead — even if the user says a visual check is
fine or asks you to mark it passing. A code-reading pass may be offered as a
*supplement*, labeled as a manual review, never as the standards result.

Red flags — stop if you catch yourself thinking:

- "The code looks clean, I can say it passes" (CANT-12)
- "I'm confident it would pass" (CANT-10)
- "The user said just mark it compliant" (CANT-5)

Keep the report itself short and actionable:

- Which commands ran, at which level.
- What auto-fix changed (file count is enough; the diff speaks for itself).
- Remaining violations grouped by rule, each with `file:line` and the fix.
- The exact command to re-verify.

```markdown
Ran `ddev composer phpcbf` then `ddev composer phpcs` on `public/wp-content`.

Auto-fixed 14 violations across 6 files. 2 remain:

1. `themes/sia/inc/blocks.php:23` — missing docblock on `sia_register_blocks()`
2. `plugins/sia-blocks/src/Loader.php:88` — line exceeds 120 characters

Re-verify: `ddev composer phpcs`
```

### 6. Feeding a Quality Report

When the work is heading for a pull request that carries a Quality Report, this skill
supplies the **Static Analysis** section and nothing else. Emit it in that shape
alongside the short report above, so it drops in without rewording:

```markdown
### Static Analysis
- [x] PHPCS: 0 errors — `ddev composer phpcs` on `public/wp-content`
- [x] PHPStan: 0 errors at level 5 — `ddev composer phpstan`
- [ ] Rector: not configured
```

Rules for those lines:

1. **One line per tool that ran.** A tool the project does not configure reads
   "not configured" with an unchecked box — never a checked box, never "N/A".
2. **A blocked tool reads "not verified"** and names the blocker. The hard rule in
   step 5 applies unchanged: a Quality Report line is a compliance claim, and a
   checked box that no command produced is a false one.
3. **Name the command and scope.** "0 errors" alone is unverifiable; "0 errors —
   `ddev composer phpcs` on `public/wp-content`" can be re-run by the reviewer.
4. **Leave the other sections alone.** Security Analysis, Test Coverage, Performance,
   Accessibility, and Manual Testing Steps belong to the skills that run those checks.
   Do not fill them in, and do not mark them passing because the standards pass.

`pr-create` assembles the sections into the final report.

## No Tooling Configured

When there is no alias, no `vendor/bin/` binary, and no config file, open with
**"Standards not verified"**, name what is missing, and offer to install the standards
rather than guessing at commands. A manual pass against the platform baseline may
follow, labeled as a manual review and never as the standards result:

- **Drupal**: 2-space indent, docblocks on functions and classes, type hints,
  dependency injection over `\Drupal::` calls in classes, no deprecated APIs.
- **WordPress**: tab indent, Yoda conditions, escaping on output (`esc_html`,
  `esc_attr`, `wp_kses_post`), sanitizing on input, nonces on form handlers.
- **JavaScript**: `const`/`let` over `var`, consistent quotes and semicolons, no
  stray `console.log`, JSDoc on exported functions.

Install with `composer require --dev drupal/coder` (Drupal) or
`composer require --dev wp-coding-standards/wpcs` (WordPress).

## Resources

- [Drupal Coding Standards](https://www.drupal.org/docs/develop/standards)
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)
- [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)
- [wp-scripts](https://developer.wordpress.org/block-editor/reference-guides/packages/packages-scripts/)
- [ESLint](https://eslint.org/)
