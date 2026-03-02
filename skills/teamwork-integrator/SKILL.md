---
name: teamwork-integrator
description: Automatically look up Teamwork task status, details, or project information when user mentions ticket numbers, asks "what's the status of", or needs quick project context. Performs focused queries without creating or modifying data. Invoke when user asks "status of PROJ-123", "what's in that ticket?", "show me task details", or references Teamwork ticket numbers.
---

# Teamwork Integrator Skill

## Philosophy

**Quick context without interruption.** Developers need fast access to task status and details without leaving their flow. This skill provides read-only Teamwork integration for instant lookups.

## When to Use This Skill

This skill activates when users:
- Mention ticket numbers in format: `PROJ-123`, `SITE-456`, etc.
- Ask "what's the status of [ticket]?"
- Say "show me task [number]"
- Ask "what's in that ticket?"
- Reference Teamwork tasks conversationally
- Need project context ("which project is this?", "show me projects")

**Do NOT activate for:**
- Creating new tasks (use teamwork-task-creator instead)
- Updating existing tasks (escalate to teamwork-specialist)
- Exporting audit findings (use teamwork-exporter instead)
- Complex multi-task operations (escalate to teamwork-specialist)

## Ticket Number Pattern Recognition

### Supported Formats

The skill recognizes these ticket number patterns:

- `PROJ-123` - Standard format (PROJECT-NUMBER)
- `SITE-456` - Any uppercase prefix + dash + number
- `ABC-789` - 2-4 letter prefix supported
- `#123` - Hash + number (less specific, ask for clarification)

### Pattern Matching Examples

**Automatically detected:**
```
"Check the status of SITE-456"
"I'm working on PROJ-123"
"What's in WEB-789?"
"Is BLOG-012 ready for QA?"
```

**Needs clarification:**
```
"Check ticket 123" → Ask: "Which project? (e.g., PROJ-123)"
"Status of #456" → Ask: "Which project prefix? (e.g., SITE-456)"
```

## Core Operations

### 1. Quick Status Check

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

### 2. Task Details

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

### 3. Project Context

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

### 4. Link Tasks in PR Descriptions

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

## Teamwork MCP Tools

This skill uses these Teamwork MCP tools (loaded via ToolSearch):

### For Status Checks
```
mcp__teamwork__twprojects-get_task
```

**Usage:**
```javascript
ToolSearch("select:mcp__teamwork__twprojects-get_task")
// Then call: mcp__teamwork__twprojects-get_task(task_id: "123456")
```

### For Project Listing
```
mcp__teamwork__twprojects-list_projects
```

### For Task Listing
```
mcp__teamwork__twprojects-list_tasks
mcp__teamwork__twprojects-list_tasks_by_project
```

## Workflow

```
1. Detect ticket number pattern in user input
   └─ If unclear → Ask for clarification

2. Load required Teamwork MCP tool via ToolSearch
   └─ If tool fails → Provide manual lookup instructions

3. Execute read-only query
   └─ If not found → Check project prefix, suggest alternatives

4. Format response with key information
   └─ Always include direct Teamwork link

5. Suggest next actions if relevant
   └─ "Would you like to update this task?"
   └─ "Ready to create a PR for this?"
```

## Error Handling

### Ticket Not Found

**Response:**
```markdown
I couldn't find ticket PROJ-123 in Teamwork.

**Possible reasons:**
- Ticket number might be incorrect
- You might not have access to this project
- Project prefix might be different

**What to try:**
1. Double-check the ticket number
2. Run `/teamwork` to see available projects
3. Check Teamwork directly: https://yourcompany.teamwork.com
```

### MCP Server Not Available

**Response:**
```markdown
I'm unable to connect to the Teamwork MCP server.

**Manual lookup:**
1. Go to https://yourcompany.teamwork.com
2. Search for task: PROJ-123
3. Or use the project search in Teamwork

**To fix MCP server:**
Check that the Teamwork MCP server is configured in your Claude Code settings.
```

### Ambiguous Request

**Response:**
```markdown
I need a bit more context. Are you asking about:
- **Status check:** "What's the status of PROJ-123?"
- **Task details:** "Show me PROJ-123"
- **Update task:** "Update PROJ-123 status to in-progress" (requires teamwork-specialist)

Which would you like?
```

## Integration with PR Workflow

