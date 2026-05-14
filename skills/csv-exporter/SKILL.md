---
name: csv-exporter
description: Generate properly formatted Teamwork CSV files from Functional Requirements Documents. Converts FRD requirements into CSV backlog with task hierarchy, priorities, story points, and estimated hours. Automatically populates estimated time from story point conversion. Invoke when user asks to "export to CSV", "create Teamwork backlog", or needs project backlog file.
---

# CSV Exporter Skill

## Philosophy

**Transform planning into actionable work.** FRDs identify requirements; this skill converts them into structured, importable task backlogs that teams can immediately start executing.

## When to Use This Skill

This skill activates when:
- User says "export to CSV", "create Teamwork backlog"
- FRD is complete and ready for task creation
- User asks "how do I get this into Teamwork?"
- Project needs backlog CSV for sprint planning

**Do NOT activate for:**
- Single task creation (use `teamwork-task-creator` instead)
- Updating existing Teamwork tasks (the main session has Teamwork MCP — handle directly)
- Status checks or queries (use `teamwork-integrator` instead)

## Core Responsibilities

### 1. Parse FRD Requirements

Extract structured data from FRD:

**Requirements Sections:**
- Functional Requirements (FR-XXX)
- Technical Requirements (TR-XXX)
- User Interface Requirements (UI-XXX)
- Data Requirements (DR-XXX)

**Extract for each requirement:**
- Requirement ID and title
- Priority level (MUST/SHOULD/NICE TO HAVE)
- Story point estimate
- User story format
- Acceptance criteria
- Technical details
- Dependencies

### 2. Convert to CSV Structure

Transform requirements into Teamwork CSV format with 10 required columns (see **[Teamwork Format](templates/teamwork-format.md)** for complete specification):

| Column | Purpose | Example |
|--------|---------|---------|
| Tasklist | Phase grouping | "Phase 1: Setup" |
| Task | Task name with hierarchy | "[EPIC] Provider Directory [21 points]" |
| Description | Complete ticket template | Full markdown template |
| Assign to | Assignee email | "" (blank initially) |
| Start date | Planned start | "" (blank initially) |
| Due date | Target completion | "" (blank initially) |
| Priority | Task priority | "high", "medium", "low" |
| Estimated time | Hours estimate | "40" (from story points) |
| Tags | Categorization | "SP-21,Phase-1,MVP" |
| Status | Task status | "Active" |

### 3. Establish Task Hierarchy

Create three-level hierarchy using prefix conventions (see **[Hierarchy Examples](templates/hierarchy-examples.md)** for complete patterns):

**Level 1 - Epic (no prefix):**
```
[EPIC] User Authentication System [13 points]
```

**Level 2 - Story (single dash):**
```
- [STORY] User Registration Flow [5 points]
```

**Level 3 - Task (double dash):**
```
-- [TASK] Create registration form component [3 points]
```

**Level 4 - Sub-task (triple dash, if needed):**
```
--- [TASK] Validate email format [1 point]
```

### 4. Map Priorities

Convert FRD priority levels to Teamwork priorities:

| FRD Priority | Teamwork Priority | Use For |
|--------------|-------------------|---------|
| MUST HAVE | `high` | MVP features, critical path, blockers, foundation |
| SHOULD HAVE | `medium` | Core features, important but not MVP-blocking |
| NICE TO HAVE | `low` | Enhancements, polish, post-MVP features |

**Priority Guidelines:**
- **High:** Foundation setup, must-have for MVP, blocking dependencies
- **Medium:** Important features, standard functionality, should-have items
- **Low:** Enhancements, nice-to-have, documentation, polish

### 5. Populate Estimated Time

**CRITICAL FEATURE:** Automatically populate the "Estimated time" column from story points using conversion table:

| Story Points | Estimated Hours | Typical Work |
|--------------|-----------------|--------------|
| 1 point | 2 hours | Simple changes, small fixes |
| 2 points | 4 hours | Small features, standard tasks |
| 3 points | 8 hours | Standard features (1 day) |
| 5 points | 16 hours | Complex features (2 days) |
| 8 points | 32 hours | Major features (4 days) |
| 13 points | 80 hours | Large epics (2 weeks) |
| 21 points | 120 hours | Very large epics (3 weeks) |
| 34+ points | Split task | Must be decomposed |

**Format:** Enter as integer hours: `2`, `4`, `8`, `16`, `32`, `80`, `120`

**Note:** Teamwork also accepts formats like `01:30`, `1h 15m`, `2 hours`, but integer hours is simplest.

### 6. Generate Task Descriptions

Use standardized ticket template for Description field:

```markdown
## Description

> As a [user type], I need to [action] so that [benefit].

_Brief context about current vs. expected behavior._

## Story Points
**X points** - Justification for estimate

## Acceptance Criteria
* Specific testable criteria
* e.g. Feature works as described
* e.g. No console errors

## Steps to Validate
1. Explicit validation steps
1. Include URLs or specific test scenarios

## Technical Details
Implementation specifics, patterns to follow, architecture decisions.

## Deployment Notes
_New dependencies, configuration changes, post-launch tasks._
```

**For Epics, add:**
```markdown
## Working With this Epic

- This Epic task will have a single integration branch/pull-request/multidev
- All internal QA will happen on Epic multidev
- Client UAT happens once entire epic is delivered and internally validated
- Epic branch merged to main once QA and UAT complete
```

### 7. Apply Consistent Tagging

Required tags for all tasks (comma-separated, no spaces):

**Mandatory:**
- `SP-X` - Story points (e.g., `SP-3`, `SP-8`, `SP-13`)
- `Phase-X` - Phase number (e.g., `Phase-1`, `Phase-2`)

