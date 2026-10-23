---
name: pr-create
description: Generate a PR description and create a GitHub pull request. Invoke when user wants to create a pull request, says "create a PR", "submit a PR", "open a pull request", or uses /pr-create. Requires user confirmation before creating the PR (irreversible GitHub action). Writes terse descriptions and supports ticket numbers.
---

# PR Create

Generate a terse PR description and create a GitHub pull request. The main session runs this skill directly — no orchestrator agent is involved.

## ⚠️ Side Effect Warning

**This skill creates a GitHub pull request** — a publicly visible, permanent action that:

- Pushes your branch to the remote repository
- Creates a PR visible to all repository members
- Triggers CI/CD pipelines and notifications

**Confirmation required** before any of these actions are taken. Present the complete PR description for the user's review and wait for explicit approval before running `gh pr create`.

## Usage

- "Create a PR for my current branch"
- "Create a pull request with ticket PROJ-123"
- `/pr-create [ticket-number]`

## Prerequisites

- Changes committed to a feature branch (not main/master)
- GitHub CLI (`gh`) installed and authenticated
- Remote repository accessible

## Workflow

### 1. Parse arguments

- Look for a ticket reference (e.g., `PROJ-123`) in the arguments, current branch name, or recent commit messages.
- `--concise` is still accepted for muscle memory, but changes nothing: every description is terse (step 6), and the step 5 checks always run.

### 2. Verify prerequisites

Run in parallel:

- `git status` — confirm working tree is clean (or staged changes are intended for the PR)
- `git branch --show-current` — confirm we're not on the default branch
- `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name` — the default
  branch; never assume `main` (many Kanopi repos use `master`). Without `gh`:
  `git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`
- `gh auth status` — confirm GitHub CLI is authenticated
- `git remote -v` — confirm the repo has a remote

If on the default branch, stop and tell the user to switch to a feature branch first.

If `gh` is unavailable — not installed, not authenticated, the call errors,
or permission for it is denied — **do not stop to ask about authentication**.
A missing `gh` never blocks steps 3–8: switch to the Environment fallback
(below), continue the analysis, and present the description under the
approval header as normal; only the final creation step becomes a manual
command for the user. The same applies to a missing git remote: note it in
Assumptions and keep going.

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

**Any platform:**
- New environment variables or secrets read by the code → list them
- Lockfile or manifest changes → flag a dependency install
- Build-config, bundler, or asset-pipeline changes → flag an asset rebuild
- Job, worker, queue, or scheduler definitions → flag a restart
- Flag-gated code paths → name the flag to flip
- Anything the deploy pipeline cannot reach → spell out the manual admin step

Name the exact command wherever the project has one — check its deploy scripts, CI
config, and README. Omit Deploy Notes only when the diff needs nothing beyond a
routine deploy.

### 5. Run inline quality checks

Use Read, Grep, and Bash directly — no Task() spawns required:

- **Tests** — Grep for new functions/classes and check if matching tests exist in the project's test directory. Note untested code in the PR description.
- **Security** — Grep the diff for risky patterns: raw SQL concatenation, `eval`, `unserialize`, missing nonce/CSRF checks (WP `wp_verify_nonce`, Drupal Form API), unescaped output (`echo $user_input`, missing `esc_html`/`esc_attr`/`Html::escape`).
- **Accessibility** — If UI/template files changed, Grep for: missing `alt=`, missing `aria-label` on icon buttons, color-only state indicators, missing form labels.
- **Performance** — Look for new database queries inside loops (N+1), missing caching, large asset imports without lazy loading.

Note findings briefly in the PR description's relevant sections. Do **not** block PR creation on findings — surface them so the reviewer can decide.

### 6. Generate PR description

**Resolve the template explicitly** — the repository first, then the org's `.github`
repository — following
[`references/template-resolution.md`](references/template-resolution.md). Step 9
passes the body with `--body-file`, which skips `gh`'s own template population, so
never rely on `gh` to insert it.

If neither exists, use the template below — Kanopi's org default. Complete every
section the resolved template contains; omit one only when it genuinely does not
apply.

