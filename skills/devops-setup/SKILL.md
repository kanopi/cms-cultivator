---
name: devops-setup
description: Automate Kanopi's complete Drupal/Pantheon DevOps setup for a new project. Invoke when user explicitly asks to set up DevOps for a new project, onboard a Pantheon site to Kanopi's CI/CD pipeline, or uses /devops-setup. This is an irreversible multi-system setup requiring explicit user confirmation at each phase. Creates GitHub repos, configures Pantheon services, and makes code changes.
disable-model-invocation: true
---

# DevOps Setup

Automate Kanopi's complete Drupal/Pantheon DevOps onboarding workflow using the drupal-pantheon-devops-specialist agent.

## ⚠️ Side Effect Warning

**This skill makes irreversible changes across multiple systems:**
- Creates a new GitHub repository in the `kanopi/` organization
- Configures branch protection rules and GitHub teams
- Enables Pantheon services (Redis, New Relic) — may incur costs
- Makes code changes across 16 files and creates new branches/PRs
- Installs new Composer dependencies

**Explicit user confirmation is required before each destructive phase.** This skill will pause and confirm before creating the GitHub repo, before Pantheon configuration, and before pushing any code.

## Usage

- "Set up DevOps for this Pantheon project"
- "Onboard this site to Kanopi's CI/CD pipeline"
- `/devops-setup [git-url]`

**Arguments**: Git URL (Pantheon SSH or GitHub HTTPS/SSH)

## Prerequisites

- Git installed and configured
- GitHub CLI (`gh`) installed and authenticated with `kanopi` org access
- Terminus CLI installed (or will be installed automatically)
- Write access to Pantheon site
- Pantheon site UUID

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() or system tools are unavailable:

1. **Gather inputs** — Ask user for: Git URL, GitHub org, Pantheon site name/UUID, team members
2. **Plan phases** — Present the complete 5-phase setup plan for review
3. **⛔ STOP: Wait for user confirmation** to proceed with each phase
4. **Provide manual instructions** — Step-by-step commands for each phase:
   - Phase 1: Clone repo and create GitHub repo commands
   - Phase 2: GitHub settings configuration commands
   - Phase 3: Pantheon Terminus commands
   - Phase 4: Code change checklist (16 steps)
   - Phase 5: Branch creation and PR commands
5. **Generate config files** — Use Write to create `.ddev/config.yaml`, `.circleci/config.yml`, `phpstan.neon`, etc. based on project info

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() and all required tools:

**⚠️ CONFIRM WITH USER before spawning the agent** — this is an irreversible multi-system setup.

Present to user:
```
DevOps Setup will:
1. Create new GitHub repo: kanopi/{repo-name}
2. Configure branch protection and teams
3. Enable Redis and New Relic on Pantheon (may incur costs)
4. Make code changes and create feature/kanopi-devops branch
5. Create PR

Reply "confirm" to proceed, or "cancel" to abort.
```

**After user confirms**:
```
Task(cms-cultivator:drupal-pantheon-devops-specialist:drupal-pantheon-devops-specialist,
     prompt="Set up Kanopi DevOps for a Drupal/Pantheon project. Arguments: {git-url if provided}. Follow the complete 5-phase workflow: (1) Clone repo and create new GitHub repo in kanopi org, (2) Configure GitHub settings (squash merge, branch protection, teams), (3) Configure Pantheon services via Terminus (Redis, New Relic), (4) Make all code changes on feature/kanopi-devops branch, (5) Push branch, create PR, and output verification checklist with manual follow-up tasks.")
```

## Workflow Phases

### Phase 1: Initial Git Setup
- Clone from provided git URL
- Create new private GitHub repo under `kanopi/` org
- Configure remotes: `pantheon` (original) + `origin` (new kanopi repo)
- Create `main` branch and push

### Phase 2: GitHub Configuration
- Enable squash merges, auto-delete branches, auto-merge
- Create GitHub team with write access + `kanopicode`
- Set branch protection: require PR reviews, status checks, conversation resolution

### Phase 3: Pantheon Configuration
- Verify/install Terminus CLI
- Enable Redis and New Relic on Pantheon site
- Retrieve site UUID for CircleCI config

### Phase 4: Code Changes (feature/kanopi-devops branch)
16 code changes including: DDEV config, Composer dev deps + scripts, code quality configs, pantheon.yml, Cypress tests, CircleCI config, CODEOWNERS, Quicksilver scripts, README, CLAUDE.md

### Phase 5: PR Creation
- Push `feature/kanopi-devops` branch
- Create PR with comprehensive description
- Output verification checklist and manual follow-up tasks

## Manual Follow-Up Tasks (Always Required)

1. **CircleCI Secrets**: Configure `TERMINUS_TOKEN`, `GITHUB_TOKEN`, etc.
2. **CircleCI SSH Key**: Add SSH key to Pantheon for deployments
3. **Gulp Upgrade**: Upgrade Gulp 3 to 4 if flagged
4. **Theme Compilation**: Verify theme builds on multidev

## Related Skills

- **pr-create** — Create PRs for subsequent changes
- **quality-audit** — Analyze code quality after setup
- **security-audit** — Run security audit on the project
