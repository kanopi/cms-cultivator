---
name: pr-review
description: >-
  Review a pull request or analyze local changes before submitting. Checks the diff against what
  the ticket asked for, then for correctness bugs, and reports only findings that survive a
  concrete failure scenario and verification against the file. Findings post as inline
  suggestions, and silence is a valid result. Invoke when the user gives a PR number, asks for a
  code review, wants changes analyzed before submitting, or says "pr review", "review self",
  "review my changes", or "pr-review self". Focus areas: code, security, breaking, testing, size,
  performance.
---

# PR Review

Report only findings that survive verification. A fabricated finding forces the reader to
re-check everything. Usage: "Review PR #123", "review my changes".

## Output

Copy this shape in every mode. Delivery is decided in step 6 and never changes what you write.

````markdown
Request changes. The overflow rule clips two card variants the ticket never mentions, and the
alert dismissal reads an option name nothing writes.

**Critical: the dismissal expiry is read from an option nothing writes**
- File: `inc/class-alerts.php:88`
- Issue: The save path writes `alert_dismissed_until`, so this read always falls back to 0 and the alert never stays dismissed.
- Fix:
```suggestion
	$until = (int) get_option( 'alert_dismissed_until', 0 );
```

**Important: `.card` overflow clips every card variant**
- File: `css/blocks.css:31`
- Issue: `.card--profile` and `.card--stat` hang their badge outside the box; this rule cuts it off.
- Fix:
```suggestion
.card--event { overflow: hidden; }
```

**Minor: `card--event` is missing from the variant table**
- File: `css/blocks.css:31`
- Apply: `docs/components/cards.md` (not in this diff)
- Issue: The table is how the next developer finds a variant, so an absent one gets rebuilt by hand.
- Fix: Add a `card--event` row beside the existing `card--profile` row.

Unverified: the 781px stacking, since no browser ran here.
````

Rules for the shape:

- A review is three parts: one verdict line, findings most severe first, one closing
  `Unverified:` line. Every sentence lives in one of these slots. A sentence with no slot is
  deleted, not relocated.
- Each label holds one line. `Issue:` is one short sentence: the input or state, then the wrong
  result. Write "the last pass reads `$posts[3]` of a 3-item array and fatals on null", not
  "`count()` is a valid index only up to `count() - 1`, so the loop runs one pass too many and
  reads an undefined offset, throwing a fatal whenever posts exist". The proof stays in your
  head; the `Fix:` carries the mechanism.
- Severity: `Critical` ships a bug, security hole, or data loss. `Important` blocks the merge.
  `Minor` is the author's call. Approve when the change improves code health, even if imperfect.
- `File:` is where the problem shows, on every finding. `Apply:` is where the change goes,
  omitted when that is the same line.
- `Fix:` is a ```suggestion``` block replacing exactly the `Apply:` line (or the `File:` line
  when there is no `Apply:`), or one named concrete action. No line to replace, no block.
- `Unverified:` names what could not be checked, including shared selectors, classes, hooks, or
  config keys the diff touches that you could not clear.

## Workflow

1. **Gate.** Closed, merged, draft, already reviewed with no new commits, automated (dependency
   bumps, lockfiles, generated files), or purely mechanical (formatting, a uniform rename,
   comments only): reply `Skipping review:` with the reason and stop.
2. **Target.** A PR number: review that PR in this session. "self" or "my changes": spawn the
   specialist (below). A prompt naming a base and head: you are the spawned specialist or an
   automated routine, so review that diff here, with no dialogue, and never spawn. None of
   these: ask.
3. **Context.** In parallel: `gh pr view <n> --json title,body,baseRefName,changedFiles`,
   `gh pr diff <n>`, `gh pr checks <n>`, and `gh issue view <n>` for any issue the PR or its
   commits reference. Local diff: against the default branch, plus uncommitted changes. No
   `gh`: ask for the diff and say what you could not see. Over 1,000 lines: suggest a split.
4. **Spec axis.** Follow the Teamwork link in the PR body, then a GitHub issue the PR or its
   commits reference, then the PR body. Quote the requirement line for each spec finding.
   When none of these carries requirements, say so in one line and skip this axis. Never
   invent a requirement.
