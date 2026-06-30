---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: design-handoff
subject:
  kind: document
  ref: "<Drive doc URL>"
  title: "<Handoff title>"
ticket: <TICKET>            # optional
scope: deliverable          # feature | fix | chore | milestone | launch | deliverable
assisted_by:
  models: [<model-id>]
  skills: [<skills used>]
checks:
  goals_kpis: { defined: <pass|fail|n/a>, measurable: <pass|fail|n/a> }
  audiences:  { mapped: <pass|fail|n/a> }
  journeys:   { primary: <pass|fail|n/a>, secondary: <pass|fail|n/a> }
  figma_urls: { present: <pass|fail|n/a>, dev_mode_ready: <pass|fail|n/a> }
  cd_review:  { creative_director: "<approved by @cd>" }
sign_off:
  produced_by: "@<author> <YYYY-MM-DD>"
  reviewed_by: ""           # REQUIRED — filled at the human checkpoint
  # approved_by: "@<client> <YYYY-MM-DD>"   # required when scope is launch or deliverable
---

<!-- Justify every `n/a` in one line near the top. A `fail` needs a `## Waiver` section. -->

## What changed

One paragraph: what the handoff compiles (goals/KPIs, audiences, journeys, Figma
references).

## What the AI produced

What design-analyzer (or equivalent) extracted from the Figma file.

## What the human verified

Checkpoint 1 (plan approval): <handoff template matched the design system>.
Checkpoint 2 (final approval): <Figma frames published and linked, KPIs measurable,
journeys map to real templates; creative fidelity signed off>.

## Issues found and resolved

- ...

## Deferred or known risks

- ... (owner + ticket link)
