---
name: dependabot-branch-validation
description: This skill should be used when the user asks to "validate Dependabot branches", "consolidate the Dependabot PRs", "roll up the dependency bumps", "check the Dependabot PRs", "verify the dependency bumps", "make sure the lock file was computed correctly", "recompute composer.lock", "recompute package-lock.json", or wants every open automated dependency update combined into one reviewable branch and PR. Covers DDEV database snapshots, Composer and npm lock verification, theme build checks, Drupal config drift, generated-file gaps that Dependabot misses, and consolidated PR creation. Automated security advisory PRs (`security/tw-*` branches) belong to composer-security-update.
---

# Dependabot Branch Validation

## Purpose

Combine every open Dependabot branch into a single consolidated branch, validate
the whole set together, and open one pull request for it. Dependabot edits lock
files directly rather than running the package manager the way a developer
would, so two classes of problem show up: a lock file that does not match what
the resolver actually produces, and tracked generated files that were never
regenerated alongside the lock. Reviewing fifteen separate PRs also costs
fifteen review cycles for what is usually one decision.

The consolidated branch carries one commit per original Dependabot PR, each
referencing that PR number, so the history stays auditable and any single bump
can be reverted on its own.

## Scope and safety

- This skill ends in a push and a pull request. That is the deliverable, but
  push only after the user has seen the branch contents in step 10 and said to
  go. Never push on your own judgement that it looks fine, and treat a request
  to skip the review as a request to see it quickly, not a waiver.
- Never force-push. Never push to `main`, `dev`, or any other base branch.
- Never merge the consolidated PR. Never close or delete the original Dependabot
  PRs or their remote branches: Dependabot closes its own PRs when the bumps
  land, and closing them by hand is the user's call.
- Take the database snapshot before the first branch switch, and restore it at
  the end. `ddev refresh` and `drush updatedb` both mutate the local database,
  so the snapshot is what makes this workflow non-destructive.
- Report Drupal config drift. Do not run `config:export` to "fix" it, and do not
  commit exported config to the consolidated branch unless the user asks.
- Follow the commit conventions in the user's and the project's CLAUDE.md,
  including any rule about AI attribution trailers.
- Stop and report if the working tree is dirty at the start. Do not stash the
  user's work.

## Workflow

### 1. Preflight

```bash
git status --short
git rev-parse --abbrev-ref HEAD
ddev describe
```

Record the starting branch. It is restored in step 11. If the tree is dirty,
stop and tell the user, starting with the line
`WORKING TREE NOT CLEAN: commit or stash before continuing.` Do not snapshot,
switch branches, or merge anything until they have. Stop as well if DDEV is not
running.

### 2. Snapshot the database

Take the snapshot first, before anything switches branches or refreshes the
database. Use a fixed, recognizable name so the restore and the cleanup in
step 12 target exactly this snapshot:

```bash
ddev snapshot --name=predependabot-$(date +%Y%m%d-%H%M%S)
```

Record the exact snapshot name that DDEV reports. Confirm it exists before
continuing:

```bash
ddev snapshot --list
```

If the snapshot fails, stop. Do not proceed into `ddev refresh` without a
restore point.

### 3. Enumerate the open Dependabot PRs and find the base branch

Do not assume the base is `main`. Dependabot targets whatever branch the
repository configures, which on Drupal projects with a dev-to-prod flow is
routinely `dev`. Diffing or branching from the wrong base reports every commit
the base has that the Dependabot branch lacks as if the Dependabot branch had
introduced it, so a lock-file-only branch appears to be rewriting templates and
config.

Ask GitHub, which knows the answer exactly, and capture the PR numbers at the
same time. The PR number is required for the commit messages in step 6:

```bash
git fetch --prune origin
gh pr list --state open --limit 100 \
  --json number,headRefName,baseRefName,title \
  --jq '.[] | select(.headRefName|startswith("dependabot/")) | "\(.number)\t\(.baseRefName)\t\(.headRefName)\t\(.title)"'
```

When `gh` is unavailable, fall back to comparing candidate bases by how many
files a branch appears to change. The correct base is the one that makes the
branch look like what it is, a lock file update:

```bash
for base in main dev master develop; do
  git rev-parse --verify --quiet "origin/$base" >/dev/null || continue
  echo "$(git diff --name-only origin/$base...origin/<branch> | wc -l) files  $base"
done
```

The lowest count wins. Do not use merge-base distance for this: a base that has
moved a few commits since the branch was cut can sit closer to the branch than
the true base, so that heuristic picks the wrong answer on exactly the
repositories where getting it right matters.

Without `gh` there is also no PR number. Ask the user for the numbers rather
than committing without them.

If the open PRs target more than one base branch, stop and ask. One consolidated
branch cannot serve two bases.

