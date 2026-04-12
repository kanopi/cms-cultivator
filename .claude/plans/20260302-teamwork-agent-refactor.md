# Refactor Teamwork Skills & Agent to Multi-File Structure

## Objective

Bring Teamwork skills under the 500-line guideline by extracting content to separate template files, following the established pattern used by `documentation-generator` and `test-scaffolding` skills.

## Current State

**Line counts:**
- `teamwork-task-creator/SKILL.md`: 618 lines (118 over limit)
- `teamwork-integrator/SKILL.md`: 569 lines (69 over limit)
- `teamwork-exporter/SKILL.md`: 793 lines (293 over limit)
- `teamwork-specialist/AGENT.md`: 838 lines (no explicit limit, but should refactor for consistency)

**Existing multi-file pattern:**
- `documentation-generator`: 5 files (SKILL.md + 4 in templates/)
- `test-scaffolding`: 4 files (SKILL.md + 3 in templates/)
- Both use `templates/` subdirectory with markdown links in "Templates" section

## Target State

**After refactoring:**
- `teamwork-task-creator/SKILL.md`: ~350 lines (extract ~268 lines)
- `teamwork-integrator/SKILL.md`: ~300 lines (extract ~269 lines)
- `teamwork-exporter/SKILL.md`: ~250 lines (extract ~543 lines)
- `teamwork-specialist/AGENT.md`: ~500 lines (extract ~338 lines)

**Total template files to create:** 25 new files

## Architectural Decisions

### 1. Use `templates/` Subdirectory

**Rationale:** Matches established pattern in existing multi-file skills. Provides consistency across the plugin.

### 2. Create `templates/audit-handlers/` Subdirectory for Exporter

**Rationale:** The exporter has 4 distinct audit type transformations (security, performance, accessibility, quality), each 80-120 lines. Subdirectory prevents cluttering main templates directory.

### 3. Refactor Agent Too

**Rationale:** While agents don't have explicit 500-line limit, refactoring to ~500 lines improves maintainability and follows same pattern as skills.

### 4. Add References Section

**Format (following documentation-generator pattern):**
```markdown
## Templates

Complete templates are available for reference:

- **[Template Name](templates/filename.md)** - Description
- **[Another Template](templates/another.md)** - Description

Use these templates as starting points, customizing for specific needs.
```

## Final Directory Structure

```
skills/
├── teamwork-task-creator/
│   ├── SKILL.md (350 lines)
│   └── templates/
│       ├── task-templates.md (300 lines - all 4 templates)
│       ├── cms-platform-notes.md (60 lines - Drupal/WordPress/NextJS)
│       ├── task-examples.md (150 lines - good vs bad)
│       └── priority-guide.md (15 lines - P0-P4 mapping)
│
├── teamwork-integrator/
│   ├── SKILL.md (300 lines)
│   └── templates/
│       ├── ticket-patterns.md (25 lines)
│       ├── operations-reference.md (130 lines)
│       ├── integration-examples.md (115 lines)
│       ├── cms-context.md (55 lines)
│       ├── mcp-tools-reference.md (25 lines)
│       └── performance-tips.md (6 lines)
│
└── teamwork-exporter/
    ├── SKILL.md (250 lines)
    └── templates/
        ├── priority-mapping.md (20 lines)
        ├── template-selection.md (25 lines)
        ├── batch-patterns.md (60 lines)
        ├── dependency-management.md (30 lines)
        ├── agent-integration.md (55 lines)
        ├── mcp-tools.md (10 lines)
        ├── error-handling.md (45 lines)
        └── audit-handlers/
            ├── security-export.md (110 lines)
            ├── performance-export.md (100 lines)
            ├── accessibility-export.md (120 lines)
            └── quality-export.md (115 lines)

agents/
└── teamwork-specialist/
    ├── AGENT.md (500 lines)
    └── templates/
        ├── task-templates-overview.md (100 lines)
        ├── cms-notes.md (90 lines)
        ├── workflow-examples.md (200 lines)
        └── error-recovery.md (50 lines)
```

## Extraction Details

### teamwork-task-creator (618→350 lines)

**Extract to templates/:**
1. `task-templates.md` (~300 lines) - All 4 task templates (Big Task/Epic, Little Task, QA Handoff, Bug Report) with required sections
2. `cms-platform-notes.md` (~60 lines) - Drupal, WordPress, NextJS specific context
3. `task-examples.md` (~150 lines) - Good vs. bad task examples with explanations
4. `priority-guide.md` (~15 lines) - P0-P4 priority levels and when to use each

**Retain in SKILL.md:**
- Philosophy (why tasks matter)
- When to Use guidance
- Template Selection Algorithm & decision tree
- Handling Missing Information
- Integration with Teamwork Specialist
- Best Practices
- Output Format
- Example Workflow
- **NEW: Templates section** with markdown links

### teamwork-integrator (569→300 lines)

