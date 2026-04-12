# Plan: Integrate GTM Performance Audit into CMS Cultivator

## Context

CMS Cultivator needs a new GTM Performance Audit capability to analyze Google Tag Manager impact on page performance. This adds a skill + agent + command following the existing audit pattern (like audit-perf, audit-security). Chrome DevTools MCP is a hard requirement (no fallback mode). The command uses flexible argument modes matching existing audit commands.

**Current state**: 14 agents (tests expect 14, but 15 actually exist due to teamwork-specialist gap), 24+ commands, 18 skill directories
**Target state**: 16 agents, +1 command, +1 skill directory, all tests passing

## Prerequisites

**Fix `bd` (beads) tool**: The Dolt database backend fails with "binary built without CGO support". User will fix this before implementation begins. Once fixed, we create bd issues for each phase with dependency chains.

---

## bd Issue Tracking

Create the following bd issues with dependencies so each phase blocks the next:

```bash
# Phase 1: Core Skill
bd create "Create GTM performance audit skill" \
  -d "Create skills/gtm-performance-audit/SKILL.md with full workflow phases, Chrome DevTools MCP integration, and GTM-specific analysis criteria" \
  -l "phase-1,skill,gtm" -p 1

# Phase 2a: Agent
bd create "Create GTM specialist agent" \
  -d "Create agents/gtm-specialist/AGENT.md as leaf specialist with mode handling, CMS patterns, and report templates" \
  -l "phase-2,agent,gtm" -p 1 \
  --deps "<phase-1-id>"

# Phase 2b: Command
bd create "Create audit-gtm command" \
  -d "Create commands/audit-gtm.md with flexible argument modes, Task spawn for gtm-specialist, and usage examples" \
  -l "phase-2,command,gtm" -p 1 \
  --deps "<phase-1-id>"

# Phase 3a: Update tests
bd create "Update BATS tests for GTM integration" \
  -d "Update tests/test-plugin.bats: agent count 14→16, add gtm-specialist to expected_agents and leaf_specialists, add 2 new integration tests" \
  -l "phase-3,testing,gtm" -p 1 \
  --deps "<phase-2a-id>,<phase-2b-id>"

# Phase 3b: Plugin metadata
bd create "Update plugin.json for GTM release" \
  -d "Bump version to 0.9.0, update agent/command/skill counts, add gtm keywords" \
  -l "phase-3,metadata,gtm" -p 2 \
  --deps "<phase-2a-id>,<phase-2b-id>"

# Phase 4: Automated test run
bd create "Run automated test suite and fix failures" \
  -d "Run bats tests/test-plugin.bats, verify all tests pass including new GTM tests, fix any failures" \
  -l "phase-4,testing,gtm" -p 0 \
  --deps "<phase-3a-id>,<phase-3b-id>"

# Phase 5: Documentation
bd create "Update documentation for GTM audit" \
  -d "Update docs/commands/overview.md, create docs/commands/gtm-performance.md, update agents-and-skills.md, skills/README.md, zensical.toml, CHANGELOG.md" \
  -l "phase-5,docs,gtm" -p 2 \
  --deps "<phase-4-id>"

# Phase 6: Docs build verification
bd create "Verify documentation builds cleanly" \
  -d "Run zensical build --clean to verify no broken links. Run bats tests again for nav file existence test." \
  -l "phase-6,testing,gtm" -p 1 \
  --deps "<phase-5-id>"
```

---

## Phase 1: Core Skill File

**Create** `skills/gtm-performance-audit/SKILL.md`

Adapt the user's detailed GTM audit spec to match plugin skill conventions:

