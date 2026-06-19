---
name: pr-review
description: "Review a pull request or analyze local changes before submitting. Auto-activates when user mentions reviewing a PR, asks for code review, wants to analyze their changes before submitting, or mentions \"pr-review self\". Invoke when user provides a PR number to review or says \"review self\", \"review my changes\", or \"pr review\". Supports focus areas: code, security, breaking, testing, size, performance."
---

# PR Review

Review a pull request or analyze your local changes before submitting. The main session runs this skill directly — no orchestrator agent is involved.

## Usage

**Review someone else's PR:**
- "Review PR #123" / "Review pull request 456"
- With focus: "Review PR #123 for security issues"

**Self-review your own changes before creating a PR:**
- "Review my changes" / "Self-review before PR"
- With focus: "Check my changes for breaking changes"

**Focus options:** `code`, `security`, `breaking`, `testing`, `size`, `performance` (or `all` for a comprehensive review).

## Workflow

### 1. Determine target

- **PR number provided** (e.g., `PR #123`, `pr-review 456`) → review that PR.
- **"self" / "my changes" / "before submitting"** → review local changes against the default branch.
- **No clear target** → ask the user which one they want.
- If invoked from a subagent context (the prompt names a specific PR number and says "delegated" or "automated routine"), do not ask clarifying questions — proceed with that PR.

### 2. Gather context

**For PR review (Tier 2 with `gh` available):**

Run in parallel:

- `gh pr view <number> --json title,body,baseRefName,headRefName,author,additions,deletions,changedFiles`
- `gh pr diff <number>`
- `gh pr checks <number>` (if CI status matters)

**For self-review:**

Determine the default branch (`gh repo view --json defaultBranchRef --jq .defaultBranchRef.name`) — usually `main` or `1.x`. Then run in parallel:

- `git branch --show-current`
- `git log --oneline <default>..HEAD`
- `git diff --stat <default>...HEAD`
- `git diff <default>...HEAD`

**For portable environments (no `gh`):**

Ask the user to share the PR description, the diff, or the file list. Do as much analysis as the provided context allows; note what would have been checked with full access.

### 3. Classify size and complexity

| Size | Lines changed |
|------|---------------|
| XS | < 10 |
| S | 10–100 |
| M | 100–400 |
| L | 400–1,000 |
| XL | > 1,000 — recommend splitting |

Complexity is a judgment call: low for isolated changes, high for cross-cutting refactors or unfamiliar areas.

### 4. Run inline analysis by focus area

Use Read, Grep, and Bash directly. Spawn no agents — the skill performs the analysis itself.

#### Code quality (`code`)

- Readability, naming, function length, duplication
- Project convention adherence (compare against neighbor files)
- Design patterns and SOLID principles where applicable
- Magic numbers, hard-coded strings, dead code

#### Security (`security`)

- **Input handling:** unvalidated `$_GET`/`$_POST`, request params used directly in queries or output
- **SQL:** raw concatenation vs. prepared statements (`$wpdb->prepare`, `db_select` placeholders)
- **Output escaping:** unescaped echo, missing `esc_html`/`esc_attr`/`esc_url`/`Html::escape`/`Xss::filter`
- **Auth:** missing capability checks (`current_user_can`), missing nonce verification (`wp_verify_nonce`), missing Drupal access checks
- **Secrets:** API keys, tokens, passwords committed in code
- **Deserialization:** `unserialize` on user input
- **File handling:** path traversal, unrestricted uploads

#### Breaking changes (`breaking`)

- Function/method signature changes (public API)
- Database schema changes (table/column drops, type changes)
- Removed routes, endpoints, hooks, filters, services
- Dependency major version bumps in `composer.json`/`package.json`
- Config schema changes that won't migrate cleanly
- Permission/capability changes

#### Testing (`testing`)

- New/modified code without corresponding tests
- Test quality: do the assertions actually cover the behavior?
- Edge cases: empty input, null, large input, concurrent access
- Test isolation: do tests pollute state?

