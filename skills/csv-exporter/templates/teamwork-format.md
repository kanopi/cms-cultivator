# Teamwork CSV Format Specification

Complete specification for generating Teamwork-ready CSV backlogs from Functional Requirements Documents.

## CSV Column Structure

Teamwork CSV imports require these exact column names in this order:

| Column | Data Type | Required | Purpose |
|--------|-----------|----------|---------|
| **Tasklist** | String | Yes | Phase or feature area grouping |
| **Task** | String | Yes | Task name with hierarchy prefixes |
| **Description** | Text (Markdown) | Yes | Complete ticket template with user story |
| **Assign to** | Email | No | Assignee email address |
| **Start date** | Date | No | Task start date (localized format) |
| **Due date** | Date | No | Task due date (localized format) |
| **Priority** | String | Yes | low, medium, or high |
| **Estimated time** | String | Yes | Time estimate in hours |
| **Tags** | String | Yes | Comma-separated tags |
| **Status** | String | Yes | Active, completed, or other status |

## Column Details and Requirements

### 1. Tasklist Column

**Purpose:** Groups tasks by phase, feature area, or epic

**Format:**
- Use descriptive phase names
- Match Implementation Plan phases from FRD
- Keep consistent across related tasks

**Examples:**
```
"Phase 1: Setup and Foundation"
"Phase 2: Core Features"
"Phase 3: User Management"
"Phase 4: Content Management"
"Phase 5: Polish and Launch"
```

**Best Practices:**
- Use consistent naming across project
- Include phase number for sorting
- Be descriptive but concise
- Group related work together

---

### 2. Task Column

**Purpose:** Task name with hierarchical structure

**Hierarchy Prefixes:**
- No prefix: Epic level
- `-` (single dash): Story level (first level subtask)
- `--` (double dash): Task level (second level subtask)
- `---` (triple dash): Sub-task level (third level subtask)

**Task Type Labels:**
- `[EPIC]` - High-level feature grouping (13+ points)
- `[STORY]` - User story or feature (3-8 points)
- `[TASK]` - Specific implementation task (1-3 points)
- `[SPIKE]` - Research or investigation task
- `[BUG]` - Bug fix task

**Story Points in Task Name:**
Include story points at end of task name: `[X points]`

**Examples:**
```
[EPIC] Provider Directory [21 points]
- [STORY] Provider Search and Filtering [8 points]
-- [TASK] Implement search autocomplete [3 points]
-- [TASK] Add specialty filter [2 points]
-- [TASK] Add location filter [2 points]
--- [TASK] Geocode locations [1 point]
- [STORY] Provider Detail Pages [8 points]
-- [TASK] Create provider detail template [3 points]
-- [TASK] Add biography and credentials section [2 points]
-- [TASK] Add contact information [2 points]
-- [TASK] Add appointment scheduling CTA [1 point]
```

---

### 3. Description Column

**Purpose:** Complete ticket specification using standardized template

**Format:** Use the complete ticket template (markdown supported):

```markdown
## Description

> As a [user type], I need to [action] so that [benefit].

_A few sentences describing the overall goals of this work.
What is the current behavior? What is the updated/expected behavior?_

## Story Points
**X points** - Justification for the estimate

## Working With this Epic
(For Epics only)
- This Epic task will have a single integration branch/pull-request/multidev
- All internal QA will happen on Epic multidev
- Client UAT happens once entire epic is delivered and internally validated
- Epic branch merged to main once QA and UAT complete
- Multiple developers may work on this Epic simultaneously

## Acceptance Criteria
* Specific testable criteria
* e.g. Clicking outside modal closes it
* e.g. Form validation shows inline errors

## Assumptions
* Known issues or constraints
* e.g. Known Javascript error in console
* e.g. Plugin breaks on specific multidev

## Steps to Validate
1. Explicit validation steps
1. Include direct links to test sites
1. Be specific about what to test

## Affected URL
[link_to_test_site](insert_link_here)

## Designs
- Desktop: [link_to_desktop_design]
- Mobile: [link_to_mobile_design]

## Helpful Resources
List relevant documentation, references, or examples.

## Technical Details
Implementation specifics, architectural decisions, patterns to follow.

## Deployment Notes
_Notes regarding deployment. New dependencies, scripts, post-launch work._
```

