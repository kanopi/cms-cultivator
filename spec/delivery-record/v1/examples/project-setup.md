---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: project-setup
subject:
  kind: document
  ref: "kanopi/example/CLAUDE.md"
  title: "Project context — CLAUDE.md and onboarding brief"
ticket: PROJ-001
scope: deliverable
assisted_by:
  models: [claude-opus-4-8]
  skills: [documentation-generator]
checks:
  context_accurate:   { stack_verified: pass, commands_verified: pass }
  sources_verified:   { sow_reviewed: pass, repo_inspected: pass }
  access_confirmed:   { hosting: pass, teamwork: pass, drive: pass }
  stakeholder_review: { reviewed: "approved by @pm", techlead: pass }
sign_off:
  produced_by: "@dana 2026-06-24"
  reviewed_by: "@techlead 2026-06-24"
  approved_by: "@pm 2026-06-24"
---

## What changed

Established the shared project context: a `CLAUDE.md` documenting the stack,
DDEV/Composer commands, and coding standards, plus an onboarding brief pointing
to the SOW, hosting, and Teamwork.

## What the AI produced

`documentation-generator` drafted `CLAUDE.md` from an inspection of the repo
(composer.json, theme tooling, CI config) and the SOW, then flagged commands it
could not verify.

## What the human verified

Checkpoint 1 (plan approval): @dana confirmed the sections to include and the
source documents.
Checkpoint 2 (final approval): @techlead ran every documented command against a
fresh checkout to confirm accuracy; @pm approved the onboarding brief and
confirmed access to hosting, Teamwork, and Drive.

## Issues found and resolved

- Draft listed a `npm run test` script that does not exist; removed after the
  command-verification pass.

## Deferred or known risks

- None.
