---
description: Review a pull request or analyze your own changes
argument-hint: [pr-number|self] [focus-area]
allowed-tools: Bash(gh:*), Bash(git:*), Read, Glob, Grep, Bash(ddev composer:*), Bash(ddev:*)
---

You are helping review a pull request or analyze changes before creating one. This command provides comprehensive analysis including code review, size/complexity assessment, breaking changes detection, and test plan generation.

## Usage

**Review someone else's PR:**
- `/pr-review <pr-number>` - Full review of PR by number
- `/pr-review <pr-number> code` - Focus on code quality only
- `/pr-review <pr-number> security` - Focus on security only
- `/pr-review <pr-number> breaking` - Focus on breaking changes only

**Analyze your own changes (before creating PR):**
- `/pr-review self` - Analyze local changes (all aspects)
- `/pr-review self size` - Focus on size/complexity only
- `/pr-review self breaking` - Focus on breaking changes only
- `/pr-review self testing` - Focus on test plan only

**Focus options**: `code`, `security`, `breaking`, `testing`, `size`, `performance`

---

## Quick Start (Kanopi Projects)

### Pre-Review Quality Checks

Before reviewing, run Kanopi's quality checks to identify issues:

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

### Test Plan Automation

Include these in the test plan's "Automated Tests" section:

```bash
# Quality checks
ddev composer code-check     # Drupal all-in-one
ddev composer phpstan        # WordPress static analysis
ddev composer phpcs          # WordPress code standards

# Security checks
ddev composer audit
ddev exec npm audit

# End-to-end tests
ddev cypress-run

# Performance tests
ddev critical-run
```

---

## Workflow

### MODE 1: Review Someone's PR (`/pr-review <pr-number>`)

#### Step 1: Fetch PR Information

```bash
# Get PR information
gh pr view <pr-number>

# Get PR diff
gh pr diff <pr-number>

# Get PR files changed
gh pr view <pr-number> --json files --jq '.files[].path'

# Get PR stats
gh pr view <pr-number> --json additions,deletions
```

#### Step 2: Analyze the Changes

Review across multiple dimensions:

##### Code Quality
- **Readability**: Is the code easy to understand?
- **Maintainability**: Will this be easy to modify in the future?
- **Consistency**: Does it follow project conventions?
- **Documentation**: Are complex sections explained?
- **Naming**: Are variables/functions well-named?

##### Functionality
- **Correctness**: Does the code do what it claims?
- **Edge cases**: Are error conditions handled?
- **Logic**: Are there any logical errors?
- **Performance**: Any obvious performance issues?

##### Security
- **Input validation**: Is user input sanitized?
- **SQL injection**: Are queries parameterized?
- **XSS vulnerabilities**: Is output properly escaped?
- **Authentication/Authorization**: Are permissions checked?
- **Secrets**: Are there any hardcoded credentials?

##### Drupal-Specific Review
- **Config management**: Are config changes in `config/sync/`?
- **Update hooks**: Are `hook_update_N()` properly numbered and documented?
- **Database API**: Using proper query builders (EntityQuery, Database API)?
- **Cache tags**: Are appropriate cache tags and contexts used?
- **Access control**: Are entity access checks properly implemented?
- **Module dependencies**: Are `.info.yml` dependencies correct?
- **Services**: Are services properly injected, not statically called?
- **Form API**: Using Form API correctly?
- **Render API**: Using render arrays properly?
- **Best practices**: Following Drupal coding standards?

##### WordPress-Specific Review
- **Theme templates**: Following template hierarchy correctly?
- **Hooks and filters**: Using appropriate WordPress hooks?
- **Database queries**: Using $wpdb->prepare() for custom queries?
- **WP_Query**: Using WP_Query correctly (with proper tax_query, meta_query)?
- **Nonces**: Security nonces implemented for forms/AJAX?
- **Sanitization**: Using sanitize_text_field(), esc_html(), etc.?
- **Transients**: Using transients/object cache appropriately?
- **Gutenberg blocks**: Blocks registered and enqueued correctly?
- **ACF fields**: ACF field groups exported to JSON?
- **Theme support**: Proper theme support declarations?

