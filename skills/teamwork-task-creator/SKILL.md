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

### 1. Big Task/Epic Template

**Use when:**
- Multiple developers required
- Integration branch/multidev environment needed
- Complex scope with dependencies
- Phased delivery or epic-level coordination

**Required Sections:**

```markdown
## Background
[Why this work is needed, business context, user impact]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

## Technical Approach
[High-level technical strategy, architecture decisions]

## Integration Branch/Multidev
- Branch name: `integration/feature-name`
- Environment URL: [will be created]
- Merge strategy: [describe]

## Dependencies
- Depends on: [link related tasks]
- Blocks: [what this blocks]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Testing Plan
- Unit tests: [scope]
- Integration tests: [scope]
- Manual testing: [specific scenarios]

## Deployment Notes
[Special deployment considerations, database migrations, cache clearing]

## Resources
- Design: [Figma link]
- Documentation: [link]
- Related tickets: [links]
```

**Optional Sections:**
- **Performance Considerations**: If performance-critical
- **Security Notes**: If security-sensitive
- **Browser/Device Support**: If cross-browser issues expected

### 2. Little Task Template

**Use when:**
- Single developer can complete
- Clear, focused scope
- Estimated < 8 hours
- No complex dependencies

**Required Sections:**

```markdown
## Task Description
[Clear, concise description of what needs to be done]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Testing Steps
1. Step 1
2. Step 2
3. Step 3

## Validation
- Test URL: [specific page]
- Expected result: [what success looks like]

## Files to Change
- `path/to/file1.php`
- `path/to/file2.js`
- (add more as discovered during implementation)

## Deployment Notes
[Any special deployment steps, cache clearing, etc.]
```

**Optional Sections:**
- **Design Reference**: If design mockup available
- **Related Tasks**: If part of larger feature

### 3. QA Handoff Template

**Use when:**
- Work is complete and ready for QA team
- Testing instructions needed
- Specific validation scenarios required

**Required Sections:**

```markdown
## What Was Built
[Summary of changes, features added, bugs fixed]

## Test Environment
- URL: [staging/multidev URL]
- Credentials: [if needed]
- Browser requirements: [Chrome, Firefox, Safari, etc.]

## Testing Instructions

### Test Case 1: [Name]
**Steps:**
1. Step 1
2. Step 2
3. Step 3

**Expected Result:**
[What should happen]

### Test Case 2: [Name]
**Steps:**
1. Step 1
2. Step 2
3. Step 3

**Expected Result:**
[What should happen]

## Regression Testing
- [ ] Check [related feature 1] still works
- [ ] Check [related feature 2] still works
- [ ] Check [related feature 3] still works

## Known Issues
- [Any known limitations or issues to be aware of]

## Success Criteria
- [ ] All test cases pass
- [ ] No console errors
- [ ] Responsive on mobile/tablet/desktop
- [ ] Accessible (keyboard navigation, screen readers)

## Notes for QA
[Any additional context QA should know]
```

**Optional Sections:**
- **Performance Considerations**: If performance testing needed
- **Browser/Device Matrix**: If specific browser testing required

### 4. Bug Report Template

**Use when:**
- Reporting a defect
- Something is broken or not working as expected
- Need reliable reproduction steps

**Required Sections:**

```markdown
## Bug Description
[Clear description of the problem]

## Steps to Reproduce
**CRITICAL: These must be reliable. QA/Developers must be able to reproduce consistently.**

1. Go to [URL]
2. Click [element]
3. Enter [data]
4. Click [submit]
5. Observe [error]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- Browser: [Chrome 120, Firefox 121, Safari 17, etc.]
- OS: [Windows 11, macOS 14, iOS 17, etc.]
- Device: [Desktop, iPhone 14, Samsung S23, etc.]
- URL: [exact URL where bug occurs]
- User role: [logged in/out, admin/editor/subscriber]

## Screenshots/Video
[Attach screenshots or screen recording]

## Console Errors
[Any JavaScript errors from browser console]

## Frequency
- [ ] Happens every time
- [ ] Happens intermittently (~X% of the time)
- [ ] Happened once

## Impact
- [ ] Critical - Blocks core functionality
- [ ] High - Impacts important feature
- [ ] Medium - Usability issue
- [ ] Low - Minor cosmetic issue

## Workaround
[If any workaround exists, describe it]

## Additional Context
[Any other relevant information]
```

**Optional Sections:**
- **Network Requests**: If API/network related
- **Database State**: If data-specific issue

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

## CMS-Specific Guidance

### Drupal Projects

Always include:
- **Drupal Version**: 9.x, 10.x, 11.x
- **Module Dependencies**: Which contrib/custom modules affected
- **Configuration Management**: Does this export config? (`drush cex` needed?)
- **Cache Clearing**: Required? (`drush cr`)
- **Multidev Environment**: Pantheon multidev name

Example addition:
```markdown
## Drupal Notes
- Version: Drupal 10.2
- Modules: webform, custom_module
- Config exports: Yes - run `drush cex` before committing
- Cache: Clear caches after deployment
- Multidev: `multidev-feature-name`
```

