---
name: pr-release
description: Generate changelog entries, a deployment checklist, and update a release PR description. Invoke when user asks to prepare a release, generate a changelog, create a deployment checklist, or uses /pr-release. Requires user confirmation before updating the PR (modifies publicly visible content). Supports version numbers and focus areas (changelog/deploy/update).
---

# PR Release

Generate changelog entries, deployment checklists, and update the release PR description. The main session runs this skill directly — no orchestrator agent is involved.

## ⚠️ Side Effect Warning

**This skill updates a GitHub PR description** — an action that modifies publicly visible content:

- Updates the PR description via `gh pr edit`
- The changelog and deployment checklist are visible to all repository members

**Confirmation required** before updating the PR. Present all artifacts for review and wait for explicit approval before running `gh pr edit`.

This skill does **not** create git tags, merge the PR, or deploy. Those remain manual.

## Usage

- "Prepare release artifacts for version 1.2.0"
- "Generate a changelog for this release branch"
- "Create a deployment checklist"
- `/pr-release [version-or-focus]`

**Focus options:** `changelog`, `deploy`, `update`, or a version number like `1.2.0`.

## Prerequisites

- On a release branch (typically named `release/<version>` or similar)
- Commits follow conventional commits (`feat`, `fix`, `breaking`, `chore`, etc.)
- GitHub CLI (`gh`) installed and authenticated for the Tier 2 path

## Workflow

### 1. Parse arguments

- If the argument looks like a version (`1.2.0`, `v2.3.4`, `1.0.0-rc1`) — use it as the target version.
- If the argument is `changelog` / `deploy` / `update` — focus the output on that section only.
- If no argument — generate all three artifacts (changelog, deployment checklist, PR description update).

### 2. Determine version (if not provided)

- Read the project's version source of truth (e.g., `.claude-plugin/plugin.json` for this repo, `composer.json`, `style.css` for WP themes, `*.info.yml` for Drupal modules).
- Read `CHANGELOG.md` to find the previous released version.
- Inspect commits since the last release to suggest a bump:
  - Any `feat:` → minor bump (1.X.0)
  - Any `BREAKING CHANGE:` or `!:` → major bump (X.0.0)
  - Only `fix`/`chore`/`docs` → patch bump (1.0.X)
- Confirm the proposed version with the user before continuing.

### 3. Analyze commits since the last release

Run in parallel:

- Find the previous tag: `git describe --tags --abbrev=0` (or read `CHANGELOG.md`)
- `git log --oneline <prev-tag>..HEAD`
- `git log <prev-tag>..HEAD --pretty=format:"%s%n%b"`
- `git diff --stat <prev-tag>..HEAD`

### 4. Categorize commits

Group by conventional commit type for the changelog:

| Commit type | Changelog section |
|-------------|-------------------|
| `feat:` | Added |
| `fix:` | Fixed |
| `refactor:` | Changed |
| `perf:` | Changed |
| `docs:` | Changed (or Documentation) |
| `BREAKING CHANGE:` / `!:` | Breaking Changes |
| `security:` (or fix related to vulns) | Security |

Within each section, write one human-readable line per commit. Don't just copy the commit subject — translate to user-facing language where appropriate.

### 5. Detect CMS-specific deployment requirements

Scan the diff for:

**Drupal:**
- `config/sync/` changes → `drush config:import`
- `hook_update_N` → `drush updatedb`
- New module dependencies → `composer install --no-dev` + `drush en <module>`
- Service or render changes → `drush cache:rebuild`
- New `*.routing.yml` entries → rebuild routes

**WordPress:**
- ACF JSON files in `acf-json/` → re-sync via ACF UI or WP-CLI
- `register_post_type`, `register_taxonomy`, rewrite changes → flush permalinks
- Theme changes → clear caching plugin (W3 Total Cache, WP Rocket, etc.)
- New plugins added → activate after deploy
- `block.json` / `src/blocks/` changes → run build, clear editor cache
- Multisite changes → check network-wide impact

### 6. Generate artifacts

#### Changelog (Keep a Changelog format)

```markdown
## [<version>] - <YYYY-MM-DD>

### Added
- <user-facing description of feature>

### Changed
- <user-facing description of change>

### Fixed
- <user-facing description of fix>

### Security
- <vulnerability fix>

### Breaking Changes
- <breaking change with migration note>

### Drupal-Specific Upgrade Notes
- Run: `drush updatedb`
- Run: `drush config:import`
- Clear cache: `drush cache:rebuild`

### WordPress-Specific Upgrade Notes
- Flush permalinks: Settings → Permalinks → Save
- Re-sync ACF fields from `acf-json/`
```

Omit any section that has no entries.

#### Deployment Checklist

```markdown
## Pre-Deployment
- [ ] Code review complete
- [ ] Tests passing in CI
- [ ] Database backup taken
- [ ] Multidev/staging validated
- [ ] Client UAT complete (if applicable)

## Deployment Steps
1. [ ] Merge release PR to main
2. [ ] Pull on production: `git pull origin main`
3. [ ] Run: `composer install --no-dev` (if dependencies changed)
4. [ ] <CMS-specific step from step 5>
5. [ ] <CMS-specific step from step 5>

## Post-Deployment
- [ ] Smoke test critical user flows: <list>
- [ ] Monitor error logs for 15 minutes
- [ ] Notify stakeholders of completion

## Rollback Plan
- [ ] Database restore command ready
- [ ] Revert git ref: `<previous-tag>`
- [ ] Cache flush after rollback
```

#### PR Description Update

Suggest specific edits to the existing PR description — usually:

- Title prefixed with `Release: v<version>` or `chore(release): v<version>`
- Body includes the changelog entry as the description
- Deployment checklist appended

### 7. Present for approval

Your response **must start immediately** with the approval header. No preamble.

```
=== RELEASE ARTIFACTS READY FOR APPROVAL ===

## Changelog Entry

<changelog>

## Deployment Checklist

<checklist>

## Proposed PR Description Update

**New title:** <title>

**Body:**

<body>

===================================

Reply "approve" to update the PR and save these artifacts, or provide your edits.
```

### 8. Wait for explicit user approval

⛔ **Do not run `gh pr edit` or write to `CHANGELOG.md` until the user replies "approve" or provides edits.**

### 9. Apply the artifacts

On approval:

1. **Update `CHANGELOG.md`** — insert the new entry under `## [Unreleased]` (move existing Unreleased content into the new version block if appropriate).
2. **Update the version source of truth** (e.g., `plugin.json`, `composer.json`, `style.css`).
3. **Update the PR description** via `gh pr edit <pr-number> --title "<title>" --body "$(cat <<'EOF'\n<body>\nEOF\n)"`.
4. Tell the user: "Release artifacts applied. Tag and deploy remain manual — run `git tag v<version> && git push --tags` when ready."

## Environment fallback (no `gh` CLI)

1. Run steps 1–7 normally.
2. After approval, **provide the commands** for the user to run manually — heredoc-formatted so they can paste.
3. Edit `CHANGELOG.md` and version files locally; the user pushes.

## Semantic Versioning Quick Reference

- **Major (X.0.0)** — Breaking changes, removed features
- **Minor (1.X.0)** — New features (backwards-compatible)
- **Patch (1.0.X)** — Bug fixes, security patches, doc-only changes

## Related Skills

- **pr-create** — Create the initial release PR before this skill runs
- **pr-review** — Review the release PR before approval
- **commit-message-generator** — Source of the conventional commits this skill categorizes
