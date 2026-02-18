# Plan: Phased Testing & Validation for DevOps Specialist Agent

## Context

The `drupal-pantheon-devops-specialist` agent has been tested manually but keeps hitting issues in two areas: **DDEV setup** (environment detection, `ddev init` failures, npm recovery) and **CircleCI setup** (project creation, API slug format, settings API). The existing plan (`starry-splashing-snowglobe.md`) made 8 changes to improve robustness — most already committed in `d5c6cf8` and `e771e96`. Now we need a structured, repeatable testing approach using **beads** to track progress through 5 test phases.

## Test Parameters

- **Pantheon repo**: `ssh://codeserver.dev.dc524cf2-19c7-40af-a5b4-842a85440736@codeserver.dev.dc524cf2-19c7-40af-a5b4-842a85440736.drush.in:2222/~/repository.git`
- **New repo name**: `ucsf-siren-network`
- **Team**: `kanopicode` only
- **Agent file**: `agents/drupal-pantheon-devops-specialist/AGENT.md`

## Files to Modify

- `agents/drupal-pantheon-devops-specialist/AGENT.md` — Gate validation improvements
- `.beads/issues.jsonl` — New test-tracking issues via `bd create`

---

## Step 1: Create Beads Issues for All 5 Test Phases

Create 25 beads issues using `bd create` to track each test checkpoint. Issues are organized into 5 phases (A-E), each with a `-FIX` collector issue for agent changes discovered during testing.

### Phase A: Pre-Flight & Git/GitHub Setup (3 issues)

```bash
bd create "Phase A: Validate pre-flight checks (git, gh, terminus, circleci)"
bd create "Phase A: Validate git clone + GitHub repo creation for ucsf-siren-network"
bd create "Phase A: Validate GitHub repo config (squash merge, team, branch protection)"
```

### Phase B: Pantheon Config & DDEV Setup (6 issues) — HIGH RISK

```bash
bd create "Phase B: Validate Terminus auth and Pantheon services (Redis, New Relic, UUID)"
bd create "Phase B: Validate DDEV config creation (4.1a) — PHP/DB version detection"
bd create "Phase B: Validate Kanopi DDEV add-on install (4.1b) — host commands exist"
bd create "Phase B: Validate DDEV project-configure (4.1c) + Gate 3B — env vars, nginx, load-config.sh"
bd create "Phase B: Validate ddev init (4.1d) + Gate 4A — composer, db-refresh, npm recovery"
bd create "Phase B-FIX: Track DDEV-related agent changes discovered during testing"
```

### Phase C: Local Validation & Module Setup (4 issues)

```bash
bd create "Phase C: Validate browser check (4.1e) — Chrome DevTools MCP"
bd create "Phase C: Validate Redis/PAPC module install (4.1f) — decoupled from browser"
bd create "Phase C: Validate Cypress test run (4.1g) — users, flood clear, system-checks"
bd create "Phase C: Validate Solr conditional setup (4.1h)"
```

### Phase D: Code Changes Bulk (5 issues)

```bash
bd create "Phase D: Validate Composer deps and scripts (4.2)"
bd create "Phase D: Validate config files and file operations (4.3-4.12)"
bd create "Phase D: Validate modules, README, CLAUDE.md (4.13-4.15) + Gate 4B"
bd create "Phase D: Validate local browser check + commit (4.16-4.17)"
bd create "Phase D-FIX: Track code-change agent issues"
```

### Phase E: CircleCI & PR (7 issues) — HIGH RISK

```bash
bd create "Phase E: Validate branch push (5.1)"
bd create "Phase E: Validate CircleCI project creation (5.2) — manual + API poll with github/ slug"
bd create "Phase E: Validate CircleCI settings API (5.3) — autocancel + pr_only_build"
bd create "Phase E: Validate CircleCI schedule creation (5.4) — verify response has ID"
bd create "Phase E: Validate PR creation + Gate 5 (5.5)"
bd create "Phase E: Validate final checklist output (5.6)"
bd create "Phase E-FIX: Track CircleCI-related agent changes"
```

---

## Step 2: AGENT.md Validation Improvements (Before Testing)

These changes strengthen the gate validation system to catch issues earlier.

### Change A: Gate 3B — Make THEME blocking and validate HOSTING_ENV value (~line 1900)

**Current Gate 3B check 3** says THEME path is non-blocking. But if the theme path is wrong, `ddev theme-install`, `ddev theme-build`, and CircleCI theme compilation all fail silently downstream.

**Replace Gate 3B check 3:**
```
| 3 | THEME path is set | `Grep(pattern="THEME=", path=".ddev/scripts/load-config.sh")` | No |
```
**With:**
```
| 3 | THEME path is set and valid | `Grep(pattern="THEME=", path=".ddev/scripts/load-config.sh")` then `Glob(pattern="{detected-theme-path}/*.info.yml")` to confirm theme exists | **Yes** |
```

**Add new Gate 3B check 6** — validate HOSTING_ENV is reachable:
```
| 6 | HOSTING_ENV accessible on Pantheon | `terminus env:info {pantheon-site}.{hosting-env}` | No |
```

### Change B: Gate 4A — Make Drupal bootstrap blocking (~line 1912)

**Current** check 2 says Drupal bootstrap is non-blocking. But steps 4.1f (drush en redis) and 4.1g (drush cypress-users) both require a working bootstrap. If bootstrap fails, these steps fail silently.

