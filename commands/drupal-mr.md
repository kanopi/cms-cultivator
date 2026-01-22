---
description: Create or list merge requests for drupal.org projects via git.drupalcode.org
argument-hint: "[project] [issue-number] | list [project]"
allowed-tools: Read, Glob, Grep, Bash(git:*), Bash(glab:*), Bash(drupalorg:*), Bash(mkdir:*), Bash(ls:*), Bash(cd:*), chrome-devtools MCP, Task
---

## How It Works

Spawn the **drupalorg-mr-specialist** agent to handle merge request operations:

```
Task(cms-cultivator:drupalorg-mr-specialist:drupalorg-mr-specialist,
     prompt="Execute the drupal-mr command with arguments: [arguments]. Check prerequisites (glab CLI, authentication), clone project to ~/.cache/drupal-contrib/ if needed, create issue fork via browser automation, set up branch, and create MR. Return MR URL and next steps.")
```

### Workflow Steps (Automated)

The drupalorg-mr-specialist automatically executes these steps:

#### 1. Prerequisites Check
- Verify glab CLI is installed
- Check authentication: `glab auth status --hostname git.drupalcode.org`
- Guide through one-time setup if needed

#### 2. Clone/Update Repository
- Clone to `~/.cache/drupal-contrib/{project}/`
- Or update existing clone with `git fetch --all`

#### 3. Create Issue Fork (Browser Automation)
- Navigate to drupal.org issue page
- Click "Create issue fork" button
- Wait for fork creation confirmation

#### 4. Set Up Branch and Remote
- Add issue fork remote: `git remote add issue-fork git@git.drupal.org:issue/{project}-{issue}.git`
- Create branch: `git checkout -b {issue_number}-{description}`

#### 5. Push and Create MR
- Push to issue fork: `git push issue-fork {branch}`
- Create MR via glab CLI or browser fallback

---

## Quick Start

```bash
# Create MR for an issue
/drupal-mr paragraphs 3456789

# List your MRs
/drupal-mr list

# List MRs for specific project
/drupal-mr list paragraphs
```

## Usage

### Create Merge Request

```bash
/drupal-mr {project} {issue_number}
```

**Examples**:
```bash
/drupal-mr paragraphs 3456789
/drupal-mr webform 3456790
/drupal-mr easy_lqp 3456791
```

The agent will:
1. Clone the project to `~/.cache/drupal-contrib/{project}/`
2. Create issue fork on drupal.org (via browser)
3. Create branch: `{issue_number}-{description}`
4. Push to issue fork
5. Create MR via glab CLI
6. Return MR URL

### List Merge Requests

```bash
# List all your MRs across cloned projects
/drupal-mr list

# List MRs for specific project
/drupal-mr list {project}
```

## Prerequisites

### glab CLI

Install the GitLab CLI:

```bash
# macOS
brew install glab

# Linux
curl -sL https://j.mp/glab | sudo bash

# Windows
winget install glab
```

### Authentication (One-Time Setup)

```bash
# Authenticate with git.drupalcode.org
glab auth login --hostname git.drupalcode.org
```

1. Choose "Token" authentication
2. Get token from: https://git.drupalcode.org/-/user_settings/personal_access_tokens
3. Required scopes: `api`, `read_user`, `read_repository`, `write_repository`

Verify setup:
```bash
glab auth status --hostname git.drupalcode.org
```

### SSH Key

Ensure your SSH key is added to git.drupalcode.org:
1. Go to: https://git.drupalcode.org/-/user_settings/ssh_keys
2. Add your public key (`~/.ssh/id_rsa.pub` or `~/.ssh/id_ed25519.pub`)

### drupalorg-cli (Optional)

The `drupalorg-cli` tool provides additional shortcuts:

```bash
# Install
curl -LO https://github.com/mglaman/drupalorg-cli/releases/latest/download/drupalorg.phar
chmod +x drupalorg.phar
sudo mv drupalorg.phar /usr/local/bin/drupalorg
```

Useful commands:
- `drupalorg issue:branch {issue}` - Create branch for issue
- `drupalorg issue:apply {issue}` - Apply patch from issue
- `drupalorg project:releases {project}` - Show releases

### Chrome DevTools MCP

Required for creating issue forks (drupal.org requires web UI for this step).

## Clone Location

Projects are cloned to `~/.cache/drupal-contrib/` to:
- Avoid conflicts with your current project
- Persist across sessions
- Allow working on multiple contrib projects

```bash
~/.cache/drupal-contrib/
├── paragraphs/
├── webform/
└── easy_lqp/
```

## Branch Naming

Branches follow drupal.org convention:
```
{issue_number}-{description-slug}

Examples:
3456789-fix-validation-error
3456789-add-ckeditor5-support
```

## Output

### Successful MR Creation

```markdown
**Merge Request Created**

**Project**: paragraphs
**Issue**: #3456789
**MR URL**: https://git.drupalcode.org/issue/paragraphs-3456789/-/merge_requests/1
**Branch**: 3456789-fix-validation-error

**Local repo**: ~/.cache/drupal-contrib/paragraphs/

**To continue working**:
```bash
cd ~/.cache/drupal-contrib/paragraphs
git checkout 3456789-fix-validation-error
# Make changes
git add . && git commit -m "Issue #3456789: updates"
git push issue-fork 3456789-fix-validation-error
```

**Next Steps**:
1. Review MR at the URL above
2. Update drupal.org issue status to "Needs review"
3. Respond to review feedback
```

### MR List

```markdown
**Your Drupal.org Merge Requests**

| Project | Issue | MR | Status | Branch |
|---------|-------|-----|--------|--------|
| paragraphs | #3456789 | !1 | Open | 3456789-fix-validation |
| webform | #3456790 | !2 | Merged | 3456790-add-feature |
```

## Resume Work on Existing MR

If you need to continue working on an existing MR:

```bash
cd ~/.cache/drupal-contrib/{project}
git fetch --all
git checkout {branch_name}
# Make changes
git add . && git commit -m "Issue #{issue}: additional fixes"
git push issue-fork {branch_name}
```

The MR updates automatically when you push to the branch.

## Error Handling

### glab Not Installed

The agent provides installation instructions for your platform.

### Not Authenticated

The agent guides you through:
1. Creating a personal access token
2. Running `glab auth login`
3. Verifying with `glab auth status`

### Issue Fork Not Created

The agent uses browser automation to create the fork, or provides manual instructions if browser automation is unavailable.

## Related Commands

- **[`/drupal-issue`](drupal-issue.md)** - Create issue first
- **[`/drupal-contribute`](drupal-contribute.md)** - Full workflow (issue + MR)
- **[`/drupal-cleanup`](drupal-cleanup.md)** - Clean up cloned repos

## Agent Skill

This command uses the **drupalorg-contribution-helper** skill for:
- Git workflow guidance
- Branch naming conventions
- glab CLI commands

For quick help with drupal.org git workflows, the skill activates when you ask about "drupal.org contribution" or "issue fork".
