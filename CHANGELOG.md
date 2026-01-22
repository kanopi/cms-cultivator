# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Drupal.org Integration** - New commands and agents for contributing to drupal.org projects
  - `/drupal-issue` - Create, update, or list issues on drupal.org using browser automation
  - `/drupal-mr` - Create or list merge requests on git.drupalcode.org via glab CLI
  - `/drupal-contribute` - Full workflow orchestrator combining issue creation and MR setup
  - `/drupal-cleanup` - List and cleanup cloned repositories in `~/.cache/drupal-contrib/`
  - `drupalorg-issue-specialist` agent - Browser automation for issue management
  - `drupalorg-mr-specialist` agent - Git operations and glab CLI for merge requests
  - `drupalorg-issue-helper` skill - Quick help with issue templates and formatting
  - `drupalorg-contribution-helper` skill - Quick help with git workflow and branch naming
  - Credential storage support at `~/.config/drupalorg/credentials.yml` for auto-login
  - Integration with `drupalorg-cli` tool (https://github.com/mglaman/drupalorg-cli) when available
  - Comprehensive documentation at `docs/drupal-contribution.md`
  - New BATS test file `tests/test-drupalorg-integration.bats` for integration testing

## [0.6.1] - 2026-01-20

### Fixed
- **Workflow Specialist Agent** - Improved user approval workflow
  - Removed deprecated `AskUserQuestion` tool reference
  - Standardized to continuous workflow with formatted output approval pattern
  - Use `=== SECTION READY FOR APPROVAL ===` header format for all outputs
  - Commit messages and PR descriptions now presented as formatted output blocks
  - Users approve by responding naturally, no structured options needed

- **Audit Specialists** - Standardized report file creation
  - All audit specialists now create persistent markdown report files
  - File naming convention: `audit-[type]-YYYY-MM-DD-HHMM.md`
  - Reports saved to current directory or `reports/` subdirectory
  - Executive summary presented to terminal + file path provided
  - Added Write/Edit tools to all specialist agents
  - Commands updated to require file creation in prompts

### Added
- **Markdown Style Guide** - New comprehensive documentation reference
  - Complete guide at `docs/reference/markdown-style-guide.md`
  - Documents proper Zensical rendering patterns
  - Conversion examples for common markdown issues
  - Testing checklist for documentation changes
  - Fixes heading vs. bold text structure issues
  - Referenced in CLAUDE.md, commands/docs-generate.md, and documentation-generator skill

### Changed
- **PR Workflow Commands** - Improved command structure and documentation
  - `/pr-create` - Changed to "How It Works" section with continuous workflow
  - `/pr-release` - Changed to "How It Works" section with continuous workflow
  - Removed confusing "Phase" structure with "DO NOT create yet" language
  - Clarified automated workflow steps happen in single agent invocation
  - Simplified Tool Usage sections with clear prerequisites
  - Agents now generate and present full descriptions before waiting for approval

- **Documentation Formatting** - Better heading hierarchy and list structure
  - Removed shell expansion (!command) from PR workflow commands
  - Updated workflow-specialist prompts to gather git context directly
  - Improved documentation structure in contributing guide
  - Enhanced list formatting in design workflow guide
  - Simplified index page categorization with proper subheadings
  - Better heading structure replaces bold text in nested lists

- **File Creation Requirements** - Standardized across audit commands
  - `/audit-a11y` - Updated to require file creation
  - `/audit-live-site` - Updated to require file creation
  - `/audit-perf` - Updated to require file creation
  - `/audit-security` - Updated to require file creation
  - `/quality-analyze` - Updated to require file creation
  - `/quality-standards` - Updated to require file creation

### Breaking Changes

**BREAKING CHANGE: Audit specialists output format changed**

All audit specialist agents now create persistent report files as primary output instead of terminal-only display. This affects:
- `accessibility-specialist`
- `security-specialist`
- `performance-specialist`
- `code-quality-specialist`
- `live-audit-specialist`

**Migration:** Users relying on terminal-only output will now receive a file path. The executive summary is still displayed to terminal, but full reports are in markdown files.

## [0.6.0] - 2026-01-18

### Added
- **Flexible Argument Modes** - Major feature addition for audit and quality commands
  - **Depth modes:** `--quick` (~5 min), `--standard` (~15 min), `--comprehensive` (~30 min)
  - **Scope control:** `--scope=current-pr`, `--scope=module=<name>`, `--scope=file=<path>`, `--scope=entire`
  - **Output formats:** `--format=report`, `--format=json`, `--format=summary`, `--format=checklist`
  - **Threshold controls:** Command-specific quality gates and severity filters
  - **Backward compatibility:** Legacy focus area arguments still supported (e.g., `/audit-a11y contrast`)

- **Command Enhancements** - 4 commands updated with flexible argument modes:
  - `/audit-a11y [options]` - Accessibility audits with WCAG compliance
    - New: `--quick`, `--standard`, `--comprehensive` depth modes
    - New: `--scope=current-pr|module|file|entire` scope control
    - New: `--format=report|json|summary|checklist` output formats
    - Legacy: Focus areas (`contrast`, `keyboard`, `aria`) still supported

  - `/audit-perf [options]` - Performance audits with Core Web Vitals
    - New: `--quick`, `--standard`, `--comprehensive` depth modes
    - New: `--scope=current-pr|frontend|backend|module|file|entire` scope control
    - New: `--format=report|json|summary|metrics` output formats
    - New: `--target=good|needs-improvement` threshold controls
    - Legacy: Focus areas (`queries`, `assets`, `vitals`, `lcp`) still supported

  - `/audit-security [options]` - Security audits with OWASP Top 10
    - New: `--quick`, `--standard`, `--comprehensive` depth modes
    - New: `--scope=current-pr|user-input|auth|api|module|file|entire` scope control
    - New: `--format=report|json|summary|sarif` output formats (SARIF for security tools)
    - New: `--min-severity=high|medium|low` severity filtering
    - Legacy: Focus areas (`injection`, `xss`, `csrf`, `auth`) still supported

  - `/quality-analyze [options]` - Code quality and technical debt analysis
    - New: `--quick`, `--standard`, `--comprehensive` depth modes
    - New: `--scope=current-pr|recent-changes|module|file|entire` scope control
    - New: `--format=report|json|summary|refactoring-plan` output formats
    - New: `--max-complexity=N`, `--min-grade=A|B|C` quality thresholds
    - Legacy: Focus areas (`complexity`, `debt`, `patterns`) still supported

- **Agent Updates** - 4 specialist agents enhanced with mode handling:
  - **accessibility-specialist** - Added mode handling section with JSON output structure
  - **performance-specialist** - Added mode handling with CWV-specific guidance
  - **security-specialist** - Added mode handling with SARIF format support
  - **code-quality-specialist** - Added mode handling with refactoring plan support

- **Documentation**
  - New comprehensive guide: `docs/guides/using-argument-modes.md`
  - Updated command documentation: `docs/commands/accessibility.md`, `performance.md`, `security.md`, `code-quality.md`
  - Updated README.md with "Flexible Audit Modes" section
  - CI/CD integration examples with GitHub Actions
  - Common workflow recipes (pre-commit, PR review, pre-release)

### Changed
- **Command Frontmatter** - Updated argument hints from `[focus-area]` to `[options]`
- **Allowed Tools** - Added `Bash(git:*)` to audit commands for scope=current-pr support
- **Default Behavior** - Commands without arguments now default to `--standard --scope=entire --format=report`

### Benefits
- ⚡ **Faster development workflow** - Quick checks in ~5 minutes vs 15-30 minutes
- 💰 **Cost control** - Scope limiting reduces token usage significantly
- 🤖 **CI/CD ready** - JSON and SARIF outputs for automated pipelines
- 🎯 **Flexible targeting** - Analyze only what matters (PR files, specific modules, etc.)
- 📊 **Multiple audiences** - Different formats for developers, stakeholders, and tools
- ✅ **Backward compatible** - All existing command usage still works

### Migration Guide
No breaking changes. All existing command usage continues to work:
```bash
# Old syntax still works
/audit-a11y contrast
/audit-perf queries
/audit-security xss

# New syntax available
/audit-a11y --quick --scope=current-pr
/audit-perf --standard --scope=backend --format=json
/audit-security --comprehensive --min-severity=high
```

---

### Added
- **Concise Mode for PR Creation** - New `--concise` flag for `/pr-create` command
  - Generates shorter, more focused PR descriptions for smaller tasks
  - Reduces verbosity while maintaining all required template sections
  - Skips comprehensive specialist checks unless critical issues detected
  - Ideal for simple bug fixes, minor features, and support tickets
  - Usage: `/pr-create PROJ-123 --concise`

### Changed
- **workflow-specialist Agent** - Major improvements to commit and PR workflows
  - **Present FULL content, not summaries** - Users now see complete commit messages and PR descriptions
  - **Removed "Co-Authored-By: Claude..." footer** - No longer adds AI attribution to commits
  - **Next step suggestions** - After commits, suggests running `/pr-create` to create pull request
  - Added argument parsing for `--concise` flag in PR creation
  - Updated approval prompts to be clearer about showing full content
  - Improved PR creation flow to support both standard and concise modes
- **Command Updates**
  - `/pr-commit-msg` - Now shows full message and suggests `/pr-create` as next step
  - `/pr-create` - Added `--concise` flag support and comprehensive mode documentation
  - Updated workflow descriptions to clarify "FULL content" vs "summary" presentation

### Fixed
- **Commit Message Presentation** - Fixed issue where users saw summaries instead of actual messages (pr-commit-msg.md:20)
- **PR Description Presentation** - Fixed issue where users saw summaries instead of full PR content (pr-create.md:28)
- **Co-Authored-By Footer** - Removed unwanted Claude attribution from commit messages (workflow-specialist/AGENT.md:121)

## [0.4.2] - 2026-01-04

### Added
- **User Approval Workflow** - Interactive approval for commit messages and PR descriptions
  - New `AskUserQuestion` integration in workflow-specialist agent
  - Users can now approve or edit generated content before execution
  - Applies to `/pr-commit-msg`, `/pr-create`, and `/pr-release` commands
  - Two-option approval flow: "Approve and proceed" or "Edit content"
  - Ensures explicit user control over all git operations

### Changed
- **workflow-specialist Agent** - Enhanced PR creation and commit workflows
  - Added comprehensive user approval process documentation
  - Updated PR creation flow to present descriptions before execution
  - Added handling for user edits vs. as-is approvals
  - Improved release artifact presentation (changelog, deployment checklist)
- **commit-message-generator Skill** - Updated to support approval workflow
  - Modified workflow to present message for user review
  - Added guidance for handling user edits
  - Removed auto-generated Claude Code footers from commit examples
- **Command Updates** - Enhanced documentation for approval flow
  - `/pr-commit-msg` - Documents approval step in workflow (step 7)
  - `/pr-create` - Documents approval step in PR creation (step 5)
  - `/pr-release` - Documents approval for changelog and deployment checklist

### Improved
- **User Experience** - More control and transparency in git operations
  - Prevents accidental commits with unwanted messages
  - Allows inline editing of PR descriptions before creation
  - Shows preview of generated content before execution
  - Maintains explicit user consent for all git operations

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

[Unreleased]: https://github.com/kanopi/cms-cultivator/compare/0.6.1...HEAD
[0.6.1]: https://github.com/kanopi/cms-cultivator/compare/0.6.0...0.6.1
[0.6.0]: https://github.com/kanopi/cms-cultivator/compare/0.4.2...0.6.0
[0.4.2]: https://github.com/kanopi/cms-cultivator/compare/0.4.1...0.4.2
[0.4.1]: https://github.com/kanopi/cms-cultivator/compare/0.4.0...0.4.1
[0.4.0]: https://github.com/kanopi/cms-cultivator/compare/0.3.1...0.4.0
[0.3.1]: https://github.com/kanopi/cms-cultivator/compare/0.3.0...0.3.1
[0.3.0]: https://github.com/kanopi/cms-cultivator/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/kanopi/cms-cultivator/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/kanopi/cms-cultivator/releases/tag/0.1.0