### Auto-detect in Branch Names

When user creates PR, scan branch name for ticket numbers:

**Branch:** `feature/PROJ-123-user-auth`

**Auto-add to PR body:**
```markdown
Implements: PROJ-123
Link: https://example.teamwork.com/tasks/123456
```

### Scan Commit Messages

Look for ticket references in commits:

**Commit:** `"PROJ-123: Add OAuth providers"`

**Auto-add to PR body:**
```markdown
Related Tickets:
- PROJ-123: Implement user authentication
```

### Format PR Description

**Complete PR section:**
```markdown
## Teamwork Tasks

This PR addresses the following tickets:

### Implements
- [PROJ-123: Implement user authentication](https://example.teamwork.com/tasks/123456)
  - Status: In Progress → Completed (when merged)
  - OAuth2 with Google and GitHub

### Related
- [PROJ-100: Database schema updates](https://example.teamwork.com/tasks/123450) (dependency)

## Testing

Testing steps from Teamwork tasks:
1. [Steps from PROJ-123 acceptance criteria]
```

## CMS-Specific Context

### Drupal Projects

When showing task details, highlight Drupal-specific info:
- Multidev environment URLs
- Configuration export requirements
- Module dependencies

**Example:**
```markdown
## PROJ-123 Details

### Drupal Notes
- Multidev: `multidev-proj-123`
- URL: https://multidev-proj-123.pantheonsite.io
- Config: Yes - `drush cex` required
- Modules: webform, custom_auth
```

### WordPress Projects

Highlight WordPress-specific info:
- Staging environment
- Plugin/theme changes
- PHP version requirements

**Example:**
```markdown
## SITE-456 Details

### WordPress Notes
- Staging: https://staging.example.com
- Theme: custom-theme v2.1
- PHP: 8.2 required
- Plugins: No new activations needed
```

### NextJS Projects

Highlight NextJS-specific info:
- Deployment environment
- Build requirements
- Environment variables

**Example:**
```markdown
## APP-789 Details

### NextJS Notes
- Preview: https://preview-proj-789.vercel.app
- Build: `npm run build` required
- Env vars: `NEXT_PUBLIC_API_URL` updated
- API routes: New `/api/auth` endpoint
```

## When to Escalate to Teamwork Specialist

Escalate to the full teamwork-specialist agent when:

1. **User wants to modify tasks**
   - "Update PROJ-123 status"
   - "Assign SITE-456 to John"
   - "Add comment to BLOG-789"

2. **Multiple operations needed**
   - "Show me all tasks for this project and update their priorities"
   - "List overdue tasks and create follow-ups"

3. **Complex queries**
   - "Show me all tasks assigned to me that are blocked"
   - "Find all QA tasks for the last sprint"

4. **Task creation/export**
   - "Create a new task for this bug"
   - "Export these audit findings to Teamwork"

**Escalation message:**
```markdown
For [operation], I'll hand this over to the teamwork-specialist agent which has full
read/write capabilities.

[Spawn teamwork-specialist with context]
```

## Best Practices

**DO:**
- ✅ Provide direct Teamwork links
- ✅ Format output for readability (markdown)
- ✅ Include key info (status, assignee, priority)
- ✅ Suggest next actions
- ✅ Auto-detect ticket numbers in conversation

**DON'T:**
- ❌ Attempt to modify tasks (read-only skill)
- ❌ Overwhelm with too much detail (keep it focused)
- ❌ Make assumptions about ticket number format
- ❌ Ignore error cases (always handle gracefully)

## Examples

### Example 1: Quick Status

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

### Example 2: Task Details

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

### Example 3: Project Listing

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

### Example 4: PR Integration

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

## Output Format

Always structure responses with:

1. **Clear heading** with ticket number and title
2. **Key info** (status, assignee, priority) in bold
3. **Relevant sections** (description, criteria, comments)
4. **Direct link** to Teamwork task
5. **Suggested next actions** (optional)

Use emojis sparingly for status:
- ⏳ In Progress
- 🎯 Ready for QA
- ✓ Complete
- 🚫 Blocked
- 📋 Not Started

## Performance Tips

- Cache project list (update every 24 hours)
- Cache task details (update every 5 minutes)
- Use task IDs not names for API calls
- Batch requests when possible (list multiple tasks at once)
