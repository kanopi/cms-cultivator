---
name: composer-security-update
description: This skill should be used when the user asks to "run a Composer security update", "validate the security PR", "check the automated security PR", "review the security bot PR", "run composer audit", "patch the security advisories", "update the vulnerable packages", "fix the CVEs in this project", "apply the Drupal core security release", or hands over a "Security Advisory:" Teamwork task or a `security/tw-*` pull request. Use it whenever a Drupal or WordPress Composer project needs its advisories resolved, even if the user only says "are we vulnerable?" or names a single CVE. The Kanopi security dashboard already creates the Teamwork task and opens the pull request; this skill finds that existing PR, checks out its branch, and validates it locally with composer audit before and after, a DDEV database snapshot and refresh, update hooks, config drift, theme builds, and a per-advisory cleared/blocked report. Fix-up commits are pushed to the same branch and a validation section is added to the existing PR description, only after the user approves the draft. It never creates a new task, branch, or PR. Routine Dependabot version bumps belong to dependabot-branch-validation; patching a contrib module's code belongs to composer-patch-generator.
---

# Composer Security Update

## Purpose

Validate the automated security pull request for a Teamwork task, and finish it
when the automation fell short.

The Kanopi security dashboard now does the opening moves on its own. For each
site with published advisories it creates a Teamwork task titled
`Security Advisory: {Site} - {packages}`, runs a targeted `composer update` in
CI, opens a pull request from a `security/tw-{task}` branch, and comments the PR
link on the task. This skill does not repeat any of that. Do not create a task,
cut a new branch, or open a new PR.

What the automation cannot do is the part that needs a running site: prove each
advisory actually cleared, run update hooks against production-like data, check
config drift, rebuild themes, and judge whether the lock diff is scoped tightly
enough to ship. That is this skill's job.

The discipline is still scope and honesty. The bot's update is targeted but not
always minimal: it can land a newer minor than the advisory needs, or move
transitive packages. And it runs without `--with-all-dependencies`, so an
advisory pinned by a root requirement can stay installed while the PR still
looks like a fix. Both get reported, not glossed over.

## Scope and safety

- Work on the automated PR's own head branch. Never cut a new branch, never open
  a second PR, and never create or rename the Teamwork task.
- The deliverable is the validated PR: any fix-up commits pushed to its branch,
  and a validation section added to its description. Push only after the user
  has read the drafted text and said to go, even when their instructions
  otherwise forbid pushing. Never push on your own judgement that it looks
  fine. Never force-push, never rewrite or squash the bot's commit, never
  push to the base branch, never merge, never approve the PR.
- Do not change the PR title. The dashboard sets it.
- If no open automated PR exists for the task, stop and ask, starting with the
  line `NO AUTOMATED SECURITY PR: this skill validates an existing PR and does
  not create one.` Do not fall back to creating a branch, running the update
  yourself, or opening a PR, even when the user asks for that as a shortcut.
- Snapshot the DDEV database before the first branch switch and restore it at
  the end. The refresh in step 6 and `drush updatedb` in step 9 both replace or
  mutate the local database; the snapshot is what makes this reversible.
- Report Drupal config drift. Do not run `config:export` to "fix" it and do not
  commit exported config unless the user asks.
- Do not widen a `composer.json` constraint to reach a fixed version unless the
  user asks. Widening can pull a major version, a different risk profile than a
  security patch.
- Stop and report if the working tree is dirty at the start. Do not stash the
  user's work.
- Follow the commit conventions in the user's and the project's CLAUDE.md,
  including any rule about AI attribution trailers.

## Workflow

### 1. Preflight

```bash
git status --short
git rev-parse --abbrev-ref HEAD
ddev describe
```

Record the starting branch; it is restored in step 14. If the tree is dirty,
stop and tell the user, starting with the line
`WORKING TREE NOT CLEAN: commit or stash before continuing.` Do not switch
branches, snapshot, or run Composer until they have. Stop as well if DDEV is not
running.

### 2. Find the task and its automated PR

The user may give a Teamwork task ID, a task URL like
`https://kanopi.teamwork.com/app/tasks/30160608` whose trailing number is the
ID, a PR number or URL, or nothing. With nothing, ask and stop.