#### Size (`size`)

- Lines/files counts
- Mixed concerns (refactor + feature + bugfix in one PR)
- Suggest split points for XL PRs

#### Performance (`performance`)

- N+1 queries inside loops
- Missing caching on expensive operations
- Large unminified assets, missing lazy-load
- Synchronous external HTTP calls in request path
- Cache invalidation patterns

### 5. CMS-specific checks

**Drupal:**

- Config management: `config/sync/` changes match code changes
- Update hooks: present for schema changes
- Database API: no raw queries; `db_query`/`db_select` with placeholders
- Cache tags / contexts on render arrays
- Access control on routes and entity operations
- Services in `*.services.yml` properly wired

**WordPress:**

- `$wpdb->prepare()` on all dynamic queries
- Nonce verification on form/AJAX handlers
- Capability checks (`current_user_can`) before admin actions
- Sanitization on input (`sanitize_text_field`, `wp_kses`)
- Escaping on output (`esc_html`, `esc_attr`, `esc_url`)
- ACF field group exports in `acf-json/`
- Gutenberg block `block.json` correct, attributes typed

### 6. Produce the review

```markdown
# 🤖 AI Code Review — PR #<number>

**Size:** <XS/S/M/L/XL> (<N> files, +<X>/-<Y> lines)
**Complexity:** <Low/Medium/High>

## Summary
<2–4 sentence overall assessment>

## Required Changes

### Critical Issues
- [ ] **<issue>** (`<file>:<line>`) — <problem and recommended fix>

### Security Concerns
- [ ] **<issue>** (`<file>:<line>`) — <risk and fix>

## Suggestions

### Performance
- <bullet>

### Code Quality
- <bullet>

### Testing Gaps
- <bullet>

## Test Plan
- <specific test case>
- <specific test case>

## Overall Recommendation
- [ ] Approve
- [ ] Request Changes
- [ ] Comment
```

Each finding should be **specific** (`auth.php:42`, not "authentication code"), include **why** it matters, and **suggest a fix**. Avoid generic checklist output.

### 7. Optional: post the review to GitHub

If reviewing a PR (not self-review) and the user wants the review posted:

1. Present the review to the user first.
2. Ask: "Post this as a PR review on GitHub? (approve / request changes / comment)"
3. On approval, use `gh pr review <number> --<action> --body "$(cat <<'EOF'\n<review>\nEOF\n)"`.

Self-reviews stay local — they're not posted anywhere.

## Delegated mode (for automated routines)

When invoked via a subagent prompt (e.g. from the code-review routine), behave
non-interactively:

- Skip step 7 entirely — do NOT post to GitHub. The parent routine handles posting.
- Skip user dialogue ("ask the user", "present to the user first") — no user is present.
- Skip the strategic-thinking 5 Cs prose; just apply the framework silently to land on a verdict.
- Output ONLY the review report (step 6 template), with NO preamble.
- End the output with this exact sentinel on its own line:
    FINAL_RECOMMENDATION: Approve
    FINAL_RECOMMENDATION: Request Changes
    FINAL_RECOMMENDATION: Comment
  (one of the three, verbatim — the parent parses this line.)

The parent is responsible for posting to Teamwork/GitHub/Slack and for any
notification rules.

## Strategic Decision Framework

When deciding whether to recommend "approve" vs. "request changes," apply the **5 Cs** from the `strategic-thinking` skill:

- **Color** — Production hotfix vs. exploratory branch sets different bars.
- **Consequence** — What breaks if this ships with the issues you found?
- **Cost** — How much rework do the required changes represent?
- **Connective Tissue** — Does this PR affect other in-flight work?

Use these to provide a recommendation with reasoning, not just a verdict.

## Related Skills

- **commit-message-generator** — Used during PR creation
- **pr-create** — Create the PR after a passing self-review
- **security-scanner** — Deep security checks on specific code shown inline
- **accessibility-checker** — Element-level accessibility checks
