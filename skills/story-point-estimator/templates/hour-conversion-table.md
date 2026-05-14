# Story Points to Hours Conversion Table

This table provides hour equivalents for story points to help with stakeholder communication and timeline planning.

**Important**: Story points are relative measures of effort, not absolute time. Hours are approximations and will vary by team, project, and individual developer skill.

---

## Conversion Table

| Story Points | Hour Range | Day Range | Typical Use |
|--------------|------------|-----------|-------------|
| 1 point      | 1-2 hours  | <0.5 day  | Trivial change, config update |
| 2 points     | 2-4 hours  | 0.5 day   | Small feature, basic bug fix |
| 3 points     | 4-8 hours  | 1 day     | Standard feature with testing |
| 5 points     | 12-24 hours| 2-3 days  | Complex feature with integration |
| 8 points     | 24-40 hours| 3-5 days  | Major feature with architecture |
| 13 points    | 40-80 hours| 1-2 weeks | Epic (should be broken down) |
| 21 points    | 80-120 hours| 2-3 weeks | Large epic (must be decomposed) |
| 34+ points   | 120+ hours | 3+ weeks  | Too large (requires decomposition) |

---

## Detailed Breakdown

### 1 Point = 1-2 Hours

**Best Case**: 1 hour (straightforward, no obstacles)
**Typical**: 1.5 hours (minor questions, standard process)
**Worst Case**: 2 hours (small complications, clarifications needed)

**What's Included**:
- Implementation: 45 minutes
- Testing: 15 minutes
- Code review: 15 minutes
- Documentation: 15 minutes

**Examples**:
- Update copyright text: 1 hour
- Change CSS color: 1 hour
- Fix typo in code: 0.5 hours

---

### 2 Points = 2-4 Hours

**Best Case**: 2 hours (clear requirements, no blockers)
**Typical**: 3 hours (normal questions, standard review)
**Worst Case**: 4 hours (some unknowns, minor rework)

**What's Included**:
- Implementation: 2 hours
- Testing: 0.5 hours
- Code review: 0.5 hours
- Documentation: 0.5 hours

**Examples**:
- Add form validation: 2 hours
- Create UI component: 3 hours
- Simple bug fix: 2-3 hours

---

### 3 Points = 4-8 Hours (1 Day)

**Best Case**: 4 hours (well-defined, smooth execution)
**Typical**: 6 hours (standard complexity, normal review)
**Worst Case**: 8 hours (edge cases, iterations needed)

**What's Included**:
- Implementation: 3-4 hours
- Testing: 1-2 hours
- Code review: 0.5-1 hour
- Documentation: 0.5-1 hour

**Examples**:
- Search filter feature: 6 hours
- API endpoint (CRUD): 5 hours
- Content type creation: 4 hours

---

### 5 Points = 12-24 Hours (2-3 Days)

**Best Case**: 12 hours (well-scoped, efficient execution)
**Typical**: 16 hours (standard complexity, normal blockers)
**Worst Case**: 24 hours (unexpected complexity, rework needed)

**What's Included**:
- Implementation: 8-12 hours
- Testing: 2-4 hours
- Code review: 1-2 hours
- Documentation: 1-2 hours
- Integration work: 2-4 hours

**Examples**:
- Authentication flow: 18 hours
- Payment integration: 20 hours
- Multi-step form: 16 hours

---

### 8 Points = 24-40 Hours (3-5 Days)

**Best Case**: 24 hours (clear architecture, smooth implementation)
**Typical**: 32 hours (some unknowns, normal iterations)
**Worst Case**: 40 hours (significant complexity, multiple revisions)

**What's Included**:
- Implementation: 12-20 hours
- Testing: 4-8 hours
- Code review: 2-4 hours
- Documentation: 2-4 hours
- Architecture/design: 2-4 hours
- Integration/deployment: 2-4 hours

**Examples**:
- Real-time notification system: 32 hours
- Complex reporting dashboard: 35 hours
- Advanced search system: 30 hours

---

### 13 Points = 40-80 Hours (1-2 Weeks)

**Best Case**: 40 hours (well-defined epic, minimal unknowns)
**Typical**: 60 hours (normal epic complexity)
**Worst Case**: 80 hours (significant unknowns, coordination overhead)

**What's Included**:
- Implementation: 20-40 hours
- Testing: 8-16 hours
- Code review: 4-8 hours
- Documentation: 4-8 hours
- Architecture/design: 4-8 hours
- Integration/coordination: 4-8 hours

**Recommendation**: Break into 3-5 point stories before sprint planning

