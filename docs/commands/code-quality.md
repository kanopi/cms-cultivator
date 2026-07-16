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

### What It Checks

- **PHP**: PHPCS against Drupal or WordPress coding standards
- **JavaScript**: ESLint with the project's configuration
- **Auto-detection**: Reads project structure to pick the right standard

### Quick Start (Kanopi Projects)

```bash
# Drupal
ddev composer code-check      # phpstan + rector + phpcs in one pass
ddev composer code-fix        # Auto-fix violations

# WordPress
ddev composer phpcs           # Check standards
ddev composer phpcbf          # Auto-fix violations
```

For projects without Kanopi tooling, the skill runs PHPCS/ESLint directly and reports violations with suggested fixes.

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
