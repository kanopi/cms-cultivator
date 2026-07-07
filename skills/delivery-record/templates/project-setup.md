---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: project-setup
subject:
  kind: document
  ref: "<repo/CLAUDE.md or brief URL>"
  title: "<Project context — CLAUDE.md / onboarding brief>"
ticket: <TICKET>            # optional
scope: deliverable          # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  context_accurate:   { stack_verified: <pass|fail|n/a>, commands_verified: <pass|fail|n/a> }
  sources_verified:   { sow_reviewed: <pass|fail|n/a>, repo_inspected: <pass|fail|n/a> }
  access_confirmed:   { hosting: <pass|fail|n/a>, teamwork: <pass|fail|n/a>, drive: <pass|fail|n/a> }
  stakeholder_review: { reviewed: "<approved by @pm>", techlead: <pass|fail|n/a> }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph: what project context was established (CLAUDE.md, onboarding brief)
and what it points to.

## What the AI produced

Which skill drafted it (e.g. documentation-generator) and from what sources (repo
inspection, SOW).

## What the human verified

Checkpoint 1 (plan approval): <sections and source documents confirmed>.
Checkpoint 2 (final approval): <every documented command run against a fresh
checkout; access confirmed>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
