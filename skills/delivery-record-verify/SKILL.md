---
name: delivery-record-verify
description: |
  Validate a Delivery Record file against the kanopi/delivery-record schema.
  Reads predicate_type to resolve the schema version, then enforces required
  fields, checks-value validity (pass|fail|n/a), and the per-activity_type
  required-keys policy. Applies the threshold rule (fail needs a waiver, n/a
  needs a justification) as soft warnings, or hard failures with --strict.
  Invoke as /delivery-record-verify <path>, or with no path to validate all
  docs/delivery-records/*.md.
---

# Delivery Record Verify

Validate one or more Delivery Record files against the canonical schema in
[`spec/delivery-record/`](../../spec/delivery-record/). Intended for ad-hoc
reviewer use and for CI lint. This skill is **read-only** — it never writes or
modifies records.

## Usage

- "Verify this delivery record: docs/delivery-records/PR-456-breadcrumb.md"
- "Validate all the delivery records"
- `/delivery-record-verify [path] [--strict]`

## Workflow

### 1. Resolve the target(s)

- If a path is given, validate that file.
- If no path is given, auto-detect every `docs/delivery-records/*.md` under the
  current repo.

### 2. Run the verifier

The mechanics live in the bundled validator. From the plugin's `scripts/`:

```bash
python3 scripts/delivery_record_verify.py [path ...] [--strict]
# or the CI wrapper:
scripts/delivery-record-verify.sh [path ...] [--strict]
```

The validator:

1. Parses the YAML front-matter. If `predicate_type` is missing or malformed, it
   fails with "not a Delivery Record."
2. Resolves the schema version from `predicate_type` (e.g. the trailing `v1` →
   `spec/delivery-record/v1/schema.json`).
3. Validates the front-matter against `schema.json`, which enforces the required
   fields, the enums, and the per-`activity_type` required `checks` keys.
4. Applies the **threshold rule** as soft warnings: a `fail` check requires a
   `## Waiver` heading in the body; an `n/a` check requires a one-line
   justification within the first five lines of the body. `--strict` escalates
   these warnings to failures.

### 3. Report

The verifier prints a structured report:

- `✓` for each passing record
- `✗` for hard validation failures, with the offending field/location
- `⚠` for soft (threshold) warnings
- A final summary line: `<n> records · <m> passing · <k> failing`

Exit codes: `0` all valid, `1` one or more failures (or a warning under
`--strict`), `2` environment/usage error.

### 4. Environment fallback (no Python)

If `python3` is unavailable, validate by hand against
[`spec/delivery-record/v1/README.md`](../../spec/delivery-record/v1/README.md):

1. Confirm `predicate_type` matches the version URL pattern.
2. Confirm the six required front-matter fields are present.
3. Confirm `checks` contains exactly the required keys for the record's
   `activity_type` (see the per-activity table).
4. Confirm `sign_off.produced_by` and `sign_off.reviewed_by` are non-empty, and
   that `approved_by` is present when `scope` is `launch` or `deliverable`.
5. Apply the threshold rule for any `fail` / `n/a` values.

Report findings in the same `✓ / ✗ / ⚠` shape.

## CI integration

Other projects can enforce that every PR ships a valid Delivery Record by adding
the wrapper to CI (not enabled in cms-cultivator's own CI by default):

```yaml
- name: Verify Delivery Records
  run: scripts/delivery-record-verify.sh --strict
```

## Related skills

- **delivery-record** — write a new record (this skill validates what that one produces).
