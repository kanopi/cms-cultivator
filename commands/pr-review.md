---
description: Review a pull request or analyze your own changes using workflow specialist
argument-hint: "[pr-number|self] [focus-area]"
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Bash(gh pr view:*), Bash(gh pr diff:*), Task
---

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

## Tool Usage

**Allowed operations:**
- ✅ Gather git context (for self-reviews) or fetch PR details (for PR reviews)
- ✅ Run gh pr view and gh pr diff for PR reviews
- ✅ Run git diff and git log for self-reviews
- ✅ Spawn workflow-specialist agent
- ✅ Spawn specialist agents (security, testing, accessibility) in parallel

**Not allowed:**
- ❌ Do not submit review comments (just generate review)
- ❌ Do not merge or close PRs
- ❌ Do not modify files

The workflow-specialist agent will perform all review operations.

---

## Workflow-Specialist Agent

Spawn the **workflow-specialist** agent using:

```
Task(cms-cultivator:workflow-specialist:workflow-specialist,
     prompt="Review changes comprehensively. Target: [first argument - PR number or 'self']. Focus area: [second argument if provided, otherwise 'all aspects']. First, gather necessary context (for self-reviews: branch info, commits, diffs, file stats; for PR reviews: use gh pr view and gh pr diff). Orchestrate specialists in parallel as needed (testing, security, accessibility). Provide detailed code review with actionable recommendations.")
```

## How It Works

This command spawns the **workflow-specialist** agent, which orchestrates a comprehensive code review process by:

1. **Fetching PR details** (or analyzing local changes for self-review using context above)
2. **Identifying review areas** - Security, testing, accessibility, performance, code quality
3. **Spawning relevant specialists in parallel**:
   - **cms-cultivator:security-specialist:security-specialist** - OWASP vulnerabilities, input validation, SQL injection
   - **cms-cultivator:testing-specialist:testing-specialist** - Test coverage analysis and test plan generation
   - **cms-cultivator:accessibility-specialist:accessibility-specialist** - WCAG compliance for UI changes
4. **Compiling unified review** - Synthesizes all specialist findings into actionable report

### Review Modes

**PR Review Mode (`/pr-review <pr-number>`):**
- Fetches PR via GitHub CLI (`gh pr view`, `gh pr diff`)
- Analyzes commits, file changes, and diff
- Delegates to specialists based on change types
- Generates comprehensive review with recommendations
- Can optionally submit review via `gh pr review`

**Self-Review Mode (`/pr-review self`):**
- Gathers git context (branch, commits, diffs, stats)
- Compares current branch against main
- Same specialist delegation as PR review
- Identifies issues before PR creation
- Provides "ready for PR" assessment

---

## What the Workflow Specialist Analyzes

### Comprehensive Review (No Focus)

**Code Quality:**
- Readability, maintainability, consistency
- Documentation and naming conventions
- Project convention adherence
- Design patterns and SOLID principles

**Functionality:**
- Correctness and edge cases
- Logic errors and performance issues
- Error handling completeness

**Security:**
- Input validation and output encoding
- SQL injection and XSS vulnerabilities
- Authentication/authorization checks
- Secrets and credentials
- CMS-specific security patterns

**Testing:**
- Test coverage for new/modified code
- Test quality and edge cases
- Automated test recommendations

**Size & Complexity:**
- Lines changed, files affected
- Size category (XS/S/M/L/XL)
- Review complexity assessment
- Split recommendations

**Breaking Changes:**
- API/function signature changes
- Database schema changes
- Dependency version changes
- CMS-specific breaking changes (configs, permissions, routes)

**Dependencies:**
- New dependencies appropriateness
- Version constraint analysis
- License compatibility
- Security audit (`composer audit`, `npm audit`)

**Deployment:**
- Database migrations
- Configuration changes
- Backwards compatibility
- Environment variables

### CMS-Specific Analysis

**Drupal Projects:**
- Config management (`config/sync/`)
- Update hooks (`hook_update_N`)
- Database API usage
- Cache tags and contexts
- Access control and permissions
- Services and dependency injection
- Form API and Render API
- Module dependencies