##### Testing
- **Test coverage**: Are there tests for new functionality?
- **Cypress tests**: If UI changes, are E2E tests included/updated?
- **Test quality**: Do tests actually verify the functionality?
- **Edge cases**: Are edge cases tested?

##### Dependencies
- **composer.json changes**: Are new dependencies necessary and appropriate?
- **package.json changes**: Are npm packages up-to-date and secure?
- **Version constraints**: Are version constraints appropriate?
- **License compatibility**: Are licenses compatible with project?

##### Deployment Considerations
- **Database migrations**: Are they idempotent and reversible?
- **Config changes**: Will config import work correctly?
- **Backwards compatibility**: Will this break existing functionality?
- **Environment variables**: Are new env vars documented?
- **Asset changes**: Do assets need rebuilding (npm run build)?

#### Step 3: Size & Complexity Analysis

Measure and assess:

```bash
# Get diff stats
git diff origin/main..HEAD --stat
git diff origin/main..HEAD --shortstat
git diff origin/main..HEAD --numstat
```

**Size Categories:**
- **XS**: < 10 lines (typo fixes, small config)
- **S**: 10-100 lines (bug fix, small feature)
- **M**: 100-400 lines (moderate feature) ⭐ Optimal
- **L**: 400-1000 lines (large feature) ⚠️ Consider splitting
- **XL**: > 1000 lines (very large) 🚫 Should split

**Complexity Factors:**
- Technical complexity (DB, API, security changes)
- Cognitive complexity (new patterns, business logic)
- Review complexity (mixed concerns, poor organization)

**Mixed Concerns Detection:**
- Feature + refactoring in one PR
- Multiple unrelated features
- Bug fix + enhancement together
- Frontend + backend + database all at once

#### Step 4: Breaking Changes Detection

Scan for:

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

**Assess Impact & Severity:**
- **Critical**: Immediate failures, data loss, security issues
- **High**: Breaks functionality for most users
- **Medium**: Breaks some use cases
- **Low**: Edge cases, easily worked around

#### Step 5: Generate Test Plan

Create comprehensive test plan covering:

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

#### Step 6: Output Structured Review

```markdown
# PR Review - [PR Title]

**PR**: #[number]
**Author**: [username]
**Size**: [XS/S/M/L/XL] ([X] files, +[Y]/-[Z] lines)
**Complexity**: [Low/Medium/High]
**Review Time Estimate**: [X] hours

---

## Summary
[Brief overall assessment of the PR]

## Strengths
- [What was done well]
- [Positive observations]

---

## 📊 SIZE & COMPLEXITY ANALYSIS

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

### High Priority Breaking Changes
[List with migration paths]

### Recommendations
- Version bump required: [MAJOR/MINOR/PATCH]
- Migration guide needed: [Yes/No]
- Deprecation period: [Recommended timeline]

---

## Required Changes
These must be addressed before approval:

### Critical Issues
- [ ] **[Issue description]**
  - Location: `path/to/file.php:123`
  - Problem: [Specific problem]
  - Suggestion: [How to fix]

### Security Concerns
- [ ] **[Security issue]**
  - Location: `path/to/file.php:456`
  - Risk: [What could happen]
  - Fix: [Recommended solution]

---

## Suggestions
These would improve the code but aren't blockers:

### Performance
- **[Suggestion]** (path/to/file.php:789)
  - Current: [What's happening now]
  - Better: [Improved approach]

### Code Quality
- **[Suggestion]** (path/to/file.php:101)
  - Consider: [Alternative approach]

---

## ✅ TEST PLAN

### Test Environment Setup
- [ ] Pull latest code
- [ ] Install dependencies: `composer install && npm install`
- [ ] Run database updates
- [ ] Import config (Drupal) or sync ACF (WordPress)
- [ ] Build assets: `npm run build`
- [ ] Clear caches

### Functional Tests
[Specific test cases with steps and expected results]

### Security Tests
[Authentication, input validation, CSRF tests]

### Performance Tests
[Load times, query performance, asset sizes]

### Accessibility Tests
[Keyboard nav, screen reader, contrast, semantic HTML]

### Regression Tests
[Existing features to verify still work]

### Automated Tests
- [ ] Unit tests: `vendor/bin/phpunit`
- [ ] Cypress: `npm run cypress:run`
- [ ] Static analysis: `composer phpstan`
- [ ] Code standards: `composer phpcs`

### Drupal-Specific Tests
- [ ] Config import: `drush cim`
- [ ] Database updates: `drush updb`
- [ ] Entity updates: `drush entup`
- [ ] Status report: `/admin/reports/status`

### WordPress-Specific Tests
- [ ] Site Health: `/wp-admin/site-health.php`
- [ ] Permalinks working
- [ ] ACF fields display correctly
- [ ] CPTs accessible

---

## Drupal-Specific Notes
(If Drupal project)
- Config import required: [Yes/No - list specific configs]
- Database updates: [List update hooks to run]
- Cache clear needed: [Automatic via deployment]
- Entity updates needed: `drush entup -y`

## WordPress-Specific Notes
(If WordPress project)
- Database migrations: [List any migrations]
- Permalink flush needed: [If CPT/taxonomy changes]
- ACF field sync: [If acf-json changes]
- WP-CLI commands: [Any required wp commands]

---

## Questions
- [Any clarifying questions for the author]

---

## Overall Recommendation
- [ ] **Approve** - Ready to merge
- [ ] **Request Changes** - Must address required changes first
- [ ] **Comment** - Feedback provided, author's discretion

**Ready for Review**: [✅ Yes | ⚠️ With concerns | ❌ Split first]
```