**Template Sections:**

**Description** (Required)
- User story in format: "As a [user], I need to [action] so that [benefit]"
- Current vs. expected behavior
- Context and background

**Story Points** (Required)
- Points estimate
- Brief justification (complexity factors, dependencies, etc.)

**Working With this Epic** (For Epics Only)
- Integration branch strategy
- QA process
- UAT timing
- Merge workflow

**Acceptance Criteria** (Required)
- Specific, testable criteria
- Bullet points with clear success conditions
- Use "e.g." prefix for examples

**Assumptions** (As Needed)
- Known issues
- Constraints
- Dependencies on other work

**Steps to Validate** (Required)
- Numbered list
- Explicit testing steps
- Include URLs and specific scenarios

**Affected URL** (As Needed)
- Link to test environment
- Link to staging site
- Placeholder if not yet available

**Designs** (For UI Work)
- Desktop design link
- Mobile design link
- Responsive behavior notes

**Helpful Resources** (As Needed)
- Documentation links
- API references
- Similar implementations

**Technical Details** (As Needed)
- Implementation approach
- Architecture decisions
- Code patterns to follow
- Technology choices

**Deployment Notes** (As Needed)
- New dependencies
- Configuration changes
- Database updates
- Cache clearing requirements
- Post-launch tasks

---

### 4. Assign to Column

**Purpose:** Pre-assign tasks to team members

**Format:** Email addresses (comma-separated for multiple assignees)

**Examples:**
```csv
"developer@example.com"
"dev1@example.com,dev2@example.com"
""  (leave blank for assignment during sprint planning)
```

**Best Practices:**
- Leave blank initially unless specific expertise required
- Assign during sprint planning for better team buy-in
- Use valid Teamwork user email addresses
- Multiple assignees supported with comma separation

---

### 5. Start date Column

**Purpose:** Planned start date for task

**Format:** Follows Teamwork site localization settings

**Common Formats:**
- US: `MM/DD/YYYY` (e.g., `03/15/2026`)
- European: `DD/MM/YYYY` (e.g., `15/03/2026`)
- ISO: `YYYY-MM-DD` (e.g., `2026-03-15`)

**Best Practices:**
- Leave blank initially (assign during sprint planning)
- Set during sprint planning once work is scheduled
- Ensure format matches Teamwork site settings

---

### 6. Due date Column

**Purpose:** Target completion date for task

**Format:** Same as Start date format (site localization)

**Best Practices:**
- Leave blank initially for backlog items
- Set during sprint planning with sprint end date
- Buffer epic due dates for testing and review
- Critical path items may have fixed due dates

---

### 7. Priority Column

**Purpose:** Task priority level

**Allowed Values:**
- `high` - Must-have features, critical path, blockers
- `medium` - Should-have features, important but not blocking
- `low` - Nice-to-have features, enhancements, documentation

**Mapping from FRD Priority:**
- **MUST HAVE** → `high`
- **SHOULD HAVE** → `medium`
- **NICE TO HAVE** → `low`

**Priority Assignment Guidelines:**

**High Priority:**
- Foundation and setup work
- Blocking other features
- Critical path items
- Must-have for MVP
- Security or compliance requirements

**Medium Priority:**
- Core features for full release
- Important but not MVP-blocking
- Dependent on high-priority work
- Should-have features

**Low Priority:**
- Enhancements and polish
- Nice-to-have features
- Post-MVP features
- Documentation and training materials

---

### 8. Estimated time Column

**Purpose:** Time estimate for task completion

**CRITICAL:** This column must be populated from story points using conversion table.

**Supported Formats:**
- Hours only: `25` (assumes hours)
- HH:MM format: `01:30` (1.5 hours)
- Hours with unit: `1h 15m`, `2h`, `3 hours`

**Recommended Format:** Integer hours (simplest): `2`, `4`, `8`, `16`, `32`, `80`, `120`

**Story Points to Hours Conversion:**

Use these standard conversions for populating estimated time:

