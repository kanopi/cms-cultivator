---
description: Create, update, or list issues on drupal.org using browser automation
argument-hint: "[create|update|list] [project] [issue-number]"
allowed-tools: Read, Glob, Grep, Bash, Bash(drupalorg:*), chrome-devtools MCP, Task
---

## How It Works

Spawn the **drupalorg-issue-specialist** agent to handle drupal.org issue operations:

```
Task(cms-cultivator:drupalorg-issue-specialist:drupalorg-issue-specialist,
     prompt="Execute the drupal-issue command with arguments: [arguments]. Check Chrome DevTools MCP availability, verify drupal.org login status, then perform the requested operation (create, update, or list). Present issue content for approval before submission. Return issue URL on success.")
```

### Workflow Steps (Automated)

The drupalorg-issue-specialist automatically executes these steps:

#### 1. Prerequisites Check
- Verify Chrome DevTools MCP is available
- Navigate to drupal.org
- Check login status (guide user to log in if needed)

#### 2. Execute Operation

**Create Issue**:
1. Navigate to issue creation page: `https://www.drupal.org/node/add/project-issue/{project}`
2. Fill form fields (title, description, version, category, priority)
3. Present content for user approval
4. Submit and return issue URL

**Update Issue**:
1. Navigate to issue page
2. Find and modify requested field (status, comment, etc.)
3. Submit change

**List Issues**:
1. Navigate to issue list page
2. Parse and display results

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
2. Navigate to drupal.org issue form
3. Fill in the form
4. Present for your approval
5. Submit and return the issue URL

**Example**:
```bash
/drupal-issue create paragraphs
# Agent prompts for: title, description, version, type, priority
# Returns: https://www.drupal.org/project/paragraphs/issues/3456789
```

### Update Issue Status

```bash
/drupal-issue update {project} {issue_number}
```

The agent will:
1. Navigate to the issue
2. Ask which field to update
3. Make the change
4. Confirm success

**Status options**: Active, Needs work, Needs review, Fixed, Closed

### Add Comment

```bash
/drupal-issue comment {project} {issue_number}
```

The agent will:
1. Navigate to the issue
2. Ask for your comment
3. Post the comment
4. Confirm success

### List Issues

```bash
# List your issues
/drupal-issue list

# List project's issues
/drupal-issue list {project}
```

## Prerequisites

### Chrome DevTools MCP

This command requires Chrome DevTools MCP for browser automation. Drupal.org's issue tracker has no write API.

**Setup**:
1. Ensure Chrome is running with DevTools enabled
2. Chrome DevTools MCP must be configured in Claude Code

### drupal.org Account

You need a drupal.org account. The agent will:
1. Check if you're logged in
2. If not logged in and credentials are saved, auto-login
3. If no saved credentials, prompt you to log in manually

**Save credentials for auto-login** (recommended):
```bash
mkdir -p ~/.config/drupalorg
cat > ~/.config/drupalorg/credentials.yml << 'EOF'
username: your-username
password: your-password
EOF
chmod 600 ~/.config/drupalorg/credentials.yml
```

## Issue Templates

The agent uses these templates when creating issues:

### Bug Report
```markdown
## Problem/Motivation
{What's wrong?}

## Steps to Reproduce
1. {Step 1}
2. {Step 2}

## Expected vs Actual Behavior
{What should happen vs what does happen}

## Environment
- Drupal: {version}
- Module: {version}
- PHP: {version}
```

### Feature Request
```markdown
## Problem/Motivation
{Why is this needed?}

## Proposed Resolution
{How should it work?}

## API/UI Changes
{What changes are required?}
```

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

## Error Handling

### Not Logged In
The agent will guide you to log in:
1. Open https://www.drupal.org/user/login
2. Log in with your credentials
3. Let the agent know when done

### Chrome DevTools MCP Unavailable
The agent provides manual instructions with pre-filled content:
- Direct link to issue form
- Pre-formatted description to copy/paste

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
