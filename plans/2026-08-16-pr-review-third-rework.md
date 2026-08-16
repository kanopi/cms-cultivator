# pr-review, third rework: structure over rules

Date: 2026-08-16
Repo: `kanopi/cms-cultivator`

## Problem

`pr-review` was reworked three times on 2026-08-16. Each attempt fixed the stated
complaint and introduced a new one.

| Attempt | Fixed | Broke | Measured |
|---|---|---|---|
| 2.2.0 rework (#64) | Fabricated findings, empty sections | Nothing bounded length | 750 words for 3 findings |
| Hard word caps | Length | Compression produced jargon: "the builder style", "the chain", "migrators" | 190 words, unreadable |
| Targets + show-the-code | Jargon, missing fixes | Length returned; target ignored | 640 words against a 250 target |

Reader verdict on attempt 3: "You're right back into prose, comments and jargon again.
This got much worse."

A fourth round of rule-tuning is not indicated.

## Root cause

The skill is 209 lines carrying 16 separate directives: an evidence rule, a confidence
rubric, a fourteen-item exclusion list, blast-radius and silent-failure lenses, length
targets, show-the-code, a plain-language table, no-praise, a closing-line cap, and a
delegated-mode contract.

**Every one of those directives is satisfied by writing more.** There is no directive
whose compliance is demonstrated by writing less. Adding a rule to reduce output is
self-defeating when rules are the output mechanism.

Attempt 2 proved the point from the other side: a hard word cap did reduce length, and
the model bought those words back by compressing meaning into shorthand. The words went
down; the comprehension went down further.

## What obra/superpowers does differently

Reference: `skills/requesting-code-review/code-reviewer.md`.

1. **A per-issue micro-template with field labels, not prose.** Each issue is four
   lines: bold headline, `File:`, `Issue:`, `Fix:`. Labels make padding structurally
   awkward — there is nowhere to put a subordinate clause. Roughly 20 words per issue.
2. **A worked example that is the real contract.** Their example output runs about 150
   words for three issues. Ours has an example too, but it sits beneath 100 lines of
   prose rules, and the rules win.
3. **Far fewer directives.** No confidence rubric, no exclusion list, no evidence rule.
   Discipline comes from a ten-line DO/DON'T list, including "Give feedback on code you
   didn't actually read" as a single DON'T.
4. **The caller supplies the spec.** It is a subagent prompt with `[PLAN_OR_REQUIREMENTS]`
   and `[BASE_SHA]`/`[HEAD_SHA]` placeholders, so the reviewer never guesses at what the
   change was supposed to do. Our skill infers the spec from a Teamwork link.

Note the direct contradiction with our current skill: **they mandate praise**
("Acknowledge what was done well before listing issues — accurate praise helps the
implementer trust the rest of the feedback"). We ban it. Their reasoning is about trust
calibration, not politeness, and deserves a real answer rather than a reflex.

## Decisions to make

### D1. Replace prose rules with a labeled micro-template

Recommended. Each finding becomes:

```
**<headline: what is wrong, plain language>**
- File: `path:line`
- Issue: <one sentence — what breaks, for whom>
- Fix: <one sentence, or a fenced code block>
```

The label is the constraint. `Issue:` followed by three sentences reads visibly wrong
in a way that a word budget does not.

### D2. The worked example moves to the top and gets treated as the spec

Recommended. A complete example review, at target length, placed before the rules. The
rules that survive get stated as short DO/DON'T lines beneath it.

### D3. Cut the directive count

Recommended. Candidates to keep, because each traces to a real defect this repo
observed:

- Evidence rule — killed the two false claims on spokaneairport#310
- "Never claim a check you did not run" — the `use`-statement fabrication on #58
- Exclusion 1 (tooling already catches it) and 2/3 (unmodified and pre-existing lines)
- Eligibility gate

Candidates to cut or compress into single DON'T lines: the 14-item exclusion list down
to the four that have actually fired, the confidence rubric (keep the 80 floor, drop
the five-level prose), blast-radius and silent-failure lenses (fold into the DO list as
two bullets), the plain-language table, the closing-line cap.

Target: under 120 lines, from 209.

### D4. Strengths section — DECIDED: none

No Strengths section, in any form. The reader's complaint is words, and praise is words
that carry no action. Superpowers' trust-calibration argument is noted and rejected for
this repo: the reviewer's credibility comes from findings that survive verification, not
from balancing them with compliments.

### D5. Delivery — DECIDED: inline suggestion blocks

Findings post as inline comments on the changed line, each carrying a
```suggestion``` block the author commits with one click. This is the structural fix the
prose rules kept failing to achieve:

- Location prose disappears. The comment is already attached to the line
- "What to change" cannot be vague, because the block must contain the literal
  replacement text for those lines
- The reader's effort drops from "read, navigate, interpret, edit" to "read, click"

Mechanics: `gh api repos/{owner}/{repo}/pulls/{n}/comments` with `path`, `line`, and
`body`, or a single `gh api ... /reviews` call carrying a `comments` array. The review
body itself shrinks to a one-line verdict plus anything with no line to attach to
(missing registration rows, absent eval cases, process gaps).

Constraint to respect: a suggestion block only works on lines present in the diff. A
finding about a file the PR never touched has no anchor and belongs in the body.

### D6. Spec source — DECIDED: keep inferring, state when absent

Try the Teamwork link, then the PR body. When neither carries requirements, say so in
one line and skip the axis. Do not invent requirements, and do not require the caller to
supply them.

Both PRs reviewed on 2026-08-16 had no ticket, so this path is the common one, not the
exception.

### D7. Severity — DECIDED: three levels

`Critical` / `Important` / `Minor`, matching superpowers. Five levels gave the model
more to deliberate over and the reader more to decode. Three buckets, and the
distinction that matters — does this block the merge — is carried by the verdict line,
not by the prefix.

## Acceptance criteria

Measurable, unlike last time. Re-run against the three fixtures we now have history for:
kanopi/cms-cultivator#58, #60, and kanopi/spokaneairport#310 at commit `8624cee`.

1. Every review under 250 words of prose, code blocks excluded, with no exceptions
   clause
2. Every finding carries a `Fix:` that is code or a named concrete action
3. Zero unverified claims about language semantics, vendor APIs, or release dates — the
   `use`-statement class of error
4. #310 still surfaces the silent poll expiry and the containment blast radius
5. A reader who has not seen the diff can state what to change from the review alone

Criterion 5 is the one that matters and the one no automated check covers. It needs a
human read before merge.

## Evidence to preserve

Three defects found today by re-running reviews, all real, none found by CI:

- `#58` — `drupal-rector-update` missing from the 26-row table in
  `docs/commands/overview.md`; no check covers that table
- `#58` — CLAUDE.md requires gate and pressure eval cases for side-effect skills;
  the PR omits them, and `composer-patch-generator` omitted them earlier
- `#60` — the behavioral eval case cannot run the commands it grades, because
  `BASE_ALLOWED_TOOLS` lacks `git ls-remote` and `git worktree list`

Also: verifying the review before posting caught a fabricated claim on its way to a
colleague's PR (`use` after `return` asserted as a syntax error; `php -l` says
otherwise). **Verify-before-post is part of the workflow, not an optional step**, and
the skill should say so.

## Out of scope

- The other skills reworked today
- The behavioral eval harness itself
- Whether `pr-review` should become a subagent (that is D6, and it is a bigger change
  than this plan should carry)
