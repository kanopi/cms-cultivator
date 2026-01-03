# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- TBD

### Changed
- TBD

## [0.4.1] - 2026-01-02

Bugfix for calling agents.

## [0.4.0] - 2026-01-02

### Added - Agent-Based Architecture 🤖

**8 Specialist Agents** - Autonomous agents that orchestrate complex workflows:

**Leaf Specialists** (work independently):
- **accessibility-specialist** - WCAG 2.1 Level AA compliance audits
  - Skills: `accessibility-checker`
  - Commands: `/audit-a11y`
- **performance-specialist** - Core Web Vitals and optimization analysis
  - Skills: `performance-analyzer`
  - Commands: `/audit-perf`
- **security-specialist** - OWASP Top 10 vulnerability scanning
  - Skills: `security-scanner`
  - Commands: `/audit-security`
- **documentation-specialist** - API documentation, guides, changelogs
  - Skills: `documentation-generator`
  - Commands: `/docs-generate`
- **code-quality-specialist** - Coding standards and technical debt analysis
  - Skills: `code-standards-checker`
  - Commands: `/quality-analyze`, `/quality-standards`

**Orchestrator Agents** (delegate to other agents):
- **workflow-specialist** - PR workflows, commit messages, code review
  - Skills: `commit-message-generator`
  - Delegates to: testing, security, accessibility (conditional, based on change type)
  - Commands: `/pr-commit-msg`, `/pr-create`, `/pr-review`, `/pr-release`
- **testing-specialist** - Test generation, coverage analysis, test planning
  - Skills: `test-scaffolding`, `test-plan-generator`, `coverage-analyzer`
  - Delegates to: security, accessibility (conditional, for specialized test scenarios)
  - Commands: `/test-generate`, `/test-plan`, `/test-coverage`
- **live-audit-specialist** - Comprehensive live site audits (pure orchestrator)
  - Skills: none (delegates all work)
  - Delegates to: performance, accessibility, security, code-quality (always, in parallel)
  - Commands: `/audit-live-site`

**Testing Infrastructure**:
- **35 new BATS tests** validating agent structure, frontmatter, skills mapping, and integration
  - Total BATS tests: 86 (100% passing)
  - Agent directory structure validation
  - Agent frontmatter validation (YAML, required fields)
  - Skills mapping verification (leaf specialists vs orchestrators)
  - Command-to-agent integration validation
- **80 runtime integration test cases** in `tests/test-agents/`
  - Leaf specialist tests (20 cases): spawn, skill access, no-delegation, output validation
  - Orchestrator tests (13 cases): conditional/always delegation, parallel execution, synthesis
  - Skills access tests (10 cases): loading behavior, mapping, isolation
  - Orchestration tests (10 cases): Task tool usage, delegation logic, failure handling
  - Output format tests (27 cases): structure standards, quality scoring (40-point scale)
- **Test documentation suite**:
  - `tests/agent-integration-tests.md` - Main testing guide
  - `tests/test-agents/README.md` - Quick start and overview
  - `tests/test-agents/01-leaf-specialists.md` - Leaf specialist test procedures
  - `tests/test-agents/02-orchestrators.md` - Orchestrator test procedures
  - `tests/test-agents/03-skills-access.md` - Skills integration tests
  - `tests/test-agents/04-orchestration.md` - Delegation pattern tests
  - `tests/test-agents/05-output-formats.md` - Output validation tests
  - `tests/test-agents/test-results-template.log` - Results tracking template

**Skill Enhancements**:
- **Skill template system** for documentation-generator and test-scaffolding
  - `skills/documentation-generator/templates/` - API docs, README, changelog, user guide templates
  - `skills/test-scaffolding/templates/` - Unit, integration, e2e test templates
  - Cleaner skill organization with reusable templates

### Changed - Architecture Transformation

**Command System** - Refactored from execution to orchestration:
- All 14 commands now spawn appropriate specialist agents via Task tool
- Command files reduced to concise interfaces (focus on "when to use" vs "how to do")
- Commands delegate complex logic to agents
- Agents handle all implementation details, CMS-specific patterns, and output generation
- Average command size reduction: ~60-70% (agents handle the complexity)

