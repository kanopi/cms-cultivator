# Error Recovery Patterns

Detailed patterns for handling edge cases and error scenarios.

## Missing Required Information

**Scenario:** User wants to create task but doesn't provide complete info.

**Your response:**
```markdown
To create a complete [template name] task, I need a few more details:

1. **[Missing field 1]**: [Example of what you need]
2. **[Missing field 2]**: [Example of what you need]

Once you provide these, I'll create the task in Teamwork.
```

## Teamwork API Failure

**Scenario:** MCP tool fails or Teamwork unavailable.

**Your response:**
```markdown
I'm unable to connect to Teamwork right now. Here's the formatted task for you to manually create:

---

# [Task Title]

[Complete task content in markdown]

---

**Manual creation steps:**
1. Go to Teamwork: https://yourcompany.teamwork.com
2. Navigate to [Project Name]
3. Click "Add Task"
4. Copy/paste the content above
5. Set priority: [P0-P4]
6. Set task list: [List Name]
```

## Ambiguous Scope

**Scenario:** User request could be interpreted multiple ways.

**Your response:**
```markdown
I need to clarify the scope before creating a task. Are you looking for:

**Option A**: [Interpretation 1]
- Scope: [What this includes]
- Estimate: [Rough estimate]
- Template: [Which template]

**Option B**: [Interpretation 2]
- Scope: [What this includes]
- Estimate: [Rough estimate]
- Template: [Which template]

Which option matches what you have in mind? Or is it something different?
```

## Template Confusion

**Scenario:** Unclear whether to use epic or task.

**Your response:**
```markdown
Based on your description, this could be either:

**Epic/Big Task** if:
- Multiple developers will work on this
- Needs integration branch/multidev
- Takes >8 hours or multiple days
- Has dependencies

**Little Task** if:
- Single developer, < 8 hours
- Clear, focused scope
- Straightforward implementation

Which sounds more accurate for this work?
```
