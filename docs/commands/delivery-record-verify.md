# Delivery Record Verify

Validate one or more [Delivery Records](delivery-record.md) against the canonical
schema and the threshold rule. Read-only — it never writes or modifies records.
Use it for ad-hoc reviewer checks and as a CI lint.

---

## `delivery-record-verify`

### Usage

```bash
/delivery-record-verify docs/delivery-records/PR-456-breadcrumb.md
/delivery-record-verify                   # auto-detect docs/delivery-records/*.md
/delivery-record-verify --strict          # treat threshold warnings as failures
```

### What it checks

1. Parses the YAML front-matter; a missing or malformed `predicate_type` fails as
   "not a Delivery Record."
2. Resolves the schema version from `predicate_type` (the trailing `v<n>`).
3. Validates required fields, enums, and the per-`activity_type` required `checks`
   keys against `schema.json`.
4. Applies the **threshold rule**: a `fail` check needs a `## Waiver` heading; an
   `n/a` check needs a one-line justification near the top of the body. Warnings by
   default; failures under `--strict`.

### Report

- `✓` passing record
- `✗` hard validation failure (with field/location)
- `⚠` soft threshold warning
- Summary: `<n> records · <m> passing · <k> failing`

Exit codes: `0` all valid, `1` failure (or warning under `--strict`), `2`
environment/usage error.

---

## CI integration

Other projects can enforce that every PR ships a valid Delivery Record by adding
the bundled wrapper to CI. This is **not** enabled in cms-cultivator's own CI — it
is a tool other projects opt into.

```yaml
- name: Verify Delivery Records
  run: scripts/delivery-record-verify.sh --strict
```

The wrapper calls `scripts/delivery_record_verify.py`, which requires `python3`
with `pyyaml` and `jsonschema`.

---

## Related skills

- **[`/delivery-record`](delivery-record.md)** — write a record (this skill
  validates what that one produces).