**WordPress Projects:**
- Theme templates and hierarchy
- Hooks and filters
- Database queries (`$wpdb->prepare()`)
- Nonce verification
- Capability checks
- Sanitization and escaping
- Transients and object cache
- Gutenberg blocks
- ACF field exports

---

## Focus Area Options

### Code Quality Focus (`code`)
Only analyzes readability, maintainability, consistency, documentation, and naming. Skips security, size, and breaking changes.

### Security Focus (`security`)
Only analyzes input validation, SQL injection, XSS, authentication/authorization, and secrets. Skips code quality and size analysis.

### Breaking Changes Focus (`breaking`)
Only analyzes API changes, database changes, dependency changes, and migration paths. Provides version bump recommendations.

### Testing Focus (`testing`)
Only generates comprehensive test plan with functional, security, performance, and accessibility tests. Skips code review.

### Size/Complexity Focus (`size`)
Only analyzes lines changed, files changed, size category, complexity assessment, and split recommendations.

### Performance Focus (`performance`)
Only analyzes query optimization, asset sizes, page load times, caching strategies, and N+1 queries.

---

## Output Format

The workflow specialist generates structured reviews following this format:

```markdown
# PR Review - [PR Title]

**PR**: #[number]
**Author**: [username]
**Size**: [XS/S/M/L/XL] ([X] files, +[Y]/-[Z] lines)
**Complexity**: [Low/Medium/High]
**Review Time Estimate**: [X] hours

---

## Summary
[Brief overall assessment]

## Strengths
- [What was done well]

---

## 📊 SIZE & COMPLEXITY ANALYSIS

**Category**: [XS/S/M/L/XL]
**Lines Changed**: +[X] -[Y]
**Files Changed**: [N]
**Mixed Concerns**: [✅ Single Focus | ⚠️ Mixed | ❌ Multiple Unrelated]

**Recommendation**: [Is PR review-ready? Should it be split?]

---

## ⚠️ BREAKING CHANGES

**Found**: [N] breaking changes
- [X] Critical
- [X] High
- [X] Medium
- [X] Low

[List with migration paths and version bump recommendations]

---

## Required Changes
These must be addressed before approval:

### Critical Issues
- [ ] **[Issue]** (path/to/file.php:123)
  - Problem: [Specific problem]
  - Suggestion: [How to fix]

### Security Concerns
- [ ] **[Security issue]** (path/to/file.php:456)
  - Risk: [What could happen]
  - Fix: [Recommended solution]

---

## Suggestions
These would improve the code but aren't blockers:

### Performance
- **[Suggestion]** (path/to/file.php:789)

### Code Quality
- **[Suggestion]** (path/to/file.php:101)

---

## ✅ TEST PLAN

### Test Environment Setup
- [ ] Pull latest code
- [ ] Install dependencies
- [ ] Run database updates
- [ ] Import config/sync ACF

### Functional Tests
[Specific test cases]

### Security Tests
[Authentication, input validation]

### Automated Tests
- [ ] `vendor/bin/phpunit`
- [ ] `npm run cypress:run`
- [ ] `composer phpstan`
- [ ] `composer phpcs`

### CMS-Specific Tests
[Drupal: drush cim, drush updb]
[WordPress: Permalinks, ACF, CPTs]

---

## Overall Recommendation
- [ ] **Approve** - Ready to merge
- [ ] **Request Changes** - Must address required changes first
- [ ] **Comment** - Feedback provided, author's discretion
```

---

## Size Categories

The workflow specialist uses these categories to assess PR size:

- **XS**: < 10 lines (typo fixes, small config)
- **S**: 10-100 lines (bug fix, small feature)
- **M**: 100-400 lines (moderate feature) ⭐ Optimal for review
- **L**: 400-1000 lines (large feature) ⚠️ Consider splitting
- **XL**: > 1000 lines (very large) 🚫 Should split

**Research shows:**
- PRs > 400 lines have 2x more defects
- PRs < 400 lines merge 2x faster
- Smaller PRs get higher quality reviews

---

## Related Commands

- **[`/pr-create`](pr-create.md)** - Create PR after self-review
- **[`/pr-commit-msg`](pr-commit-msg.md)** - Generate commit message
- **[`/audit-security`](audit-security.md)** - Deep security audit
