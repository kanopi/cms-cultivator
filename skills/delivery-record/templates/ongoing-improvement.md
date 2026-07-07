---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: ongoing-improvement
subject:
  kind: report
  ref: "<Report / notebook URL>"
  title: "<Site health review — site>"
ticket: <TICKET>            # optional
scope: deliverable          # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  metrics_reviewed:            { core_web_vitals: <pass|fail|n/a>, uptime: <pass|fail|n/a>, error_rate: <pass|fail|n/a> }
  findings_verified:           { reproduced: <pass|fail|n/a>, sample_size: "<n templates>" }
  recommendations_prioritized: { ranked: <pass|fail|n/a>, effort_estimated: <pass|fail|n/a> }
  stakeholder_review:          { reviewed: "<approved by @pm>", techlead: <pass|fail|n/a> }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph: the review window, the metrics summarized, and the recommendation
output.

## What the AI produced

Which skill(s) ran (e.g. performance-analyzer, coverage-analyzer) and what they
surfaced.

## What the human verified

Checkpoint 1 (plan approval): <metrics window and sampled templates confirmed>.
Checkpoint 2 (final approval): <top findings reproduced; effort estimates and
priority order confirmed>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
