# Drupal.org Contribution Integration

CMS Cultivator provides specialized commands and agents for contributing to drupal.org projects, including issue creation, merge request management, and the complete contribution workflow.

## Overview

Contributing to drupal.org involves a specific workflow:

1. **Create an issue** on drupal.org (bug report, feature request, etc.)
2. **Create an issue fork** via the drupal.org web UI
3. **Clone the project** and set up the issue fork remote
4. **Create a branch** following naming conventions
5. **Make changes** and commit
6. **Push to the issue fork** and create a merge request

CMS Cultivator automates most of this workflow, with **two manual steps** required due to drupal.org's CAPTCHA protection.

## Commands

| Command | Purpose |
|---------|---------|
| `/drupal-issue` | Create, update, or list issues on drupal.org |
| `/drupal-mr` | Create or list merge requests on git.drupalcode.org |
| `/drupal-contribute` | Full workflow orchestrator (issue + MR) |
| `/drupal-cleanup` | List and cleanup cloned repositories |

## Quick Start

### New Contribution

Start a complete contribution workflow:

```bash
/drupal-contribute paragraphs
```

This will:
1. Generate issue content and copy title to clipboard
2. Open browser for you to create the issue
3. Clone the project to `~/.cache/drupal-contrib/paragraphs/`
4. Guide you through creating the issue fork
5. Set up your branch
6. Create MR via glab CLI

### Existing Issue

If you already have an issue, create just the MR:

```bash
/drupal-mr paragraphs 3456789
```

### Issue Only

Create only an issue (no MR setup):

```bash
/drupal-issue create paragraphs
```

## User Interaction Points

The workflow requires **two manual interactions** due to drupal.org's CAPTCHA protection:

### 1. Issue Creation
- **When**: After agent generates issue content
- **What**: Paste title (from clipboard) and description into drupal.org form
- **Then**: Reply with the issue number (e.g., `3456789`)

### 2. Issue Fork Creation
- **When**: After agent opens the issue page
- **What**: Click "Create issue fork" button in right sidebar
- **Then**: Reply "done" when the fork is created

## Prerequisites

### One-Time Setup

#### 1. glab CLI

Install the GitLab CLI tool:

```bash
# macOS
brew install glab

# Linux
curl -sL https://j.mp/glab | sudo bash

# Windows
winget install glab
```

#### 2. glab Authentication

Authenticate with git.drupalcode.org:

```bash
glab auth login --hostname git.drupalcode.org
```

1. Choose "Token" authentication
2. Get token from: https://git.drupalcode.org/-/user_settings/personal_access_tokens
3. Required scopes: `api`, `read_user`, `read_repository`, `write_repository`

Verify setup:
```bash
glab auth status --hostname git.drupalcode.org
```

#### 3. drupalorg-cli (Optional but Recommended)

The `drupalorg-cli` tool provides additional commands for drupal.org workflows:

```bash
# Download and install
curl -LO https://github.com/mglaman/drupalorg-cli/releases/latest/download/drupalorg.phar
chmod +x drupalorg.phar
sudo mv drupalorg.phar /usr/local/bin/drupalorg

# Verify installation
drupalorg --version
```

**Useful commands**:
- `drupalorg project:issues {project}` - List project issues
- `drupalorg issue:branch {issue}` - Create branch for issue
- `drupalorg issue:apply {issue}` - Apply patch from issue
- `drupalorg issue:link {issue}` - Open issue in browser

See: https://github.com/mglaman/drupalorg-cli

#### 4. SSH Key

Add your SSH key to git.drupalcode.org:
1. Go to: https://git.drupalcode.org/-/user_settings/ssh_keys
2. Add your public key

#### 5. drupal.org Account

You need a drupal.org account. Log in via your browser when prompted during the workflow.

## How It Works

### Guided Manual Workflow

Unlike browser automation approaches, CMS Cultivator uses a **"guided manual" workflow** for drupal.org interactions:

