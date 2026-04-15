---
name: drupal-cleanup
description: "List and clean up cloned drupal.org repositories in the local cache (~/.cache/drupal-contrib/). Invoke when user asks to list, remove, or clean up cloned Drupal contrib repos, says \"cleanup drupal repos\", \"remove cloned drupal projects\", or uses /drupal-cleanup. Has side effects: permanently deletes repository clones. Requires user confirmation before deletion."
---

# Drupal Cleanup

List and clean up cloned drupal.org repositories in `~/.cache/drupal-contrib/`.

## ⚠️ Side Effect Warning

**Removing a repository permanently deletes the local clone** including:
- All branches not pushed to issue forks
- Any uncommitted changes
- Local-only commits

**The skill checks for uncommitted changes and unpushed branches before deletion and requires explicit user confirmation.** Once deleted, the repository must be re-cloned.

## Usage

- "List my cloned drupal.org repos"
- "Remove the paragraphs repository from my local cache"
- "Clean up all drupal contrib repos"
- `/drupal-cleanup` — List all repos
- `/drupal-cleanup list` — List with details
- `/drupal-cleanup {project}` — Remove specific project
- `/drupal-cleanup --all` — Remove all cloned repos

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Bash tools are unavailable:

**For listing**:
1. Ask user to run: `ls -la ~/.cache/drupal-contrib/` and share output
2. Provide analysis and recommendations based on shared output
3. Guide cleanup decisions

**For removal (requires Bash in Tier 2)**:
- Provide the exact commands for user to run manually with explanations

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Bash available:

**Listing repos**:
```bash
# Check if cache directory exists
ls -la ~/.cache/drupal-contrib/ 2>/dev/null || echo "No repos cloned yet"

# Get size and details of each project
for dir in ~/.cache/drupal-contrib/*/; do
  project=$(basename "$dir")
  size=$(du -sh "$dir" 2>/dev/null | cut -f1)
  branches=$(cd "$dir" && git branch | wc -l)
  status=$(cd "$dir" && git status --short | wc -l)
  echo "$project | $size | $branches branches | $status modified files"
done
```

**Removing specific project**:
1. Check for uncommitted changes: `cd ~/.cache/drupal-contrib/{project} && git status --short`
2. Check for unpushed branches: `git log --branches --not --remotes --oneline | wc -l`
3. **Present findings to user**
4. **⛔ STOP: Warn about irreversible deletion and require confirmation**:
   ```
   ⚠️ This will permanently delete ~/.cache/drupal-contrib/{project}/
   
   Status: {uncommitted changes / unpushed commits if any}
   
   Reply "yes" to proceed, "no" to cancel.
   ```
5. **After "yes" confirmation only**: `rm -rf ~/.cache/drupal-contrib/{project}/`

**Removing all repos**:
1. Show summary: all projects, total size, any with uncommitted work
2. **⛔ STOP: Require explicit confirmation**:
   ```
   ⚠️ This will permanently delete ALL repos in ~/.cache/drupal-contrib/:
   
   {list of projects with their sizes}
   Total: {X} MB across {N} projects
   
   {Warning if any have uncommitted changes}
   
   Reply "yes, delete all" to proceed, or "no" to cancel.
   ```
3. **After "yes, delete all" confirmation only**: `rm -rf ~/.cache/drupal-contrib/`

## Listing Output Format

```markdown
**Cloned Drupal.org Repositories**
Location: ~/.cache/drupal-contrib/

| Project | Size | Branches | Modified | Status |
|---------|------|----------|----------|--------|
| paragraphs | 45 MB | 3 | 2 days ago | Clean |
| webform | 120 MB | 1 | 1 week ago | Clean |
| easy_lqp | 12 MB | 2 | Today | ⚠️ Modified |

**Total**: 177 MB across 3 projects

**To remove a repo**: Use the drupal-cleanup skill with the project name
**To remove all**: Use the drupal-cleanup skill with --all flag
```

## Safety Checks

Before any deletion, this skill checks:
1. **Uncommitted changes** — Modified files not yet staged
2. **Unstaged files** — New files not tracked by git
3. **Unpushed branches** — Local commits not pushed to issue fork

If any are found, the user is warned before proceeding.

## When to Clean Up

Consider cleaning up when:
- An MR has been merged
- You're done contributing to a project
- Disk space is low
- You want a fresh start

**Before cleanup, ensure**:
- All branches are pushed to issue forks on git.drupalcode.org
- No uncommitted changes exist
- MRs are in stable state

## Re-cloning After Cleanup

```bash
# Via drupal-mr skill (re-clones automatically):
# "Create MR for {project} issue {number}"

# Or manually:
git clone git@git.drupal.org:project/{project}.git ~/.cache/drupal-contrib/{project}
```

## Related Skills

- **drupal-mr** — Create MRs (will re-clone if needed)
- **drupal-issue** — Create issues on drupal.org
- **drupal-contribute** — Full contribution workflow
