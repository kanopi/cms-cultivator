---
description: Generate conventional commit messages from staged changes
allowed-tools: Bash(git:*), Read, Glob
---

You are helping write a conventional commit message. Generate clear, descriptive commit messages following best practices.

## Step 1: Analyze Staged Changes

Run these commands to understand what's being committed:

```bash
# See staged files
git diff --cached --name-only

# See actual staged changes
git diff --cached

# Check recent commits for style consistency
git log --oneline -10
```

## Step 2: Determine Commit Type

Classify the change using conventional commit types:

### Primary Types
- **feat**: A new feature (user-facing functionality)
- **fix**: A bug fix (resolves incorrect behavior)
- **docs**: Documentation only changes
- **style**: Code style changes (formatting, whitespace, no logic change)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Performance improvement
- **test**: Adding or updating tests
- **build**: Build system or external dependencies (package.json, composer.json)
- **ci**: CI/CD configuration changes
- **chore**: Other changes that don't modify src or test files
- **revert**: Reverts a previous commit

### Drupal-Specific Types
- **config**: Drupal configuration changes
- **module**: Custom module changes
- **theme**: Theme-related changes
- **migration**: Migration-related changes

### WordPress-Specific Types
- **theme**: WordPress theme changes
- **plugin**: Plugin-related changes
- **block**: Gutenberg block changes

## Step 3: Identify Scope

Determine the scope (optional but recommended):

### General Scopes
- **api**: API-related changes
- **ui**: User interface changes
- **deps**: Dependency updates
- **security**: Security-related changes
- **a11y**: Accessibility improvements
- **i18n**: Internationalization
- **db**: Database changes

### Drupal Scopes
- **entity**: Entity-related changes
- **views**: Views configuration
- **forms**: Form API changes
- **config**: Configuration management
- **cache**: Cache-related changes
- **module-name**: Specific custom module

### WordPress Scopes
- **acf**: ACF-related changes
- **gutenberg**: Block editor changes
- **cpt**: Custom post type changes
- **taxonomy**: Taxonomy changes
- **theme**: Theme-specific changes

## Step 4: Write Commit Message

Follow this format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Rules for Description
- Use imperative mood ("add" not "added" or "adds")
- Don't capitalize first letter
- No period at the end
- Maximum 50 characters for subject line
- Be specific but concise

### Examples of Good Descriptions
- `feat(user-auth): add password reset functionality`
- `fix(checkout): prevent duplicate order submissions`
- `docs(readme): update installation instructions`
- `perf(queries): optimize user lookup query`
- `refactor(api): simplify error handling logic`
- `config(drupal): add field for event location`
- `theme(blocks): create hero banner component`

### Examples of Bad Descriptions
- ❌ `fix: fixed bug` (not specific)
- ❌ `feat: Added new feature.` (capitalized, period, past tense)
- ❌ `update stuff` (no type, vague)
- ❌ `wip` (not descriptive)

### Body Guidelines (Optional)
Include body when:
- Change is complex and needs explanation
- There are breaking changes
- Need to explain WHY, not just WHAT

Body should:
- Be separated from subject by blank line
- Wrap at 72 characters
- Explain motivation and contrast with previous behavior

Example:
```
fix(cart): prevent race condition in cart updates

Previously, rapid clicks on "add to cart" could result in duplicate
items due to concurrent requests. This change adds optimistic locking
to prevent duplicate cart item creation.

Closes #234
```

### Footer Guidelines
Use footers for:
- **Breaking changes**: `BREAKING CHANGE: description`
- **Issue references**: `Fixes #123`, `Closes #456`, `Refs #789`
- **Co-authors**: `Co-authored-by: Name <email>`
- **Reviewers**: `Reviewed-by: Name <email>`

## Step 5: Generate Options

Provide 3-5 commit message options with explanations:

```markdown
## Suggested Commit Messages

### Option 1 (Recommended)
```
feat(user-profile): add avatar upload functionality

