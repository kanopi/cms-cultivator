# Implementation Plan: Teamwork Project Management Agent & Skills

## Overview

Create a comprehensive Teamwork integration for CMS Cultivator that provides expert project management and solutions architecture capabilities for Drupal, WordPress, and NextJS projects. This will include:

1. **Teamwork Specialist Agent** - Orchestrator for all Teamwork operations
2. **Multiple Agent Skills** - Specialized skills for different Teamwork workflows
3. **/teamwork Slash Command** - User-facing interface with flexible arguments
4. **Template Logic** - Context-aware task template selection

## Architecture

### Component Structure

```
cms-cultivator/
├── agents/
│   └── teamwork-specialist/
│       └── AGENT.md
├── skills/
│   ├── teamwork-task-creator/
│   │   └── SKILL.md
│   ├── teamwork-integrator/
│   │   └── SKILL.md
│   └── teamwork-exporter/
│       └── SKILL.md
└── commands/
    └── teamwork.md
```

## Phase 1: Teamwork Specialist Agent

**File**: `/agents/teamwork-specialist/AGENT.md`

### Frontmatter

```yaml
---
name: teamwork-specialist
description: Use this agent when you need to create, update, or manage Teamwork tasks, export audit findings to project management, or link code changes to tickets. Expert in Drupal, WordPress, and NextJS project architecture. Should be used when users mention "Teamwork", "create task", "export to Teamwork", provide ticket numbers (PROJ-123 format), or when other agents need to create issues from findings. It will create tasks using appropriate templates, update existing tasks, export audit results as formatted tasks, and link git commits/PRs to Teamwork tickets.
tools: Read, Glob, Grep, Bash, Write, Edit, Task, ToolSearch, mcp__teamwork__*
skills: teamwork-task-creator, teamwork-integrator, teamwork-exporter
model: sonnet
color: blue
---
```

### Content Sections

1. **When to Use This Agent**
   - Examples of trigger phrases
   - Context-based activation scenarios
   - Integration with other agents (audit specialists, workflow specialists)

2. **Core Responsibilities**
   - Create tasks using 4 provided templates
   - Read and update existing Teamwork tasks
   - Export audit findings from other specialists
   - Link git commits and PRs to Teamwork tickets
   - Provide project management advice for web projects

3. **Template Selection Logic**
   - **Big Task/Epic**: Multiple developers, integration branch needed, complex scope, dependencies
   - **Little Task**: Single-developer task, straightforward scope, <8 hours estimated
   - **QA Handoff**: When handing off to QA team, includes testing steps and success criteria
   - **Bug Report**: When reporting defects, includes reproduction steps and browser info

4. **Tools Available**
   - Teamwork MCP tools (list_projects, create_task, update_task, list_tasks, etc.)
   - ToolSearch for loading Teamwork MCP tools on-demand
   - Standard tools (Read, Bash for git operations)

5. **Skills You Use**
   - `teamwork-task-creator`: Template-based task creation
   - `teamwork-integrator`: Quick lookups and status checks
   - `teamwork-exporter`: Convert audit results to tasks

6. **Workflow**
   ```
   1. Identify operation type (create/update/export/link)
   2. Load required Teamwork MCP tools via ToolSearch
   3. Delegate to appropriate skill for detailed logic
   4. Execute Teamwork API operations
   5. Confirm success and provide task URLs
   ```

7. **Commands You Support**
   - `/teamwork create [type]` - Create new task
   - `/teamwork update <ticket>` - Update existing task
   - `/teamwork export <report>` - Export audit findings
   - `/teamwork link <ticket>` - Link git changes to ticket
   - `/teamwork status <ticket>` - Check task status

8. **CMS-Specific Context**
   - Drupal: Module development patterns, multidev workflow, configuration management
   - WordPress: Plugin/theme development, staging environments, deployment notes
   - NextJS: Component architecture, API routes, build processes

9. **Best Practices**
   - DO include direct links to specific pages/nodes
   - DO provide explicit validation steps
   - DO note deployment requirements
   - DON'T create tasks without required template sections
   - DON'T assume developers know implicit requirements

10. **Error Recovery**
    - Missing template sections: Include headers with "(fill in when picking up ticket)" notes
    - Teamwork API failures: Provide formatted markdown for manual creation
    - Ambiguous scope: Ask clarifying questions before creating task

## Phase 2: Agent Skills

### Skill 1: teamwork-task-creator

**File**: `/skills/teamwork-task-creator/SKILL.md`

