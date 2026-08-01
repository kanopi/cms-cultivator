---
name: worktree-manager
description: Create, list, and tear down git worktrees following Kanopi's branch naming conventions so developers and agents can work multiple tickets in parallel without clobbering each other's working tree. Creates a new branch, or attaches a worktree to a branch that already exists locally or on origin. Handles DDEV isolation automatically (folder-derived project name, no pinned ports) for Drupal and WordPress, and plain worktree setup for Next.js. Invoke when the user wants to start a ticket in a fresh worktree, run more than one Claude Code or Claude Desktop session at once, says "create a worktree", "new worktree for tw1234", "spin up a parallel branch", "work on two tickets at once", "worktree for an existing branch", "check out this branch in a worktree", "pick up a teammate's branch", "resume a branch I already have", "/worktree-manager", or asks how to clean up a finished worktree. Use this skill even if the user only says "I need to work on another ticket without losing my current one."
---

# Worktree Manager

Create and tear down git worktrees that follow Kanopi's branch conventions and stay isolated at the DDEV layer, so multiple tickets — and multiple AI sessions — can run side by side from a single clone.

## Why this exists

A worktree checks out a second branch into its own directory while sharing one `.git`. That is the primitive that lets two Claude Code sessions (or one CLI session and one Claude Desktop "code" session) work different tickets at the same time without `git checkout` thrash or stepping on each other's files. It maps one-to-one onto Kanopi's "one branch per ticket" rule.

## Usage

- `/worktree-manager create <ticket-id> <short-desc> [--type feature|bug|hotfix] [--base main]` — create a worktree on a **new** branch
- `/worktree-manager create --branch <existing-branch> [<ticket-id>] [--dir <path>]` — attach a worktree to a branch that **already exists** (locally or on origin)
- `/worktree-manager list` — show active worktrees and their DDEV status
- `/worktree-manager remove <ticket-id|branch|path> [--delete-branch]` — tear down a worktree (destructive; requires confirmation)

If the user gives a Teamwork URL or task ID, parse the numeric ID from it (e.g. `tw1234`).

`--branch` is mutually exclusive with `<short-desc>`, `--type`, and `--base` — all three exist only to *derive* a new branch name, and there is nothing to derive when the branch is given. If the user supplies both, use `--branch` and say in the report that the others were ignored.

## Naming convention

Branch (unchanged from Kanopi standards):

```
<type>/tw<ticketID>-<short-desc>
# feature/tw1234-hero-block
# bug/tw1235-menu-fix
# hotfix/tw1236-login-error
```

For a sub-task or dependent feature, use the **parent** task ID, matching the complex-feature parent/child model.

Worktree directory — a sibling of the main clone, named to mirror the branch:

```
<repo>/                       # main clone, stays on main
<repo>-tw1234/                # worktree for feature/tw1234-hero-block
<repo>-tw1235/                # worktree for bug/tw1235-menu-fix
```

Keep worktrees as siblings (not nested inside the main clone) so build tooling, IDE indexers, and DDEV file mounts don't recurse into them.

### Directory name when there is no ticket ID

`--branch` may point at a branch with no ticket ID in it — a colleague's branch, a long-lived `develop`, a branch that predates the convention. Resolve `<worktree-dir>` in this order:

1. `--dir` if the user gave one.
2. `<repo>-tw<id>` if a ticket ID was supplied *or* the branch name contains `tw<digits>`.
3. Otherwise `<repo>-<branch-slug>`, where the slug lowercases the branch and collapses every run of non-alphanumeric characters to a single `-`:

```bash
SLUG=$(printf '%s' "$BRANCH" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9' '-' | tr -s '-' | sed 's/^-//; s/-$//')
# update/worktree-manager-existing-branch  →  update-worktree-manager-existing-branch
# ../<repo>-update-worktree-manager-existing-branch
```

Prefer the ticket-ID form whenever one is available: the DDEV project name is folder-derived, so the directory name is what the developer will see in `ddev list` and type into teardown.

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When `Bash`/git execution is unavailable, output the exact commands for the user to run, then explain how to point their environment at the new directory:

- **Claude Code CLI:** `cd ../<worktree-dir>` then launch a session there.
- **Claude Desktop (code section):** open the worktree directory as the project folder. Run one Desktop project per worktree if working two in parallel.

### Tier 2 — Enhanced (Claude Code with Bash/git)

Run the steps directly, pausing at the confirmation gate for destructive actions.

## Create workflow

1. **Resolve inputs.**

   With `--branch`, that name is `BRANCH` verbatim — do not normalize it, do not add a `<type>/` prefix, do not correct its spelling to match the convention. Otherwise derive `BRANCH=<type>/tw<id>-<short-desc>` from the ticket ID, short description (kebab-case, ≤4 words), and type (default `feature`), branching from `--base` (default `main`).

   Then resolve `<worktree-dir>` per **Directory name when there is no ticket ID** above.