- **Frontmatter**: `name: gtm-performance-audit`, description with trigger terms ("GTM", "tag manager", "tracking tags slow", "too many tags", "marketing tags")
- **Philosophy / Core Beliefs**: 4 beliefs about GTM performance measurement
- **When This Skill Activates**: Explicit trigger conditions
- **Decision Framework**: Assess audit mode (live page, container JSON + live, container ID)
- **Setup**: Ask user for target URL, GTM container ID, optional container JSON export, critical tags list
- **Phase 1 workflow - Baseline Performance**: Use `mcp__chrome-devtools__evaluate_script` for navigation timing, paint metrics, GTM resource filtering; `mcp__chrome-devtools__list_network_requests` for waterfall; `mcp__chrome-devtools__list_console_messages` for errors; CWV measurement
- **Phase 2 workflow - GTM Container Analysis**: Navigate to tagmanager.google.com via MCP if logged in, or parse container JSON, or infer from network data
- **Phase 3 workflow - Issue Detection**: 14 check categories from user's spec (sync scripts, blocking tags, large payloads, main thread blocking, conditional tags, trigger optimization, duplicates, orphaned tags, expensive variables, missing async, Custom HTML conversion, server-side candidates, consent gaps, firing order)
- **Phase 4 workflow - Report Generation**: Executive summary, quick wins, detailed findings (each with measurement, impact, GTM fix steps, risk assessment), tag inventory table, network waterfall, implementation checklist
- **Required MCP Integration**: List all `mcp__chrome-devtools__*` tools used (evaluate_script, list_network_requests, list_console_messages, navigate_page, take_snapshot, performance_start_trace, performance_stop_trace, new_page)
- **Guardrails**: Read-only (never modify GTM), never enter credentials, conservative estimates

**Verify**: File has valid YAML frontmatter with `name` and `description`

---

## Phase 2: Agent + Command

### 2a. Create `agents/gtm-specialist/AGENT.md`

Leaf specialist pattern (like performance-specialist):

```yaml
---
name: gtm-specialist
description: Use this agent to audit Google Tag Manager implementations for performance impact. Analyzes container configuration, measures tag execution timing, identifies blocking tags, audits custom HTML safety, evaluates trigger efficiency, and maps tag impact to Core Web Vitals.
tools: Read, Glob, Grep, Bash, Write, Edit
skills: gtm-performance-audit
model: sonnet
color: green
---
```

Required sections (enforced by tests):
- **When to Use This Agent** - 3 `<example>` blocks
- **Core Responsibilities** - 6 numbered duties (container analysis, live profiling, tag-level analysis, trigger optimization, CWV impact mapping, remediation planning)
- **Mode Handling** - Depth/scope/format + GTM-specific options
- **File Creation** - `audit-gtm-YYYY-MM-DD-HHMM.md`
- **Tools Available** - List tools
- **Skills You Use** - Reference `gtm-performance-audit`
- **GTM-Specific Patterns** - Drupal (google_tag module) + WordPress (GTM4WP, Google Site Kit) patterns
- **Output Format** - Report templates
- **Commands You Support** - Reference `/audit-gtm`

### 2b. Create `commands/audit-gtm.md`

Follow audit-perf.md pattern exactly:

```yaml
---
description: Comprehensive Google Tag Manager performance audit analyzing container size, tag execution, trigger efficiency, and Core Web Vitals impact
argument-hint: "[options]"
allowed-tools: Task, Bash(git:*)
---
```

Content:
- Task spawn: `Task(cms-cultivator:gtm-specialist:gtm-specialist, prompt="...")`
- **Depth Modes**: `--quick` (container size + tag count), `--standard` (full analysis, default), `--comprehensive` (deep profiling + remediation plan)
- **Scope Control**: `--scope=current-pr`, `--scope=container=<GTM-ID>`, `--scope=entire`
- **Output Formats**: `--format=report`, `--format=json`, `--format=summary`
- **GTM-specific options**: `--container-id=<GTM-XXXX>`, `--with-container-json=<path>`, `--url=<target-url>`
- **Legacy Focus Areas**: `container`, `tags`, `triggers`, `datalayer`, `custom-html`, `consent`
- Usage examples, How It Works, Related Commands

**Verify**: Both files have valid YAML; command references gtm-specialist; agent has Core Responsibilities and Tools sections

---

## Phase 3: Tests + Plugin Metadata

### 3a. Modify `tests/test-plugin.bats`