Fetch the task with the Teamwork MCP (`twprojects-get_task`). Its description is
the dashboard's advisory list: for each package, the CVE, the SA identifier,
severity, and the version that fixes it. Record that list; it is what the ticket
asked for, and step 8 checks the PR against it. Without the Teamwork MCP, ask
the user to paste the task description rather than guessing the advisories.

Find the PR, in this order:

1. The task's comments (`twprojects-list_comments` with `task_id`). The
   dashboard posts one starting "An automated pull request is ready for review"
   with a GitHub PR link.
2. GitHub, by branch name:

   ```bash
   gh pr list --state all --search "head:security/tw-<task-id>" --json number,url,state,headRefName,baseRefName,author
   ```

Confirm before going further:

```bash
gh pr view <number> --json number,url,state,isDraft,author,headRefName,baseRefName,title,body,files,commits
```

- `state` is `OPEN`. A merged PR needs no validation branch; a closed one means
  someone rejected it. Report either and stop.
- The head branch is `security/tw-<task-id>` and the task ID matches.
- Keep the original body exactly as returned; step 12 appends to it.

If the user gave a PR instead of a task, read the task ID from the branch name
or the body's `Teamwork task:` line and fetch the task anyway.

The base branch is the PR's `baseRefName`, not an assumption about `main`. Some
projects run a dev-to-prod flow where it is `dev`. Say in the report which base
was used.

### 3. Snapshot the database

First, before anything switches branches or replaces the database:

```bash
ddev snapshot --name=presecurity-$(date +%Y%m%d-%H%M%S)
ddev snapshot --list
```

Record the exact name DDEV reports and confirm it is listed. If it fails, stop:
no refresh and no update hooks without a restore point.

### 4. Audit the base

```bash
git fetch --prune origin
git checkout <base>
git pull --ff-only origin <base>
ddev exec composer audit --locked --format=json > /tmp/audit-before.json
python3 "${CLAUDE_PLUGIN_ROOT}/skills/composer-security-update/scripts/audit_table.py" composer.lock < /tmp/audit-before.json
```

`--locked` audits `composer.lock`, which is what ships, and does not need
`vendor/` to match, so no install is needed on the base. `composer audit` exits
non-zero when it finds advisories, so a non-zero exit is the normal case here.
It can also mean an abandoned package rather than an advisory, so read the JSON
instead of trusting the exit status.

Use `ddev exec composer` for the audit, not `ddev composer`. The `ddev composer`
wrapper discards captured output when Composer exits non-zero, so the redirect
lands an empty file exactly when there are advisories to lose; `ddev exec`
passes stdout through. Everything else here can use `ddev composer`.

Compare the audit with the task's advisory list. The audit is the ground truth
for the base; the task is what the dashboard saw when it filed the ticket. Note
any advisory the audit reports that the task does not (released since, or a dev
dependency the dashboard ignores), and any task advisory the audit no longer
reports (already fixed on the base by another merge).

If `composer audit` is unavailable the project is on Composer 1 or an early 2.x.
Report that and stop rather than guessing.

Show the user the advisory table before going on. A critical advisory in a
dev-only dependency and one in a runtime dependency warrant different urgency,
and that judgement is theirs.

### 5. Check out the PR branch

```bash
git fetch origin security/tw-<task-id>
git checkout -b security/tw-<task-id> --track origin/security/tw-<task-id>
ddev composer install
```

Tracking the PR's own remote branch is correct here; it is what fix-up commits
push to. (The rule against tracking applies to the base branch, not this one.)
If a local branch of that name already exists, check it is not ahead of or
diverged from the remote before reusing it; report and stop if it is.

Use `ddev composer`, never bare `composer`: Drupal projects routinely require a
newer PHP than the host has, and resolving against the wrong platform version
silently produces a different dependency tree than CI will.

### 6. Refresh the database

With the snapshot safe and the branch checked out, pull a current database from
the hosting provider:

```bash
ddev db-refresh
```

`updatedb` in step 9 is only meaningful against production-like data. A stale
local database can run every update hook clean while the same hooks fail on real
content, which makes the PR look validated when it is not.

