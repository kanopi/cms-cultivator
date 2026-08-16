# pr-review, from scratch: specialist agent, thin skill

Date: 2026-08-16
Repo: `kanopi/cms-cultivator`
Branch: `feat/pr-review-structure-over-rules`
Supersedes: `plans/2026-08-16-pr-review-fourth-rework.md` (kept as history)
Handoff: `plans/2026-08-16-pr-review-handoff.md`

## Design rule

Build the skill as it would be built today, with no history. Carry from the
legacy design only what measurement paid for. Every carried item below names
its evidence; anything without evidence was not carried.

## Architecture

Three files replace the current monolith, following this repo's own pattern:
agents orchestrate, skills guide.

1. **`agents/pr-review-specialist/AGENT.md`** (new, ~40 lines). A leaf agent
   that reviews a diff in a fresh context. The properties the current skill
   enforces through prose become frontmatter declarations:
   - `model: sonnet` (user decision: pin the spawned reviewer to sonnet)
   - `tools: Read, Glob, Grep, Bash` with a body rule that all git and gh use
     is read-only; never mutate the working tree, index, HEAD, or branches
   - `skills: pr-review` so the agent loads the output contract
   - Never spawns another agent
   Constraint 5 (fresh context for self-review) is now implemented by the
   registry instead of obeyed by a prompt.

2. **`skills/pr-review/SKILL.md`** (rewritten, target ~100 lines). The single
   source of truth for the output contract, workflow, and filters. The
   self-review step becomes one line:
   `Task(cms-cultivator:pr-review-specialist:pr-review-specialist, prompt=...)`
   plus one fallback line for hosts without agents (Claude Desktop, Codex,
   sandboxed evals): review in-session, same contract.

3. **`skills/pr-review/references/posted-format.md`** (new, ~30 lines). The
   posted-body wrapper, loaded only at the posting step.

## Output contract (the skill's core)

The worked example remains the spec, in the current shape:

- One verdict line, findings most severe first, one closing `Unverified:`
  line. Nothing outside these slots.
- Per finding: bold one-line headline, `File:`, `Apply:` (when different),
  `Issue:` (the input or state, then the wrong result), `Fix:` (a
  ```suggestion``` block or one named action).
- Severities `Critical` / `Important` / `Minor` (constraint 2).
- No praise, no Strengths, no verified lists (constraint 3).
- The `Unverified:` line carries what could not be checked, including shared
  carriers (selectors, classes, hooks, config keys) the diff touches that the
  reviewer could not clear. This is the legal slot for uncleared blast
  radius; it satisfies acceptance criterion 4 without a fabricated finding.

No word limits at any granularity and no finding-count caps (user decision,
twice; adversarial review showed caps leak pressure into severity labels).
Length is bounded by selectivity and containment only.

## Mechanism change: verify votes replace the confidence score

The 0-100 self-scored confidence with an 80 floor is dropped. A model grading
its own certainty is pseudo-precision. Replacement, taken from the built-in
code-review skill:

After drafting, re-read each finding against the file and assign one of:

- **CONFIRMED**: can name the inputs or state that trigger it and the wrong
  result. Quote the line.
- **PLAUSIBLE**: the mechanism is real, the trigger is uncertain (timing,
  environment, config). State what would confirm it.
- **REFUTED**: factually wrong or guarded elsewhere. Quote the line that
  proves it.

Report CONFIRMED findings, and PLAUSIBLE findings with their trigger stated.
Drop REFUTED. This keeps the verify-before-post step that caught the
fabricated `use`-statement claim, and makes the filter checkable (a quoted
line) instead of self-reported (a number).

## Carried from legacy, with evidence

| Item | Evidence |
|---|---|
| The 7 handoff constraints, unchanged | decided |
| `File:` / `Apply:` two locations | wrong anchors 2 of 6 before, 0 of 3 after |
| Gate list (closed, merged, draft, automated, mechanical) | decided |
| Exclusions: tooling-caught, unmodified lines, pre-existing, unread third-party | each fired on a real PR |
| "Never claim a check you ran only in your head" | the `use`-after-`return` fabrication on #58 |
| Blast-radius and silent-failure lenses | found the #310 poll expiry and #58 table gap |
| Spec axis: Teamwork link, then PR body, else say so in one line | constraint 4 |
| Delegated mode contract and sentinel, verbatim | constraint 1; external parser |
| Silence is a valid result; `No issues found` plus one coverage line | decided in 2.2.0 rework |

