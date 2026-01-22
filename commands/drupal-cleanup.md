---
description: List and cleanup cloned drupal.org repositories in the local cache
argument-hint: "[list] | [project] | [--all]"
allowed-tools: Bash(ls:*), Bash(rm:*), Bash(du:*), Bash(git:*), Bash(find:*), Read
---

## How It Works

This command manages the `~/.cache/drupal-contrib/` directory where drupal.org projects are cloned for contribution work.

### Direct Execution (No Agent)

This command executes directly without spawning an agent:

1. **List**: Show all cloned repositories with metadata
2. **Remove specific**: Delete a single project's clone
3. **Remove all**: Clean up the entire cache directory

---

## Quick Start

```bash
# List all cloned repos
/drupal-cleanup

# List with detailed info
/drupal-cleanup list

# Remove specific project
/drupal-cleanup paragraphs

# Remove all cloned repos
/drupal-cleanup --all
```

## Usage

### List Cloned Repositories

```bash
/drupal-cleanup
# or
/drupal-cleanup list
```

Shows:
- Project names
- Disk space used
- Number of branches
- Last modified date
- Any uncommitted changes

**Example output**:
```markdown
**Cloned Drupal.org Repositories**
Location: ~/.cache/drupal-contrib/

| Project | Size | Branches | Modified | Status |
|---------|------|----------|----------|--------|
| paragraphs | 45 MB | 3 | 2 days ago | Clean |
| webform | 120 MB | 1 | 1 week ago | Clean |
| easy_lqp | 12 MB | 2 | Today | Modified |

**Total**: 177 MB across 3 projects

**Commands**:
- Remove one: `/drupal-cleanup paragraphs`
- Remove all: `/drupal-cleanup --all`
```

### Remove Specific Project

```bash
/drupal-cleanup {project}
```

Removes the specified project's clone after confirmation.

**Example**:
```bash
/drupal-cleanup paragraphs
```

The command will:
1. Check for uncommitted changes
2. Show branches that will be lost
3. Ask for confirmation
4. Remove `~/.cache/drupal-contrib/paragraphs/`

### Remove All Cloned Repos

```bash
/drupal-cleanup --all
```

Removes the entire `~/.cache/drupal-contrib/` directory after confirmation.

**Warning**: This removes all cloned projects and their branches. Make sure any work is pushed to issue forks first.

## Commands Executed

### Listing
```bash
# Check if cache directory exists
ls -la ~/.cache/drupal-contrib/

# Get size of each project
du -sh ~/.cache/drupal-contrib/*/

# Show branches in each project
for dir in ~/.cache/drupal-contrib/*/; do
    echo "=== $(basename $dir) ==="
    cd "$dir" && git branch -a && cd -
done

# Check for uncommitted changes
for dir in ~/.cache/drupal-contrib/*/; do
    echo "=== $(basename $dir) ==="
    cd "$dir" && git status --short && cd -
done
```

### Cleanup
```bash
# Remove specific project
rm -rf ~/.cache/drupal-contrib/{project}

# Remove all
rm -rf ~/.cache/drupal-contrib
```

## Safety Checks

Before removing, the command checks:

1. **Uncommitted changes**: Warns if there are modified files
2. **Unpushed branches**: Shows branches not pushed to remote
3. **Open MRs**: Notes if there are active MRs (if glab available)

**Example warning**:
```markdown
**Warning: Uncommitted Changes**

The `paragraphs` repository has uncommitted changes:

```
M  src/Plugin/Field/FieldWidget/ParagraphsWidget.php
?? new_file.php
```

**Branches with unpushed work**:
- `3456789-fix-validation` (2 commits ahead)

Are you sure you want to delete this repository?
- Reply "yes" to proceed
- Reply "no" to cancel
- Run `cd ~/.cache/drupal-contrib/paragraphs && git status` to review
```

## Re-cloning After Cleanup

If you remove a project and need to work on it again:

```bash
/drupal-mr {project} {issue_number}
```

The agent will re-clone the project and set up the issue fork.

Or manually:
```bash
git clone git@git.drupal.org:project/{project}.git ~/.cache/drupal-contrib/{project}
```

## Cache Location

All drupal.org contribution work is stored in:
```
~/.cache/drupal-contrib/
```

This location:
- Avoids conflicts with your main projects
- Persists across sessions (unlike /tmp)
- Can be safely deleted without affecting other work
- Is the standard XDG cache location

## When to Clean Up

Consider cleaning up when:
- An MR has been merged
- You're done contributing to a project
- Disk space is low
- You want a fresh start

**Before cleanup**, ensure:
- All branches are pushed to issue forks
- No uncommitted changes exist
- MRs are in a stable state

## Related Commands

- **[`/drupal-mr`](drupal-mr.md)** - Create merge requests (will re-clone if needed)
- **[`/drupal-issue`](drupal-issue.md)** - Create issues on drupal.org
- **[`/drupal-contribute`](drupal-contribute.md)** - Full contribution workflow