`db-refresh` is a Kanopi add-on command, not core DDEV, so confirm this project
defines it (`ls .ddev/commands/web .ddev/commands/host`) before repeating the
name. A project may ship `db-refresh-scrubbed` and deliberately no unscrubbed
refresh, or take the environment as an argument (`ddev db-refresh live`); use
the names and aliases it actually defines. With no refresh command, say so, note
that `updatedb` will run against whatever data is local, and continue rather
than inventing a pull.

If the refresh fails, report the error and stop. A half-imported database is
worse than the one that was there; restore the snapshot per step 14 first.

### 7. Prove each advisory actually cleared

This step separates a real security fix from a diff that looks like one.

```bash
ddev exec composer audit --locked --format=json > /tmp/audit-after.json
python3 "${CLAUDE_PLUGIN_ROOT}/skills/composer-security-update/scripts/audit_table.py" composer.lock < /tmp/audit-after.json
```

An advisory in `audit-before.json` and absent from `audit-after.json` is
cleared. Anything still listed is **blocked**, and blocked advisories are the
most important thing in the final report. For each, name what holds it back:

```bash
ddev composer why-not vendor/package <fixed-version>
ddev composer why vendor/package
```

`why-not` prints the constraint forbidding the fixed version; `why` prints what
pulls the package in. Together they say whether the blocker is the project's own
`composer.json`, a contrib module's requirement, or Drupal core.

The most common blocker on these PRs is the bot itself: it updates without
`--with-all-dependencies`, and its own Composer output (in the PR body's
"Composer output" block) says so with lines like "Dependency X is also a root
requirement ... keeping locked at old version." When that is what holds an
advisory back, fix it on the branch with a targeted update:

```bash
PKGS=$(python3 "${CLAUDE_PLUGIN_ROOT}/skills/composer-security-update/scripts/audit_table.py" --format=packages < /tmp/audit-after.json)
ddev composer update $PKGS --with-all-dependencies
```

When `drupal/core-recommended` pins the vulnerable package, include core:

```bash
ddev composer update "drupal/core-*" $PKGS --with-all-dependencies
```

Still targeted: the still-flagged packages and core, nothing else. Re-run the
audit afterwards. Avoid `--no-install` on projects with
`cweagans/composer-patches`; it can remove a patched package and skip the
reinstall.

When the blocker is a constraint in `composer.json` or a contrib module's
requirement, report it with the constraint quoted and stop there. Do not widen
the constraint and do not reach for a `cweagans` patch unless the user asks.
Both change the risk profile from "apply a vendor's fix" to "ship something the
vendor has not shipped," which is the user's call.

Also confirm nothing new appeared. A transitive bump can introduce an advisory
that was not there before.

### 8. Review the bot's diff

```bash
git log --oneline origin/<base>..HEAD
git diff --stat origin/<base>...HEAD
git diff origin/<base>...HEAD -- composer.json composer.lock
```

Check, and note each for the description:

- **Scope.** Every lock change should be an advisory package or something it
  required to move. List unrelated packages that moved.
- **Version jumps.** Compare each landed version with the task's "fixed in"
  version. A newer minor than the fix needs (for example fixed in 2.2.2, landed
  2.3.2) is not wrong, but it carries feature changes, so name it and give the
  release notes a look. A major-version jump in any package, transitive or not,
  is the one thing in a security update that can genuinely break something;
  flag it prominently.
- **`composer.json` untouched.** The bot should only move the lock. A changed
  constraint is a widening the user did not approve; report it.
- **PHP platform.** The bot's footer says which PHP it resolved on and what the
  site reports. Confirm that matches `config.platform.php` and the DDEV PHP
  version; a mismatch can mean the lock resolves differently in CI.
- **Generated files.** If the project uses `joachim-n/composer-manifest`, the
  bot's diff should include `composer-manifest.yaml`; step 9 checks it.

### 9. Install and run the project checks

```bash
ddev composer install
ddev drush updatedb -y
ddev drush cache:rebuild
```

A large `composer install` can report success while still partway through.
Confirm it landed with `ddev drush status --field=drupal-version`, and install
again if that disagrees with `composer.lock`.

**Validate the lock.** A stale content hash produces an "out of date" warning.
Quote the shortest decisive line of any error in the report.

```bash
ddev exec composer validate --no-check-publish
```

**Check the Composer manifest if the project has one.** Composer updates
`composer.lock` but not files produced by Composer plugins:

