---
description: Create or list merge requests for drupal.org projects via git.drupalcode.org
argument-hint: "[project] [issue-number] | list [project]"
allowed-tools: Read, Glob, Grep, Bash(git:*), Bash(ssh:*), Bash(drupalorg:*), Bash(mkdir:*), Bash(ls:*), Bash(cd:*), Bash(open:*), Bash(xdg-open:*), Bash(pbcopy:*), Bash(xclip:*), Bash(curl:*), Task
---

## How It Works

Spawn the **drupalorg-mr-specialist** agent to handle merge request operations:

```
Task(cms-cultivator:drupalorg-mr-specialist:drupalorg-mr-specialist,
     prompt="Execute the drupal-mr command with arguments: [arguments]. Check prerequisites (SSH key), clone project to ~/.cache/drupal-contrib/ if needed, guide user through manual issue fork creation, set up branch, push changes, and provide MR creation URL. Return MR URL and next steps.")
```

### Workflow Steps

The drupalorg-mr-specialist handles git operations automatically but requires **one manual step** for issue fork creation:

#### 1. Prerequisites Check
- Verify SSH key connectivity: `ssh -T git@git.drupal.org`
- Guide through SSH key setup if needed

#### 2. Clone/Update Repository
- Clone to `~/.cache/drupal-contrib/{project}/`
- Or update existing clone with `git fetch --all`

#### 3. Create Issue Fork (Manual Step)
- Opens the issue page in your browser
- You click "Create issue fork" button in the right sidebar
- Reply "done" when the fork is created

**Note**: Issue fork creation requires the drupal.org web UI and cannot be automated due to CAPTCHA protection.

#### 4. Set Up Branch and Remote
- Add issue fork remote: `git remote add {project}-{issue} git@git.drupal.org:issue/{project}-{issue}.git`
- Fetch from fork: `git fetch {project}-{issue}`
- Create branch: `git checkout -b {issue_number}-{description}`

#### 5. Push and Create MR
- Push to issue fork: `git push {project}-{issue} {branch}`
- Git outputs the MR creation URL automatically
- Open that URL in browser to complete MR creation

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
2. Open the issue page for you to create the issue fork
3. Wait for your confirmation ("done")
4. Add the issue fork remote (named `{project}-{issue}`)
5. Fetch from the fork
6. Create branch: `{issue_number}-{description}`
7. Push to issue fork
8. Provide MR creation URL from git push output
9. Open URL in browser for you to complete MR creation

### List Merge Requests

```bash
# List all your MRs across cloned projects
/drupal-mr list

# List MRs for specific project
/drupal-mr list {project}
```

## Prerequisites

### SSH Key

Ensure your SSH key is added to git.drupalcode.org:
1. Go to: https://git.drupalcode.org/-/user_settings/ssh_keys
2. Add your public key (`~/.ssh/id_rsa.pub` or `~/.ssh/id_ed25519.pub`)

Verify connectivity:
```bash
ssh -T git@git.drupal.org
```

### HTTPS Fallback (Optional)

If your network blocks SSH port 22, use HTTPS with a personal access token:

1. Create token at: https://git.drupalcode.org/-/user_settings/personal_access_tokens
2. Required scopes: `read_repository`, `write_repository`
3. Use HTTPS remote URLs instead:
   ```bash
   git remote set-url {project}-{issue} \
     "https://{username}:{token}@git.drupalcode.org/issue/{project}-{issue}.git"
   ```

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
**Merge Request Ready**

**Project**: paragraphs
**Issue**: #3456789
**Branch**: 3456789-fix-validation-error

**MR Creation URL**: https://git.drupalcode.org/issue/paragraphs-3456789/-/merge_requests/new?merge_request%5Bsource_branch%5D=3456789-fix-validation-error

Opening URL in browser... Complete the MR creation in the web UI.

**Local repo**: ~/.cache/drupal-contrib/paragraphs/

**To continue working**:
```bash
cd ~/.cache/drupal-contrib/paragraphs
git checkout 3456789-fix-validation-error
# Make changes
git add . && git commit -m "Issue #3456789: updates"
git push paragraphs-3456789 3456789-fix-validation-error
```

**Next Steps**:
1. Complete MR creation in browser
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
git push {project}-{issue} {branch_name}
```

The MR updates automatically when you push to the branch.

## Error Handling

### SSH Connection Failed

The agent guides you through:
1. Generating an SSH key if needed
2. Adding key to git.drupalcode.org
3. Testing connectivity with `ssh -T git@git.drupal.org`
4. Optionally using HTTPS fallback with token

### Issue Fork Not Created

The agent opens the issue page and provides instructions to create the fork manually.

### Push Failed

Common causes and solutions:
1. **Remote not added**: `git remote add {project}-{issue} git@git.drupal.org:issue/{project}-{issue}.git`
2. **SSH key not configured**: Add key to git.drupalcode.org
3. **Network blocks SSH**: Use HTTPS with token fallback

## Related Commands

- **[`/drupal-issue`](drupal-issue.md)** - Create issue first
- **[`/drupal-contribute`](drupal-contribute.md)** - Full workflow (issue + MR)
- **[`/drupal-cleanup`](drupal-cleanup.md)** - Clean up cloned repos

## Agent Skill

This command uses the **drupalorg-contribution-helper** skill for:
- Git workflow guidance
- Branch naming conventions
- Native git commands for drupal.org

For quick help with drupal.org git workflows, the skill activates when you ask about "drupal.org contribution" or "issue fork".
