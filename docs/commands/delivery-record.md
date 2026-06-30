# Delivery Record Skills

Produce and validate **Delivery Records** — one schema-typed, human-signed
markdown file per significant AI-assisted output. A record proves the work was
reviewed by a *named human* and ran through Kanopi's workflow.

The schema is canonical in the repository at
[`spec/delivery-record/v1/`](../spec/delivery-record/v1.md); the narrative
rationale lives in
[`kanopi/ai-workflows`](https://github.com/kanopi/ai-workflows/blob/main/src/content/delivery-record.md).

---

## When a record is required

Required whenever the output is **client-facing** (code that ships, a deliverable
sent to the client, a message on a client thread) or **load-bearing internal** (an
FRD, IA, audit, architecture decision, or design-to-dev handoff that downstream
work depends on).

Not required for ephemeral chat, meeting prep, status notes, throwaway spikes, or
brainstorming.

---

## `delivery-record`

Draft a Delivery Record, require a named reviewer and checkpoint notes, write the
file, and index it in Teamwork.

!!! warning "Side effects"
    Writes a markdown file (repo or Drive), appends to the project's Teamwork
    "Delivery Records" notebook, and links the record from the PR. **Refuses to
    write without a named reviewer and both checkpoint notes.**

### Usage

```bash
/delivery-record                              # detects PR → activity_type: code
/delivery-record --activity-type frd          # non-code deliverable
/delivery-record --pr 456 --scope deliverable
/delivery-record --reviewer @alice            # pre-fill reviewer (checkpoints still required)
```

### Flags

- `--activity-type <type>` — `code`, `frd`, `audit`, `discovery`, `design-handoff`, `strategy`, `client-comm`
- `--pr <n>` — override PR detection
- `--ticket <key>` — set the ticket reference
- `--scope <feature|fix|chore|milestone|launch|deliverable>` — set scope
- `--reviewer <handle>` — pre-fill `reviewed_by`

### What it does

1. Detects the environment and activity type (PR open → `code`).
2. Gathers facts (git/PR/CI for code; Teamwork/Drive/Fathom for non-code).
3. Drafts the record from the matching template and validates the draft.
4. **Requires the human checkpoint** — a named reviewer plus Checkpoint 1 (plan)
   and Checkpoint 2 (final) notes. A bare "LGTM" fails.
5. Writes the file: `docs/delivery-records/PR-<n>-<slug>.md` (code) or Drive
   `/Delivery Records/YYYY-MM-DD-<slug>.md` (non-code).
6. Indexes the record in the Teamwork "Delivery Records" notebook (asks before
   creating the notebook).
7. For code, links the record from the PR description.

---

## `delivery-record-verify`

Validate an existing Delivery Record against the schema and the threshold rule.
Read-only. See the [verify command page](delivery-record-verify.md).

```bash
/delivery-record-verify docs/delivery-records/PR-456-breadcrumb.md
/delivery-record-verify --strict          # all records; warnings become failures
```

---

## Related skills

- **[`/pr-create`](pr-workflow.md)** — run first for code; the record is the
  per-PR artifact that follows.
- **`commit-message-generator`** — appends the per-commit `Assisted-by:` trailer
  that complements the per-PR record.
- **`teamwork-integrator`** — locates and updates the Delivery Records notebook.