**Optional but recommended:**
- `MVP` - Must-have for minimum viable product
- `Frontend` - Frontend development work
- `Backend` - Backend development work
- `Design` - Design work required
- `Content` - Content creation/migration
- `Recipe` - Drupal recipe development
- `Block` - WordPress block development

**Example:** `SP-8,Phase-1,MVP,Backend,Recipe`

## Workflow

```
1. Receive FRD document
   └─ Parse Implementation Plan sections
   └─ Extract all requirements with story points

2. Organize by phase and epic
   └─ Group requirements by Implementation Plan phases
   └─ Identify epics (13+ points or related features)
   └─ Establish parent-child relationships

3. Build task hierarchy
   └─ Create epic rows (no prefix)
   └─ Create story rows (- prefix)
   └─ Create task rows (-- prefix)
   └─ Add sub-task rows if needed (--- prefix)

4. Populate CSV columns
   └─ Tasklist: Phase name
   └─ Task: Name with hierarchy prefix and [X points]
   └─ Description: Complete ticket template
   └─ Priority: Map from MUST/SHOULD/NICE
   └─ Estimated time: Convert story points to hours
   └─ Tags: SP-X, Phase-X, and feature tags
   └─ Status: "Active" for all

5. Validate CSV structure
   └─ Verify story points sum correctly
   └─ Check epic points = sum of story points
   └─ Ensure all required columns present
   └─ Validate CSV formatting (UTF-8, proper quotes)

6. Export CSV file
   └─ Name: backlog-[project-name].csv
   └─ Provide import instructions
   └─ Summarize task counts and story points
```

## CSV Format Requirements

**File Encoding:** UTF-8

**Column Delimiter:** Comma (`,`)

**Text Qualifier:** Double quotes (`"`)

**Escape Quotes:** Double the quote character (`""`)

**Header Row (exact column names):**
```csv
Tasklist,Task,Description,Assign to,Start date,Due date,Priority,Estimated time,Tags,Status
```

**Example Row:**
```csv
"Phase 1: Setup","[EPIC] Provider Directory [21 points]","## Description

> As a site visitor, I need to search healthcare providers so that I can find the right provider.

## Story Points
**21 points** - Large epic including multiple content types and complex views

## Acceptance Criteria
* Provider search works with filters
* Provider profiles display correctly","","","",high,120,"SP-21,Phase-1,MVP,Backend",Active
```

## Validation Checklist

Before exporting CSV, verify:

- [ ] Header row present with exact column names
- [ ] All required columns populated (Tasklist, Task, Description, Priority, Estimated time, Tags, Status)
- [ ] Hierarchy prefixes correct (-, --, ---)
- [ ] Story points in task names match Description section
- [ ] Estimated time populated from story points for ALL tasks
- [ ] Epic story points = sum of child story points
- [ ] Total story points match FRD total
- [ ] All descriptions follow ticket template
- [ ] User stories present in all descriptions
- [ ] Tags include SP-X and Phase-X for all tasks
- [ ] Priorities align with FRD (MUST→high, SHOULD→medium, NICE→low)
- [ ] Status set to "Active" for all tasks
- [ ] UTF-8 encoding
- [ ] Proper CSV escaping for quotes and newlines

## Output Format

After generating CSV, provide summary:

```markdown
## CSV Export Complete

**File:** backlog-project-name.csv
**Total Tasks:** 47 (8 epics + 23 stories + 16 tasks)
**Total Story Points:** 144 points
**Estimated Hours:** 672 hours (calculated from story points)

### Breakdown by Phase

**Phase 1: Setup and Foundation**
- Tasks: 12 (2 epics, 5 stories, 5 tasks)
- Story Points: 34 points
- Estimated Hours: 152 hours

**Phase 2: Core Features**
- Tasks: 20 (4 epics, 10 stories, 6 tasks)
- Story Points: 68 points
- Estimated Hours: 320 hours

**Phase 3: Enhanced Features**
- Tasks: 15 (2 epics, 8 stories, 5 tasks)
- Story Points: 42 points
- Estimated Hours: 200 hours

### Priority Distribution
- High: 22 tasks (47%)
- Medium: 18 tasks (38%)
- Low: 7 tasks (15%)

### Import Instructions

1. Go to your Teamwork project
2. Navigate to Settings → Import/Export
3. Select "Import Tasks from CSV"
4. Upload backlog-project-name.csv
5. Verify column mapping
6. Choose to create new tasklists or map to existing
7. Click Import
8. Review imported tasks for hierarchy and formatting

### Next Steps
- Assign tasks to team members during sprint planning
- Set start/due dates based on sprint schedule
- Review and refine task estimates based on team velocity
- Create sprint milestones in Teamwork
```

## Best Practices

**DO:**
- ✅ Populate estimated hours from story points for all tasks
- ✅ Group related requirements into logical epics
- ✅ Use consistent task naming with [TYPE] prefix
- ✅ Include complete context in descriptions
- ✅ Provide specific, testable acceptance criteria
- ✅ Sum story points accurately (epic = sum of stories)
- ✅ Apply consistent tagging strategy
- ✅ Validate CSV before export

**DON'T:**
- ❌ Leave estimated time column blank (defeats purpose of skill)
- ❌ Create flat task lists (use hierarchy)
- ❌ Skip user stories in descriptions
- ❌ Use inconsistent priority mapping
- ❌ Forget to include SP-X and Phase-X tags
- ❌ Create tasks without acceptance criteria
- ❌ Export without validating story point totals

## References

Complete reference materials available in the templates directory:

- **[Teamwork Format](templates/teamwork-format.md)** - Complete CSV column specifications and requirements
- **[Hierarchy Examples](templates/hierarchy-examples.md)** - Task hierarchy patterns and conventions

Use these references to understand CSV structure and implementation details.
