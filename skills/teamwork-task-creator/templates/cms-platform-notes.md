# CMS Platform-Specific Notes

This document provides platform-specific guidance for creating tasks in Drupal, WordPress, and NextJS projects.

## Drupal Projects

Always include:
- **Drupal Version**: 9.x, 10.x, 11.x
- **Module Dependencies**: Which contrib/custom modules affected
- **Configuration Management**: Does this export config? (`drush cex` needed?)
- **Cache Clearing**: Required? (`drush cr`)
- **Multidev Environment**: Pantheon multidev name

Example addition:
```markdown
## Drupal Notes
- Version: Drupal 10.2
- Modules: webform, custom_module
- Config exports: Yes - run `drush cex` before committing
- Cache: Clear caches after deployment
- Multidev: `multidev-feature-name`
```

## WordPress Projects

Always include:
- **WordPress Version**: 6.4, 6.5, etc.
- **Plugin/Theme**: Which plugin/theme modified
- **PHP Version**: 8.1, 8.2, etc.
- **Staging Environment**: WP Engine staging, Local, etc.
- **Plugin Activation**: Any plugins need activation?

Example addition:
```markdown
## WordPress Notes
- Version: WordPress 6.4
- Theme: custom-theme
- PHP: 8.2
- Staging: WP Engine staging environment
- Plugins: No new plugin activation needed
```

## NextJS Projects

Always include:
- **Next Version**: 13.x, 14.x, etc.
- **Node Version**: 18.x, 20.x, etc.
- **Build Required**: Yes/No
- **API Routes**: Any new API routes?
- **Environment Variables**: Any new env vars?

Example addition:
```markdown
## NextJS Notes
- Next Version: 14.1
- Node: 20.x
- Build: Yes - `npm run build` required
- API Routes: New `/api/auth` endpoint
- Env Vars: Add `NEXT_PUBLIC_API_URL` to `.env`
```
