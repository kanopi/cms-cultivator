---
description: Generate PR description and create pull request on remote
argument-hint: [ticket-number]
allowed-tools: Bash(git:*), Bash(gh:*), Read, Glob, Grep
---

You are helping create a pull request on GitHub. Follow this workflow:

## Step 1: Generate PR Description

Follow the same analysis and template approach as `/pr-desc` command:

1. **Analyze the git state:**
   - Run `git status` to see modified, staged, and untracked files
   - Run `git diff` to see the actual code changes
   - Run `git log origin/main..HEAD` to see commits since branching from main
   - Check branch name for ticket references
   - Review recent commit messages for context

2. **Detect key information for Drupal/WordPress projects:**
   - Check if Cypress tests (`.cy.js` or `.cy.ts` files) were modified and extract test scenarios
   - Identify changes to `composer.json` or `composer.lock` for new PHP dependencies
   - Identify changes to `package.json` or `package-lock.json` for new frontend dependencies

   **For Drupal projects:**
   - Config changes in `config/sync/*.yml` or similar config directories
   - Custom module changes in `modules/custom/`
   - Contrib module patches in `patches/` or `composer.json` patches section
   - Services definitions in `*.services.yml` files
   - Routing changes in `*.routing.yml` files
   - Permissions in `*.permissions.yml` files
   - Module dependencies in `*.info.yml` files
   - Database updates (`hook_update_N` in `.install` files)
   - Entity type definitions, field definitions, view modes, form display configurations
   - Theme changes: Twig templates, libraries (`*.libraries.yml`), preprocess functions
   - Migration configurations, REST API endpoints, webform configurations

   **For WordPress projects:**
   - Theme changes (`functions.php`, template files)
   - Custom Gutenberg blocks in `blocks/` directories
   - ACF field group exports in `acf-json/` directories
   - Must-use plugins in `mu-plugins/`
   - Custom plugin modifications
   - Custom post type or taxonomy registrations
   - Shortcode implementations
   - Changes to `wp-config.php`

3. **Generate description using the same template as `/pr-desc`:**

```markdown
## Description
Teamwork Ticket(s): [insert_ticket_name_here](insert_link_here)
- [ ] Was AI used in this pull request?

> As a developer, I need to start with a story.

_A few sentences describing the overall goals of the pull request's commits.
What is the current behavior of the app? What is the updated/expected behavior
with this PR?_

## Acceptance Criteria
* A list describing how the feature should behave
* e.g. Clicking outside a modal will close it
* e.g. Clicking on a new accordion tab will not close open tabs

## Assumptions
* A list of things the code reviewer or project manager should know
* e.g. There is a known Javascript error in the console.log
* e.g. On any `multidev`, the popup plugin breaks.

## Steps to Validate
1. A list of steps to validate
1. Include direct links to test sites (specific nodes, admin screens, etc)
1. Be explicit

## Affected URL
[link_to_relevant_multidev_or_test_site](insert_link_here)

## Deploy Notes
_Notes regarding deployment of the contained body of work. These should note any
new dependencies, new scripts, etc. This should also include work that needs to be
accomplished post-launch like enabling a plugin._
```

4. **Populate intelligently** following the same guidelines as `/pr-desc`:
   - Extract acceptance criteria from hook implementations, entity alterations, field definitions, etc.
   - Note deployment requirements like config imports, entity updates, module enablement
   - Include specific admin paths and validation steps
   - List all new dependencies and configuration changes

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
