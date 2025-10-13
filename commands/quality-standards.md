---
description: Check code against coding standards (PHPCS, ESLint, WordPress/Drupal standards)
allowed-tools: Bash(composer:*), Bash(ddev composer:*), Bash(ddev exec composer:*), Bash(npm:*), Bash(ddev exec npm:*), Bash(ddev theme-npm:*), Bash(eslint:*), Bash(npx eslint:*), Read, Glob
---

# Coding Standards Check

Verify code compliance with Drupal Coding Standards, WordPress Coding Standards, and JavaScript/CSS linting using Kanopi's standardized scripts.

## Quick Start (Kanopi Projects)

### Drupal - All-in-One Check
```bash
# Check everything (modules + themes)
ddev composer code-sniff

# Check modules only
ddev composer code-sniff-modules

# Check themes only
ddev composer code-sniff-themes
```

### WordPress - Check Standards
```bash
# Check all wp-content (using Drupal/DrupalPractice standards)
ddev composer phpcs
```

---

## Auto-Fix Code Standards

### Drupal - Fix Issues
```bash
# Fix everything (modules + themes + rector + php lint)
ddev composer code-fix

# Fix modules only
ddev composer code-fix-modules

# Fix themes only
ddev composer code-fix-themes
```

### WordPress - Fix Issues
```bash
# Auto-fix code standards in wp-content
ddev composer phpcbf
```

---

## Drupal-Specific: Twig Template Standards

Drupal projects have additional Twig linting:

```bash
# Check Twig templates (modules + themes)
ddev composer twig-lint

# Check Twig in modules only
ddev composer twig-lint-modules

# Check Twig in themes only
ddev composer twig-lint-themes

# Auto-fix Twig issues
ddev composer twig-fix

# Fix modules only
ddev composer twig-fix-modules

# Fix themes only
ddev composer twig-fix-themes
```

---

## PHP Coding Standards

### Drupal Standards (Kanopi Drupal Starter)

**Check Code:**
```bash
# Recommended: Use Kanopi's composer script
ddev composer code-sniff

# What it does:
# - Runs phpcs on web/modules/custom
# - Runs phpcs on web/themes/custom
# - Uses Drupal and DrupalPractice standards
# - Ignores node_modules
```

**Fix Code:**
```bash
# Recommended: Use Kanopi's composer script
ddev composer code-fix

# What it does:
# - Runs phpcbf on modules
# - Runs phpcbf on themes
# - Applies rector fixes
# - Runs php -l syntax check
```

**Manual Commands (if needed):**
```bash
# Direct phpcs command
ddev exec vendor/bin/phpcs --ignore=*/node_modules/* --standard=Drupal,DrupalPractice --extensions=php,module,inc,install,test,profile,theme,info,txt,md,yml web/modules/custom

# Direct phpcbf command
ddev exec vendor/bin/phpcbf --ignore=*/node_modules/* --standard=Drupal,DrupalPractice --extensions=php,module,inc,install,test,profile,theme,info,txt,md,yml web/modules/custom
```

### WordPress Standards (Kanopi Struts Starter)

**Check Code:**
```bash
# Recommended: Use Kanopi's composer script
ddev composer phpcs

# What it does:
# - Runs phpcs on web/wp-content
# - Uses Drupal and DrupalPractice standards (Kanopi standard)
# - Configured in .phpcs.xml.dist
```

**Fix Code:**
```bash
# Recommended: Use Kanopi's composer script
ddev composer phpcbf

# What it does:
# - Runs phpcbf on web/wp-content
# - Auto-fixes violations
# - Uses same standards as phpcs
```

**Manual Commands (if needed):**
```bash
# Direct phpcs command
ddev exec web/wp-content/mu-plugins/vendor/bin/phpcs -s --standard="./.phpcs.xml.dist" ./web/wp-content

# Direct phpcbf command
ddev exec web/wp-content/mu-plugins/vendor/bin/phpcbf -s --standard="./.phpcs.xml.dist" ./web/wp-content
```

---

## JavaScript Standards

### ESLint

