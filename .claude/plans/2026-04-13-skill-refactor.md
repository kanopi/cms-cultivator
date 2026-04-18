# CMS Cultivator v1.0 Restructuring Plan

## Context

CMS Cultivator 0.9.x built up 27 slash commands + 20 skills + 18 agents over time, resulting in significant overlap (commands that duplicate skill functionality), outdated architecture (commands where skills now handle the same job), and a developer-only mental model. The goal is to:

1. Remove slash commands that are superseded by skills or have no meaningful side effects
2. Convert remaining command functionality into skills using the plugin-dev:skill-development workflow
3. Design skills for portability — all user types (sales, PM, QA, developer) across Claude Desktop, Claude.ai/Cowork, and Claude Code
4. Apply a **two-tier pattern** to complex skills: Tier 1 (portable, works anywhere) + Tier 2 (Claude Code enhanced with MCP/bash)
5. Fix agent best-practices gaps (empty `skills:[]` arrays, description quality)
6. Overhaul all documentation to match the new architecture
7. Bump to v1.0.0 as a breaking change

---

## Phase 1: Command Classification

### Keep (8 commands — irreversible or high side-effects)

| Command | Reason to Keep |
|---|---|
| `devops-setup.md` | 5-phase irreversible DevOps setup, GitHub/Pantheon writes |
| `drupal-cleanup.md` | Destructive `~/.cache/` filesystem operations |
| `drupal-contribute.md` | Orchestrates external git push + browser workflow |
| `drupal-issue.md` | Browser automation + clipboard, no API write access |
| `drupal-mr.md` | Git push to git.drupalcode.org |
| `pr-create.md` | Creates GitHub PR (external artifact, requires confirmation) |
| `pr-release.md` | Release workflow — version bumps, changelog, tag creation |
| `wp-add-skills.md` | Plugin installation to `~/.claude/skills/`, destructive |

### Remove (10 commands — already covered by existing skills)

| Command | Replaced By |
|---|---|
| `audit-gtm.md` | `gtm-performance-audit` skill |
| `audit-structured-data.md` | `structured-data-analyzer` skill |
| `design-validate.md` | `browser-validator` skill |
| `docs-generate.md` | `documentation-generator` skill |
| `pr-commit-msg.md` | `commit-message-generator` skill |
| `quality-standards.md` | `code-standards-checker` skill |
| `teamwork.md` | `teamwork-task-creator` + `teamwork-integrator` + `teamwork-exporter` skills |
| `test-coverage.md` | `coverage-analyzer` skill |
| `test-generate.md` | `test-scaffolding` skill |
| `test-plan.md` | `test-plan-generator` skill |

### Convert to Skills (9 commands → new skills, two-tier where applicable)

| Command | New Skill | Notes |
|---|---|---|
| `audit-a11y.md` | `accessibility-audit` | Comprehensive; two-tier |
| `audit-perf.md` | `performance-audit` | Comprehensive; two-tier |
| `audit-security.md` | `security-audit` | Comprehensive; two-tier |
| `audit-live-site.md` | `live-site-audit` | Orchestrator; two-tier; key for non-devs |
| `quality-analyze.md` | `quality-audit` | Comprehensive; two-tier |
| `design-to-block.md` | `design-to-wp-block` | Claude Code enhanced (Figma MCP) |
| `design-to-paragraph.md` | `design-to-drupal-paragraph` | Claude Code enhanced |
| `pr-review.md` | `pr-review` | Two-tier; no external side effects |
| `export-audit-csv.md` | `audit-export` | Portable; PM/sales use case |

---

## Phase 2: New & Enhanced Skills

### Two-Tier Pattern (apply to all comprehensive audit skills)

Every Tier 1/2 skill follows this structure in its `SKILL.md`:

```markdown
## Environment Detection

**Tier 1 — Portable** (Claude Desktop, Claude.ai, Cowork):
Works with code, HTML, or URLs pasted into the conversation.
Provides structured analysis framework + manual testing guidance.

**Tier 2 — Claude Code Enhanced**:
Uses Chrome DevTools MCP, bash tools, and specialist agents for
automated comprehensive analysis.
```

