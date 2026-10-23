# pr-review, fourth rework: containment over caps

Date: 2026-08-16 (revised same day after adversarial agent review)
Repo: `kanopi/cms-cultivator`
Branch: `feat/pr-review-structure-over-rules` (continues the uncommitted work)
Prior plan: `plans/2026-08-16-pr-review-third-rework.md`
Handoff: `plans/2026-08-16-pr-review-handoff.md`

## Goal

Unchanged: reviews short enough that a human reads all of it, specific enough
that a human or agent makes the fix without a follow-up question. Direct
language in the reviews and in the skill file itself.

## Decisions made with the user (2026-08-16)

1. **Wrapper scope: posted reviews.** Self output stays bare (verdict,
   findings, `Unverified:`). Any review destined for posting carries the
   #315-style wrapper: an "AI Code Review" title, Recommendation checkboxes,
   a `Changes Requested` section (Critical and Important), a `Suggestions`
   section (Minor). Delegated reviews are posted by the parent, so delegated
   output is wrapped too; only self output is bare.
2. **Recommendation checkboxes: keep**, in the posted body only. The checked
   box, the GitHub review `event`, and (in delegated mode) the
   `FINAL_RECOMMENDATION` sentinel all derive from one recommendation; the
   skill states this so they cannot drift.
3. **Spawned reviewer: pin to sonnet** (`model: "sonnet"` on the Agent call).
4. **No word limits at any granularity.** Not per review, not per finding,
   not per field, not in characters. Every prior word-limiting instrument
   produced jargon or was ignored. Length is controlled by selectivity (the
   filters decide how many findings exist) and by containment (slots decide
   where words may exist), never by compression.

## Length: containment and selectivity, no numbers

Diagnosis, stated with its limits: the #310 review ran 472 words for one
finding; the template accounts for roughly 85. The review text itself is not
in the repo, so the split is an estimate, not an artifact. Two candidate
causes, both addressed:

- The blast-radius lens said each question "owes a named answer"
  (SKILL.md:86) and the model printed the answers.
- Acceptance criterion 4 demands #310 surface the containment blast radius,
  but the evidence filter forbids it as a finding (no constructible failure),
  so the only way to satisfy the criterion was to leak it as prose.

Mechanisms:

- **Slots are the whole output.** Every sentence lives in a labeled slot:
  the verdict line, a finding field, or the `Unverified:` line. This rule
  exists today (SKILL.md:68-69) and was violated; what changes is removing
  the two directives above that rewarded violating it.
- **Lenses direct investigation, not output.** Blast radius, silent failure,
  and the new removed-behavior lens each get two lines: what to investigate,
  what a candidate looks like. Their answers reach the output only as
  findings that survive the filters, with one exception below.
- **The `Unverified:` line is the legal slot for uncleared blast radius.**
  Shared selectors, classes, hooks, or config carriers the diff touches that
  the reviewer could not clear are named there in one line. That is what the
  line means (not confirmed), it satisfies criterion 4 without a fabricated
  finding, and it removes the leak incentive.
- **No headline character bound.** Considered (the built-in skill uses 60
  chars) and rejected by the adversarial review: a character bound is the
  attempt-2 hard cap re-skinned, and compression lands on the field every
  reader sees first. The existing instruments stay: bold one-line headline,
  plain words, no shorthand the author would have to ask about.
- **No Minor cap.** Considered (cap at 3) and rejected: a cap leaks pressure
  into severity labels, promoting a fourth Minor to Important or demoting an
  Important to escape the budget. Minor findings are bounded by the filters
  like everything else.

## Acceptance criteria (revised)

Criterion 1 is replaced; word thresholds are a mechanism the user has
rejected twice. The rest carry over from the third-rework plan.

1. **Zero sentences outside a labeled slot** in every fixture review. Word
   counts per fixture are measured and reported for trend against the
   251-472 baseline, but not gated.
2. Every finding carries a `Fix:` that is code or a named concrete action.
3. Zero unverified claims about language semantics, vendor APIs, or dates.
4. #310 surfaces the silent poll expiry (as a finding) and the containment
   blast radius (finding or `Unverified:` line).
5. A reader who has not seen the diff can state what to change from the
   review alone. Human judged; this is the readability gate.

## Mined from the references

### Claude Code built-in code-review (extracted from binary 2.1.233)

Adopt:

- **Removed-behavior lens.** For every line the diff deletes or replaces,
  name the invariant it enforced, then find where the new code re-establishes
  it. A missing re-establishment is a candidate. No current lens catches a
  dropped guard.
- **Anti-padding line**: "if fewer genuine findings exist, report what you
  have; do not invent to hit a count."
- **Enclosing-function scope.** Bugs in unchanged lines of a touched function
  are in scope; the diff re-exposes them. Refines the "lines the PR did not
  modify" exclusion.
- **"Quote the line" evidence phrasing** for claims about existing code.

Reject:

- Effort tiers and multi-agent finder fan-out (one-seat rule, cost).
- Finding floors such as `min(files_changed, 4)` (floors manufacture
  findings).
- The 60-character headline bound (see Length section).
- Its Fix-less one-line finding format (criterion 2 requires a Fix).

### mattpocock/skills (code-review)

Adopt:

- **Fail fast before spawning.** Resolve the base ref and confirm the diff is
  non-empty before the Agent call.

Reject:

- The 12-smell Fowler baseline (outside correctness scope, ~40 lines).
- Two parallel subagents per review (cost, one seat).
- "Under 400 words" budgets (word limits, rejected).

### addyosmani/agent-skills (code-review-and-quality)

Adopt, as single lines:

- Selectivity: one structural problem outranks ten nits.
- Approval standard: approve when the change improves code health, even if
  imperfect.

