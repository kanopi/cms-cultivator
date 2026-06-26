---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: client-comm
subject:
  kind: message
  ref: "<Teamwork message URL>"
  title: "<Message subject>"
ticket: <TICKET>            # optional
scope: chore                # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  facts_verified:              { ticket_status_confirmed: <pass|fail|n/a>, dates_confirmed: <pass|fail|n/a> }
  tone_reviewed:               { reviewed: <pass|fail|n/a> }
  no_unauthorized_commitments: { confirmed: <pass|fail|n/a> }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  # approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph: what the message communicates (status, decision, request).

## What the AI produced

Which skill drafted it (e.g. project-heartbeat) and from what sources.

## What the human verified

Checkpoint 1 (plan approval): <the message focus was confirmed>.
Checkpoint 2 (final approval): <every status claim checked against ticket states;
no new scope/timeline/budget commitment implied; tone approved>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