**Extract to templates/:**
1. `ticket-patterns.md` (~25 lines) - Supported ticket formats and pattern matching
2. `operations-reference.md` (~130 lines) - Complete details for all 4 core operations
3. `integration-examples.md` (~115 lines) - Real-world usage examples
4. `cms-context.md` (~55 lines) - Drupal, WordPress, NextJS specific information
5. `mcp-tools-reference.md` (~25 lines) - Teamwork MCP tools and usage patterns
6. `performance-tips.md` (~6 lines) - Caching and optimization strategies

**Retain in SKILL.md:**
- Philosophy (quick context without interruption)
- When to Use guidance
- Ticket Number Pattern Recognition (overview)
- Core Operations (summary with links to detailed reference)
- Workflow (decision tree)
- Error Handling
- When to Escalate to Teamwork Specialist
- Best Practices
- Output Format
- **NEW: References section** with markdown links

### teamwork-exporter (793→250 lines)

**Extract to templates/:**
1. `priority-mapping.md` (~20 lines) - Severity to priority conversion tables
2. `template-selection.md` (~25 lines) - Logic for choosing task templates
3. `batch-patterns.md` (~60 lines) - Epic creation and task grouping strategies
4. `dependency-management.md` (~30 lines) - Auto-detecting task dependencies
5. `agent-integration.md` (~55 lines) - How audit agents pass data to exporter
6. `mcp-tools.md` (~10 lines) - Teamwork MCP tools for export
7. `error-handling.md` (~45 lines) - Fallback strategies when MCP unavailable
8. `audit-handlers/` subdirectory:
   - `security-export.md` (~110 lines) - Security findings to bug reports
   - `performance-export.md` (~100 lines) - Performance issues to tasks
   - `accessibility-export.md` (~120 lines) - WCAG violations to bug reports
   - `quality-export.md` (~115 lines) - Code quality issues to refactoring tasks

**Retain in SKILL.md:**
- Philosophy (bridge between findings and execution)
- When to Use guidance
- Core Responsibilities (overview with links)
- Workflow (5-step process)
- Output Format (summary structure)
- Best Practices
- **NEW: References section** with markdown links

### teamwork-specialist (838→500 lines)

**Extract to templates/:**
1. `task-templates-overview.md` (~100 lines) - All 4 templates with requirements
2. `cms-notes.md` (~90 lines) - Drupal, WordPress, NextJS platform guidance
3. `workflow-examples.md` (~200 lines) - Complete examples of common operations
4. `error-recovery.md` (~50 lines) - Detailed patterns for handling edge cases

**Retain in AGENT.md:**
- Frontmatter (unchanged)
- When to Use This Agent
- Core Responsibilities (overview)
- Template Selection Logic
- Tools Available
- Skills You Use
- Workflow
- Commands You Support
- CMS-Specific Context (overview with link)
- Best Practices
- Priority Mapping
- Error Recovery (overview with link)
- Integration with Other Agents
- Output Format
- Tips for Success
- Remember section
- **NEW: Templates and References section** with markdown links

## Implementation Steps

### Step 1: Create Template Directories (5 min)

```bash
mkdir -p skills/teamwork-task-creator/templates
mkdir -p skills/teamwork-integrator/templates
mkdir -p skills/teamwork-exporter/templates/audit-handlers
mkdir -p agents/teamwork-specialist/templates
```

### Step 2: Extract Content to Templates (2-3 hours)

**Order of extraction:**
1. **teamwork-task-creator** (4 template files) - Simplest, good warm-up
2. **teamwork-integrator** (6 template files) - Medium complexity
3. **teamwork-specialist** (4 template files) - Agent references skills
4. **teamwork-exporter** (11 template files) - Most complex, has subdirectory

