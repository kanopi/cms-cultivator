# Composer Scripts

Kanopi projects include standardized Composer scripts for quality checks, testing, and code standards.

See [Kanopi Tools Overview](overview.md) for complete list of Composer scripts.

## Quick Reference

### Drupal
```bash
ddev composer code-check    # All checks
ddev composer code-fix      # Auto-fix all
ddev composer phpstan       # Static analysis
ddev composer rector-check  # Modernization
ddev composer twig-lint     # Twig templates
```

### WordPress
```bash
ddev composer phpcs         # Code standards
ddev composer phpcbf        # Auto-fix
ddev composer phpstan       # Static analysis
ddev composer rector-check  # Modernization
```
