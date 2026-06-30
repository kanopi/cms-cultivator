---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: discovery
subject:
  kind: document
  ref: "<Drive doc URL>"
  title: "<Discovery title>"
ticket: <TICKET>            # optional
scope: milestone            # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  sources_cited:      { count: <N>, links_present: <pass|fail|n/a> }
  sample_size:        { interviews: <N>, surveys: <N> }
  bias_check:         { sampling_bias_noted: <pass|fail|n/a>, leading_questions_reviewed: <pass|fail|n/a> }
  stakeholder_review: { strategist: "<approved by @strategist>", pm: "<approved by @pm>" }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  # approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph: what was synthesized (segments, journeys, evidence map) and from
what inputs.

## What the AI produced

What was drafted and how each claim is linked back to a cited source.

## What the human verified

Checkpoint 1 (plan approval): <synthesis framework confirmed>.
Checkpoint 2 (final approval): <claims traced to sources, sampling bias called out>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
