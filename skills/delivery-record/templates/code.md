---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: code
subject:
  kind: pr
  ref: "<org/repo#PR>"
  sha: <short-sha>
  title: "<PR title>"
ticket: <TICKET>            # optional
scope: feature              # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  standards: { phpcs: <pass|fail|n/a>, phpstan: <pass|fail|n/a> }
  tests:     { unit: <pass|fail|n/a>, ci_run: "<CI run URL>" }
  audits:    { a11y: <pass|fail|n/a>, performance: <pass|fail|n/a>, security: <pass|fail|n/a> }
  review:    { code_review: "<approved by @reviewer>", qa: <pass|fail|n/a> }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  # approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph plus a bullet list of files or areas touched.

## What the AI produced

What was generated, which skills and agents ran, any notable plan or trajectory
notes from /evaluate-output.

## What the human verified

Checkpoint 1 (plan approval): <brief note>.
Checkpoint 2 (final code approval): <what the reviewer actually looked at beyond
the automated gates>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
