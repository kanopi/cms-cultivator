---
name: pr-create
description: Generate a PR description and create a GitHub pull request. Invoke when user wants to create a pull request, says "create a PR", "submit a PR", "open a pull request", or uses /pr-create. Requires user confirmation before creating the PR (irreversible GitHub action). Supports ticket numbers and --concise mode.
---

# PR Create

Generate a comprehensive PR description and create a GitHub pull request. The main session runs this skill directly — no orchestrator agent is involved.

## ⚠️ Side Effect Warning

**This skill creates a GitHub pull request** — a publicly visible, permanent action that:

- Pushes your branch to the remote repository
- Creates a PR visible to all repository members
- Triggers CI/CD pipelines and notifications

**Confirmation required** before any of these actions are taken. Present the complete PR description for the user's review and wait for explicit approval before running `gh pr create`.

## Usage

- "Create a PR for my current branch"
- "Create a pull request with ticket PROJ-123"
- "Create a concise PR for this bug fix"
- `/pr-create [ticket-number] [--concise]`

## Prerequisites

- Changes committed to a feature branch (not main/master)
- GitHub CLI (`gh`) installed and authenticated
- Remote repository accessible

## Workflow

### 1. Parse arguments

- Look for a ticket reference (e.g., `PROJ-123`) in the arguments, current branch name, or recent commit messages.
- Look for `--concise` flag in the arguments. Concise mode produces shorter descriptions and skips non-critical quality checks.

### 2. Verify prerequisites

Run in parallel:

- `git status` — confirm working tree is clean (or staged changes are intended for the PR)
- `git branch --show-current` — confirm we're not on `main`/`master`
- `gh auth status` — confirm GitHub CLI is authenticated
- `git remote -v` — confirm the repo has a remote

If on `main`/`master`, stop and tell the user to switch to a feature branch first. If `gh` isn't authenticated, suggest `gh auth login` and provide manual instructions instead.

### 3. Analyze changes

Run in parallel:

- `git log --oneline <base>..HEAD` — full commit history on this branch
- `git diff <base>...HEAD` — full diff
- `git diff --stat <base>...HEAD` — files changed summary

Where `<base>` is typically `main` or `1.x` (whichever the repo uses as the default branch — check with `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`).

### 4. Detect CMS context

Scan the diff for platform-specific changes:

**Drupal indicators:**
- Files under `config/sync/` → flag config import needed
- `hook_update_N` definitions in `.module` or `.install` → flag database update
- Changes to services, render arrays, or cache tags → flag cache clear
- New module dependencies in `*.info.yml` or `composer.json`

**WordPress indicators:**
- ACF JSON files in `acf-json/` → flag field re-sync
- `register_post_type`, `register_taxonomy`, or rewrite rule changes → flag permalink flush
- Theme template changes or new plugin activations → flag cache clear / plugin activation
- Block changes (`block.json`, `src/blocks/`) → flag editor cache

### 5. Run inline quality checks (skip in --concise mode unless critical)

Use Read, Grep, and Bash directly — no Task() spawns required:

- **Tests** — Grep for new functions/classes and check if matching tests exist in the project's test directory. Note untested code in the PR description.
- **Security** — Grep the diff for risky patterns: raw SQL concatenation, `eval`, `unserialize`, missing nonce/CSRF checks (WP `wp_verify_nonce`, Drupal Form API), unescaped output (`echo $user_input`, missing `esc_html`/`esc_attr`/`Html::escape`).
- **Accessibility** — If UI/template files changed, Grep for: missing `alt=`, missing `aria-label` on icon buttons, color-only state indicators, missing form labels.
- **Performance** — Look for new database queries inside loops (N+1), missing caching, large asset imports without lazy loading.

Note findings briefly in the PR description's relevant sections. Do **not** block PR creation on findings — surface them so the reviewer can decide.

### 6. Generate PR description

Use the template below. Adjust verbosity for `--concise` mode.

