# Delivery Record — versioning policy

The Delivery Record schema follows the [in-toto](https://github.com/in-toto/attestation)
convention of a versioned, resolvable `predicate_type`. Each major version lives
in its own self-contained directory under `spec/delivery-record/`.

```
spec/delivery-record/
├── VERSIONING.md      ← this file
└── v1/
    ├── README.md
    ├── schema.json
    ├── checks/
    └── examples/
```

## How versions resolve

A record names its schema version in front-matter:

```yaml
predicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1
```

The `/delivery-record-verify` skill (and `scripts/delivery_record_verify.py`)
read the trailing `v<n>` segment and load `spec/delivery-record/v<n>/schema.json`.
The URL also resolves to the human-readable schema page on the docs site at
<https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1/>.

## What is allowed within a version

`v1` is the floor. **Additive, backward-compatible changes** are allowed in place
without a new version directory:

- New **optional** front-matter fields.
- New `activity_type` enum values — **only if** every existing value keeps
  validating exactly as before, and the new value ships with its own
  `checks/<activity_type>.json` and an `if/then` branch in `schema.json`.
- New optional keys inside a `checks` group.
- Clarifying `description` text and new examples.

Every record that validated against `v1` yesterday must still validate today.

## What requires a new version

**Breaking changes** require a new `v2/` directory; `v1/` stays untouched so old
records keep validating forever:

- Renaming or removing a front-matter field.
- Making an optional field required.
- Removing or renaming an `activity_type` value or a required `checks` key.
- Changing the meaning of an existing field or check.

When `v2/` ships, new records use the `…/v2` predicate; existing `…/v1` records
are never rewritten and keep resolving against `v1/`.

## Each version directory is self-contained

A version directory carries everything needed to validate a record of that
version: the main `schema.json`, the per-activity `checks/*.json` sub-schemas,
and example records. Tooling never reaches across version directories.
