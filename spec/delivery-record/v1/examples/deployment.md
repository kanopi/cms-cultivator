---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: deployment
subject:
  kind: report
  ref: "https://github.com/kanopi/example/releases/tag/v2.4.0"
  title: "Deploy v2.4.0 to production"
ticket: PROJ-450
scope: milestone
assisted_by:
  models: [claude-opus-4-8]
  skills: [commit-message-generator]
checks:
  release_notes:       { generated: pass, reviewed: pass }
  backup_taken:        { database: pass, files: pass }
  migrations_verified: { config_import: pass, updb: pass }
  smoke_test:          { homepage: pass, login: pass, checkout: pass }
sign_off:
  produced_by: "@sam 2026-06-30"
  reviewed_by: "@techlead 2026-06-30"
---

## What changed

Production deploy of release v2.4.0: the breadcrumb component, two bug fixes, and
a config change for the new content type. Release notes generated from the merged
PR titles since v2.3.0.

## What the AI produced

`commit-message-generator` assembled the release notes from the conventional-commit
history. The deploy command was posted for a human to run — the skill does not
deploy on its own.

## What the human verified

Checkpoint 1 (plan approval): @sam confirmed the release scope and the backup step
ran before cutover.
Checkpoint 2 (final approval): @techlead verified the config import and database
updates applied cleanly, then ran the smoke test across the three critical paths.

## Issues found and resolved

- Config import warned about a stale block placement; re-exported and re-ran clean.

## Deferred or known risks

- None.
