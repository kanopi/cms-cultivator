---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: qa
subject:
  kind: report
  ref: "<Teamwork task URL>"
  title: "<QA — feature (TICKET)>"
ticket: <TICKET>            # optional
scope: feature              # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  acceptance_criteria: { all_met: <pass|fail|n/a>, notes: "<n of n criteria validated>" }
  test_coverage:       { functional: <pass|fail|n/a>, responsive: <pass|fail|n/a>, cross_browser: <pass|fail|n/a> }
  regressions_checked: { adjacent_pages: <pass|fail|n/a> }
  evidence_captured:   { screenshots: <pass|fail|n/a>, multidev_url: "<preview URL>" }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  # approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph: what was validated and against which acceptance criteria.

## What the AI produced

Which skill(s) generated the checklist and drove the browser (e.g.
qa-validation-checklist, browser-validator), and what evidence was captured.

## What the human verified

Checkpoint 1 (plan approval): <the validation steps matched the acceptance criteria>.
Checkpoint 2 (final approval): <screenshots and regression pass reviewed; console
checked>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
