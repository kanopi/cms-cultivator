---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: discovery
subject:
  kind: document
  ref: "https://docs.google.com/document/d/disc456"
  title: "Discovery synthesis — audience research"
ticket: PROJ-401
scope: milestone
assisted_by:
  models: [claude-opus-4-8]
  skills: [strategist-site-audit]
checks:
  sources_cited:      { count: 9, links_present: pass }
  sample_size:        { interviews: 8, surveys: 142 }
  bias_check:         { sampling_bias_noted: pass, leading_questions_reviewed: pass }
  stakeholder_review: { strategist: "approved by @grace", pm: "approved by @dana" }
sign_off:
  produced_by: "@grace 2026-06-23"
  reviewed_by: "@dana 2026-06-23"
---

## What changed

Synthesized the discovery research into three primary audience segments with
supporting evidence from interviews, the survey, and analytics.

## What the AI produced

Drafted the segment definitions, journey hypotheses, and the evidence map linking
each claim back to a cited source.

## What the human verified

Checkpoint 1 (plan approval): @grace confirmed the synthesis framework before
drafting.
Checkpoint 2 (final approval): @grace verified every segment claim traces to a
cited source and that the survey's self-selection bias is called out; @dana
confirmed the segments align with the engagement goals.

## Issues found and resolved

- One unsupported claim about mobile usage removed pending analytics confirmation.

## Deferred or known risks

- Survey skewed toward existing members; net-new audience under-sampled
  (owner @grace, PROJ-409).
