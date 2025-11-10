---
description: Check code against coding standards (PHPCS, ESLint, WordPress/Drupal)
allowed-tools: Bash(composer:*), Bash(ddev composer:*), Bash(ddev exec composer:*), Bash(npm:*), Bash(ddev exec npm:*), Bash(ddev theme-npm:*), Bash(eslint:*), Bash(npx eslint:*), Read, Glob
---

# Code Standards Check

Check your code against PHPCS, ESLint, WordPress Coding Standards, and Drupal Coding Standards.

## Quick Start

### Kanopi Projects

```bash
# Run all code quality checks
ddev composer code-check

# Individual checks
ddev composer phpcs        # Coding standards
ddev composer phpstan      # Static analysis
ddev composer rector-check # Modernization opportunities
```

### Non-Kanopi Projects

```bash
# PHP (Drupal)
vendor/bin/phpcs --standard=Drupal,DrupalPractice web/modules/custom

# PHP (WordPress)
vendor/bin/phpcs --standard=WordPress wp-content/themes/custom-theme

# JavaScript
npx eslint src/**/*.js
```

## How It Works

This command uses the **code-standards-checker** Agent Skill to validate code quality.

**For complete workflow and platform-specific standards**, see:
→ [`skills/code-standards-checker/SKILL.md`](../skills/code-standards-checker/SKILL.md)

The skill provides detailed instructions for:
- Detecting project type (Drupal/WordPress/JavaScript)
- Running appropriate linters (PHPCS, ESLint, etc.)
- Identifying and fixing style violations
- Platform-specific coding standards
- Common patterns and anti-patterns

## When to Use

**Use this command (`/quality-standards`)** when:
- ✅ You want comprehensive project-wide standards check
- ✅ Preparing code for commit or PR
- ✅ CI/CD pipeline integration
- ✅ Full project analysis needed

**The skill auto-activates** when you ask:
- "Does this follow WordPress standards?"
- "Is my code properly formatted?"
- "Should I run PHPCS?"

## What Gets Checked

### PHP Standards

**Drupal**:
- 2-space indentation
- Type hints required
- Docblocks for all functions/classes
- Drupal naming conventions

**WordPress**:
- Tab indentation
- Yoda conditions
- Escaping/sanitization
- WordPress naming conventions

### JavaScript Standards

- ESLint rules (project-specific)
- Modern JavaScript (const/let, arrow functions)
- No console.log in production
- Proper JSDoc comments

## Example Output

```markdown
## Code Standards Check Results

**Project**: Drupal 10
**Standard**: Drupal + DrupalPractice

### Summary
- ✅ 45 files checked
- ⚠️ 12 warnings
- ❌ 3 errors

### Errors (Must Fix)

1. **Missing type hint** - `src/Controller/MyController.php:23`
   Fix: Add type hint `public function process(array $data): void`

2. **SQL Injection Risk** - `src/Service/UserService.php:45`
   Fix: Use placeholders instead of concatenation

### Auto-Fix Available
```bash
ddev composer code-fix
```
```

## Common Issues

### High Priority (Security/Functionality)
- SQL injection vulnerabilities
- XSS vulnerabilities (unescaped output)
- Missing access checks

### Medium Priority (Maintainability)
- Missing type hints
- Missing documentation
- Poor function/variable names

### Low Priority (Style)
- Whitespace issues
- Line length
- Brace placement

## Related Commands

- **[`/quality-analyze`](quality-analyze.md)** - Analyze code quality and technical debt
- **[`/test-generate`](test-generate.md)** - Generate tests for your code
- **[`/audit-security`](audit-security.md)** - Security-focused code analysis

## Resources

- [Drupal Coding Standards](https://www.drupal.org/docs/develop/standards)
- [WordPress Coding Standards](https://developer.wordpress.org/coding-standards/)
- [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)
- [ESLint](https://eslint.org/)
- [code-standards-checker Agent Skill](../skills/code-standards-checker/SKILL.md)
