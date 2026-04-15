---
name: pr-release
description: Generate changelog, deployment checklist, and update PR for release using the workflow-specialist agent. Invoke when user asks to prepare a release, generate a changelog, create a deployment checklist, or uses /pr-release. Requires user confirmation before updating the PR (irreversible GitHub action). Supports version numbers and focus areas (changelog/deploy/update).
---

# PR Release

Generate changelog entries, deployment checklists, and update PR descriptions for releases using the workflow-specialist agent.

## ⚠️ Side Effect Warning

**This skill updates a GitHub PR description** — an action that modifies publicly visible content:
- Updates the PR description via `gh pr create` / `gh pr edit`
- The changelog and deployment checklist are visible to all repository members

**Confirmation required** before updating the PR. The skill will present all artifacts for review and wait for explicit approval.

**Note**: This skill does NOT create git tags, merge PRs, or deploy to production. Those actions remain manual.

## Usage

- "Prepare release artifacts for version 1.2.0"
- "Generate a changelog for this release branch"
- "Create a deployment checklist"
- `/pr-release [version-or-focus]`

**Focus options**: `changelog`, `deploy`, `update`, or a version number like `1.2.0`

## Prerequisites

- On a release branch
- Commits following conventional commit format (feat, fix, breaking, etc.)
- GitHub CLI (`gh`) installed and authenticated

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() or gh CLI are unavailable:

1. **Parse arguments** — Determine version number or focus area
2. **Gather git context** — Ask user to share: branch name, commits since last release, existing CHANGELOG.md
3. **Categorize commits** — Sort by type (feat → Added, fix → Fixed, breaking → Breaking Changes, etc.)
4. **Detect CMS changes** — Identify Drupal/WordPress-specific deployment requirements
5. **Generate artifacts**:
   - **Changelog** in Keep a Changelog format
   - **Deployment checklist** with pre/post checks and rollback plan
   - **PR description updates**
6. **Present for approval** — Display all artifacts under `=== RELEASE ARTIFACTS READY FOR APPROVAL ===`
7. **⛔ STOP: Wait for explicit user approval**
8. **After approval**: Provide artifacts for manual use; give `gh pr edit` command for user to run

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() and git/gh CLI available:

1. **Spawn workflow-specialist**:
   ```
   Task(cms-cultivator:workflow-specialist:workflow-specialist,
        prompt="Prepare release artifacts for the current branch. User's focus: {argument or 'all'}. Follow the complete release workflow: (1) Analyze changes since last release, categorize commits by type, detect CMS-specific deployment requirements, (2) Generate changelog in Keep a Changelog format, (3) Create comprehensive deployment checklist, (4) CRITICAL OUTPUT FORMAT: Start IMMEDIATELY with '=== RELEASE ARTIFACTS READY FOR APPROVAL ===' — NO text before this header. Show changelog, deployment checklist, and PR update recommendations. End with approval request. (5) After approval, update PR description via gh CLI.")
   ```
2. **Present output directly** — Display workflow-specialist output verbatim when `=== RELEASE ARTIFACTS READY FOR APPROVAL ===` appears
3. **⛔ STOP: Wait for user approval**
4. **After approval** — Resume workflow-specialist to update PR

## Confirmation Protocol

```
=== RELEASE ARTIFACTS READY FOR APPROVAL ===

## Changelog Entry (Keep a Changelog format)
[Generated changelog]

## Deployment Checklist
[Complete deployment steps]

## PR Description Updates
[Updated sections]

===================================

Reply "approve" to update the PR and save these artifacts, or provide your edits.
```

## Changelog Format (Keep a Changelog)

```markdown
## [1.2.0] - 2026-04-15

### Added
- [New features]

### Changed
- [Modified behavior]

### Fixed
- [Bug fixes]

### Security
- [Security patches]

### Drupal-Specific Upgrade Notes
- Run: `drush updatedb`
- Run: `drush config:import`
- Clear cache: `drush cache:rebuild`

### WordPress-Specific Upgrade Notes
- Flush permalinks: Settings > Permalinks > Save
- Re-sync ACF fields from acf-json/
```

## Semantic Versioning Guidance

- **Major (X.0.0)**: Breaking changes, removed features, incompatible API changes
- **Minor (1.X.0)**: New features (backwards-compatible), new API endpoints
- **Patch (1.0.X)**: Bug fixes, security patches, documentation updates

## Related Skills

- **pr-create** — Create initial PR before release
- **pr-review** — Review changes before release
- **commit-message-generator** — Generate commit messages
