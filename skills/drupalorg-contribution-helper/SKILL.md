---
name: drupalorg-contribution-helper
description: Quick help with drupal.org contribution workflows including git commands, branch naming, issue fork setup, and merge request creation. Invoke when user asks "how do I contribute to drupal.org?", "drupal.org git workflow", "issue fork", "drupal merge request", or needs help with git.drupalcode.org commands.
---

# Drupal.org Contribution Helper

Quick assistance with drupal.org contribution workflows, git commands, and merge request creation.

## When to Use This Skill

Activate this skill when the user:
- Asks "how do I contribute to drupal.org?"
- Mentions "issue fork" or "drupal merge request"
- Needs help with git.drupalcode.org commands
- Asks about drupal.org branch naming conventions
- Wants to understand the drupal.org contribution workflow
- Asks about glab CLI for drupal.org

## Quick Reference

### drupalorg-cli Tool (Optional)

The `drupalorg-cli` package provides helpful shortcuts for drupal.org contribution:

```bash
# Install
curl -LO https://github.com/mglaman/drupalorg-cli/releases/latest/download/drupalorg.phar
chmod +x drupalorg.phar
sudo mv drupalorg.phar /usr/local/bin/drupalorg

# Create branch for issue (inside project directory)
drupalorg issue:branch 3456789

# Apply latest patch from issue
drupalorg issue:apply 3456789

# Generate patch from local changes
drupalorg issue:patch

# List project issues
drupalorg project:issues paragraphs

# Open issue in browser
drupalorg issue:link 3456789
```

**Note**: drupalorg-cli excels at the legacy patch workflow. For GitLab MR workflow, also use glab CLI.

### Git Clone Commands

```bash
# Clone any drupal.org project
git clone git@git.drupal.org:project/{project_name}.git

# Examples
git clone git@git.drupal.org:project/paragraphs.git
git clone git@git.drupal.org:project/webform.git
git clone git@git.drupal.org:project/easy_lqp.git
```

### Branch Naming Convention

```
{issue_number}-{description-slug}

Examples:
3456789-fix-validation-error
3456789-add-ckeditor5-support
3456789-update-documentation
```

**Rules**:
- Start with issue number
- Use hyphens (not underscores)
- Keep description brief but descriptive
- Maximum 255 characters

### Issue Fork Remote

```bash
# Add issue fork remote
git remote add issue-fork git@git.drupal.org:issue/{project}-{issue_number}.git

# Example
git remote add issue-fork git@git.drupal.org:issue/paragraphs-3456789.git

# Verify remotes
git remote -v
```

### Commit Message Format

```
Issue #{issue_number}: {description}

Example:
Issue #3456789: Fix validation error in configuration form
```

### Push to Issue Fork

```bash
# Push branch to issue fork
git push issue-fork {branch_name}

# Example
git push issue-fork 3456789-fix-validation-error
```

## Complete Workflow

### 1. Clone Project

```bash
# Clone to isolated location (recommended)
mkdir -p ~/.cache/drupal-contrib
git clone git@git.drupal.org:project/{project}.git ~/.cache/drupal-contrib/{project}
cd ~/.cache/drupal-contrib/{project}
```

### 2. Create Issue Fork (Manual Step Required)

Issue forks must be created via the drupal.org web UI. This cannot be automated due to CAPTCHA protection.

1. Go to: `https://www.drupal.org/project/{project}/issues/{issue_number}`
2. Click **"Create issue fork"** in the right sidebar
3. Wait for confirmation message (~10 seconds)

**Note**: This step cannot be done via command line or API.

### 3. Add Issue Fork Remote

```bash
git remote add issue-fork git@git.drupal.org:issue/{project}-{issue_number}.git
```

### 4. Create Branch

```bash
git checkout -b {issue_number}-{description}
```

### 5. Make Changes and Commit

```bash
# Make your code changes
# ...

# Stage and commit
git add .
git commit -m "Issue #{issue_number}: {description}"
```

### 6. Push to Issue Fork

```bash
git push issue-fork {branch_name}
```

### 7. Create Merge Request

