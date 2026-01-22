---
name: drupalorg-issue-helper
description: Quick help with drupal.org issue templates, formatting, and best practices. Invoke when user asks "how do I write a bug report?", "drupal.org issue template", "issue formatting", or needs help structuring issue descriptions for drupal.org projects.
---

# Drupal.org Issue Helper

Quick assistance with drupal.org issue templates, formatting, and best practices for effective bug reports and feature requests.

## When to Use This Skill

Activate this skill when the user:
- Asks "how do I write a bug report?"
- Mentions "drupal.org issue template"
- Needs help formatting an issue description
- Asks about issue categories or priorities
- Wants to understand drupal.org issue best practices

## Quick Auth Note

**drupal.org has no write API** - issue creation requires browser automation.

**Save credentials for auto-login** (one-time setup):
```bash
mkdir -p ~/.config/drupalorg
cat > ~/.config/drupalorg/credentials.yml << 'EOF'
username: your-username
password: your-password
EOF
chmod 600 ~/.config/drupalorg/credentials.yml
```

Then use `/drupal-issue create {project}` - the agent will auto-login if needed.

Or manually create issues at: `https://www.drupal.org/node/add/project-issue/{project}`

## Issue Categories

| Category | When to Use |
|----------|-------------|
| **Bug report** | Something doesn't work as expected |
| **Feature request** | New functionality needed |
| **Task** | Work item that's not a bug or feature |
| **Support request** | Need help using the module |
| **Plan** | Strategic planning for the project |

## Priority Levels

| Priority | Definition |
|----------|------------|
| **Critical** | Data loss, security issue, or complete breakage with no workaround |
| **Major** | Significant impact but workaround exists |
| **Normal** | Standard priority for most issues |
| **Minor** | Nice to have, cosmetic issues, minor improvements |

## Bug Report Template

```markdown
## Problem/Motivation

{Clearly describe what's wrong. What did you expect to happen vs. what actually happened?}

## Steps to Reproduce

1. {First step - be specific}
2. {Second step}
3. {Third step}
4. {Observe the bug}

## Expected Behavior

{What should happen when following the steps above?}

## Actual Behavior

{What actually happens? Include any error messages.}

## Environment

- **Drupal version**: 10.3.x
- **Module version**: 2.0.x
- **PHP version**: 8.2
- **Web server**: Apache/Nginx
- **Database**: MySQL 8.0 / MariaDB 10.x / PostgreSQL

## Additional Context

{Screenshots, error logs, configuration details, etc.}
```

### Bug Report Best Practices

1. **Be specific** - "The form doesn't work" is unhelpful; "Clicking Save on the settings form shows a WSOD" is useful
2. **Include versions** - Always mention Drupal core, module, and PHP versions
3. **Provide steps** - Make it reproducible
4. **Show error messages** - Copy exact error text, don't paraphrase
5. **Attach screenshots** - Visual bugs need visual evidence
6. **Check if it's a duplicate** - Search existing issues first

## Feature Request Template

```markdown
## Problem/Motivation

{Why is this feature needed? What problem does it solve?}

## Proposed Resolution

{How should this feature work? Be as specific as possible.}

## User Interface Changes

{Will there be new admin pages, form fields, or UI elements?}

## API Changes

{Any new hooks, services, or public methods?}

## Data Model Changes

{New database tables, fields, or configuration schema?}

## Alternatives Considered

{What other approaches did you consider and why didn't you choose them?}

## Additional Context

{Mockups, examples from other modules, user stories, etc.}
```

### Feature Request Best Practices

1. **Explain the "why"** - Help maintainers understand the use case
2. **Be specific** - Vague requests are hard to implement
3. **Consider existing patterns** - Follow Drupal conventions
4. **Offer to help** - Maintainers appreciate contributors
5. **Accept alternatives** - Your solution might not be the best one

## Task Template

```markdown
## Summary

{What needs to be done?}

## Detailed Description

{Provide more context and background}

## Acceptance Criteria

- [ ] {Specific, testable criterion}
- [ ] {Another criterion}
- [ ] {Tests pass}
- [ ] {Documentation updated}

## Related Issues

- #{related_issue_number}: {brief description}
```

