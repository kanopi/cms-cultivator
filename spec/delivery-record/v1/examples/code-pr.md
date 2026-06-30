---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: code
subject:
  kind: pr
  ref: "kanopi/example#456"
  sha: 7398623
  title: "Add breadcrumb component"
ticket: PROJ-123
scope: feature
assisted_by:
  models: [claude-opus-4-8]
  skills: [pr-create, code-standards-checker, accessibility-checker]
checks:
  standards: { phpcs: pass, phpstan: pass }
  tests:     { unit: pass, ci_run: "https://app.circleci.com/pipelines/github/kanopi/example/123" }
  audits:    { a11y: pass, performance: n/a, security: pass }
  review:    { code_review: "approved by @alice", qa: pass }
sign_off:
  produced_by: "@bob 2026-06-25"
  reviewed_by: "@alice 2026-06-25"
---

`performance: n/a` — this PR adds a static SDC with no new queries or assets;
no measurable runtime path to profile.

## What changed

Adds a global breadcrumb Single Directory Component (SDC) and the Twig template
that reads the active menu trail.

- `web/themes/custom/example/components/breadcrumb/`
- `web/themes/custom/example/example.libraries.yml`

## What the AI produced

`pr-create` drafted the PR description; `code-standards-checker` ran PHPCS and
PHPStan to green; `accessibility-checker` reviewed the landmark roles and the
`aria-current` handling on the active crumb.

## What the human verified

Checkpoint 1 (plan approval): confirmed the SDC approach over a preprocess hook.
Checkpoint 2 (final code approval): @alice read the Twig template and the schema,
verified the WCAG 2.1 AA landmark structure beyond the automated a11y gate, and
confirmed the menu-trail logic against a three-level deep page.

## Issues found and resolved

- Initial draft hard-coded the home link label; switched to the site name token.

## Deferred or known risks

- None.