**Option A: Using glab CLI**
```bash
glab mr create --hostname git.drupalcode.org \
  --source-branch {branch_name} \
  --target-branch main \
  --title "Issue #{issue_number}: {description}"
```

**Option B: Via Web UI**
1. Go to issue page on drupal.org
2. Click "Compare" button
3. Follow MR creation flow

## glab CLI Setup

### Installation

```bash
# macOS
brew install glab

# Linux
curl -sL https://j.mp/glab | sudo bash

# Windows
winget install glab
```

### Authentication

```bash
# Authenticate with git.drupalcode.org
glab auth login --hostname git.drupalcode.org

# Choose "Token" authentication
# Get token from: https://git.drupalcode.org/-/user_settings/personal_access_tokens
# Required scopes: api, read_user, read_repository, write_repository
```

### Verify Setup

```bash
# Check authentication status
glab auth status --hostname git.drupalcode.org
```

## Common Commands

### List Your MRs

```bash
glab mr list --hostname git.drupalcode.org --repo project/{project} --author=@me
```

### View MR Details

```bash
glab mr view {mr_number} --hostname git.drupalcode.org --repo project/{project}
```

### Check MR Status

```bash
glab mr status --hostname git.drupalcode.org --repo project/{project}
```

## Troubleshooting

### "Permission denied" on push

1. Verify SSH key is added to git.drupalcode.org:
   - Go to: https://git.drupalcode.org/-/user_settings/ssh_keys
   - Add your public key

2. Verify issue fork exists:
   - Check drupal.org issue page for "Issue fork" section

3. Verify remote is correct:
   ```bash
   git remote -v
   # Should show: issue-fork git@git.drupal.org:issue/{project}-{issue}.git
   ```

### "Issue fork not found"

You must create the issue fork via drupal.org web UI first:
1. Go to the issue page
2. Click "Create issue fork"
3. Then add the remote

### Branch Already Exists

```bash
# If local branch exists
git checkout {existing_branch}

# If remote branch exists
git fetch issue-fork
git checkout -b {branch} issue-fork/{branch}
```

### Update Existing MR

```bash
# Make additional changes
git add .
git commit -m "Issue #{issue_number}: Additional fixes"

# Push updates (existing MR updates automatically)
git push issue-fork {branch_name}
```

## Best Practices

1. **One issue = one branch = one MR**
2. **Reference issue number in every commit**
3. **Keep commits focused and atomic**
4. **Update issue status to "Needs review" after creating MR**
5. **Respond promptly to review feedback**
6. **Rebase on target branch before final merge**

## Example Interactions

**Example 1: Quick Workflow Question**
```
User: "How do I create a merge request for drupal.org?"

Skill response:
1. Clone the project
2. Create issue fork on drupal.org (click button in web UI - required manual step)
3. Add remote: `git remote add issue-fork git@git.drupal.org:issue/{project}-{issue}.git`
4. Create branch: `git checkout -b {issue_number}-{description}`
5. Commit with: `Issue #{issue_number}: description`
6. Push: `git push issue-fork {branch}`
7. Create MR via glab or drupal.org UI
```

**Example 2: Branch Naming Help**
```
User: "What should I name my branch for issue 3456789?"

Skill response:
Use: `3456789-{brief-description}`

Examples:
- `3456789-fix-validation`
- `3456789-update-docs`
- `3456789-add-feature`

Create it with:
```bash
git checkout -b 3456789-your-description
```
```

**Example 3: Remote Setup Help**
```
User: "I created the issue fork, now what?"

Skill response:
Add the issue fork as a remote:

```bash
git remote add issue-fork git@git.drupal.org:issue/{project}-{issue_number}.git
```

Replace `{project}` with your project name and `{issue_number}` with your issue number.

Then push your branch:
```bash
git push issue-fork {your-branch-name}
```
```

## Resources

- [Drupal.org GitLab Guide](https://www.drupal.org/docs/develop/git/using-gitlab-to-contribute-to-drupal)
- [Creating Issue Forks](https://www.drupal.org/docs/develop/git/using-gitlab-to-contribute-to-drupal/creating-issue-forks)
- [glab CLI Documentation](https://docs.gitlab.com/cli/)
- [git.drupalcode.org](https://git.drupalcode.org)
