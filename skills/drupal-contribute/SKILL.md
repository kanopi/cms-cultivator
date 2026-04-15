---
name: drupal-contribute
description: "Full drupal.org contribution workflow — create an issue and set up a merge request together. Invoke when user wants to contribute to a Drupal module, says \"contribute to drupal.org\", \"create a drupal.org issue and MR\", or uses /drupal-contribute. Requires user interaction at two manual steps (CAPTCHA-protected issue creation and issue fork creation). Has side effects: clones repos to ~/.cache/drupal-contrib/ and creates drupal.org issues."
---

# Drupal Contribute

Full drupal.org contribution workflow — create an issue and set up a merge request in one workflow.

## ⚠️ Side Effect Warning

**This skill has external side effects:**
- Creates a new issue on drupal.org (publicly visible)
- Clones the project repository to `~/.cache/drupal-contrib/{project}/`
- Pushes to an issue fork on git.drupalcode.org

**Two manual interaction points are required** (CAPTCHA protection prevents automation):
1. You paste and submit the issue on drupal.org
2. You click "Create issue fork" on the issue page

## Usage

- "Contribute to the paragraphs module — create an issue and MR"
- "Start a new drupal.org contribution for the webform module"
- `/drupal-contribute {project} [issue-number]`

**If issue already exists**: `/drupal-contribute paragraphs 3456789` (skips to MR setup)

## Prerequisites

- drupal.org account (logged in via browser)
- SSH key added to git.drupalcode.org (for MR setup)
- Or HTTPS token from git.drupalcode.org (if SSH blocked)

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() is unavailable:

1. **Gather issue details** — Ask user for: issue type, title, description, Drupal/module version, priority
2. **Generate issue content** — Format using official drupal.org HTML template:
   ```html
   <h3 id="summary-problem-motivation">Problem/Motivation</h3>
   {description}
   <h3 id="summary-proposed-resolution">Proposed resolution</h3>
   {resolution}
   <h3 id="summary-remaining-tasks">Remaining tasks</h3>
   - [ ] Confirm the bug
   - [ ] Write fix
   - [ ] Add tests
   ```
3. **Display for manual submission** — Show complete formatted content for copy/paste
4. **Provide issue URL** — `https://www.drupal.org/node/add/project-issue/{project}`
5. **⛔ STOP: User pastes content and submits issue, then replies with issue number**
6. **Guide MR setup** — Provide git commands:
   ```bash
   git clone git@git.drupal.org:project/{project}.git ~/.cache/drupal-contrib/{project}
   cd ~/.cache/drupal-contrib/{project}
   # User creates issue fork at: https://www.drupal.org/project/{project}/issues/{issue_number}
   git remote add {project}-{issue} git@git.drupal.org:issue/{project}-{issue_number}.git
   git fetch {project}-{issue_number}
   git checkout -b {issue_number}-{description-slug}
   ```
7. **⛔ STOP: User creates issue fork, replies "done"**
8. **Provide push command**:
   ```bash
   git push {project}-{issue_number} {branch_name}
   # Git outputs MR creation URL — open in browser to complete
   ```

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() and git available:

**Phase 1 — Issue Creation**:
```
Task(cms-cultivator:drupalorg-issue-specialist:drupalorg-issue-specialist,
     prompt="Create a new issue for {project}. Generate issue content using drupal.org HTML templates, copy title to clipboard, open browser, guide user through submission, and return the issue number.")
```

**Phase 2 — MR Setup** (after user provides issue number):
```
Task(cms-cultivator:drupalorg-mr-specialist:drupalorg-mr-specialist,
     prompt="Create a merge request for {project} issue #{issue_number}. Clone repo, guide user through manual fork creation, set up branch, push changes, and provide MR creation URL.")
```

## Contribution Workflow

### New Contribution (Issue + MR)
1. Agent generates issue content and opens browser
2. **You paste and submit** — reply with issue number
3. Agent opens issue page for fork creation
4. **You click "Create issue fork"** — reply "done"
5. Agent sets up branch and remote
6. Make your code changes in `~/.cache/drupal-contrib/{project}/`
7. Commit and push (git outputs MR URL automatically)
8. Open MR URL in browser to complete creation

### Existing Issue (MR Only)
Use `/drupal-contribute {project} {issue_number}` to skip issue creation.

## Related Skills

- **drupal-issue** — Issue operations only
- **drupal-mr** — MR operations only
- **drupal-cleanup** — Manage cloned repositories
- **drupalorg-issue-helper** — Issue template guidance
- **drupalorg-contribution-helper** — Git workflow guidance