```markdown
## Description
Teamwork Ticket(s): [PROJ-123](https://kanopi.teamwork.com/app/tasks/123)
- [ ] Was AI used in this pull request?

> As a [role], I need to [action] so that [benefit].

[Summary of changes in 2–4 sentences. What changed and why.]

## Acceptance Criteria
* [Specific, testable criteria]
* [One bullet per criterion]

## Assumptions
* [Anything reviewers/PMs should know — known issues, scope decisions]

## Steps to Validate
1. [Explicit testing instructions with URLs where applicable]
2. [Cover the happy path and at least one edge case]

## Affected URL
[Multidev or staging URL]

## Deploy Notes
[Config imports, cache clearing, database updates, plugin activations, permalink flushes — anything required for deployment]
```

In concise mode:
- Description paragraph is 1–2 sentences
- Acceptance Criteria and Steps to Validate as bullets (2–4 each)
- Deploy Notes only if there are real deployment requirements
- All template sections still present

### 7. Present for approval

Your response **must start immediately** with the approval header. No preamble, no summary, no "I've analyzed your changes" — start with the header.

```
=== PULL REQUEST READY FOR APPROVAL ===

**Title:** <conventional commit style PR title>

**Description:**

<full PR description with all sections>

===================================

Reply "approve" to create this PR, or provide your edits.
```

### 8. Wait for explicit user approval

⛔ **Do not run `gh pr create` until the user replies "approve" or provides edits.**

- If approved → proceed to step 9 with the presented content.
- If user provides edits → use their edited version verbatim and proceed to step 9.
- If user declines → stop. No PR created.

### 9. Create the PR

```bash
gh pr create --base <default-branch> --head <current-branch> --title "<title>" --body "$(cat <<'EOF'
<approved description>
EOF
)"
```

Return the PR URL to the user. Suggest next steps (e.g., assigning reviewers, running `/pr-release` later for the release).

## Environment fallback (no `gh` CLI / no Task tool)

If `gh` is unavailable (Claude Desktop, Codex without `gh`, restricted environment):

1. Run steps 1–7 normally — present the PR title and description.
2. After approval, **provide the `gh pr create` command** for the user to run manually, with the body pre-formatted in a heredoc they can paste.
3. Do not attempt to create the PR yourself.

## Title Conventions

Use conventional commit style: `<type>(<scope>): <description>`

- `feat(auth): add two-factor authentication`
- `fix(checkout): resolve cart total calculation`
- `refactor(api): consolidate response handlers`
- `chore(deps): update React to 18.3`

## CMS-Specific Detection Quick Reference

**Drupal:**
- Config changes → `drush config:import` after deploy
- Update hooks → `drush updatedb`
- Service/render changes → `drush cache:rebuild`

**WordPress:**
- ACF JSON changes → re-sync fields from `acf-json/`
- CPT/taxonomy/rewrite changes → flush permalinks (Settings → Permalinks → Save)
- Theme/plugin changes → clear caching plugin
- Block changes → may need browser cache clear for editor

## Related Skills

- **pr-review** — Self-review before creating the PR
- **commit-message-generator** — Generate the commit messages that feed into the PR
- **pr-release** — Generate changelog + deployment checklist for the release PR

## Anti-rationalization table

Creating a PR is an outward-facing, hard-to-retract action. The confirmation
gate and the honesty of the description are the contract:

| Pressure / rationalization | Correct behavior |
|---|---|
| "The user obviously wants the PR — skip the confirmation" | Always show the final title/description and wait for explicit confirmation before `gh pr create`. |
| "Tests are probably passing, say so in the description" | Only claim what ran. If tests weren't run, the description says so. |
| "Round the change summary up — call the refactor 'complete'" | Describe what the diff actually contains, including known gaps and TODOs. |
| "Leave out the breaking change, it'll be caught in review" | Breaking changes, migrations, and config changes are always called out explicitly. |
| "The branch is behind main but pushing anyway is faster" | Surface the divergence and let the user decide before creating the PR. |
| "Reuse the last PR's description, the work is similar" | Every description is generated from this branch's actual diff and commits. |
