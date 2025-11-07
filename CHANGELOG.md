# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Removed
- `/pr-desc` - Functionality merged into `/pr-create` command
- `/pr-analysis` - Functionality merged into `/pr-review` command
- `/a11y-check` - Merged into `/a11y-audit` as focus areas
- `/a11y-checklist` - Merged into `/a11y-audit checklist` mode
- `/a11y-report` - Merged into `/a11y-audit report` mode
- `/fix-a11y-issues` - Merged into `/a11y-audit fix` mode

### Changed
- `/pr-create` now generates PR descriptions inline (previously required separate `/pr-desc` step)
- `/pr-review` now includes size/complexity analysis and breaking change detection (previously separate `/pr-analysis`)
- `/a11y-audit` now consolidated with multiple modes:
  - Default mode: Full WCAG 2.1 AA audit
  - Focus modes: `contrast`, `aria`, `headings`, `forms`, `alt-text`, `keyboard`
  - Special modes: `checklist`, `report`, `fix`
- Updated command count from 25 to 19 commands (6→4 PR commands, 5→1 A11y commands)

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

[Unreleased]: https://github.com/kanopi/cms-cultivator/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/kanopi/cms-cultivator/releases/tag/v0.1.0
