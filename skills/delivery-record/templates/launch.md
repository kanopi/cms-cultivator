---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: launch
subject:
  kind: document
  ref: "<Launch notebook / doc URL>"
  title: "<Launch readiness — site>"
ticket: <TICKET>            # optional
scope: launch               # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  prelaunch_audits:    { a11y: <pass|fail|n/a>, performance: <pass|fail|n/a>, seo: <pass|fail|n/a>, security: <pass|fail|n/a> }
  rollback_plan:       { documented: <pass|fail|n/a>, tested: <pass|fail|n/a> }
  dns_ssl_verified:    { dns_cutover: <pass|fail|n/a>, ssl_cert: <pass|fail|n/a>, redirects: <pass|fail|n/a> }
  stakeholder_signoff: { techlead: <pass|fail|n/a>, pm: <pass|fail|n/a>, client: "<approved by @client>" }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph: the launch scope, the cutover plan, and the rollback procedure.

## What the AI produced

Which audit skills ran (e.g. performance-analyzer, structured-data-analyzer) and
where the reports live.

## What the human verified

Checkpoint 1 (plan approval): <cutover window and stakeholder list confirmed>.
Checkpoint 2 (final approval): <rollback tested; redirect map complete; go-live
approved>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
