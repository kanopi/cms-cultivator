---
description: Generate PR description and create pull request using workflow specialist
argument-hint: [ticket-number] [--concise]
allowed-tools: Task
---

Spawn the **workflow-specialist** agent using:

```
Task(cms-cultivator:workflow-specialist:workflow-specialist,
     prompt="Create a pull request for the user's changes. Analyze git changes, detect CMS-specific modifications (Drupal/WordPress), orchestrate quality checks by spawning specialists in parallel as needed (unless --concise mode), generate PR description following project template, and create the pull request using gh CLI. Arguments: [use ticket number and --concise flag if provided]")
```

The workflow specialist will:
1. **Parse arguments** - Check for ticket number and `--concise` flag
2. **Analyze git changes** - Review commits, diffs, and modified files since branching from main
3. **Detect CMS-specific changes**:
   - **Drupal**: Config changes, module updates, update hooks, services, routes, permissions, entity definitions
   - **WordPress**: Theme changes, Gutenberg blocks, ACF fields, custom post types, shortcodes
4. **Orchestrate quality checks** - Spawn specialists in parallel as needed:
   - **Standard mode**: Run all applicable specialists (testing, security, accessibility)
   - **Concise mode**: Skip specialists unless critical security/accessibility issues detected
5. **Generate PR description** - Following your project's template with:
   - User story and description (concise in --concise mode)
   - Acceptance criteria extracted from code changes
   - Deployment notes (essential only in --concise mode)
   - Steps to validate with specific admin paths
6. **Present FULL PR title and description for approval** - Shows the complete PR content, not a summary
7. **Verify prerequisites** - Check gh CLI installation, authentication, branch status
8. **Create pull request** - Execute `gh pr create` with approved description
9. **Return PR URL** - Provide link to created pull request

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

## How It Works

This command spawns the **workflow-specialist** agent, which orchestrates the entire PR creation workflow. The workflow specialist uses the **commit-message-generator** skill and delegates to other specialists for comprehensive quality checks.

### Agent Orchestration

The workflow specialist will intelligently spawn other agents in parallel based on your changes:

- **Security-critical code?** → `security-specialist` checks for OWASP vulnerabilities, input validation, SQL injection risks
- **UI/frontend changes?** → `accessibility-specialist` validates WCAG compliance, semantic HTML, ARIA usage
- **New features or modified code?** → `testing-specialist` analyzes test coverage and generates test plans

All specialist findings are compiled into a unified PR description with prioritized action items.

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

## Prerequisites

The workflow specialist verifies:
- ✅ GitHub CLI (`gh`) is installed and authenticated
- ✅ Current branch is NOT main/master
- ✅ Commits exist to create PR for
- ✅ Branch is pushed to remote (or pushes it for you)

## Ticket Number Handling

**Provide ticket number as argument:**
```bash
/pr-create PROJ-123
```

**Or let the workflow specialist extract it from:**
- Branch name: `feature/PROJ-123-description`
- Commit messages: Contains `PROJ-123`
- Manual prompt: Agent will ask if not found

## Error Handling

The workflow specialist handles:
- **gh not installed** - Provides installation instructions
- **Not authenticated** - Guides through `gh auth login`
- **On main/master** - Warns that a feature branch is needed
- **No commits** - Explains nothing to create PR for
- **Branch not pushed** - Automatically pushes with tracking
- **PR already exists** - Shows existing PR URL

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

## Agent Used

**workflow-specialist** - Orchestrates PR creation with parallel specialist delegation for comprehensive quality checks.

## What Makes This Different

**Before (manual PR creation):**
- Write PR description yourself
- Manually identify deployment steps
- Miss security/accessibility concerns
- No automated quality checks

**With workflow-specialist:**
- ✅ Automated PR description generation
- ✅ CMS-specific deployment notes
- ✅ Parallel quality checks (security, testing, accessibility)
- ✅ Comprehensive acceptance criteria
- ✅ Direct validation links
- ✅ Compiled specialist findings
