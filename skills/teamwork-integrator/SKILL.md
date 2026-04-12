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

The skill recognizes standard ticket formats (PROJ-123, SITE-456, etc.) and can clarify ambiguous references.

For complete pattern details, see **[Ticket Patterns](templates/ticket-patterns.md)**.

## Core Operations

The skill provides four read-only operations:

1. **Quick Status Check** - Status, assignee, priority, due date
2. **Task Details** - Full description, criteria, comments, dependencies
3. **Project Context** - List active projects and recent tasks
4. **Link Tasks in PRs** - Auto-detect ticket numbers in branches/commits

For complete operation details and examples, see **[Operations Reference](templates/operations-reference.md)**.

For MCP tool usage, see **[MCP Tools Reference](templates/mcp-tools-reference.md)**.

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

When displaying task details, highlight platform-specific information (Drupal multidev URLs, WordPress staging, NextJS preview environments).

For complete CMS context examples, see **[CMS Context](templates/cms-context.md)**.

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

## References

Complete reference materials available in the templates directory:

- **[Ticket Patterns](templates/ticket-patterns.md)** - Supported ticket number formats and pattern matching
- **[Operations Reference](templates/operations-reference.md)** - Detailed documentation for all four core operations
- **[Integration Examples](templates/integration-examples.md)** - Real-world usage examples for each operation
- **[CMS Context](templates/cms-context.md)** - Drupal, WordPress, and NextJS specific information
- **[MCP Tools Reference](templates/mcp-tools-reference.md)** - Teamwork MCP tools and usage patterns
- **[Performance Tips](templates/performance-tips.md)** - Caching and optimization strategies

Use these references to understand operation details and implementation patterns.
