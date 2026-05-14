# Project Planning Skills

Generate Functional Requirements Documents (FRDs), estimate work in story points, and export task backlogs to Teamwork. These three skills compose end-to-end project planning, from requirements gathering to importable backlog.

---

## Workflow

```
Gather requirements
       ↓
story-point-estimator   (estimate complexity in Fibonacci points + hours)
       ↓
frd-generator           (structure into a 10-section FRD with numbered requirements)
       ↓
csv-exporter            (convert FRD requirements into Teamwork-ready CSV)
       ↓
Import into Teamwork
```

Each skill is independently invokable — use them together for full planning, or individually when you only need part of the workflow.

---

## Available Skills

### frd-generator

**Purpose:** Generate comprehensive Functional Requirements Documents with standardized structure.

**Auto-invoked triggers:** "create an FRD", "functional requirements document", "structure these requirements", "draft an FRD"

**What it produces:**

- 10-section FRD: Executive Summary, Technical Requirements, Functional Requirements, UI Requirements, Data Requirements, Non-Functional Requirements, Implementation Plan, Testing Requirements, Risk Assessment, Success Criteria
- Numbered requirements (FR-XXX, TR-XXX, US-XXX, UI-XXX, DR-XXX, NFR-XXX, TS-XXX, RISK-XXX)
- Platform-specific subsections for Drupal recipe-based projects and WordPress block themes
- Cross-referenced requirements for traceability

**Quick examples:**

```
"Generate an FRD for this healthcare provider directory project"
"Structure these requirements into an FRD"
"Draft a functional requirements document"
```

---

### story-point-estimator

**Purpose:** Provide Fibonacci-based story point estimates with hour conversions and velocity context.

**Auto-invoked triggers:** "how many story points?", "estimate this", "how long will this take?", "complexity estimate"

**What it produces:**

- Story point estimate using the Fibonacci scale (1, 2, 3, 5, 8, 13, 21, 34+)
- Hour range conversion (1 point = 2 hours; 13 points = 40–80 hours; 21+ = decompose)
- Complexity factors (technical, integration, business logic, uncertainty)
- Platform-specific adjustments for Drupal recipes and WordPress blocks
- Assumptions, dependencies, and recommendations

**Quick examples:**

```
"How many story points is this feature?"
"Estimate the work to add user authentication"
"How long would it take to migrate this content type?"
```

---

### csv-exporter

**Purpose:** Convert FRD requirements into a Teamwork-ready CSV backlog.

**Auto-invoked triggers:** "export to CSV", "Teamwork backlog", "create project backlog", "import to Teamwork"

**What it produces:**

- 10-column Teamwork CSV (Tasklist, Task, Description, Priority, Estimated time, Tags, Status, etc.)
- Three-level task hierarchy using prefix conventions: `[EPIC]`, `- [STORY]`, `-- [TASK]`
- Automatic story-point-to-hours conversion in the Estimated time column
- Priority mapping (MUST → high, SHOULD → medium, NICE → low)
- Consistent tagging: `SP-X`, `Phase-X`, and feature tags (Backend, Frontend, Recipe, Block, etc.)
- Complete ticket templates in the Description column with user stories and acceptance criteria

**Quick examples:**

```
"Export this FRD to a Teamwork CSV backlog"
"Create a project backlog file from these requirements"
"Generate the import file for Teamwork"
```

---

## When to Use These Skills

### Use `frd-generator` when:

- Starting a new project and need to document requirements formally
- Translating discovery notes into a structured deliverable for clients and developers
- Need a single source of truth that balances client readability with developer precision

### Use `story-point-estimator` when:

- Planning a sprint or estimating capacity
- Need to communicate "how long will this take" with a defensible range
- Comparing the complexity of two approaches

### Use `csv-exporter` when:

- An FRD is complete and you need to create tickets in Teamwork
- Setting up a new project's backlog
- Migrating planning artifacts into a project management tool

---

## Integration with Other Skills

These planning skills complement existing CMS Cultivator capabilities:

- **[teamwork-task-creator](project-management.md)** — Single-task creation; `csv-exporter` is for bulk backlog import.
- **[teamwork-integrator](project-management.md)** — Look up Teamwork task status after import.
- **[teamwork-exporter](project-management.md)** — Export audit findings (security, performance, accessibility) as Teamwork tasks; `csv-exporter` exports planned requirements.

---

## Requirements

**Required:**

- CMS Cultivator plugin
- Markdown viewer (FRD output is Markdown)

**For Teamwork import (optional):**

- Teamwork account with project import permissions
- The CSV produced by `csv-exporter` can be imported via **Project → Settings → Import/Export → Import Tasks from CSV**

No MCP servers are required — these skills generate output that you import yourself.

---

## Next Steps

- **[Agents & Skills](../agents-and-skills.md)** — How skills auto-activate
- **[Project Management Skills](project-management.md)** — Teamwork integration skills
- **[Skills Overview](overview.md)** — Complete skill reference
