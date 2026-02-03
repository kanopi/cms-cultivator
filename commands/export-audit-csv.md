---
description: Export audit report to CSV for project management tools (Teamwork, Jira, Monday, etc.)
argument-hint: "[report-file]"
allowed-tools: Read, Write, Bash(date:*)
---

Export audit findings from markdown reports to CSV format for importing into project management tools.

## Usage

```bash
# Export comprehensive audit report
/export-audit-csv audit-live-site-2026-02-02-1430.md

# Export specific audit type
/export-audit-csv security-audit-2026-02-02.md
```

## How It Works

1. **Read audit report** - Parse markdown file for findings
2. **Identify severity levels** - Critical, High, Medium, Low
3. **Create phase structure** - Group tasks by priority
4. **Extract details** - File paths, line numbers, effort estimates
5. **Generate CSV** - Teamwork-compatible format
6. **Save file** - `[original-name]-tasks.csv`

## CSV Output Structure

**Columns:**
- TASKLIST - Phase grouping
- TASK - Individual task name
- DESCRIPTION - Details with file paths, line numbers
- ASSIGN TO - (blank)
- START DATE - (blank)
- DUE DATE - Calculated from priority
- PRIORITY - Critical, High, Medium, Low
- ESTIMATED TIME - Extracted from report (15m, 30m, 1h, 2h)
- TAGS - Security, Performance, Accessibility, Code Quality
- STATUS - Active (default)

**Phase Organization:**
- Phase 1: Critical Issues (DUE DATE = today + 3 days)
- Phase 2: High Priority (DUE DATE = today + 10 days)
- Phase 3: Medium Priority (DUE DATE = today + 20 days)
- Phase 4: Low Priority (no due date)

## Example Output

```csv
TASKLIST,TASK,DESCRIPTION,ASSIGN TO,START DATE,DUE DATE,PRIORITY,ESTIMATED TIME,TAGS,STATUS
Phase 1: Critical Issues,,Blocking launch - must fix immediately,,,2026-02-10,Critical,,,
,SQL Injection in User Search,File: modules/custom/user_search/src/Controller/SearchController.php Line 45: Use parameterized query,,,2026-02-05,Critical,2h,Security,Active
,Unsafe Referrer Policy,Meta tag shows unsafe-url. Privacy violation. Fix: Change to strict-origin-when-cross-origin,,,2026-02-05,Critical,30m,Security,Active
Phase 2: High Priority,,Fix this sprint,,,2026-02-20,High,,,
,Color Contrast Issues,8 instances of insufficient contrast (< 4.5:1). See detailed list in report,,,2026-02-15,High,4h,Accessibility,Active
,Missing Content Security Policy,No CSP header. Implement with strict directives. Effort includes testing period.,,,2026-02-15,High,8h,Security,Active
```

## Parsing Logic

**Section Mapping:**
- `## Critical Issues` or `### CRITICAL` → Phase 1
- `## High Priority Issues` or `### HIGH` → Phase 2
- `## Medium Priority Issues` or `### MEDIUM` → Phase 3
- `## Low Priority Issues` or `### LOW` → Phase 4

**Task Extraction:**
- Heading level 3 (`###`) within priority sections = Individual task
- Extract: Title, severity, file path, line number, description, effort
- Consolidate: "X instances across Y pages" = single task with count

**Effort Estimation:**
- Pattern match: "Estimated Effort: 2 hours" → `2h`
- Pattern match: "15 minutes" → `15m`
- Default if not found: (blank)

**Tag Assignment:**
- Security-related keywords → `Security`
- Performance/optimization → `Performance`
- Accessibility/WCAG → `Accessibility`
- Code quality/standards → `Code Quality`

## File Naming

Output: `[input-basename]-tasks.csv`

Examples:
- `audit-live-site-2026-02-02-1430.md` → `audit-live-site-2026-02-02-1430-tasks.csv`
- `security-audit.md` → `security-audit-tasks.csv`

## Limitations

- Requires structured markdown report from cms-cultivator audit commands
- Teamwork format (other formats: future enhancement)
- Does not assign tasks or set START DATE (manual in PM tool)
