---
description: Analyze PR size, complexity, breaking changes, and generate test plan
argument-hint: [focus-area]
allowed-tools: Bash(git:*), Read, Glob, Grep, Bash(ddev composer:*), Bash(ddev:*)
---

You are helping analyze a pull request comprehensively. This command combines size analysis, breaking changes detection, and test plan generation.

## Usage

- `/pr-analysis` - Run all analyses (size, breaking changes, test plan)
- `/pr-analysis size` - Focus on size and complexity only
- `/pr-analysis breaking` - Focus on breaking changes only
- `/pr-analysis testing` - Focus on test plan generation only

## Quick Start (Kanopi Projects)

### Running Quality Checks Before PR Analysis

Before analyzing the PR, run Kanopi's quality checks to identify potential issues:

```bash
# Drupal - Run all checks
ddev composer code-check    # phpstan + rector + code-sniff

# WordPress - Run checks individually
ddev composer phpstan       # Static analysis
ddev composer phpcs         # Code standards
ddev composer rector-check  # Modernization opportunities

# Both platforms - Check dependencies
ddev composer audit         # PHP vulnerabilities
ddev exec npm audit         # JavaScript vulnerabilities
```

### Estimating Complexity from Tool Output

Use the tool output to inform PR complexity assessment:

**PHPStan Findings** → Increases cognitive complexity:
- Errors found = potential bugs that need discussion
- Complexity warnings = harder to review

**Rector Suggestions** → Code modernization opportunities:
- Many suggestions = legacy code patterns
- Consider modernizing before merging

**PHPCS Violations** → Review friction:
- Standards violations slow down review
- Run auto-fix first: `ddev composer code-fix` (Drupal) or `ddev composer phpcbf` (WordPress)

### Test Plan Automation

Include these commands in the test plan's "Automated Tests" section:

```bash
# Drupal - All-in-one quality check
ddev composer code-check

# WordPress - Run all checks
ddev composer phpstan
ddev composer phpcs
ddev composer rector-check

# Both platforms - Security checks
ddev composer audit
ddev exec npm audit

# End-to-end tests (if configured)
ddev cypress-run

# Performance tests (if configured)
ddev critical-run
```

---

## Step 1: Analyze Changes

Gather information about the PR:

```bash
# Get diff stats
git diff origin/main..HEAD --stat

# Get detailed changes
git diff origin/main..HEAD

# See commits
git log origin/main..HEAD --oneline
```

## Analysis Areas

### 1. SIZE & COMPLEXITY ANALYSIS

#### Measure Size
Count lines changed (excluding generated files):
```bash
git diff origin/main..HEAD --shortstat
git diff origin/main..HEAD --numstat
```

#### Size Categories
- **XS**: < 10 lines (typo fixes, small config)
- **S**: 10-100 lines (bug fix, small feature)
- **M**: 100-400 lines (moderate feature) ⭐ Optimal
- **L**: 400-1000 lines (large feature) ⚠️ Consider splitting
- **XL**: > 1000 lines (very large) 🚫 Should split

#### Complexity Factors
- Technical complexity (DB, API, security changes)
- Cognitive complexity (new patterns, business logic)
- Review complexity (mixed concerns, poor organization)

#### Mixed Concerns Detection
Watch for:
- Feature + refactoring in one PR
- Multiple unrelated features
- Bug fix + enhancement together
- Frontend + backend + database all at once

**Output**: Size category, metrics, complexity assessment, split recommendations if needed

---

### 2. BREAKING CHANGES DETECTION

#### Scan for Breaking Changes

**API/Function Changes:**
- Function parameters changed (added, removed, reordered)
- Return types changed
- Public methods made private
- Functions renamed or removed

**Database Changes:**
- Tables/columns dropped or renamed
- Required columns added without defaults
- Foreign key relationships changed

**Drupal Breaking Changes:**
- Config entities removed
- Required config values added
- Permissions renamed/removed
- Routes changed

**WordPress Breaking Changes:**
- Custom post types renamed/removed
- Template names changed
- Hook signatures changed
- Shortcode changes

**Dependency Changes:**
- Minimum PHP/Node version increased
- Major version bumps (1.x → 2.x)
- Required dependencies removed

**Frontend Changes:**
- CSS classes renamed/removed
- JavaScript global variables removed
- HTML structure significantly altered

#### Assess Impact & Severity
- **Critical**: Immediate failures, data loss, security issues
- **High**: Breaks functionality for most users
- **Medium**: Breaks some use cases
- **Low**: Edge cases, easily worked around

#### Provide Migration Paths
For each breaking change:
- Show before/after code examples
- Explain specific migration steps
- Suggest release strategy (major version, deprecation period, feature flags)

