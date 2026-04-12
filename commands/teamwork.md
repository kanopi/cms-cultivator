---
description: Create, update, and manage Teamwork tasks with expert project management guidance
argument-hint: "[operation] [args]"
allowed-tools: Bash(git:*), Bash(gh:*), Read, Glob, Grep, Write, Edit, ToolSearch
---

# /teamwork

Comprehensive Teamwork project management for Drupal, WordPress, and NextJS projects. Create properly formatted tasks, export audit findings, link code changes to tickets, and manage project workflows with expert guidance.

## Quick Start

**Create a new task:**
```bash
/teamwork create
/teamwork create --type=epic
/teamwork create --template=bug
```

**Update existing task:**
```bash
/teamwork update PROJ-123
/teamwork update PROJ-123 --status=in-progress
```

**Export audit findings:**
```bash
/teamwork export audit-results.md
/teamwork export --source=security-scan
```

**Link git changes to ticket:**
```bash
/teamwork link PROJ-123
/teamwork link PROJ-123 --branch=feature/new-component
```

**Check task status:**
```bash
/teamwork status PROJ-123
```

## Operations

### create

Create a new Teamwork task using appropriate template.

**Arguments:**
- `--type=epic|task|bug|qa` - Specify task type (agent infers if omitted)
- `--template=big-task|little-task|qa-handoff|bug-report` - Explicit template selection
- `--project=PROJECT_ID` - Target project (defaults to current)
- `--priority=0-4` or `--priority=P0-P4` - Priority level (0=critical, 2=medium, 4=backlog)

**Context-Based Template Selection:**

The agent automatically chooses the appropriate template based on your description:

- **Epic/Big Task**: Detects keywords like "multiple devs", "integration branch", "epic", scope indicators suggesting complex work requiring team coordination
- **Little Task**: Detects keywords like "quick fix", "simple change", small scope indicators for straightforward single-developer work
- **QA Handoff**: Detects keywords like "ready for QA", "testing", "handoff" when work is complete and needs validation
- **Bug Report**: Detects keywords like "bug", "error", "broken", "issue" when reporting defects

**Examples:**

```bash
# Agent infers Big Task/Epic template
/teamwork create
# Then describe: "Implement OAuth authentication with multiple providers"

# Explicit bug report
/teamwork create --type=bug --priority=1

# Create epic with high priority
/teamwork create --type=epic --priority=P1
```

### update

Update existing Teamwork task.

**Arguments:**
- `TICKET_NUMBER` (required) - Format: PROJ-123, SITE-456, etc.
- `--status=not-started|in-progress|completed` - Update status
- `--assignee=username` - Assign to team member
- `--comment="text"` - Add comment

**Examples:**

```bash
# Mark task as in progress
/teamwork update PROJ-123 --status=in-progress

# Assign to team member
/teamwork update PROJ-123 --assignee=jane.dev

# Add comment
/teamwork update PROJ-123 --comment="Waiting on API documentation"

# Combine updates
/teamwork update PROJ-123 --status=completed --comment="Ready for deployment"
```

### export

Export audit findings or reports to Teamwork tasks.

**Arguments:**
- `REPORT_FILE` - Markdown or JSON report file path
- `--source=audit-type` - Specify audit source (security, performance, accessibility, quality)
- `--batch` - Create epic for multiple related findings
- `--priority=0-4` - Override priority for all exported tasks

**Examples:**

```bash
# Export security audit with epic
/teamwork export security-audit.md --batch

# Export performance findings
/teamwork export --source=performance

# Override priority for all tasks
/teamwork export audit-report.json --priority=1
```

**Integration with audit commands:**

Audit commands can automatically trigger export:

```bash
# Run security audit, then export findings
/audit-security --comprehensive
# Agent asks: "Export findings to Teamwork?"

# Or explicit export after audit
/audit-a11y
/teamwork export --source=accessibility
```

### link

Link current branch/commit/PR to Teamwork ticket.

**Arguments:**
- `TICKET_NUMBER` (required)
- `--branch=name` - Specific branch (defaults to current)
- `--pr=number` - Link specific PR

**Examples:**

```bash
# Link current branch to ticket
/teamwork link PROJ-123

# Link specific branch
/teamwork link PROJ-123 --branch=feature/user-auth

# Link existing PR
/teamwork link PROJ-123 --pr=456
```

**Auto-detection:**

