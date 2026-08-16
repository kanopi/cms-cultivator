---
name: pr-review
description: >-
  Review a pull request or analyze local changes before submitting. Checks the diff
  against what the ticket asked for, then for correctness bugs, and reports only
  findings that survive a concrete failure scenario and a confidence floor. Silence is
  a valid result. Auto-activates when the user mentions reviewing a PR, asks for code
  review, wants to analyze changes before submitting, or mentions "pr-review self".
  Invoke when the user provides a PR number to review or says "review self", "review
  my changes", or "pr review". Supports focus areas: code, security, breaking,
  testing, size, performance.
---

# PR Review

Review a pull request, or your own changes before you open one. Runs directly in the
main session; no agents.

Ten plausible findings containing two fabrications is worse than two verified
findings, because the reader now has to check everything. Every mechanism below exists
to delete candidates, not to generate them.

Usage: "Review PR #123", "review my changes", optionally with a focus area.

## Workflow

### 0. Eligibility gate

Before reading anything, check whether this PR should be reviewed at all. Skip and
say which reason applies:

- Closed or merged
- Draft
- Already reviewed by you, unless there are new commits since
- Automated (dependency bumps, lockfile-only, generated files, release chores)
- Trivially mechanical: pure formatting, a rename applied uniformly, comment-only

When one applies, reply with `Skipping review:` and the reason, and stop. "Skipping
review: lockfile bump, no reviewable logic" is a complete, correct response. Do not
review something ineligible just because you were asked to, and do not pad the reply
with findings to justify the turn.

### 1. Determine target

- PR number given → review that PR
- "self" / "my changes" / "before submitting" → review local changes against the
  default branch
- Neither → ask
- Delegated context (prompt names a PR and says "delegated" or "automated routine")
  → proceed without asking

### 2. Gather context

**PR:** in parallel, `gh pr view <n> --json title,body,baseRefName,author,additions,deletions,changedFiles`,
`gh pr diff <n>`, `gh pr checks <n>`.

**Self-review:** resolve the base with
`gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`, then in parallel
`git log --oneline <base>..HEAD` and `git diff <base>...HEAD`.

**No `gh`:** ask for the description and diff, review what you were given, and say
what you could not see.

Fetch the ticket too — Kanopi PR bodies link a Teamwork task, and that link is the
spec for axis 1. With no ticket and no PR body, say so and skip axis 1 rather than
guessing at what was asked.

Size: XS <10, S 10–100, M 100–400, L 400–1,000, XL >1,000 lines. XL: suggest a split.

### 3. Review on two axes

**Axis 1 — Spec.** Does the diff do what the ticket and PR body say it does? Quote the
requirement line for each finding.

- A requirement with no implementation
- A requirement implemented partially
- A requirement implemented incorrectly: the code runs, but not what was asked
- Scope creep: changes nothing in the ticket asked for

**Axis 2 — Correctness.** Bugs, in the code the diff touched. Logic errors, unhandled
states, wrong boundaries, broken assumptions about data or lifecycle, races across
requests, security defects that are actually reachable.

Two lenses that catch what a diff-shaped reading misses:

**Blast radius.** For every selector, class, hook, filter, or config key the diff
touches, enumerate what *else* it matches before judging the change correct. Name the
other layouts, variants, templates, or content types that share it. A CMS block class
is usually shared by every variant of that block, so a rule hung on the wrapper hits
the ones the ticket never mentioned. A fix that works and quietly changes a neighbour
is still a defect, and "the targeted case looks right" is not an answer to "what else
matches this?"

**Silent failure.** A poll, retry, timeout, fallback, or `catch` that swallows its own
failure path leaves no signal when it stops working. Ask what the user or the next
developer sees when the fallback is the branch that runs. A bounded loop that expires
without a warning is a defect even when it usually succeeds.

Cleanup, convention, and style findings rank below both axes and are the first cut
when the cap binds.

### 4. Filter every candidate

Nothing reaches the reader without passing all three filters.

#### 4a. Evidence

Every finding states a concrete failure scenario: specific inputs or state leading to
a specific wrong output, crash, or data problem. "This could be fragile" is not a
scenario. A candidate that cannot be given one is **dropped, not softened** — hedging
it into a "consider" bullet is how noise gets in.

