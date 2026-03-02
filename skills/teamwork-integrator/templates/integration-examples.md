# Integration Examples

Real-world usage examples demonstrating the four core operations.

## Example 1: Quick Status

**User:** "What's the status of PROJ-123?"

**Skill Response:**
```markdown
## PROJ-123 Status

**Title:** Implement user authentication

**Status:** In Progress ⏳

**Assignee:** jane.developer

**Priority:** P1 (High)

**Due:** Jan 20, 2024

**Link:** https://example.teamwork.com/tasks/123456

Jane is actively working on this. Last update was 2 hours ago: "Google OAuth working on staging"

Would you like to see full task details or update the status?
```

## Example 2: Task Details

**User:** "Show me SITE-456"

**Skill Response:**
```markdown
## SITE-456: Fix contact form validation

**Status:** Ready for QA 🎯 | **Assignee:** john.dev | **Priority:** P1

### Description
Contact form validation not working on mobile devices. Users can submit empty forms. Fixed validation logic and added client-side checks.

### Acceptance Criteria
- [x] Form validates on desktop
- [x] Form validates on mobile
- [x] Error messages display correctly
- [x] Empty submissions blocked
- [ ] QA testing complete

### Recent Comments
**john.dev (1 hour ago):** "Ready for QA - tested on Chrome/Safari mobile"
**jane.qa (3 hours ago):** "I'll test this tomorrow"

### WordPress Notes
- Staging: https://staging.example.com/contact
- Theme: custom-theme
- Files changed: `contact-form.js`, `form-validation.php`

**Link:** https://example.teamwork.com/tasks/654321

This looks ready for QA review. Would you like me to create a QA handoff task or update this one?
```

## Example 3: Project Listing

**User:** "Show me active projects"

**Skill Response:**
```markdown
## Active Teamwork Projects

1. **Website Redesign (SITE)** - 23 open tasks
   - Recent: SITE-456, SITE-455, SITE-450
   - Link: https://example.teamwork.com/projects/12345

2. **Blog Platform (BLOG)** - 8 open tasks
   - Recent: BLOG-123, BLOG-120, BLOG-119
   - Link: https://example.teamwork.com/projects/12346

3. **Mobile App (APP)** - 15 open tasks
   - Recent: APP-789, APP-788, APP-780
   - Link: https://example.teamwork.com/projects/12347

Which project would you like to focus on?
```

## Example 4: PR Integration

**User:** "I'm creating a PR for my user-auth branch"

**Skill Response:**
```markdown
I detected ticket PROJ-123 in your branch name `feature/PROJ-123-user-auth`.

Here's what I'll add to your PR description:

---

## Related Tickets

Implements: [PROJ-123: Implement user authentication](https://example.teamwork.com/tasks/123456)

## Summary from Teamwork

OAuth2 authentication with Google and GitHub providers. Users can sign in using either provider.

**Status:** In Progress → Completed (when merged)

## Testing

From PROJ-123 acceptance criteria:
- [ ] Google OAuth integration works
- [ ] GitHub OAuth integration works
- [ ] User profile created on first login
- [ ] Existing users can link accounts

---

Would you like me to create the PR now with this description?
```