The agent automatically detects ticket numbers in:
- Branch names: `feature/PROJ-123-description`
- Commit messages: `"PROJ-123: Add user authentication"`
- PR titles and descriptions

When creating PRs with `/pr-create`, ticket links are automatically added if detected.

### status

Quick status check for a task.

**Arguments:**
- `TICKET_NUMBER` (required)

**Examples:**

```bash
# Check task status
/teamwork status PROJ-123

# Check multiple tasks
/teamwork status PROJ-123
/teamwork status SITE-456
```

**Conversational alternative:**

You can also check status conversationally without the command:

```
"What's the status of PROJ-123?"
"Show me SITE-456"
```

The teamwork-integrator skill activates automatically for quick lookups.

## Task Templates

The agent uses four templates based on task type:

### 1. Big Task/Epic Template

**For complex features requiring:**
- Multiple developers
- Integration branch/multidev environment
- Epic-level coordination
- Dependencies and phased delivery

**Includes sections for:**
- Background and business context
- Detailed requirements
- Technical approach
- Integration branch setup
- Dependencies (blocks/blocked by)
- Acceptance criteria
- Testing plan (unit, integration, manual)
- Deployment notes
- Resources (designs, docs, related tickets)

**Example use case:**
```
"Implement OAuth authentication with Google and GitHub providers,
including user profile creation and account linking"
```

### 2. Little Task Template

**For straightforward tasks:**
- Single developer
- Clear, focused scope
- < 8 hours estimated
- Direct implementation

**Includes sections for:**
- Task description
- Acceptance criteria (checkboxes)
- Testing steps (numbered)
- Validation (test URL, expected result)
- Files to change
- Deployment notes

**Example use case:**
```
"Add logout button to header navigation with proper styling"
```

### 3. QA Handoff Template

**For handing work to QA team:**
- Testing instructions
- Expected outcomes
- Test environments
- Known issues

**Includes sections for:**
- What was built (summary)
- Test environment (URL, credentials, browsers)
- Testing instructions (test cases with steps)
- Regression testing checklist
- Known issues
- Success criteria
- Notes for QA

**Example use case:**
```
"Contact form is complete and ready for QA validation"
```

### 4. Bug Report Template

**For reporting defects:**
- Reproduction steps (must be reliable)
- Expected vs. actual behavior
- Browser/OS information
- Screenshots/video

**Includes sections for:**
- Bug description
- Steps to reproduce (reliable, numbered)
- Expected behavior
- Actual behavior
- Environment (browser, OS, device, URL, user role)
- Screenshots/video
- Console errors
- Frequency (always/intermittent)
- Impact level
- Workaround (if any)
- Additional context

**Example use case:**
```
"Contact form submit returns 500 error on production"
```

## How It Works

This command spawns the **teamwork-specialist** agent with three supporting skills:

### teamwork-task-creator Skill
Handles template-based task creation with context-aware template selection. Ensures all required sections are included and tasks are properly formatted.

**Activates for:** Single task creation, straightforward workflows

### teamwork-integrator Skill
Provides quick lookups and status checks without full agent invocation. Read-only operations for fast context retrieval.

**Activates for:** Status checks, ticket number mentions, PR linking

### teamwork-exporter Skill
Converts audit findings into actionable Teamwork tasks with appropriate priorities, templates, and dependencies.

**Activates for:** Batch export of audit results, security/performance/accessibility findings

**For complete workflow and technical details**, see:
→ [`skills/teamwork-task-creator/SKILL.md`](../skills/teamwork-task-creator/SKILL.md)
→ [`skills/teamwork-integrator/SKILL.md`](../skills/teamwork-integrator/SKILL.md)
→ [`skills/teamwork-exporter/SKILL.md`](../skills/teamwork-exporter/SKILL.md)

## Integration with Other Commands

The Teamwork agent integrates seamlessly with:

### /pr-create
Auto-links PR to Teamwork ticket when:
- Ticket number in branch name (`feature/PROJ-123-description`)
- Ticket mentioned in commit messages
- Explicit linking via `/teamwork link`

**Example workflow:**
```bash
# Create feature branch with ticket number
git checkout -b feature/PROJ-123-user-auth

# Make changes and commit
git add .
git commit -m "PROJ-123: Implement OAuth providers"

# Create PR (auto-detects PROJ-123)
/pr-create
# → PR description includes ticket link automatically
```