### WordPress Projects

Always include:
- **WordPress Version**: 6.4, 6.5, etc.
- **Plugin/Theme**: Which plugin/theme modified
- **PHP Version**: 8.1, 8.2, etc.
- **Staging Environment**: WP Engine staging, Local, etc.
- **Plugin Activation**: Any plugins need activation?

Example addition:
```markdown
## WordPress Notes
- Version: WordPress 6.4
- Theme: custom-theme
- PHP: 8.2
- Staging: WP Engine staging environment
- Plugins: No new plugin activation needed
```

### NextJS Projects

Always include:
- **Next Version**: 13.x, 14.x, etc.
- **Node Version**: 18.x, 20.x, etc.
- **Build Required**: Yes/No
- **API Routes**: Any new API routes?
- **Environment Variables**: Any new env vars?

Example addition:
```markdown
## NextJS Notes
- Next Version: 14.1
- Node: 20.x
- Build: Yes - `npm run build` required
- API Routes: New `/api/auth` endpoint
- Env Vars: Add `NEXT_PUBLIC_API_URL` to `.env`
```

## Examples: Good vs. Bad Tasks

### ❌ Bad Task Example

```
Title: Fix the form

Description:
The form is broken. Please fix it.
```

**Problems:**
- No specific form identified
- No reproduction steps
- No expected/actual behavior
- No environment information
- No acceptance criteria

### ✅ Good Task Example (Bug Report)

```
Title: Contact form submit fails with 500 error on production

## Bug Description
The contact form on `/contact` page returns a 500 error when submitted with valid data. Form worked on staging but fails on production.

## Steps to Reproduce
1. Go to https://example.com/contact
2. Fill in all fields:
   - Name: "Test User"
   - Email: "test@example.com"
   - Message: "Test message"
3. Click "Submit"
4. Observe 500 error page

## Expected Behavior
Form submits successfully, user sees confirmation message, email sent to admin@example.com

## Actual Behavior
500 error page displays, no email sent

## Environment
- Browser: Chrome 120
- OS: macOS 14
- URL: https://example.com/contact
- User role: Anonymous (not logged in)

## Console Errors
```
POST /contact/submit 500 Internal Server Error
```

## Frequency
- [x] Happens every time

## Impact
- [x] High - Contact form is primary lead generation tool

## Additional Context
- Works correctly on staging: https://staging.example.com/contact
- Deployed to production yesterday (2024-01-15)
- No code changes to contact form in that deploy
```

**Why it's good:**
- Specific URL and form identified
- Reliable reproduction steps (5 steps)
- Clear expected vs. actual behavior
- Complete environment info
- Console errors included
- Impact clearly stated
- Additional context about staging vs. production

### ❌ Bad Task Example (Feature)

```
Title: Add search

Description:
We need search functionality.
```

**Problems:**
- No requirements
- No scope definition
- No acceptance criteria
- No technical approach
- No testing plan

### ✅ Good Task Example (Little Task)

```
Title: Add site-wide search box to header navigation

## Task Description
Add a search input field to the main header navigation (desktop and mobile) that searches all published pages and posts. Search should use WordPress core search functionality.

## Acceptance Criteria
- [ ] Search box appears in header on all pages
- [ ] Search box is keyboard accessible (tab to focus, enter to submit)
- [ ] Search box is visible on desktop (>1024px)
- [ ] Search box is in mobile menu (<1024px)
- [ ] Search results display using existing `/search` template
- [ ] Placeholder text: "Search site..."
- [ ] Icon: Use existing magnifying glass icon from theme

## Testing Steps
1. Go to homepage
2. Click in search box (or tab to it)
3. Type "test query"
4. Press Enter
5. Verify `/search?s=test+query` loads with results
6. Test on mobile (<768px) - search in mobile menu
7. Test keyboard navigation (tab, enter)

## Validation
- Test URL: https://staging.example.com
- Expected result: Search box in header, functional search, responsive on mobile

## Files to Change
- `header.php` - Add search form markup
- `style.css` - Add search box styles
- `mobile-menu.js` - Add search to mobile menu
- (add more as discovered)

## Deployment Notes
- No database changes
- Clear browser cache to see CSS changes
- Test on staging before pushing to production

## WordPress Notes
- Version: WordPress 6.4
- Theme: custom-theme
- PHP: 8.2
- Staging: https://staging.example.com
- Uses WP core search (no plugin needed)
```

**Why it's good:**
- Clear, specific scope (header search box)
- Detailed acceptance criteria (7 items)
- Complete testing steps (7 steps with mobile and accessibility)
- Validation details (URL, expected result)
- Files identified
- Deployment notes included
- WordPress-specific context

## Priority Mapping

When creating tasks, suggest appropriate priorities:

- **P0 (Critical)**: Production down, data loss, security vulnerability
- **P1 (High)**: Major feature broken, blocks other work, high-impact bug
- **P2 (Medium)**: Standard feature work, moderate bugs, improvements
- **P3 (Low)**: Minor bugs, small enhancements, nice-to-haves
- **P4 (Backlog)**: Future work, ideas, technical debt

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