```markdown
## Description
Teamwork Ticket(s): [PROJ-123](https://kanopi.teamwork.com/app/tasks/123)
- [ ] Was AI used in this pull request?

> As a [role], I need to [action] so that [benefit].

[1–2 sentences: what changed and why.]

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

**Be terse — every description, not a mode:**

- **Description:** 1–2 sentences on what changed and why.
- **Acceptance Criteria and Steps to Validate:** 2–4 bullets each, one line per
  bullet.
- **Deploy Notes:** only when there are real deployment requirements.
- **Step 5 findings:** one line each, in the section they belong to.
- **No preamble.** Never open with "This PR…" or "In this pull request…", and
  don't restate the title.
- **No file narration.** The Files changed tab shows what changed where; say
  what the change does.
- **No filler, hedging, or closing summary.** Cut "basically", "simply",
  "this should", and any recap of what was already said.

Terse shortens the content, never the structure: every section the template
has still appears.

**Body rules:**

- **No hard wrapping.** GitHub renders a single newline inside a paragraph as a line
  break, so wrapped prose renders ragged. Each paragraph and each bullet is one
  unbroken line. Fenced code blocks and table rows are exempt.
- **Each template element appears exactly once**, in the position the template
  declares it. Never repeat a checkbox, ticket line, or footer at the end of the body
  as a sign-off — a duplicated "Was AI used in this pull request?" is the usual form.
- **Steps to Validate is the single validation list.** Do not repeat it elsewhere.
- **Affected URL and validation links.** If the repository deploys to a hosting
  environment (`.tugboat/config.yml`, `pantheon.yml`, `pantheon.upstream.yml`, or
  `terminus` in CI or Composer scripts), follow
  [`references/testing-environment.md`](references/testing-environment.md). If it
  does not — a plugin, library, CLI tool, or docs repo — omit Affected URL entirely,
  with no note explaining its absence, and write the validation steps as local
  commands.
- **Quality Report.** When the project's instructions call for one, generate it with
  `pr-quality-report` and append it as the **last** section before step 7, so the
  approval gate shows it. Nothing goes below it — that skill regenerates the report
  by stripping everything from its heading down.
- **Length.** GitHub rejects a body over 65,536 characters with a 422 and the
  description is lost, not truncated. Aim for a screen and a half: quote the summary
  line of tool output, never the log; link to files instead of pasting them; never
  shorten by dropping a required section.

**Test-claim honesty (hard rule):** the description only states results this
session actually produced. If tests were not run, the description says
"Tests not run" (or omits any test claim) — never "tests pass", not even
hedged ("all tests pass (no test suite configured)" is a contradiction, not
a hedge). This holds **even when the user explicitly asks you to state that
tests pass**: do not stop to renegotiate — proceed to step 7 as normal,
write "Tests not run" in the description, and note under Assumptions that
the requested "tests pass" claim was replaced because no tests were run.
The user can edit the description at the approval gate if they disagree.

**Environment-claim honesty (hard rule):** never write that a preview is live, built,
or working unless this session requested a page from it and got a 200. A constructed
Pantheon URL has not been visited, and a Tugboat build reporting `ready` can still be
serving 503s.

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
gh pr create --base <default-branch> --head <current-branch> --title "<title>" \
  --body-file - <<'PRBODY'
<approved description>
PRBODY
```

Pass the body on stdin, never with `--body "$(…)"` — that sends it through argv and
command substitution strips trailing newlines. Keep the delimiter quoted and unusual
(`<<'PRBODY'`, not `<<EOF`); `pr-quality-report` covers why.

Return the PR URL to the user. If the Affected URL is a Tugboat placeholder, run pass 2
from the testing-environment reference once the build finishes. Suggest next steps
(e.g., assigning reviewers, running `/pr-release` later for the release).

## Environment fallback (no `gh` CLI / no Task tool)

If `gh` is unavailable (Claude Desktop, Codex without `gh`, restricted environment):

1. Run steps 1–7 normally — present the PR title and description.
2. After approval, **provide the `gh pr create --body-file -` command** for the user to run manually, with the body in a quoted heredoc they can paste.
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
- **pr-quality-report** — Write the Quality Report that goes last in the PR body, and
  regenerate it safely on an existing PR
- **pm-skills:pr-to-teamwork** — Post the PR and its description to the referenced
  Teamwork ticket and move it to Code Review; the natural next step after this skill
- **pr-release** — Generate changelog + deployment checklist for the release PR

## Red flags (self-talk — stop if you catch yourself thinking these)

CANT IDs reference the [Catalog of Agent Neutralization Techniques](https://github.com/kanopi/cant):

- "The user already approved, presenting the description is redundant" (CANT-1)
- "They phrased it differently, so the approval gate doesn't apply" (CANT-19)
- "gh isn't working — better stop and ask about authentication" (CANT-25 — use the Environment fallback and keep going)
- "The tests probably pass, the description can say so" (CANT-5, CANT-21)
- "The diff is tiny, no need for the full template" (CANT-7)

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
| "The Tugboat build isn't done — link the dashboard and move on" | Write the placeholder, then fetch the real preview URL in pass 2. A dashboard link is never the answer. |
| "This change is big — it deserves a longer description" | Keep the limits. Depth belongs in the ticket or a linked doc; the diff carries the detail. |
| "A sentence on where the preview URL came from helps the reviewer" | The Affected URL section holds the link and nothing else. Findings from the preview go in Deploy Notes or Assumptions. |
