---
description: Automate Kanopi's Drupal/Pantheon DevOps setup for a new project
argument-hint: "[git-url]"
allowed-tools: Task, Bash(git:*), Bash(gh:*), Bash(terminus:*), Bash(ddev:*), Bash(composer:*), Bash(ddev composer:*), Bash(npm:*), Bash(ddev exec:*), Bash(curl:*), Bash(brew:*), Bash(which:*), Bash(php:*), Bash(node:*), Bash(mkdir:*), Bash(cp:*), Bash(chmod:*), Bash(ls:*), Bash(cat:*), Bash(ssh:*), Read, Glob, Grep, Write, Edit
---

## How It Works

Spawn the **drupal-pantheon-devops-specialist** agent to automate the complete Kanopi DevOps onboarding workflow:

```
Task(cms-cultivator:drupal-pantheon-devops-specialist:drupal-pantheon-devops-specialist,
     prompt="Set up Kanopi DevOps for a Drupal/Pantheon project. Arguments: [use git URL if provided]. Follow the complete 5-phase workflow: (1) Clone repo and create new GitHub repo in kanopi org, (2) Configure GitHub settings (squash merge, branch protection, teams), (3) Configure Pantheon services via Terminus (Redis, New Relic), (4) Make all code changes on feature/kanopi-devops branch (DDEV, CircleCI, Cypress, code quality, quicksilver scripts, README, CLAUDE.md), (5) Push branch, create PR, and output verification checklist with manual follow-up tasks.")
```

### Workflow Phases (Automated)

#### Phase 1: Initial Git Setup
- Clone from the provided git URL (Pantheon SSH or GitHub HTTPS/SSH)
- Create new private GitHub repo under `kanopi/` org
- Configure remotes: `pantheon` (original) + `origin` (new kanopi repo)
- Create `main` branch and push

#### Phase 2: GitHub Repo Configuration
- Enable squash merges only, auto-delete branches, auto-merge
- Create GitHub team with members + `kanopicode`
- Set branch protection: require PR reviews, status checks, conversation resolution

#### Phase 3: Pantheon Configuration
- Verify/install Terminus CLI
- Enable Redis and New Relic on the Pantheon site
- Retrieve site UUID for CircleCI config

#### Phase 4: Code Changes (feature/kanopi-devops branch)
- DDEV config, Composer dev deps + scripts, code quality configs
- pantheon.yml updates, .gitignore, .editorconfig
- Theme setup (`.nvmrc`, compiled assets)
- Cypress tests, CircleCI config, CODEOWNERS
- Quicksilver scripts, Drupal modules (Redis, PAPC)
- README and project-specific CLAUDE.md
- All reference files fetched from `kanopi/drupal-starter` at runtime

#### Phase 5: Test Branch Building
- Push `feature/kanopi-devops` branch
- Create PR with comprehensive description
- Output verification checklist and manual follow-up tasks

---

## Prerequisites

- **Git**: Installed and configured
- **GitHub CLI**: Installed and authenticated (`gh auth status`)
- **Terminus**: Installed or will be installed automatically
- **Access**: Write access to `kanopi` GitHub org and target Pantheon site

## Quick Start

```bash
# With a Pantheon SSH URL:
/devops-setup ssh://codeserver.dev.SITE-UUID@codeserver.dev.SITE-UUID.drush.in:2222/~/repository.git

# With a GitHub URL:
/devops-setup https://github.com/org/repo.git

# Without arguments (will prompt for inputs):
/devops-setup
```

## What Gets Created

### GitHub Configuration
- Private repo under `kanopi/` org with squash merge policy
- Branch protection on `main` with required status checks
- GitHub team with write access and CODEOWNERS

### Pantheon Services
- Redis enabled for object caching
- New Relic enabled for performance monitoring

### Code Changes (16 steps)
| Step | What |
|------|------|
| DDEV config | `.ddev/config.yaml` matching PHP/DB versions |
| Composer deps | `drupal/coder`, `phpstan-drupal`, `drupal-rector`, `twig-cs-fixer` |
| Composer scripts | `code-check`, `code-fix`, `phpstan`, `rector-check`, `code-sniff` |
| Code quality | `phpstan.neon`, `rector.php`, `.twig-cs-fixer.php` |
| pantheon.yml | Quicksilver hooks, enforce HTTPS, protected paths |
| Vendor cleanup | Remove committed `vendor/` if present |
| .gitignore | Merged from drupal-starter reference |
| .editorconfig | Drupal standard |
| Theme setup | `.nvmrc`, gitignored compiled assets |
| Cypress tests | `tests/cypress/` from drupal-starter |
| CircleCI | `.circleci/config.yml` with project variables |
| CODEOWNERS | `.github/CODEOWNERS` |
| Quicksilver | `web/private/scripts/` for deploy hooks |
| Drupal modules | `drupal/redis`, `drupal/pantheon_advanced_page_cache` |
| README | Project-specific with important links |
| CLAUDE.md | Dev commands, code quality, DDEV references |

## Manual Follow-Up Tasks

After the automated setup completes, these tasks require manual action:

1. **CircleCI Secrets**: Configure context secrets (`TERMINUS_TOKEN`, `GITHUB_TOKEN`, etc.)
2. **CircleCI SSH Key**: Add SSH key to Pantheon for deployments
3. **Enable Drupal Modules**: Enable `redis` and `pantheon_advanced_page_cache` after first deploy
4. **Gulp Upgrade**: Upgrade Gulp 3 to 4 if flagged during setup
5. **Theme Compilation**: Verify theme builds correctly on multidev

## Related Commands

- **[`/pr-create`](pr-create.md)** - Create pull requests for subsequent changes
- **[`/quality-analyze`](quality-analyze.md)** - Analyze code quality after setup
- **[`/audit-security`](audit-security.md)** - Run security audit on the project
