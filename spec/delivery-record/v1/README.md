# Kanopi Delivery Record — schema v1

The canonical, machine-readable schema for a **Delivery Record**: one
schema-typed, human-signed markdown file per significant AI-assisted output.
This directory is the authoritative source. The human-readable face of the spec
lives on the docs site at
<https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1/>.

> **AI drafts the record. A named human reviews, edits, and signs.** A passive
> "AI was used" disclosure is not enough — the record names the reviewer.

## Files

| File | Purpose |
| --- | --- |
| `schema.json` | JSON Schema 2020-12 for the YAML front-matter. Self-contained; validates a full record including per-activity required `checks` keys via `if/then` branches. |
| `checks/<activity_type>.json` | Standalone sub-schema for one activity's `checks` block. Single source of truth for which keys each activity requires. |
| `examples/*.md` | One fully filled-in record per activity type. Double as validation fixtures. |

Only the **front-matter** is validated. The prose body is unstructured by design.

## Front-matter fields

| Field | Required | Notes |
| --- | --- | --- |
| `predicate_type` | yes | Must match `https://kanopi.github.io/cms-cultivator/spec/delivery-record/v<n>`. |
| `activity_type` | yes | One of `code`, `frd`, `audit`, `discovery`, `design-handoff`, `strategy`, `client-comm`, `design`, `qa`, `launch`, `deployment`, `devops`, `project-setup`, `ongoing-improvement`. |
| `subject` | yes | Object with `kind` (`pr`/`document`/`report`/`figma`/`message`) and `title`; optional `ref`, `sha`. |
| `ticket` | no | Project ticket reference. |
| `scope` | no | One of `feature`, `fix`, `chore`, `milestone`, `launch`, `deliverable`. |
| `assisted_by` | yes | Object with `models` (non-empty array) and optional `skills`. |
| `checks` | yes | Object of check groups; required keys depend on `activity_type` (see below). |
| `sign_off` | yes | Requires `produced_by` and `reviewed_by`; `approved_by` is required when `scope` is `launch` or `deliverable`. |

## Per-activity check templates

The `checks:` block adapts to the activity type — same record shape, different
evidence. Each `checks/<activity_type>.json` requires exactly these keys:

| Activity type | Subject kind | Required `checks` keys | Sign-off roles |
| --- | --- | --- | --- |
| `code` | pr | `standards`, `tests`, `audits`, `review` | Developer, Tech Lead |
| `frd` | document | `sow_alignment`, `hour_total_vs_cap`, `completeness`, `stakeholder_review` | Tech Lead, PM |
| `audit` | report | `methodology`, `sample_size`, `findings_verified`, `severity_rubric` | Specialist, Tech Lead |
| `discovery` | document | `sources_cited`, `sample_size`, `bias_check`, `stakeholder_review` | Strategist, PM |
| `design-handoff` | document | `goals_kpis`, `audiences`, `journeys`, `figma_urls`, `cd_review` | Strategist, Designer, Tech Lead |
| `strategy` | document | `sources_grounded`, `recommendations_defensible`, `alternatives_considered` | Strategist, Account |
| `client-comm` | message | `facts_verified`, `tone_reviewed`, `no_unauthorized_commitments` | PM, Account |
| `design` | figma | `brand_alignment`, `design_system`, `accessibility_review`, `stakeholder_review` | Designer, Creative Director |
| `qa` | report | `acceptance_criteria`, `test_coverage`, `regressions_checked`, `evidence_captured` | QA, Tech Lead |
| `launch` | document | `prelaunch_audits`, `rollback_plan`, `dns_ssl_verified`, `stakeholder_signoff` | Tech Lead, PM, Account |
| `deployment` | report | `release_notes`, `backup_taken`, `migrations_verified`, `smoke_test` | Developer, Tech Lead |
| `devops` | pr | `change_documented`, `tested_lower_env`, `secrets_handled`, `rollback_plan` | DevOps, Tech Lead |
| `project-setup` | document | `context_accurate`, `sources_verified`, `access_confirmed`, `stakeholder_review` | PM, Tech Lead |
| `ongoing-improvement` | report | `metrics_reviewed`, `findings_verified`, `recommendations_prioritized`, `stakeholder_review` | Tech Lead, PM |

Each check group is an object. Leaf values are a status (`pass` / `fail` / `n/a`)
or an evidence string such as a CI run URL or a reviewer note
(`code_review: "approved by @alice"`).

## The threshold rule

The status semantics are enforced by the verifier, not the schema:

- A `fail` cannot be signed off without an explicit `## Waiver` heading in the body.
- An `n/a` must be justified in one line near the top of the body — silence is
  not an answer.

`/delivery-record-verify` surfaces these as **warnings** by default and as
**hard failures** under `--strict`.

## Validating

```bash
# All records under docs/delivery-records/, or pass explicit paths
python3 scripts/delivery_record_verify.py spec/delivery-record/v1/examples/*.md
python3 scripts/delivery_record_verify.py --strict path/to/record.md
```

Any JSON Schema 2020-12 validator works against `schema.json` directly — e.g.
`npx ajv-cli validate -s schema.json -d record.json` after converting the
front-matter to JSON.

See [`../VERSIONING.md`](../VERSIONING.md) for the compatibility policy.