Say in the report which base was used.

### 4. Check out the base branch and refresh the database

```bash
git checkout <base>
git pull --ff-only origin <base>
```

Then refresh the database so the validation runs against production-like data
rather than whatever the local database drifted into. Refresh commands are
custom, not DDEV builtins, so they exist only on projects that ship them.
Check what this project defines before calling anything:

```bash
ls .ddev/commands/host .ddev/commands/web
ddev help | grep -iE 'refresh|db-refresh|db-rebuild|pull'
```

Use whichever the project actually defines, in this order of preference:
`ddev refresh`, `ddev db-refresh`, `ddev pull <provider>`. If the project
defines none of them, say so in the report and continue with the existing
database. Do not invent a refresh out of `drush sql:drop` and a guessed dump
path.

Install dependencies for the base so the tree matches it before any merging
starts:

```bash
ddev composer install
```

### 5. Create the consolidated branch

```bash
git checkout -b dependabot/consolidated/$(date +%Y-%m-%d)
```

Do not set an upstream tracking reference to the base branch. The branch gets its own remote in step 10.

If a branch by that name already exists from an earlier run today, ask the user
whether to reuse it, rename it, or delete it. Do not silently reset it.

### 6. Merge each Dependabot branch as one commit

Work through the branches one at a time, oldest PR number first, so that later
bumps resolve against the earlier ones. Squash each branch into a single commit
so the consolidated history reads as one commit per original PR:

```bash
git merge --squash origin/<branch>
git commit
```

Write the message in Conventional Commits style with the original PR number in a
footer:

```
build(deps): bump vendor/package from 1.2.3 to 1.2.4

Squashed from the Dependabot branch dependabot/composer/vendor/package-1.2.4.

Refs: #<pr-number>
```

Use `build(deps)` for runtime dependencies and `build(deps-dev)` for dev
dependencies. Keep one commit per original PR even when two PRs touch the same
lock file.

#### Resolving the lock file conflicts

Conflicts in `composer.lock` and `package-lock.json` are expected once the
second branch merges, because every branch was cut from the same base and each
rewrote the same file. Never hand-merge a lock file and never take one side
wholesale. Resolve by discarding the conflicted lock and letting the resolver
recompute it:

```bash
git checkout --ours composer.lock          # keep the consolidated branch's lock
ddev composer update <vendor/package> --with-all-dependencies
git add composer.lock composer.json
```

For npm, the same shape:

```bash
git checkout --ours <theme-path>/package-lock.json
ddev exec bash -c "cd <theme-path> && npm install --package-lock-only --ignore-scripts"
git add <theme-path>/package-lock.json
```

`composer.json` and `package.json` conflicts are different: those are real
content, one added constraint per branch, and both sides must survive. Merge
them by hand, keeping every bumped constraint.

### 7. Run the updates

With every branch merged, install the consolidated result and run the database
updates once, rather than after each merge:

```bash
ddev composer install
ddev drush updatedb -y
ddev drush cache:rebuild
```

Use the project's PHP runtime, not the host's. Drupal projects commonly require
a newer PHP than the host has installed, and resolving against the wrong
platform version silently produces a different dependency tree. Running through
DDEV (`ddev composer`) uses the container's PHP.

#### Avoid `--no-install` on patched projects

On projects using `cweagans/composer-patches`, adding `--no-install` to a
`composer update` can leave the tree half-updated: Composer removes a patched
package so it can be re-patched, then skips the reinstall. The package directory
disappears and the site breaks. Either omit `--no-install`, or follow it with a
plain `ddev composer install` to restore the tree.

A large `composer install` can report success while still being partway through
its work. Confirm it landed:

```bash
ddev drush status --field=drupal-version
```

If it disagrees with `composer.lock`, run `ddev composer install` again.

### 8. Composer checks

Run these only if the consolidated branch changed `composer.json` or
`composer.lock`.

**Install with no version conflicts.** Confirm the lock is internally consistent
with `composer.json`, then prove a clean resolve:

```bash
ddev composer validate --no-check-publish
ddev composer install --dry-run
```

A stale content hash produces an "out of date" warning from `validate`. A
conflict surfaces from `install` as `Your requirements could not be resolved to
an installable set of packages`. Quote the shortest decisive line of that error
in the report and name the two packages that disagree.

Then re-resolve each bumped package and confirm the resolver agrees with what
Dependabot wrote:

```bash
ddev composer update <vendor/package> --with-all-dependencies
git status --short
```

`Nothing to modify in lock file` with an unchanged `composer.lock` means the
lock is correct. If the lock does change, Dependabot's resolution was incomplete
(usually a missed transitive dependency); commit the regenerated lock as a
separate follow-up commit referencing the same PR number.

