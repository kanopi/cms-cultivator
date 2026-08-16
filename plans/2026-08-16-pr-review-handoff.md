# pr-review handoff: current state

Date: 2026-08-16
Repo: `kanopi/cms-cultivator`
Branch: `feat/pr-review-structure-over-rules` (branched off `main`)

**The work on this branch is uncommitted.** Read the working tree, not the log. Prior
attempts are in the log: `47944a6`, `090b218`, `e0a807d` (the last two on
`feat/pr-review-word-caps`, unmerged). `plans/2026-08-16-pr-review-third-rework.md` is the
plan this branch implements.

## Goal

Concise, actionable code reviews. Short enough that a human reads all of it, specific
enough that a human or an agent can make the fix without asking a follow-up question.

No prose, no jargon, no literary flourish. Direct language.

## Uncommitted changes

| File | State |
|---|---|
| `skills/pr-review/SKILL.md` | rewritten, 166 lines (was 209) |
| `docs/commands/pr-workflow.md` | modified to match |
| `CHANGELOG.md` | `[Unreleased]` entry added |
| `evals/cases/pr-review--findings-are-actionable.json` | new |
| `evals/fixtures/wp-plugin-buggy-change/` | new, ported from `feat/pr-review-word-caps` |

## Current output format

Every finding, in every mode:

```
**Important: `phpunit: TRUE` has nothing left to act on**
- File: `assets/rector.php:36`
- Apply: `evals/cases/` (not in this diff)
- Issue: <one line: the input or state, then the wrong result>
- Fix: <a ```suggestion block, or one named action>
```

A review is three parts: a one-line verdict, the findings, and a closing `Unverified:`
line. `File:` is where the problem shows. `Apply:` is where the change goes, omitted when
it is the same line. Inline comments anchor at `Apply:` because that is the line GitHub
applies a suggestion to.

## Constraints that must hold

These are decided. Do not relitigate without asking.

1. Delegated mode, and its `FINAL_RECOMMENDATION: Approve|Request Changes|Comment`
   sentinel on its own line. An automated routine parses that line verbatim.
2. Three severities: `Critical` / `Important` / `Minor`.
3. No Strengths section, no praise, in any form. This includes "what I verified" lists.
4. Spec axis infers from the Teamwork ticket, then the PR body. When neither exists, say
   so in one line and skip the axis. Never invent a requirement.
5. `/pr-review self` hands the diff to a fresh subagent, because whoever asks just wrote
   the code. Falls back to in-session where `Agent()` does not exist.
6. Two locations per finding (`File:` / `Apply:`), decided after measuring wrong anchors.
7. Never claim a check you did not run. Any claim about contrib, plugin, or vendor
   behaviour cites the `file:line` actually read.

## Measured results

Three fixtures, run headlessly. Prose words exclude code blocks.

| Fixture | Words | Findings | Wrong anchors |
|---|---|---|---|
| cms-cultivator#58, in-session | 314 | 3 | 0 |
| cms-cultivator#58, spawned subagent | 302 | 4 | 0 |
| cms-cultivator#60 | 251 | 2 | 0 |
| spokaneairport#310 @ `8624cee` | 472 | 1 | 0 |

Before the current format, the same skill produced 519 and 495 words on #58 and #60 in
two different shapes. Wrong suggestion anchors ran 2 of 6 before the `Apply:` field and
0 of 3 after.

`#310` finds the silent poll expiry that commit `235a2bf` later fixed, plus a second one
the author did not fix. It names the containment blast radius but declines to raise it as
a finding, having found no constructible failure.

## Known problems

1. **The skill is written in the style it bans.** `SKILL.md:108` "That is the worst
   possible reader", `:145` "a Strengths section that learned to dress itself", `:122`
   "One review seat", `:55` "is not the reader's problem". A skill demanding direct
   language should be written in direct language. This is the largest unfixed problem and
   it is the reason this handoff exists.
2. **166 lines against a 120-line target.** The plan's thesis is that rules are the
   problem and structure is the fix; the file has grown every time a defect appeared.
3. **Reviews run 250-472 words against a 250-word target.** Four length instruments have
   been tried: a hard word cap (produced jargon), a soft target (ignored), one line per
   label (halved it), and "state the failure not the derivation" (helped). None hold it.
4. **The spawn path has no automated test.** `scripts/run-behavioral-evals.sh` rejects
   `Agent` via `FORBIDDEN_EXTRA_RE`, by design. All three `pr-review` eval cases drive
   `self` prompts, so they exercise only the fallback. The default path is untested.
5. **A spawned review cost $2.08.** Roughly triple in-session. Unbudgeted.
6. **Two stale reviews are posted** on kanopi/cms-cultivator#58 and #60, from a
   mid-session version predating `Apply:` and the subagent change.

## Reference implementations

- https://github.com/obra/superpowers/tree/main — `skills/requesting-code-review/code-reviewer.md`.
  Source of the labelled micro-template and the three severities. Mandates praise; we
  reject that (constraint 3).
- https://github.com/addyosmani/agent-skills/tree/main — not yet read.
- https://github.com/mattpocock/skills/tree/main — not yet read.
- Claude Code's built-in `code-review` skill — not yet read.

## How to run things

Gates, all four currently pass:

```bash
./scripts/validate-frontmatter.sh
node scripts/run-evals.js --min-rank1 75     # routing, 28/28
bats tests/                                   # 83/83
./scripts/check-codex-parity.sh
./scripts/run-behavioral-evals.sh --case pr-review--findings-are-actionable
```

Fixtures. `#58` and `#60` gate as "already reviewed" if driven by PR number, so they run
as self-reviews from worktrees pinned at each PR head:

```bash
git fetch origin pull/58/head:pr58-head
git worktree add /tmp/cc-pr58 pr58-head
git worktree add /tmp/cc-pr60 771935b
git -C ~/Projects/spokane worktree add /tmp/spokane-8624cee 8624cee
```

Then from inside each worktree:

```bash
claude -p "/cms-cultivator:pr-review self" --setting-sources "" \
  --plugin-dir ~/Projects/cms-cultivator --no-session-persistence \
  --allowedTools "Agent,Read,Grep,Glob,Bash(git diff:*),Bash(git log:*),Bash(gh pr view:*),Bash(gh pr diff:*),Bash(grep:*),Bash(sed:*),Bash(php:*)"
```

Gotchas: `--setting-sources ""` blocks every `gh` call unless allowlisted, and the review
correctly refuses rather than inventing findings. Omitting `Agent` from `--allowedTools`
silently exercises the fallback path. `timeout` does not exist on macOS.

## Acceptance criteria

From the plan, unchanged:

1. Every review under 250 words of prose, code blocks excluded, no exceptions clause
2. Every finding carries a `Fix:` that is code or a named concrete action
3. Zero unverified claims about language semantics, vendor APIs, or release dates
4. `#310` surfaces the silent poll expiry and the containment blast radius
5. A reader who has not seen the diff can state what to change from the review alone

Criterion 5 is judged by a human, not by the agent doing the work.
