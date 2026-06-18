# Task Hierarchy Examples

Complete guide to task hierarchy conventions and naming patterns for Teamwork CSV imports.

## Hierarchy Prefix System

Teamwork recognizes task hierarchy through prefix characters in the Task column.

### Prefix Conventions

| Level | Prefix | Type | Story Points | Example |
|-------|--------|------|--------------|---------|
| 1 | None | Epic | 13-21+ points | `[EPIC] User Authentication [13 points]` |
| 2 | `-` | Story | 3-8 points | `- [STORY] User Registration [5 points]` |
| 3 | `--` | Task | 1-3 points | `-- [TASK] Create registration form [3 points]` |
| 4 | `---` | Sub-task | 1 point | `--- [TASK] Validate email format [1 point]` |

**Critical:** Use exact characters (dash `-`, not hyphen or other unicode character)

## Complete Hierarchy Examples

### Example 1: User Authentication System

This example shows a complete epic with multiple stories and tasks, demonstrating proper story point distribution.

```
Phase 1: Setup and Foundation

[EPIC] User Authentication System [13 points]
- [STORY] User Registration Flow [5 points]
-- [TASK] Create registration form component [3 points]
-- [TASK] Implement email verification [2 points]
- [STORY] User Login Flow [5 points]
-- [TASK] Create login form component [2 points]
-- [TASK] Implement JWT authentication [3 points]
- [STORY] Password Reset Flow [3 points]
-- [TASK] Create password reset request form [1 point]
-- [TASK] Implement reset token generation [1 point]
-- [TASK] Create new password form [1 point]
```

**Story Point Validation:**
- Story 1: 3 + 2 = 5 ✓
- Story 2: 2 + 3 = 5 ✓
- Story 3: 1 + 1 + 1 = 3 ✓
- Epic Total: 5 + 5 + 3 = 13 ✓

**Estimated Hours:**
- Epic: 80 hours (13 points)
- Story 1: 16 hours (5 points)
  - Task 1: 8 hours (3 points)
  - Task 2: 4 hours (2 points)
- Story 2: 16 hours (5 points)
  - Task 1: 4 hours (2 points)
  - Task 2: 8 hours (3 points)
- Story 3: 8 hours (3 points)
  - Task 1: 2 hours (1 point)
  - Task 2: 2 hours (1 point)
  - Task 3: 2 hours (1 point)

---

### Example 2: Provider Directory (Drupal Recipe)

This example demonstrates recipe-based architecture with shared field dependencies and complex views.

```
Phase 2: Core Features

[EPIC] Provider Directory [21 points]
- [STORY] Provider Content Model [8 points]
-- [TASK] Create saplings_person recipe structure [3 points]
-- [TASK] Define Person content type with fields [3 points]
-- [TASK] Create Specialties taxonomy [1 point]
-- [TASK] Create Languages taxonomy [1 point]
- [STORY] Provider Listing and Search [8 points]
-- [TASK] Create Provider Directory view with filters [3 points]
-- [TASK] Implement search autocomplete [2 points]
-- [TASK] Add specialty filter [1 point]
-- [TASK] Add location filter [1 point]
-- [TASK] Add insurance filter [1 point]
- [STORY] Provider Detail Pages [5 points]
-- [TASK] Create provider detail page template [2 points]
-- [TASK] Add biography and credentials display [1 point]
-- [TASK] Add contact information block [1 point]
-- [TASK] Add appointment scheduling CTA [1 point]
```

**Story Point Validation:**
- Story 1: 3 + 3 + 1 + 1 = 8 ✓
- Story 2: 3 + 2 + 1 + 1 + 1 = 8 ✓
- Story 3: 2 + 1 + 1 + 1 = 5 ✓
- Epic Total: 8 + 8 + 5 = 21 ✓

**Estimated Hours:**
- Epic: 120 hours (21 points)
- Story 1: 32 hours (8 points)
- Story 2: 32 hours (8 points)
- Story 3: 16 hours (5 points)

---

### Example 3: E-commerce Product Catalog

This example shows a complex feature with frontend and backend components.

```
Phase 2: Core Features

[EPIC] Product Catalog [21 points]
- [STORY] Product Content Type [5 points]
-- [TASK] Create Product content type [2 points]
-- [TASK] Configure product fields (price, SKU, inventory) [2 points]
-- [TASK] Create product categories taxonomy [1 point]
- [STORY] Product Display and Filtering [8 points]
-- [TASK] Create product catalog view [3 points]
-- [TASK] Implement category filtering [2 points]
-- [TASK] Implement price range filtering [2 points]
-- [TASK] Add sorting options (price, name, rating) [1 point]
- [STORY] Product Detail Pages [5 points]
-- [TASK] Create product detail page template [2 points]
-- [TASK] Add product image gallery [2 points]
-- [TASK] Add add-to-cart functionality [1 point]
- [STORY] Related Products [3 points]
-- [TASK] Implement related products algorithm [2 points]
-- [TASK] Create related products display block [1 point]
```

