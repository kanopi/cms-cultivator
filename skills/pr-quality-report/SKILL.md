---
name: pr-quality-report
description: Write the Quality Report that closes a pull request description — changes summary, security analysis, tests written, checks deferred to CI, performance, and accessibility, each section only when the diff touched its subject — and attach it as the last section of the PR body, or regenerate it safely on an existing PR. Also covers passing any multiline body to gh with --body-file and a quoted heredoc. Invoke when the user asks for a "quality report", to "add" or "update the quality report on the PR", to "regenerate the PR report", or when project instructions require a Quality Report before a task is done.
---

# PR Quality Report

Write the Quality Report for a pull request and attach it as the last section of the PR
body. The main session runs this skill directly; no orchestrator agent is involved.

## ⚠️ Side Effect Warning

**On an existing PR, this skill rewrites the PR description** — public, and visible to
everyone on the repository.

**Confirmation required.** Show the report and wait for explicit approval before
`gh pr edit`. When `pr-create` calls this skill before its own approval gate, that gate
covers the report and no second confirmation is needed.

## Usage

- "Write the quality report for this PR"
- "Update the quality report on PR 347"
- "Regenerate the quality report after the last push"

## Definitions

- **Custom code** — code the repository owns: custom modules, themes, plugins,
  application code, templates, build config, tests.
- **Dependency-only change** — version bumps and lockfile churn with no custom code
  edited: Composer and npm bumps, Drupal module updates, WordPress plugin updates,
  package metadata, and core patch or security releases (Drupal 11.3.19 → 11.3.20). A
  dependency that is patched, forked, or overridden counts as custom code.
- **Core, framework, or PHP upgrade beyond a patch release** (Drupal 11.3 → 11.4,
  WordPress 6.7 → 6.8, PHP 8.3 → 8.4) is **not** dependency-only: it runs update hooks,
  changes config, and deprecates APIs the custom code uses. Security Analysis applies,
  and Snyk runs on the custom code it touches.

## What goes in the report

**Report only on what changed.** Omission is the default. A section whose subject the
diff never touched is left out entirely — no heading, no placeholder, no row of `N/A`.
`N/A` across a section you could have deleted adds length without information and
trains readers to skim past the sections that matter.

| Section | Include when |
|---|---|
| Changes Summary | Always |
| Security Analysis | Custom code changed |
| Tests Written | Logic, services, utilities, or user-facing behaviour changed |
| Deferred to CI | Something was written this session but not run locally |
| Performance | Queries, caching, or asset loading touched |
| Accessibility | Markup, templates, or UI components touched |

- **Never omit a section to shorten the report.** Omit it because its subject did not
  change. If an applicable section runs long, shorten its content.
- **Never add a file list** — no "Files Modified" section, no table of paths, no
  per-file summary. GitHub's Files changed tab already has them, with diffs, and a
  hand-written copy goes stale on the next commit. Say what changed in Changes
  Summary; let the diff show where.
- **Never restate what CI reports** — no "Static Checks" section, no pass/fail table
  for linters, static analysis, type checks, or test runs CI also performs. The checks
  UI is the live record. Record a local check only when it has **no CI equivalent**,
  and then in the section that covers it, never a table of its own.
- **Steps to Validate lives in the PR template.** Do not duplicate it here.
- **It is a deliverable, not a summary.** Style rules that suppress end-of-task
  summaries do not apply to it.
- **No hard wrapping.** Every bullet and table cell is one unbroken line; GitHub renders
  a newline inside a paragraph as a line break.

```markdown
## Quality Report

### Changes Summary
- What changed and why

### Security Analysis
- [ ] Snyk SAST: [Pass / Fail] — findings
- [ ] No hardcoded secrets or credentials
- [ ] Input validation on system boundaries
- [ ] No SQL injection, XSS, or command injection vectors

### Tests Written
- [ ] Unit: [Created / Updated / Existing] — list test files
- [ ] Functional / E2E: [Created / Updated / Existing] — list test files
- [ ] Edge cases considered: [list]

### Deferred to CI
- Environment-dependent checks written but not run locally, e.g. functional tests, E2E

### Performance
- [ ] No N+1 query patterns introduced
- [ ] Caching strategy: [described if relevant]
- [ ] Frontend impact: [Lighthouse-relevant notes if applicable]

### Accessibility
- [ ] WCAG 2 AA for new UI elements
- [ ] Semantic HTML used
```

### The Snyk line

When Security Analysis applies, run `snyk code test <path>` on every changed custom
directory and report Pass or Fail with its findings. **Never mark it N/A** — if custom
code changed, the scan is applicable. On a dependency-only change the whole section is
omitted, so there is no line to write.

If Snyk reports no supported files (`SNYK-CODE-0006` — Markdown, YAML, and other
files it cannot analyze), say so and leave the box unchecked. No supported files is a
result, not a Pass.

### Honesty

State only what this session produced. A test file that was written is not a test that
passed; tests run in CI are reported by the checks UI, not here. Unknown is never Pass.

## Attaching it to the PR

The report is the last section of the PR body. That makes regenerating it safe: strip
the previous report, then append the new one. Only org attribution may follow it —
anything else placed after the report is destroyed on the next regeneration. A
`Delivery Record:` link belongs above the report.

**Org attribution.** Claude Code's `attribution.pr`, often pushed through org managed
settings, ends PR descriptions with a fixed line — Kanopi's is
`- [x] Was AI used in this pull request?`. It outranks this skill's placement rules.
The strip below would remove it with the old report, so regeneration keeps it: if the
body currently **ends** with that line, it is moved back to the end after the new
report and any other copy is dropped. If the body does not end with it, nothing is
added at the end — the attribution covers PRs the agent creates, not ones it edits. A
body with no checkbox anywhere is handled by the disclosure check below.

