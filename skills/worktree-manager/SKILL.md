---
name: worktree-manager
description: Create, list, and tear down git worktrees following Kanopi's branch naming conventions so developers and agents can work multiple tickets in parallel without clobbering each other's working tree. Handles DDEV isolation automatically (folder-derived project name, no pinned ports) for Drupal and WordPress, and plain worktree setup for Next.js. Invoke when the user wants to start a ticket in a fresh worktree, run more than one Claude Code or Claude Desktop session at once, says "create a worktree", "new worktree for tw1234", "spin up a parallel branch", "work on two tickets at once", "/worktree-manager", or asks how to clean up a finished worktree. Use this skill even if the user only says "I need to work on another ticket without losing my current one."
---

# Worktree Manager

Create and tear down git worktrees that follow Kanopi's branch conventions and stay isolated at the DDEV layer, so multiple tickets — and multiple AI sessions — can run side by side from a single clone.

## Why this exists

A worktree checks out a second branch into its own directory while sharing one `.git`. That is the primitive that lets two Claude Code sessions (or one CLI session and one Claude Desktop "code" session) work different tickets at the same time without `git checkout` thrash or stepping on each other's files. It maps one-to-one onto Kanopi's "one branch per ticket" rule.

## Usage

- `/worktree-manager create <ticket-id> <short-desc> [--type feature|bug|hotfix] [--base main]` — create a worktree + branch
- `/worktree-manager list` — show active worktrees and their DDEV status
- `/worktree-manager remove <ticket-id>` — tear down a worktree (destructive; requires confirmation)

If the user gives a Teamwork URL or task ID, parse the numeric ID from it (e.g. `tw1234`).

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

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When `Bash`/git execution is unavailable, output the exact commands for the user to run, then explain how to point their environment at the new directory:

- **Claude Code CLI:** `cd ../<repo>-tw1234` then launch a session there.
- **Claude Desktop (code section):** open the worktree directory as the project folder. Run one Desktop project per worktree if working two in parallel.

### Tier 2 — Enhanced (Claude Code with Bash/git)

Run the steps directly, pausing at the confirmation gate for destructive actions.

## Create workflow

1. **Resolve inputs** — ticket ID, short description (kebab-case, ≤4 words), type (default `feature`), base branch (default `main`).
2. **Sync base** so the worktree starts current:
   ```bash
   git fetch origin
   ```
3. **Create the worktree + branch** off the up-to-date remote base:
   ```bash
   git worktree add ../<repo>-tw<id> -b <type>/tw<id>-<short-desc> origin/<base>
   ```
   If the branch already exists (resuming work), omit `-b`:
   ```bash
   git worktree add ../<repo>-tw<id> <type>/tw<id>-<short-desc>
   ```
4. **Run platform setup** — see Platform Notes below.
5. **Report** the directory path, branch name, and (for DDEV projects) the local URL from `ddev describe`, plus the Tier 1 instructions for attaching a CLI or Desktop session.

## Platform Notes

### Drupal & WordPress (DDEV)

DDEV isolation is automatic when the project name is folder-derived — i.e. `name:` is omitted from `.ddev/config.yaml`, so DDEV uses the directory name. Each worktree then gets its own hostname, database, and auto-assigned host ports, and the shared router keeps them from colliding. This is DDEV's documented recommendation for worktrees.

If a project still commits a `name:` (or pins host ports), the second worktree will collide when it runs `ddev start`. Don't try to fix that repo-wide as part of this skill — surface the collision clearly and let the developer resolve it in their own config when they hit it. The quick local fix is a gitignored `config.local.yaml` in the worktree with a unique `name:`; the cleaner long-term fix is dropping the committed `name:` line on that project, but that's the team's call, not this skill's.

Setup inside the new worktree:

```bash
cd ../<repo>-tw<id>
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
cd ../<repo>-tw<id>
npm install
npm run dev -- -p 3001        # use a different port per parallel worktree
```

If platform is ambiguous (no `.ddev/`, no `next.config.*`), ask which platform is in scope before running setup.

## Remove workflow (destructive — confirm first)

**Confirmation gate:** state exactly what will be deleted (worktree directory, local branch if merged, DDEV project + database) and wait for explicit approval before proceeding.

1. **Verify the branch is merged** (or the user confirms abandoning it):
   ```bash
   git branch --merged main | grep <type>/tw<id>
   ```
2. **Tear down DDEV** for that project (snapshot kept by default for safety):
   ```bash
   ddev delete -Oy <project-name>   # omit -O to keep a recovery snapshot
   ```
3. **Remove the worktree and prune:**
   ```bash
   git worktree remove ../<repo>-tw<id>
   git worktree prune
   ```
4. **Delete the local branch** once merged (mirrors Kanopi's branch-cleanup discipline):
   ```bash
   git branch -d <type>/tw<id>-<short-desc>
   ```
   Use `-D` only with explicit confirmation — it discards unmerged work.

## Quality Gates

Before reporting a create as complete:
1. ✅ Worktree directory exists and is on the expected branch (`git -C ../<repo>-tw<id> branch --show-current`)
2. ✅ Base was fetched before branching
3. ✅ For DDEV projects: the site responds (`ddev describe`)

Before a remove:
1. ✅ User explicitly approved the deletion
2. ✅ Branch is merged, or user confirmed abandoning unmerged work
3. ✅ DDEV project torn down before the directory is removed

## Notes

- Never create a worktree inside the main clone's working tree.
- Don't reuse a ticket ID across two live worktrees.
- This skill changes local state only; it never force-pushes or deletes remote branches.
