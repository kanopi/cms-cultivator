# Core Operations Reference

Complete details for all four core read-only operations supported by the Teamwork Integrator skill.

## 1. Quick Status Check

**Trigger phrases:**
- "status of PROJ-123"
- "what's the status?"
- "is SITE-456 done?"

**Information to retrieve:**
- Task title
- Current status (Not Started, In Progress, Completed)
- Assignee (who's working on it)
- Priority (P0-P4)
- Due date (if set)
- Direct link to Teamwork task

**Example output:**
```markdown
## PROJ-123 Status

**Title:** Implement user authentication

**Status:** In Progress ⏳

**Assignee:** jane.developer@example.com

**Priority:** P1 (High)

**Due Date:** 2024-01-20

**Link:** https://example.teamwork.com/tasks/123456
```

## 2. Task Details

**Trigger phrases:**
- "show me PROJ-123"
- "what's in that ticket?"
- "details on SITE-456"

**Information to retrieve:**
- All fields from status check above
- Task description (first 500 chars)
- Acceptance criteria
- Comments (last 3)
- Attachments/links
- Related tasks (dependencies)

**Example output:**
```markdown
## PROJ-123: Implement user authentication

**Status:** In Progress ⏳ | **Assignee:** jane.developer | **Priority:** P1

### Description
Implement OAuth2 authentication with Google and GitHub providers. Users should be able to sign in using either provider...

### Acceptance Criteria
- [ ] Google OAuth integration
- [ ] GitHub OAuth integration
- [ ] User profile creation
- [x] Database schema updated

### Recent Comments
**john.qa (2 hours ago):** "Database migrations look good"
**jane.developer (4 hours ago):** "Google OAuth working on staging"

### Dependencies
- Depends on: PROJ-100 (Database schema updates) ✓ Complete
- Blocks: PROJ-125 (User profile page)

**Link:** https://example.teamwork.com/tasks/123456
```

## 3. Project Context

**Trigger phrases:**
- "which project is this?"
- "show me projects"
- "list Teamwork projects"

**Information to retrieve:**
- Active projects
- Project names and IDs
- Recent tasks per project

**Example output:**
```markdown
## Active Teamwork Projects

1. **Website Redesign (SITE)**
   - ID: 12345
   - Active tasks: 23
   - Recent: SITE-456, SITE-455, SITE-450

2. **Blog Platform (BLOG)**
   - ID: 12346
   - Active tasks: 8
   - Recent: BLOG-123, BLOG-120, BLOG-119

3. **Mobile App (APP)**
   - ID: 12347
   - Active tasks: 15
   - Recent: APP-789, APP-788, APP-780
```

## 4. Link Tasks in PR Descriptions

**Trigger phrases:**
- "add this to PR description"
- "link PROJ-123 in the PR"
- "reference this ticket in PR"

**When creating/updating PR:**
- Detect ticket numbers in branch name
- Detect ticket numbers in commit messages
- Format ticket references for PR body

**Format for PR body:**
```markdown
## Related Tickets

- Implements: PROJ-123
- Fixes: SITE-456
- Related: BLOG-789

## Teamwork Links

- [PROJ-123: Implement user authentication](https://example.teamwork.com/tasks/123456)
```