Any claim about the behavior of a contrib module, plugin, vendor library, or framework
internal must cite the `file:line` in that source that you actually opened. No
citation, no finding. Never write that you verified something you did not.

Asserting third-party behavior from memory is CANT-20, and claiming a check you did
not run is CANT-23, both in the
[Catalog of Agent Neutralization Techniques](https://github.com/kanopi/cant).

#### 4b. Confidence

Score every surviving candidate 0–100 with this rubric, and report only 80 and above:

- **0** — Not confident. A false positive that doesn't survive light scrutiny, or a
  pre-existing issue.
- **25** — Somewhat confident. Might be real, might not; you could not verify it.
- **50** — Moderately confident. Verified real, but a nitpick or rare in practice.
- **75** — Highly confident. Verified, very likely hit in practice, directly impacts
  functionality.
- **100** — Certain. Confirmed, will happen frequently, evidence directly supports it.

#### 4c. CMS false-positive exclusions

Do not report:

1. Anything PHPCS, PHPStan, Rector, ESLint, stylelint, or twig-lint catches. CI runs
   these; point at `code-standards-checker` instead
2. Issues on lines the PR did not modify
3. Pre-existing issues, including code the diff only moves
4. Missing escaping where Twig autoescape, `wp_kses_post`, or Drupal's render layer
   already escapes the value
5. Missing nonce or capability checks on read-only public front-end output
6. Missing capability checks in client-side JS — client code is untrusted by
   definition and the check belongs server-side
7. Absent tests for CSS, SCSS, or template-only changes
8. Theoretical race conditions inside a single PHP request lifecycle
9. Contrib, plugin, or vendor code the PR does not modify
10. Any assertion about third-party behavior not confirmed by reading its source
11. Generic "add caching" or "this may be slow" without naming the loop and the query
12. Accessibility findings that belong to `browser-validator`, unless the diff
    introduces the regression
13. Missing sanitization on values that never leave a trusted context
14. Restructuring suggestions for a file the PR touched incidentally

### 5. Produce the review

Report at most **8 findings**, most severe first. Correctness outranks cleanup when
the cap forces a cut.

Prefix each so required and optional are distinguishable: **Critical** (ships a bug,
security hole, or data loss), no prefix (required before merge), **Optional** (worth
doing, not blocking), **Nit** (author's discretion), **FYI** (no action wanted).

Each finding carries the prefix, a one-line claim, `file:line`, the failure scenario,
and the fix. Propose the move, not just the problem.

Write only the sections you have content for. There is no template to fill. Never
print an empty heading — "no security concerns" is a clause in the summary at most,
never a section of its own.

**If nothing scores 80 or above**, output `No issues found`, one line naming what you
checked (axes, files, and anything you could not see), and stop. Do not manufacture
suggestions to look thorough. A clean review is a real result.

Close with a recommendation — approve, request changes, or comment — reasoned, not
just a verdict. Approve when the change definitely improves code health, even if
imperfect. Apply the 5 Cs (Context, Color, Connective Tissue, Cost, Consequence) as
silent reasoning behind that call; do not write them out as prose.

### 6. Optional: post to GitHub

For a PR review, not a self-review, and only if asked: present the review, ask "Post
this as a PR review? (approve / request changes / comment)", and on approval run
`gh pr review <n> --<action> --body-file <file>`. Self-reviews stay local.

## Delegated mode (automated routines)

When invoked from a subagent prompt, behave non-interactively:

- Skip step 6 entirely — do NOT post. The parent routine posts.
- Skip all user dialogue; no user is present.
- Output ONLY the review, with no preamble.
- End with this exact sentinel on its own line, one of the three verbatim, because the
  parent parses it:
    FINAL_RECOMMENDATION: Approve
    FINAL_RECOMMENDATION: Request Changes
    FINAL_RECOMMENDATION: Comment

The filters in step 4 apply unchanged in delegated mode. An automated review that
invents findings is worse than one that returns none.

## Related Skills

- `code-standards-checker` — run before review; it owns everything in exclusion 1
- `pr-create` — create the PR after a passing self-review
- `pm-skills:qa-validation-checklist` — write the reviewer-facing validation steps
  once the review passes
- `browser-validator` — real-browser accessibility and responsive checks
