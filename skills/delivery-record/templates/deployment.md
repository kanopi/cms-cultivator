---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: deployment
subject:
  kind: report
  ref: "<Release tag / deploy URL>"
  title: "<Deploy vX.Y.Z to production>"
ticket: <TICKET>            # optional
scope: milestone            # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  release_notes:       { generated: <pass|fail|n/a>, reviewed: <pass|fail|n/a> }
  backup_taken:        { database: <pass|fail|n/a>, files: <pass|fail|n/a> }
  migrations_verified: { config_import: <pass|fail|n/a>, updb: <pass|fail|n/a> }
  smoke_test:          { homepage: <pass|fail|n/a>, login: <pass|fail|n/a> }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  # approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph: what shipped in this release and how the notes were assembled.

## What the AI produced

Which skill generated the release notes (e.g. commit-message-generator). Note that
the deploy command is posted for a human to run — the skill does not deploy.

## What the human verified

Checkpoint 1 (plan approval): <release scope confirmed; backup ran before cutover>.
Checkpoint 2 (final approval): <migrations applied cleanly; smoke test across the
critical paths>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
