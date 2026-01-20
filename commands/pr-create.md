---
description: Generate PR description and create pull request using workflow specialist
argument-hint: "[ticket-number] [--concise]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(gh pr view:*), Task
---

## Context

- **Current branch**: !`git branch --show-current`
- **Main branch**: !`git remote show origin | grep 'HEAD branch' | cut -d' ' -f5`
- **Commits since branching**: !`git log --oneline origin/main..HEAD 2>/dev/null | wc -l | tr -d ' '`
- **Files changed**: !`git diff --name-only origin/main...HEAD 2>/dev/null | wc -l | tr -d ' '`
- **Last 10 commits**: !`git log --oneline -10`
- **Branch status**: !`git status --porcelain=v1 2>/dev/null`

## Phase 1: Analysis

**Goal**: Understand changes to include in PR

Spawn the **workflow-specialist** agent with:

```
Task(cms-cultivator:workflow-specialist:workflow-specialist,
     prompt="Analyze changes for PR creation. Review all commits since branch divergence from main, identify CMS-specific modifications (Drupal config, WordPress blocks), and assess what quality checks are needed. Arguments: [use ticket number and --concise flag if provided]. DO NOT create the PR yet - this is analysis phase only.")
```

**Tool Usage in this phase:**
- ✅ Read context provided above (commits, files, branch info)
- ✅ Run git commands to analyze changes
- ✅ Detect Drupal/WordPress specific changes
- ❌ Do not create PR yet
- ❌ Do not push to remote yet

The workflow specialist will:
1. **Parse arguments** - Check for ticket number and `--concise` flag
2. **Analyze git changes** - Review commits, diffs, and modified files since branching from main
3. **Detect CMS-specific changes**:
   - **Drupal**: Config changes, module updates, update hooks, services, routes, permissions, entity definitions
   - **WordPress**: Theme changes, Gutenberg blocks, ACF fields, custom post types, shortcodes
4. **Determine quality checks needed** - Decide which specialists to spawn based on changes

## Phase 2: Quality Checks (Parallel)

**Goal**: Run comprehensive quality checks

**Standard mode**: Spawn specialists in parallel as needed:
- **Security-critical code?** → `cms-cultivator:security-specialist:security-specialist`
- **UI/frontend changes?** → `cms-cultivator:accessibility-specialist:accessibility-specialist`
- **New features or modified code?** → `cms-cultivator:testing-specialist:testing-specialist`

**Concise mode** (`--concise` flag): Skip specialists unless critical issues detected

**Tool Usage in this phase:**
- ✅ Spawn specialist agents in parallel using Task tool
- ✅ Collect findings from specialists
- ❌ Do not create PR yet

## Phase 3: Review & Approval

**CRITICAL - DO NOT SKIP**

**Goal**: Get user approval before creating PR

The workflow specialist will:
1. **Generate PR description** following project template:
   - User story and description (concise in --concise mode)
   - Acceptance criteria extracted from code changes
   - Deployment notes (essential only in --concise mode)
   - Steps to validate with specific admin paths
   - Compiled specialist findings (if any)

2. **Present FULL PR title and description** - Shows complete content for review

3. **Ask user**: "Ready to create PR with this description? You can request edits or approve."

4. **Wait for explicit approval** - Do not proceed without user confirmation

**Tool Usage in this phase:**
- ✅ Generate PR description
- ✅ Show full description to user
- ✅ Wait for approval
- ❌ Do not create PR without approval

## Phase 4: PR Creation

**DO NOT START WITHOUT USER APPROVAL**

**Goal**: Create and push PR

After user approval, the workflow specialist will:
1. **Verify prerequisites**:
   - ✅ Check gh CLI installation and authentication
   - ✅ Verify current branch is NOT main/master
   - ✅ Confirm commits exist to create PR for
   - ✅ Ensure branch is pushed to remote (or push it)

2. **Create pull request** using `gh pr create`

3. **Return PR URL** for user to review

**Tool Usage in this phase:**
- ✅ Push branch if needed (with user permission)
- ✅ Create PR with gh CLI
- ✅ Display PR URL
- ❌ Do not merge or modify PR after creation

---

## Tool Usage

**Allowed operations:**
- ✅ Spawn workflow-specialist agent (orchestrator)
- ✅ Agent spawns security-specialist, accessibility-specialist, testing-specialist in parallel for quality checks
- ✅ Analyze git history (commits, diffs, branch status)
- ✅ Detect CMS-specific changes (Drupal config, WordPress blocks)
- ✅ Generate PR description with acceptance criteria
- ✅ Push branch to remote (with user confirmation)
- ✅ Create pull request using gh CLI

**Not allowed:**
- ❌ Do not commit changes (user must commit before running command)
- ❌ Do not merge PR after creation
- ❌ Do not modify code during PR creation
- ❌ Do not skip quality checks in standard mode

The workflow-specialist orchestrates all PR creation operations and delegates quality checks to specialized agents.

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
