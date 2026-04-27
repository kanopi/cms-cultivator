# DevOps Setup

Automate Kanopi's complete Drupal/Pantheon DevOps onboarding workflow for new projects.

## Skill

`devops-setup [git-url]` — Full Kanopi DevOps onboarding: GitHub repo creation, Pantheon services, CircleCI, and code quality tooling

## Quick Start

```bash
# With a Pantheon SSH URL:
/devops-setup ssh://codeserver.dev.SITE-UUID@codeserver.dev.SITE-UUID.drush.in:2222/~/repository.git

# With a GitHub URL:
/devops-setup https://github.com/org/repo.git

# Without arguments (will prompt for inputs):
/devops-setup
```

## How It Works

The command spawns the **drupal-pantheon-devops-specialist** agent, which executes a five-phase automated onboarding workflow.

### Workflow Phases

#### Phase 1: Initial Git Setup

- Clones from the provided git URL (Pantheon SSH or GitHub HTTPS/SSH)
- Creates a new private GitHub repo under the `kanopi/` org
- Configures remotes: `pantheon` (original) + `origin` (new kanopi repo)
- Creates `main` branch and pushes

#### Phase 2: GitHub Repo Configuration

- Enables squash merges only, auto-delete branches, and auto-merge
- Creates GitHub team with members + `kanopicode`
- Sets branch protection: required PR reviews, status checks, and conversation resolution

#### Phase 3: Pantheon Configuration

- Verifies or installs Terminus CLI
- Enables Redis on the Pantheon site for object caching
- Enables New Relic for performance monitoring
- Retrieves site UUID for CircleCI config

#### Phase 4: Code Changes (`feature/kanopi-devops` branch)

All reference files are fetched from `kanopi/drupal-starter` at runtime:

| Step | What |
|------|------|
| DDEV config | `.ddev/config.yaml` matching PHP/DB versions |
| Composer deps | `drupal/coder`, `phpstan-drupal`, `drupal-rector`, `twig-cs-fixer` |
| Composer scripts | `code-check`, `code-fix`, `phpstan`, `rector-check`, `code-sniff` |
| Code quality | `phpstan.neon`, `rector.php`, `.twig-cs-fixer.php` |
| `pantheon.yml` | Quicksilver hooks, enforce HTTPS, protected paths |
| Vendor cleanup | Remove committed `vendor/` if present |
| `.gitignore` | Merged from drupal-starter reference |
| `.editorconfig` | Drupal standard |
| Theme setup | `.nvmrc`, gitignored compiled assets |
| Cypress tests | `tests/cypress/` from drupal-starter |
| CircleCI | `.circleci/config.yml` with project variables |
| CODEOWNERS | `.github/CODEOWNERS` |
| Quicksilver | `web/private/scripts/` for deploy hooks |
| Drupal modules | `drupal/redis`, `drupal/pantheon_advanced_page_cache` |
| README | Project-specific with important links |
| CLAUDE.md | Dev commands, code quality, DDEV references |

#### Phase 5: Test Branch Building

- Pushes `feature/kanopi-devops` branch to origin
- Creates PR with comprehensive description
- Outputs verification checklist and manual follow-up tasks

## What Gets Created

### GitHub Configuration

- Private repo under `kanopi/` org with squash merge policy
- Branch protection on `main` with required status checks
- GitHub team with write access and CODEOWNERS file

### Pantheon Services

- Redis enabled for object caching
- New Relic enabled for performance monitoring

## Prerequisites

- **Git** — Installed and configured
- **GitHub CLI** — Installed and authenticated (`gh auth status`)
- **Terminus** — Installed, or will be installed automatically during setup
- **Access** — Write access to `kanopi` GitHub org and target Pantheon site

## Manual Follow-Up Tasks

These steps require manual action after the automated setup completes:

1. **CircleCI Secrets** — Configure context secrets (`TERMINUS_TOKEN`, `GITHUB_TOKEN`, etc.)
2. **CircleCI SSH Key** — Add SSH key to Pantheon for deployments
3. **Gulp Upgrade** — Upgrade Gulp 3 to 4 if flagged during setup
4. **Theme Compilation** — Verify theme builds correctly on multidev

## Related Commands

- **[`/pr-create`](../commands/pr-workflow.md)** — Create pull requests for subsequent changes
- **[`/quality-analyze`](../commands/code-quality.md)** — Analyze code quality after setup
- **[`/audit-security`](../commands/security.md)** — Run security audit on the project
