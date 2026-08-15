---
name: ddev-docker-cleanup
description: Deterministic cleanup of DDEV and Docker disk usage on OrbStack, Docker Desktop, or any Docker provider. Safely reclaims space by removing orphaned Docker volumes (leftovers from worktrees, agent or CI runs, Playwright tests, and throwaway clones), build cache, and dangling images, while protecting the database of every current DDEV project. Use this whenever the user is low on disk or memory, mentions DDEV, Docker, or OrbStack taking up space, sees many "unused" volumes, wants to prune Docker, or asks how to clean up their local dev environment, even if they do not say the word "skill."
---

# DDEV / Docker Cleanup

Reclaim local disk and memory from DDEV and Docker without deleting anything the user still needs. The scripts do the deterministic work. Your job is to run them in order, present the results, and get explicit confirmation before anything is removed.

## The safety model (read this first)

A DDEV project's database does not live in the project folder. It lives in a Docker volume, and it is not checked into git. If that volume is deleted, or the Docker provider is factory reset, the database is gone. This is why blunt cleanup commands are dangerous here.

Two rules follow from that, and the scripts enforce them:

1. The only trustworthy allowlist of volumes to keep is the set of projects currently in `ddev list`, plus the DDEV global volumes. Everything else is a leftover.
2. Never run `docker volume prune`, `docker system prune --volumes`, or `docker image prune -a`. When projects are stopped their volumes look "unused" and "100% reclaimable," but that is just because nothing is attached. Those commands would wipe stopped-project databases or force a full image re-pull. Do not suggest them even if the user asks, without first explaining what they would destroy.

Build cache and dangling images are safe to remove. They are rebuilt or re-pulled on the next `ddev start`.

## Workflow

Always follow this order. Do not skip the report, and do not run `--apply` before the user has seen the dry run.

1. Run the read-only report and show the user the output:
   ```
   bash "${CLAUDE_PLUGIN_ROOT}/skills/ddev-docker-cleanup/scripts/report.sh"
   ```
   It prints the protected projects, overall Docker usage (`docker system df`), the volumes being kept, and the orphaned volumes that are safe to remove.

2. Explain what they are looking at. Point out that the kept volumes are their live databases plus Redis, Solr, mutagen, and the globals, and that the orphans are leftovers. If any orphan name looks like real client work (for example an old dated release-prep clone), flag it and ask before including it.

3. Run the dry run and present the list of what would be removed:
   ```
   bash "${CLAUDE_PLUGIN_ROOT}/skills/ddev-docker-cleanup/scripts/prune.sh"
   ```
   Nothing is deleted. This shows the orphaned volumes, the build cache, and the dangling images that `--apply` would clear.

4. Get explicit confirmation, then apply:
   ```
   bash "${CLAUDE_PLUGIN_ROOT}/skills/ddev-docker-cleanup/scripts/prune.sh" --apply
   ```
   Add `--poweroff` to stop all DDEV projects first, which also frees the RAM they were holding and lets the numbers read honestly:
   ```
   bash "${CLAUDE_PLUGIN_ROOT}/skills/ddev-docker-cleanup/scripts/prune.sh" --apply --poweroff
   ```

5. Show the before and after. The script prints `docker system df` after applying. Compare it to the report from step 1 and tell the user roughly how much came back.

To scope a run, name one or more passes: `--volumes`, `--images`, `--cache`. With none named, all three run.

## Volume naming reference

Use this to explain why a volume is kept or removed. For a project named `NAME`, these are its volumes:

| Volume | Purpose |
| --- | --- |
| `NAME-mariadb` / `NAME-postgres` / `NAME-mysql` | Database. The important one. |
| `NAME_project_mutagen` | Mutagen sync data. Recreated on start. |
| `ddev-NAME-snapshots` | Database snapshots for that project. |
| `ddev-NAME_redis`, `ddev-NAME_solr`, `ddev-NAME_<service>` | Add-on service data. |

Global volumes, always kept: `ddev-global-cache`, `ddev-ssh-agent_socket_dir`, `ddev-ssh-agent_dot_ssh`.

The separator after the name matters. `NAME-mariadb` is matched exactly, and add-ons are matched by the `ddev-NAME_` prefix with an underscore. That is why a real project like `smalley` is protected while an untracked clone like `smalley-tw30090415` is treated as an orphan and removed.

## If the host disk still looks full after cleanup

Docker is usually not the whole story. Two more places to look:

OrbStack stores its data in a sparse disk image that only uses the space it needs and shrinks automatically as data is deleted. After a large prune the host figure can lag. Quitting and reopening OrbStack, or restarting its engine, nudges it to release the freed blocks. On Docker Desktop the equivalent `Docker.raw` shrinks inside but not always on the host, so a provider restart may be needed.

Space outside Docker entirely. If the machine is still tight, the weight is often `node_modules` across projects (`du -sh ~/Projects/*/node_modules 2>/dev/null`), Composer and npm caches (`~/.composer/cache`, `~/.npm`), and Xcode DerivedData (`~/Library/Developer/Xcode/DerivedData`) if this is a Mac with Xcode. Offer to help check these, but they are outside this skill's scripts.

## Manual escape hatches

These are safe DDEV-native commands worth knowing, for cases the scripts do not cover:

- `ddev delete images` removes DDEV images from before the current release. Non-destructive; DDEV re-pulls what it needs. A more thorough image cleanup than the dangling-only pass, best run with everything powered off.
- `ddev delete --omit-snapshot <project>` removes a project you no longer want, including its database volume, with no snapshot taken.
- `ddev snapshot <project>` or `ddev export-db <project> --file=...` back up a database before any risky removal.

## Requirements

`docker`, `ddev`, and `jq` must be on PATH. Install jq with `brew install jq` on macOS. The scripts refuse to prune volumes if `ddev list` returns no projects, so a broken DDEV cannot trick the allowlist into targeting everything.