**Story Point Validation:**
- Story 1: 2 + 2 + 1 = 5 ✓
- Story 2: 3 + 2 + 2 + 1 = 8 ✓
- Story 3: 2 + 2 + 1 = 5 ✓
- Story 4: 2 + 1 = 3 ✓
- Epic Total: 5 + 8 + 5 + 3 = 21 ✓

**Estimated Hours:**
- Epic: 120 hours (21 points)
- Story 1: 16 hours (5 points)
- Story 2: 32 hours (8 points)
- Story 3: 16 hours (5 points)
- Story 4: 8 hours (3 points)

---

### Example 4: Four-Level Hierarchy (with Sub-tasks)

This example shows when to use the fourth level (triple dash) for detailed decomposition.

```
Phase 3: Enhanced Features

[EPIC] Advanced Search [13 points]
- [STORY] Search Infrastructure [5 points]
-- [TASK] Set up Elasticsearch integration [3 points]
--- [TASK] Install and configure Elasticsearch module [1 point]
--- [TASK] Configure connection settings [1 point]
--- [TASK] Create initial index configuration [1 point]
-- [TASK] Create search index for content [2 points]
--- [TASK] Index existing content [1 point]
--- [TASK] Set up incremental indexing [1 point]
- [STORY] Search Interface [5 points]
-- [TASK] Create search form component [2 points]
-- [TASK] Implement search results page [2 points]
-- [TASK] Add search suggestions/autocomplete [1 point]
- [STORY] Advanced Filters [3 points]
-- [TASK] Implement faceted search filters [2 points]
-- [TASK] Add search result highlighting [1 point]
```

**Story Point Validation:**
- Story 1: (1 + 1 + 1) + (1 + 1) = 5 ✓
- Story 2: 2 + 2 + 1 = 5 ✓
- Story 3: 2 + 1 = 3 ✓
- Epic Total: 5 + 5 + 3 = 13 ✓

**Estimated Hours:**
- Epic: 80 hours (13 points)
- Story 1: 16 hours (5 points)
  - Task 1: 8 hours (3 points = 1+1+1)
  - Task 2: 4 hours (2 points = 1+1)
- Story 2: 16 hours (5 points)
- Story 3: 8 hours (3 points)

---

### Example 5: Foundation Setup (High Priority)

This example shows typical foundation/setup tasks that are high priority and enable other work.

```
Phase 1: Setup and Foundation

[EPIC] Development Environment Setup [8 points]
- [STORY] Local Development Environment [3 points]
-- [TASK] Set up local Docker environment [2 points]
-- [TASK] Configure local domain and SSL [1 point]
- [STORY] Hosting and CI/CD [3 points]
-- [TASK] Set up Pantheon hosting [1 point]
-- [TASK] Configure multidev environments [1 point]
-- [TASK] Set up GitHub Actions for testing [1 point]
- [STORY] Developer Documentation [2 points]
-- [TASK] Create local setup documentation [1 point]
-- [TASK] Document deployment process [1 point]
```

**Story Point Validation:**
- Story 1: 2 + 1 = 3 ✓
- Story 2: 1 + 1 + 1 = 3 ✓
- Story 3: 1 + 1 = 2 ✓
- Epic Total: 3 + 3 + 2 = 8 ✓

**Estimated Hours:**
- Epic: 32 hours (8 points)
- Story 1: 8 hours (3 points)
- Story 2: 8 hours (3 points)
- Story 3: 4 hours (2 points)

**Priority:** All tasks in this epic should be `high` priority as they are foundation work.

---

### Example 6: Content Migration (Mixed Priorities)

This example shows how priorities can vary within an epic based on requirement importance.

```
Phase 3: Content and Launch

[EPIC] Content Migration [13 points]
- [STORY] Content Model Preparation [3 points] (High)
-- [TASK] Map old content structure to new [2 points]
-- [TASK] Create content migration plan [1 point]
- [STORY] Core Content Migration [8 points] (High)
-- [TASK] Migrate pages and articles [3 points]
-- [TASK] Migrate media and files [3 points]
-- [TASK] Migrate user accounts [2 points]
- [STORY] Additional Content [2 points] (Medium)
-- [TASK] Migrate blog posts [1 point]
-- [TASK] Migrate comments [1 point]
```

**Story Point Validation:**
- Story 1: 2 + 1 = 3 ✓
- Story 2: 3 + 3 + 2 = 8 ✓
- Story 3: 1 + 1 = 2 ✓
- Epic Total: 3 + 8 + 2 = 13 ✓