**For each template file:**
- Add clear markdown header (# Template Name)
- Copy relevant content from main file
- Add introduction explaining when/how to use
- Format code blocks properly
- Save as `.md` file in appropriate directory

### Step 3: Update Main Files (45 min)

**For each SKILL.md/AGENT.md:**
1. Remove extracted content
2. Add References/Templates section with markdown links
3. Update section headers to reference templates
4. Replace detailed examples with "See [template](path)"
5. Verify frontmatter unchanged
6. Check line count meets target

**References section format:**
```markdown
## Templates

Complete templates are available for reference:

- **[Template Name](templates/filename.md)** - Brief description
- **[Another Template](templates/another.md)** - Brief description

Use these templates as starting points, customizing for specific needs.
```

### Step 4: Update Documentation (30 min)

**Files to update:**
1. `docs/project-management/teamwork-integration.md` - Document new structure
2. `commands/teamwork.md` - Update "How It Works" if needed
3. Verify other docs still reference correctly

**Changes:**
- Mention that skills now use templates/ subdirectories
- Update any direct file path references
- Ensure markdown links still work

### Step 5: Verification (45 min)

**Line count verification:**
```bash
wc -l skills/teamwork-task-creator/SKILL.md   # Should be ~350
wc -l skills/teamwork-integrator/SKILL.md    # Should be ~300
wc -l skills/teamwork-exporter/SKILL.md      # Should be ~250
wc -l agents/teamwork-specialist/AGENT.md    # Should be ~500
```

**Link checking:**
```bash
zensical build --clean
# Should build without broken link errors
```

**Skill loading test:**
```bash
# Install plugin locally
ln -s $(pwd) ~/.config/claude/plugins/cms-cultivator

# Enable plugin
claude plugins enable cms-cultivator

# Test skill activation
# 1. Open Claude Code
# 2. Say: "Create a task for implementing OAuth authentication"
#    → Should activate teamwork-task-creator skill
# 3. Say: "What's the status of PROJ-123?"
#    → Should activate teamwork-integrator skill
# 4. Say: "Export these security findings to Teamwork"
#    → Should activate teamwork-exporter skill
```

**Verify:**
- ✅ Skills load correctly
- ✅ Frontmatter unchanged
- ✅ Template links resolve
- ✅ Core workflows intact
- ✅ No broken documentation links

### Step 6: Git Commit (15 min)

**Branch:** `feature/teamwork-integration` (current branch with PR #23)

**Commit message:**
```
refactor(teamwork): extract content to templates for 500-line guideline

Bring Teamwork skills and agent under maintainability guidelines by
extracting detailed content to separate template files:

Skills refactored:
- teamwork-task-creator: 618→350 lines (4 template files)
- teamwork-integrator: 569→300 lines (6 template files)
- teamwork-exporter: 793→250 lines (11 template files + subdirectory)

Agent refactored:
- teamwork-specialist: 838→500 lines (4 template files)

Follows established pattern from documentation-generator and
test-scaffolding skills. All content remains accessible via
markdown links in Templates/References sections.

Total: 25 new template files created in templates/ subdirectories.
```

**Files changed:**
- Modified: 4 files (3 SKILL.md + 1 AGENT.md)
- Created: 29 files (25 templates + 4 template directories)
- Modified: ~3 documentation files

### Step 7: Update PR Description (15 min)

Update PR #23 description to mention:
- Refactored to multi-file structure for maintainability
- Follows 500-line guideline from Claude Code docs
- All content preserved in templates/ subdirectories
- Verification steps completed

## Critical Files

**Main files to refactor:**
- `/Users/thejimbirch/Projects/cms-cultivator/skills/teamwork-task-creator/SKILL.md`
- `/Users/thejimbirch/Projects/cms-cultivator/skills/teamwork-integrator/SKILL.md`
- `/Users/thejimbirch/Projects/cms-cultivator/skills/teamwork-exporter/SKILL.md`
- `/Users/thejimbirch/Projects/cms-cultivator/agents/teamwork-specialist/AGENT.md`

**Reference pattern:**
- `/Users/thejimbirch/Projects/cms-cultivator/skills/documentation-generator/SKILL.md` (lines 146-155 show established template reference pattern)

**Documentation to update:**
- `/Users/thejimbirch/Projects/cms-cultivator/docs/project-management/teamwork-integration.md`
- `/Users/thejimbirch/Projects/cms-cultivator/commands/teamwork.md`

## Success Criteria

**Must have:**
- ✅ All 4 files under target line counts (350, 300, 250, 500)
- ✅ No broken markdown links (verified by `zensical build --clean`)
- ✅ Skills load correctly in Claude Code
- ✅ Frontmatter unchanged (YAML headers must match exactly)
- ✅ Core workflows retained in main files
- ✅ Template structure follows existing patterns (templates/ subdirectory)

**Should have:**
- ✅ Documentation updated with new structure
- ✅ Template files have clear headers
- ✅ Cross-references work between files
- ✅ Clear commit message following conventional commits

**Nice to have:**
- ✅ Template navigation links (back to main file)
- ✅ References organized by topic/purpose
- ✅ Subdirectory for audit handlers (already planned)

## Risk Assessment

**Risk level:** Low - Pure refactoring, no functional changes

**Potential issues:**
1. **Broken markdown links** → Fix with link checker before commit
2. **Skill loading failure** → Verify frontmatter unchanged, test locally
3. **Documentation drift** → Update in follow-up if needed
4. **Template references unclear** → Add navigation/context to template files

**Mitigation:**
- Follow established pattern exactly (documentation-generator)
- Test locally before pushing
- Use link checker
- Verify frontmatter unchanged

## Timeline

**Total estimated time:** 4-6 hours

- Create directories: 5 minutes
- Extract templates: 2-3 hours
- Update main files: 45 minutes
- Documentation: 30 minutes
- Verification: 45 minutes
- Git commit: 15 minutes
- Update PR: 15 minutes
- Contingency: +1 hour

## Notes

- The 500-line guideline comes from [Claude Code Skills documentation](https://code.claude.com/docs/en/skills)
- Agents don't have explicit limit but applying same principle for consistency
- All extracted content remains accessible via markdown links
- YAML frontmatter must remain unchanged for skills to load properly
- Template files should be practical reference material, not verbose explanations
