---
name: teamwork-task-creator
description: Automatically create properly formatted Teamwork tasks when user provides task details, mentions creating tickets, or shares work that needs tracking. Performs context-aware template selection and ensures all required sections are included. Invoke when user says "create a task", "make a ticket", "track this work", or provides requirements to document.
---

# Teamwork Task Creator Skill

## Philosophy

**Task quality determines project success.** A well-written task saves hours of clarification, reduces implementation errors, and ensures consistent quality. This skill ensures every task created follows best practices for web development project management.

## When to Use This Skill

This skill activates when users:
- Say "create a task", "make a ticket", "track this work"
- Provide requirements or features that need documentation
- Mention Teamwork task creation conversationally
- Ask "how do I create a task?"

**Do NOT activate for:**
- Quick status checks (use teamwork-integrator instead)
- Exporting audit findings (use teamwork-exporter instead)
- Updating existing tasks
- Complex multi-task workflows (escalate to teamwork-specialist agent)

## Template Selection Algorithm

The skill uses context clues to select the appropriate template:

### Decision Tree

```
1. Check for bug indicators:
   - Keywords: "bug", "error", "broken", "crash", "issue", "defect", "not working"
   - If present → BUG REPORT TEMPLATE

2. Check for QA handoff indicators:
   - Keywords: "ready for qa", "qa handoff", "testing", "validate", "test this"
   - Phrases: "hand off to qa", "qa team", "needs testing"
   - If present → QA HANDOFF TEMPLATE

3. Check for epic/big task indicators:
   - Keywords: "multiple devs", "integration branch", "epic", "multidev", "phased"
   - Complexity: mentions "depends on", "blocked by", "multiple components"
   - Scope: estimates >8 hours, mentions team coordination
   - If present → BIG TASK/EPIC TEMPLATE

4. Default to LITTLE TASK TEMPLATE:
   - Single developer work
   - Clear, focused scope
   - Straightforward implementation
```

### Context Analysis Examples

**Bug Report:**
- "There's a crash when users click the checkout button"
- "The form validation is broken on mobile"
- "I found an error in the login flow"

**QA Handoff:**
- "The navigation menu is ready for QA"
- "Can you create a task to test the new search feature?"
- "Need QA to validate the responsive design"

**Big Task/Epic:**
- "Implement OAuth authentication with multiple providers"
- "Need an integration branch for the checkout redesign"
- "Create an epic for the multi-step form wizard"

**Little Task:**
- "Add a logout button to the header"
- "Change the button color to match brand"
- "Update the copyright year in the footer"

## Task Templates

All task templates are available in the templates directory:

- **[All Four Templates](templates/task-templates.md)** - Big Task/Epic, Little Task, QA Handoff, and Bug Report templates with required and optional sections
- **[CMS Platform Notes](templates/cms-platform-notes.md)** - Drupal, WordPress, and NextJS specific guidance
- **[Task Examples](templates/task-examples.md)** - Good vs. bad task examples with explanations
- **[Priority Guide](templates/priority-guide.md)** - P0-P4 priority levels and when to use each

Use these templates as starting points, customizing for specific project needs.

## Handling Missing Information

When users don't provide complete information:

1. **For Required Sections**: Ask clarifying questions
   - "What's the expected behavior when the user clicks submit?"
   - "Which URL should QA use to test this?"
   - "What browser did you see this error in?"

2. **For Optional Sections**: Use placeholders
   - "(add design reference when available)"
   - "(fill in browser testing matrix when picking up ticket)"
   - "(performance considerations to be determined during implementation)"

3. **For Ambiguous Scope**: Escalate to teamwork-specialist
   - If user says "improve the search feature" without specifics
   - If multiple interpretations possible
   - If epic vs. task classification unclear


## Integration with Teamwork Specialist

This skill handles simple, single-task creation. For complex scenarios, escalate to the teamwork-specialist agent:

**Escalate when:**
- User wants to create multiple related tasks
- Epic with sub-tasks needed
- Batch export of audit findings
- Complex dependencies to manage
- Unclear scope requiring investigation

**Example escalation:**
```
User: "Create tasks for implementing the entire checkout redesign"

Response: "This sounds like a big task that would benefit from the teamwork-specialist
agent. It can help break this down into an epic with multiple sub-tasks and manage
dependencies. Let me spawn that agent for you."

[Spawn teamwork-specialist agent with full context]
```

## Best Practices

**DO:**
- ✅ Always include direct page URLs for testing
- ✅ Provide explicit validation steps (numbered lists)
- ✅ Note all deployment requirements (cache, migrations, env vars)
- ✅ Link to designs, documentation, related tickets
- ✅ Specify browser/device testing needs
- ✅ Include CMS-specific context (version, modules/plugins)
- ✅ Use proper markdown formatting for readability

**DON'T:**
- ❌ Create tasks with vague descriptions ("fix the thing")
- ❌ Omit testing instructions
- ❌ Forget deployment notes
- ❌ Assume developers know implicit requirements
- ❌ Skip reproduction steps for bugs
- ❌ Leave required sections empty

## Output Format

When creating a task, provide:

1. **Template selected and why**
   - "I'm using the Bug Report template because you mentioned an error..."

2. **Complete task content**
   - Formatted as markdown, ready to paste into Teamwork

3. **Suggested priority**
   - "I suggest P1 (High) priority because this affects checkout."

4. **Next steps**
   - "Would you like me to create this task in Teamwork now?"
   - Or: "Here's the formatted task. Copy/paste into Teamwork or let me create it via API."

## Example Workflow

**User:** "Create a task for fixing the broken newsletter signup form"

**Skill Response:**

> I'm using the **Bug Report Template** because you mentioned "broken" functionality.
>
> However, I need a few more details to create a complete bug report:
>
> 1. **What's the exact error or problem?** (e.g., "500 error", "nothing happens", "wrong email sent")
> 2. **Where does this happen?** (specific URL)
> 3. **What browser/device did you observe this on?**
> 4. **What were you doing when it broke?** (reproduction steps)
>
> Once you provide these details, I'll create a complete bug report task with all required sections.

**User:** "It's on /newsletter page, when I click Submit nothing happens, tested on Chrome/Mac"

**Skill Response:**

> Perfect! Here's the formatted task:
>
> [Complete Bug Report Template filled in]
>
> **Suggested Priority:** P1 (High) - Newsletter signup is important for lead generation
>
> Would you like me to create this task in Teamwork now, or would you prefer to review/edit first?
