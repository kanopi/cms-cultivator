---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: frd
subject:
  kind: document
  ref: "<Drive doc URL>"
  title: "<FRD title>"
ticket: <TICKET>            # optional
scope: deliverable          # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  sow_alignment:      { in_scope: <pass|fail|n/a>, out_of_scope_flagged: <pass|fail|n/a> }
  hour_total_vs_cap:  { estimate: "<Nh>", cap: "<Nh>", within_cap: <pass|fail|n/a> }
  completeness:       { functional: <pass|fail|n/a>, technical: <pass|fail|n/a>, user_stories: <pass|fail|n/a> }
  stakeholder_review: { tech_lead: "<approved by @lead>", pm: "<approved by @pm>" }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  # approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph plus a bullet list of the sections, requirement counts, and scope.

## What the AI produced

Which skills ran (frd-generator, story-point-estimator, csv-exporter) and what
each produced.

## What the human verified

Checkpoint 1 (plan approval): <brief note>.
Checkpoint 2 (final approval): <SOW mapping confirmed, hour total vs cap checked,
high-point stories spot-checked>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