**Replace Gate 4A check 2:**
```
| 2 | Drupal bootstrap works | `ddev drush status --field=bootstrap` | No |
```
**With:**
```
| 2 | Drupal bootstrap works | `ddev drush status --field=bootstrap` — must return "Successful" | **Yes** |
```

**Update the "On FAIL" text:**
```
**On FAIL (blocking):** DDEV is not running or Drupal cannot bootstrap. Check `ddev logs` for PHP errors. Verify database was imported by `ddev db-refresh`. If bootstrap fails, steps 4.1f and 4.1g (drush commands) will also fail — do not proceed until bootstrap is working.
```

### Change C: Step 5.2 — Add retry loop for CircleCI API polling (~line 1539)

**Current** code does a single curl check. If CircleCI project is still initializing, it gets 404 and has no retry.

**Replace the polling section with:**
```markdown
2. **Poll to verify** the project exists (use `github/` slug, NOT `gh/`). Retry up to 6 times with 10-second waits:
   ```bash
   curl -s -o /dev/null -w "%{http_code}" \
     "https://circleci.com/api/v2/project/github/kanopi/{repo-name}" \
     -H "Circle-Token: $CIRCLECI_TOKEN"
   ```
   - If returns **200**, project is ready. Proceed.
   - If returns **404**, wait 10 seconds and retry (up to 6 attempts = 60 seconds total).
   - If still 404 after 6 attempts, prompt the user: "CircleCI project not found via API yet. Please verify the project was created and try again."
```

### Change D: Step 5.3 — Validate API response codes (~line 1558)

**After each PATCH call, add validation:**
```markdown
Check the HTTP response code. If not 200:
- Record the failure in the gate warnings
- Add to manual follow-up checklist: "Configure auto-cancel / PR-only builds via CircleCI web UI → Project Settings → Advanced"
```

### Change E: Step 5.4 — Validate schedule response body (~line 1578)

**After the POST call, add:**
```markdown
Parse the response JSON. Verify:
- Response contains an `"id"` field (schedule was created successfully)
- `"name"` matches "Automated Updates"

If the response does not contain an `"id"`, report: "Schedule creation failed. Add as manual follow-up: Create weekly schedule via CircleCI web UI → Project Settings → Triggers."
```

### Change F: Gate 4B — Validate all CircleCI config placeholders (~line 1930)

**Add new Gate 4B check 10:**
```
| 10 | No unreplaced placeholders in CircleCI config | `Grep(pattern="\\{.*\\}", path=".circleci/config.yml")` — should return no matches (all `{variable}` placeholders must be substituted) | **Yes** |
```

---

## Step 3: Testing Execution Strategy

### Execution Order

Run phases A → B → C → D → E sequentially. Each phase depends on the prior phase.

### Within Each Phase

1. `bd update <id> --status in_progress` for all phase issues
2. Run the agent for that phase's steps (instruct it to stop after the phase)
3. Verify success criteria for each issue
4. If a step fails: note in the `-FIX` issue, update AGENT.md, commit, re-test that step
5. `bd close <id>` for passing issues
6. Only proceed to next phase when all blocking issues pass

### Phase-Specific Testing Approach

**Phase A** — Run full agent, stop after Gate 2. Quick, low risk.

**Phase B** — This is the critical phase. Run steps 3.1-3.5, then 4.1a-4.1d. Watch for:
- Does `terminus env:info {site}.live` succeed or fall back to `dev`?
- What are the exact placeholder strings in `.ddev/nginx_full/nginx-site.conf`?
- Does `ddev init` complete all 9 sub-steps? Which ones fail?
- If npm recovery triggers, does it fix the issue?

**Phase C** — Continue from Phase B. Watch for:
- Does agent proceed to 4.1f even if 4.1e browser check fails?
- Does flood table clear prevent Cypress login lockout?

**Phase D** — Continue from Phase C. Mostly file operations, lower risk. Watch for:
- CircleCI config has Pantheon site name (not GitHub repo name)
- No `{variable}` placeholders left unreplaced

**Phase E** — Continue from Phase D. Watch for:
- API uses `github/kanopi/ucsf-siren-network` not `gh/kanopi/ucsf-siren-network`
- CircleCI project poll succeeds after user creates project
- Schedule POST returns an `id`

### Reset Procedures

**Full reset (start over from Phase A):**
1. User deletes `kanopi/ucsf-siren-network` GitHub repo manually
2. `gh api orgs/kanopi/teams/ucsf-siren-network -X DELETE` (if team was created)
3. Delete CircleCI project via web UI (if created)
4. `ddev stop && ddev delete -O` (if DDEV was started)
5. Remove local clone directory
6. Remove `/tmp/drupal-starter`

**Phase B reset only (re-test DDEV):**
1. `ddev stop && ddev delete -O`
2. `rm -rf .ddev/`
3. `git checkout feature/kanopi-devops && git reset --hard HEAD`

---

## Verification

After all 5 phases pass:

1. All 25 beads issues are closed (`bd list` shows all closed)
2. The `-FIX` issues document what agent changes were needed
3. GitHub repo `kanopi/ucsf-siren-network` exists with correct config
4. PR exists with passing CircleCI checks (or documented failures)
5. DDEV local environment works (`ddev init` completes without errors)
6. Run `bats tests/test-plugin.bats` to ensure no structural regressions
7. Commit all AGENT.md improvements discovered during testing
