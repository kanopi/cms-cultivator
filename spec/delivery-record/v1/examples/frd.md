---
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
activity_type: frd
subject:
  kind: document
  ref: "https://docs.google.com/document/d/abc123"
  title: "Member Portal — Functional Requirements"
ticket: PROJ-200
scope: deliverable
assisted_by:
  models: [claude-opus-4-8]
  skills: [frd-generator, story-point-estimator, csv-exporter]
checks:
  sow_alignment:     { in_scope: pass, out_of_scope_flagged: pass }
  hour_total_vs_cap: { estimate: "412h", cap: "480h", within_cap: pass }
  completeness:      { functional: pass, technical: pass, user_stories: pass }
  stakeholder_review: { tech_lead: "approved by @carol", pm: "approved by @dana" }
sign_off:
  produced_by: "@dana 2026-06-25"
  reviewed_by: "@carol 2026-06-25"
  approved_by: "@client 2026-06-26"
---

## What changed

Drafted the full FRD for the Member Portal milestone: 10 sections, 38 functional
requirements (FR-001–FR-038), 12 technical requirements, and 24 user stories.

## What the AI produced

`frd-generator` produced the section scaffold and requirement numbering;
`story-point-estimator` produced the per-story Fibonacci estimates and the hour
conversion; `csv-exporter` produced the Teamwork backlog CSV.

## What the human verified

Checkpoint 1 (plan approval): @carol confirmed the requirement decomposition
matched the SOW scope before estimation.
Checkpoint 2 (final approval): @carol verified the 412h total against the 480h
SOW cap and spot-checked five high-point stories; @dana confirmed every SOW line
item maps to at least one requirement and flagged the SSO integration as a
phase-2 out-of-scope note.

## Issues found and resolved

- Two duplicate requirements (search + filter) merged into FR-019.

## Deferred or known risks

- SSO integration deferred to phase 2 (owner @dana, PROJ-241).