```bash
# Install ESLint (if not already installed)
ddev exec npm install --save-dev eslint

# Check JavaScript
ddev exec npx eslint web/themes/custom/js

# Fix automatically
ddev exec npx eslint web/themes/custom/js --fix
```

### Theme-Specific npm Scripts

Many Kanopi themes have lint scripts in package.json:

```bash
# Run theme's lint script (if configured)
ddev theme-npm run lint

# Run theme's lint:fix script (if configured)
ddev theme-npm run lint:fix
```

---

## CSS Standards

### Stylelint

```bash
# Install Stylelint (if not already installed)
ddev exec npm install --save-dev stylelint stylelint-config-standard

# Check CSS
ddev exec npx stylelint "web/themes/custom/**/*.css"

# Fix automatically
ddev exec npx stylelint "web/themes/custom/**/*.css" --fix
```

---

## CI/CD Integration

### GitHub Actions - Drupal

```yaml
# .github/workflows/code-standards.yml
name: Code Standards
on: [push, pull_request]

jobs:
  phpcs-drupal:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up DDEV
        uses: ddev/github-action-setup-ddev@v1

      - name: Start DDEV
        run: ddev start

      - name: Install dependencies
        run: ddev composer install

      - name: Run PHPCS with JUnit output
        run: ddev composer code-sniff-ci

      - name: Publish Test Results
        uses: EnricoMi/publish-unit-test-result-action@v2
        if: always()
        with:
          files: |
            phpcs-modules-report.xml
            phpcs-themes-report.xml

  twig-lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: ddev/github-action-setup-ddev@v1

      - name: Start DDEV
        run: ddev start

      - name: Install dependencies
        run: ddev composer install

      - name: Run Twig Lint with JUnit output
        run: ddev composer twig-lint-ci

      - name: Publish Test Results
        uses: EnricoMi/publish-unit-test-result-action@v2
        if: always()
        with:
          files: |
            twig-modules-report.xml
            twig-themes-report.xml

  eslint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: ddev/github-action-setup-ddev@v1

      - name: Start DDEV
        run: ddev start

      - name: Install npm dependencies
        run: ddev theme-npm install

      - name: Run ESLint
        run: ddev theme-npm run lint
```

### GitHub Actions - WordPress

```yaml
# .github/workflows/code-standards.yml
name: Code Standards
on: [push, pull_request]

jobs:
  phpcs-wordpress:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up DDEV
        uses: ddev/github-action-setup-ddev@v1

      - name: Start DDEV
        run: ddev start

      - name: Install dependencies
        run: ddev composer install

      - name: Run PHPCS
        run: ddev composer phpcs

  eslint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: ddev/github-action-setup-ddev@v1

      - name: Start DDEV
        run: ddev start

      - name: Install npm dependencies
        run: ddev theme-npm install

      - name: Run ESLint
        run: ddev theme-npm run lint
```

---

## Configuration Files

### Drupal - .phpcs.xml (if customizing)

```xml
<?xml version="1.0"?>
<ruleset name="Kanopi Drupal">
  <description>Kanopi Drupal coding standards</description>

  <!-- Use Drupal standards -->
  <rule ref="Drupal"/>
  <rule ref="DrupalPractice"/>

  <!-- Paths to check -->
  <file>web/modules/custom</file>
  <file>web/themes/custom</file>

  <!-- Exclude patterns -->
  <exclude-pattern>*/node_modules/*</exclude-pattern>
  <exclude-pattern>*/vendor/*</exclude-pattern>
</ruleset>
```

### WordPress - .phpcs.xml.dist

Kanopi Struts projects include `.phpcs.xml.dist` configured with Drupal/DrupalPractice standards for consistency across CMS platforms.

### .eslintrc.js

```javascript
module.exports = {
  extends: ['eslint:recommended'],
  env: {
    browser: true,
    es6: true,
    node: true,
    jquery: true, // For WordPress/Drupal projects using jQuery
  },
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module',
  },
  rules: {
    'no-console': 'warn',
    'no-unused-vars': 'error',
    'prefer-const': 'warn',
    'no-var': 'warn',
  },
};
```

---

## Complete Quality Check Workflow

