---
name: story-point-estimator
description: Provide story point estimation guidance with hour calculations for software development tasks. Uses Fibonacci sequence (1, 2, 3, 5, 8, 13, 21, 34+) and converts story points to hours. Includes platform-specific adjustments and velocity calculations.
---

# Story Point Estimator

Provide accurate story point estimates with hour calculations for software development work.

## Philosophy

Story points provide a relative measure of effort that accounts for complexity, uncertainty, and risk.

### Core Beliefs

1. **Relative Sizing Works Better Than Absolute Time**: Compare tasks to known reference stories
2. **Include All Work in Estimates**: Implementation, testing, review, documentation, deployment
3. **Fibonacci Reflects Uncertainty**: Larger tasks have more unknowns, gaps increase accordingly
4. **Hours Provide Context**: Convert story points to hours for stakeholder communication

### Why Story Points Matter

- **Velocity Tracking**: Measure team capacity consistently across sprints
- **Relative Estimation**: Easier to compare tasks than estimate absolute time
- **Account for Uncertainty**: Larger gaps reflect higher uncertainty
- **Team Calibration**: Shared understanding of effort and complexity

## When to Use This Skill

Activate this skill when the user:
- Asks "how many story points is this?"
- Says "estimate this feature"
- Mentions "how long will this take?"
- Asks about task complexity or effort
- Needs to plan sprint capacity
- Asks "how do I estimate this?"
- Mentions velocity or capacity planning

## Decision Framework

Before providing estimates, determine:

### What Is Being Estimated?

1. **Single Task** - Specific implementation work → Direct story point estimate
2. **Feature** - Multiple related tasks → Break into stories, estimate each
3. **Epic** - Large body of work → Decompose into 3-8 point stories first
4. **Bug Fix** - Defect resolution → Estimate based on complexity and investigation
5. **Technical Debt** - Refactoring or improvement → Estimate like features

### What's the Complexity?

- **Technical Complexity** - New technology, algorithms, performance optimization
- **Integration Complexity** - Multiple systems, APIs, data transformation
- **Business Logic Complexity** - Many edge cases, conditional logic, workflows
- **Uncertainty** - Unknown requirements, unclear implementation path

### What's Included in the Work?

**Always include**:
- Implementation time
- Unit and integration testing
- Code review cycle
- Documentation
- Deployment preparation
- Bug fixes from testing

### Are There Dependencies?

- **Blocking Dependencies** - Add buffer for waiting time
- **Parallel Work** - Consider coordination overhead
- **External Dependencies** - Add uncertainty buffer
- **Shared Resources** - Account for contention

### What's the Platform?

- **Drupal (recipes)** - Special consideration for shared field storage, recipe dependencies
- **WordPress (blocks)** - Block registration, attributes, editor integration
- **Custom Platform** - Standard web development patterns

### Decision Tree

```
User requests estimate
    ↓
Identify work type (task/feature/epic/bug)
    ↓
Assess complexity (technical/integration/business)
    ↓
Identify dependencies and blockers
    ↓
Check platform-specific considerations
    ↓
Apply Fibonacci scale (1, 2, 3, 5, 8, 13, 21, 34+)
    ↓
Convert to hours for stakeholder communication
    ↓
Provide estimate with rationale
```

## Workflow

### 1. Understand the Work

**Ask clarifying questions**:
- What is the specific scope of this work?
- Are there any dependencies or blockers?
- What testing is required?
- Is there existing code to modify or is this new?
- What's the platform and architecture?

### 2. Reference the Fibonacci Scale

Use the standard Fibonacci sequence:

**1, 2, 3, 5, 8, 13, 21, 34+**

Refer to templates for detailed definitions:
- `templates/fibonacci-scale.md` - Complete scale with examples
- `templates/hour-conversion-table.md` - Story points to hours mapping

### 3. Consider Platform-Specific Factors

**Drupal (recipes)**:
- Recipe creation and configuration export: 2-3 points per recipe
- Shared field storage coordination: +1-3 points based on complexity
- Recipe dependencies and installation order: +1-2 points
- Clean environment testing: 1 point per recipe

**WordPress (blocks)**:
- Block registration and metadata: 2-3 points per block
- Block attributes and serialization: +1-2 points based on complexity
- Editor integration and controls: +1-3 points
- Dynamic rendering (PHP): +2-3 points

**General Web Development**:
- Standard patterns apply from fibonacci-scale.md
- Include time for testing, review, deployment

### 4. Calculate Hours

Use hour conversion table:

- **1 point** = 2 hours
- **2 points** = 4 hours
- **3 points** = 8 hours (1 day)
- **5 points** = 12-16 hours (2 days)
- **8 points** = 24-32 hours (3-4 days)
- **13 points** = 40-80 hours (1-2 weeks)
- **21 points** = 80-120 hours (2-3 weeks)
- **34+ points** = Must be decomposed

