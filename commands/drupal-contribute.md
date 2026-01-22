---
description: Full drupal.org contribution workflow - create issue and merge request together
argument-hint: "{project} [issue-number]"
allowed-tools: Read, Glob, Grep, Bash(git:*), Bash(glab:*), Bash(mkdir:*), chrome-devtools MCP, Task
---

## How It Works

This command orchestrates the complete drupal.org contribution workflow by spawning both specialist agents in sequence:

```
1. Task(cms-cultivator:drupalorg-issue-specialist:drupalorg-issue-specialist,
       prompt="Create a new issue for {project}. Gather issue details, navigate to drupal.org, fill the form, get user approval, submit, and return the issue number.")

2. Task(cms-cultivator:drupalorg-mr-specialist:drupalorg-mr-specialist,
       prompt="Create a merge request for {project} issue #{issue_number}. Clone repo, create issue fork, set up branch, and create MR.")
```

### Workflow Steps (Automated)

#### Phase 1: Issue Creation (drupalorg-issue-specialist)
1. Check Chrome DevTools MCP availability
2. Verify drupal.org login
3. Gather issue details (type, title, description, version, priority)
4. Fill and submit issue form
5. Return issue URL and number

#### Phase 2: Merge Request Creation (drupalorg-mr-specialist)
1. Check glab CLI and authentication
2. Clone project to `~/.cache/drupal-contrib/{project}/`
3. Create issue fork via browser
4. Create branch: `{issue_number}-{description}`
5. Set up for code changes
6. (After changes) Push and create MR

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
1. Create a new issue on drupal.org
2. Clone the project to `~/.cache/drupal-contrib/{project}/`
3. Create the issue fork
4. Create a branch for your work
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
2. Create issue fork (if not already created)
3. Set up branch for the issue
4. Return setup instructions

**Example**:
```bash
/drupal-contribute paragraphs 3456789
```

## Complete Workflow

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

### Step 3: Approve Issue
Review the issue content and approve for submission.

### Step 4: Make Code Changes
Navigate to the cloned repo and make your changes:
```bash
cd ~/.cache/drupal-contrib/paragraphs
# Edit files...
```

### Step 5: Commit and Push
```bash
git add .
git commit -m "Issue #3456789: Fix validation error"
git push issue-fork 3456789-fix-validation-error
```

### Step 6: Create MR
The agent can create the MR via glab, or you can do it via the drupal.org UI.

## Prerequisites

### For Issue Creation
- **Chrome DevTools MCP** - Browser automation for drupal.org
- **drupal.org credentials** - Save for auto-login (see below)

### For MR Creation
- **glab CLI** - GitLab CLI tool
- **git.drupalcode.org authentication** - Via `glab auth login` (persists in config)
- **SSH key** - Added to git.drupalcode.org

### Save drupal.org Credentials (Recommended)

```bash
mkdir -p ~/.config/drupalorg
cat > ~/.config/drupalorg/credentials.yml << 'EOF'
username: your-username
password: your-password
EOF
chmod 600 ~/.config/drupalorg/credentials.yml
```

With saved credentials, the agent auto-logs in when needed.

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
**Issue Fork**: git@git.drupal.org:issue/paragraphs-3456789.git

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
   git push issue-fork 3456789-fix-validation-error
   ```

4. **Create MR** (if not auto-created):
   ```bash
   glab mr create --hostname git.drupalcode.org \
     --title "Issue #3456789: Fix validation error"
   ```

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

### Browser Automation Unavailable
Falls back to manual instructions with pre-filled content for both issue creation and fork setup.

## Related Commands

- **[`/drupal-issue`](drupal-issue.md)** - Issue operations only
- **[`/drupal-mr`](drupal-mr.md)** - MR operations only
- **[`/drupal-cleanup`](drupal-cleanup.md)** - Manage cloned repos

## Skills Used

This command uses both skills:
- **drupalorg-issue-helper** - Issue templates and formatting
- **drupalorg-contribution-helper** - Git workflow and branch conventions
