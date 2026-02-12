# Plan: `/devops-setup` Command for Drupal/Pantheon DevOps Automation

## Context

Kanopi has a documented but manual process for onboarding existing Pantheon-hosted Drupal sites into Kanopi's DevOps workflow. This involves cloning the repo, creating a new GitHub repo in the kanopi org, configuring GitHub settings (squash merges, branch protection, teams), enabling Pantheon services (Redis, New Relic), and making extensive code changes (DDEV, CircleCI, Cypress, code quality tools, quicksilver scripts, etc.). The process takes significant developer time and is error-prone. This command automates the entire workflow.

Reference repo: https://github.com/kanopi/drupal-starter

## Files to Create

| File | Purpose |
|------|---------|
| `commands/devops-setup.md` | Slash command entry point |
| `agents/drupal-pantheon-devops-specialist/AGENT.md` | Drupal/Pantheon orchestrator agent (~600-800 lines) |

Also update: `.claude-plugin/plugin.json` (bump version, update counts)

## Architecture

**Single command + single agent.** No skill needed (explicit workflow with side effects). No sub-agents needed (steps are sequential and operate on the same repo).

Pattern follows: `pr-create.md` → spawns `workflow-specialist` via `Task()`.

---

## Command: `/devops-setup`

### Frontmatter
```yaml
---
description: Automate Kanopi's Drupal/Pantheon DevOps setup for a new project
argument-hint: "[git-url]"
allowed-tools: Task, Bash(git:*), Bash(gh:*), Bash(terminus:*), Bash(ddev:*), Bash(composer:*), Bash(ddev composer:*), Bash(npm:*), Bash(ddev exec:*), Bash(curl:*), Bash(brew:*), Bash(which:*), Bash(php:*), Bash(node:*), Bash(mkdir:*), Bash(cp:*), Bash(chmod:*), Bash(ls:*), Bash(cat:*), Bash(ssh:*), Read, Glob, Grep, Write, Edit
---
```

### Structure
1. Spawn `Task(cms-cultivator:drupal-pantheon-devops-specialist:drupal-pantheon-devops-specialist, ...)`
2. Document the 5 phases
3. List prerequisites
4. Show quick start examples

---

## Agent: `drupal-pantheon-devops-specialist`

### Frontmatter
```yaml
---
name: drupal-pantheon-devops-specialist
description: Automate the complete Kanopi DevOps setup for Drupal projects hosted on Pantheon. Clones an existing repo, creates a new GitHub repo in the kanopi org, configures GitHub settings (squash merges, branch protection, teams), enables Pantheon services (Redis, New Relic) via Terminus, and makes all code changes (DDEV, CircleCI, Cypress, code quality tools, quicksilver scripts, CODEOWNERS, theme tooling, README). Invoke when user runs /devops-setup or says "set up devops", "onboard a Pantheon site", or "configure Kanopi CI/CD".
tools: Read, Glob, Grep, Bash, Write, Edit
model: sonnet
color: blue
---
```

### Interactive Flow

**Step 1 - Prompt for inputs (2 required):**
- **Existing git URL** - Pantheon SSH URL or GitHub HTTPS/SSH URL (passed as argument or prompted)
- **New GitHub repo name** - Name for the new repo under `kanopi/` org

**Step 2 - Clone and auto-detect:**
After cloning, the agent auto-detects from the repo:
- PHP version (from `pantheon.yml`)
- DB version (from `pantheon.yml`)
- Pantheon site name/UUID (from git remote URL or `pantheon.yml`)
- Theme name and path (scan `web/themes/custom/`)
- Whether Solr is used (from `pantheon.yml` or `composer.json`)
- Node version (from existing `.nvmrc` or default to 22)
- Existing composer dependencies

**Step 3 - Prompt for team info:**
- GitHub team name (default: repo name)
- Team members (GitHub usernames)

**Step 4 - Show confirmation summary, then execute all 5 phases.**

---

### Phase 1: Initial Git Setup

1. Clone from the provided git URL
2. Create new GitHub repo: `gh repo create kanopi/{name} --private`
3. Rename origin remote to `pantheon`, add new `origin` pointing to kanopi repo
4. Create `main` branch and push to kanopi repo

### Phase 2: GitHub Repo Configuration

1. **Repo settings** via `gh api repos/kanopi/{name} -X PATCH`:
   - `allow_squash_merge: true`, disable merge commits and rebase merges
   - `delete_branch_on_merge: true`, `allow_auto_merge: true`
2. **Create GitHub team**: `gh api orgs/kanopi/teams -X POST`
   - Add team members + `kanopicode`
3. **Add team to repo** with write permissions
4. **Branch protection for main** via `gh api`:
   - Require PR reviews (1 reviewer, code owner reviews required)
   - Required status checks: Cypress, Deployment, PHPcs, PHPstan, Rector
   - Require conversation resolution

### Phase 3: Pantheon Configuration

