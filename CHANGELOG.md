# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- TBD

### Changed
- TBD

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

[Unreleased]: https://github.com/kanopi/cms-cultivator/compare/0.3.0...HEAD
[0.3.0]: https://github.com/kanopi/cms-cultivator/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/kanopi/cms-cultivator/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/kanopi/cms-cultivator/releases/tag/0.1.0