**Frontmatter**:
```yaml
---
name: teamwork-task-creator
description: Automatically create properly formatted Teamwork tasks when user provides task details, mentions creating tickets, or shares work that needs tracking. Performs context-aware template selection and ensures all required sections are included. Invoke when user says "create a task", "make a ticket", "track this work", or provides requirements to document.
---
```

**Content**:
- Philosophy: Task quality determines project success
- Template Selection Algorithm (detailed decision tree)
- Required vs. Optional sections for each template
- How to handle missing information
- Examples of good vs. bad task descriptions

### Skill 2: teamwork-integrator

**File**: `/skills/teamwork-integrator/SKILL.md`

**Frontmatter**:
```yaml
---
name: teamwork-integrator
description: Automatically look up Teamwork task status, details, or project information when user mentions ticket numbers, asks "what's the status of", or needs quick project context. Performs focused queries without creating or modifying data. Invoke when user asks "status of PROJ-123", "what's in that ticket?", "show me task details", or references Teamwork ticket numbers.
---
```

**Content**:
- Quick Status Checks (read-only operations)
- Ticket Number Pattern Recognition (PROJ-123 format)
- Linking tickets in PR descriptions
- Project context retrieval
- When to escalate to full teamwork-specialist

### Skill 3: teamwork-exporter

**File**: `/skills/teamwork-exporter/SKILL.md`

**Frontmatter**:
```yaml
---
name: teamwork-exporter
description: Automatically export audit findings, security issues, performance problems, or accessibility violations to Teamwork tasks when other agents complete their analysis. Converts technical findings into actionable project management tasks with appropriate priorities and templates. Invoke when audit agents finish reports, user says "export to Teamwork", or findings need project tracking.
---
```

**Content**:
- Converting Audit Results to Tasks
- Priority Mapping (P0-P4 based on severity)
- Batching Related Issues (creating epics for multiple findings)
- Template Selection for Different Finding Types
- Linking Related Tasks (dependencies)

## Phase 3: Slash Command

**File**: `/commands/teamwork.md`

### Frontmatter

```yaml
---
description: Create, update, and manage Teamwork tasks with expert project management guidance
argument-hint: [operation] [args]
allowed-tools: Bash(git:*), Bash(gh:*), Read, Glob, Grep, Write, Edit, ToolSearch
---
```

### Command Structure

