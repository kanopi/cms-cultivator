# Plan: Move CircleCI Project Setup Before PR Creation

## Context

The agent currently writes the `.circleci/config.yml` file in step 4.10a (Phase 4), sets up the CircleCI project in steps 4.10b-d (also Phase 4), then pushes the branch and creates the PR in Phase 5. The problem is that CircleCI project setup (follow, configure settings, add trigger) should happen **after** the branch is pushed (so CircleCI can see the config file on GitHub) but **before** the PR is created (so the CI pipeline runs immediately with correct settings when the PR triggers it).

## File to Modify

- `agents/drupal-pantheon-devops-specialist/AGENT.md`

## Current Flow (Phase 5)

```
5.1 Push Branch
5.2 Create Pull Request
5.3 Output Verification Checklist
```

CircleCI steps 4.10b-d sit in Phase 4, before any push happens.

## New Flow (Phase 5)

```
5.1 Push Branch                          (unchanged)
5.2 Set Up CircleCI Project              (moved from 4.10b)
5.3 Configure CircleCI Project Settings  (moved from 4.10c)
5.4 Add Weekly Automated Update Trigger  (moved from 4.10d)
5.5 Create Pull Request                  (was 5.2)
5.6 Output Verification Checklist        (was 5.3)
```

## Implementation

### Change 1: Remove steps 4.10b, 4.10c, 4.10d from Phase 4

Delete sections 4.10b ("Set Up CircleCI Project"), 4.10c ("Configure CircleCI Project Settings"), and 4.10d ("Add Weekly Automated Update Trigger") from their current location under section 4.10. Keep 4.10a (CircleCI Config File) and 4.10e (Remove Legacy CI/Build Files) in place. Renumber 4.10e → 4.10b.

### Change 2: Restructure Phase 5 to include CircleCI setup after push, before PR

Rewrite Phase 5 section with this order:

1. **5.1 Push Branch** — same as current (push feature/kanopi-devops)
2. **5.2 Set Up CircleCI Project** — content from old 4.10b (circleci follow)
3. **5.3 Configure CircleCI Project Settings** — content from old 4.10c (auto-cancel, PR-only)
4. **5.4 Add Weekly Automated Update Trigger** — content from old 4.10d (scheduled pipeline)
5. **5.5 Create Pull Request** — same content as current 5.2 (gh pr create)
6. **5.6 Output Verification Checklist** — same content as current 5.3

### Change 3: Update Gate 5 references

Update the Gate 5 validation section:
- Gate 5 currently says "after step 5.2 PR creation, before 5.3 checklist"
- Change to "after step 5.5 PR creation, before 5.6 checklist"

### Change 4: Update the Gate 5 pointer before 5.3 (checklist)

The current `**⮕ Run Gate 5 validation**` marker is after step 5.2 (PR creation). Move it to after step 5.5 (the new PR creation step location).

## Verification

- Read through Phase 5 to confirm the order is: push → CircleCI setup → PR → checklist
- Confirm steps 4.10b-d no longer exist in Phase 4
- Confirm 4.10e was renumbered to 4.10b
- Grep for "4.10b", "4.10c", "4.10d" to ensure no stale cross-references remain
- Run `bats tests/test-plugin.bats` to ensure no test regressions
