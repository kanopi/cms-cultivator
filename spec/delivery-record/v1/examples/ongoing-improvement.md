---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: ongoing-improvement
subject:
  kind: report
  ref: "https://kanopi.teamwork.com/app/notebooks/6110"
  title: "Q2 site health review — example.com"
ticket: PROJ-770
scope: deliverable
assisted_by:
  models: [claude-opus-4-8]
  skills: [performance-analyzer, coverage-analyzer]
checks:
  metrics_reviewed:            { core_web_vitals: pass, uptime: pass, error_rate: pass }
  findings_verified:           { reproduced: pass, sample_size: "12 templates" }
  recommendations_prioritized: { ranked: pass, effort_estimated: pass }
  stakeholder_review:          { reviewed: "approved by @pm", techlead: pass }
sign_off:
  produced_by: "@dana 2026-07-02"
  reviewed_by: "@techlead 2026-07-02"
  approved_by: "@pm 2026-07-02"
---

## What changed

Quarterly site-health review for example.com: Core Web Vitals trend, error-rate
and uptime summary, and a prioritized list of improvement recommendations for the
next engagement block.

## What the AI produced

`performance-analyzer` pulled the CWV trend across the top templates;
`coverage-analyzer` flagged three untested code paths that recur in error logs.
Findings were compiled into a ranked recommendation list.

## What the human verified

Checkpoint 1 (plan approval): @dana confirmed the metrics window and the templates
to sample.
Checkpoint 2 (final approval): @techlead reproduced the top three findings and
confirmed the effort estimates were realistic; @pm approved the priority order.

## Issues found and resolved

- One "regression" was a measurement artifact from a synthetic-test change; dropped
  from the findings after verification.

## Deferred or known risks

- INP on the search results template is borderline; scheduled for the next block
  (owner @techlead, PROJ-771).