```markdown
# /teamwork

Comprehensive Teamwork project management for Drupal, WordPress, and NextJS projects.

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
Agent automatically chooses template based on:
- **Epic/Big Task**: Keywords like "multiple devs", "integration branch", "epic", scope indicators
- **Little Task**: Keywords like "quick fix", "simple change", small scope indicators
- **QA Handoff**: Keywords like "ready for QA", "testing", "handoff"
- **Bug Report**: Keywords like "bug", "error", "broken", "issue"

### update
Update existing Teamwork task.

**Arguments:**
- `TICKET_NUMBER` (required) - Format: PROJ-123
- `--status=not-started|in-progress|completed` - Update status
- `--assignee=username` - Assign to team member
- `--comment="text"` - Add comment

### export
Export audit findings or reports to Teamwork tasks.

**Arguments:**
- `REPORT_FILE` - Markdown or JSON report file
- `--source=audit-type` - Specify audit source (security, performance, accessibility, quality)
- `--batch` - Create epic for multiple related findings
- `--priority=0-4` - Override priority for all exported tasks

### link
Link current branch/commit/PR to Teamwork ticket.

**Arguments:**
- `TICKET_NUMBER` (required)
- `--branch=name` - Specific branch (defaults to current)
- `--pr=number` - Link specific PR

### status
Quick status check for a task.

**Arguments:**
- `TICKET_NUMBER` (required)

## Task Templates

The agent uses four templates based on task type:

### 1. Big Task/Epic Template
For complex features requiring:
- Multiple developers
- Integration branch/multidev
- Epic-level coordination
- Dependencies and phased delivery

### 2. Little Task Template
For straightforward tasks:
- Single developer
- Clear scope
- < 8 hours estimated
- Direct implementation

### 3. QA Handoff Template
For handing work to QA team:
- Testing instructions
- Expected outcomes
- Test environments
- Known issues

### 4. Bug Report Template
For reporting defects:
- Reproduction steps (must be reliable)
- Expected vs. actual behavior
- Browser/OS information
- Screenshots

## How It Works

This command spawns the **teamwork-specialist** agent with three supporting skills:
- **teamwork-task-creator**: Template selection and task creation
- **teamwork-integrator**: Quick lookups and status checks
- **teamwork-exporter**: Audit result conversion

**For complete workflow and technical details**, see:
→ [`skills/teamwork-task-creator/SKILL.md`](../skills/teamwork-task-creator/SKILL.md)
→ [`skills/teamwork-integrator/SKILL.md`](../skills/teamwork-integrator/SKILL.md)
→ [`skills/teamwork-exporter/SKILL.md`](../skills/teamwork-exporter/SKILL.md)

## Integration with Other Commands

The Teamwork agent integrates with:
- `/pr-create` - Auto-links PR to Teamwork ticket
- `/audit-*` commands - Exports findings to tasks
- `/quality-*` commands - Creates improvement tasks
- `/test-plan` - Generates QA handoff tasks

## Teamwork MCP Server Requirement

This command requires the Teamwork MCP server to be configured. The agent will use ToolSearch to load Teamwork tools on-demand:
- `mcp__teamwork__twprojects-create_task`
- `mcp__teamwork__twprojects-update_task`
- `mcp__teamwork__twprojects-list_tasks`
- `mcp__teamwork__twprojects-get_task`
- And more...

## CMS-Specific Guidance

### Drupal Projects
- Reference multidev environments in task descriptions
- Include configuration management notes
- Note module dependencies
- Specify Drupal version requirements

### WordPress Projects
- Reference staging/production environments
- Include plugin/theme activation notes
- Note WordPress version compatibility
- Specify PHP version requirements

### NextJS Projects
- Reference Vercel/deployment environments
- Include build/deployment notes
- Note Node/npm version requirements
- Specify API route changes

## Best Practices

DO:
- ✅ Provide specific page URLs for validation
- ✅ Include explicit testing steps
- ✅ Note all deployment requirements
- ✅ Link to designs/documentation
- ✅ Specify browser/device testing needs

DON'T:
- ❌ Create tasks with vague descriptions
- ❌ Omit testing instructions
- ❌ Forget deployment notes
- ❌ Assume implicit requirements
- ❌ Skip linking to supporting materials

## Examples

### Create Epic from Feature Request
```bash
/teamwork create --type=epic
# Agent prompts for: title, description, acceptance criteria
# Automatically uses Big Task/Epic template
# Creates integration branch/multidev section
```

### Export Security Audit Findings
```bash
/teamwork export security-audit.md --batch
# Agent creates epic for security issues
# Individual tasks for each finding
# Priorities based on severity
# Links dependencies
```

### Link Current Branch to Ticket
```bash
/teamwork link PROJ-456
# Agent detects current branch: feature/user-auth
# Adds branch name to task comments
# Updates PR description with ticket link
```

### Quick Status Check
```bash
/teamwork status PROJ-789
# Agent fetches task details
# Shows: status, assignee, progress, blockers
# Returns link to Teamwork task
```
```

## Phase 4: Documentation Updates

### Update Agent Skills Overview

**File**: `/docs/agent-skills.md`

Add three new skills to the "Available Agent Skills" section:

```markdown
### teamwork-task-creator
Create properly formatted Teamwork tasks using context-aware template selection.

**Invoke when:** User mentions "create task", "make ticket", "track this work"
**Related command:** `/teamwork create`

### teamwork-integrator
Quick lookups and status checks for Teamwork tickets.

**Invoke when:** User mentions ticket numbers (PROJ-123), asks "status of", "show me task"
**Related command:** `/teamwork status`

### teamwork-exporter
Convert audit findings into Teamwork tasks.

**Invoke when:** Audit agents complete, user says "export to Teamwork"
**Related command:** `/teamwork export`
```

### Update Commands Overview

**File**: `/docs/commands/overview.md`

Add to the "Project Management" section:

```markdown
### /teamwork
Comprehensive Teamwork project management for web projects.

**Operations:**
- Create tasks with automatic template selection
- Update existing tasks
- Export audit findings
- Link git changes to tickets
- Quick status checks

**Use cases:**
- Converting user stories to tracked tasks
- Exporting audit findings for project planning
- Linking PRs to Teamwork tickets
- Checking task status without leaving CLI
```

### Create New Documentation Page

**File**: `/docs/project-management/teamwork-integration.md`

Comprehensive guide covering:
- Teamwork MCP server setup
- Task template decision guide
- Integration with audit commands
- Best practices for task creation
- Examples for Drupal, WordPress, NextJS projects

### Update zensical.toml

Add new navigation entries:

```toml
[[nav]]
section = "Project Management"
items = [
  { name = "Teamwork Integration", path = "project-management/teamwork-integration" },
]

[[nav.nested]]
section = "Commands"
subsection = "Project Management"
items = [
  { name = "/teamwork", path = "commands/teamwork" },
]
```