Refer to `templates/hour-conversion-table.md` for complete mapping.

### 5. Provide Velocity Context

If calculating project timeline, use velocity formula:

```
Velocity (points/sprint) = (Team size × Hours per sprint × Productive %) / Avg hours per point
```

Refer to `templates/velocity-calculation.md` for examples.

### 6. Format the Estimate

**Provide**:
- Story point estimate with Fibonacci value
- Hour range for stakeholder communication
- Key complexity factors
- Any assumptions or dependencies
- Recommendation to break down if 13+ points

**Example Output**:
```
Estimate: 5 story points (12-16 hours, ~2 days)

Rationale:
- Complex feature requiring multiple components
- Integration with external API
- Includes testing, documentation, deployment
- Some uncertainty around API response format

Assumptions:
- API documentation is available
- No blocking dependencies
- Standard code review process

Recommendation: Proceed with 5 points. If API integration proves more complex, may need to re-estimate.
```

## Templates

Use these templates for reference:

### Fibonacci Scale
`templates/fibonacci-scale.md` - Complete Fibonacci scale with definitions, examples, and when to use each value

### Hour Conversion Table
`templates/hour-conversion-table.md` - Story point to hour mappings with ranges and context

### Velocity Calculation
`templates/velocity-calculation.md` - Team velocity formulas, examples, and calibration guidance

### Platform Estimates
`templates/platform-estimates.md` - Platform-specific estimation patterns for Drupal, WordPress, and general web development

## Best Practices

### Include Complete Work
- Implementation + testing + review + documentation + deployment
- Don't just estimate coding time

### Use Relative Sizing
- Compare to known reference stories
- "This is similar to X but with Y complexity"

### Account for Uncertainty
- Higher points = more uncertainty
- Use larger Fibonacci gaps for uncertain work

### Break Down Large Items
- 13+ points should be decomposed before sprint planning
- Break into 3-8 point stories

### Calibrate with Team Velocity
- Use historical velocity for planning
- Re-calibrate as team learns

### Re-estimate When Requirements Change
- Scope increases = higher estimate
- New constraints = re-evaluate

### Document Assumptions
- Note dependencies
- Identify risks
- Clarify scope boundaries

## Common Estimation Patterns

### Bug Fixes
- **1 point**: Simple fix, known cause
- **2 points**: Investigation needed, moderate fix
- **3 points**: Complex investigation, significant fix
- **5+ points**: Architectural issue or multiple bugs

### New Features
- **2 points**: Trivial feature (add field, styling)
- **3 points**: Small feature (component, endpoint)
- **5 points**: Standard feature (multiple components)
- **8 points**: Complex feature (architecture decisions)
- **13+ points**: Epic feature (break down required)

### Technical Debt
- **1-2 points**: Small refactoring (rename, extract function)
- **3 points**: Moderate refactoring (extract class, reorganize)
- **5 points**: Significant refactoring (redesign component)
- **8+ points**: Major refactoring (system-wide changes)

### Documentation
- **1 point**: Minor docs (README update, comments)
- **2 points**: Moderate docs (API documentation, user guide page)
- **3 points**: Comprehensive docs (complete manual, developer guide)

## Output Format

Always provide estimates in this format:

```markdown
## Estimate: [X] Story Points

**Hour Equivalent**: [Y-Z hours] ([A-B days])

**Complexity Factors**:
- [Factor 1]
- [Factor 2]
- [Factor 3]

**What's Included**:
- Implementation
- Testing (unit + integration)
- Code review cycle
- Documentation
- Deployment preparation

**Assumptions**:
- [Assumption 1]
- [Assumption 2]

**Dependencies**:
- [Dependency 1 if any]

**Platform-Specific Considerations**:
- [Platform consideration if applicable]

**Recommendation**: [Proceed with estimate / Break down further / Conduct technical spike]
```

## Error Handling

### If Requirements Are Unclear
- Ask clarifying questions before estimating
- Provide a range: "This is likely 3-5 points depending on..."
- Recommend a technical spike (1-2 points) to reduce uncertainty

### If Work Is Too Large
- Recommend decomposition: "This is 21+ points and should be broken down"
- Help identify sub-stories: "This epic includes X, Y, Z which could be separate stories"

### If Platform Is Unknown
- Use general web development patterns
- Note that platform-specific considerations may adjust estimate

### If Dependencies Are Unclear
- Note dependency risk in estimate
- Recommend clarifying dependencies before sprint planning

## Integration with FRD Generation

When used in FRD context:
- Estimate all requirements and epics
- Calculate total project story points
- Provide velocity-based timeline projection
- Include buffer for uncertainty (20-30%)
- Break down phases with story point totals