## Support Request Template

```markdown
## What I'm Trying to Do

{Describe your goal, not just your problem}

## What I've Tried

1. {First approach}
2. {Second approach}
3. {Third approach}

## Current Behavior

{What's happening now?}

## Environment

- Drupal version: {version}
- Module version: {version}
- Other relevant modules: {list}

## Code/Configuration

```php
// Relevant code snippet if applicable
```

## Screenshots

{Attach if helpful}
```

## Title Best Practices

### Good Titles

- "Form validation fails when field is empty"
- "Add support for CKEditor 5 plugins"
- "PHP 8.2 deprecation warning in EntityViewBuilder"
- "Missing translation for 'Save' button"

### Bad Titles

- "It doesn't work" (too vague)
- "URGENT!!! HELP!!!" (not descriptive)
- "Bug" (meaningless)
- "Question" (doesn't describe the question)

### Title Formula

```
{Action/Problem} + {Context/Location} + {Condition (optional)}

Examples:
- "Form validation fails when required field is empty"
- "Add bulk export option to admin views"
- "WSOD on node save with paragraphs enabled"
```

## Issue Status Flow

```
Active → Needs work → Needs review → RTBC → Fixed → Closed
    ↑         ↓
    └─────────┘
```

| Status | Who Sets | Meaning |
|--------|----------|---------|
| **Active** | Reporter | Issue is open, being worked on |
| **Needs work** | Reviewer | Changes requested |
| **Needs review** | Contributor | Ready for review |
| **RTBC** | Community | Reviewed, ready to commit |
| **Fixed** | Maintainer | Committed to codebase |
| **Closed** | Anyone | Various close reasons |

## Quick Examples

### Example 1: Concise Bug Report

```
User: "I found a bug where the paragraphs module crashes on save"

Title: WSOD when saving node with nested paragraphs

## Problem/Motivation
Saving a node with more than 3 levels of nested paragraphs causes a white screen of death.

## Steps to Reproduce
1. Create a paragraph type with a nested paragraphs field
2. Create content with 4+ levels of nesting
3. Click Save

## Expected Behavior
Node saves successfully.

## Actual Behavior
WSOD with error: "Maximum function nesting level of 256 reached"

## Environment
- Drupal: 10.2.5
- Paragraphs: 1.17
- PHP: 8.2.15
```

### Example 2: Feature Request

```
User: "I want to suggest adding a feature to export paragraphs"

Title: Add ability to export paragraph configurations as YAML

## Problem/Motivation
Developers need to share paragraph type configurations between sites. Currently, this requires manually recreating configurations or using Features module.

## Proposed Resolution
Add a "Export" tab to paragraph types that generates YAML configuration that can be imported via drush or admin UI.

## User Interface Changes
- New "Export" tab on paragraph type edit page
- YAML textarea with copy button
- Import form at /admin/structure/paragraphs/import

## API Changes
- New service: `paragraphs.config_exporter`
- New drush command: `paragraphs:export`

## Alternatives Considered
- Features module: Adds complexity for simple use case
- Manual config sync: Error-prone and tedious
```

### Example 3: Quick Status Update

```
User: "How do I mark my issue as ready for review?"

Status changes:
1. Go to your issue page
2. Scroll to the status field (usually near bottom)
3. Change from "Active" or "Needs work" to "Needs review"
4. Add a comment explaining what's ready for review
5. Click Save

Best practice: Include a summary of changes in your comment when changing to "Needs review".
```

## Common Mistakes to Avoid

1. **No version info** - Always include Drupal and module versions
2. **No steps to reproduce** - Bugs without repro steps often get closed
3. **Duplicate issues** - Search before creating
4. **Wrong project** - Make sure you're creating the issue on the correct project
5. **Mixing issues** - One issue per bug/feature
6. **No follow-up** - Respond to maintainer questions

## Resources

- [Drupal Issue Queue Documentation](https://www.drupal.org/docs/develop/issues)
- [Issue Priority Guidelines](https://www.drupal.org/docs/develop/issues/issue-priorities)
- [Writing Good Bug Reports](https://www.drupal.org/docs/develop/issues/fields-and-other-parts-of-issues)
