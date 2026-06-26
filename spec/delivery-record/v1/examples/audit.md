---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: audit
subject:
  kind: report
  ref: "audit-live-site-2026-06-24-1400.md"
  title: "Accessibility audit — marketing site"
ticket: PROJ-310
scope: deliverable
assisted_by:
  models: [claude-opus-4-8]
  skills: [accessibility-audit]
checks:
  methodology:       { standard: "WCAG 2.1 AA", tooling: "axe + manual" }
  sample_size:       { pages_reviewed: 12, templates_covered: pass }
  findings_verified: { manually_confirmed: pass, false_positives_removed: pass }
  severity_rubric:   { applied: pass, scale: "critical/serious/moderate/minor" }
sign_off:
  produced_by: "@eve 2026-06-24"
  reviewed_by: "@frank 2026-06-24"
  approved_by: "@client 2026-06-25"
---

## What changed

Full WCAG 2.1 AA accessibility audit of the marketing site: 12 representative
pages across 7 templates, 41 findings ranked by the four-level severity rubric.

## What the AI produced

`accessibility-audit` spawned the accessibility-specialist, which captured the
axe automated pass and the keyboard/screen-reader manual review, then produced
the ranked findings report.

## What the human verified

Checkpoint 1 (plan approval): @frank confirmed the page sample covered every
distinct template before the audit ran.
Checkpoint 2 (final approval): @eve manually re-confirmed all 7 critical findings
in a screen reader and removed 3 axe false positives before the report shipped.

## Issues found and resolved

- 3 automated false positives (decorative SVGs flagged as missing alt) removed.

## Deferred or known risks

- Third-party embedded map widget is non-conformant; vendor ticket filed
  (owner @frank, PROJ-318).