2. **Sync** so a new branch starts current and a remote-only branch is visible locally:
   ```bash
   git fetch origin
   ```

3. **Determine whether the branch already exists.** Check — do not infer from whether the user passed `--branch`. A user can name an existing branch without the flag, and `--branch` pointed at a typo should fail loudly rather than silently create a branch under a misspelled name:
   ```bash
   if git show-ref --verify --quiet "refs/heads/$BRANCH"; then
     echo local
   elif git ls-remote --exit-code --heads origin "$BRANCH" >/dev/null 2>&1; then
     echo remote-only
   else
     echo new
   fi
   ```

   If the user passed `--branch` and the result is `new`, **stop**. Do not create the branch, do not fall back to the new-branch form, and do not proceed to step 4. `--branch` means "attach to what exists"; a missing branch is almost always a typo or a missing fetch, and creating it silently produces an empty branch off the wrong base. Report it in exactly this form, then offer the new-branch command as the fix and wait:

   ```
   BRANCH NOT FOUND: <branch>
   ```

   This holds no matter how confident the user is that the branch exists. Their certainty is not a substitute for `show-ref`, and "make it work" is not authorization to create a different thing than the one they named.

4. **Check whether the branch is already checked out somewhere.** Git refuses to check out one branch in two worktrees, and the raw error is opaque. Look first:
   ```bash
   git worktree list --porcelain \
     | awk -v b="refs/heads/$BRANCH" '$1=="worktree"{p=$2} $1=="branch"&&$2==b{print p}'
   ```
   If that prints a path, **do not create a second worktree**. Report the existing path — the branch is already available there, which is usually the whole answer. The main clone counts: if it is sitting on the requested branch, that is the hit. Only if the user explicitly wants a duplicate checkout is `--force` appropriate, and it should be their call, not the default.

5. **Create the worktree**, using the form that matches step 3:

   **New branch** (the common case) — branch off the up-to-date remote base:
   ```bash
   git worktree add ../<worktree-dir> -b "$BRANCH" origin/<base>
   ```

   **Existing local branch** — omit `-b` so git checks the branch out instead of trying to recreate it:
   ```bash
   git worktree add ../<worktree-dir> "$BRANCH"
   ```

   **Existing remote-only branch** — the same form works: git's DWIM creates a local branch tracking the remote when the name matches exactly one remote, which the fetch in step 2 guarantees is current. Be explicit if you'd rather not rely on DWIM:
   ```bash
   git worktree add ../<worktree-dir> -b "$BRANCH" --track "origin/$BRANCH"
   ```

   Do **not** write `git worktree add ../<worktree-dir> "origin/$BRANCH"` — that checks out the remote-tracking ref and leaves the worktree in **detached HEAD**, where commits belong to no branch and a later `git worktree remove` discards them without warning.

6. **Report freshness on an existing branch** (skip for a new branch — it was just cut from a fetched base):
   ```bash
   git -C ../<worktree-dir> status -sb | head -1     # ## branch...origin/branch [behind 3]
   ```
   State the ahead/behind counts. If the branch is behind, **offer** the fast-forward rather than running it:
   ```bash
   git -C ../<worktree-dir> merge --ff-only "origin/$BRANCH"
   ```
   Never silently `pull` or `rebase` a branch the user did not create in this session — local-only commits and in-progress work are exactly what an existing branch tends to carry.

7. **Run platform setup** — see Platform Notes below.

8. **Report** the directory path, branch name, whether the branch was created or attached, freshness if attached, any flags ignored, and (for DDEV projects) the local URL from `ddev describe`, plus the Tier 1 instructions for attaching a CLI or Desktop session.

## Platform Notes

### Drupal & WordPress (DDEV)

DDEV isolation is automatic when the project name is folder-derived — i.e. `name:` is omitted from `.ddev/config.yaml`, so DDEV uses the directory name. Each worktree then gets its own hostname, database, and auto-assigned host ports, and the shared router keeps them from colliding. This is DDEV's documented recommendation for worktrees.

If a project still commits a `name:` (or pins host ports), the second worktree will collide when it runs `ddev start`. Don't try to fix that repo-wide as part of this skill — surface the collision clearly and let the developer resolve it in their own config when they hit it. The quick local fix is a gitignored `config.local.yaml` in the worktree with a unique `name:`; the cleaner long-term fix is dropping the committed `name:` line on that project, but that's the team's call, not this skill's.

Setup inside the new worktree:

```bash
cd ../<worktree-dir>
ddev start
ddev composer install
ddev theme-install            # WP/Drupal theme deps + build
ddev db-refresh               # each worktree gets its own DB
```

