---
description: Generate a PR description from git changes using team template
argument-hint: [ticket-number]
allowed-tools: Bash(git:*), Read, Glob, Grep
---

Generate a pull request description using the following template. Analyze the git changes to populate the template intelligently.

## Instructions

1. **Analyze the current git state:**
   - Run `git status` to see modified, staged, and untracked files
   - Run `git diff` to see the actual code changes
   - Check the current branch name for ticket references
   - Look at recent commit messages for context

2. **Detect key information for Drupal/WordPress projects:**
   - Check if Cypress tests (`.cy.js` or `.cy.ts` files) were modified and extract test scenarios
   - Identify changes to `composer.json` or `composer.lock` for new PHP dependencies (Drupal modules, WordPress plugins, libraries, patches)
   - Identify changes to `package.json` or `package-lock.json` for new frontend dependencies
   
   **For Drupal projects:**
   - Detect and document configuration changes in `config/sync/*.yml` or similar config directories
   - Look for custom module changes in `modules/custom/`
   - Check for contrib module patches in `patches/` directory or `composer.json` patches section
   - Detect services definitions in `*.services.yml` files
   - Look for routing changes in `*.routing.yml` files
   - Check permissions in `*.permissions.yml` files
   - Identify module dependency changes in `*.info.yml` files
   - Look for database update files (`hook_update_N` in `.install` files)
   - Check for entity type definitions or custom entity changes
   - Detect field definitions, field storage changes, view modes, or form display configurations
   - Look for theme changes: Twig templates (`.html.twig`), libraries (`*.libraries.yml`), preprocess functions in `.theme` files
   - Check for migration configurations or custom migrations
   - Look for REST API endpoint changes (`*.rest.yml`)
   - Detect webform configurations, paragraph types, or taxonomy changes
   - Check for changes to `settings.php` or `settings.local.php`
   
   **For WordPress projects:**
   - Detect theme changes (`functions.php`, template files in theme directories)
   - Check for custom Gutenberg blocks in `blocks/` directories
   - Look for ACF field group exports in `acf-json/` directories
   - Identify changes to `mu-plugins/` (must-use plugins)
   - Detect custom plugin modifications in `wp-content/plugins/`
   - Check for custom post type or taxonomy registrations
   - Look for shortcode implementations
   - Check changes to `wp-config.php`
   
   - Identify new custom modules, themes, or plugins being added
   - Check for changes to `.htaccess`, `robots.txt`, or other deployment-critical files

3. **Generate PR description using this template:**

```markdown
## Description
Teamwork Ticket(s): [insert_ticket_name_here](insert_link_here)
- [ ] Was AI used in this pull request?

> As a developer, I need to start with a story.

_A few sentences describing the overall goals of the pull request's commits.
What is the current behavior of the app? What is the updated/expected behavior
with this PR?_

## Acceptance Criteria
* A list describing how the feature should behave
* e.g. Clicking outside a modal will close it
* e.g. Clicking on a new accordion tab will not close open tabs

## Assumptions
* A list of things the code reviewer or project manager should know
* e.g. There is a known Javascript error in the console.log
* e.g. On any `multidev`, the popup plugin breaks.

## Steps to Validate
1. A list of steps to validate
1. Include direct links to test sites (specific nodes, admin screens, etc)
1. Be explicit

## Affected URL
[link_to_relevant_multidev_or_test_site](insert_link_here)

## Deploy Notes
_Notes regarding deployment of the contained body of work. These should note any
new dependencies, new scripts, etc. This should also include work that needs to be
accomplished post-launch like enabling a plugin._
```

4. **Populate intelligently for Drupal/WordPress context:**

   **Description**: Summarize what changed based on git diff (new modules/plugins, content type changes, theme updates, bug fixes, custom blocks, entity definitions, field configurations)
   
   **User Story**: Infer from the changes (e.g., "As a content editor, I need to be able to filter events by category" or "As a site visitor, I need to see related products in a sidebar widget")
   
   **Acceptance Criteria**: Extract from:
   - **Drupal**: Hook implementations, entity form alterations, views configurations, permission changes, field definitions, routing changes, services, form validation, paragraph types, webform configurations, migration sources
   - **WordPress**: Action/filter hooks, shortcodes, custom post types, custom taxonomies, Gutenberg blocks, ACF field groups, widget registrations
   - **Frontend**: Template changes, Twig templates, CSS/JS modifications, accessibility improvements, library definitions
   
   **Assumptions**: Note:
   - Multidev/staging environment quirks
   - **Drupal**: Entity updates that might be needed, config split environments, search reindexing requirements
   - **WordPress**: Plugin activation/deactivation needs, ACF sync requirements
   - Any manual configuration steps
   - Known issues or limitations
   
   **Steps to Validate**:
   - If Cypress tests exist in changes, reference them directly with test names
   - **For Drupal**:
     - Include admin paths (`/admin/structure/types/manage/[type]`, `/admin/structure/views/view/[view]`)
     - Content type field testing at `/node/add/[type]`
     - View testing at specific view paths
     - Permission testing with different user roles (e.g., authenticated user, content editor, administrator)
     - Form validation testing
     - Webform testing at specific form paths
     - Paragraph type testing in content creation
     - Taxonomy vocabulary management at `/admin/structure/taxonomy/manage/[vocab]`
   - **For WordPress**:
     - Include wp-admin paths (`/wp-admin/...`)
     - Gutenberg editor testing for blocks
     - ACF field testing on specific post types
     - Shortcode rendering tests
     - Widget/sidebar testing
   - Reference specific nodes/posts, taxonomy terms, or user roles to test with
   
   **Deploy Notes**: List:
   - New Composer dependencies (`composer install` required)
   - New npm dependencies (`npm install` required)
   - **For Drupal projects**:
     - Document what configuration files changed in the `/config` folder (e.g., "Updated views configuration for events listing", "Modified field storage for taxonomy terms", "Added new content type configuration for News", "Updated permissions for editor role")
     - Modules that need to be enabled (`drush en module_name`) or disabled (`drush pm-uninstall module_name`)
     - Entity updates required (`drush entity:updates` or `drush entup`)
     - Database updates required if `.install` files changed (`drush updb -y`)
     - Config split environment considerations
     - Search index rebuilding if search_api or solr configs changed (`drush search-api:rebuild-tracker`, `drush search-api:index`)
     - Image style regeneration if image styles were modified
     - Translation imports if locale files changed
     - Drupal core patches or core version updates
     - Third-party library additions
     - Migration execution if new migrations added (`drush migrate:import [migration_id]`)
   - **For WordPress projects**:
     - ACF field groups that need to be synced (if not using JSON sync, note manual sync required)
     - WordPress plugins that need activation/deactivation
     - Permalink flush required (if custom post types, taxonomies, or rewrite rules changed)
     - WP-CLI commands that need to run post-deployment
     - New custom post type or taxonomy registrations
   - New environment variables or settings in `wp-config.php` or `settings.php`
   - File permission changes
   - `.htaccess` rule changes affecting permalinks or redirects

5. **Support optional ticket number argument:**
   - Allow `/pr-desc 12345` to automatically populate the ticket reference
   - Use branch name as fallback for ticket detection (common patterns: `feature/PROJ-123`, `bugfix/456`, `feature/123-description`)

The command should produce ready-to-use PR descriptions that developers can copy to GitHub/GitLab, with comprehensive Drupal and WordPress-specific deployment considerations.