Implements new avatar upload feature allowing users to customize their
profile picture. Includes image validation, resizing, and S3 upload.

Closes #123
```
**Why**: Most specific and includes helpful context in the body.

### Option 2 (Concise)
```
feat(user-profile): add avatar upload functionality
```
**Why**: Good for simpler changes that don't need explanation.

### Option 3 (Alternative Scope)
```
feat(media): add avatar upload functionality
```
**Why**: Alternative scope if you consider this more of a media feature.
```

## Drupal-Specific Commit Messages

### Config Changes
```
config(field): add location field to event content type

Updates event content type with new address field for storing
event location information. Requires config import.
```

### Custom Module Changes
```
feat(custom-events): add event registration functionality

Implements new event registration system allowing users to RSVP
to events. Includes custom entity, form, and email notifications.
```

### Database Updates
```
fix(updates): add missing index to event_registration table

Adds database index on user_id column to improve query performance
for user's event registrations listing.
```

### Theme Changes
```
theme(templates): update event listing layout

Refactors event listing template to use CSS Grid for improved
responsive behavior and maintainability.
```

## WordPress-Specific Commit Messages

### Theme Function Changes
```
feat(theme): add custom pagination for event listings

Implements custom pagination function for event post type archives
using WP_Query with proper accessibility markup.
```

### Gutenberg Block
```
feat(blocks): create event card block

New custom Gutenberg block for displaying event information with
customizable fields for date, location, and registration link.
```

### ACF Field Groups
```
config(acf): add event location field group

New ACF field group for event CPT including address, map
coordinates, and venue name fields.
```

### Custom Post Type
```
feat(cpt): register events custom post type

Implements events CPT with custom taxonomies (event-category,
event-tag) and archive/single templates.
```

## Step 6: Present Options

Show the user multiple options and ask which they prefer, or if they'd like modifications.

**Format:**
```
I've analyzed your staged changes. Here are commit message suggestions:

[Present 3-5 options as shown above]

Which option would you like to use? Or would you like me to adjust any of them?
```

## Best Practices Checklist

A good commit message should:
- [ ] Use conventional commit format
- [ ] Have clear, specific description
- [ ] Use imperative mood
- [ ] Be under 50 chars for subject (72 max)
- [ ] Include scope when applicable
- [ ] Reference issue/ticket if applicable
- [ ] Explain WHY if change is complex
- [ ] Not include unnecessary words (the, a, an)
- [ ] Be atomic (one logical change)

## Common Patterns to Detect

### Dependency Updates
```
build(deps): update drupal core to 10.2.1

Security update addressing SA-CORE-2024-001
```

### Cypress Tests
```
test(e2e): add tests for user registration flow

Adds comprehensive Cypress tests covering registration form
validation, submission, and confirmation email.
```

### Config Import Required
```
config(views): update events listing view

Modifies events view to include location filter and sort by
date. Requires config import on deployment.
```

### Breaking Changes
```
feat(api): change authentication to JWT

BREAKING CHANGE: API authentication now uses JWT tokens instead
of session cookies. Clients must update to use Authorization header.

Migration guide: docs/auth-migration.md
```

### Security Fixes
```
fix(security): sanitize user input in search query

Prevents XSS vulnerability by properly escaping user-provided
search terms before rendering in results template.

Fixes #456
```

## Red Flags to Avoid

Don't write messages like:
- ❌ `wip` or `work in progress`
- ❌ `fix` (too vague)
- ❌ `updates` (not specific)
- ❌ `changes` (meaningless)
- ❌ `asdf` or `test` (lazy)
- ❌ `Fix bugs` (plural and vague)
- ❌ `PR feedback` (doesn't describe change)

## Output Format

1. Show analysis of staged changes
2. Present 3-5 commit message options
3. Explain why each option is appropriate
4. Highlight recommended option
5. Ask if user wants to use one or modify

Keep it concise but informative. The goal is to make it easy for future developers (including the author) to understand what changed and why.
