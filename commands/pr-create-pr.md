---
description: Generate PR description and create pull request on remote
argument-hint: [ticket-number]
allowed-tools: Bash(git:*), Bash(gh:*), Read, Glob, Grep
---

You are helping create a pull request on GitHub. Follow this workflow:

## Step 1: Generate PR Description

First, run the `/pr-desc` command logic internally (don't literally call the command):

1. Run `git status` to see changed files
2. Run `git diff` to see actual changes
3. Run `git log origin/main..HEAD` to see commits since branching from main
4. Analyze all changes for:
   - **Drupal-specific changes** (if Drupal project detected):
     - Config changes in `config/sync/*.yml`
     - Custom modules in `modules/custom/`
     - `.info.yml`, `.module`, `.install`, `.theme` files
     - Service definitions (`*.services.yml`)
     - Route definitions (`*.routing.yml`)
     - Permission definitions (`*.permissions.yml`)
     - Database updates (`hook_update_N`)
     - Entity/field definitions
     - Twig templates
     - Theme libraries
     - View modes, form displays
     - Views in `config/sync/views.view.*.yml`
   - **WordPress-specific changes** (if WordPress project detected):
     - Theme changes (`functions.php`, templates)
     - Gutenberg blocks in `blocks/`
     - ACF field groups in `acf-json/`
     - Must-use plugins in `mu-plugins/`
     - Custom post types and taxonomies
     - Shortcodes
     - WP_Query customizations
     - Template hierarchy customizations
   - **Cypress tests** in `cypress/e2e/`
   - **composer.json** or **package.json** changes
   - **Database migrations** or schema changes
   - **Environment variable** changes

5. Generate a description following this template:

```markdown
## Description
[Comprehensive summary of what this PR accomplishes and why]

## Acceptance Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]

## Assumptions
- [Any assumptions made]

## Steps to Validate
1. [Step-by-step validation instructions]

## Affected URL
- [URL where changes can be seen]

## Deploy Notes

### Pre-deployment
- [ ] [Any pre-deploy steps]

### Deployment Steps
**If Drupal project:**
- [ ] `drush cim -y` (if config changes detected)
- [ ] `drush updb -y` (if database updates detected)
- [ ] `drush cr` (if needed)
- [ ] `drush entup -y` (if entity/field changes)
- [ ] Additional Drush commands as needed

**If WordPress project:**
- [ ] Run database migrations if present
- [ ] Flush permalinks if CPT/taxonomy changes
- [ ] Clear object cache
- [ ] Additional WP-CLI commands as needed

**If Cypress tests added/modified:**
- [ ] Verify test environment is up-to-date
- [ ] Run Cypress tests: `npm run cypress:run` or `npx cypress run`

### Post-deployment
- [ ] [Any post-deploy verification steps]

### Rollback Plan
[How to rollback if issues occur]
```

## Step 2: Show Generated Description

Present the generated PR description to the user and ask:
"Here's the generated PR description. Would you like me to proceed with creating the pull request, or would you like to make any changes first?"

Wait for user confirmation before proceeding.

## Step 3: Verify Prerequisites

Before creating the PR:

1. **Check gh CLI is installed:**
   ```bash
   gh --version
   ```
   If not installed, provide installation instructions for their OS.

2. **Verify authentication:**
   ```bash
   gh auth status
   ```
   If not authenticated, run: `gh auth login`

3. **Check current branch:**
   ```bash
   git branch --show-current
   ```
   Ensure it's NOT `main` or `master`. If it is, stop and warn the user.

4. **Check for commits:**
   ```bash
   git log origin/main..HEAD --oneline
   ```
   If empty, there are no commits to create a PR for.

5. **Check if branch is pushed to remote:**
   ```bash
   git rev-parse --abbrev-ref --symbolic-full-name @{u}
   ```
   If not tracking a remote branch, push it:
   ```bash
   git push -u origin $(git branch --show-current)
   ```

## Step 4: Create the Pull Request

Once prerequisites are met and user approves:

1. **Create PR using gh CLI:**
   ```bash
   gh pr create \
     --title "[TICKET-123] Brief title" \
     --body "$(cat <<'EOF'
   [Insert the generated PR description here]
   EOF
   )"
   ```

2. **Handle the ticket number:**
   - If user provided ticket number as argument, use it in title
   - If not provided, derive from branch name or ask user
   - Common patterns: `PROJ-123`, `feature/PROJ-123-description`, `PROJ-123-description`

3. **Set base branch if needed:**
   If PR should target a branch other than main:
   ```bash
   gh pr create --base develop --title "..." --body "..."
   ```

## Step 5: Confirm Success

After PR creation:

1. **Get PR URL:**
   The `gh pr create` command will output the PR URL

2. **Display success message:**
   ```
   ✅ Pull request created successfully!

   PR #123: [Title]
   URL: https://github.com/org/repo/pull/123

   Next steps:
   - Request reviews from team members
   - Ensure CI checks pass
   - Address any review feedback
   ```

## Error Handling

- **If `gh` not installed:** Provide installation link (https://cli.github.com/)
- **If not authenticated:** Guide through `gh auth login`
- **If on main/master:** Stop and explain branches should be created first
- **If no commits:** Explain there's nothing to create a PR for
- **If branch not pushed:** Automatically push with tracking
- **If PR already exists:** Show existing PR URL and ask if they want to update it instead (suggest `/pr-update` command)

## Optional Enhancements

Ask user if they want to:
- Add labels: `--label bug,enhancement`
- Add reviewers: `--reviewer username1,username2`
- Add assignees: `--assignee username`
- Mark as draft: `--draft`
- Add to project: `--project "Project Name"`

Example with options:
```bash
gh pr create \
  --title "[PROJ-123] Add user dashboard" \
  --body "$PR_DESCRIPTION" \
  --reviewer jane,john \
  --label enhancement,frontend \
  --assignee @me
```

## Output Format

Provide clear, actionable output at each step:
1. ✅ or ❌ for each prerequisite check
2. Show the generated PR description for review
3. Confirm PR creation with URL
4. List any follow-up actions needed

Remember: Always get user approval before actually creating the PR. The description generation is automatic, but PR creation requires explicit confirmation.
