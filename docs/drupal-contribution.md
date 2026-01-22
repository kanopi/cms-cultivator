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

CMS Cultivator automates this workflow through specialized agents and commands.

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
1. Create a new issue on drupal.org
2. Clone the project to `~/.cache/drupal-contrib/paragraphs/`
3. Create the issue fork
4. Set up your branch
5. Guide you through making changes and creating the MR

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

Log into drupal.org in Chrome:
1. Open: https://www.drupal.org/user/login
2. Log in with your credentials
3. Your session persists for the agents to use

#### 6. Chrome DevTools MCP

Ensure Chrome DevTools MCP is configured in Claude Code for browser automation.

## Authentication Details

### How Authentication Works

| Service | Read Operations | Write Operations |
|---------|-----------------|------------------|
| **drupal.org** | No auth (public REST API) | Browser session cookies |
| **git.drupalcode.org** | No auth (public repos) | glab token or SSH key |

**Key point**: drupal.org has **no write API**. Issue creation/updates require browser automation using your Chrome session.

### Credential Storage

| Credential | Storage Location | Managed By |
|------------|------------------|------------|
| drupal.org credentials | `~/.config/drupalorg/credentials.yml` | You (one-time setup) |
| git.drupalcode.org token | `~/.config/glab-cli/config.yml` | glab CLI |
| SSH keys | `~/.ssh/` | You |

### Save drupal.org Credentials (Recommended)

Save your drupal.org credentials for automatic login:

```bash
# Create config directory
mkdir -p ~/.config/drupalorg

# Create credentials file
cat > ~/.config/drupalorg/credentials.yml << 'EOF'
# drupal.org credentials for CMS Cultivator
username: your-drupal-username
password: your-drupal-password
EOF

# IMPORTANT: Set secure file permissions
chmod 600 ~/.config/drupalorg/credentials.yml
```

**Security notes**:
- File is in your home directory, not the project
- `chmod 600` ensures only you can read it
- Never commit credentials to version control
- The agent reads this to auto-fill the login form

### Session Persistence

Chrome MCP does not persist cookies between sessions, but with saved credentials the agent can auto-login:

| Scenario | With Saved Credentials | Without Saved Credentials |
|----------|------------------------|---------------------------|
| Same session | Stays logged in | Stays logged in |
| New session | **Auto-login** (~5 sec) | Manual login required |
| Chrome MCP restart | **Auto-login** (~5 sec) | Manual login required |

**Recommendation**: Save credentials once for seamless experience across sessions.

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

## Workflow Details

### Issue Creation

The `drupalorg-issue-specialist` agent handles issue creation:

1. Navigates to drupal.org
2. Checks login status
3. Fills the issue form with your details
4. Presents for approval before submission
5. Returns the issue URL

**Note**: drupal.org has no write API, so browser automation is required.

### Issue Fork Creation

Issue forks must be created via the drupal.org web UI. The agent:

1. Navigates to the issue page
2. Clicks "Create issue fork"
3. Waits for confirmation

This step cannot be done via git or glab CLI.

### Merge Request Creation

The `drupalorg-mr-specialist` agent handles MR creation:

1. Clones the project (or updates existing clone)
2. Creates the issue fork via browser
3. Adds the issue fork remote
4. Creates a properly named branch
5. Pushes changes
6. Creates MR via glab CLI

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

**Purpose**: Create and manage drupal.org issues

**Tools**: Read, Glob, Grep, Bash, chrome-devtools MCP

**Skill**: drupalorg-issue-helper

### drupalorg-mr-specialist

**Purpose**: Create and manage merge requests

**Tools**: Read, Glob, Grep, Bash, chrome-devtools MCP

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

### Browser automation not working

1. Ensure Chrome is running
2. Verify Chrome DevTools MCP is configured
3. Fall back to manual instructions provided by the agent

## Resources

- [Drupal.org GitLab Guide](https://www.drupal.org/docs/develop/git/using-gitlab-to-contribute-to-drupal)
- [Creating Issue Forks](https://www.drupal.org/docs/develop/git/using-gitlab-to-contribute-to-drupal/creating-issue-forks)
- [glab CLI Documentation](https://docs.gitlab.com/cli/)
- [git.drupalcode.org](https://git.drupalcode.org)
