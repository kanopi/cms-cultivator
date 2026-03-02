# CMS Platform Notes

Platform-specific context to include in all Teamwork tasks.

## Drupal Projects

Always include in tasks:
- **Drupal Version**: 9.x, 10.x, 11.x
- **Multidev Environment**: Pantheon multidev name (e.g., `multidev-proj-123`)
- **Module Dependencies**: Which contrib/custom modules affected
- **Configuration Management**: Export config? (`drush cex` needed?)
- **Cache Clearing**: Required after deployment? (`drush cr`)

**Example addition to task:**
```markdown
## Drupal Notes
- Version: Drupal 10.2
- Multidev: `multidev-user-auth`
- URL: https://multidev-user-auth.pantheonsite.io
- Modules: webform, custom_auth
- Config: Yes - run `drush cex` after changes
- Cache: Clear caches after deployment (`drush cr`)
```

## WordPress Projects

Always include in tasks:
- **WordPress Version**: 6.4, 6.5, etc.
- **Staging Environment**: WP Engine, Local, etc.
- **Plugin/Theme**: Which plugin/theme modified
- **PHP Version**: 8.1, 8.2, etc.
- **Plugin Activation**: Any plugins need activation after deployment?

**Example addition to task:**
```markdown
## WordPress Notes
- Version: WordPress 6.4
- Staging: https://staging.example.com
- Theme: custom-theme v2.1
- PHP: 8.2 required
- Plugins: No new activations needed
- Deployment: Push to WP Engine staging first
```

## NextJS Projects

Always include in tasks:
- **Next Version**: 13.x, 14.x, etc.
- **Node Version**: 18.x, 20.x, etc.
- **Deployment Environment**: Vercel, custom
- **Build Required**: Yes/No
- **API Routes**: Any new API routes?
- **Environment Variables**: Any new env vars needed?

**Example addition to task:**
```markdown
## NextJS Notes
- Next: 14.1
- Node: 20.x
- Deployment: Vercel preview (auto on PR)
- Build: Yes - `npm run build` required
- API Routes: New `/api/auth` endpoint
- Env Vars: Add `NEXT_PUBLIC_API_URL` to Vercel settings
```