### Drupal - Full Check
```bash
# Run all quality checks at once
ddev composer code-check

# This runs:
# - phpstan (static analysis)
# - rector-modules (modernization check)
# - rector-themes (modernization check)
# - code-sniff (phpcs on modules + themes)

# Then check Twig
ddev composer twig-lint
```

### WordPress - Full Check
```bash
# Check code standards
ddev composer phpcs

# Run static analysis
ddev composer phpstan

# Check for modernization opportunities
ddev composer rector-check
```

---

## Fixing All Issues

### Drupal - Fix Everything
```bash
# Fix all PHP issues
ddev composer code-fix

# Fix Twig issues
ddev composer twig-fix

# Fix JavaScript (if theme has lint:fix script)
ddev theme-npm run lint:fix
```

### WordPress - Fix Everything
```bash
# Fix code standards
ddev composer phpcbf

# Apply rector fixes
ddev composer rector-fix

# Fix JavaScript (if theme has lint:fix script)
ddev theme-npm run lint:fix
```

---

## Output Interpretation

### PHPCS Output Example

```
FILE: /var/www/html/web/modules/custom/mymodule/src/Controller/MyController.php
--------------------------------------------------------------------------------
FOUND 3 ERRORS AND 2 WARNINGS AFFECTING 5 LINES
--------------------------------------------------------------------------------
 12 | ERROR   | [x] Expected 1 space after closing parenthesis; found 0
 15 | WARNING | [ ] Line exceeds 80 characters; contains 95 characters
 23 | ERROR   | [x] Expected 1 blank line after function; found 0
 45 | ERROR   | [ ] Missing @param tag for parameter $uid
 67 | WARNING | [ ] TODO found: Refactor this method
--------------------------------------------------------------------------------
PHPCBF CAN FIX THE 2 MARKED SNIFF VIOLATIONS AUTOMATICALLY
--------------------------------------------------------------------------------
```

**Interpretation:**
- `[x]` = Auto-fixable with phpcbf
- `[ ]` = Requires manual fix
- Warnings are suggestions, errors must be fixed

### Twig Lint Output Example

```
FILE: /var/www/html/web/themes/custom/mytheme/templates/node.html.twig
------------------------------------------------------------------------
FOUND 2 VIOLATIONS AFFECTING 2 LINES
------------------------------------------------------------------------
 5 | ERROR | Extra indentation found. Expected 2 spaces, found 4
12 | ERROR | Missing space after opening curly brace
------------------------------------------------------------------------
```

---

## Best Practices

1. **Run Before Committing**
   - Always check standards before committing code
   - Use pre-commit hooks (see `ddev project-lefthook`)

2. **Fix Automatically First**
   - Run auto-fix commands (`phpcbf`, `code-fix`, `twig-fix`)
   - Then manually address remaining issues

3. **Use CI/CD**
   - Configure GitHub Actions to fail builds on violations
   - Use `-ci` variants for JUnit XML output

4. **Team Consistency**
   - Use Kanopi's composer scripts for consistency
   - All team members use same standards

5. **IDE Integration**
   - Configure your IDE to use PHPCS/ESLint
   - Enable real-time feedback as you code

---

## Troubleshooting

### "Command not found" Errors

**Issue**: `vendor/bin/phpcs: not found`

**Solution**: Use Kanopi's composer scripts which handle paths:
```bash
ddev composer code-sniff  # Instead of direct vendor/bin/phpcs
```

### Different Standards on Different Projects

**Issue**: Standards differ between WordPress and Drupal

**Solution**: Kanopi uses Drupal/DrupalPractice standards consistently across both platforms. This is intentional for team consistency.

### Twig Lint Fails on Drupal

**Issue**: `vendor/bin/twig-cs-fixer: not found`

**Solution**: Twig linting requires drupal/core-dev:
```bash
ddev composer require --dev drupal/core-dev
```

---

## Resources

- [Drupal Coding Standards](https://www.drupal.org/docs/develop/standards)
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)
- [ESLint](https://eslint.org/)
- [Twig Coding Standards](https://twig.symfony.com/doc/3.x/coding_standards.html)
- [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)
- [Kanopi DDEV Add-ons](https://github.com/kanopi)
