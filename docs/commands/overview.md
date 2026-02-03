# Commands Overview

CMS Cultivator provides specialized commands organized into categories. Each command integrates seamlessly with Drupal and WordPress projects.

---

## Command Categories

### 🔄 [PR Workflow](pr-workflow.md)

Streamline pull request creation, review, and deployment.

| Command | Description |
|---------|-------------|
| `/pr-create [ticket]` | Create pull request with generated description |
| `/pr-review [pr-number\|self] [focus]` | Review PR or analyze your own changes (size, breaking changes, test plan) |
| `/pr-commit-msg` | Generate conventional commit messages from staged changes |
| `/pr-release [focus]` | Generate changelog, deployment checklist, and update PR |

---

### ♿ [Accessibility](accessibility.md)

Ensure WCAG 2.1 Level AA compliance and create inclusive experiences.

| Command | Description |
|---------|-------------|
| `/audit-a11y [focus]` | Comprehensive accessibility audit with WCAG 2.1 Level AA compliance |

**Usage modes**:
- `/audit-a11y` - Full audit with detailed findings
- `/audit-a11y [focus]` - Focused checks (contrast, aria, headings, forms, alt-text, keyboard)
- `/audit-a11y checklist` - Generate WCAG 2.1 AA compliance checklist
- `/audit-a11y report` - Generate stakeholder-friendly compliance report
- `/audit-a11y fix` - Generate specific code fixes for identified issues

---

### ⚡ [Performance](performance.md)

Optimize site speed and improve Core Web Vitals.

| Command | Description |
|---------|-------------|
| `/audit-perf [focus]` | Comprehensive performance analysis and Core Web Vitals optimization |

**Usage modes**:
- `/audit-perf` - Full performance audit across all areas
- `/audit-perf [focus]` - Focused analysis (queries, n+1, assets, bundles, caching)
- `/audit-perf vitals` - Check all Core Web Vitals (LCP, INP/FID, CLS)
- `/audit-perf [metric]` - Optimize specific vital (lcp, inp, fid, cls)
- `/audit-perf lighthouse` - Generate Lighthouse performance report
- `/audit-perf report` - Generate stakeholder-friendly performance report

---

### 🔒 [Security](security.md)

Scan for vulnerabilities, exposed secrets, and security misconfigurations.

| Command | Description |
|---------|-------------|
| `/audit-security [focus]` | Comprehensive security audit with vulnerability scanning and compliance reporting |

**Usage modes**:
- `/audit-security` - Complete security audit with detailed findings
- `/audit-security [focus]` - Focused scans (deps, secrets, permissions)
- `/audit-security report` - Generate stakeholder-friendly compliance report

---

### 📝 [Documentation](documentation.md)

Generate and maintain project documentation.

| Command | Description |
|---------|-------------|
| `/docs-generate [type]` | Generate documentation (API, README, guides, changelog) |

**Type options**: `api`, `readme`, `changelog`, `guide user`, `guide developer`, `guide deployment`, `guide admin`

---

### 🧪 [Testing](testing.md)

Generate tests and analyze test coverage.

| Command | Description |
|---------|-------------|
| `/test-generate [type]` | Generate test scaffolding (unit, integration, e2e, data) |
| `/test-coverage` | Analyze test coverage and identify untested code paths |
| `/test-plan` | Generate comprehensive QA test plan from code changes |

**Type options**: `unit`, `integration`, `e2e`, `data`

---

### 📊 [Code Quality](code-quality.md)

Maintain code quality and reduce technical debt.

| Command | Description |
|---------|-------------|
| `/quality-analyze [focus]` | Analyze code quality (refactoring, complexity, technical debt) |
| `/quality-standards` | Check code against standards (PHPCS, ESLint, Drupal/WordPress) |

**Focus options**: `refactor`, `complexity`, `debt`

---

### 🔍 [Live Site Auditing](live-site-auditing.md)

Comprehensive audits of live websites using Chrome DevTools.

| Command | Description |
|---------|-------------|
| `/audit-live-site [url]` | Full site audit for performance, accessibility, SEO, and security |
| `/export-audit-csv [report-file]` | Export audit report to CSV for project management tools (Teamwork, Jira, Monday, etc.) |

**Requirements**: Chrome DevTools MCP Server

**What it audits**:
- Performance (Core Web Vitals: LCP, INP, CLS, FCP, TBT)
- Accessibility (WCAG 2.2 AA compliance)
- SEO (meta tags, structured data, sitemaps)
- Security (HTTPS, headers, mixed content)
- Best practices (console errors, optimization)

**Output**: Markdown report + CSV task list

---

## Platform-Specific Features

### Drupal Support
- Configuration change detection
- Custom module analysis
- Hook implementation detection
- Entity and field change tracking
- Database update detection (`hook_update_N`)
- Views and Entity Query optimization
- Drupal caching analysis (page cache, render cache, cache tags)
- Drush command generation

### WordPress Support
- Theme and functions.php analysis
- Gutenberg block accessibility and performance
- ACF field group detection
- Custom post type and taxonomy analysis
- Shortcode implementation
- WP_Query optimization
- Object cache analysis
- WP-CLI command generation

---

## Integration with Kanopi Tools

Commands automatically integrate with [Kanopi's DDEV add-ons](../kanopi-tools/overview.md):

- **Quality Commands** use `ddev composer code-check`, `phpstan`, `rector-check`
- **Performance Commands** suggest `ddev theme-build` and `ddev critical-run`
- **Security Commands** use `ddev composer audit` and `npm audit`
- **Testing Commands** leverage `ddev cypress-run` for E2E tests

---

## Next Steps

- **[PR Workflow Commands](pr-workflow.md)** - Detailed PR workflow guide
- **[Accessibility Commands](accessibility.md)** - WCAG compliance guide
- **[Performance Commands](performance.md)** - Optimization strategies
- **[Quick Start](../quick-start.md)** - Common workflow examples
