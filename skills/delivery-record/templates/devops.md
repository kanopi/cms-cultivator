---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: devops
subject:
  kind: pr
  ref: "<org/repo#PR>"
  sha: <short-sha>
  title: "<Infra / environment change>"
ticket: <TICKET>            # optional
scope: chore                # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  change_documented: { readme_updated: <pass|fail|n/a>, runbook: <pass|fail|n/a> }
  tested_lower_env:  { multidev: <pass|fail|n/a>, ci_pipeline: <pass|fail|n/a> }
  secrets_handled:   { no_secrets_in_repo: <pass|fail|n/a>, env_vars_documented: <pass|fail|n/a> }
  rollback_plan:     { documented: <pass|fail|n/a>, revert_tested: <pass|fail|n/a> }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  # approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph plus a bullet list of the config/infra files touched. Note whether
application code paths change.

## What the AI produced

Which skill(s) ran (e.g. code-standards-checker) and any hosting commands that were
printed for a human to run rather than executed.

## What the human verified

Checkpoint 1 (plan approval): <backend choice and lower-environment test plan confirmed>.
Checkpoint 2 (final approval): <no secrets in the repo; change tested in a lower
environment; revert path tested>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