#### Step 7: Submit Review (Optional)

Ask if they want to submit via gh CLI:

```bash
# Approve
gh pr review <pr-number> --approve --body "Review comments..."

# Request changes
gh pr review <pr-number> --request-changes --body "Review comments..."

# Comment only
gh pr review <pr-number> --comment --body "Review comments..."
```

---

### MODE 2: Analyze Your Own Changes (`/pr-review self`)

#### Step 1: Analyze Local Changes

```bash
# Get diff stats
git diff origin/main..HEAD --stat

# Get detailed changes
git diff origin/main..HEAD

# See commits
git log origin/main..HEAD --oneline

# Check specific areas
git diff origin/main..HEAD config/sync/     # Drupal config
git diff origin/main..HEAD acf-json/        # WordPress ACF
git diff origin/main..HEAD composer.json
git diff origin/main..HEAD package.json
```

#### Step 2: Self-Assessment

Run through same analysis as PR review:
- Size & complexity
- Breaking changes
- Code quality concerns
- Security issues
- Test coverage

#### Step 3: Generate Self-Review Report

```markdown
# Self-Review - [Branch Name]

**Branch**: [current-branch]
**Target**: main
**Size**: [XS/S/M/L/XL] ([X] files, +[Y]/-[Z] lines)
**Commits**: [N] commits

---

## 📊 SIZE & COMPLEXITY

[Same format as PR review]

## ⚠️ BREAKING CHANGES

[Same format as PR review]

## 🔍 CODE QUALITY CHECKLIST

- [ ] Code is readable and well-documented
- [ ] Follows project conventions
- [ ] No obvious performance issues
- [ ] Error handling in place
- [ ] No hardcoded credentials
- [ ] Input validation present
- [ ] Output properly escaped

## 🔒 SECURITY CHECKLIST

- [ ] SQL queries use parameterization
- [ ] XSS prevention in place
- [ ] CSRF tokens where needed
- [ ] Authentication/authorization checks
- [ ] No sensitive data in logs

## ✅ TEST PLAN

[Same format as PR review]

---

## ISSUES FOUND

### Critical (Must Fix Before PR)
[List critical issues found]

### Important (Should Fix Before PR)
[List important issues]

### Nice to Have (Optional Improvements)
[List optional improvements]

---

## NEXT STEPS

**Ready for PR**: [✅ Yes | ⚠️ After fixes | ❌ Needs work]

**Priority Actions**:
1. [Most important action]
2. [Second priority]
3. [Third priority]

**Estimated Time to PR-Ready**: [X] hours
```

---

## Focus Area Options