| Story Points | Estimated Hours | Typical Duration | Work Type |
|--------------|-----------------|------------------|-----------|
| 1 point | 2 | < 2 hours | Simple changes, config tweaks |
| 2 points | 4 | 2-4 hours | Small features, standard tasks |
| 3 points | 8 | 1 day | Standard features |
| 5 points | 16 | 2 days | Complex features |
| 8 points | 32 | 4 days | Major features |
| 13 points | 80 | 2 weeks | Large epics |
| 21 points | 120 | 3 weeks | Very large epics |
| 34+ points | Must decompose | - | Split into smaller tasks |

**Calculation Examples:**

```
Task: [TASK] Create registration form [3 points]
Estimated time: 8

Task: [STORY] User Registration Flow [5 points]
Estimated time: 16

Task: [EPIC] User Authentication System [13 points]
Estimated time: 80
```

**Note:** This is a planning estimate. Actual hours vary by:
- Team velocity and experience
- Complexity of specific implementation
- Dependencies and blockers
- Testing and review requirements

Use team's historical data to refine conversion ratios over time.

---

### 9. Tags Column

**Purpose:** Categorize and filter tasks

**Format:** Comma-separated tag list (no spaces after commas)

**Required Tags:**
- `SP-X` - Story points (e.g., `SP-3`, `SP-8`, `SP-13`)
- `Phase-X` - Phase number (e.g., `Phase-1`, `Phase-2`)

**Optional Tags:**
- `MVP` - Must-have for minimum viable product
- `Frontend` - Frontend development work
- `Backend` - Backend development work
- `Design` - Design work required
- `Content` - Content creation/migration
- `Testing` - QA testing task
- `DevOps` - Infrastructure/deployment work
- `Recipe` - Drupal recipe development
- `Block` - WordPress block development

**Examples:**
```csv
"SP-8,Phase-1,MVP,Backend"
"SP-3,Phase-2,Frontend,Design"
"SP-5,Phase-1,Recipe,Content"
"SP-13,Phase-3,Backend,DevOps"
```

**Best Practices:**
- Always include SP-X and Phase-X tags
- Use consistent tag naming across project
- Tags are case-sensitive in Teamwork
- New tags will be created automatically if they don't exist
- No spaces after commas in tag list

---

### 10. Status Column

**Purpose:** Current task status

**Allowed Values:**
- `Active` - Ready to work (default for new tasks)
- `new` - Not yet reviewed
- `completed` - Work finished

**Best Practices:**
- Set all backlog items to `Active`
- Teamwork will manage status changes during sprint
- Don't pre-mark items as completed

---

## Complete CSV Row Example

### Epic Task with Full Template

```csv
"Phase 1: Setup","[EPIC] Provider Directory [21 points]","## Description

> As a site visitor, I need to search and browse healthcare providers so that I can find the right provider for my needs.

_This epic encompasses the complete provider directory feature including search, filtering, provider profiles, and appointment scheduling integration._

## Story Points
**21 points** - Large epic including multiple content types (Person, Service, Location), complex views with filtering, and integration with appointment system

## Working With this Epic

- This Epic task will have a single integration branch/pull-request/multidev
- All internal QA will happen on Epic multidev
- Client UAT happens once entire epic is delivered and internally validated
- Epic branch merged to main once QA and UAT complete

## Acceptance Criteria
* Provider search works with autocomplete
* Filters work: specialty, location, insurance, language
* Provider profiles display all required information
* Appointment scheduling integration functional

## Technical Details
Drupal recipe-based implementation:
- saplings_person recipe (Person content type)
- saplings_service recipe (Service taxonomy)
- saplings_location recipe (Location content type)
- Shared field coordination (field_phone, field_services, field_locations)","","","",high,120,"SP-21,Phase-1,MVP,Backend,Recipe",Active
```

### Story Task

