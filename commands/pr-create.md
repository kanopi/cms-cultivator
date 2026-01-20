---
description: Generate PR description and create pull request using workflow specialist
argument-hint: "[ticket-number] [--concise]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(gh pr view:*), Task
---

## How It Works

Spawn the **workflow-specialist** agent to handle the complete PR creation workflow:

```
Task(cms-cultivator:workflow-specialist:workflow-specialist,
     prompt="Create a pull request from the current branch. Arguments: [use ticket number and --concise flag if provided]. Follow the complete PR creation workflow: (1) Analyze git changes and detect CMS-specific modifications, (2) Run quality checks as needed (skip in --concise mode unless critical), (3) Generate comprehensive PR description following the project template, (4) Format your FINAL output with ONLY the PR title and full description using the '=== PULL REQUEST READY FOR APPROVAL ===' format - NO summaries, NO explanations, ONLY the title, complete description, and approval request, (5) Wait for user approval, then create the PR using gh CLI.")
```

### Workflow Steps (Automated)

The workflow specialist automatically executes these steps:

#### 1. Analysis
- Parse arguments (ticket number, `--concise` flag)
- Gather git context: current branch, main branch, commits since branching, files changed
- Detect CMS-specific changes:
  - **Drupal**: Config changes, module updates, update hooks, services, routes, permissions
  - **WordPress**: Theme changes, Gutenberg blocks, ACF fields, custom post types, shortcodes
- Determine which quality checks are needed

#### 2. Quality Checks (Parallel)
- **Standard mode**: Spawn specialists in parallel based on changes detected
  - Security-critical code → `cms-cultivator:security-specialist:security-specialist`
  - UI/frontend changes → `cms-cultivator:accessibility-specialist:accessibility-specialist`
  - New features/modified code → `cms-cultivator:testing-specialist:testing-specialist`
- **Concise mode** (`--concise`): Skip specialists unless critical issues detected

#### 3. PR Description Generation
- Generate description following project template:
  - User story and description (concise in `--concise` mode)
  - Acceptance criteria extracted from code changes
  - Deployment notes (essential only in `--concise` mode)
  - Steps to validate with specific admin paths
  - Compiled specialist findings (if any)

#### 4. User Approval (CRITICAL)
- **Present ONLY the PR title and full description** - NO summaries, NO context, NO explanations
- Format: `=== PULL REQUEST READY FOR APPROVAL ===` header, title, complete description, approval request
- Same presentation format whether `--concise` flag is used or not (flag only affects description verbosity)
- **Wait for explicit approval** before proceeding
- Allow user to approve or provide edits

#### 5. PR Creation
- Verify prerequisites (gh CLI auth, branch status, commits exist)
- Push branch to remote if needed (with user confirmation)
- Create pull request using `gh pr create`
- Return PR URL

### Tool Usage

The workflow-specialist orchestrates all operations:
- Analyze git history (commits, diffs, branch status)
- Detect CMS-specific changes (Drupal config, WordPress blocks)
- Spawn security-specialist, accessibility-specialist, testing-specialist in parallel for quality checks
- Generate PR description with acceptance criteria
- Present full description for user approval
- Push branch to remote (with user confirmation)
- Create pull request using gh CLI

**Prerequisites:**
- Changes must be committed before running this command
- Current branch cannot be main/master
- gh CLI must be installed and authenticated

---

## Quick Start

```bash
# 1. Commit and push your changes
git add .
git commit -m "Your commit message"
git push -u origin feature-branch

# 2. Run this command
/pr-create

# With ticket number:
/pr-create PROJ-123

# For smaller tasks/support tickets (concise mode):
/pr-create PROJ-123 --concise
/pr-create --concise
```

## Concise Mode

For smaller support tickets or simple bug fixes, use the `--concise` flag to generate:
- **Shorter descriptions** - 2-3 sentences instead of full paragraphs
- **Bullet point format** - Easier to scan and read
- **Fewer specialist checks** - Skips comprehensive analysis unless critical issues detected
- **Essential deployment notes only** - Focuses on what's necessary
- **All required template sections** - Still includes Description, Acceptance Criteria, Steps to Validate, etc.

**Use concise mode when:**
- ✅ Simple bug fixes
- ✅ Minor feature additions
- ✅ Small support tickets
- ✅ Quick UI tweaks
- ✅ Documentation updates

**Use standard mode when:**
- ✅ Major feature development
- ✅ Security-critical changes
- ✅ Complex refactoring
- ✅ Database schema changes
- ✅ Breaking changes

## PR Description Template

The workflow specialist generates descriptions following this structure:

```markdown
## Description
Teamwork Ticket(s): [PROJ-123](link)
- [ ] Was AI used in this pull request?

> As a developer, I need to...

[Comprehensive summary of changes and goals]

## Acceptance Criteria
* Extracted from code changes
* Specific, testable criteria
* Admin paths and validation steps

## Assumptions
* Known issues or limitations
* Environment-specific notes

## Steps to Validate
1. Direct links to test sites
2. Explicit testing instructions
3. Expected outcomes

## Affected URL
[link_to_multidev_or_test_site]

## Deploy Notes
[Dependencies, config imports, database updates, cache clearing]
```

## Ticket Number Handling

**Provide ticket number as argument:**
```bash
/pr-create PROJ-123
```

**Or let the workflow specialist extract it from:**
- Branch name: `feature/PROJ-123-description`
- Commit messages: Contains `PROJ-123`
- Manual prompt: Agent will ask if not found

## Optional PR Options

The workflow specialist can add:
- **Labels**: `--label bug,enhancement`
- **Reviewers**: `--reviewer username1,username2`
- **Assignees**: `--assignee username`
- **Draft mode**: `--draft`
- **Project**: `--project "Project Name"`

Just mention these in your request:
```bash
/pr-create PROJ-123 - mark as draft and assign to me
```

## CMS-Specific Detection

### Drupal Projects

The workflow specialist detects and documents:
- **Config changes**: `config/sync/*.yml` → Config import required
- **Update hooks**: `hook_update_N()` → Database updates needed
- **Module changes**: `modules/custom/` → Module dependencies
- **Services**: `*.services.yml` → Service definitions
- **Routes**: `*.routing.yml` → New endpoints
- **Permissions**: `*.permissions.yml` → Permission changes
- **Entities**: Field definitions, view modes, form displays

### WordPress Projects

The workflow specialist detects and documents:
- **Theme changes**: Template files, `functions.php`
- **Gutenberg blocks**: `blocks/` directories
- **ACF fields**: `acf-json/` exports
- **Custom post types**: CPT registrations
- **Shortcodes**: New shortcode implementations
- **Must-use plugins**: `mu-plugins/` changes

## Related Commands

- **[`/pr-commit-msg`](pr-commit-msg.md)** - Generate commit message first
- **[`/pr-review self`](pr-review.md)** - Self-review before creating PR
- **[`/pr-release`](pr-release.md)** - Create release PR with changelog
