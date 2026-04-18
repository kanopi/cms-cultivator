---
name: drupal-mr
description: "Create or list merge requests for drupal.org projects via git.drupalcode.org. Invoke when user wants to create a merge request for a drupal.org issue, says \"create a drupal.org MR\", \"set up a merge request for issue\", or uses /drupal-mr. Has side effects: clones repos to ~/.cache/drupal-contrib/ and pushes to git.drupalcode.org. Requires one manual step (issue fork creation via web UI)."
disable-model-invocation: true
---

# Drupal MR

Create and manage merge requests for drupal.org projects via git.drupalcode.org.

## ⚠️ Side Effect Warning

**This skill has external side effects:**
- Clones the project repository to `~/.cache/drupal-contrib/{project}/`
- Pushes branches to git.drupalcode.org issue forks (public)

**One manual interaction required** — Issue fork creation must be done via the drupal.org web UI (CAPTCHA-protected).

## Usage

- "Create a merge request for paragraphs issue 3456789"
- "Set up an MR for issue #3456789 in the webform module"
- `/drupal-mr {project} {issue_number}` — Create MR
- `/drupal-mr list [{project}]` — List MRs

## Prerequisites

**SSH key** added to git.drupalcode.org:
1. Go to: https://git.drupalcode.org/-/user_settings/ssh_keys
2. Add your public key (`~/.ssh/id_ed25519.pub`)
3. Verify: `ssh -T git@git.drupal.org`

**HTTPS fallback** (if SSH port 22 is blocked):
- Create token at: https://git.drupalcode.org/-/user_settings/personal_access_tokens
- Scopes needed: `read_repository`, `write_repository`

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() is unavailable:

1. **Check SSH connectivity** — Instruct user to verify: `ssh -T git@git.drupal.org`
2. **Clone repository** — Provide command:
   ```bash
   git clone git@git.drupal.org:project/{project}.git ~/.cache/drupal-contrib/{project}
   cd ~/.cache/drupal-contrib/{project}
   ```
3. **Open issue page** — URL: `https://www.drupal.org/project/{project}/issues/{issue_number}`
4. **⛔ STOP: User clicks "Create issue fork" in the right sidebar, then replies "done"**
5. **Set up remote and branch**:
   ```bash
   git remote add {project}-{issue_number} git@git.drupal.org:issue/{project}-{issue_number}.git
   git fetch {project}-{issue_number}
   git checkout -b {issue_number}-{description-slug}
   ```
6. **Guide code changes** — User makes their changes in the cloned repo
7. **Push and create MR**:
   ```bash
   git add .
   git commit -m "Issue #{issue_number}: {description}"
   git push {project}-{issue_number} {branch_name}
   # Git outputs MR creation URL — open in browser to complete
   ```

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() and git/ssh available:

```
Task(cms-cultivator:drupalorg-mr-specialist:drupalorg-mr-specialist,
     prompt="Execute the drupal-mr command with arguments: {arguments}. Check prerequisites (SSH key), clone project to ~/.cache/drupal-contrib/ if needed, guide user through manual issue fork creation, set up branch, push changes, and provide MR creation URL. Return MR URL and next steps.")
```

The agent handles git operations automatically, pausing for the one required manual step (issue fork creation).

## Branch Naming Convention

```
{issue_number}-{description-slug}

Examples:
3456789-fix-validation-error
3456789-add-ckeditor5-support
```

## Clone Location

All drupal.org projects clone to `~/.cache/drupal-contrib/`:
```
~/.cache/drupal-contrib/
├── paragraphs/
├── webform/
└── easy_lqp/
```

This location persists across sessions and avoids conflicts with your main projects.

## Resuming Work on Existing MR

```bash
cd ~/.cache/drupal-contrib/{project}
git fetch --all
git checkout {branch_name}
# Make changes
git add . && git commit -m "Issue #{issue}: additional fixes"
git push {project}-{issue_number} {branch_name}
# MR updates automatically
```

## MR Success Output

```markdown
**Merge Request Ready**

**Project**: paragraphs
**Issue**: #3456789
**Branch**: 3456789-fix-validation-error
**Local repo**: ~/.cache/drupal-contrib/paragraphs/

**Next Steps**:
1. Complete MR creation via the URL in git push output
2. Update drupal.org issue status to "Needs review"
3. Respond to review feedback
```

## Related Skills

- **drupal-issue** — Create issue before MR
- **drupal-contribute** — Full workflow (issue + MR)
- **drupal-cleanup** — Manage cloned repos
- **drupalorg-contribution-helper** — Git workflow guidance
