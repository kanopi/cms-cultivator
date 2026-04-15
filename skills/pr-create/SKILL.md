---
name: pr-create
description: Generate PR description and create a GitHub pull request using the workflow-specialist agent. Invoke when user explicitly asks to create a pull request, says "create a PR", "submit a PR", "open a pull request", or uses /pr-create. Requires user confirmation before creating the PR (irreversible GitHub action). Supports ticket numbers and --concise mode.
---

# PR Create

Generate PR description and create a GitHub pull request using the workflow-specialist agent.

## ⚠️ Side Effect Warning

**This skill creates a GitHub pull request** — a publicly visible, permanent action that:
- Pushes your branch to the remote repository
- Creates a PR visible to all repository members
- Triggers CI/CD pipelines and notifications

**Confirmation required** before any of these actions are taken. The skill will present the complete PR description for your review and wait for explicit approval.

## Usage

- "Create a PR for my current branch"
- "Create a pull request with ticket PROJ-123"
- "Create a concise PR for this bug fix"
- `/pr-create [ticket-number] [--concise]`

## Prerequisites

- Changes committed to a feature branch (not main/master)
- GitHub CLI (`gh`) installed and authenticated
- Remote repository accessible

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() or gh CLI are unavailable:

1. **Gather git context** — Ask user to share: current branch, recent commits, changed files
2. **Extract ticket number** — From branch name, commits, or user input
3. **Detect CMS changes** — Ask user about or analyze provided diff for:
   - Drupal: config changes, update hooks, module changes
   - WordPress: theme changes, ACF fields, CPT registrations
4. **Generate PR description** following the project template:
   - User story and description
   - Acceptance criteria
   - Deployment notes
   - Steps to validate
5. **Present for approval** — Display the complete PR title and description
6. **⛔ STOP: Wait for explicit user approval** before proceeding
7. **After approval**: Provide the `gh pr create` command for the user to run manually

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() and git/gh CLI available:

1. **Verify prerequisites** — Ensure changes are committed, not on main branch
2. **Spawn workflow-specialist**:
   ```
   Task(cms-cultivator:workflow-specialist:workflow-specialist,
        prompt="Create a pull request from the current branch. Arguments: {ticket-number if provided, --concise flag if provided}. Follow the complete PR creation workflow: (1) Analyze git changes and detect CMS-specific modifications, (2) Run quality checks as needed (skip in --concise mode unless critical), (3) Generate comprehensive PR description following the project template, (4) CRITICAL OUTPUT FORMAT: Your response must START IMMEDIATELY with '=== PULL REQUEST READY FOR APPROVAL ===' followed by the PR content. DO NOT write ANY text before this header. (5) Wait for user approval, then create the PR using gh CLI.")
   ```
3. **Present output directly** — When workflow-specialist returns `=== PULL REQUEST READY FOR APPROVAL ===`, display verbatim to user
4. **⛔ STOP: Wait for user approval** (approve or provide edits)
5. **After approval** — Resume workflow-specialist with approval to execute `gh pr create`

## Confirmation Protocol

The skill will always present this sequence:

```
=== PULL REQUEST READY FOR APPROVAL ===

**Title**: [PR Title]

## Description
[Full PR description]

===================================

Reply "approve" to create this PR, or provide your edits.
```

**No PR will be created until you reply "approve".**

## PR Description Template

```markdown
## Description
Teamwork Ticket(s): [PROJ-123](link)
- [ ] Was AI used in this pull request?

> As a developer, I need to...

[Summary of changes]

## Acceptance Criteria
* [Specific, testable criteria]

## Assumptions
* [Known limitations]

## Steps to Validate
1. [Testing instructions]

## Affected URL
[link to test site]

## Deploy Notes
[Config imports, cache clearing, database updates]
```

## Concise Mode

Use `--concise` for smaller tasks/bug fixes:
- Shorter descriptions (2-3 sentences)
- Fewer specialist quality checks
- Essential deployment notes only
- Same required template sections

## CMS-Specific Detection

**Drupal**: Config changes → config import needed; update hooks → database updates; services → cache clear

**WordPress**: ACF changes → re-sync fields; CPT changes → flush permalinks; theme changes → clear cache

## Related Skills

- **pr-review** — Self-review before creating PR
- **commit-message-generator** — Generate commit message first
- **pr-release** — Create release PR with changelog
