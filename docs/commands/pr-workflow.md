# PR Workflow Skills

Streamline the development lifecycle — from isolating a ticket in its own worktree through pull request creation, review, and deployment.

---

## Skills

### `worktree-manager [create|list|remove]`

Create, list, and tear down git worktrees so multiple tickets — and multiple AI sessions — run side by side from a single clone.

**Usage:**
```bash
/worktree-manager create 1234 hero-block       # new worktree + feature/tw1234-hero-block
/worktree-manager create 1235 menu-fix --type bug
/worktree-manager create --branch feature/tw1236-old-work   # attach to an existing branch
/worktree-manager create --branch develop --dir ../site-develop
/worktree-manager list                          # show active worktrees + DDEV status
/worktree-manager remove 1234                   # tear down (asks for confirmation first)
/worktree-manager remove feature/tw1236-old-work --delete-branch
```

**What it does:**
1. Creates a sibling worktree directory mirroring the branch (`../<repo>-tw1234`)
2. Branches off the up-to-date remote base using Kanopi naming (`<type>/tw<id>-<short-desc>`) — or, with `--branch`, attaches to a branch that already exists locally or on `origin`
3. Runs platform setup — DDEV (`start`, `composer install`, theme build, `db-refresh`) for Drupal/WordPress, or port-separated `npm run dev` for Next.js
4. Reports the directory, branch, and local URL, plus how to attach a CLI or Desktop session
5. On removal, gates the destructive teardown (worktree, branch, DDEV project + database) behind explicit confirmation

**Working with an existing branch:**

`--branch` takes the branch name verbatim — useful for resuming abandoned work, picking up a colleague's branch, or attaching to a long-lived branch that doesn't follow the ticket convention. It is mutually exclusive with `<short-desc>`, `--type`, and `--base`, which exist only to derive a *new* branch name.

- A branch that exists only on `origin` gets a local tracking branch, never a detached HEAD
- A branch already checked out in another worktree (including the main clone) is reported with that path instead of a raw git error
- A branch behind `origin` reports its ahead/behind counts and offers a fast-forward — it is never pulled silently, since existing branches are the ones most likely to carry local-only work
- Without a ticket ID, the directory falls back to `<repo>-<branch-slug>` unless you pass `--dir`
- On teardown, the local branch is kept by default and deleted only with `--delete-branch` or explicit approval

**Why worktrees:**
- Run two Claude Code sessions (or a CLI session and a Claude Desktop "code" session) on different tickets at once — no `git checkout` thrash
- Maps one-to-one onto Kanopi's "one branch per ticket" rule
- DDEV isolation is automatic when the project name is folder-derived (no committed `name:`, no pinned ports)

**Requires:** Git with worktree support; DDEV for Drupal/WordPress setup steps

---

### `pr-create [ticket-number]`

Create pull request directly on GitHub with generated description.

**Usage:**
```bash
/pr-create 123
# or: "create a PR for PROJ-123"
```

**What it does:**
1. Analyzes git changes (commits, diffs, files)
2. Detects Drupal/WordPress-specific changes
3. Generates comprehensive PR description
4. Shows preview and asks for confirmation
5. Creates PR on GitHub via `gh` CLI

**What it detects:**
- Drupal configuration changes
- Database updates and migrations
- WordPress ACF changes
- Custom post types and taxonomies
- Gutenberg blocks
- File changes and dependencies
- Breaking changes

**Requires:** GitHub CLI (`gh`) authenticated

---

### `pr-review [pr-number|self] [focus]`

Review a pull request or analyze your own changes before creating a PR.

**Review someone's PR:**
```bash
/pr-review 456                    # Full comprehensive review
/pr-review 456 code               # Focus on code quality
/pr-review 456 security           # Focus on security issues
/pr-review 456 breaking           # Focus on breaking changes
```

**Analyze your own changes (pre-PR):**
```bash
/pr-review self                   # Full self-assessment
/pr-review self size              # Check PR size/complexity
/pr-review self breaking          # Check for breaking changes
/pr-review self testing           # Generate test plan
```

**Focus options:**
- `code` - Code quality, readability, maintainability
- `security` - Security vulnerabilities, input validation
- `breaking` - Breaking changes detection and migration paths
- `testing` - Test plan generation
- `size` - Size and complexity assessment
- `performance` - Performance optimization opportunities

**What it reviews**, on two axes:
- **Spec** — does the diff do what the linked Teamwork ticket and PR body say it does?
  Missing, partial, incorrect, or out-of-scope requirements, each quoting the
  requirement line
- **Correctness** — bugs in the code the diff touched, including blast radius (a
  selector, hook, or override that also reaches things the ticket never mentioned) and
  silent failure (a poll, retry, or fallback that swallows its own failure path)

**What it filters out.** Every candidate must carry a concrete failure scenario, and any
claim about contrib, plugin, or vendor behavior must cite the `file:line` actually read.
Candidates are then scored 0–100 and only 80-and-above is reported. A fourteen-item CMS
exclusion list drops what CI already catches, pre-existing issues, unmodified lines, and
the other usual false positives.

**Outputs:**
- At most 8 findings, most severe first, each with a severity prefix (Critical,
  Required, Optional, Nit, FYI), a `file:line`, the failure scenario, and the fix
- Only the sections that have content — there is no fixed template
- `No issues found`, plus one line on what was checked, when nothing clears the bar.
  A clean review is a real result, not a failure to look hard enough
- A reasoned approve / request changes / comment recommendation

---

### `commit-message-generator`

Generate conventional commit messages from staged changes.

