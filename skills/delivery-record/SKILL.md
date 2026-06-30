---
name: delivery-record
description: |
  Generate a Delivery Record for a significant AI-assisted output (PR, FRD,
  audit, discovery deliverable, design handoff, strategy doc, or client
  communication). Refuses to write without a named human reviewer and the two
  checkpoint notes. Writes to docs/delivery-records/ in a repo or to Drive in
  Claude Desktop, and indexes the result in the project's Teamwork "Delivery
  Records" notebook. Invoke at the end of a unit of work, after /pr-create for
  code, or via /delivery-record.
---

# Delivery Record

Draft a schema-typed, human-signed Delivery Record — one markdown file per
significant AI-assisted output — then write it and index it in Teamwork. The
main session runs this skill directly; no orchestrator agent is involved.

The record proves a piece of AI-assisted work was reviewed by a **named human**
and ran through Kanopi's workflow. The schema is canonical in this repo at
[`spec/delivery-record/v1/`](../../spec/delivery-record/v1/README.md); the
narrative rationale lives in [`kanopi/ai-workflows`](https://github.com/kanopi/ai-workflows/blob/main/src/content/delivery-record.md).

## ⚠️ Side Effect Warning

**This skill writes a file and posts to Teamwork.** Specifically it:

- Writes a markdown file to `docs/delivery-records/` in the repo (code) or to the
  client's Drive (non-code).
- Appends an index line to the project's "Delivery Records" Teamwork notebook
  (and, with your confirmation, creates that notebook if it is missing).
- For code records, amends the open PR description with a link to the record.

**The human checkpoint is mandatory.** This skill **refuses to write the file**
without a named reviewer and both checkpoint notes (see step 4).

## When a record is required

Required whenever the output is **client-facing** (code that ships, a deliverable
sent to the client, a message on a client thread) **or load-bearing internal** (an
FRD, IA, audit, architecture decision, or design-to-dev handoff that downstream
work depends on).

**Not** required for ephemeral chat, meeting prep, status notes, throwaway spikes,
or brainstorming.

## Usage

- "Create a delivery record for this PR"
- "Generate a delivery record for the audit report"
- `/delivery-record [--activity-type <type>] [--pr <n>] [--ticket <key>] [--scope <scope>] [--reviewer <handle>]`

### Inputs (CLI-style flags accepted in the prompt)

- `--activity-type <type>` — skip detection (`code`, `frd`, `audit`, `discovery`, `design-handoff`, `strategy`, `client-comm`)
- `--pr <n>` — override PR detection
- `--ticket <key>` — set `ticket:` explicitly
- `--scope <feature|fix|chore|milestone|launch|deliverable>` — set scope
- `--reviewer <handle>` — pre-fill `reviewed_by` (still validated against blank checkpoint notes)

## Workflow

### 1. Detect environment and activity type

- **Claude Code with a PR open** → default `activity_type: code`, `subject.kind: pr`.
  Gather the PR number and SHA from `gh pr view --json number,headRefOid,title,url`.
- **Claude Desktop / no PR** → ask for the `activity_type`, then route to the
  matching template in `templates/`.
- A `--activity-type` flag always wins over detection.

### 2. Gather facts

Pull what the chosen activity needs:

- **code**: `git log <base>..HEAD --oneline`, PR number/SHA/title from `gh pr view`,
  CI status (`gh pr checks` or the CircleCI MCP), presence of audit report files in
  the repo, and any `/evaluate-output` trajectory notes from this session.
- **frd**: the Teamwork epic + child tasks (via `teamwork-integrator`), the Drive
  doc URL, and the SOW hour cap if known.
- **audit**: the audit report file path, its methodology section, and the host
  site URL.
- **discovery / strategy / design-handoff**: ask for the Drive doc URL; pull recent
  Teamwork comments tagged to the same epic.
- **client-comm**: ask for the Teamwork message URL; pull the thread; pull the
  matching Fathom transcript if a call is referenced.

### 3. Draft the record

- Render `templates/<activity_type>.md`. Populate the front-matter with the
  gathered facts. Set `predicate_type` to
  `https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1`.
- Fill the `checks:` block with the required keys for the activity type (see the
  table in [`spec/delivery-record/v1/README.md`](../../spec/delivery-record/v1/README.md)).
  Use `pass` / `fail` / `n/a` for statuses and evidence strings (CI URLs, reviewer
  notes) where appropriate. **Justify every `n/a`** in one line near the top of the
  body; a `fail` requires a `## Waiver` section.
- Leave `sign_off.reviewed_by` and the two **What the human verified** checkpoint
  notes **blank** — those come from the human in step 4.
- Validate the in-progress draft early to catch missing required fields:

  ```bash
  python3 scripts/delivery_record_verify.py <draft-path>
  ```

  (Resolve the path to this plugin's bundled `scripts/`. In environments without
  Python, validate by eye against the schema reference — the front-matter required
  fields and the per-activity `checks` keys.)

### 4. Require the human checkpoint (the curl rule)

Display the draft and explicitly prompt:

> **Who is the named reviewer? Paste the Checkpoint 1 (plan approval) and
> Checkpoint 2 (final approval) notes.**

**Refuse to proceed** if either checkpoint note is blank or generic. A bare
"LGTM", "looks good", or an empty line **fails** — Checkpoint 2 must say what the
reviewer actually looked at beyond the automated gates. Re-prompt up to twice; on
the third blank/generic input, **abort** with a clear message and do not write the
file.

A `--reviewer` flag pre-fills `reviewed_by` but does **not** satisfy the checkpoint
notes — those are always required from the human.

### 5. Write the file

- **code**: `docs/delivery-records/PR-<n>-<slug>.md` in the current repo. Create
  the directory if it does not exist. `<slug>` is a kebab-case of the PR title.
- **non-code**: write to Drive via the Drive MCP at
  `/Delivery Records/YYYY-MM-DD-<slug>.md`. On first use in a project, ask for the
  target Drive folder and reuse it for the session. **If the Drive MCP is not
  available, abort** with clear instructions and print the full draft so the user
  can save it manually.

After writing, re-run the validator on the final file and report the result.

### 6. Index in Teamwork

- Use `teamwork-integrator` to find the project's **"Delivery Records"** notebook.
- If it does not exist, **confirm with the user before creating it** (do not create
  silently). If the user declines, skip indexing and tell them the record was
  written but not indexed.
- Append a one-line entry:

  ```
  YYYY-MM-DD · <activity_type> · <title> · <link>
  ```

### 7. For code records: link from the PR

Amend the PR description with a trailer so reviewers can find the record:

```
Delivery Record: docs/delivery-records/PR-<n>-<slug>.md
```

## Validation reference

The skill never writes an invalid record. The required front-matter fields,
the per-activity `checks` keys, the `pass | fail | n/a` rule, and the
waiver/justification (threshold) rule are all defined in
[`spec/delivery-record/v1/`](../../spec/delivery-record/v1/README.md). Use
`/delivery-record-verify` to validate an existing record after the fact.

## Environment fallback

- **No `gh` CLI** → ask the user for the PR number, SHA, and CI status, then
  proceed; print the `gh pr edit` command for the PR link in step 7 instead of
  running it.
- **No Teamwork MCP** → write the file, then tell the user to add the index line
  to the Delivery Records notebook manually (provide the exact line).
- **No Drive MCP (non-code)** → abort the write per step 5 and print the draft.

## Related skills

- **pr-create** — run first for code; the Delivery Record is the per-PR artifact
  that follows.
- **commit-message-generator** — appends the per-commit `Assisted-by:` trailer that
  complements the per-PR record.
- **delivery-record-verify** — validate a record against the schema and the
  threshold rule.
- **teamwork-integrator** — locate and update the Delivery Records notebook.