**Estimated Hours:**
- Epic: 80 hours (13 points)
- Story 1: 8 hours (3 points)
- Story 2: 32 hours (8 points)
- Story 3: 4 hours (2 points)

**Priority Notes:**
- Story 1 & 2: High priority (must-have content)
- Story 3: Medium priority (nice-to-have content, can be migrated post-launch)

---

## Task Type Labels

Use clear type labels in square brackets to indicate task category:

### Epic Types

```
[EPIC] - Standard epic (feature grouping)
[EPIC - FOUNDATION] - Setup/infrastructure epic
[EPIC - INTEGRATION] - Third-party integration epic
```

### Story Types

```
[STORY] - Standard user story
[STORY - RECIPE] - Drupal recipe development
[STORY - BLOCK] - WordPress block development
[STORY - API] - API endpoint development
```

### Task Types

```
[TASK] - Standard implementation task
[SPIKE] - Research or investigation
[BUG] - Bug fix
[REFACTOR] - Code refactoring
[TEST] - Testing task
[DOCS] - Documentation task
```

### Examples with Type Labels

```
[EPIC] Provider Directory [21 points]
- [STORY - RECIPE] saplings_person Recipe Development [8 points]
-- [TASK] Create recipe configuration [3 points]
-- [TASK] Add demo content [2 points]
-- [SPIKE] Research shared field dependencies [2 points]
-- [DOCS] Document recipe usage [1 point]
- [STORY - API] Provider REST API [8 points]
-- [TASK] Create provider endpoint [3 points]
-- [TASK] Add filtering support [2 points]
-- [TEST] Write API integration tests [2 points]
-- [DOCS] Document API endpoints [1 point]
```

---

## Naming Conventions

### Epic Names

Format: `[EPIC] Feature Name [XX points]`

**Good examples:**
```
[EPIC] User Authentication System [13 points]
[EPIC] Provider Directory [21 points]
[EPIC] E-commerce Checkout Flow [21 points]
[EPIC - FOUNDATION] Development Environment Setup [8 points]
```

**Bad examples:**
```
[EPIC] Auth (missing context, no points)
User Authentication [13 points] (missing [EPIC] label)
[EPIC] User Authentication System (missing story points)
```

### Story Names

Format: `- [STORY] Feature Description [X points]`

**Good examples:**
```
- [STORY] User Registration Flow [5 points]
- [STORY] Provider Search and Filtering [8 points]
- [STORY - RECIPE] saplings_person Recipe [8 points]
```

**Bad examples:**
```
- User Registration [5 points] (missing [STORY] label)
[STORY] User Registration Flow [5 points] (missing dash prefix)
- [STORY] Registration (too vague, no points)
```

### Task Names

Format: `-- [TASK] Specific Action [X points]`

**Good examples:**
```
-- [TASK] Create registration form component [3 points]
-- [TASK] Implement email verification [2 points]
-- [SPIKE] Research authentication solutions [2 points]
```

**Bad examples:**
```
-- Registration form (missing [TASK] label, no points)
- [TASK] Create registration form [3 points] (wrong prefix, should be --)
-- [TASK] Form (too vague, no points)
```

---

## Hierarchy Best Practices

### 1. Maintain Consistent Depth

**Recommended:** 3 levels (Epic → Story → Task)

**Use 4th level only when:**
- Breaking down complex technical tasks
- Showing parallel work streams
- Decomposing spike/research tasks

### 2. Balance Story Points

**Epic (13-21 points):**
- 2-4 stories
- Each story 3-8 points

**Story (3-8 points):**
- 2-5 tasks
- Each task 1-3 points

**Task (1-3 points):**
- Atomic work unit
- Can be completed in 1-2 days

### 3. Story Point Distribution Patterns

**Pattern 1: Balanced (Recommended)**
```
[EPIC] Feature [13 points]
- [STORY] Part 1 [5 points]
- [STORY] Part 2 [5 points]
- [STORY] Part 3 [3 points]
```

**Pattern 2: Foundation Heavy**
```
[EPIC] Feature [13 points]
- [STORY] Foundation [8 points] (front-loaded complexity)
- [STORY] Build-out [3 points]
- [STORY] Polish [2 points]
```

**Pattern 3: Progressive Complexity**
```
[EPIC] Feature [13 points]
- [STORY] Basic Implementation [3 points]
- [STORY] Enhanced Features [5 points]
- [STORY] Advanced Features [5 points]
```

### 4. Avoid Common Mistakes