**Usage:**
```bash
# Stage your changes first
git add .

# Generate the commit message
/commit-message-generator
```

**What it generates:**
- One commit message, presented for approval before anything is committed
- Conventional commits format, matched to the repository's existing commit style
- An `Assisted-by: <Vendor>/<model-id>` git trailer when AI assisted the change
  itself, skipped for human-authored changes and never `Co-Authored-By`
- A suggestion to split the commit when the staged changes cover unrelated work

**Commit types:**
`feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`

**Scopes** are the module, component, or feature area — Drupal work commonly uses
`config`, `custom_module`, or `hooks`; WordPress work uses `theme`, `plugin`, or
`blocks`. For example `feat(blocks): add testimonial Gutenberg block`.

---

### `pr-release [focus]`

Generate changelog, deployment checklist, and update PR for release.

**Usage:**
```bash
/pr-release               # Generate all artifacts
/pr-release changelog     # Focus on changelog only
/pr-release deploy        # Focus on deployment checklist only
/pr-release update        # Update PR with release info
/pr-release 1.2.0         # Generate for specific version
```

**Focus options:**
- `changelog` - Generate changelog from commits (Keep a Changelog format)
- `deploy` - Create comprehensive deployment checklist
- `update` - Update existing PR description

**What it generates:**
- **Changelog**: Following Keep a Changelog format (Added, Changed, Fixed, Security, etc.)
- **Deployment Checklist**: Pre-deployment checks, deployment steps, post-deployment verification, rollback plan
- **PR Updates**: Updated PR description with release notes

---

## Workflow Examples

### Complete PR Workflow

```bash
# 0. Starting a ticket - isolate it in its own worktree (optional)
/worktree-manager create 123 feature-name   # fresh worktree + branch, DDEV isolated

# 1. During development - commit frequently
git add feature.php
/commit-message-generator            # Generate conventional commit

# 2. Before creating PR - self-review
/pr-review self           # Analyze your own changes
/code-standards-checker        # Check code standards

# 3. Create PR
/pr-create PROJ-123    # Generates description and creates PR

# 4. After PR created - someone reviews
/pr-review 456            # Comprehensive review of PR #456

# 5. Before release
/pr-release               # Generate changelog and deployment checklist
```

### Quick PR Creation

```bash
# Fastest path to PR
/pr-create 123         # Auto-generates description and creates PR
```

### Self-Review Before Submitting

```bash
# Check your work first
/pr-review self           # Full self-assessment
# Fix any issues found
/pr-create 123         # Create PR when ready
```

### Reviewing Someone's PR

```bash
# Full review
/pr-review 456

# Focus on specific areas
/pr-review 456 security   # Security-focused review
/pr-review 456 breaking   # Breaking changes check
```

### Release Preparation

```bash
# Generate all release artifacts
/pr-release 2.0.0

# Or generate individually
/pr-release changelog     # First, create changelog
/pr-release deploy        # Then, create deployment plan
/pr-release update        # Finally, update PR description
```

---

## Integration with Kanopi Tools

PR workflow commands automatically integrate with Kanopi's DDEV commands:

### Pre-Review Quality Checks

```bash
# Before /pr-review self
ddev composer code-check      # Drupal quality checks (phpstan + rector + phpcs)
ddev composer phpstan         # WordPress static analysis
ddev composer phpcs           # WordPress code standards
ddev composer audit           # PHP dependency vulnerabilities
ddev exec npm audit           # JavaScript vulnerabilities
```

### Test Plan Automation

The `/pr-review` command includes these automated test commands:

```bash
# Automated tests to include in test plan
ddev composer code-check      # Code quality (Drupal)
ddev composer phpstan         # Static analysis (WordPress)
ddev cypress-run              # E2E tests (if configured)
ddev critical-run             # Performance tests (if configured)
```

See [Kanopi Tools](../kanopi-tools/overview.md) for more information.

---

## Skill Comparison

### When to use each skill:

**`/worktree-manager`**
- Starting a ticket without disturbing your current working tree
- Running two tickets — or two AI sessions — in parallel from one clone
- Cleaning up a finished ticket's worktree, branch, and DDEV project

**`/pr-create`**
- You're ready to create a PR
- Want PR description auto-generated
- Have `gh` CLI installed and authenticated

**`/pr-review [pr-number]`**
- Reviewing someone else's PR
- Need comprehensive code review
- Want to check for breaking changes or security issues

**`/pr-review self`**
- Before creating your PR
- Want to self-assess your changes
- Need size/complexity check
- Want to catch issues early

**`/commit-message-generator`**
- Making a commit
- Want consistent commit message format
- Following conventional commits

**`/pr-release`**
- Preparing for release
- Need changelog and deployment plan
- Want structured release process

---

## Best Practices

### Commit Messages
- Use conventional commits format
- Be specific and descriptive
- Reference tickets/issues
- Keep subject under 50 characters

### PR Creation
- Self-review with `/pr-review self` first
- Run quality checks before creating PR
- Keep PRs focused (< 400 lines optimal)
- Include comprehensive description

### PR Review
- Review promptly (within 24 hours)
- Be constructive and specific
- Separate critical issues from suggestions
- Acknowledge good work

### Releases
- Generate changelog from commits
- Create detailed deployment checklist
- Test on staging first
- Have rollback plan ready

---

## Next Steps

- **[Quick Start](../quick-start.md)** - Common workflow examples
- **[Skills Overview](overview.md)** - All skills
- **[Code Quality Commands](code-quality.md)** - Maintain code quality