**New PR** — `pr-create` appends the report before its approval gate and creates the PR
once, with the whole body on stdin.

**Existing PR** — read the body, drop the earlier report, append the new one, and write
it back after approval:

```bash
# Strip \r: a body last edited in the GitHub web UI has CRLF line endings, and the
# anchored matches below would miss every line — appending a second report.
BODY=$(gh pr view <pr-number> --json body -q .body | tr -d '\r')
[ -n "$BODY" ] || { echo "Could not read PR body; aborting."; exit 1; }

# The session's org attribution text, if it has one; Kanopi's shown. It is only ever
# kept, never added, so the default is safe when the session carries none. Set it to
# the session's own text when that differs, or a different org's line is dropped.
ATTR='- [x] Was AI used in this pull request?'
LAST=$(printf '%s\n' "$BODY" | grep -v '^[[:space:]]*$' | tail -1)
KEEP=""; [ "$LAST" = "$ATTR" ] && KEEP="$ATTR"

{
  # Everything above the previous report — minus the attribution, if it moves to the end.
  # Drop every tick state of the AI checkbox too, or an unticked template copy survives.
  printf '%s\n' "$BODY" | awk '/^## Quality Report$/{exit} {print}' \
    | if [ -n "$KEEP" ]; then
        grep -vFx -- "$ATTR" | grep -vE '^- \[[ xX]\] Was AI used in this pull request\?$'
      else cat; fi

  cat <<'PRBODY'
## Quality Report
<the report>
PRBODY

  [ -z "$KEEP" ] || printf '\n%s\n' "$KEEP"
} | gh pr edit <pr-number> --body-file -
```

**The emptiness check is not optional.** Without it, a failed `gh pr view` pipes nothing
through `awk` and the description is overwritten with the report alone.

**Check the AI disclosure every time you write the body.** The `Was AI used in this pull
request?` checkbox must appear exactly once — in the template's position, or last when
org attribution puts it there — and be ticked when AI assisted the change itself (the
`Assisted-by:` test). Count whole checkbox lines only; the bare phrase also turns up when
a description quotes it:

```bash
gh pr view <pr-number> --json body -q .body | tr -d '\r' \
  | grep -cE '^- \[[ xX]\] Was AI used in this pull request\?$'   # must print 1
```

A missing, duplicated, or wrongly unticked box sits above the report, so fixing it is a
separate edit: read the body, correct that one line — adding it under `## Description`,
after the ticket line, if it is missing — and write it back with the same empty-read
guard. Show the fix at the approval gate. If the session's attribution settings say to
add no attribution lines to PR descriptions, never add a missing box; only correct one
the template already has.

- **Never append a second report.** One body holds exactly one, reflecting the latest
  run.
- **Other sections are a separate edit.** This procedure rewrites the report only.
  Filling in a Tugboat preview URL (see `pr-create`) changes sections above it.
- **No `gh`** — output the full body, template plus report, and hand over the
  `gh pr edit --body-file -` command with the body in a quoted heredoc.

## Multiline content with gh

Never pass multiline content with `--body`. It goes through argv, is subject to shell
quoting, and command substitution strips trailing newlines. Pass it on stdin —
`--body-file -` reads the body from standard input:

```bash
gh pr create --title "<title>" --body-file - <<'PRBODY'
## Description
...
PRBODY
```

`--body-file -` works the same on `gh pr create`, `gh pr edit`, `gh pr comment`,
`gh issue create`, and `gh issue comment`.

Three rules for the heredoc:

- **Quote the delimiter.** `<<'PRBODY'`, never `<<PRBODY`. Unquoted, the shell expands
  `$variables` and backticks inside the body, and PR bodies are full of both
  (`$user_input`, `esc_html`, `${TERMINUS_SITE}`).
- **Use an unlikely delimiter.** `PRBODY`, not `EOF`. A body line that is exactly the
  delimiter ends the heredoc early, and the rest runs as shell commands.
- **One unbroken line per paragraph and bullet.** An editor's wrap column has no place
  in a PR body.

Use a temporary file only when the body must survive the command — retrying a failed
call without regenerating it, or inspecting it before it goes up. Delete it afterward.

## Anti-rationalization table

| Pressure / rationalization | Correct behavior |
|---|---|
| "Every section should be there so the report looks complete" | Omit every section whose subject did not change. Completeness is the wrong goal. |
| "A file list helps reviewers find things" | The Files changed tab does that, and stays current. No file list. |
| "Copy the CI results in so it's all in one place" | The checks UI is the record. Restate only a check with no CI equivalent. |
| "Tests were written, so mark them passing" | Written is not passed. Report what this session ran. |
| "Just append the new report below the old one" | Strip the old report first. One report per body. |
| "Put the delivery-record link at the very end" | Only org attribution goes below the report. Place the link above. |
| "Regenerating anyway — the trailing attribution line can go" | Keep it. The org requires the body to end with it, and the strip would delete it. |
| "Add the attribution line at the end of this PR too, while editing" | Never add a trailing line to a body that doesn't already end with one. If the body has no checkbox at all, add it under `## Description` instead. |
| "The AI checkbox is missing, but that's outside the report" | Fix it in a separate edit above the report. Disclosure is required on every PR. |
| "The PR body read failed — write the report anyway" | Abort. Writing without the read destroys the description. |

## Related Skills

- **pr-create** — Creates the PR and calls this skill before its approval gate
- **code-standards-checker** — Fixes standards violations before the PR opens; hands
  over only a local check that has no CI equivalent
- **commit-message-generator** — Per-commit `Assisted-by:` provenance