### Skills to Create (10 new skills)

#### From converted commands (developer + non-developer audience)

1. **`accessibility-audit`** — Two-tier. Comprehensive WCAG 2.1 AA audit.  
   - Tier 1: Analyze pasted HTML/templates; checklist-based manual guidance  
   - Tier 2: Chrome DevTools MCP + `accessibility-specialist` agent  
   - Trigger terms: "audit accessibility", "full accessibility check", "WCAG audit", "accessibility report"  
   - _Distinct from `accessibility-checker` (quick, conversational)_

2. **`performance-audit`** — Two-tier. Core Web Vitals + code optimization.  
   - Tier 1: Analyze pasted code/config; LCP/INP/CLS guidance  
   - Tier 2: Chrome DevTools performance traces + `performance-specialist` agent  
   - Trigger terms: "audit performance", "Core Web Vitals report", "performance analysis"

3. **`security-audit`** — Two-tier. OWASP Top 10 vulnerability scan.  
   - Tier 1: Analyze pasted code for common vulnerabilities  
   - Tier 2: Full codebase scan via `security-specialist` agent  
   - Trigger terms: "security audit", "vulnerability scan", "OWASP check"

4. **`quality-audit`** — Two-tier. Code complexity + technical debt.  
   - Tier 1: Analyze pasted code for complexity patterns  
   - Tier 2: Full codebase via `code-quality-specialist` agent + PHPCS/ESLint  
   - Trigger terms: "code quality audit", "technical debt", "complexity analysis"

5. **`live-site-audit`** — Two-tier. Multi-dimensional URL-based site audit. **Key for non-devs.**  
   - Tier 1: Guided manual checklist for a URL; exports findings as structured list  
   - Tier 2: Orchestrates `accessibility-specialist` + `performance-specialist` + `security-specialist` + `code-quality-specialist` in parallel via Chrome DevTools  
   - Trigger terms: "audit this site", "check [url]", "site health", "full audit of", "analyze this website"  
   - _Target: sales, PM, QA — no code knowledge required_

6. **`design-to-wp-block`** — Claude Code enhanced (needs Figma MCP or screenshot).  
   - Converts Figma URL or screenshot → WordPress block pattern  
   - Trigger terms: "create a block from this design", "Figma to WordPress block", "implement this as a block"

7. **`design-to-drupal-paragraph`** — Claude Code enhanced.  
   - Converts design → Drupal paragraph type (YAML + Twig)  
   - Trigger terms: "create a paragraph type", "Figma to Drupal", "implement this as a paragraph"

8. **`pr-review`** — Two-tier. Code review for quality/security/accessibility.  
   - Tier 1: Analyze pasted diff or file changes  
   - Tier 2: `gh pr diff` + parallel specialist agents  
   - Trigger terms: "review this PR", "review my changes", "code review", "look at this diff"

9. **`audit-export`** — Portable. Formats audit findings for PM tools.  
   - Parses markdown audit output → CSV or Teamwork-compatible format  
   - Trigger terms: "export these findings", "create tasks from this audit", "audit to CSV", "export to Teamwork"  
   - _Target: PMs and sales — no code knowledge required_

#### New for non-developer audience

10. **`audit-report`** — Portable. Generates client-facing executive summaries.  
    - Transforms technical audit findings → plain-language reports with priority recommendations  
    - Trigger terms: "client report", "executive summary", "stakeholder report", "summarize these findings for the client", "non-technical summary"  
    - _Target: sales, account managers, PMs_

### Existing Skills to Review (20 skills — description + best-practice audit)

Using `plugin-dev:skill-reviewer` on each:
- Verify trigger descriptions are specific and precise (no false positives/negatives)
- Confirm `name` field matches directory name
- Add any missing portability notes where relevant
- Update `strategic-thinking` trigger to be less broad

Priority reviews (most-used, highest trigger overlap risk):
`accessibility-checker`, `performance-analyzer`, `security-scanner`, `gtm-performance-audit`, `structured-data-analyzer`, `teamwork-task-creator`

---