**Output**: Breaking changes by severity, migration paths, release recommendations

---

### 3. TEST PLAN GENERATION

#### Identify Test Areas

**Functional Testing:**
- New features added
- Modified features
- Bug fixes
- User workflows affected

**Security Testing:**
- Authentication/authorization
- Input validation (SQL injection, XSS)
- CSRF protection
- Access control

**Performance Testing:**
- Page load times (LCP < 2.5s target)
- Database queries (no N+1, < 100ms)
- Asset sizes (JS < 200KB, CSS < 50KB gzipped)

**Accessibility Testing (WCAG 2.1 AA):**
- Keyboard navigation
- Screen reader compatibility
- Color contrast (4.5:1 ratio)
- Semantic HTML

**Responsive Design:**
- Mobile (375px), Tablet (768px), Desktop (1920px)
- No horizontal scroll

**Browser Compatibility:**
- Chrome, Firefox, Safari, Edge (latest versions)

**Drupal-Specific:**
- Config import: `drush cim`
- Database updates: `drush updb`
- Entity updates: `drush entup`
- Cache clearing: `drush cr`

**WordPress-Specific:**
- ACF field sync
- Permalink flush if CPT/taxonomy changes
- WP-CLI commands needed

#### Generate Test Plan Structure

```markdown
# Test Plan - [Feature Name]

## Test Environment Setup
- [ ] Pull latest code
- [ ] Install dependencies: composer install && npm install
- [ ] Run database updates
- [ ] Import config (Drupal)
- [ ] Build assets: npm run build
- [ ] Clear caches

## Functional Tests
[Specific test cases with steps and expected results]

## Security Tests
[Authentication, input validation, CSRF tests]

## Performance Tests
[Load times, query performance, asset sizes]

## Accessibility Tests
[Keyboard nav, screen reader, contrast, semantic HTML]

## Regression Tests
[Existing features to verify still work]

## Automated Tests
- [ ] Unit tests: vendor/bin/phpunit
- [ ] Cypress: npm run cypress:run
- [ ] Static analysis: composer phpstan

## Test Results Summary
Total: ___ | Passed: ___ | Failed: ___ | Pass Rate: ___%
```

**Output**: Complete, executable test plan with checkboxes

---

## Combined Output Format

Provide comprehensive analysis report:

```markdown
# PR Analysis Report

## 📊 SIZE ANALYSIS

**Category**: [XS/S/M/L/XL]
**Lines Changed**: +[X] -[Y]
**Files Changed**: [N]
**Review Time Estimate**: [X] hours

**Complexity**: [Low/Medium/High]
**Mixed Concerns**: [✅ Single Focus | ⚠️ Mixed | ❌ Multiple Unrelated]

**Recommendation**:
[Is PR review-ready? Should it be split? Action items]

---

## ⚠️ BREAKING CHANGES

**Found**: [N] breaking changes
- [X] Critical
- [X] High
- [X] Medium
- [X] Low

### Critical Breaking Changes
[List with migration paths]

### Recommendations
- Version bump required: [MAJOR/MINOR/PATCH]
- Migration guide needed: [Yes/No]
- Deprecation period: [Recommended timeline]

---

## ✅ TEST PLAN

[Complete test plan as detailed above]

---

## SUMMARY & NEXT STEPS

**Overall Assessment**: [Brief verdict on PR readiness]

**Priority Actions**:
1. [Most important action]
2. [Second priority]
3. [Third priority]

**Ready for Review**: [✅ Yes | ⚠️ With concerns | ❌ Split first]
```

## Focus Area Options

### If user specifies focus area:

**`/pr-analysis size`**
- Only output Size & Complexity Analysis section
- Skip breaking changes and test plan

**`/pr-analysis breaking`**
- Only output Breaking Changes Detection section
- Skip size analysis and test plan

**`/pr-analysis testing`**
- Only output Test Plan Generation section
- Skip size and breaking changes analysis

**`/pr-analysis` (no argument)**
- Output all three sections in full combined report

## Best Practices

1. **Be Thorough**: Better to find issues now than in production
2. **Be Constructive**: Frame feedback positively
3. **Be Specific**: Concrete examples and action items
4. **Prioritize**: Separate critical issues from nice-to-haves
5. **Industry Standards**: Reference Google/Microsoft research on PR sizes

## Red Flags

Stop and recommend splitting if:
- **> 1000 lines**: Too large to review effectively
- **> 30 files**: Too broad scope
- **Multiple unrelated domains**: Should be separate PRs
- **Critical + nice-to-have mixed**: Split by priority
- **Review would take > 2 hours**: Too much cognitive load

Remember: Smaller, focused PRs are faster to review, have fewer defects, and merge 2x faster according to Microsoft research.