5. **Correctness axis.** Bugs in the changed lines and in the unchanged lines of any function
   the diff touches. Three lenses direct the investigation. Their answers reach the output only
   as findings that survive step 6, or on the `Unverified:` line, never as narration.
   - **Blast radius.** For every selector, class, hook, filter, or config key the diff touches,
     search the theme, plugin, and content for the other things carrying it.
   - **Silent failure.** For every poll, retry, timeout, fallback, or `catch`, find the branch
     that runs when it gives up and what that branch logs. A bounded loop that expires without
     a warning is a defect.
   - **Removed behavior.** For every line the diff deletes or replaces, name the invariant it
     enforced, then find where the new code re-establishes it. Nowhere is a candidate.
6. **Verify, then deliver.** Re-read each finding against the file and vote:
   - **CONFIRMED**: you can name the inputs or state that trigger it and the wrong result.
     Quote the line.
   - **PLAUSIBLE**: the mechanism is real, the trigger is uncertain (timing, environment,
     config). State what would confirm it in the `Issue:` line.
   - **REFUTED**: factually wrong or guarded elsewhere. Quote the line that proves it, then
     drop the finding.

   Report CONFIRMED and PLAUSIBLE findings only. Read every ```suggestion``` block as the
   literal replacement for its `Apply:` line. Then check each finding's form: `Issue:` holds
   exactly one sentence; a second sentence, a worked instance, or a restated rule gets deleted
   here, not shipped. If nothing survives, the whole review is two lines, `No issues found`
   and one sentence naming the axes and files covered, plus `Unverified:` when needed.
   Nothing before them, no list of what checked out. Report what you have; never invent a
   finding to hit a count.

   Delivery: a self-review returns the bare review and nothing is posted. For a PR, ask "Post
   this review?", format the body per `references/posted-format.md`, and post in one
   `gh api repos/{owner}/{repo}/pulls/<n>/reviews` call with `event: COMMENT`, `body`, and a
   `comments` array of `{path, line, body}`. Always `COMMENT`: the review posts as whoever ran
   the skill, often an automated routine, and an approve or request-changes event from that
   account gates the PR on that person re-reviewing. The Recommendation checkboxes carry the
   verdict instead. Use another event only when the user explicitly asks for it. Anchor each
   finding at its `Apply:` line, or `File:` when there is no `Apply:`; findings whose anchor is
   not in the diff stay in the body.

## Filters

Do not report: anything PHPCS, PHPStan, Rector, ESLint, stylelint, or twig-lint catches (point
at `code-standards-checker`); pre-existing issues in code the diff does not touch, including
code it only moves; third-party behavior you did not confirm by reading it. Any claim about a
contrib module, plugin, vendor library, or framework internal quotes the `file:line` you read.
Never claim a check you ran only in your head; `php -l` accepts `use` after `return`. One
structural problem outranks ten nits.

No praise, no Strengths section, and no list of what you verified, whatever the heading. No
empty headings. No shorthand the author would have to ask about. No CANT ids, eval-case names,
model names, or token costs in an author-facing review.

## Self-review

The author's context hides the bug. Use a fresh one. Confirm the base ref resolves and the
diff is non-empty (`git rev-parse`, `git diff --stat`); an empty diff means there is nothing
to review, so say that and stop. Then:

```
Task(cms-cultivator:pr-review-specialist:pr-review-specialist,
     prompt="Review the local diff. Base: <default-branch>. Head: HEAD, plus uncommitted
             changes. Working directory: <cwd>. Output only the bare review.")
```

Print what returns verbatim and stop: no preface, no edits, no commentary after it. Where
agents do not exist (Claude Desktop, Codex, sandboxed evals), say so in one line and review in
this session; the output is identical. Never spawn a second reviewer, and a spawned reviewer
never spawns.

## Delegated mode (automated routines)

When the prompt names a target and says "delegated" or "automated routine": no dialogue, no
preamble, never spawn. Output the review formatted per `references/posted-format.md`; the
parent posts it, anchoring each finding at its `Apply:` line, or `File:` when there is no
`Apply:`. The checked Recommendation box must match the sentinel. End with one of these
verbatim, on its own line, because the parent parses it:

    FINAL_RECOMMENDATION: Approve
    FINAL_RECOMMENDATION: Request Changes
    FINAL_RECOMMENDATION: Comment

## Related skills

`code-standards-checker` runs before review and owns the tooling exclusion. `pr-create` opens
the PR after a passing self-review. `pm-skills:qa-validation-checklist` writes the
reviewer-facing steps once it passes. `browser-validator` does the real-browser accessibility
and responsive checks.