## Phase 3: Agent Best Practices

### Issues Across All 18 Agents

**Problem 1: Empty `skills:[]` arrays**  
All agents have `skills: []`. Per CLAUDE.md, agents should reference the skills they use. Populate:

| Agent | Skills to Add |
|---|---|
| `accessibility-specialist` | `accessibility-checker`, `accessibility-audit` |
| `performance-specialist` | `performance-analyzer`, `performance-audit` |
| `security-specialist` | `security-scanner`, `security-audit` |
| `code-quality-specialist` | `code-standards-checker`, `quality-audit` |
| `live-audit-specialist` | `live-site-audit`, `audit-report` |
| `workflow-specialist` | `commit-message-generator`, `pr-review` |
| `design-specialist` | `design-analyzer`, `design-to-wp-block`, `design-to-drupal-paragraph`, `responsive-styling` |
| `browser-validator-specialist` | `browser-validator` |
| `documentation-specialist` | `documentation-generator` |
| `testing-specialist` | `test-scaffolding`, `test-plan-generator`, `coverage-analyzer` |
| `teamwork-specialist` | `teamwork-task-creator`, `teamwork-integrator`, `teamwork-exporter` |
| `gtm-specialist` | `gtm-performance-audit` |
| `structured-data-specialist` | `structured-data-analyzer` |
| `responsive-styling-specialist` | `responsive-styling` |
| `drupalorg-issue-specialist` | `drupalorg-issue-helper` |
| `drupalorg-mr-specialist` | `drupalorg-contribution-helper` |

**Problem 2: Description specificity**  
Review each agent description against the "good description" examples in CLAUDE.md. Add specific trigger terms and invocation conditions.

**Problem 3: Model selection**  
All agents use `sonnet`. Agents doing pure orchestration or lightweight tasks should consider `haiku`:
- `drupalorg-issue-specialist` (read-only, clipboard operations) → `haiku`
- `drupalorg-cleanup` actions are command-only, not agents

**Problem 4: `live-audit-specialist` content/frontmatter mismatch**  
AGENT.md body references `strategic-thinking` skill but frontmatter `skills: []`. Fix by adding `strategic-thinking` to skills array.

---

## Phase 4: Documentation Overhaul

### `/docs/` Structure Changes

**New structure:**
```
docs/
├── index.md                    # Skills-first landing; audience nav
├── installation.md             # Updated for v1.0
├── quick-start.md              # Updated: lead with skills
├── by-role/                    # NEW: audience-based guides
│   ├── developers.md           # Dev-focused skills + Claude Code features
│   ├── project-managers.md     # Teamwork, audit-export, live-site-audit
│   └── sales-and-clients.md    # live-site-audit, audit-report, site health
├── skills/                     # RENAMED from commands/ (reorganized)
│   ├── index.md                # Full skills catalog
│   ├── auditing.md             # All audit skills
│   ├── code-quality.md         # Quality, standards, security
│   ├── design-to-code.md       # design-to-block, design-to-paragraph
│   ├── pr-workflow.md          # pr-review, commit-message-generator
│   ├── project-management.md   # Teamwork skills, audit-export
│   ├── testing.md              # Test skills
│   └── drupal-contribution.md  # Drupal.org skills
├── commands/                   # KEPT but reduced (8 commands only)
│   ├── index.md                # "For explicit workflows with side effects"
│   ├── pr-create.md
│   ├── pr-release.md
│   ├── devops-setup.md
│   ├── drupal-contribute.md
│   ├── drupal-issue.md
│   ├── drupal-mr.md
│   ├── drupal-cleanup.md
│   └── wp-add-skills.md
├── agents.md                   # Agents reference (was agents-and-skills.md)
├── contributing.md             # Updated with two-tier pattern guide
├── guides/
│   ├── getting-started.md      # Updated for skills-first
│   ├── two-tier-skills.md      # NEW: guide for skill portability
│   └── troubleshooting.md
└── reference/
    └── markdown-style-guide.md
```