**Specific Command Updates**:
- `/audit-a11y` - Now spawns accessibility-specialist agent
- `/audit-perf` - Now spawns performance-specialist agent
- `/audit-security` - Now spawns security-specialist agent
- `/audit-live-site` - Now spawns live-audit-specialist (orchestrates 4 specialists in parallel)
- `/pr-commit-msg` - Now spawns workflow-specialist agent
- `/pr-create` - Now spawns workflow-specialist (delegates to testing/security/accessibility as needed)
- `/pr-review` - Now spawns workflow-specialist agent
- `/pr-release` - Now spawns workflow-specialist agent
- `/test-generate` - Now spawns testing-specialist (delegates for security/a11y test scenarios)
- `/test-plan` - Now spawns testing-specialist agent
- `/test-coverage` - Now spawns testing-specialist agent
- `/docs-generate` - Now spawns documentation-specialist agent
- `/quality-analyze` - Now spawns code-quality-specialist agent
- `/quality-standards` - Now spawns code-quality-specialist agent

**Skills System**:
- Skills now scoped to agents (load only when agent uses them, not globally)
- Skills provide isolated knowledge contexts per agent
- Pure orchestrators (live-audit-specialist) have no skills (delegate all work)
- Skill isolation prevents cross-contamination between agents

**Documentation**:
- `docs/agent-skills.md` renamed to `docs/agents-and-skills.md`
- Added comprehensive agent architecture documentation
- Documented orchestration patterns (conditional vs. always-delegate)
- Added delegation flow diagrams
- Updated README with agent architecture overview
- Command documentation now includes "Agent Used" sections

**Plugin Metadata**:
- Updated description to highlight agent orchestration capabilities
- Added agent-related keywords: "agents", "subagents", "agent-skills"
- Plugin version bumped to 0.4.0

**Test Suite**:
- Removed "commands have code examples" test (not applicable to agent-based commands)
- Fixed "commands use Task tool" test (grep -l instead of grep -c)
- Expanded from 52 to 86 BATS tests (+34 tests, -1 removed, +1 fixed)

### Technical Details

**Agent Orchestration Patterns**:
1. **Conditional Delegation** (workflow-specialist, testing-specialist)
   - Analyzes context to determine if delegation is needed
   - Spawns specialists based on code/change type
   - Example: UI changes → spawn accessibility-specialist
2. **Always-Delegate** (live-audit-specialist)
   - Pure orchestrator with no skills
   - Always spawns all 4 leaf specialists in parallel
   - Synthesizes findings into unified report
3. **Parallel Execution**
   - Orchestrators spawn multiple agents simultaneously
   - Reduces overall execution time
   - Example: live-audit spawns 4 specialists at once

**Agent-to-Skill Mapping**:
```
accessibility-specialist    → accessibility-checker
performance-specialist      → performance-analyzer
security-specialist         → security-scanner
testing-specialist          → test-scaffolding, test-plan-generator, coverage-analyzer
workflow-specialist         → commit-message-generator
documentation-specialist    → documentation-generator
code-quality-specialist     → code-standards-checker
live-audit-specialist       → (no skills, pure orchestrator)
```

**Testing Coverage**:
- BATS automated tests: 86 (structure, frontmatter, integration)
- Integration test cases: 80 (runtime behavior, delegation, output)
- Total test validations: 166
- Pass rate: 100% (all BATS tests passing)

### Migration Notes

**No Breaking Changes** - This is a major architectural refactor with 100% backward compatibility:
- All 14 slash commands work identically from user perspective
- Agent implementation is transparent to users
- Same input → same output behavior
- No changes to command syntax or arguments

**What Changed Under the Hood**:
- Commands spawn agents instead of executing directly
- Agents orchestrate complex workflows via delegation
- Skills scoped to agents (no global auto-triggering)
- Improved parallel execution for comprehensive audits

**For Plugin Developers**:
- New `agents/` directory structure
- Agent files use AGENT.md with YAML frontmatter
- Agents have access to Task tool for delegation
- Skills referenced in agent frontmatter
- Test suite expanded to validate agent architecture

### Benefits of Agent Architecture

**For Users**:
- Faster comprehensive audits (parallel specialist execution)
- More consistent output quality (specialist expertise)
- Better orchestration of complex workflows
- Transparent - no changes to command usage

**For Developers**:
- Modular, composable design (agents are reusable)
- Clear separation of concerns (one agent, one responsibility)
- Easier to test and maintain
- Extensible - easy to add new specialists