Carried user decisions (2026-08-16): wrapper on posted reviews including
delegated output, Recommendation checkboxes, sonnet pin, no word limits.

Carried from the adversarial review of the fourth-rework plan:

- Lenses direct investigation, never output; the two directives that rewarded
  leaking ("owes a named answer", criterion-4 pressure) are gone.
- Delegated anchor bug fixed: the parent anchors at `Apply:`, falling back to
  `File:` (current text says `File:`, which measurement showed is wrong).
- Checkbox, review `event`, and sentinel derive from one recommendation.
- No 60-character headline bound, no Minor cap (re-skinned caps).

New lenses and lines from the reference mining (fourth-rework plan, section
"Mined from the references", unchanged): removed-behavior lens, anti-padding
line, enclosing-function scope, fail-fast diff check before spawning,
approval standard and selectivity as single lines.

## Not carried from legacy

- The 0-100 confidence rubric and 80 floor (replaced by verify votes).
- The 8-finding cap (a count limit; selectivity and severity ordering bound
  the list).
- Every sentence that argues, jokes, or persuades. The register offenders
  named in the handoff (`:14`, `:55`, `:108`, `:122`, `:145`) and their flat
  replacements are listed in the superseded plan and apply here.
- The one-seat rationale paragraphs (now one line: "Never spawn a second
  reviewer"; the agent frontmatter enforces the rest).

## Posted-body wrapper (`references/posted-format.md`)

```markdown
## AI Code Review

**Recommendation**
- [ ] Approve
- [x] Request Changes
- [ ] Comment

<verdict line>

### Changes Requested
<Critical and Important findings>

### Suggestions
<Minor findings>

Unverified: <line, when present>
```

Anchored findings post as inline comments carrying the full template and
suggestion block; the body lists each as one line (headline plus `File:`)
under its section. Unanchored findings appear in full in the body. Empty
sections are omitted. Self output never carries the wrapper.

## Work plan

1. Write `agents/pr-review-specialist/AGENT.md`.
2. Rewrite `skills/pr-review/SKILL.md` against the contract above.
3. Write `skills/pr-review/references/posted-format.md`.
4. Register the new agent: Codex TOML in `.codex/agents/`, row in
   `docs/agents-and-skills.md`, roster entry in the top-level `README.md`.
5. Update `docs/commands/pr-workflow.md` and the `[Unreleased]` CHANGELOG
   entry (skill rework and new agent).
6. Run all gates:
   `./scripts/validate-frontmatter.sh`, `node scripts/run-evals.js
   --min-rank1 75`, `bats tests/`, `./scripts/check-codex-parity.sh`,
   `./scripts/run-behavioral-evals.sh --case pr-review--findings-are-actionable`.
   The skill description keeps its trigger phrases so routing evals hold.
7. Fixture runs from the handoff's worktrees (#58, #60, spokaneairport#310
   at `8624cee`), with `Agent` allowlisted. A run counts only if the
   transcript shows the specialist agent invoked with sonnet; the fallback
   substitutes silently otherwise.
8. Report measured prose word counts per fixture against the 251-472
   baseline. Reported, not gated.
9. Posting-path exercise: post one new-format review on cms-cultivator#58
   through the real step 6 (user confirms before the `gh` call). Dismiss the
   two stale reviews on #58 and #60 with a one-line note (submitted reviews
   cannot be deleted; user confirms first).

## Acceptance criteria

1. Zero sentences outside a labeled slot in every fixture review.
2. Every finding carries a `Fix:` that is code or a named concrete action.
3. Zero unverified claims about language semantics, vendor APIs, or dates.
4. #310 surfaces the silent poll expiry (finding) and the containment blast
   radius (finding or `Unverified:` line).
5. A reader who has not seen the diff can state what to change from the
   review alone. Human judged.

## Risks

- The behavioral eval harness rejects `Agent` by design; the spawn path's
  only coverage is the manual fixture runs with the transcript assertion.
- Whether sonnet finds the #310 poll expiry is demonstrated by one manual
  run. If it misses, the decision (keep sonnet or inherit) returns to the
  user with the measured output.
- Agent frontmatter cannot scope Bash to read-only commands; the read-only
  rule stays a body instruction, the one place prose still enforces a
  property.

## Out of scope

- The behavioral eval harness
- Other skills