**Too shallow (missing hierarchy):**
```
❌ [EPIC] User Auth [13 points]
❌ [TASK] Registration [5 points] (should be Story)
❌ [TASK] Login [5 points] (should be Story)
❌ [TASK] Password Reset [3 points] (should be Story)
```

**Too deep (unnecessary levels):**
```
❌ [EPIC] User Auth [13 points]
❌ - [STORY] Registration [5 points]
❌ -- [TASK] Create form [3 points]
❌ --- [TASK] Add name field [1 point] (too granular)
❌ --- [TASK] Add email field [1 point] (too granular)
❌ --- [TASK] Add password field [1 point] (too granular)
```

**Correct (right balance):**
```
✅ [EPIC] User Authentication System [13 points]
✅ - [STORY] User Registration Flow [5 points]
✅ -- [TASK] Create registration form component [3 points]
✅ -- [TASK] Implement email verification [2 points]
✅ - [STORY] User Login Flow [5 points]
✅ -- [TASK] Create login form component [2 points]
✅ -- [TASK] Implement JWT authentication [3 points]
✅ - [STORY] Password Reset Flow [3 points]
✅ -- [TASK] Create password reset form [2 points]
✅ -- [TASK] Implement token generation [1 point]
```

---

## Dependency Indicators

While Teamwork handles dependencies separately, you can indicate dependencies in task names or descriptions:

### In Task Names

```
[EPIC] Provider Directory [21 points]
- [STORY] Provider Content Model [8 points] (BLOCKING)
-- [TASK] Create Person content type [3 points]
-- [TASK] Create shared field storage [2 points]
- [STORY] Provider Listing [8 points] (DEPENDS ON: Content Model)
-- [TASK] Create Provider Directory view [3 points]
```

### In Descriptions

```markdown
## Description
> As a developer, I need to create the Provider Directory view...

## Dependencies
* Depends on: Provider Content Model completion
* Blocked by: Shared field storage creation

## Technical Details
Cannot start until Person content type and shared fields exist.
```

---

## CSV Format Examples

### Minimal CSV (3 tasks)

```csv
Tasklist,Task,Description,Assign to,Start date,Due date,Priority,Estimated time,Tags,Status
"Phase 1: Setup","[EPIC] Development Setup [8 points]","## Description

> As a developer, I need a local development environment...

## Story Points
**8 points** - Standard setup with Docker and CI/CD","","","",high,32,"SP-8,Phase-1,MVP,DevOps",Active
"Phase 1: Setup","- [STORY] Local Environment [3 points]","## Description

> As a developer, I need a local Docker environment...

## Story Points
**3 points** - Standard Docker setup","","","",high,8,"SP-3,Phase-1,MVP,DevOps",Active
"Phase 1: Setup","-- [TASK] Configure Docker Compose [2 points]","## Description

> As a developer, I need Docker Compose configuration...

## Story Points
**2 points** - Standard configuration

## Acceptance Criteria
* Docker containers start successfully
* Database connection works
* Site accessible on localhost","","","",high,4,"SP-2,Phase-1,MVP,DevOps",Active
```

### Full Hierarchy CSV (multiple levels)

See complete examples in the **[Teamwork Format](teamwork-format.md)** template, section "Complete CSV Row Examples".

---

## Quick Reference

### Hierarchy Levels

| Prefix | Type | Points | Example |
|--------|------|--------|---------|
| None | Epic | 13-21+ | `[EPIC] Feature [13 points]` |
| `-` | Story | 3-8 | `- [STORY] Sub-feature [5 points]` |
| `--` | Task | 1-3 | `-- [TASK] Implementation [2 points]` |
| `---` | Sub-task | 1 | `--- [TASK] Detail [1 point]` |

### Type Labels

| Label | Use For |
|-------|---------|
| `[EPIC]` | Feature grouping |
| `[STORY]` | User story |
| `[TASK]` | Implementation task |
| `[SPIKE]` | Research/investigation |
| `[BUG]` | Bug fix |
| `[REFACTOR]` | Code refactoring |
| `[TEST]` | Testing task |
| `[DOCS]` | Documentation |

### Estimated Hours by Story Points

| Points | Hours | Use For |
|--------|-------|---------|
| 1 | 2 | Trivial tasks |
| 2 | 4 | Small tasks |
| 3 | 8 | Standard tasks (1 day) |
| 5 | 16 | Complex tasks (2 days) |
| 8 | 32 | Major tasks (4 days) |
| 13 | 80 | Large epics (2 weeks) |
| 21 | 120 | Very large epics (3 weeks) |

### Priority Mapping

| FRD | CSV | Use For |
|-----|-----|---------|
| MUST HAVE | `high` | MVP, critical path, blockers |
| SHOULD HAVE | `medium` | Important features |
| NICE TO HAVE | `low` | Enhancements, polish |