**Examples**:
- User management system: 60 hours
- E-commerce checkout: 65 hours
- Recipe-based content model: 55 hours

---

### 21 Points = 80-120 Hours (2-3 Weeks)

**Best Case**: 80 hours (clear scope, efficient team)
**Typical**: 100 hours (standard large epic)
**Worst Case**: 120 hours (many unknowns, extensive coordination)

**What's Included**:
- Implementation: 40-60 hours
- Testing: 16-24 hours
- Code review: 8-12 hours
- Documentation: 8-12 hours
- Architecture/design: 8-12 hours
- Integration/coordination: 8-12 hours

**Requirement**: MUST be decomposed into 8-13 point epics before sprint planning

**Examples**:
- Complete theme development: 100 hours
- Full content model (5+ types): 110 hours
- Major platform migration: 115 hours

---

### 34+ Points = 120+ Hours (3+ Weeks)

**Too large to estimate accurately**

**Action Required**: Decompose into smaller epics immediately

---

## Using Hour Estimates

### For Stakeholder Communication

**Convert story points to hours when**:
- Client asks "how long will this take?"
- Leadership needs timeline projections
- Budget estimation required
- Resource planning needed

**Example**:
> "This feature is estimated at 5 story points, which typically translates to 12-24 hours of development work, or about 2-3 days. This includes implementation, testing, code review, and documentation."

### For Sprint Planning

**Use story points internally**:
- Track velocity in points, not hours
- Plan sprints using points
- Compare tasks relatively

**Convert to hours for**:
- Individual task time tracking
- Identifying capacity constraints
- Communicating with non-technical stakeholders

### For Timeline Projections

**Calculate project duration**:

```
Total hours = Total story points × Average hours per point
Timeline = Total hours / (Team size × Hours per week × Productive %)

Example:
150 story points × 6 hours per point = 900 hours
900 hours / (3 devs × 40 hrs/week × 70%) = 10.7 weeks ≈ 11 weeks
```

---

## Factors That Affect Hour Conversion

### Team Experience
- **Junior team**: Higher hours per point (8-10 hours for 3 points)
- **Senior team**: Lower hours per point (4-6 hours for 3 points)

### Project Type
- **Greenfield**: Typically faster (lower hours per point)
- **Legacy system**: Typically slower (higher hours per point)

### Technology Familiarity
- **Familiar stack**: Standard hours per point
- **New technology**: Add 20-50% to hour estimates

### Technical Debt
- **Clean codebase**: Standard hours per point
- **High tech debt**: Add 20-30% to hour estimates

### Interruptions
- **Dedicated team**: Lower hours per point
- **Shared responsibilities**: Add 20-30% for context switching

---

## Calibration Guidance

### Initial Calibration (Sprints 1-3)

Use conservative estimates:
- 1 point = 2 hours
- 2 points = 4 hours
- 3 points = 8 hours
- 5 points = 20 hours
- 8 points = 40 hours

### Ongoing Calibration (Sprints 4+)

Calculate actual hours per point:

```
Actual hours per point = Total hours spent / Total points completed

Example:
Sprint 4: 168 hours / 28 points = 6 hours per point
Sprint 5: 175 hours / 30 points = 5.8 hours per point
Sprint 6: 162 hours / 27 points = 6 hours per point

Average: 6 hours per point
```

Adjust conversion table based on team's actual performance.

---

## Common Mistakes

### Mistake 1: Using Hours for Sprint Planning
**Problem**: Hours are less reliable than relative points
**Solution**: Plan sprints using points, convert to hours only for communication

### Mistake 2: Not Accounting for Non-Coding Time
**Problem**: Estimate only coding time, forget testing/review/docs
**Solution**: Hours in conversion table include all work

### Mistake 3: Assuming All Points Equal Same Hours
**Problem**: 1 point doesn't always equal 2 hours (varies by task)
**Solution**: Use hour ranges, acknowledge variability

### Mistake 4: Not Calibrating Over Time
**Problem**: Use default conversion without team data
**Solution**: Track actual hours and adjust conversion table

---

## Best Practices

1. **Use Points Internally**: Track velocity and plan sprints with points
2. **Convert for Stakeholders**: Translate to hours when communicating with non-technical audiences
3. **Provide Ranges**: "5 points is typically 12-24 hours" vs "5 points is exactly 16 hours"
4. **Calibrate Regularly**: Update hour conversions based on actual team performance
5. **Include All Work**: Hours include implementation, testing, review, documentation, deployment
6. **Add Buffer**: When converting points to project timeline, add 20-30% buffer