**Technical**:
- Progressive disclosure via agent delegation
- Efficient context usage (skills load only when needed)
- Clean orchestration patterns
- Explicit delegation paths (no magic)

## [0.3.1] - 2025-11-10

### Added
- Live Site Auditing documentation to navigation (docs/commands/live-site-auditing.md)
- Agent Skills best practices section in CLAUDE.md
  - Good vs. bad skill description examples
  - Key elements of effective skill descriptions
  - Skill vs. Command decision guide

### Changed
- Updated file organization diagram in CLAUDE.md to reflect current structure

### Fixed
- MkDocs navigation now includes all command documentation pages

## [0.3.0] - 2025-11-10

### Added
- **9 Agent Skills** - Model-invoked automatic assistance during conversation
  - `commit-message-generator` - Auto-generate commit messages when user mentions committing
  - `code-standards-checker` - Auto-check coding standards when user asks about code style
  - `test-scaffolding` - Auto-generate test boilerplate when user needs tests
  - `documentation-generator` - Auto-generate docs when user mentions documentation
  - `test-plan-generator` - Auto-generate QA test plans when user asks what to test
  - `accessibility-checker` - Auto-check accessibility when user asks "is this accessible?"
  - `performance-analyzer` - Auto-analyze performance when user mentions "slow" or "optimize"
  - `security-scanner` - Auto-scan for vulnerabilities when user asks "is this secure?"
  - `coverage-analyzer` - Auto-analyze test coverage when user asks "what's not tested?"
- **Natural Language Support** - Talk to Claude naturally, no need to remember command names
- **Hybrid Architecture** - Both explicit commands and automatic Agent Skills
- **Comprehensive Agent Skills Documentation** - Complete guide at `docs/agent-skills.md`
- `/audit-live-site [url]` - New comprehensive live website auditing command using Chrome DevTools MCP
  - Automated multi-page discovery and intelligent prioritization
  - Performance analysis with Core Web Vitals
  - Accessibility testing (WCAG 2.1 Level AA)
  - SEO analysis and best practices
  - Security scanning and SSL validation
  - Responsive design testing
  - Executive summary reports with actionable recommendations

### Changed
- **Architecture Refactoring** - "Skills as Engine, Commands as Interface" pattern
  - Commands now reference Agent Skills for detailed workflows (72% size reduction)
  - Skills are single source of truth for implementation details
  - Commands provide quick start guides and link to skills
  - Eliminates duplication between commands and skills (was 60-80% duplicated)
- **BREAKING**: Consolidated audit commands with new naming convention `audit-[category]`
- `/a11y-audit` → `/audit-a11y [mode]` - Consolidated 5 accessibility commands into 1
  - Modes: default (full audit), `contrast`, `aria`, `headings`, `forms`, `alt-text`, `keyboard`, `checklist`, `report`, `fix`
- `/perf-performance-audit` → `/audit-perf [mode]` - Consolidated 5 performance commands into 1
  - Modes: default (full audit), `queries`, `n+1`, `assets`, `bundles`, `caching`, `lcp`, `fid`, `inp`, `cls`, `lighthouse`, `report`
- `/security-audit` → `/audit-security [mode]` - Consolidated 3 security commands into 1
  - Modes: default (full audit), `deps`, `secrets`, `permissions`, `report`
- `/pr-create` now generates PR descriptions inline (previously required separate `/pr-desc` step)
- `/pr-review` now includes size/complexity analysis and breaking change detection (previously separate `/pr-analysis`)
- Updated command count from 25 to 14 commands total
- Updated plugin description to highlight Agent Skills
- Updated all documentation (README, docs, quick-start) to show both natural language and explicit commands

### Removed
- **PR Workflow**: `/pr-desc`, `/pr-analysis` (merged into `/pr-create` and `/pr-review`)
- **Accessibility**: `/a11y-audit`, `/a11y-check`, `/a11y-checklist`, `/a11y-report`, `/fix-a11y-issues` (consolidated into `/audit-a11y`)
- **Performance**: `/perf-performance-audit`, `/perf-lighthouse-report`, `/perf-performance-report`, `/perf-analyze`, `/perf-vitals` (consolidated into `/audit-perf`)
- **Security**: `/security-audit`, `/security-scan`, `/security-report` (consolidated into `/audit-security`)