```bash
grep -n 'composer-manifest' composer.json
git status --short composer-manifest.yaml
git diff origin/<base>...HEAD -- composer-manifest.yaml
```

After the install, `composer-manifest.yaml` should be unchanged in the working
tree (the bot already committed it). A working-tree change means the bot's
manifest is stale or the local install is out of sync: run `ddev composer
install` again, and if the change persists, it is a real fix-up to commit. The
committed diff should show only the packages that moved in the lock.

**Check for Drupal config drift.** A security release can ship changed default
config that `updatedb` imports, leaving active config ahead of what is exported:

```bash
ddev drush config:status
```

`No differences between DB and sync directory` is clean, meaning no `drush cex`
is needed; record that for step 12. Anything else is drift. Report it as a table
of config object and state (`Only in DB`, `Different`, `Only in sync dir`) and
let the user decide. Check whether the drift also appears on the base with the
same database, so the report can say whether this change caused it.

**WordPress projects** have no `updatedb` or `config:status` step. Run the
Composer checks, then confirm the site still boots:

```bash
ddev wp core version
ddev wp plugin list --status=active
```

**Smoke-test the patched behaviour.** For each cleared advisory, load a page
that exercises the module (an embedded paragraph, a trimmed teaser, the patched
form) and confirm it still renders. This is what turns the steps to validate in
step 12 into something already done once.

### 10. Theme build check

Run this only if the PR touched a `package.json` or `package-lock.json`:

```bash
git diff --name-only origin/<base>...HEAD | grep -E 'package(-lock)?\.json$'
```

For each theme path, install from the lock first, then build:

```bash
ddev exec bash -c "cd <theme-path> && npm ci"
ddev exec bash -c "cd <theme-path> && npm run build"
```

Use the project's real script name (`build`, `production`, `dev`) from
`package.json`. A build that exits 0 without producing files is not a pass. If
compiled CSS or JS is tracked in git, commit the rebuilt assets separately.

Two `npm ci` failures on ARM containers are environmental, not lock defects:
`Failed to set up Chromium r<build>` from Puppeteer, and `autoreconf: not found`
from imagemin binary builds. Fall back to
`PUPPETEER_SKIP_DOWNLOAD=1 npm ci --ignore-scripts`, say so in the report, and
confirm the build still runs.

### 11. Commit fix-ups, if any

Most runs end here with nothing to commit: the bot's commit is the fix, and the
deliverable is the validation. Only commit what validation proved missing, on
top of the bot's commit, never amending or squashing it.

```
fix(deps): update symfony/http-kernel with core for CVE-2024-51736

The automated update ran without --with-all-dependencies, so
drupal/core-recommended kept symfony/http-kernel locked at 6.4.12.
Updated with core so the pinned version could move.

Refs: TW-30160608
```

Use `fix(deps)` for runtime and `fix(deps-dev)` for dev dependencies. Regenerated
files get their own `chore(deps): regenerate composer-manifest.yaml` commit.

Then show the user what is on the branch:

```bash
git log --oneline origin/<base>..HEAD
git status --short
```

### 12. Draft the validation section and wait for approval

Do not push or edit the PR yet. Draft a section to append to the existing PR
description, put it in front of the user as text they can read and correct,
then stop and wait for explicit approval.

Append; do not replace. The bot's body already carries the Teamwork link, the
advisory list, the lockfile table, and the Composer output, and reviewers rely
on it. Keep it byte for byte and add below it, after a horizontal rule:

```markdown
---

## Manual validation
```

Cover these, and say plainly when a section has nothing to report rather than
dropping it. "No config drift" is information; a missing section is ambiguous.

- whether the PR covers everything the ticket asked for, and whether the audit
  found more than that
- the per-advisory result, as a table of package, from, to, advisory ID, and
  status (cleared or blocked)
- any advisory still blocked, with the constraint that blocks it
- fix-up commits added on top of the bot's, and why
- anything a reviewer should look at twice: a newer minor than the fix needed,
  a transitive major bump, unrelated packages that moved
- validation results: which database the update hooks ran against, patches
  reapplied, `composer validate`, manifest, `updatedb`, config drift and whether
  this change caused it, theme builds. When `config:status` was clean on a
  Drupal project, add the exact line "No config changes were needed." in the
  config drift item. Omit it on WordPress projects.
