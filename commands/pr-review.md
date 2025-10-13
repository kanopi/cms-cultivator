---
description: Review a pull request with comprehensive analysis
argument-hint: <pr-number>
allowed-tools: Bash(gh:*), Bash(git:*), Read, Glob, Grep
---

You are helping review a pull request. Provide a thorough, constructive review.

## Step 1: Fetch PR Information

Get PR details using GitHub CLI:

```bash
# Get PR information
gh pr view <pr-number>

# Get PR diff
gh pr diff <pr-number>

# Get PR files changed
gh pr view <pr-number> --json files --jq '.files[].path'
```

## Step 2: Analyze the Changes

Review the code changes across multiple dimensions:

### Code Quality
- **Readability**: Is the code easy to understand?
- **Maintainability**: Will this be easy to modify in the future?
- **Consistency**: Does it follow project conventions?
- **Documentation**: Are complex sections explained?
- **Naming**: Are variables/functions well-named?

### Functionality
- **Correctness**: Does the code do what it claims?
- **Edge cases**: Are error conditions handled?
- **Logic**: Are there any logical errors?
- **Performance**: Any obvious performance issues?

### Security
- **Input validation**: Is user input sanitized?
- **SQL injection**: Are queries parameterized?
- **XSS vulnerabilities**: Is output properly escaped?
- **Authentication/Authorization**: Are permissions checked?
- **Secrets**: Are there any hardcoded credentials?

### Drupal-Specific Review (if Drupal project)
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

### WordPress-Specific Review (if WordPress project)
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

### Testing
- **Test coverage**: Are there tests for new functionality?
- **Cypress tests**: If UI changes, are E2E tests included/updated?
- **Test quality**: Do tests actually verify the functionality?
- **Edge cases**: Are edge cases tested?

### Dependencies
- **composer.json changes**: Are new dependencies necessary and appropriate?
- **package.json changes**: Are npm packages up-to-date and secure?
- **Version constraints**: Are version constraints appropriate?
- **License compatibility**: Are licenses compatible with project?

### Deployment Considerations
- **Database migrations**: Are they idempotent and reversible?
- **Config changes**: Will config import work correctly?
- **Backwards compatibility**: Will this break existing functionality?
- **Environment variables**: Are new env vars documented?
- **Asset changes**: Do assets need rebuilding (npm run build)?

## Step 3: Check PR Description

Evaluate the PR description:
- Does it clearly explain WHAT was changed?
- Does it explain WHY the change was made?
- Are acceptance criteria listed?
- Are deployment steps documented?
- Are there validation steps?
- Are there screenshots/videos for UI changes?

## Step 4: Provide Structured Feedback

Format your review in this structure:

```markdown
## Summary
[Brief overall assessment of the PR]

## Strengths
- [What was done well]
- [Positive observations]

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

## Suggestions
These would improve the code but aren't blockers:

### Performance
- **[Suggestion]** (path/to/file.php:789)
  - Current: [What's happening now]
  - Better: [Improved approach]

### Code Quality
- **[Suggestion]** (path/to/file.php:101)
  - Consider: [Alternative approach]

## Testing Recommendations
- [ ] Test: [Specific scenario to verify]
- [ ] Test: [Edge case to check]
- [ ] Run Cypress tests if UI changes: `npm run cypress:run`

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

## Deployment Checklist Review
Review the PR's deployment steps and add any missing items:
- [ ] [Additional deployment step]
- [ ] [Verification step]

## Questions
- [Any clarifying questions for the author]

## Overall Recommendation
- [ ] **Approve** - Ready to merge
- [ ] **Request Changes** - Must address required changes first
- [ ] **Comment** - Feedback provided, author's discretion
```

## Step 5: Submit Review (Optional)

Ask the user if they want you to submit the review via gh CLI:

```bash
# Approve
gh pr review <pr-number> --approve --body "Review comments..."

# Request changes
gh pr review <pr-number> --request-changes --body "Review comments..."

# Comment only
gh pr review <pr-number> --comment --body "Review comments..."
```

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

## Review Checklist

Before submitting, ensure you've checked:
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

## Red Flags to Watch For

- Hardcoded credentials or API keys
- SQL queries without parameterization
- Unescaped output (XSS risk)
- Missing access control checks
- Direct file system access without validation
- Disabled security features
- Commented-out code without explanation
- TODOs without tickets
- Console.log statements in production code
- Overly complex logic without comments
- Copy-pasted code that should be abstracted
- Changes to core files (Drupal/WordPress)
- Missing error handling
- Unsafe deserialization
- Weak cryptography

## Output Format

Provide a comprehensive but scannable review that:
1. Starts with a summary assessment
2. Highlights both strengths and issues
3. Clearly separates required changes from suggestions
4. Provides specific, actionable feedback
5. Includes code examples where helpful
6. Ends with a clear recommendation

Remember: The goal is to help ship quality code while supporting the author's growth. Be thorough but kind, critical but constructive.
