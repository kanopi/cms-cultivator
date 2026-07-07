---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: design
subject:
  kind: figma
  ref: "<Figma file URL>"
  title: "<Deliverable title>"
ticket: <TICKET>            # optional
scope: deliverable          # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  brand_alignment:      { logo_usage: <pass|fail|n/a>, color_tokens: <pass|fail|n/a>, type_scale: <pass|fail|n/a> }
  design_system:        { components_reused: <pass|fail|n/a>, new_components_documented: <pass|fail|n/a> }
  accessibility_review: { contrast: <pass|fail|n/a>, target_sizes: <pass|fail|n/a>, focus_states: <pass|fail|n/a> }
  stakeholder_review:   { reviewed: "<approved by @reviewer>", client: <pass|fail|n/a> }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph: what was designed (mood board, design system, hi-fi comps) and how
it was delivered.

## What the AI produced

Which skill(s) ran (e.g. design-analyzer) and what they extracted or flagged.

## What the human verified

Checkpoint 1 (plan approval): <the direction confirmed before building comps>.
Checkpoint 2 (final approval): <brand alignment, component reuse, and AA contrast
verified beyond the automated checks>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