```csv
"Phase 1: Setup","- [STORY] Provider Search and Filtering [8 points]","## Description

> As a site visitor, I need to search for providers by name and filter by specialty, location, and insurance so that I can quickly find providers that meet my needs.

_Current behavior: No provider directory exists. Expected behavior: Searchable directory with multiple filter options._

## Story Points
**8 points** - Complex view configuration with exposed filters, autocomplete search, and multiple entity relationships

## Acceptance Criteria
* Search box with autocomplete shows provider names as user types
* Specialty filter shows all available specialties
* Location filter shows all practice locations
* Insurance filter shows accepted insurance plans
* Multiple filters can be applied simultaneously
* Results update without page reload (AJAX)

## Steps to Validate
1. Navigate to /providers
1. Test search autocomplete by typing provider name
1. Apply specialty filter, verify results update
1. Apply location filter, verify results update
1. Apply multiple filters together, verify all filters work together
1. Clear filters, verify all providers shown

## Technical Details
- Views with exposed filters
- Views AJAX enabled for filter updates
- Autocomplete using Views Autocomplete Filters module
- Entity reference filters for specialty, location, insurance taxonomies","","","",high,32,"SP-8,Phase-1,MVP,Frontend,Backend",Active
```

### Task Item

```csv
"Phase 1: Setup","-- [TASK] Implement provider search autocomplete [3 points]","## Description

> As a developer, I need to implement search autocomplete for the provider directory so that users can quickly find providers by name.

_Add autocomplete functionality to the provider search field using Views Autocomplete Filters module._

## Story Points
**3 points** - Standard implementation with established module, includes testing

## Acceptance Criteria
* Search field shows autocomplete suggestions after 2 characters typed
* Suggestions include provider name and specialty
* Clicking suggestion filters to that provider
* Autocomplete works with keyboard navigation (arrows, enter)

## Steps to Validate
1. Navigate to /providers
1. Type 2 characters in search box, verify suggestions appear
1. Use arrow keys to navigate suggestions
1. Press enter to select suggestion
1. Verify results filtered to selected provider

## Technical Details
- Install Views Autocomplete Filters module
- Configure in Views exposed filter settings
- Set minimum characters to 2
- Include provider name and specialty in autocomplete results
- Enable keyboard navigation

## Deployment Notes
- New module: views_autocomplete_filters (add to composer.json)","","","",high,8,"SP-3,Phase-1,MVP,Frontend",Active
```

## CSV File Structure

### File Header

The first row must contain exact column names:

```csv
Tasklist,Task,Description,Assign to,Start date,Due date,Priority,Estimated time,Tags,Status
```

### CSV Format Requirements

**Encoding:** UTF-8

**Line Endings:** Unix-style (`\n`) or Windows-style (`\r\n`)

**Field Delimiter:** Comma (`,`)

**Text Qualifier:** Double quotes (`"`)

**Escaping Quotes:** Double the quote character (`""`)

**Example with Quotes in Description:**
```csv
"Phase 1","[TASK] Update ""About Us"" page [1 point]","Description here...","",,,"",medium,2,"SP-1,Phase-1",Active
```

### Multi-line Descriptions

Descriptions can include line breaks within quoted fields:

```csv
"Phase 1","[TASK] Task name [3 points]","## Description

This is a multi-line
description with line breaks.

## Acceptance Criteria
* Criterion 1
* Criterion 2","","","",high,8,"SP-3,Phase-1",Active
```

## CSV Generation Best Practices

### Validation Before Export

Verify story points sum correctly:

```
[EPIC] Provider Directory [21 points]
  - [STORY] Provider Listing [8 points]
    -- [TASK] Content type [3 points]
    -- [TASK] View [3 points]
    -- [TASK] Styling [2 points]
  - [STORY] Provider Detail [8 points]
    -- [TASK] Template [3 points]
    -- [TASK] Biography [2 points]
    -- [TASK] Contact [2 points]
    -- [TASK] CTA [1 point]
  - [STORY] Search [5 points]
    -- [TASK] Autocomplete [3 points]
    -- [TASK] Filters [2 points]

Validation:
Story totals: 8 + 8 + 5 = 21 ✓
Task totals: (3+3+2) + (3+2+2+1) + (3+2) = 21 ✓
Epic total: 21 ✓

Estimated Hours:
Story 1: 32 hours (8 points)
Story 2: 32 hours (8 points)
Story 3: 16 hours (5 points)
Epic total: 80 hours ✓
```

