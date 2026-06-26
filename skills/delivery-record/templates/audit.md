---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: audit
subject:
  kind: report
  ref: "<audit report file or URL>"
  title: "<Audit title>"
ticket: <TICKET>            # optional
scope: deliverable          # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  methodology:       { standard: "<e.g. WCAG 2.1 AA / OWASP Top 10>", tooling: "<tools>" }
  sample_size:       { pages_reviewed: <N>, templates_covered: <pass|fail|n/a> }
  findings_verified: { manually_confirmed: <pass|fail|n/a>, false_positives_removed: <pass|fail|n/a> }
  severity_rubric:   { applied: <pass|fail|n/a>, scale: "<rubric>" }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  # approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph plus the scope: pages/templates reviewed, finding count, severity
breakdown.

## What the AI produced

Which audit skill/specialist ran and what it captured (automated pass + manual
review).

## What the human verified

Checkpoint 1 (plan approval): <sample coverage confirmed before the audit ran>.
Checkpoint 2 (final approval): <critical findings re-confirmed manually, false
positives removed>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