**Update the Composer manifest if the project has one.** Dependabot updates
`composer.lock` but not files produced by Composer plugins. The recurring one is
`composer-manifest.yaml` from `joachim-n/composer-manifest`, which is tracked in
git and drifts on every single Composer PR. Check whether the project uses it,
then check the file:

```bash
grep -n 'composer-manifest' composer.json
git status --short
git diff composer-manifest.yaml
```

The diff should show only the bumped packages and their transitive dependencies.
If it shows unrelated packages, the local install state is out of sync: run
`ddev composer install` and re-check before committing.

Commit it as its own commit that explains the gap:

```
chore(deps): regenerate composer-manifest.yaml

Dependabot updates composer.lock but never the generated
composer-manifest.yaml. Regenerated via composer install.

Refs: #<pr-number>, #<pr-number>
```

**Check for Drupal config drift.** A Composer update can ship new or changed
default config that `updatedb` imports, which leaves the site's active config
ahead of what is exported in the repository:

```bash
ddev drush config:status
```

`No differences between DB and sync directory` is the clean result, meaning no
`drush cex` is needed; record that for the PR description in step 10. Anything
else is drift caused by this set of updates. Report it as a table of config
object and state (`Only in DB`, `Different`, `Only in sync dir`) and let the
user decide. Do not run `config:export`, and do not commit exported config to
the consolidated branch, unless the user explicitly asks for it. An update hook
that legitimately adds config is a normal outcome that still needs a human to
approve the export.

Finish by verifying an update is really installed, for example
`ddev exec vendor/bin/phpcs --version` after a PHP_CodeSniffer bump.

### 9. Theme build check

Run this only if the consolidated branch changed a `package.json` or
`package-lock.json`. Find the affected themes from the diff rather than assuming
one:

```bash
git diff --name-only origin/<base>...HEAD | grep -E 'package(-lock)?\.json$'
```

For each theme path, install from the lock **first**, then recompute. Order
matters: `npm install --package-lock-only` still reads the tree on disk, so
recomputing against a stale `node_modules` can re-resolve a subtree and invent
churn that has nothing to do with Dependabot. Reifying the lock first removes
that variable, and doubles as the installability check because `npm ci` verifies
every integrity hash:

```bash
ddev exec bash -c "cd <theme-path> && npm ci"
ddev exec bash -c "cd <theme-path> && npm install --package-lock-only --ignore-scripts"
git diff --stat -- <theme-path>/package-lock.json
```

An empty diff means the lock is correct. If there is churn, re-run both commands
before concluding anything. Churn that vanishes on a second pass was an artifact
of install state, not a Dependabot error, and committing it would bury a real
dependency change under an unrelated rewrite.

Then prove the theme still compiles. This is the check that matters most in a
consolidated branch, because two individually safe bumps can break a build
together:

```bash
ddev exec bash -c "cd <theme-path> && npm run build"
```

Use the project's real script name (`build`, `production`, `dev`) from
`package.json`. Confirm the compiled assets actually changed on disk or that the
build wrote its output; a build that exits 0 without producing files is not a
pass. If compiled CSS or JS is tracked in git, commit the rebuilt assets as
their own commit.

If the build fails, identify which bump caused it by reverting that single
commit on the consolidated branch and rebuilding. Report the culprit PR number
and leave that bump out of the consolidated branch rather than shipping a broken
build.

#### Match the lock's own format

Check `lockfileVersion` at the top of `package-lock.json` before recomputing.
npm preserves whatever version it finds, so a recompute normally will not
reformat the file on its own. But if the project is mid-migration, or a
recompute has to be forced into a specific format to compare like with like, be
explicit:

```bash
npm install --package-lock-only --ignore-scripts --lockfile-version 2
```

A v2 lock carries a full duplicate of the tree in a legacy `dependencies` block
alongside the modern `packages` block. Dependabot's partial edits hide well in
that duplication, so on a v2 project read both blocks when auditing a diff, and
consider proposing a one-time migration to v3 as a separate change rather than
smuggling it into a dependency PR.

Node version still matters for the build even when it does not move the lock.
Prefer the container's Node so results match CI, and check whether the project's
`.nvmrc` agrees with the DDEV `nodejs_version`; a mismatch between them is worth
reporting on its own.

#### Native install failures are usually environmental

Two failures show up on ARM containers and are not lock defects:

- `Failed to set up Chromium r<build>` from Puppeteer. Retry with
  `PUPPETEER_SKIP_DOWNLOAD=1`.
- `autoreconf: not found` from imagemin binary builds, which need autotools that
  the web container does not ship.

When these block `npm ci`, fall back to
`PUPPETEER_SKIP_DOWNLOAD=1 npm ci --ignore-scripts`. That still validates
resolution and integrity hashes, which is the point of the check. Say so in the
report rather than presenting it as a full install, and confirm the webpack or
Vite build still runs afterward.

