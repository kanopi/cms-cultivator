# Project Management Skills

Three skills integrate with Teamwork for project management, task tracking, and team coordination. All three run directly from the main session using the Teamwork MCP server — no orchestrator agent is involved.

!!! info "Teamwork MCP required"
    These skills depend on the Teamwork MCP server being configured in your Claude Code, Claude Desktop, or Codex client. The skills call `mcp__teamwork__twprojects-*` tools directly. Without the MCP, the skills can still produce formatted task content for manual entry, but cannot create or look up tasks.

---

## Available Skills

### teamwork-task-creator

**Purpose:** Create Teamwork tasks from conversation context with automatic template selection.

**Auto-invoked triggers:** "create a Teamwork task", "add this to Teamwork", "log this as a task"

**Quick examples:**
```
"Create a Teamwork task for this security issue"
"Log this performance bug in Teamwork"
```

### teamwork-integrator

**Purpose:** Look up Teamwork tasks and cross-reference with code changes.

**Auto-invoked triggers:** ticket number provided (e.g. PROJ-123), "find Teamwork task", "look up ticket"

### teamwork-exporter

**Purpose:** Export audit findings as Teamwork-compatible CSV for project management tools.

**Auto-invoked triggers:** "export audit to Teamwork", "create Teamwork tasks from audit"

---

## Comprehensive Guide

For detailed information about Teamwork integration, including:
- MCP server setup
- Task template selection guide
- Integration with audit skills
- Best practices
- CMS-specific examples

**See:** [Teamwork Integration Guide](../project-management/teamwork-integration.md)

---

## Key Features

### Template-Based Task Creation

Four task templates with automatic selection:
- **Big Task/Epic** - Complex features, multiple developers
- **Little Task** - Straightforward work, single developer
- **QA Handoff** - Work ready for testing
- **Bug Report** - Defects and broken functionality

### Audit Export

Convert findings from audit skills into tracked Teamwork tasks:
- Security vulnerabilities → Bug Report tasks
- Performance issues → Optimization tasks
- Accessibility violations → Compliance tasks
- Code quality issues → Improvement tasks

### Git Integration

Automatically detect and link:
- Ticket numbers in branch names
- Ticket references in commit messages
- PRs to Teamwork tasks

### CMS-Specific Context

Tasks automatically include relevant context:
- **Drupal:** Multidev environments, configuration management, cache clearing
- **WordPress:** Staging URLs, plugin/theme info, PHP requirements
- **NextJS:** Deployment environments, build requirements, API routes

---

## Integration with Other Skills

Teamwork skills work seamlessly with:

- **[pr-create](pr-workflow.md)** - Auto-links PRs to tickets
- **[audit-security](security.md)** - Export security findings
- **[audit-perf](performance.md)** - Export performance issues
- **[audit-a11y](accessibility.md)** - Export accessibility violations
- **[quality-analyze](code-quality.md)** - Export code quality tasks

---

## Requirements

**Required:**
- CMS Cultivator plugin
- Teamwork account

**Recommended:**
- Teamwork MCP server (enables direct API integration)

**Without MCP server:** Agent provides formatted markdown for manual task creation.

---

## Next Steps

- **[Teamwork Integration Guide](../project-management/teamwork-integration.md)** - Complete documentation
- **[Agents & Skills](../agents-and-skills.md)** - How skills auto-activate (the three Teamwork skills run directly from the main session — no agent in between)