1. **Check/install Terminus**: `which terminus` → if missing, install via Homebrew or curl
2. **Authenticate**: `terminus auth:whoami` → if not authenticated, prompt for machine token
3. **Enable Redis**: `terminus redis:enable {site}`
4. **Enable New Relic**: `terminus new-relic:enable {site}`
5. **Get site UUID**: `terminus site:info {site} --field=id` (needed for CircleCI config)

### Phase 4: Code Changes (on `feature/kanopi-devops` branch)

Create the branch, then make all changes. **Reference files fetched from drupal-starter at runtime via `gh api`** to always get latest versions.

| Step | What | Details |
|------|------|---------|
| 4.1 | DDEV config | Create `.ddev/config.yaml` matching PHP/DB from `pantheon.yml`. Reference kanopi DDEV drupal add-on quick-start |
| 4.2 | Composer dev deps | Add missing: `drupal/coder`, `mglaman/phpstan-drupal`, `palantirnet/drupal-rector`, `vincentlanglet/twig-cs-fixer`. Add `code-check`, `code-fix`, `phpstan`, `rector-check`, `code-sniff` scripts. Merge into existing `composer.json` (don't overwrite) |
| 4.3 | Code quality configs | Fetch `phpstan.neon`, `rector.php`, `.twig-cs-fixer.php` from drupal-starter if not present |
| 4.4 | pantheon.yml updates | Add: `web_docroot: true`, `build_step: false`, `new_relic.drupal_hooks: true`, `enforce_https: full`, `protected_web_paths`, quicksilver workflow hooks |
| 4.5 | Vendor cleanup | Ensure `vendor/` in `.gitignore`. If committed: `git rm -r --cached vendor/` |
| 4.6 | .gitignore | Fetch drupal-starter reference, merge with existing (preserve project-specific entries) |
| 4.7 | .editorconfig | Create from Drupal standard if missing |
| 4.8 | Theme setup | Add `.nvmrc` (node 22) in theme dir. Ensure compiled assets dir (`dist/` or `assets/`) is gitignored. Flag Gulp 3→4 upgrade if detected (manual task) |
| 4.9 | Cypress tests | Fetch `tests/cypress/` from drupal-starter: `package.json`, `cypress.config.js`, `cypress/e2e/system-checks.cy.js`, support files. Update `.nvmrc` |
| 4.10 | CircleCI | Fetch `.circleci/config.yml` from drupal-starter. Replace variables: `TERMINUS_SITE`, `PANTHEON_UUID`, `THEME_NAME`, `THEME_PATH`, node/PHP versions. Copy helper scripts |
| 4.11 | CODEOWNERS | Create `.github/CODEOWNERS` with `* @kanopi/{team-name}` |
| 4.12 | Quicksilver scripts | Fetch `web/private/scripts/` from drupal-starter (drush_config_import, new_relic_deploy) |
| 4.13 | Drupal modules | Add `drupal/redis` and `drupal/pantheon_advanced_page_cache` to composer.json if missing |
| 4.14 | README | Update with: important links (Pantheon, GitHub, CircleCI), local setup (DDEV), deployment workflow, project-specific notes |
| 4.15 | CLAUDE.md | Generate project-specific CLAUDE.md with dev commands, code quality, DDEV references |
| 4.16 | Commit | `git add -A && git commit -m "feat: add Kanopi DevOps tooling and CI/CD configuration"` |

**Reference file strategy**: Fetch from `gh api repos/kanopi/drupal-starter/contents/{path}` at runtime. This ensures latest versions without bundling files in the plugin.

### Phase 5: Test Branch Building

1. Push branch: `git push -u origin feature/kanopi-devops`
2. Create PR: `gh pr create --title "Add Kanopi DevOps tooling and CI/CD"`
3. Output verification checklist:
   - Multidev created on Pantheon (images work, theme compiled)
   - Static code checks ran (PHPcs, PHPstan, Rector)
   - Cypress test passed
   - Redis enabled on multidev
4. Output manual follow-up tasks:
   - Configure CircleCI context secrets (`TERMINUS_TOKEN`, `GITHUB_TOKEN`, etc.)
   - Add CircleCI SSH key to Pantheon
   - Enable `redis` and `pantheon_advanced_page_cache` modules after first deploy
   - Gulp 3→4 upgrade (if flagged)

---

## Error Handling

- **Pre-flight checks**: Verify `git`, `gh auth status`, connectivity before starting
- **Idempotent steps**: Check if repo/team/branch exists before creating
- **Phase checkpoints**: If a phase fails, report what completed and what failed
- **Terminus fallback**: Install via `brew install pantheon-systems/external/terminus` or curl installer

## Verification

After implementation, test by:
1. Running `/devops-setup` in a Claude Code session
2. Verify it prompts for git URL and repo name
3. Verify it clones, creates GitHub repo, configures settings
4. Verify code changes match drupal-starter reference
5. Verify PR is created with correct content
6. Run plugin BATS tests: `bats tests/test-plugin.bats`