## Critical Files to Modify/Create

### New Files (Create)
1. `/agents/teamwork-specialist/AGENT.md` - Main orchestrator agent
2. `/skills/teamwork-task-creator/SKILL.md` - Task creation skill
3. `/skills/teamwork-integrator/SKILL.md` - Quick lookup skill
4. `/skills/teamwork-exporter/SKILL.md` - Audit export skill
5. `/commands/teamwork.md` - User-facing slash command
6. `/docs/project-management/teamwork-integration.md` - Documentation guide

### Modified Files (Update)
1. `/docs/agent-skills.md` - Add three new skills to listing
2. `/docs/commands/overview.md` - Add /teamwork command
3. `/zensical.toml` - Add navigation entries

## Template Selection Algorithm

The agent will use this decision logic:

```python
def select_template(context):
    # Bug indicators
    if any(word in context for word in ['bug', 'error', 'broken', 'crash', 'issue', 'defect']):
        return 'bug-report'

    # QA handoff indicators
    if any(phrase in context for phrase in ['ready for qa', 'qa handoff', 'testing', 'validate']):
        return 'qa-handoff'

    # Epic/Big Task indicators
    epic_keywords = ['multiple devs', 'integration branch', 'epic', 'multidev', 'phased']
    complexity_indicators = ['depends on', 'blocked by', 'acceptance criteria']
    if any(word in context for word in epic_keywords) or len(complexity_indicators_found) > 2:
        return 'big-task-epic'

    # Default: Little Task
    return 'little-task'
```

## MCP Tool Usage Pattern

The agent will load Teamwork MCP tools on-demand:

```markdown
1. Use ToolSearch to find required Teamwork tool:
   - ToolSearch("select:mcp__teamwork__twprojects-create_task")

2. Call the loaded tool with appropriate parameters:
   - Include all required template sections
   - Map priorities correctly (P0-P4)
   - Set proper task type and status

3. Handle responses:
   - Success: Return task URL and confirmation
   - Failure: Provide formatted markdown for manual creation
```

## Verification Steps

After implementation:

1. **Test Agent Invocation**
   ```bash
   # Start Claude Code in a test project
   # Say: "Create a Teamwork task for implementing user authentication"
   # Verify: Agent selects Big Task/Epic template (complex scope)
   # Verify: Agent prompts for required sections
   # Verify: Agent creates task via MCP tool
   ```

2. **Test Skills Auto-Invocation**
   ```bash
   # Say: "What's the status of PROJ-123?"
   # Verify: teamwork-integrator skill activates
   # Verify: Quick status returned without full agent invocation
   ```

3. **Test Command Usage**
   ```bash
   /teamwork create --type=bug
   # Verify: Bug Report template used
   # Verify: All required sections prompted
   ```

4. **Test Export Integration**
   ```bash
   /audit-security --quick
   # After audit completes, say: "Export these findings to Teamwork"
   # Verify: teamwork-exporter skill activates
   # Verify: Multiple tasks created with dependencies
   ```

5. **Test Template Selection Logic**
   - Provide "quick CSS fix" → should select Little Task
   - Provide "implement OAuth with external API" → should select Big Task/Epic
   - Provide "found a crash in checkout" → should select Bug Report
   - Provide "ready to hand off navigation menu" → should select QA Handoff

6. **Test MCP Tool Integration**
   - Verify ToolSearch loads Teamwork tools successfully
   - Verify actual task creation in Teamwork (requires MCP server setup)
   - Verify error handling when MCP server unavailable

## Success Criteria

- ✅ Agent correctly selects templates based on context
- ✅ All four templates properly formatted in created tasks
- ✅ Skills activate on conversational triggers
- ✅ Command handles all five operations (create/update/export/link/status)
- ✅ MCP tools loaded on-demand via ToolSearch
- ✅ Documentation complete and linked in navigation
- ✅ Integration with existing audit/PR commands works
- ✅ Drupal, WordPress, NextJS context properly handled

## Notes

- This implementation follows CMS Cultivator's "Agents Orchestrate, Skills Guide, Commands Interface" architecture
- The Teamwork MCP server must be installed and configured separately
- Template files will be embedded directly in agent/skills (not separate template files)
- Agent uses fully qualified names when spawning other agents: `cms-cultivator:agent-name:agent-name`
- Priority mapping: P0=critical, P1=high, P2=medium, P3=low, P4=backlog (numeric 0-4 format required)
