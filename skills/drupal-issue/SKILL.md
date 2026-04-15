---
name: drupal-issue
description: "Create, update, or add comments to issues on drupal.org using a guided manual workflow. Invoke when user wants to create a bug report or feature request on drupal.org, says \"create a drupal.org issue\", \"open a drupal issue\", or uses /drupal-issue. Has side effects: creates publicly visible issues on drupal.org. Requires user to paste content and submit (CAPTCHA-protected). Also supports listing and updating issues."
---

# Drupal Issue

Create, update, and manage issues on drupal.org using a guided clipboard + browser workflow.

## ⚠️ Side Effect Warning

**This skill creates publicly visible content on drupal.org:**
- Issues are permanently visible on drupal.org once submitted
- The guided workflow requires you to paste content into the drupal.org web UI

**Automation is not possible** — drupal.org uses PerimeterX CAPTCHA protection. This guided workflow uses your authenticated browser session for reliable, CAPTCHA-safe submission.

## Usage

- "Create a bug report for the paragraphs module"
- "Open a drupal.org feature request for webform"
- `/drupal-issue create {project}` — Create new issue
- `/drupal-issue update {project} {issue_number}` — Update issue status
- `/drupal-issue comment {project} {issue_number}` — Add comment
- `/drupal-issue list [{project}]` — List issues

## Prerequisites

- drupal.org account (logged in via browser)
- drupalorg-cli optional (for listing issues)

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() is unavailable:

**For issue creation:**
1. **Gather issue details** — Ask for: project name, issue type (Bug/Feature/Task), title, description, Drupal version, priority
2. **Generate formatted HTML** using official drupal.org template:

   **Bug Report:**
   ```html
   <h3 id="summary-problem-motivation">Problem/Motivation</h3>
   {What's wrong?}

   <h4 id="summary-steps-reproduce">Steps to reproduce</h4>
   1. {Step 1}
   2. {Step 2}

   <h3 id="summary-proposed-resolution">Proposed resolution</h3>
   {How to fix it}

   <h3 id="summary-remaining-tasks">Remaining tasks</h3>
   - [ ] Confirm the bug
   - [ ] Write fix
   - [ ] Add tests

   <h3 id="summary-ui-changes">User interface changes</h3>
   None

   <h3 id="summary-api-changes">API changes</h3>
   None
   ```

3. **Display content** — Show complete formatted issue for copy/paste
4. **Provide URL** — `https://www.drupal.org/node/add/project-issue/{project}`
5. **Guide settings** — Issue category, version, priority dropdowns to select
6. **⛔ STOP: User pastes content, sets options, submits — then replies with issue number**
7. **Confirm success** — Display: issue URL, number, next steps

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() available:

```
Task(cms-cultivator:drupalorg-issue-specialist:drupalorg-issue-specialist,
     prompt="Execute the drupal-issue command with arguments: {arguments}. Generate properly formatted issue content using drupal.org HTML templates, copy the title to clipboard, open the issue form in the browser, and guide the user through submission. Request the issue number from the user after creation.")
```

The agent will:
- Automatically copy title to clipboard (macOS: pbcopy, Linux: xclip/wl-copy)
- Open browser to correct URL
- Guide through form field selection

## Issue Templates

### Bug Report (Key Sections)
- **Problem/Motivation**: What's wrong, when it occurs
- **Steps to reproduce**: Numbered steps to reproduce the bug
- **Proposed resolution**: How to fix it
- **Remaining tasks**: Checklist of work needed

### Feature Request (Key Sections)
- **Problem/Motivation**: Why this feature is needed
- **Proposed resolution**: What should be implemented
- **Remaining tasks**: Implementation checklist

## Priority Guide

- **Critical**: Site down, data loss, security vulnerability
- **Major**: Significant functionality broken, no workaround
- **Normal**: Standard bug or feature request (default)
- **Minor**: Small improvement, edge case

## Status Options

- **Active**: New issue or work in progress
- **Needs work**: Patch needs more work
- **Needs review**: Patch ready for review
- **Fixed**: Issue resolved (awaiting closure)
- **Closed (duplicate)**, **Closed (won't fix)**, **Closed (works as designed)**

## Related Skills

- **drupal-mr** — Create merge request for an issue
- **drupal-contribute** — Full workflow (issue + MR)
- **drupal-cleanup** — Manage cloned repositories
- **drupalorg-issue-helper** — Issue formatting guidance