### 10. Push the branch and open the PR

Show the user the full commit list and the diffstat first, under the line
`=== CONSOLIDATED BRANCH READY FOR REVIEW ===`, together with the validation
results from steps 8 and 9 and any bump left out. Then stop and get explicit
confirmation before pushing:

```bash
git log --oneline origin/<base>..HEAD
git diff --stat origin/<base>...HEAD
```

Silence is not approval, and neither is approval given before this summary
existed.

Then push and open the PR:

```bash
git push -u origin dependabot/consolidated/<yyyy-mm-dd>
```

Use the `pr-create` skill so the PR body follows the project's template. Title it
`[TW-{teamwork-task-number}] Consolidated Dependabot updates {yyyy-mm-dd}`. A
consolidated dependency roll-up often has no Teamwork task; ask the user for the
number rather than inventing one, and drop the prefix if they say there is none.

The PR body must list every rolled-up PR by number so reviewers can trace each
bump back and Dependabot's own PRs are visibly superseded, and must record the
validation results:

- one line per bump: package, old version, new version, `Refs #<pr-number>`
- Composer: validate, conflict-free install, manifest regenerated or not present
- Drupal config drift: clean, or the list of drifted config objects. When
  `config:status` ran in step 8 and was clean, add the exact line "No config
  changes were needed." here. Omit the line when step 8 was skipped because only
  theme or other npm dependencies changed, since no config check ran.
- theme build: which themes were built and whether each passed
- anything that could not be verified and why

Do not merge the PR. Do not close the original Dependabot PRs.

### 11. Restore the previous branch and its dependencies

```bash
git checkout <original-branch>
ddev composer install
```

Reinstall for that branch, since the consolidated branch left `vendor/` and
every `node_modules/` matching the updated set. Confirm Composer landed:

```bash
ddev drush status --field=drupal-version
```

If it disagrees with `composer.lock`, run `ddev composer install` again.

#### Restore the theme node packages

`node_modules/` is not restored by the database snapshot and is not touched by
`git checkout`, so it silently keeps the consolidated branch's dependency tree.
The user is then developing against packages their branch never asked for, and
the next theme build produces output that does not match the lock in git. Undo
it explicitly.

Reinstall every theme whose `package-lock.json` the consolidated branch changed,
which is the same list step 9 built:

```bash
git diff --name-only origin/<base>...dependabot/consolidated/<yyyy-mm-dd> \
  | grep -E 'package(-lock)?\.json$'
```

For each of those theme paths, install from the original branch's own lock:

```bash
ddev exec bash -c "cd <theme-path> && npm ci"
```

Use `npm ci`, not `npm install`. `ci` deletes `node_modules` first and installs
exactly what the lock pins, which is the whole point here; `npm install` would
reconcile against the tree left behind and can leave the newer packages in
place.

Then rebuild, so the compiled assets on disk match the restored packages:

```bash
ddev exec bash -c "cd <theme-path> && npm run build"
```

Carry over the same environmental fallbacks from step 9 when `npm ci` fails on
native builds, for example `PUPPETEER_SKIP_DOWNLOAD=1 npm ci --ignore-scripts`.

Finish by confirming the tree is clean. A dirty `package-lock.json` or a changed
compiled asset here means the restore did not land:

```bash
git status --short
```

### 12. Restore the snapshot and delete it

Restore first, confirm second, delete third. Never delete before a confirmed
restore.

```bash
ddev snapshot restore <snapshot-name>
ddev drush status --field=db-status
```

Once the restore succeeds, remove that one snapshot by name:

```bash
ddev snapshot --cleanup --name=<snapshot-name> -y
```

Pass `--name`. Bare `ddev snapshot --cleanup -y` deletes **every** snapshot in
`.ddev/db_snapshots`, including ones the user took for their own work.

If the restore fails, keep the snapshot, stop, and tell the user the snapshot
name and the exact error. A failed restore with the snapshot still on disk is
recoverable; a deleted snapshot is not.

## Reporting

Give the user a short table with one row per rolled-up PR: PR number, package,
version change, and the consolidated commit SHA. Then state:

- which base branch was used and how it was determined
- the consolidated branch name and the new PR URL
- whether Composer installed conflict-free, and whether the manifest was regenerated
- the config drift result, listed object by object if there is any
- which themes were rebuilt and whether each build passed
- any bump left out of the consolidated branch, and why
- confirmation that the original branch, its `vendor/`, its theme
  `node_modules/`, and the database snapshot were all restored, and that the
  snapshot was deleted

Call out patterns rather than one-off facts. A generated file that Dependabot
never updates affects every future PR and is worth fixing in CI, not by hand each
time.
