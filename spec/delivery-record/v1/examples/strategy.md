---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: strategy
subject:
  kind: document
  ref: "https://docs.google.com/document/d/strat321"
  title: "Platform recommendation — Drupal vs headless"
ticket: PROJ-600
scope: milestone
assisted_by:
  models: [claude-opus-4-8]
  skills: [strategic-thinking]
checks:
  sources_grounded:           { citations_present: pass }
  recommendations_defensible: { tradeoffs_documented: pass }
  alternatives_considered:    { options_evaluated: 3 }
sign_off:
  produced_by: "@grace 2026-06-21"
  reviewed_by: "@account 2026-06-21"
---

## What changed

Produced the platform recommendation comparing monolithic Drupal, headless
Drupal, and a hybrid approach, with a clear recommendation and rationale.

## What the AI produced

`strategic-thinking` worked through the 5 Cs and produced the trade-off matrix
and the cost/consequence analysis for each option.

## What the human verified

Checkpoint 1 (plan approval): @grace confirmed the three options were the right
ones to evaluate.
Checkpoint 2 (final approval): @grace verified each recommendation cites a real
constraint and that the editorial-complexity risk from the prior headless attempt
is reflected; @account confirmed the recommendation fits the budget envelope.

## Issues found and resolved

- Removed an over-stated performance claim about headless that lacked a source.

## Deferred or known risks

- Editorial workflow requirements still undefined; recommendation is conditional
  on documenting them first (owner @grace, PROJ-611).
