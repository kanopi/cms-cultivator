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

## Quick Note on Creating Issues

**drupal.org has no write API** - issue creation requires the web UI.

Use `/drupal-issue create {project}` for a guided workflow that:
1. Generates properly formatted HTML content
2. Copies title to clipboard
3. Opens browser to the issue form
4. Guides you through submission

Or manually create issues at: `https://www.drupal.org/node/add/project-issue/{project}`

## Official drupal.org HTML Issue Template

drupal.org expects issue descriptions in **HTML format** with specific headings. Use this exact structure:

```html
<h3 id="summary-problem-motivation">Problem/Motivation</h3>
{problem_description}

<h4 id="summary-steps-reproduce">Steps to reproduce</h4>
{steps_if_bug}

<h3 id="summary-proposed-resolution">Proposed resolution</h3>
{proposed_solution}

<h3 id="summary-remaining-tasks">Remaining tasks</h3>
{remaining_tasks_checklist}

<h3 id="summary-ui-changes">User interface changes</h3>
{ui_changes_or_none}

<h3 id="summary-api-changes">API changes</h3>
{api_changes_or_none}

<h3 id="summary-data-model-changes">Data model changes</h3>
{data_model_changes_or_none}
```

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

Use this complete template for bug reports:

```html
<h3 id="summary-problem-motivation">Problem/Motivation</h3>
{Clearly describe what's wrong. What did you expect to happen vs. what actually happened?}

<h4 id="summary-steps-reproduce">Steps to reproduce</h4>
1. {First step - be specific}
2. {Second step}
3. {Third step}
4. {Observe the bug}

<h3 id="summary-proposed-resolution">Proposed resolution</h3>
{How should this be fixed?}

<h3 id="summary-remaining-tasks">Remaining tasks</h3>
- [ ] Confirm the bug can be reproduced
- [ ] Write the fix
- [ ] Add test coverage
- [ ] Review and merge

<h3 id="summary-ui-changes">User interface changes</h3>
None

<h3 id="summary-api-changes">API changes</h3>
None

<h3 id="summary-data-model-changes">Data model changes</h3>
None
```

### Bug Report Best Practices

1. **Be specific** - "The form doesn't work" is unhelpful; "Clicking Save on the settings form shows a WSOD" is useful
2. **Include versions** - Always mention Drupal core, module, and PHP versions
3. **Provide steps** - Make it reproducible
4. **Show error messages** - Copy exact error text, don't paraphrase
5. **Attach screenshots** - Visual bugs need visual evidence
6. **Check if it's a duplicate** - Search existing issues first

## Feature Request Template

```html
<h3 id="summary-problem-motivation">Problem/Motivation</h3>
{Why is this feature needed? What problem does it solve?}

<h3 id="summary-proposed-resolution">Proposed resolution</h3>
{How should this feature work? Be as specific as possible.}

<h3 id="summary-remaining-tasks">Remaining tasks</h3>
- [ ] Design the approach
- [ ] Implement the feature
- [ ] Add test coverage
- [ ] Update documentation

<h3 id="summary-ui-changes">User interface changes</h3>
{Will there be new admin pages, form fields, or UI elements?}

<h3 id="summary-api-changes">API changes</h3>
{Any new hooks, services, or public methods?}

<h3 id="summary-data-model-changes">Data model changes</h3>
{New database tables, fields, or configuration schema?}
```

### Feature Request Best Practices

1. **Explain the "why"** - Help maintainers understand the use case
2. **Be specific** - Vague requests are hard to implement
3. **Consider existing patterns** - Follow Drupal conventions
4. **Offer to help** - Maintainers appreciate contributors
5. **Accept alternatives** - Your solution might not be the best one

## Task Template

```html
<h3 id="summary-problem-motivation">Problem/Motivation</h3>
{What needs to be done and why?}

<h3 id="summary-proposed-resolution">Proposed resolution</h3>
{Approach to completing the task}

<h3 id="summary-remaining-tasks">Remaining tasks</h3>
- [ ] {Specific, testable task 1}
- [ ] {Specific, testable task 2}
- [ ] {Specific, testable task 3}
- [ ] Tests pass
- [ ] Documentation updated

<h3 id="summary-ui-changes">User interface changes</h3>
{If applicable, or "None"}

<h3 id="summary-api-changes">API changes</h3>
{If applicable, or "None"}

<h3 id="summary-data-model-changes">Data model changes</h3>
{If applicable, or "None"}
```

## Support Request Template

```html
<h3 id="summary-problem-motivation">Problem/Motivation</h3>
{What are you trying to do? What's not working as expected?}

**Environment**:
- Drupal version: {version}
- Module version: {version}
- PHP version: {version}

**What I've tried**:
1. {Approach 1}
2. {Approach 2}

<h3 id="summary-proposed-resolution">Proposed resolution</h3>
{What specific help or guidance do you need?}

<h3 id="summary-remaining-tasks">Remaining tasks</h3>
- [ ] Get answer/guidance
- [ ] Implement solution

<h3 id="summary-ui-changes">User interface changes</h3>
N/A

<h3 id="summary-api-changes">API changes</h3>
N/A

<h3 id="summary-data-model-changes">Data model changes</h3>
N/A
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
```

```html
<h3 id="summary-problem-motivation">Problem/Motivation</h3>
Saving a node with more than 3 levels of nested paragraphs causes a white screen of death.

<h4 id="summary-steps-reproduce">Steps to reproduce</h4>
1. Create a paragraph type with a nested paragraphs field
2. Create content with 4+ levels of nesting
3. Click Save

<h3 id="summary-proposed-resolution">Proposed resolution</h3>
Investigate recursion limit in paragraph rendering.

<h3 id="summary-remaining-tasks">Remaining tasks</h3>
- [ ] Confirm reproduction
- [ ] Investigate root cause
- [ ] Implement fix
- [ ] Add test

<h3 id="summary-ui-changes">User interface changes</h3>
None

<h3 id="summary-api-changes">API changes</h3>
None

<h3 id="summary-data-model-changes">Data model changes</h3>
None
```

### Example 2: Feature Request

```
User: "I want to suggest adding a feature to export paragraphs"

Title: Add ability to export paragraph configurations as YAML
```

```html
<h3 id="summary-problem-motivation">Problem/Motivation</h3>
Developers need to share paragraph type configurations between sites. Currently, this requires manually recreating configurations or using Features module.

<h3 id="summary-proposed-resolution">Proposed resolution</h3>
Add a "Export" tab to paragraph types that generates YAML configuration that can be imported via drush or admin UI.

<h3 id="summary-remaining-tasks">Remaining tasks</h3>
- [ ] Design export format
- [ ] Implement export functionality
- [ ] Add import functionality
- [ ] Add drush commands
- [ ] Document workflow

<h3 id="summary-ui-changes">User interface changes</h3>
- New "Export" tab on paragraph type edit page
- YAML textarea with copy button
- Import form at /admin/structure/paragraphs/import

<h3 id="summary-api-changes">API changes</h3>
- New service: paragraphs.config_exporter
- New drush command: paragraphs:export

<h3 id="summary-data-model-changes">Data model changes</h3>
None
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
7. **Using Markdown instead of HTML** - drupal.org expects HTML format

## Resources

- [Drupal Issue Queue Documentation](https://www.drupal.org/docs/develop/issues)
- [Issue Priority Guidelines](https://www.drupal.org/docs/develop/issues/issue-priorities)
- [Writing Good Bug Reports](https://www.drupal.org/docs/develop/issues/fields-and-other-parts-of-issues)
