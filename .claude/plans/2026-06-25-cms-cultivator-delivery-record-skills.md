# Implementation plan — Delivery Record skills + spec in `kanopi/cms-cultivator`

**Date:** 2026-06-25
**Target repo:** [kanopi/cms-cultivator](https://github.com/kanopi/cms-cultivator) (branch `1.x`)
**Spec source:** [ai-workflows · /delivery-record](https://github.com/kanopi/ai-workflows/blob/main/src/content/delivery-record.md)
**Companion issue:** [kanopi/ai-workflows#5](https://github.com/kanopi/ai-workflows/issues/5)

This plan ships **three things** in the `cms-cultivator` repo, in two PRs:

1. **`spec/delivery-record/v1/`** — the canonical, machine-readable schema (JSON Schema + per-activity check templates + example records). The `predicate_type: kanopi/delivery-record/v1` identifier resolves here.
2. **`/delivery-record` skill** — drafts a Delivery Record at the end of a unit of work, refuses to write without a named human reviewer, and indexes the record in Teamwork.
3. **`/delivery-record-verify` skill** — validates an existing record file against the schema and the threshold rule; intended for CI lint and ad-hoc reviewer use.

---

## Sequencing

| PR | What lands | Why this order |
| --- | --- | --- |
| **PR 1** | `spec/delivery-record/v1/` + `/delivery-record` skill | The spec must exist before either skill can validate against it; the *write* skill is the higher-value half so people start producing records immediately. |
| **PR 2** | `/delivery-record-verify` skill + (optional) sample CI workflow | Verification is meaningless until real records exist. Ship after PR 1 lands and a few records have been produced. |

A short waiting period between the two PRs is intentional — it gives a feedback window to refine the schema before locking lint behavior on top of it.

---

## PR 1 — Spec + `/delivery-record` skill

### 1.1 Spec directory

Create `spec/delivery-record/v1/` containing:

```
spec/delivery-record/v1/
├── README.md                  # Human-readable schema docs (lift from ai-workflows /delivery-record)
├── schema.json                # JSON Schema 2020-12 for the front-matter only
├── checks/
│   ├── code.json              # Per-activity check templates (one file per activity_type)
│   ├── frd.json
│   ├── audit.json
│   ├── discovery.json
│   ├── design-handoff.json
│   ├── strategy.json
│   └── client-comm.json
└── examples/
    ├── code-pr.md             # Full example records for each activity_type
    ├── frd.md
    └── audit.md
```

**`schema.json`** — validates the YAML front-matter only (the prose body is unstructured by design). Required fields: `predicate_type`, `activity_type`, `subject`, `assisted_by`, `checks`, `sign_off`. Constrains:

- `predicate_type` matches `^kanopi/delivery-record/v\\d+$`
- `activity_type` is one of seven enum values
- Every value inside `checks.*` is `pass | fail | n/a`
- `sign_off.produced_by` and `sign_off.reviewed_by` are required strings; `approved_by` is optional (required only when `scope` is `launch` or `deliverable`)

**`checks/<activity_type>.json`** — sub-schemas that constrain which keys are *required* inside the `checks:` block for that activity. Code records require `standards`, `tests`, `audits`, `review`; FRDs require `sow_alignment`, `hour_total_vs_cap`, `completeness`, `stakeholder_review`; and so on per the table in `delivery-record.md`. The main schema picks the right sub-schema using a JSON Schema `if/then` branch on `activity_type`.

**`examples/`** — three real-looking, fully-filled-in records that double as test fixtures (the skill tests can validate against these to confirm the schema stays in sync with the prose).

### 1.2 Versioning policy

Add a `VERSIONING.md` at `spec/delivery-record/VERSIONING.md`:

- v1 is the floor. Additive, backward-compatible changes (new optional fields, new enum values in `activity_type` if and only if existing values keep working) are allowed within v1.
- Breaking changes (renamed/removed fields, changed semantics) require a `v2/` directory. The old `v1/` stays untouched so old records keep validating.
- Each version directory is self-contained. The `/delivery-record-verify` skill resolves the schema by reading the `predicate_type:` field and loading the matching subdirectory.

### 1.3 `/delivery-record` skill

Create `skills/delivery-record/` with the standard layout:

```
skills/delivery-record/
├── SKILL.md                   # Anthropic-format frontmatter + workflow
├── agents/
│   └── openai.yaml            # Codex/OpenAI interface (matches the cms-cultivator convention)
└── templates/
    ├── code.md                # Per-activity body templates (the prose scaffold)
    ├── frd.md
    ├── audit.md
    ├── discovery.md
    ├── design-handoff.md
    ├── strategy.md
    └── client-comm.md
```

**SKILL.md frontmatter** (mirrors the existing `pr-create` skill's shape):

```yaml
---
name: delivery-record
description: |
  Generate a Delivery Record for a significant AI-assisted output (PR, FRD,
  audit, discovery deliverable, design handoff, strategy doc, or client
  communication). Refuses to write without a named human reviewer and the two
  checkpoint notes. Writes to docs/delivery-records/ in a repo or to Drive in
  Claude Desktop, and indexes the result in the project's Teamwork "Delivery
  Records" notebook. Invoke at the end of a unit of work or via /delivery-record.
---
```

**Workflow (numbered, deterministic):**

1. **Detect environment**
   - In Claude Code with a PR open → default `activity_type: code`, set `subject.kind: pr`, gather PR number/sha from `gh pr view`.
   - In Claude Desktop → ask for `activity_type`; route to the matching template.
2. **Gather facts**
   - `code`: git log of the PR, CI status from CircleCI/GitHub Actions, presence of audit report files in repo, output of `evaluate-output` notes if present.
   - `frd`: Teamwork epic + child tasks (via `teamwork-integrator`), Drive doc URL, SOW hour cap if known.
   - `audit`: the audit report file path, the methodology section, the host site URL.
   - `discovery`/`strategy`/`design-handoff`: ask the user for the Drive doc URL; pull recent Teamwork comments tagged to the same epic.
   - `client-comm`: ask for the Teamwork message URL; pull the thread; pull the matching Fathom transcript if a call is referenced.
3. **Draft the record**
   - Render `templates/<activity_type>.md`, populate the front-matter with gathered facts, leave `sign_off.reviewed_by` and the two checkpoint notes blank.
   - Validate the in-progress draft against `spec/delivery-record/v1/schema.json` (catches missing required fields early).
4. **Require the human checkpoint** (curl rule)
   - Display the draft and explicitly prompt: "Who is the named reviewer? Paste the Checkpoint 1 and Checkpoint 2 notes."
   - **Refuse to proceed** if either is blank or generic ("LGTM" alone fails). Re-prompt up to twice; on the third blank input, abort with a clear error.
5. **Write the file**
   - `code`: `docs/delivery-records/PR-<n>-<slug>.md` in the current repo. If the directory doesn't exist, create it.
   - non-code: write to Drive via the Drive MCP at `/Delivery Records/YYYY-MM-DD-<slug>.md`. If the Drive MCP isn't available, abort with instructions and the draft contents.
6. **Index in Teamwork**
   - Use `teamwork-integrator` to find the project's "Delivery Records" notebook (create it if it doesn't exist — confirm with the user before creating).
   - Append a one-line entry: `YYYY-MM-DD · <activity_type> · <title> · <link>`.
7. **For code records**: amend the PR description with `Delivery Record: docs/delivery-records/PR-<n>-<slug>.md` so reviewers can find it from the PR.

**Inputs (CLI-style flags accepted in the prompt):**

- `--activity-type <type>` — skip detection
- `--pr <n>` — override PR detection
- `--ticket <key>` — set `ticket:` explicitly
- `--scope <feature|fix|chore|milestone|launch|deliverable>` — set scope
- `--reviewer <handle>` — pre-fill `reviewed_by` (still validated against blank checkpoint notes)

**Side-effect warning section** in SKILL.md: this skill writes files and posts to Teamwork. List it explicitly the way `pr-create` does.

### 1.4 Update repo-level docs

- **`README.md`** — add a row to the skills table linking to `/delivery-record`.
- **`docs/commands/delivery-record.md`** — new command page following the existing convention used for `/pr-create`, `/audit-a11y`, etc.
- **`agents-and-skills.md`** — add `delivery-record` to the workflow-specialist's skill list (it composes with `pr-create`, `teamwork-integrator`, and the audit skills).
- **`CHANGELOG.md`** — a `### Added` entry under the next version: "Delivery Record schema (v1) and `/delivery-record` skill."

### 1.5 Tests

Add `tests/test-delivery-record.bats`:

- **Spec validates against itself.** Load `spec/delivery-record/v1/schema.json` with `ajv-cli`, validate each `examples/*.md`'s front-matter — all must pass.
- **Bad records fail.** Construct three intentionally-broken front-matter blobs (wrong predicate_type, unknown activity_type, missing `sign_off.reviewed_by`); each must fail validation with a descriptive error.
- **Skill SKILL.md is well-formed.** Re-use the existing `tests/test-plugin.bats` pattern to confirm frontmatter parses and required keys exist.
- **Per-activity required keys.** For each of the seven activity types, the corresponding `checks/<type>.json` must require exactly the keys named in the prose table.

### 1.6 PR checklist for PR 1

- [ ] `spec/delivery-record/v1/schema.json` validates with `ajv-cli`.
- [ ] All seven `checks/<activity_type>.json` files exist.
- [ ] All three (or more) example records validate.
- [ ] `skills/delivery-record/SKILL.md` follows the cms-cultivator frontmatter convention; `agents/openai.yaml` mirrors it.
- [ ] `docs/commands/delivery-record.md` exists.
- [ ] `README.md` skill table updated.
- [ ] `CHANGELOG.md` entry added.
- [ ] `tests/test-delivery-record.bats` passes locally.
- [ ] Manual dry-run: run the skill in Claude Code on a real PR, confirm refuses-on-blank-checkpoint, writes the file, posts to Teamwork.
- [ ] Manual dry-run: run the skill in Claude Desktop on a non-code deliverable, confirm Drive write + Teamwork index.

---

## PR 2 — `/delivery-record-verify` skill (+ optional CI)

Ships after PR 1 has been merged and at least 3–5 real records exist in the wild.

### 2.1 The skill

Create `skills/delivery-record-verify/` with the standard layout. SKILL.md:

```yaml
---
name: delivery-record-verify
description: |
  Validate a Delivery Record file against the kanopi/delivery-record schema.
  Reads predicate_type to resolve the schema version, then enforces required
  fields, checks-value validity (pass|fail|n/a), and the per-activity_type
  required-keys policy. Invoke as /delivery-record-verify <path>.
---
```

**Workflow:**

1. Accept a file path (or auto-detect all `docs/delivery-records/*.md` if no path given).
2. Parse YAML front-matter. If `predicate_type` is missing or malformed, fail with "not a Delivery Record."
3. Resolve the schema version from `predicate_type` (e.g. `v1` → `spec/delivery-record/v1/schema.json`).
4. Validate against `schema.json` + the matching `checks/<activity_type>.json`.
5. Apply the **threshold rule** as a soft warning (not a hard fail): if any check value is `fail`, the body must contain a `## Waiver` heading; if any value is `n/a`, the body must contain a one-line justification within five lines of the front-matter. Print warnings without failing the run unless `--strict` is passed.
6. Print a structured report:
   - `✓` for each passing check
   - `✗` for hard validation failures with line/field
   - `⚠` for soft warnings
   - Final summary line: `<n> records · <m> passing · <k> failing`

### 2.2 CI helper (optional, ship behind an opt-in flag)

Add `scripts/delivery-record-verify.sh` — a thin wrapper that runs the skill over `docs/delivery-records/*.md` and exits non-zero on validation failures. Document in `docs/commands/delivery-record-verify.md` as "drop this into your CI to enforce that every PR ships a valid Delivery Record."

Do **not** enable this in cms-cultivator's own CI by default — it's a tool other projects opt into.

### 2.3 Tests

Add `tests/test-delivery-record-verify.bats`:

- Verify pass for each `examples/*.md` from PR 1.
- Verify fail for hand-crafted broken records (same fixtures from PR 1's test).
- `--strict` flag escalates soft warnings to failures.
- Auto-detect mode finds and validates all records when no path is provided.

### 2.4 PR checklist for PR 2

- [ ] Skill SKILL.md + agents/openai.yaml exist.
- [ ] `docs/commands/delivery-record-verify.md` exists.
- [ ] `scripts/delivery-record-verify.sh` is executable and documented.
- [ ] Tests pass locally.
- [ ] Manual dry-run against the records produced since PR 1 landed.

---

## Open questions to resolve before starting

1. **Predicate type identifier.** Current value in the spec page: `kanopi/delivery-record/v1`. Confirm we keep this bare-path form, or promote to a URL (`https://github.com/kanopi/cms-cultivator/blob/1.x/spec/delivery-record/v1/`) so the identifier resolves to docs. Resolution gate: whether we want external consumers (auditors, clients) to be able to fetch the schema by URL.

2. **Drive write path in Claude Desktop.** The plan assumes the Drive MCP is configured at the same place across all client projects (`/Delivery Records/`). Confirm with the team whether this folder convention is already in use, or whether the skill should ask for the folder ID per project on first run and cache it.

3. **Teamwork notebook auto-creation.** Step 6 of the write workflow creates the "Delivery Records" notebook if missing. Confirm this is a desired behavior or whether the skill should require the notebook to exist (PM-created during project setup) and fail clearly otherwise.

4. **Schema validation library inside the skill.** The skill drafts records by reading the spec at runtime; how it actually runs validation depends on environment (Node/ajv in Claude Code; Python/jsonschema if invoked via Codex). Pick the simpler path or carry both.

---

## Cross-repo coordination

- After PR 1 lands in cms-cultivator, open a follow-up issue in `kanopi/ai-workflows` to add a "the spec is canonical here" link from `/delivery-record` to the cms-cultivator spec directory, so the doc-site page becomes the human-readable face and the cms-cultivator spec becomes the machine-readable backing.
- Once the skill is in cms-cultivator's release channel, update the quick-reference table in `kanopi/ai-workflows` to reflect that `/delivery-record` is actually available (today it's listed but not yet shippable).