### README.md Changes
- Lead stat: "30 skills + 18 agents + 8 commands" (was "20 skills + 27 commands + 17 agents")
- Add "Works in Claude Desktop, Claude.ai, and Claude Code" prominently
- Add by-audience quick-start examples (developer / PM / sales)
- Remove screenshot of slash command interface

### CLAUDE.md Changes
- Update architecture section: commands reduced to side-effect-only
- Add two-tier skill pattern documentation
- Update file counts and inventory
- Add plugin-dev:skill-development workflow to "Adding a New Feature"
- Add "Skill Portability" section

---

## Phase 5: Version & Release

### plugin.json Updates
```json
{
  "version": "1.0.0",
  "description": "30 skills + 18 agents + 8 commands for Drupal/WordPress. Skills work in Claude Desktop, Claude.ai, and Claude Code. Audience-aware: developers, project managers, and non-technical users."
}
```

### CHANGELOG.md Entry
```markdown
## [1.0.0] — 2026-xx-xx

### Breaking Changes
- Removed 19 slash commands (10 superseded by skills, 9 converted to skills)
- Renamed/reorganized documentation structure
- Agents now reference relevant skills in frontmatter

### Added
- 10 new skills: accessibility-audit, performance-audit, security-audit,
  quality-audit, live-site-audit, design-to-wp-block, design-to-drupal-paragraph,
  pr-review, audit-export, audit-report
- Two-tier skill architecture: portable (Claude Desktop) + enhanced (Claude Code)
- By-role documentation: developers, project managers, sales

### Removed  
- 19 slash commands (see migration guide)
```

---

## Skill Creation Workflow (using plugin-dev:skill-development)

For **each of the 10 new skills**, follow this process:

1. **Use `plugin-dev:skill-development` skill** to scaffold the SKILL.md
2. Apply two-tier pattern template where applicable
3. Write precise description with trigger terms, use cases, and "do NOT trigger when" cases
4. **Run `plugin-dev:skill-reviewer`** on the completed skill
5. Write at least 3 evals (trigger scenarios, non-trigger scenarios, output quality)
6. Validate frontmatter with `./scripts/validate-frontmatter.sh`

For **existing skill reviews**, use `plugin-dev:skill-reviewer` against each skill and apply description optimization suggestions.

---

## Implementation Order

1. **Skill creation first** (new skills, using plugin-dev) — unblocks agents update
2. **Agent updates** (populate `skills:[]` arrays after skills exist)
3. **Command removal** (delete 10 redundant commands)
4. **Documentation** (after skills + agents are finalized)
5. **Version bump** (plugin.json, CHANGELOG, README final update)

---

## Critical Files

- `/Users/thejimbirch/Projects/cms-cultivator/.claude-plugin/plugin.json` — version bump
- `/Users/thejimbirch/Projects/cms-cultivator/commands/` — remove 10, keep 8
- `/Users/thejimbirch/Projects/cms-cultivator/skills/` — add 10 new skill directories
- `/Users/thejimbirch/Projects/cms-cultivator/agents/` — update all 18 AGENT.md files
- `/Users/thejimbirch/Projects/cms-cultivator/docs/` — full reorganization
- `/Users/thejimbirch/Projects/cms-cultivator/README.md` — messaging overhaul
- `/Users/thejimbirch/Projects/cms-cultivator/CLAUDE.md` — architecture update
- `/Users/thejimbirch/Projects/cms-cultivator/CHANGELOG.md` — v1.0.0 entry

---

## Verification

1. Run `./scripts/validate-frontmatter.sh` — all skills, agents, and commands pass
2. Run `plugin-dev:skill-reviewer` on each new skill — no description issues
3. Run evals for `live-site-audit`, `audit-report`, `accessibility-audit` (highest non-dev usage)
4. Verify 8 commands load correctly in Claude Code (`/devops-setup`, `/pr-create`, etc.)
5. Verify new skills trigger correctly in Claude Code on sample prompts
6. Test `live-site-audit` and `audit-report` skills with text-only (no MCP) to confirm Tier 1 works
7. Run `zensical build --clean` — zero broken links
8. Run BATS tests: `tests/test-plugin.bats` — update for v1.0 expectations
