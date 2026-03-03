# CMS-Specific Context

Platform-specific information to highlight when displaying task details.

## Drupal Projects

When showing task details, highlight Drupal-specific info:
- Multidev environment URLs
- Configuration export requirements
- Module dependencies

**Example:**
```markdown
## PROJ-123 Details

### Drupal Notes
- Multidev: `multidev-proj-123`
- URL: https://multidev-proj-123.pantheonsite.io
- Config: Yes - `drush cex` required
- Modules: webform, custom_auth
```

## WordPress Projects

Highlight WordPress-specific info:
- Staging environment
- Plugin/theme changes
- PHP version requirements

**Example:**
```markdown
## SITE-456 Details

### WordPress Notes
- Staging: https://staging.example.com
- Theme: custom-theme v2.1
- PHP: 8.2 required
- Plugins: No new activations needed
```

## NextJS Projects

Highlight NextJS-specific info:
- Deployment environment
- Build requirements
- Environment variables

**Example:**
```markdown
## APP-789 Details

### NextJS Notes
- Preview: https://preview-proj-789.vercel.app
- Build: `npm run build` required
- Env vars: `NEXT_PUBLIC_API_URL` updated
- API routes: New `/api/auth` endpoint
```
