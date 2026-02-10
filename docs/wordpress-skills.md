# WordPress Skills

Extend CMS Cultivator with 13 specialized WordPress development skills from the official [WordPress/agent-skills](https://github.com/WordPress/agent-skills) repository.

## Overview

The WordPress agent-skills project provides Claude Code with deep WordPress expertise across:

- **Block Development** - Gutenberg blocks, InnerBlocks, block.json
- **Theme Development** - Block themes, theme.json, patterns
- **Plugin Architecture** - Hooks, actions, filters, security best practices
- **REST API** - Custom endpoints, authentication, routes
- **Performance** - Optimization strategies, caching, database queries
- **WP-CLI** - Command-line automation and operations
- **Tooling** - PHPStan, WordPress Playground, Design System

These skills complement CMS Cultivator's existing capabilities by adding WordPress-specific knowledge that activates automatically in WordPress projects.

## Installation

Install all 13 WordPress skills with one command:

```bash
/wp-add-skills
```

**Time:** ~70 seconds

**Location:** `~/.claude/skills/` (global, works across all projects)

**Prerequisites:**
- Git 2.0+
- Node.js v16+ (v18+ recommended)
- 100MB disk space
- Internet connection

## What Gets Installed

### 13 WordPress Skills

#### Core Skills

**wordpress-router**
WordPress project detection and context routing. Auto-activates WordPress skills when working in WordPress projects.

**wp-project-triage**
Auto-detect WordPress tooling, versions, installed plugins, active themes, and project configuration. Helps Claude understand your WordPress setup.

#### Block Development

**wp-block-development**
Gutenberg block development expertise including:
- `block.json` configuration
- InnerBlocks patterns
- Block transforms and variations
- Block supports and attributes
- Client-side and server-side rendering

**wp-block-themes**
Block theme development including:
- `theme.json` configuration
- Template parts and templates
- Global styles and settings
- Block patterns and pattern categories

**wp-interactivity-api**
WordPress Interactivity API (`@wordpress/interactivity`) for:
- Frontend directives
- State management
- Client-side interactivity
- Progressive enhancement

#### Plugin Development

**wp-plugin-development**
WordPress plugin architecture and best practices:
- Plugin headers and metadata
- Hooks, actions, and filters
- Custom post types and taxonomies
- Metaboxes and settings
- Security practices (nonces, sanitization, validation)
- Internationalization (i18n)

**wp-rest-api**
WordPress REST API development:
- Custom endpoints and routes
- Authentication and permissions
- Request/response handling
- Schema validation
- Extending core endpoints

**wp-abilities-api**
WordPress capabilities and permissions system:
- User roles and capabilities
- Custom capabilities
- Capability checks
- Role management

#### Operations & Performance

**wp-wpcli-and-ops**
WP-CLI automation and operations:
- Custom WP-CLI commands
- Automation scripts
- Database operations
- Deployment workflows
- Site management

**wp-performance**
WordPress performance optimization:
- Caching strategies (object cache, page cache)
- Database query optimization
- Asset optimization
- Lazy loading
- Core Web Vitals

#### Tooling

**wp-phpstan**
PHPStan configuration for WordPress:
- WordPress-specific rules
- Static analysis setup
- Type safety for WordPress APIs
- Common WordPress patterns

**wp-playground**
WordPress Playground integration:
- Local WordPress instances
- Testing environments
- Blueprint configuration
- Quick prototyping

**wpds**
WordPress Design System:
- Design tokens
- Component patterns
- Accessibility guidelines
- Figma integration

## Usage

Once installed, WordPress skills activate automatically when Claude detects you're working in a WordPress project.

### Example Questions

**Block Development:**
```
"How do I create a custom Gutenberg block?"
"Show me how to use InnerBlocks"
"What's the best way to add block variations?"
```

**Theme Development:**
```
"How do I configure theme.json?"
"Create a custom block pattern"
"What theme supports should I add?"
```

**Plugin Development:**
```
"Show me how to create a custom post type"
"How do I add a settings page to my plugin?"
"What's the proper way to sanitize user input?"
```

**REST API:**
```
"Create a custom REST endpoint"
"How do I authenticate REST API requests?"
"Show me how to extend a core endpoint"
```

**Performance:**
```
"How can I optimize database queries?"
"What's the best caching strategy?"
"Help me improve Core Web Vitals"
```

**WP-CLI:**
```
"Create a custom WP-CLI command"
"Show me how to bulk update posts"
"How do I export/import content with WP-CLI?"
```

Claude will automatically reference the appropriate WordPress skills to answer your questions with WordPress-specific best practices.

## Managing Skills

### List Installed Skills

```bash
/wp-add-skills --list
```

Shows all installed WordPress skills with verification status.

### Update Skills

```bash
/wp-add-skills --update
```

Updates skills to the latest version from the WordPress/agent-skills repository.

### Remove Skills

To remove WordPress skills, delete them from `~/.claude/skills/`:

```bash
rm -rf ~/.claude/skills/wp-*
rm -rf ~/.claude/skills/wordpress-*
```

Then restart Claude Code.

## Relationship to CMS Cultivator

WordPress skills and CMS Cultivator skills work together seamlessly:

### CMS Cultivator Skills (14)

Provide cross-platform development guidance:
- `accessibility-checker` - WCAG compliance checks
- `browser-validator` - Cross-browser testing
- `code-standards-checker` - PHPCS/ESLint integration
- `security-scanner` - Security vulnerability scanning
- `performance-analyzer` - Performance analysis
- And more...

### WordPress Skills (13)

Provide WordPress-specific expertise:
- `wp-block-development` - Gutenberg blocks
- `wp-plugin-development` - Plugin architecture
- `wp-rest-api` - REST API endpoints
- `wp-performance` - WordPress optimization
- And more...

### No Conflicts

- **Different prefixes**: CMS Cultivator skills use descriptive names, WordPress skills use `wp-*` prefix
- **Complementary**: Skills work together, not in competition
- **Auto-activation**: wordpress-router detects context and activates WordPress skills when appropriate

### Example Workflow

When working on a WordPress plugin:

1. **CMS Cultivator** checks code quality and security
2. **WordPress skills** provide WordPress-specific guidance
3. **CMS Cultivator** validates accessibility and performance
4. **WordPress skills** ensure WordPress best practices

Both skill sets enhance Claude's ability to help with WordPress development.

## Technical Details

### Installation Location

**Global skills directory:**
```
~/.claude/skills/
├── wordpress-router/
├── wp-abilities-api/
├── wp-block-development/
├── wp-block-themes/
├── wp-interactivity-api/
├── wp-performance/
├── wp-phpstan/
├── wp-playground/
├── wp-plugin-development/
├── wp-project-triage/
├── wp-rest-api/
├── wp-wpcli-and-ops/
└── wpds/
```

Each skill contains:
- `SKILL.md` - Skill documentation and examples
- Supporting files specific to that skill

### Skill Activation

Skills activate automatically based on:
- **Project detection**: wordpress-router identifies WordPress projects
- **File context**: Working in WordPress-specific files
- **Question keywords**: WordPress-specific terminology
- **Conversation context**: Discussing WordPress topics

No manual configuration required.

### Updates

The `/wp-add-skills --update` command:
1. Clones latest repository
2. Rebuilds skills from source
3. Replaces existing skills
4. Preserves any local customizations you've made

## Troubleshooting

### Skills not activating

**Check installation:**
```bash
/wp-add-skills --list
```

**Verify files:**
```bash
ls -la ~/.claude/skills/ | grep wp-
```

**Solution:** Restart Claude Code session

### Installation fails

**Check prerequisites:**
```bash
git --version
node --version
df -h ~
```

**Solution:** Install missing prerequisites, ensure 100MB disk space

### Git clone fails

**Problem:** Network issues or GitHub unavailable

**Solution:**
- Check internet connection
- Verify GitHub is accessible
- Try again later
- Check firewall/proxy settings

### Build fails

**Problem:** Node.js version incompatibility

**Solution:**
- Update Node.js to v18+ (LTS)
- Verify npm is installed: `npm --version`
- Check build error messages

## Resources

### Official Documentation

- **WordPress/agent-skills Repository**: [https://github.com/WordPress/agent-skills](https://github.com/WordPress/agent-skills)
- **WordPress Developer Resources**: [https://developer.wordpress.org/](https://developer.wordpress.org/)
- **Gutenberg Handbook**: [https://developer.wordpress.org/block-editor/](https://developer.wordpress.org/block-editor/)

### CMS Cultivator

- **Commands Overview**: [commands/overview.md](commands/overview.md)
- **Quick Start Guide**: [quick-start.md](quick-start.md)
- **Contributing**: [contributing.md](contributing.md)

### Related Skills

- **CMS Cultivator Skills**: [agent-skills.md](agent-skills.md)
- **Drupal Skills**: [drupal-org-integration.md](drupal-org-integration.md)

## License

WordPress agent-skills is licensed under GPL-2.0-or-later, compatible with CMS Cultivator's GPL-2.0-or-later license.

## Contributing

To contribute to WordPress skills:

1. Visit [WordPress/agent-skills](https://github.com/WordPress/agent-skills)
2. Follow their contribution guidelines
3. Submit issues or pull requests to the WordPress repository

For CMS Cultivator contributions, see [contributing.md](contributing.md).
