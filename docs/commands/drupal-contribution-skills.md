# Drupal.org Contribution Skills

Six skills for contributing back to drupal.org — opening issues, setting up merge requests, and managing the local clone cache. Two are full workflows, two are quick helpers, two are cleanup utilities.

!!! info "Workflow vs helper skills"
    The `drupal-contribute`, `drupal-issue`, and `drupal-mr` skills run **full guided workflows** — they walk you through opening an issue or pushing an MR step by step, often using clipboard prompts and browser launches because drupal.org has CAPTCHA protection that blocks pure automation. The `drupalorg-issue-helper` and `drupalorg-contribution-helper` skills are **quick references** — they explain templates, git workflows, and conventions without running anything.

---

## Full Workflows

### drupal-contribute

**Purpose:** End-to-end contribution workflow. Opens an issue on drupal.org and sets up the matching merge request on `git.drupalcode.org` in one guided pass.

**Auto-invoked triggers:** "contribute to drupal.org", "create a drupal.org issue and MR", "open a drupal contribution".

**Workflow:**

1. Confirms the target project (module, theme, distribution, or Drupal core)
2. Drafts the issue: title, summary, steps to reproduce, proposed resolution, version
3. Presents the formatted issue text for you to paste into drupal.org's issue form (CAPTCHA-protected, so the skill stops short of submitting)
4. After the issue is filed, captures the issue number
5. Clones the relevant repo from `git.drupalcode.org` (cached at `~/.cache/drupal-contrib/`)
6. Creates an issue fork, sets up the branch with the conventional `<issue-number>-<short-desc>` name
7. Opens the merge request in your browser with the title and description pre-drafted

**Requires:** `git`, `gh` (GitHub CLI), browser, drupal.org account.

---

### drupal-issue

**Purpose:** Just the issue side of the workflow. Create, update, or manage an issue on drupal.org.

**Auto-invoked triggers:** "create a drupal.org issue", "open a drupal issue", "file a bug on drupal.org", "update issue 3245678".

**Workflow:**

1. Asks for the target project and the issue type (bug, feature, task, support)
2. Walks you through the standard drupal.org template: summary, steps to reproduce, proposed resolution, version, component, priority
3. Formats the issue text for paste into drupal.org's CAPTCHA-protected form
4. Optionally helps draft replies, status changes, and follow-up comments on existing issues

**Requires:** Browser, drupal.org account.

---

### drupal-mr

**Purpose:** Just the merge request side. Set up a merge request on `git.drupalcode.org` for an existing issue.

**Auto-invoked triggers:** "create a drupal.org MR", "set up a merge request for issue 3245678", "push a patch for drupal.org".

**Workflow:**

1. Asks for the issue number and target project
2. Clones (or finds in cache) the project repo at `git.drupalcode.org/project/<name>`
3. Creates the issue fork via the drupal.org UI helper
4. Sets up the branch following drupal.org's `<issue>-<short-desc>` convention
5. Pushes the branch and opens the MR creation page in your browser with title and description pre-filled

**Requires:** `git`, browser, drupal.org account with contributor access.

---

## Cleanup

### drupal-cleanup

**Purpose:** List and clean up cloned drupal.org repositories in the local cache.

**Auto-invoked triggers:** "cleanup drupal repos", "remove cloned drupal projects", "list cached drupal contributions".

**Workflow:**

1. Lists everything under `~/.cache/drupal-contrib/` with last-modified dates
2. Identifies stale clones (no recent commits, no open MRs)
3. Confirms before deleting — drupal-cleanup will never delete a clone with uncommitted work

Useful before disk-cleaning or when switching machines.

---

## Quick Helpers

These don't run workflows — they explain conventions and provide reference material.

### drupalorg-issue-helper

**Purpose:** Quick guidance on drupal.org issue templates, status workflow, and formatting conventions.

**Auto-invoked triggers:** "how do I write a drupal.org bug report?", "what's the drupal.org issue template?", "drupal.org issue status workflow", "explain the drupal.org component field".

Use this when you have a one-off question about issue conventions and don't want to walk through the full `drupal-issue` workflow.

---

### drupalorg-contribution-helper

**Purpose:** Quick guidance on drupal.org git workflows — issue forks, branch naming, MR conventions, and `git.drupalcode.org` quirks.

**Auto-invoked triggers:** "how do I create an issue fork on drupal.org?", "drupal.org branch naming", "how do drupal.org MRs work?", "explain git.drupalcode.org".

Use this for git-workflow questions without spinning up the full `drupal-mr` workflow.

---

## How They Fit Together

```
Need to contribute a fix to a contrib module
  ├─→ Want the full guided flow → /drupal-contribute
  └─→ Already filed the issue manually → /drupal-mr

Want to file an issue without code
  → /drupal-issue

Quick reference question
  ├─→ Issue formatting question → /drupalorg-issue-helper
  └─→ Git workflow question → /drupalorg-contribution-helper

Disk cleanup
  → /drupal-cleanup
```

---

## CAPTCHA Note

drupal.org's forms are protected by CAPTCHA, which blocks browser automation. This is why the workflow skills use a "guided manual" approach: the skill drafts the content, opens the right URL, and you click submit. There's no way around this from the plugin side, and it's by design.

If drupal.org ever exposes an authenticated API for issue creation, the workflows can move to direct API calls.

---

## Related

- **[Drupal Contribution Guide](../drupal-contribution.md)** — Longer-form guide on the full contribution process and Kanopi's conventions
- **[Skills Overview](overview.md)**
