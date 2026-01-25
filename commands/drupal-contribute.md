---
description: Full drupal.org contribution workflow - create issue and merge request together
argument-hint: "{project} [issue-number]"
allowed-tools: Read, Glob, Grep, Bash(git:*), Bash(ssh:*), Bash(mkdir:*), Bash(open:*), Bash(xdg-open:*), Bash(pbcopy:*), Bash(xclip:*), Bash(curl:*), Task
---

## How It Works

This command orchestrates the complete drupal.org contribution workflow by spawning both specialist agents in sequence:

```
1. Task(cms-cultivator:drupalorg-issue-specialist:drupalorg-issue-specialist,
       prompt="Create a new issue for {project}. Generate issue content using drupal.org HTML templates, copy title to clipboard, open browser, guide user through submission, and return the issue number.")

2. Task(cms-cultivator:drupalorg-mr-specialist:drupalorg-mr-specialist,
       prompt="Create a merge request for {project} issue #{issue_number}. Clone repo, guide user through manual fork creation, set up branch, push changes, and provide MR creation URL.")
```

### Workflow Steps

#### Phase 1: Issue Creation (drupalorg-issue-specialist)
1. Gather issue details (type, title, description, version, priority)
2. Generate properly formatted HTML content
3. Copy title to clipboard
4. Open browser to issue creation page
5. **User interaction**: Paste content and submit
6. **User provides**: Issue number (e.g., `3456789`)

#### Phase 2: Merge Request Creation (drupalorg-mr-specialist)
1. Check SSH connectivity
2. Clone project to `~/.cache/drupal-contrib/{project}/`
3. Open issue page for fork creation
4. **User interaction**: Click "Create issue fork"
5. **User confirms**: "done"
6. Add issue fork remote (named `{project}-{issue}`)
7. Fetch from fork
8. Create branch: `{issue_number}-{description}`
9. Set up for code changes
10. Push and provide MR creation URL from git output

---

## Quick Start

```bash
# Start new contribution (creates issue, sets up for MR)
/drupal-contribute paragraphs

# Continue existing issue (skip to MR)
/drupal-contribute paragraphs 3456789
```

## Usage

### New Contribution (Issue + MR Setup)

```bash
/drupal-contribute {project}
```

This will:
1. Create a new issue on drupal.org (guided manual workflow)
2. Clone the project to `~/.cache/drupal-contrib/{project}/`
3. Guide you through creating the issue fork
4. Set up your branch
5. Return both URLs and next steps

**Example**:
```bash
/drupal-contribute paragraphs
```

### Existing Issue (MR Only)

```bash
/drupal-contribute {project} {issue_number}
```

Skips issue creation and goes straight to MR setup:
1. Clone project (if not already cloned)
2. Guide you through issue fork creation
3. Set up branch for the issue
4. Return setup instructions

**Example**:
```bash
/drupal-contribute paragraphs 3456789
```

## User Interaction Points

This workflow requires two manual interactions due to drupal.org's CAPTCHA protection:

### 1. Issue Creation (Phase 1)
- **When**: After agent generates issue content
- **What**: Paste title and description into the drupal.org form, submit
- **Then**: Reply with the issue number (e.g., `3456789`)

### 2. Issue Fork Creation (Phase 2)
- **When**: After agent opens the issue page
- **What**: Click "Create issue fork" button in the right sidebar
- **Then**: Reply "done" when the fork is created

## Complete Workflow Example

### Step 1: Run Command
```bash
/drupal-contribute paragraphs
```

### Step 2: Provide Issue Details
The agent will ask for:
- Issue type (Bug report, Feature request, Task)
- Title
- Description
- Drupal/module version
- Priority

### Step 3: Create Issue
- Agent copies title to clipboard, opens browser
- You paste and submit the issue
- You reply with the issue number

### Step 4: Create Issue Fork
- Agent opens the issue page
- You click "Create issue fork"
- You reply "done"

### Step 5: Make Code Changes
Navigate to the cloned repo and make your changes:
```bash
cd ~/.cache/drupal-contrib/paragraphs
# Edit files...
```

### Step 6: Commit and Push
```bash
git add .
git commit -m "Issue #3456789: Fix validation error"
git push paragraphs-3456789 3456789-fix-validation-error
```

### Step 7: Create MR
Git outputs the MR creation URL when you push. Open it in your browser to complete the MR.

## Prerequisites

### For Issue Creation
- **drupal.org account** - Log in via browser when prompted

### For MR Creation
- **SSH key** - Added to git.drupalcode.org
- Or **HTTPS with token** - For networks blocking SSH port 22

### One-Time Setup

```bash
# Verify SSH connectivity
ssh -T git@git.drupal.org

# If SSH fails, add your key at:
# https://git.drupalcode.org/-/user_settings/ssh_keys
```

See individual commands for more details:
- [`/drupal-issue`](drupal-issue.md) - Issue prerequisites
- [`/drupal-mr`](drupal-mr.md) - MR prerequisites

## Output

### Successful Completion

```markdown
**Drupal.org Contribution Setup Complete**

**Issue**: #3456789
**Issue URL**: https://www.drupal.org/project/paragraphs/issues/3456789
**Title**: Fix validation error in config form

**Repository**: ~/.cache/drupal-contrib/paragraphs/
**Branch**: 3456789-fix-validation-error
**Issue Fork Remote**: paragraphs-3456789

**Next Steps**:

1. **Make your changes**:
   ```bash
   cd ~/.cache/drupal-contrib/paragraphs
   # Edit files...
   ```

2. **Commit**:
   ```bash
   git add .
   git commit -m "Issue #3456789: Fix validation error"
   ```

3. **Push**:
   ```bash
   git push paragraphs-3456789 3456789-fix-validation-error
   ```

4. **Create MR**:
   Open the URL from git push output in your browser to complete MR creation.

5. **Update issue status** to "Needs review" on drupal.org
```

## When to Use Each Command

| Scenario | Command |
|----------|---------|
| New contribution (need issue + MR) | `/drupal-contribute {project}` |
| Existing issue, need MR | `/drupal-contribute {project} {issue}` or `/drupal-mr {project} {issue}` |
| Just create an issue | `/drupal-issue create {project}` |
| Just create MR for existing issue | `/drupal-mr {project} {issue}` |
| List/cleanup repos | `/drupal-cleanup` |

## Error Handling

### Missing Prerequisites
The command checks prerequisites at each phase and provides setup instructions if anything is missing.

### Partial Completion
If issue creation succeeds but MR setup fails:
- The issue URL is returned
- You can retry MR setup with `/drupal-mr {project} {issue_number}`

### Browser/Clipboard Not Available
Falls back to displaying URLs and content for manual copy/paste.

## Related Commands

- **[`/drupal-issue`](drupal-issue.md)** - Issue operations only
- **[`/drupal-mr`](drupal-mr.md)** - MR operations only
- **[`/drupal-cleanup`](drupal-cleanup.md)** - Manage cloned repos

## Skills Used

This command uses both skills:
- **drupalorg-issue-helper** - Issue templates and formatting
- **drupalorg-contribution-helper** - Git workflow and branch conventions
