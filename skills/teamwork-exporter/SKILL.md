---
name: teamwork-exporter
description: Automatically export audit findings, security issues, performance problems, or accessibility violations to Teamwork tasks when other agents complete their analysis. Converts technical findings into actionable project management tasks with appropriate priorities and templates. Invoke when audit agents finish reports, user says "export to Teamwork", or findings need project tracking.
---

# Teamwork Exporter Skill

## Philosophy

**Bridge the gap between technical findings and project execution.** Audit reports identify problems; this skill transforms them into tracked, prioritized work items that teams can action.

## When to Use This Skill

This skill activates when:
- Audit agents complete their analysis (security, performance, accessibility, quality)
- User says "export to Teamwork", "create tasks from this report"
- Findings need to be tracked in project management
- Technical debt needs to be prioritized and scheduled

**Do NOT activate for:**
- Single task creation (use teamwork-task-creator instead)
- Quick status checks (use teamwork-integrator instead)
- Manual task updates (escalate to teamwork-specialist)

## Core Responsibilities

### 1. Parse Audit Reports

Recognize and parse these audit report formats:

**Markdown reports:**
- Headers indicate finding categories
- Severity levels: Critical, High, Medium, Low
- Code blocks show affected code
- File paths and line numbers

**JSON reports:**
- Structured data from automated tools
- Severity scores (0-10 or Critical/High/Medium/Low)
- File paths and rules violated
- Remediation suggestions

**Common audit types:**
- Security audits (OWASP Top 10, CVE findings)
- Performance audits (Core Web Vitals, lighthouse scores)
- Accessibility audits (WCAG violations)
- Code quality audits (complexity, standards violations)

### 2. Convert Findings to Tasks

**Transformation rules:**

1. **Group related findings**
   - Same file/component
   - Same vulnerability type
   - Same fix strategy

2. **Create epic for multiple related issues**
   - If 3+ findings in same category
   - Example: "Security Fixes - XSS Vulnerabilities"

3. **Individual tasks for each finding**
   - Clear title: "[Type] in [File/Component]"
   - Complete description with context
   - Remediation steps
   - Testing requirements

4. **Set appropriate template**
   - Security/bugs → Bug Report template
   - Performance improvements → Little Task template
   - Major refactors → Big Task/Epic template
   - Completed work needing validation → QA Handoff template

### 3. Priority Mapping

Map audit severity to Teamwork priority (Critical→P0, High→P1, Medium→P2, Low→P3, Info→P4).

For complete mapping tables, see **[Priority Mapping](templates/priority-mapping.md)**.

### 4. Template Selection Logic

Select appropriate task template based on finding type (security→bug report, performance→little task, etc.).

For complete selection algorithm, see **[Template Selection](templates/template-selection.md)**.

## Audit Type Handlers

Complete transformation examples for each audit type are available in the audit-handlers directory:

- **[Security Export](templates/audit-handlers/security-export.md)** - Security scan results to Bug Report tasks
- **[Performance Export](templates/audit-handlers/performance-export.md)** - Performance issues to Little Task templates
- **[Accessibility Export](templates/audit-handlers/accessibility-export.md)** - WCAG violations to Bug Reports or Little Tasks
- **[Quality Export](templates/audit-handlers/quality-export.md)** - Code quality issues to Little Tasks or Epics

### Quick Reference

**Security:** OWASP/CVE findings → Bug Report tasks with CWE classification
**Performance:** Lighthouse/Core Web Vitals → Little Task for optimizations
**Accessibility:** WCAG violations → Bug Reports (Level A/AA) or Little Tasks
**Code Quality:** Complexity/standards → Little Tasks or Epics for refactors

## Batch Export Patterns

Three common patterns for organizing multiple findings: Epic with Sub-Tasks (3+ related findings), Priority Buckets (mixed severity), Component-Based (multiple issues in same component).

For complete patterns and structures, see **[Batch Patterns](templates/batch-patterns.md)**.

## Dependency Management

Auto-detect blocking relationships (database changes block features, security fixes block deployment, etc.) and link tasks appropriately.

For dependency detection patterns, see **[Dependency Management](templates/dependency-management.md)**.

## Integration with Audit Agents

