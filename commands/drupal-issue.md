---
description: Create, update, or list issues on drupal.org using guided manual workflow
argument-hint: "[create|update|list] [project] [issue-number]"
allowed-tools: Read, Glob, Grep, Bash, Bash(drupalorg:*), Bash(open:*), Bash(xdg-open:*), Bash(pbcopy:*), Bash(xclip:*), Bash(wl-copy:*), Task
---

## How It Works

Spawn the **drupalorg-issue-specialist** agent to handle drupal.org issue operations:

```
Task(cms-cultivator:drupalorg-issue-specialist:drupalorg-issue-specialist,
     prompt="Execute the drupal-issue command with arguments: [arguments]. Generate properly formatted issue content using drupal.org HTML templates, copy the title to clipboard, open the issue form in the browser, and guide the user through submission. Request the issue number from the user after creation.")
```

### Workflow Steps (Guided Manual)

The drupalorg-issue-specialist uses a **clipboard + browser launch** approach because drupal.org has no write API and uses CAPTCHA protection:

#### 1. Generate Issue Content
- Gather issue details (type, title, description, version, priority)
- Format using official drupal.org HTML template structure
- Generate all standard sections (Problem/Motivation, Proposed resolution, etc.)

#### 2. Copy Title to Clipboard
- Automatically copies the issue title to your clipboard
- Works on macOS (pbcopy), Linux (xclip/wl-copy), and WSL (clip.exe)

#### 3. Open Browser to Issue Form
- Opens `https://www.drupal.org/node/add/project-issue/{project}` in your default browser
- Uses `open` (macOS), `xdg-open` (Linux), or displays URL if browser launch unavailable

#### 4. Guide User Through Submission
- Displays the complete issue description for you to copy/paste
- Lists the form settings to select (version, category, priority)
- Requests the issue number after you submit

---

## Quick Start

```bash
# Create a new issue
/drupal-issue create paragraphs

# Update issue status
/drupal-issue update paragraphs 3456789

# Add comment to issue
/drupal-issue comment paragraphs 3456789

# List your issues
/drupal-issue list

# List project issues
/drupal-issue list paragraphs
```

## Usage

### Create New Issue

```bash
/drupal-issue create {project}
```

The agent will:
1. Ask for issue details (type, title, description, version, priority)
2. Generate properly formatted HTML content
3. Copy title to clipboard
4. Open the issue creation page in your browser
5. Guide you to paste the content and submit
6. Request the issue number from you

**Example**:
```bash
/drupal-issue create paragraphs
# Agent generates content, copies title, opens browser
# You paste and submit, then reply with: 3456789
```

### Update Issue Status

```bash
/drupal-issue update {project} {issue_number}
```

The agent will:
1. Open the issue page in your browser
2. Guide you through changing the status
3. Confirm when done

**Status options**: Active, Needs work, Needs review, Fixed, Closed

### Add Comment

```bash
/drupal-issue comment {project} {issue_number}
```

The agent will:
1. Generate your comment
2. Copy it to clipboard
3. Open the issue page
4. Guide you to paste and submit

### List Issues

```bash
# List your issues
/drupal-issue list

# List project's issues
/drupal-issue list {project}
```

Uses `drupalorg-cli` if available, or opens the issue queue in your browser.

## Prerequisites

### drupal.org Account

You need a drupal.org account. Log in via your browser when the agent opens the issue pages.

### drupalorg-cli (Optional)

For listing issues, install `drupalorg-cli`:

```bash
curl -LO https://github.com/mglaman/drupalorg-cli/releases/latest/download/drupalorg.phar
chmod +x drupalorg.phar
sudo mv drupalorg.phar /usr/local/bin/drupalorg
```

## Issue Templates

The agent uses the **official drupal.org HTML template format**:

### Bug Report
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

<h3 id="summary-data-model-changes">Data model changes</h3>
None
```

### Feature Request
Similar structure focusing on Problem/Motivation and Proposed resolution sections.

## Output

### Successful Issue Creation
```markdown
**Issue Created Successfully**

**URL**: https://www.drupal.org/project/paragraphs/issues/3456789
**Issue**: #3456789
**Title**: Fix validation error in config form
**Status**: Active

**Next Steps**:
- Run `/drupal-mr paragraphs 3456789` to create a merge request
```

### Issue List
```markdown
| # | Project | Title | Status |
|---|---------|-------|--------|
| 3456789 | paragraphs | Fix validation error | Active |
| 3456790 | webform | Add export feature | Needs review |
```

## Why Guided Manual Workflow?

drupal.org:
- Has **no write API** - all issue creation/updates require the web UI
- Uses **PerimeterX CAPTCHA** protection that blocks automated browser access

The guided manual workflow:
- Works regardless of CAPTCHA or bot protection
- Uses your existing authenticated browser session
- Minimal manual effort (paste + click)
- More reliable than browser automation

## Related Commands

- **[`/drupal-mr`](drupal-mr.md)** - Create merge request for an issue
- **[`/drupal-contribute`](drupal-contribute.md)** - Full workflow (issue + MR)
- **[`/drupal-cleanup`](drupal-cleanup.md)** - Manage cloned repositories

## Agent Skill

This command uses the **drupalorg-issue-helper** skill for:
- Issue template formatting
- Best practices for bug reports
- Priority and category guidance

For quick help with issue formatting without creating an issue, the skill activates when you ask about "drupal.org issue template" or "how to write a bug report".