1. **Agent generates content** - Issue templates, MR descriptions, etc.
2. **Copies to clipboard** - Title or content automatically copied
3. **Opens browser** - Navigates to the correct drupal.org page
4. **Guides user** - Clear instructions for what to do
5. **Waits for confirmation** - User confirms completion

**Why this approach?**
- drupal.org has **no write API** - all issue creation/updates require the web UI
- drupal.org uses **PerimeterX CAPTCHA** protection that blocks automated browser access
- The guided manual workflow is **more reliable** than fighting bot detection
- Uses your **existing authenticated browser session**
- **Minimal manual effort** - just paste and click

### What's Automated

| Operation | Automated? | Notes |
|-----------|------------|-------|
| Git clone/fetch | ✅ Yes | Clones to ~/.cache/drupal-contrib/ |
| Branch creation | ✅ Yes | Follows naming convention |
| Commit/push | ✅ Yes | Standard git operations |
| MR creation (glab) | ✅ Yes | Via glab CLI |
| Issue content generation | ✅ Yes | Using drupal.org HTML templates |
| Issue submission | ❌ Manual | Paste and submit |
| Issue fork creation | ❌ Manual | Click button in sidebar |
| Issue status updates | ❌ Manual | Change dropdown in UI |

## Repository Management

### Clone Location

All drupal.org projects are cloned to:
```
~/.cache/drupal-contrib/
```

This keeps contribution work separate from your main projects and persists across sessions.

### Viewing Cloned Repos

```bash
/drupal-cleanup
```

Shows all cloned repositories with their size, branches, and status.

### Cleaning Up

Remove a specific project:
```bash
/drupal-cleanup paragraphs
```

Remove all cloned repos:
```bash
/drupal-cleanup --all
```

## Branch Naming Convention

Drupal.org branches follow this pattern:
```
{issue_number}-{description-slug}

Examples:
3456789-fix-validation-error
3456789-add-ckeditor5-support
3456789-update-documentation
```

## Commit Message Format

Always reference the issue number:
```
Issue #{issue_number}: {description}

Example:
Issue #3456789: Fix validation error in configuration form
```

## Issue Status Flow

```
Active → Needs work → Needs review → RTBC → Fixed → Closed
```

After creating an MR, update the issue status to "Needs review".

## Agents

### drupalorg-issue-specialist

**Purpose**: Create and manage drupal.org issues using guided manual workflow

**Tools**: Read, Glob, Grep, Bash

**Skill**: drupalorg-issue-helper

### drupalorg-mr-specialist

**Purpose**: Create and manage merge requests

**Tools**: Read, Glob, Grep, Bash

**Skill**: drupalorg-contribution-helper

## Skills

### drupalorg-issue-helper

Quick help with issue templates and formatting. Activates when you ask about:
- "How do I write a bug report?"
- "drupal.org issue template"
- Issue priorities and categories

### drupalorg-contribution-helper

Quick help with git workflows and branch naming. Activates when you ask about:
- "How do I contribute to drupal.org?"
- "Issue fork" setup
- Branch naming conventions

## Troubleshooting

### "glab not found"

Install glab CLI:
```bash
brew install glab  # macOS
```

### "Not authenticated"

Re-authenticate:
```bash
glab auth login --hostname git.drupalcode.org
```

### "Issue fork not found"

Create the issue fork manually:
1. Go to the issue page on drupal.org
2. Click "Create issue fork" in the sidebar

### "Permission denied" on push

1. Verify SSH key is added to git.drupalcode.org
2. Verify issue fork exists
3. Check remote is correct: `git remote -v`

### Browser doesn't open

The agent will display the URL for you to copy/paste manually.

### Clipboard doesn't work

The agent will display the content for you to copy manually.

## Resources

- [Drupal.org GitLab Guide](https://www.drupal.org/docs/develop/git/using-gitlab-to-contribute-to-drupal)
- [Creating Issue Forks](https://www.drupal.org/docs/develop/git/using-gitlab-to-contribute-to-drupal/creating-issue-forks)
- [glab CLI Documentation](https://docs.gitlab.com/cli/)
- [git.drupalcode.org](https://git.drupalcode.org)