### Migration Guide
```bash
# Old commands → New commands

# Accessibility
/a11y-audit              → /audit-a11y
/a11y-check contrast     → /audit-a11y contrast
/a11y-checklist          → /audit-a11y checklist
/a11y-report             → /audit-a11y report
/fix-a11y-issues         → /audit-a11y fix

# Performance
/perf-performance-audit  → /audit-perf
/perf-analyze queries    → /audit-perf queries
/perf-vitals lcp         → /audit-perf lcp
/perf-lighthouse-report  → /audit-perf lighthouse
/perf-performance-report → /audit-perf report

# Security
/security-audit          → /audit-security
/security-scan secrets   → /audit-security secrets
/security-report         → /audit-security report

# PR Workflow
/pr-desc                 → /pr-create (auto-generates description)
/pr-analysis             → /pr-review (includes analysis)
```

## [0.1.0] - 2025-10-13

### Added
- Initial release of CMS Cultivator Claude Code plugin
- **25 Specialized Commands** for Drupal and WordPress development
- **PR Workflow Commands (6)**:
  - `/pr-desc` - Generate PR descriptions from git changes
  - `/pr-create-pr` - Create pull requests with generated descriptions
  - `/pr-review` - Review existing pull requests
  - `/pr-commit-msg` - Generate conventional commit messages
  - `/pr-analysis` - Analyze PR size, breaking changes, and generate test plan
  - `/pr-release` - Generate changelog, deployment checklist, and update PR
- **Accessibility Commands (5)**:
  - `/a11y-audit` - Comprehensive WCAG 2.1 Level AA audits
  - `/a11y-report` - Generate compliance reports
  - `/a11y-checklist` - WCAG compliance checklists
  - `/a11y-check` - Check specific accessibility aspects (contrast, aria, keyboard, etc.)
  - `/fix-a11y-issues` - Generate accessibility fixes
- **Performance Commands (5)**:
  - `/perf-performance-audit` - Comprehensive performance analysis
  - `/perf-lighthouse-report` - Lighthouse audits
  - `/perf-performance-report` - Executive performance reports
  - `/perf-analyze` - Analyze performance aspects (queries, assets, caching, etc.)
  - `/perf-vitals` - Check and optimize Core Web Vitals (LCP, FID, CLS)
- **Security Commands (3)**:
  - `/security-audit` - Comprehensive security audit (OWASP Top 10)
  - `/security-scan` - Scan for vulnerabilities, secrets, and permissions
  - `/security-report` - Generate security compliance report
- **Documentation Commands (1)**:
  - `/docs-generate` - Generate documentation (API, README, guides, changelog)
- **Testing Commands (3)**:
  - `/test-generate` - Generate test scaffolding (unit, integration, e2e, data)
  - `/test-coverage` - Analyze test coverage
  - `/test-plan` - Generate comprehensive QA test plan
- **Code Quality Commands (2)**:
  - `/quality-analyze` - Analyze code quality (refactoring, complexity, technical debt)
  - `/quality-standards` - Check code against standards (PHPCS, ESLint, Drupal/WordPress)
- **Platform Support**:
  - Full Drupal CMS detection and optimization
  - Full WordPress CMS detection and optimization
  - Platform-aware command suggestions
- **Quality Assurance**:
  - WCAG 2.1 Level AA compliance focus
  - Core Web Vitals monitoring and optimization
  - OWASP Top 10 security scanning
- **Integration**:
  - Kanopi DDEV add-on support
  - Composer scripts integration
  - GitHub CLI (gh) integration for PR workflows
- **Documentation**:
  - Complete MkDocs documentation site
  - Command reference with examples
  - Kanopi tools integration guide
  - Contributing guidelines
- **Testing**:
  - BATS test suite with 54 tests
  - Automated validation via GitHub Actions
  - Command structure and frontmatter validation
- **Licensing**:
  - GPL-2.0-or-later license (Drupal-compatible)

[Unreleased]: https://github.com/kanopi/cms-cultivator/compare/0.4.0...HEAD
[0.4.0]: https://github.com/kanopi/cms-cultivator/compare/0.3.1...0.4.0
[0.3.1]: https://github.com/kanopi/cms-cultivator/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/kanopi/cms-cultivator/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/kanopi/cms-cultivator/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/kanopi/cms-cultivator/releases/tag/0.1.0
