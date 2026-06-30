---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: strategy
subject:
  kind: document
  ref: "<Drive doc URL>"
  title: "<Strategy doc title>"
ticket: <TICKET>            # optional
scope: milestone            # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  sources_grounded:           { citations_present: <pass|fail|n/a> }
  recommendations_defensible: { tradeoffs_documented: <pass|fail|n/a> }
  alternatives_considered:    { options_evaluated: <N> }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  # approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph: the options compared and the recommendation made.

## What the AI produced

Which skill ran (e.g. strategic-thinking) and what analysis it produced.

## What the human verified

Checkpoint 1 (plan approval): <the options to evaluate were the right ones>.
Checkpoint 2 (final approval): <recommendations cite real constraints; alternatives
fairly weighed>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