### Code Quality Focus (`code`)
Only analyze:
- Readability, maintainability, consistency
- Documentation and naming
- Project conventions
- Skip size, breaking changes, test plan

### Security Focus (`security`)
Only analyze:
- Input validation
- SQL injection risks
- XSS vulnerabilities
- Authentication/authorization
- Secrets and credentials
- Skip size, code quality, test plan

### Breaking Changes Focus (`breaking`)
Only analyze:
- API/function changes
- Database changes
- Dependency changes
- Frontend changes
- Migration paths
- Skip code quality, security, test plan

### Testing Focus (`testing`)
Only generate:
- Comprehensive test plan
- Test environment setup
- Automated test commands
- Skip code review, size, breaking changes

### Size/Complexity Focus (`size`)
Only analyze:
- Lines changed
- Files changed
- Size category
- Complexity assessment
- Mixed concerns
- Split recommendations
- Skip code review, breaking changes

### Performance Focus (`performance`)
Only analyze:
- Query optimization
- Asset sizes
- Page load times
- Caching strategies
- N+1 queries
- Skip code review, size, breaking changes

---

## Review Best Practices

1. **Be Constructive**: Frame feedback positively
   - ❌ "This code is terrible"
   - ✅ "Consider using X approach here because Y"

2. **Be Specific**: Point to exact locations
   - ❌ "The error handling needs work"
   - ✅ "In `UserController.php:45`, the error isn't being caught"

3. **Explain Why**: Don't just point out issues
   - ❌ "Don't use `mysql_query`"
   - ✅ "Don't use `mysql_query` (deprecated in PHP 5.5, removed in 7.0). Use `$wpdb->prepare()` to prevent SQL injection"

4. **Prioritize**: Separate critical issues from nice-to-haves
   - Critical: Security, breaking changes, data loss risks
   - Important: Performance, maintainability, best practices
   - Optional: Code style, refactoring opportunities

5. **Acknowledge Good Work**: Call out what was done well

6. **Ask Questions**: If you're unsure about something, ask rather than assume

7. **Consider Context**: Understand project constraints and deadlines

---

## Red Flags to Watch For

### Security Red Flags
- Hardcoded credentials or API keys
- SQL queries without parameterization
- Unescaped output (XSS risk)
- Missing access control checks
- Direct file system access without validation
- Disabled security features
- Unsafe deserialization
- Weak cryptography

### Code Quality Red Flags
- Commented-out code without explanation
- TODOs without tickets
- Console.log statements in production code
- Overly complex logic without comments
- Copy-pasted code that should be abstracted
- Changes to core files (Drupal/WordPress)
- Missing error handling

### Size Red Flags (Stop and Recommend Splitting)
- **> 1000 lines**: Too large to review effectively
- **> 30 files**: Too broad scope
- **Multiple unrelated domains**: Should be separate PRs
- **Critical + nice-to-have mixed**: Split by priority
- **Review would take > 2 hours**: Too much cognitive load

---

## Complete Review Checklist

Before finalizing review, ensure you've checked:
- [ ] Functionality and logic
- [ ] Security vulnerabilities
- [ ] Performance implications
- [ ] Test coverage
- [ ] Documentation
- [ ] Code style and consistency
- [ ] Drupal/WordPress best practices
- [ ] Database migrations safety
- [ ] Config management
- [ ] Deployment considerations
- [ ] Backwards compatibility
- [ ] Error handling
- [ ] Input validation
- [ ] Accessibility (if frontend changes)
- [ ] Mobile responsiveness (if frontend changes)
- [ ] Browser compatibility (if frontend changes)

---

## Output Format Guidelines

Provide comprehensive but scannable output that:
1. Starts with a summary assessment
2. Highlights both strengths and issues
3. Clearly separates required changes from suggestions
4. Provides specific, actionable feedback
5. Includes code examples where helpful
6. Ends with a clear recommendation

Remember:
- **For PR reviews**: Help ship quality code while supporting the author's growth. Be thorough but kind, critical but constructive.
- **For self-reviews**: Be honest about issues found. Better to catch problems now than in code review or production.
- **Smaller, focused PRs** are faster to review, have fewer defects, and merge 2x faster according to Microsoft research.
