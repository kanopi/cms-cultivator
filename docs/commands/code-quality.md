# Code Quality Skills

Maintain coding standards and manage Composer dependency patches.

!!! note "What changed in 2.0"
    As of 2.0, CMS Cultivator focuses on CMS development workflows. The comprehensive quality-audit capability moved to a separate internal Kanopi library, alongside the other audit skills.

## Skills

- `code-standards-checker [standard]` — Check coding standards compliance (PHPCS, ESLint)
- `composer-patch-generator` — Generate CI-safe patches for Composer packages

## code-standards-checker Skill

Check coding standards compliance with PHPCS/ESLint for Drupal and WordPress projects.

```bash
/code-standards-checker          # Auto-detect standards
/code-standards-checker drupal   # Drupal coding standards
/code-standards-checker wordpress # WordPress coding standards
```

### How It Works

The skill discovers commands rather than assuming them. Script aliases are defined by
each project, so a memorized list goes stale — and recommending a command a project
never declared is a confusing failure.

1. **Detect** — read the `scripts` blocks in `composer.json` and `package.json` at the
   level that owns the changed files (theme, plugin, module, or project root), prefix
   with `ddev` when `.ddev/` exists, and check for config files (`.phpcs.xml.dist`,
   `phpstan.neon`, `rector.php`, `.eslintrc*`, `.stylelintrc*`) that reveal a
   configured tool with no alias wrapping it
2. **Map** — match the changed file type to a job: PHP to PHPCS, Twig to twig-cs-fixer,
   JS and SCSS to the wp-scripts or ESLint/stylelint commands, with a raw
   `vendor/bin/…` or `npx …` fallback when no alias exists
3. **Run auto-fix, then verify** — `phpcbf` before `phpcs`, `format` before `lint:js`,
   then re-run the check and report what survived
4. **Report** — remaining violations with `file:line` and the command to re-verify

Kanopi starter script names (`code-fix`, `code-sniff`, `twig-lint`, `rector-check`) appear
in the skill as one row of a general alias lookup, alongside vanilla Drupal, WordPress,
and wp-scripts conventions — a reference to confirm against the project, not a command
list to recite.

If no alias, binary, or config file exists, the skill says so and offers to install the
standards rather than guessing. It never certifies compliance from reading code: with
the tooling unavailable, the summary begins "Standards not verified" and names what
could not run.

## composer-patch-generator Skill

Generate patches for Composer packages that apply cleanly both locally and in CI.

```bash
/composer-patch-generator     # Guided patch creation for a contrib module or package
```

### What It Does

- Creates patches in the correct `diff -ruN` format against the dist archive
- Wires the patch into `composer.json` via `extra.patches` (cweagans/composer-patches)
- Verifies the patch applies with a clean `composer install`
- Diagnoses "applies locally but fails in CI" mismatches

## Common Workflows

**Pre-commit standards check:**
```bash
/code-standards-checker
```

**Patch a contrib module bug before the fix lands upstream:**
```bash
/composer-patch-generator
# Then contribute the fix back with /drupal-contribute
```

## Related Skills

- **[Testing Skills](testing.md)** — Coverage analysis with `coverage-analyzer`
- **[PR Workflow](pr-workflow.md)** — `/pr-review self` includes a code quality pass
- **[Drupal.org Contribution](drupal-contribution-skills.md)** — Upstream the fixes you patch