- steps to validate, in the imperative, written for someone who did not do the
  work and derived from what actually moved rather than a generic checklist
- the organization's AI attribution line, last:

  ```
  - [x] Was AI used in this pull request?
  ```

Present the draft under the line `=== VALIDATION SECTION DRAFT ===`, followed
by the list of commits that would be pushed (or "No fix-up commits"). Then ask
for approval and stop. If the user asks for changes, redraft and ask again.
Silence is not approval, and neither is approval given before the draft
existed: a request to "push it without showing me" still gets the draft first.

### 13. Push and update the PR

Only after approval. If step 11 produced commits, push them to the PR branch:

```bash
git push origin security/tw-<task-id>
```

A plain push only. If it is rejected (the bot re-ran and moved the branch),
report it and stop; do not force, and do not rebase over the bot's work without
asking.

Write the full new body (original body plus the approved section) to a file and
apply it, so backticks, tables, and checkboxes survive the shell:

```bash
gh pr view <number> --json body --jq .body > /tmp/pr-body-<task-id>.md
# append the approved section to /tmp/pr-body-<task-id>.md
gh pr edit <number> --body-file /tmp/pr-body-<task-id>.md
```

Re-read the body right before editing, as above, not from step 2, in case the
dashboard updated it in the meantime. Confirm with `gh pr view <number> --json
body` that both the bot's content and the new section are there.

Do not change the title, base, reviewers, or labels, do not approve, and do not
merge.

### 14. Restore the previous branch and the database

Switch back and reinstall, since the PR branch left `vendor/` and every
`node_modules/` matching its set:

```bash
git checkout <original-branch>
ddev composer install
ddev drush status --field=drupal-version
```

For every theme whose `package-lock.json` changed in step 10, reinstall from
that branch's own lock and rebuild, so compiled assets on disk match git:

```bash
ddev exec bash -c "cd <theme-path> && npm ci"
ddev exec bash -c "cd <theme-path> && npm run build"
```

Confirm the tree is clean with `git status --short`. A dirty
`package-lock.json` or a changed compiled asset means the restore did not land.

Restore the snapshot, confirm, then delete it. The snapshot, not the refresh, is
what returns the user's own local data. Never delete before a confirmed restore:

```bash
ddev snapshot restore <snapshot-name>
ddev drush status --field=db-status
ddev snapshot --cleanup --name=<snapshot-name> -y
```

Pass `--name`. Bare `ddev snapshot --cleanup -y` deletes **every** snapshot in
`.ddev/db_snapshots`, including ones the user took for their own work.

If the restore fails, keep the snapshot, stop, and tell the user the snapshot
name and the exact error.

Leave the local `security/tw-<task-id>` branch in place; the user may want it
for review follow-ups.

## Reporting

Lead with the advisory outcome, one row per advisory:

| Package | From | To | Fixed in | Advisory | Status |
| --- | --- | --- | --- | --- | --- |
| drupal/smart_trim | 2.2.0 | 2.3.2 | 2.2.2 | SA-CONTRIB-2026-332 | Cleared |
| drupal/contrib-thing | 1.2.0 | 1.2.0 | 1.2.1 | CVE-2024-99999 | Blocked |

For every blocked row, quote the constraint that blocks it and where it comes
from, so the user can decide between widening the constraint, patching, or
accepting the risk.

Then state:

- the Teamwork task, the PR URL, and its head and base branches
- the refresh command used and which environment the database came from, or that
  the project has no refresh command
- anything the bot's diff got wrong or overreached on, and the fix-up commits
  added, if any
- whether `composer validate` passed, and the manifest result
- the config drift result, listed object by object if there is any
- which themes were rebuilt and whether each build passed
- any advisory that appeared for the first time after the update
- that the PR description was updated, and that the PR is open and unmerged
- confirmation that the original branch, its `vendor/`, its theme
  `node_modules/`, and the database were all restored, and the snapshot deleted

Call out patterns rather than one-off facts. An advisory the bot repeatedly
leaves blocked for want of `-W`, or one blocked by a contrib module's own
constraint, is worth raising with whoever owns the dashboard or upstream rather
than rediscovering every cycle.