The skill receives findings from four audit specialists (security, performance, accessibility, quality) and converts them to appropriate task templates.

For integration details, see **[Agent Integration](templates/agent-integration.md)**.

## Teamwork MCP Tools

Uses Teamwork MCP tools loaded via ToolSearch for task creation, project listing, and milestone/epic creation.

For tool reference, see **[MCP Tools](templates/mcp-tools.md)**.

## Workflow

```
1. Receive audit report from specialist agent
   └─ Parse format (markdown, JSON, structured data)

2. Analyze findings
   └─ Group related issues
   └─ Determine priority mapping
   └─ Select appropriate templates

3. Decide export strategy
   └─ Single task vs. epic with sub-tasks
   └─ Identify dependencies

4. Load Teamwork MCP tools via ToolSearch
   └─ If epic: create parent first
   └─ Create individual tasks
   └─ Link dependencies

5. Confirm export
   └─ List created tasks with links
   └─ Provide summary statistics
   └─ Suggest next actions
```

## Output Format

After export, provide comprehensive summary:

```markdown
## Export Summary

**Audit Type:** Security Scan
**Findings:** 12 issues
**Tasks Created:** 13 (1 epic + 12 sub-tasks)

### Created Tasks

#### Epic
- [SEC-2024: Security Fixes - XSS Vulnerabilities](https://example.teamwork.com/tasks/100)
  - Priority: P1 (High)
  - Sub-tasks: 12

#### Critical (P0)
- [SEC-101: SQL Injection in User Search](https://example.teamwork.com/tasks/101)

#### High (P1)
- [SEC-102: XSS in User Profile](https://example.teamwork.com/tasks/102)
- [SEC-103: XSS in Comment Form](https://example.teamwork.com/tasks/103)
- [SEC-104: CSRF Missing on Forms](https://example.teamwork.com/tasks/104)

#### Medium (P2)
- 8 additional tasks (see epic for full list)

### Dependencies Configured
- SEC-102, SEC-103, SEC-104 depend on SEC-101 (fix core sanitization first)

### Recommended Actions
1. Start with SEC-101 (critical SQL injection)
2. Then tackle P1 XSS issues in parallel
3. Schedule P2 fixes for next sprint

### Next Steps
- Assign tasks to team members
- Set sprint milestones
- Update team on security priorities
```

## Best Practices

**DO:**
- ✅ Group related findings into epics
- ✅ Map severity to priority accurately
- ✅ Include complete context (files, lines, code)
- ✅ Provide remediation steps
- ✅ Link dependencies
- ✅ Add testing requirements

**DON'T:**
- ❌ Create 50+ individual tasks (use epics)
- ❌ Lose critical details in conversion
- ❌ Ignore severity levels
- ❌ Create tasks without remediation guidance
- ❌ Forget to link related tasks

## Error Handling

Fallback strategies for MCP server unavailability (provide formatted markdown for manual entry) and ambiguous findings (request clarification).

For detailed error handling patterns, see **[Error Handling](templates/error-handling.md)**.

## References

Complete reference materials available in the templates directory:

- **[Priority Mapping](templates/priority-mapping.md)** - Severity to priority conversion tables
- **[Template Selection](templates/template-selection.md)** - Logic for choosing task templates
- **[Batch Patterns](templates/batch-patterns.md)** - Epic creation and task grouping strategies
- **[Dependency Management](templates/dependency-management.md)** - Auto-detecting task dependencies
- **[Agent Integration](templates/agent-integration.md)** - How audit agents pass data to exporter
- **[MCP Tools](templates/mcp-tools.md)** - Teamwork MCP tools for export
- **[Error Handling](templates/error-handling.md)** - Fallback strategies when MCP unavailable

### Audit Type Handlers

- **[Security Export](templates/audit-handlers/security-export.md)** - Security findings to bug reports
- **[Performance Export](templates/audit-handlers/performance-export.md)** - Performance issues to tasks
- **[Accessibility Export](templates/audit-handlers/accessibility-export.md)** - WCAG violations to bug reports
- **[Quality Export](templates/audit-handlers/quality-export.md)** - Code quality issues to refactoring tasks

Use these references to understand transformation patterns and implementation details.
