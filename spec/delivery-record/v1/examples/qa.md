---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: qa
subject:
  kind: report
  ref: "https://kanopi.teamwork.com/app/tasks/8123"
  title: "QA — breadcrumb component (PROJ-123)"
ticket: PROJ-123
scope: feature
assisted_by:
  models: [claude-opus-4-8]
  skills: [qa-validation-checklist, browser-validator]
checks:
  acceptance_criteria: { all_met: pass, notes: "3 of 3 criteria validated" }
  test_coverage:       { functional: pass, responsive: pass, cross_browser: pass }
  regressions_checked: { adjacent_pages: pass, existing_menu: pass }
  evidence_captured:   { screenshots: pass, multidev_url: "https://pr-123-example.pantheonsite.io" }
sign_off:
  produced_by: "@quinn 2026-06-26"
  reviewed_by: "@techlead 2026-06-26"
---

## What changed

QA validation of the breadcrumb component on the PR multidev before it advances
to Code Review. Validated against the ticket's acceptance criteria.

## What the AI produced

`qa-validation-checklist` generated the step-by-step validation plan from the
ticket; `browser-validator` drove the multidev at 320px, 768px, and 1024px and
captured annotated screenshots.

## What the human verified

Checkpoint 1 (plan approval): @quinn confirmed the validation steps matched the
acceptance criteria.
Checkpoint 2 (final approval): @techlead reviewed the screenshots and the
regression pass on the existing menu trail, and confirmed no console errors.

## Issues found and resolved

- Focus ring was clipped at 320px; logged as a follow-up before merge.

## Deferred or known risks

- None.
