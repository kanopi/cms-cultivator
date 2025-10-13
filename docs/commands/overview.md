# Commands Overview

CMS Cultivator provides 25 specialized commands organized into 7 categories. Each command integrates seamlessly with Drupal and WordPress projects.

---

## Command Categories

### 🔄 [PR Workflow](pr-workflow.md) (6 commands)

Streamline pull request creation, review, and deployment.

| Command | Description |
|---------|-------------|
| `/pr-desc [ticket]` | Generate comprehensive PR descriptions from git changes |
| `/pr-create-pr [ticket]` | Create pull request with generated description |
| `/pr-review [pr-number\|url]` | Review existing pull requests with detailed feedback |
| `/pr-commit-msg` | Generate conventional commit messages from staged changes |
| `/pr-analysis [focus]` | Analyze PR size, breaking changes, and generate test plan |
| `/pr-release [focus]` | Generate changelog, deployment checklist, and update PR |

---

### ♿ [Accessibility](accessibility.md) (5 commands)

Ensure WCAG 2.1 Level AA compliance and create inclusive experiences.

| Command | Description |
|---------|-------------|
| `/a11y-audit` | Run comprehensive WCAG 2.1 Level AA accessibility audit |
| `/a11y-report` | Generate accessibility compliance report for stakeholders |
| `/a11y-checklist` | Generate WCAG 2.1 Level AA compliance checklist |
| `/a11y-check [focus]` | Check specific accessibility aspects |
| `/fix-a11y-issues` | Generate specific code fixes for accessibility issues |

**Focus options**: `contrast`, `aria`, `headings`, `forms`, `alt-text`, `keyboard`

---

### ⚡ [Performance](performance.md) (5 commands)

Optimize site speed and improve Core Web Vitals.

| Command | Description |
|---------|-------------|
| `/perf-performance-audit` | Comprehensive full-stack performance analysis |
| `/perf-lighthouse-report` | Generate Lighthouse audit with recommendations |
| `/perf-performance-report` | Generate executive performance report with ROI |
| `/perf-analyze [focus]` | Analyze performance aspects in detail |
| `/perf-vitals [metric]` | Check and optimize Core Web Vitals |

**Focus options**: `queries`, `n-plus-one`, `assets`, `bundles`, `caching`

**Metric options**: `lcp`, `fid`, `cls`

---

### 🔒 [Security](security.md) (3 commands)

Scan for vulnerabilities, exposed secrets, and security misconfigurations.

| Command | Description |
|---------|-------------|
| `/security-audit` | Comprehensive security audit (OWASP Top 10, code vulnerabilities) |
| `/security-scan [focus]` | Scan for vulnerabilities, secrets, and permission issues |
| `/security-report` | Generate security compliance report for stakeholders |

**Focus options**: `deps`, `secrets`, `permissions`

---

### 📝 [Documentation](documentation.md) (1 command)

Generate and maintain project documentation.

| Command | Description |
|---------|-------------|
| `/docs-generate [type]` | Generate documentation (API, README, guides, changelog) |

**Type options**: `api`, `readme`, `changelog`, `guide user`, `guide developer`, `guide deployment`, `guide admin`

---

### 🧪 [Testing](testing.md) (3 commands)

Generate tests and analyze test coverage.

| Command | Description |
|---------|-------------|
| `/test-generate [type]` | Generate test scaffolding (unit, integration, e2e, data) |
| `/test-coverage` | Analyze test coverage and identify untested code paths |
| `/test-plan` | Generate comprehensive QA test plan from code changes |

**Type options**: `unit`, `integration`, `e2e`, `data`

---

### 📊 [Code Quality](code-quality.md) (2 commands)

Maintain code quality and reduce technical debt.

| Command | Description |
|---------|-------------|
| `/quality-analyze [focus]` | Analyze code quality (refactoring, complexity, technical debt) |
| `/quality-standards` | Check code against standards (PHPCS, ESLint, Drupal/WordPress) |

**Focus options**: `refactor`, `complexity`, `debt`

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
