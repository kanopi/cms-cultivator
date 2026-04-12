# Project Management Commands

Integrate with Teamwork for comprehensive project management, task tracking, and team coordination.

---

## Available Commands

### /teamwork

**Purpose:** Create, update, and manage Teamwork tasks with expert project management guidance for Drupal, WordPress, and NextJS projects.

**Documentation:** See [`commands/teamwork.md`](../../commands/teamwork.md) for complete command reference.

**Quick examples:**
```bash
# Create new task
/teamwork create

# Export audit findings
/teamwork export security-audit.md --batch

# Link PR to ticket
/teamwork link PROJ-123
```

---

## Comprehensive Guide

For detailed information about Teamwork integration, including:
- MCP server setup
- Task template selection guide
- Integration with audit commands
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

Convert findings from audit commands into tracked Teamwork tasks:
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

## Integration with Other Commands

Teamwork integration works seamlessly with:

- **[/pr-create](pr-workflow.md)** - Auto-links PRs to tickets
- **[/audit-security](security.md)** - Export security findings
- **[/audit-perf](performance.md)** - Export performance issues
- **[/audit-a11y](accessibility.md)** - Export accessibility violations
- **[/quality-analyze](code-quality.md)** - Export code quality tasks

---

## Requirements

**Required:**
- CMS Cultivator plugin
- Teamwork account

**Recommended:**
- Teamwork MCP server (enables direct API integration)

**Without MCP server:** Agent provides formatted markdown for manual task creation.

---

## Quick Start

1. **Install and configure** (see [Integration Guide](../project-management/teamwork-integration.md#setup))
2. **Create your first task:**
   ```bash
   /teamwork create
   ```
3. **Export audit findings:**
   ```bash
   /audit-security --comprehensive
   /teamwork export --source=security --batch
   ```

---

## Next Steps

- **[Teamwork Integration Guide](../project-management/teamwork-integration.md)** - Complete documentation
- **[/teamwork Command Reference](../../commands/teamwork.md)** - All operations and arguments
- **[Agents & Skills](../agents-and-skills.md)** - How teamwork-specialist agent works