### /audit-* commands
Exports findings to Teamwork tasks:

**Security audit:**
```bash
/audit-security --comprehensive
# Agent finds 8 vulnerabilities
# Prompts: "Export findings to Teamwork?"
# Creates epic with 8 bug report tasks
```

**Performance audit:**
```bash
/audit-perf --scope=entire
# Agent finds optimization opportunities
# Exports as Little Task improvements
```

**Accessibility audit:**
```bash
/audit-a11y --standard
# Agent finds WCAG violations
# Exports as bug reports (Level A violations) and tasks (improvements)
```

### /quality-* commands
Creates improvement tasks from code quality findings:

```bash
/quality-analyze --comprehensive
# Agent identifies refactoring opportunities
# Exports as Little Task or Epic based on scope
```

### /test-plan
Generates QA handoff tasks:

```bash
/test-plan feature-spec.md
# Agent creates comprehensive test plan
# Can export as QA Handoff task to Teamwork
```

## Teamwork MCP Server Requirement

This command requires the **Teamwork MCP server** to be configured in your Claude Code settings.

The agent uses ToolSearch to load Teamwork tools on-demand:
- `mcp__teamwork__twprojects-create_task` - Create tasks
- `mcp__teamwork__twprojects-update_task` - Update tasks
- `mcp__teamwork__twprojects-list_tasks` - List tasks
- `mcp__teamwork__twprojects-get_task` - Get task details
- `mcp__teamwork__twprojects-list_projects` - List projects
- `mcp__teamwork__twprojects-create_comment` - Add comments
- And more...

**Setup required:**

1. Install Teamwork MCP server
2. Configure API credentials
3. Set default project (optional)

If MCP server is unavailable, the agent provides formatted markdown for manual task creation.

## CMS-Specific Guidance

### Drupal Projects

Tasks automatically include Drupal-specific context:
- Multidev environment names and URLs
- Configuration management notes (`drush cex`)
- Module dependencies
- Drupal version requirements
- Cache clearing instructions (`drush cr`)

**Example task addition:**
```markdown
## Drupal Notes
- Version: Drupal 10.2
- Multidev: `multidev-proj-123`
- URL: https://multidev-proj-123.pantheonsite.io
- Modules: webform, custom_auth
- Config: Yes - run `drush cex` after changes
- Cache: Clear after deployment (`drush cr`)
```

### WordPress Projects

Tasks automatically include WordPress-specific context:
- Staging environment URLs
- Plugin/theme activation notes
- WordPress version compatibility
- PHP version requirements

**Example task addition:**
```markdown
## WordPress Notes
- Version: WordPress 6.4
- Staging: https://staging.example.com
- Theme: custom-theme v2.1
- PHP: 8.2 required
- Plugins: No new activations needed
```

### NextJS Projects

Tasks automatically include NextJS-specific context:
- Deployment environments (Vercel, etc.)
- Build/deployment notes
- Node/npm version requirements
- API route changes
- Environment variable updates

**Example task addition:**
```markdown
## NextJS Notes
- Next: 14.1
- Node: 20.x
- Deployment: Vercel (auto-deploy on PR)
- Build: `npm run build` required
- API Routes: New `/api/auth` endpoint
- Env Vars: Add `NEXT_PUBLIC_API_URL` to Vercel
```

## Best Practices

### DO:
- ✅ Provide specific page URLs for validation
- ✅ Include explicit testing steps (numbered lists)
- ✅ Note all deployment requirements (cache, migrations, env vars)
- ✅ Link to designs, documentation, supporting materials
- ✅ Specify browser/device testing needs
- ✅ Use ticket numbers in branch names (`feature/PROJ-123-description`)
- ✅ Reference tickets in commit messages (`PROJ-123: Add feature`)
- ✅ Confirm template selection before creating complex tasks

### DON'T:
- ❌ Create tasks with vague descriptions ("fix the thing")
- ❌ Omit testing instructions
- ❌ Forget deployment notes (leads to deployment issues)
- ❌ Assume developers know implicit requirements
- ❌ Skip reproduction steps for bugs
- ❌ Create 50+ individual tasks (use epics for batch work)
- ❌ Leave required template sections empty

## Examples

### Example 1: Create Epic from Feature Request

**Command:**
```bash
/teamwork create
```