Reject:

- Everything else: checklists, sizing tables, dependency discipline,
  rationalization tables. Checklist machinery is satisfied by writing more.
  Its five-prefix severity set conflicts with constraint 2.

### obra/superpowers (re-read)

Adopt:

- **Read-only spawned reviewer**: one line in the Agent prompt forbidding
  mutation of the working tree, index, HEAD, or branch state.

Reject (re-affirmed): praise mandate, Strengths section, Recommendations
section.

## SKILL.md rewrite

### Register fixes (handoff problem 1)

Rewrite every line that editorializes:

- `:14` "Ten plausible findings containing two fabrications..." -> "Report
  only what survives verification. A fabricated finding forces the reader to
  re-check everything."
- `:55` "not the reader's problem" -> "State the failure, not the
  derivation."
- `:108` "the worst possible reader" -> "The author's context hides the bug.
  Use a fresh one."
- `:122` "One review seat... counts for nothing" -> "Never spawn a second
  reviewer."
- `:145` "learned to dress itself" -> "No verified list, whatever the
  heading."

Then a full pass: any sentence that argues, jokes, or persuades becomes an
instruction or is deleted.

### Line budget (handoff problem 2)

Current file: 166 lines. Additions: removed-behavior lens (+3), anti-padding
and scope lines (+2), approval and selectivity lines (+2), spawn precheck,
read-only, and model lines (+3), Unverified blast-radius definition (+2),
checkbox derivation line (+1). Total roughly +13.

Cuts, sized: example meta-commentary at lines 52-69 (18 -> 6), self-review
rationale at 105-124 (20 -> 10), filter overlap (12 -> 7), Don't list entries
not traced to an observed defect (6 -> 3), delegated-mode prose (10 -> 7),
Related Skills (6 -> 4). Total roughly -35.

The posted-body wrapper spec (about 25 lines with its template) moves to
`skills/pr-review/references/posted-format.md`, loaded only at the posting
step. SKILL.md step 6 references it in one line. Projected SKILL.md size:
166 + 13 - 35 = ~144 without the wrapper in-file. Under 120 requires the
full editorial pass to find another ~25 lines; if it cannot without losing a
defect-traced rule, report the landing size honestly rather than cutting a
rule to hit a number.

### Content changes

1. Worked example: keep the current one, tighten only its register.
2. Three lenses, two lines each, answers-stay-out wording, blast-radius
   remainder routed to `Unverified:`.
3. Filters: anti-padding line, enclosing-function refinement, confidence
   floor 80 kept as one line. No caps.
4. Delegated mode: sentinel verbatim (constraint 1). Fix the anchor bug:
   the parent anchors at `Apply:`, falling back to `File:`; the current text
   says `File:` (SKILL.md:153-154), which measurement showed produces wrong
   anchors (handoff, 2 of 6 before `Apply:`). Delegated output is wrapped
   (decision 1).
5. Spawn block: `model: "sonnet"`, read-only line, fail-fast precheck.
6. Step 6 posting: one-line pointer to `references/posted-format.md`.

### Posted-body wrapper (references/posted-format.md)

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

The checked box matches the review `event` and, in delegated mode, the
sentinel; all three derive from the one recommendation. Findings anchored to
a diff line post as inline comments carrying the full template and suggestion
block; the body lists each as one line (headline plus `File:`) under its
section so the body scans even when every finding is anchored. Findings with
no anchor appear in full in the body. Empty sections are omitted. Self output
never carries the wrapper, so fixture word counts are comparable to baseline.

## Verification

Gates, all must pass:

```bash
./scripts/validate-frontmatter.sh
node scripts/run-evals.js --min-rank1 75
bats tests/
./scripts/check-codex-parity.sh
./scripts/run-behavioral-evals.sh --case pr-review--findings-are-actionable
```

Fixtures, per the handoff's worktree commands, with `Agent` in
`--allowedTools`:

- kanopi/cms-cultivator#58 (worktree at `pr58-head`)
- kanopi/cms-cultivator#60 (worktree at `771935b`)
- kanopi/spokaneairport#310 (worktree at `8624cee`)

**Spawn assertion**: a fixture run counts only if its transcript shows the
Agent tool call with `model: "sonnet"`. The fallback substitutes silently
when `Agent` is missing from `--allowedTools` (handoff gotcha), and criterion
4 must be demonstrated on the model that will actually run, not on the
parent's stronger model.

Report measured prose word counts per fixture against the 251-472 baseline.

**Posting path**: exercised for real, not left untested. After fixtures pass,
post one new-format review on kanopi/cms-cultivator#58 through step 6 (user
confirms before the `gh` call). This validates the wrapper, the inline
anchors, and the section mapping on the one surface no fixture covers.

## Cleanup and registration

- Update `docs/commands/pr-workflow.md` to match.
- Update the `[Unreleased]` CHANGELOG entry.
- Stale reviews on #58 and #60: submitted GitHub reviews cannot be deleted,
  only dismissed. Dismiss both with a one-line note pointing at the
  replacement review (user confirms first). The #58 replacement is the
  posting-path exercise above; #60 gets one only if the user wants it.

## Known limitations carried forward

- The behavioral eval harness rejects `Agent` by design, so the spawn path
  has no automated test. The manual fixture runs with the spawn assertion
  above are the coverage. Changing the harness stays out of scope.
- Whether sonnet finds the #310 poll expiry is demonstrated by one manual
  run, not a repeatable test. If it misses, the fallback decision (keep
  sonnet, raise to inherit) returns to the user with the measured output.

## Out of scope

- The behavioral eval harness itself
- Other skills
- Converting pr-review into a standing subagent
