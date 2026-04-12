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
- TASKLIST - Phase grouping (repeated on every task row)
- TASK - Individual task name (REQUIRED on every row except header)
- DESCRIPTION - Details with file paths, line numbers
- ASSIGN TO - (blank)
- START DATE - (blank)
- DUE DATE - Calculated from priority
- PRIORITY - Critical, High, Medium, Low
- ESTIMATED TIME - Extracted from report (15m, 30m, 1h, 2h)
- TAGS - Security, Performance, Accessibility, Code Quality
- STATUS - Active (default)

**CRITICAL CSV Format Requirements:**

1. **Every row must have a TASK value** (except header row)
   - ❌ NEVER create tasklist-only rows with empty TASK column
   - ✅ ALWAYS populate both TASKLIST and TASK on every data row

2. **Repeat TASKLIST on every task row**
   - ❌ DON'T: Leave TASKLIST blank after first task in phase
   - ✅ DO: Write "Phase 1: Critical Issues" in column A for every task in that phase

3. **Quote all DESCRIPTION values**
   - ✅ ALWAYS wrap entire DESCRIPTION in double quotes
   - Commas, line breaks, and special characters are SAFE inside quotes
   - Markdown formatting (lists, headings, code blocks) is preserved
   - ❌ NEVER leave DESCRIPTION unquoted - will break CSV parsing

4. **Markdown in DESCRIPTION is allowed**
   - Full markdown template can be used
   - Lists, headings, code blocks all work
   - Teamwork and most PM tools render markdown properly
   - Just ensure entire content is wrapped in double quotes

**Phase Organization:**
- Phase 1: Critical Issues (DUE DATE = today + 3 days)
- Phase 2: High Priority (DUE DATE = today + 10 days)
- Phase 3: Medium Priority (DUE DATE = today + 20 days)
- Phase 4: Low Priority (no due date)

## Example Output

```csv
TASKLIST,TASK,DESCRIPTION,ASSIGN TO,START DATE,DUE DATE,PRIORITY,ESTIMATED TIME,TAGS,STATUS
Phase 1: Critical Issues,Fix Color Contrast Violations,"## Description
Teamwork Ticket(s): [To be assigned]
- [ ] Was AI used in this pull request?

> As a developer, I need to fix color contrast violations to achieve WCAG 2.1 AA compliance and eliminate legal liability.

10 CTAs have 1:1 contrast ratio (needs 4.5:1) - WCAG 1.4.3 violation affecting Request Info button, Explore your options CTA, Visit CWI button, Apply to CWI button, View All News link, and navigation dropdowns.

## Acceptance Criteria
* All buttons achieve minimum 4.5:1 contrast ratio
* WCAG 1.4.3 compliance verified with axe DevTools
* Visual design approved by stakeholders
* No regressions on desktop or mobile

## Assumptions
* Designer approval needed for background color changes
* Brand guidelines allow #005ca9 blue background

## Steps to Validate
1. Navigate to https://cwi.edu/
2. Test with axe DevTools (should show 0 contrast violations)
3. Use browser DevTools color picker to verify 4.5:1+ ratio
4. Test keyboard navigation with visible focus indicators

## Affected URL
https://cwi.edu/ (all pages with CTAs)

## Deploy Notes
File: /themes/custom/cwi/css/components/buttons.scss
Update .btn-outline-primary with background-color: #005ca9
Clear Drupal CSS cache after deployment",,,2026-02-22,Critical,2h,"Accessibility, Legal",Active
```

**Note:** The DESCRIPTION column contains the full markdown template wrapped in double quotes. This format works in Teamwork and other PM tools that support markdown in task descriptions.

## Parsing Logic

**Section Mapping:**
- `## Critical Issues` or `### CRITICAL` → Phase 1: Critical Issues
- `## High Priority Issues` or `### HIGH` → Phase 2: High Priority
- `## Medium Priority Issues` or `### MEDIUM` → Phase 3: Medium Priority
- `## Low Priority Issues` or `### LOW` → Phase 4: Long-term Optimization

**Task Extraction:**
- Heading level 3 (`###`) within priority sections = Individual task
- Extract: Title, severity, file path, line number, description, effort
- Consolidate: "X instances across Y pages" = single task with count

**CSV Row Generation (CRITICAL):**

For each task found:
```
Column A (TASKLIST): "Phase N: Phase Name"  ← Repeat on EVERY row
Column B (TASK): "Task Name"                ← REQUIRED, never empty
Column C (DESCRIPTION): "Task details..."   ← Quote and replace commas
```

**DO NOT create:**
- Header rows with tasklist name but empty task
- Rows with only TASKLIST and DESCRIPTION columns populated
- Phase separator rows

**Example of CORRECT row generation:**
```python
template = """## Description
Teamwork Ticket(s): [To be assigned]
- [ ] Was AI used in this pull request?

> As a developer, I need to {goal}

{summary}

## Acceptance Criteria
{criteria}

## Assumptions
{assumptions}

## Steps to Validate
{validation_steps}

## Affected URL
{url}

## Deploy Notes
{deploy_notes}"""

for task in tasks:
    description = template.format(
        goal=task.goal,
        summary=task.summary,
        criteria=task.criteria,
        assumptions=task.assumptions,
        validation_steps=task.validation_steps,
        url=task.url,
        deploy_notes=task.deploy_notes
    )
    csv_row = f'{task.phase},{task.name},"{description}",...'
```

**Effort Estimation:**
- Pattern match: "Estimated Effort: 2 hours" → `2h`
- Pattern match: "15 minutes" → `15m`
- Default if not found: (blank)

**Tag Assignment:**
- Security-related keywords → `Security`
- Performance/optimization → `Performance`
- Accessibility/WCAG → `Accessibility`
- Code quality/standards → `Code Quality`

**Description Formatting:**

Use the standard task description template (formatted markdown in quotes):

```markdown
## Description
Teamwork Ticket(s): [To be assigned]
- [ ] Was AI used in this pull request?

> As a developer, I need to [fix/implement/add this issue]

[Comprehensive summary extracted from audit findings]

## Acceptance Criteria
* Extracted from audit report
* Specific, testable criteria
* Include metrics and thresholds

## Assumptions
* Known limitations
* Dependencies
* Environment-specific notes

## Steps to Validate
1. Explicit testing instructions
2. Expected outcomes
3. Verification tools

## Affected URL
[link to site or specific pages]

## Deploy Notes
[File paths, cache clearing, config imports, monitoring]
```

**Important:**
- Wrap entire template in double quotes in CSV
- Markdown formatting is preserved (lists, headings, code blocks)
- Commas within quoted string are safe
- Extract specific details from audit findings for each section

## File Naming

Output: `[input-basename]-tasks.csv`

Examples:
- `audit-live-site-2026-02-02-1430.md` → `audit-live-site-2026-02-02-1430-tasks.csv`
- `security-audit.md` → `security-audit-tasks.csv`

## Limitations

- Requires structured markdown report from cms-cultivator audit commands
- Teamwork format (other formats: future enhancement)
- Does not assign tasks or set START DATE (manual in PM tool)