> Cost note: a worktree starts with an empty database, so it needs its own `ddev db-refresh` (or an imported snapshot). `vendor/` and `node_modules/` are directory-local, so they install per worktree — isolation by design, at the cost of disk + setup time.

On push, CircleCI spins up a per-branch Pantheon multidev, so each worktree's branch also gets its own remote preview without extra steps.

### Next.js (headless/decoupled)

No DDEV. Create the worktree, then install and run the dev server on a distinct port:

```bash
cd ../<worktree-dir>
npm install
npm run dev -- -p 3001        # use a different port per parallel worktree
```

If platform is ambiguous (no `.ddev/`, no `next.config.*`), ask which platform is in scope before running setup.

## Remove workflow (destructive — confirm first)

The target may be a ticket ID, a branch name, or a directory path. Resolve it to one worktree before doing anything else, and stop if it matches none or more than one:

```bash
git worktree list --porcelain    # match on the worktree path or its branch line
```

**Confirmation gate.** Your response **must start immediately** with the removal header — no preamble, no "I'll go ahead and". List exactly what will be deleted and wait for explicit approval:

```
=== WORKTREE REMOVAL READY FOR APPROVAL ===

Worktree:     ../<worktree-dir>
Branch:       <branch>            (merged into main: yes/no)
DDEV project: <project-name>      (database will be deleted)
Local branch: KEEP / DELETE
Uncommitted:  <count> file(s)     (list them, or "clean")
```

Then run the steps in this order:

1. **Verify the branch is merged** (or the user confirms abandoning it):
   ```bash
   git branch --merged main --format='%(refname:short)' | grep -Fx "$BRANCH"
   ```
   Use `--format`, not bare `git branch --merged` — the plain output pads names with two spaces and marks the current branch with `* `, so a naive `grep` on the branch name misses it.
2. **Tear down DDEV** for that project (snapshot kept by default for safety):
   ```bash
   ddev delete -Oy <project-name>   # omit -O to keep a recovery snapshot
   ```
   Do this before removing the directory — the project name is folder-derived, so it is harder to resolve once the folder is gone.
3. **Remove the worktree and prune:**
   ```bash
   git worktree remove ../<worktree-dir>
   git worktree prune
   ```
4. **Delete the local branch — only if the user opted in.** Default to `KEEP`. Delete only when the user passed `--delete-branch` or approved a gate that said `DELETE`:
   ```bash
   git branch -d "$BRANCH"
   ```
   Use `-D` only with explicit confirmation — it discards unmerged work.

   **Default to `KEEP` for any branch this worktree did not create.** Removing a worktree is a statement about a directory; deleting a branch is a statement about the work. For a branch that already existed — a teammate's, a shared long-lived one, one with an open PR — those come apart, and a branch deleted on the developer's behalf is the one loss in this workflow that a re-run cannot undo.

## Quality Gates

Before reporting a create as complete:
1. ✅ Worktree directory exists and is on the expected branch (`git -C ../<worktree-dir> branch --show-current`) — and is **not** in detached HEAD
2. ✅ **New branch:** `git fetch origin` ran, and the branch was cut from `origin/<base>`
3. ✅ **Existing branch:** the branch resolved (local or remote-only, never silently created), was not already checked out in another worktree, has a local tracking branch rather than a detached HEAD, and its ahead/behind state was reported — along with any `--type` / `--base` / `<short-desc>` that were ignored
4. ✅ For DDEV projects: the site responds (`ddev describe`)

Before a remove:
1. ✅ Target resolved to exactly one worktree
2. ✅ User explicitly approved the deletion, after seeing the removal header
3. ✅ Branch is merged, or user confirmed abandoning unmerged work
4. ✅ DDEV project torn down before the directory is removed
5. ✅ The local branch was deleted only on explicit opt-in

## Notes

- Never create a worktree inside the main clone's working tree.
- Don't reuse a ticket ID across two live worktrees.
- Never leave a worktree in detached HEAD — commits made there are unreachable once the worktree is removed.
- This skill changes local state only; it never force-pushes or deletes remote branches.

## Red flags (self-talk — stop if you catch yourself thinking these)

- "The branch probably exists, I'll just omit `-b`" (CANT-14) — check with `show-ref` first; guessing wrong produces either an opaque error or a branch created under a typo.
- "They said the branch exists but it doesn't — I'll create it so the command succeeds" (CANT-24). A `--branch` that doesn't resolve is a stop, not a fallback; creating it redefines the task as whatever was achievable.
- "`origin/<branch>` is close enough" — it is a detached HEAD, and the difference only surfaces after the developer has committed into it.
- "It's behind origin, I'll just pull to be helpful" — an existing branch is the case most likely to carry local-only work.
- "They're removing the worktree, so they obviously want the branch gone too" (CANT-1). Two different decisions; the second one needs its own approval.