**Dialog:**
```
Agent: "What would you like to create a task for?"

User: "Implement OAuth authentication with Google and GitHub"

Agent: "This sounds like a Big Task/Epic because it involves:
- Multiple authentication providers
- Integration branch likely needed
- Multiple components (backend, frontend, config)
- Estimated >8 hours

Before I create the task, I need some details:
1. Requirements: Any other providers? What about existing users?
2. Technical approach: Specific OAuth library?
3. Environment: Drupal/WordPress/NextJS? Version?
..."

[After gathering details]

Agent: "✓ Task created successfully!

**Title:** Implement OAuth Authentication (Google & GitHub)
**Type:** Epic / Big Task
**Priority:** P1 (High)
**Project:** Website Redesign

**Link:** https://example.teamwork.com/tasks/12345

**Next steps:**
- Create integration branch: `integration/oauth-auth`
- Assign sub-tasks to team members
- Schedule for next sprint
```

### Example 2: Export Security Audit Findings

**Command:**
```bash
/audit-security --comprehensive
# After audit completes...
/teamwork export --source=security --batch
```

**Result:**
```
Agent: "I'll export these 8 security findings to Teamwork.

**Analysis:**
- 1 Critical (SQL injection)
- 3 High (XSS vulnerabilities)
- 4 Medium (CSRF, weak validation)

**Plan:**
- Create epic: 'Security Fixes - OWASP Vulnerabilities'
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
- SEC-105-108: CSRF and Validation Issues (4 tasks)

**Dependencies configured:**
- SEC-102, 103, 104 depend on SEC-101 (fix sanitization first)

**Recommended order:**
1. Start with SEC-101 (critical, blocks others)
2. Tackle P1 XSS in parallel after SEC-101
3. Schedule P2 for next sprint"
```

### Example 3: Link Current Branch to Ticket

**Command:**
```bash
# On branch: feature/PROJ-456-form-validation
/teamwork link PROJ-456
```

**Result:**
```
Agent: "I'll link your PR to PROJ-456.

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
   'Pull request created: #123
   Branch: feature/PROJ-456-form-validation'

3. ✓ Updated task status: In Progress → Ready for Review

**Next steps:**
- Request PR review
- QA can test from PR's preview environment"
```

### Example 4: Quick Status Check

**Command:**
```bash
/teamwork status PROJ-789
```

**Result:**
```
## PROJ-789 Status

**Title:** Implement user authentication

**Status:** In Progress ⏳

**Assignee:** jane.developer

**Priority:** P1 (High)

**Due:** Jan 20, 2024

**Progress:**
- Last update: 2 hours ago
- Recent comment: "Google OAuth working on staging"

**Link:** https://example.teamwork.com/tasks/789

Would you like to update the status or add a comment?
```

## Tips

**For better task creation:**
1. Provide complete context upfront (requirements, constraints, environment)
2. Include example URLs or mockups when possible
3. Specify testing requirements (browsers, devices, scenarios)
4. Note deployment considerations (cache, migrations, env vars)

**For efficient workflow:**
1. Use ticket numbers in branch names for auto-linking
2. Reference tickets in commit messages
3. Export audit findings in batches (use epics)
4. Link related tasks to show dependencies

**For team coordination:**
1. Use epics for features requiring multiple developers
2. Set appropriate priorities (P0=critical, P2=standard, P4=backlog)
3. Add deployment notes for operations team
4. Link designs and documentation for context

## When to Use Each Template

**Use Big Task/Epic when:**
- Multiple developers needed
- Integration branch required
- Complex scope with dependencies
- Phased delivery
- Epic-level coordination

**Use Little Task when:**
- Single developer, < 8 hours
- Clear, focused scope
- Straightforward implementation
- No complex dependencies

**Use QA Handoff when:**
- Work complete, needs validation
- Handing off to QA team
- Specific test scenarios required
- Regression testing needed

**Use Bug Report when:**
- Something is broken
- Need reproduction steps
- Reporting defect
- Issue needs investigation

## Related Commands

- [`/pr-create`](pr-create.md) - Create PR with auto-linked tickets
- [`/audit-security`](audit-security.md) - Security audit (can export findings)
- [`/audit-perf`](audit-perf.md) - Performance audit (can export findings)
- [`/audit-a11y`](audit-a11y.md) - Accessibility audit (can export findings)
- [`/quality-analyze`](quality-analyze.md) - Code quality (can export tasks)
- [`/test-plan`](test-plan.md) - QA test plan (can export as task)
