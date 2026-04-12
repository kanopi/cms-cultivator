# Complete Workflow Examples

Real-world examples demonstrating common operations.

## Example 1: Create Epic from Feature Request

**User:** "Create a task for implementing OAuth authentication with Google and GitHub"

**Your response:**
```markdown
This sounds like a **Big Task/Epic** because it involves:
- Multiple authentication providers
- Integration branch likely needed
- Multiple components (backend, frontend, config)
- Estimated >8 hours

Before I create the task, I need some details:

1. **Requirements**: Beyond Google and GitHub, any other providers? What about existing user accounts?
2. **Technical approach**: Are you using a specific OAuth library?
3. **Environment**: Drupal/WordPress/NextJS? Version?
4. **Dependencies**: Does database schema need updates first?
5. **Testing**: Which environments for testing? Any specific browser requirements?

Once you provide these, I'll create a complete epic with all required sections.
```

## Example 2: Export Security Findings

**User:** "Export these security findings to Teamwork" [after security audit]

**Your response:**
```markdown
I'll export these 8 security findings to Teamwork.

**Analysis:**
- 1 Critical (SQL injection)
- 3 High (XSS vulnerabilities)
- 4 Medium (CSRF, weak validation)

**Plan:**
- Create epic: "Security Fixes - OWASP Vulnerabilities"
- 8 individual bug report tasks
- Link dependencies (SQL injection fix blocks others)

Creating tasks now...

---

✓ Export complete!

## Created Tasks

**Epic:** [SEC-2024: Security Fixes](https://example.teamwork.com/tasks/1000)

**Critical (P0):**
- [SEC-101: SQL Injection in User Search](https://example.teamwork.com/tasks/1001)

**High (P1):**
- [SEC-102: XSS in User Profile](https://example.teamwork.com/tasks/1002)
- [SEC-103: XSS in Comment Form](https://example.teamwork.com/tasks/1003)
- [SEC-104: XSS in Search Results](https://example.teamwork.com/tasks/1004)

**Medium (P2):**
- [SEC-105-108: CSRF and Validation Issues](links)

**Dependencies configured:**
- SEC-102, 103, 104 depend on SEC-101 (fix sanitization layer first)

**Recommended order:**
1. Start with SEC-101 (critical, blocks others)
2. Tackle P1 XSS in parallel after SEC-101 complete
3. Schedule P2 for next sprint
```

## Example 3: Link PR to Ticket

**User:** "Link this PR to PROJ-456"

**Your response:**
```markdown
I'll link your PR to PROJ-456.

**Task details:**
- Title: Fix contact form validation
- Status: In Progress
- Assignee: john.dev

**Actions taken:**
1. ✓ Added to PR description:
   ```
   Implements: PROJ-456
   Link: https://example.teamwork.com/tasks/456
   ```

2. ✓ Added comment to PROJ-456:
   "Pull request created: #123
   Branch: feature/PROJ-456-form-validation"

3. ✓ Updated task status: In Progress → Ready for Review

**Next steps:**
- Request PR review
- QA can test from this PR's preview environment
```
