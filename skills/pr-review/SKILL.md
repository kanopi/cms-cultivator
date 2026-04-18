---
name: pr-review
description: "Review a pull request or analyze local changes using the workflow specialist. Auto-activates when user mentions reviewing a PR, asks for code review, wants to analyze their changes before submitting, or mentions \"pr-review self\". Invoke when user provides a PR number to review or says \"review self\", \"review my changes\", or \"pr review\". Supports focus areas: code, security, breaking, testing, size, performance."
---

# PR Review

Review a pull request or analyze your local changes using the workflow-specialist agent.

## Usage

**Review someone else's PR:**
- Ask: "Review PR #123" or "Review pull request 456"
- With focus: "Review PR #123 for security issues"

**Analyze your own changes (before creating PR):**
- Ask: "Review my changes" or "Self-review before PR"
- With focus: "Check my changes for breaking changes"

**Focus options**: `code`, `security`, `breaking`, `testing`, `size`, `performance`

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() or gh CLI are unavailable:

1. **Determine target** — PR number or "self" (local changes)
2. **Gather context** — Use Read and Grep to examine files, look for git diff output if provided
3. **Analyze changes directly** based on focus area:
   - **Code quality**: Readability, naming, documentation, consistency
   - **Security**: Input validation, output encoding, authentication patterns
   - **Breaking changes**: API/function signature changes, database schema changes
   - **Testing**: Test coverage presence, test quality, missing test scenarios
   - **Size**: Estimate scope from files mentioned or shown
   - **Performance**: Query patterns, caching, asset loading
4. **Generate review** — Structured findings with Required Changes and Suggestions sections
5. **Provide overall recommendation** — Approve / Request Changes / Comment

**Note for Tier 1**: Without git access, ask the user to share the diff or changed files for analysis.

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() and git/gh CLI available:

1. **Determine target** — Parse PR number or "self" from request
2. **Gather context automatically**:
   - For PR review: `gh pr view {number}` and `gh pr diff {number}`
   - For self-review: `git branch`, `git log main...HEAD`, `git diff main...HEAD`
3. **Spawn workflow-specialist**:
   ```
   Task(cms-cultivator:workflow-specialist:workflow-specialist,
        prompt="Review changes comprehensively. Target: {PR number or 'self'}. Focus area: {focus or 'all aspects'}. For self-reviews: gather branch info, commits, diffs, file stats. For PR reviews: use gh pr view and gh pr diff. Orchestrate specialists in parallel as needed (testing, security, accessibility). Provide detailed code review with actionable recommendations.")
   ```
4. **Present review** to user

## Review Dimensions

### Code Quality
- Readability, maintainability, consistency
- Documentation and naming conventions
- Project convention adherence
- Design patterns and SOLID principles

### Security
- Input validation and output encoding
- SQL injection and XSS vulnerabilities
- Authentication/authorization checks
- Secrets and credentials in code
- CMS-specific security patterns

### Testing
- Test coverage for new/modified code
- Test quality and edge case coverage
- Automated test recommendations

### Size & Complexity
- Lines changed, files affected
- Size category: XS (< 10), S (10–100), M (100–400), L (400–1000), XL (> 1000)
- Split recommendations for XL PRs

### Breaking Changes
- API/function signature changes
- Database schema changes
- Dependency version changes
- CMS-specific breaking changes (config, permissions, routes)

## CMS-Specific Analysis

**Drupal**: Config management, update hooks, Database API usage, cache tags/contexts, access control, services/DI, Form API, module dependencies

**WordPress**: Theme templates and hierarchy, hooks and filters, $wpdb->prepare(), nonce verification, capability checks, sanitization/escaping, ACF field exports, Gutenberg blocks

## Review Output Format

```markdown
# PR Review — [Title or "Local Changes"]

**Size**: [XS/S/M/L/XL] ([X] files, +[Y]/-[Z] lines)
**Complexity**: [Low/Medium/High]

## Summary
[Overall assessment]

## Required Changes
### Critical Issues
- [ ] **[Issue]** (file.php:123) — [Problem and fix]

### Security Concerns
- [ ] **[Issue]** (file.php:456) — [Risk and fix]

## Suggestions
### Performance
### Code Quality

## Test Plan
[Specific test cases]

## Overall Recommendation
- [ ] Approve / Request Changes / Comment
```

## Related Skills

- **commit-message-generator** — Generate commit messages before review
- **pr-create** — Create PR after passing self-review
- **security-scanner** — Deep security checks on specific code