### Priority Distribution

Recommended distribution:
- 40-50% High priority (must-haves, MVP)
- 30-40% Medium priority (should-haves)
- 10-20% Low priority (nice-to-haves)

### Estimated Time Population

**CRITICAL:** Every task must have estimated time populated from story points.

**Verification checklist:**
- [ ] All epic rows have estimated time (13+ points = 80-120 hours)
- [ ] All story rows have estimated time (3-8 points = 8-32 hours)
- [ ] All task rows have estimated time (1-3 points = 2-8 hours)
- [ ] Total estimated hours = sum of all task hours
- [ ] Conversion matches story point table (1pt=2h, 2pt=4h, 3pt=8h, etc.)

## Import Instructions

Provide these instructions with the CSV file:

### Import Process

1. **Navigate to Import**
   - Go to project in Teamwork
   - Click Settings → Import/Export
   - Select "Import Tasks from CSV"

2. **Upload CSV**
   - Choose the generated CSV file
   - Map columns (should auto-detect)
   - Verify mapping is correct

3. **Review Options**
   - Choose tasklist mapping (create new or use existing)
   - Set default assignee if desired
   - Choose date format if applicable

4. **Import**
   - Click Import
   - Wait for confirmation
   - Review imported tasks

### After Import

1. **Verify Structure**
   - Check task hierarchy (epics → stories → tasks)
   - Verify story point tags created
   - Check priorities assigned correctly
   - Verify estimated time populated for all tasks

2. **Review Tasks**
   - Scan descriptions for formatting issues
   - Verify links work
   - Check acceptance criteria clear

3. **Assign Team Members**
   - Assign unassigned tasks
   - Balance workload across team
   - Set start/due dates during sprint planning

4. **Set Up Filters**
   - Create saved filter for current sprint
   - Filter by Phase-X tags
   - Filter by SP-X tags for reporting

## Troubleshooting

### Issue: Tasks Not Hierarchical

**Cause:** Hierarchy prefixes (-, --, ---) not recognized

**Solution:**
- Verify exact prefix characters used (dash, not hyphen)
- Ensure no extra spaces before prefix
- Check CSV formatting (quotes around task names)

### Issue: Descriptions Cut Off

**Cause:** Special characters or quotes not escaped properly

**Solution:**
- Ensure descriptions wrapped in double quotes
- Double any quote characters in description (`""`)
- Verify CSV encoding is UTF-8

### Issue: Estimated Time Not Showing

**Cause:** Incorrect format or missing values

**Solution:**
- Use integer hours format: `2`, `4`, `8`, `16`
- Verify no blank estimated time cells
- Check Teamwork accepts format (try simple integer first)

### Issue: Tags Not Created

**Cause:** Tag format incorrect or special characters

**Solution:**
- Use simple alphanumeric tags
- No spaces in tag names (use hyphens: `Phase-1` not `Phase 1`)
- Comma separation, no spaces: `SP-3,Phase-1` not `SP-3, Phase-1`

## CSV Validation Checklist

Before delivering CSV, verify:

- [ ] Header row present with correct column names
- [ ] All required columns populated (Tasklist, Task, Description, Priority, Estimated time, Tags, Status)
- [ ] Hierarchy prefixes correct (-, --, ---)
- [ ] Story points in task names match Description section
- [ ] Estimated time populated for ALL tasks from story point conversion
- [ ] All descriptions follow ticket template
- [ ] User stories present in all descriptions
- [ ] Acceptance criteria specific and testable
- [ ] Tags include SP-X and Phase-X for all tasks
- [ ] Priorities align with FRD (MUST→high, SHOULD→medium, NICE→low)
- [ ] Status set to "Active" for all tasks
- [ ] Epic story points = sum of child story points
- [ ] Epic estimated hours = sum of child estimated hours
- [ ] Total story points match FRD total
- [ ] Total estimated hours = story points × conversion rate
- [ ] No special characters causing CSV format issues
- [ ] UTF-8 encoding
- [ ] File named appropriately: `backlog-[project-name].csv`