| Change | Location | Detail |
|--------|----------|--------|
| Agent count 14 → 16 | Lines 272, 286 | Accounts for both teamwork-specialist (existing gap) and gtm-specialist |
| Test name update | Line 284 | `"agent count matches expected (16)"` |
| Add to expected_agents | Lines 289-313 | Add `"gtm-specialist"` and `"teamwork-specialist"` |
| Add to leaf_specialists | Lines 408-416 | Add `"gtm-specialist"` |
| New test | After line ~695 | `"audit-gtm references gtm-specialist"` |
| New test | After skill tests | `"gtm-specialist has gtm-performance-audit skill"` |

### 3b. Modify `.claude-plugin/plugin.json`

- Version: `"0.8.1"` → `"0.9.0"`
- Description: Update counts to "16 specialist agents + 25 commands + 15 skills"
- Keywords: Add `"gtm"`, `"google-tag-manager"`

---

## Phase 4: Automated Test Run

**Run** `bats tests/test-plugin.bats` and verify:

- All existing tests still pass (no regressions)
- New GTM-specific tests pass:
  - `"gtm-specialist"` appears in expected agents
  - `"gtm-specialist"` is classified as leaf specialist (no Task tool)
  - `"audit-gtm references gtm-specialist"` passes
  - `"gtm-specialist has gtm-performance-audit skill"` passes
- Agent count test passes with 16
- Command frontmatter validation passes for audit-gtm.md
- No merge conflicts, TODOs, or debug statements

**If failures**: Fix issues and re-run until all tests pass before proceeding to Phase 5.

---

## Phase 5: Documentation

| File | Action | Changes |
|------|--------|---------|
| `docs/commands/overview.md` | Modify | Add `/audit-gtm [options]` row in Performance section |
| `docs/commands/gtm-performance.md` | Create | Full docs page with flexible modes, CI/CD examples, common workflows |
| `docs/commands/performance.md` | Modify | Add "Related: GTM Performance Audit" cross-reference section |
| `docs/agents-and-skills.md` | Modify | Add gtm-specialist to agent list, gtm-performance-audit to skills list |
| `skills/README.md` | Modify | Add gtm-performance-audit entry with triggers and purpose |
| `zensical.toml` | Modify | Add `"commands/gtm-performance.md"` to Commands nav after performance.md |
| `CHANGELOG.md` | Modify | Add 0.9.0 entry with all new files and changes |

---

## Phase 6: Documentation Build Verification

- Run `zensical build --clean` to verify no broken links
- Run `bats tests/test-plugin.bats` again to verify nav file existence test passes
- Confirm all 12 files are consistent

---

## Files Summary

| Phase | File | Action |
|-------|------|--------|
| 1 | `skills/gtm-performance-audit/SKILL.md` | Create |
| 2 | `agents/gtm-specialist/AGENT.md` | Create |
| 2 | `commands/audit-gtm.md` | Create |
| 3 | `tests/test-plugin.bats` | Modify |
| 3 | `.claude-plugin/plugin.json` | Modify |
| 4 | *Automated test run* | Verify |
| 5 | `docs/commands/overview.md` | Modify |
| 5 | `docs/commands/gtm-performance.md` | Create |
| 5 | `docs/commands/performance.md` | Modify |
| 5 | `docs/agents-and-skills.md` | Modify |
| 5 | `skills/README.md` | Modify |
| 5 | `zensical.toml` | Modify |
| 5 | `CHANGELOG.md` | Modify |
| 6 | *Docs build + final test run* | Verify |

## Existing Patterns to Reuse

- **Skill structure**: `skills/browser-validator/SKILL.md` (Chrome MCP integration pattern)
- **Skill conventions**: `skills/performance-analyzer/SKILL.md` (Philosophy, When to Use, Decision Framework)
- **Agent structure**: `agents/performance-specialist/AGENT.md` (leaf specialist with mode handling)
- **Command structure**: `commands/audit-perf.md` (flexible argument modes, Task spawn)
- **Docs page**: `docs/commands/performance.md` (flexible modes documentation)
