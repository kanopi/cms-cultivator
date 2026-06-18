# Team Velocity Calculation

Team velocity measures how many story points a team can complete in a sprint. This guide provides formulas, examples, and calibration guidance.

---

## Velocity Formula

```
Velocity (points/sprint) = (Team size × Hours per sprint × Productive %) / Avg hours per point
```

### Formula Components

**Team size**: Number of developers working on the sprint
**Hours per sprint**: Total hours available per developer (sprint length × hours per day)
**Productive %**: Percentage of time spent on actual development (accounting for meetings, email, interruptions)
**Avg hours per point**: Average hours required to complete one story point

---

## Example Calculations

### Example 1: Standard 2-Week Sprint

**Given**:
- Team size: 3 developers
- Sprint length: 2 weeks (10 business days)
- Hours per developer per sprint: 80 hours (10 days × 8 hours)
- Productive percentage: 70%
- Average hours per story point: 6 hours

**Calculation**:
```
Total team hours = 3 developers × 80 hours = 240 hours
Productive hours = 240 hours × 70% = 168 hours
Velocity = 168 productive hours / 6 hours per point = 28 points per sprint
```

**Result**: This team can complete approximately **28 story points per 2-week sprint**.

---

### Example 2: Small Team, 1-Week Sprint

**Given**:
- Team size: 2 developers
- Sprint length: 1 week (5 business days)
- Hours per developer per sprint: 40 hours
- Productive percentage: 60% (lots of meetings)
- Average hours per story point: 6 hours

**Calculation**:
```
Total team hours = 2 developers × 40 hours = 80 hours
Productive hours = 80 hours × 60% = 48 hours
Velocity = 48 productive hours / 6 hours per point = 8 points per sprint
```

**Result**: This team can complete approximately **8 story points per 1-week sprint**.

---

### Example 3: Large Team, 3-Week Sprint

**Given**:
- Team size: 5 developers
- Sprint length: 3 weeks (15 business days)
- Hours per developer per sprint: 120 hours
- Productive percentage: 75% (mature team, few interruptions)
- Average hours per story point: 5 hours (senior team)

**Calculation**:
```
Total team hours = 5 developers × 120 hours = 600 hours
Productive hours = 600 hours × 75% = 450 hours
Velocity = 450 productive hours / 5 hours per point = 90 points per sprint
```

**Result**: This team can complete approximately **90 story points per 3-week sprint**.

---

### Example 4: Part-Time Team

**Given**:
- Team size: 3 developers (but only 50% time on this project)
- Sprint length: 2 weeks (10 business days)
- Hours per developer per sprint: 40 hours (50% of 80 hours)
- Productive percentage: 65%
- Average hours per story point: 7 hours

**Calculation**:
```
Total team hours = 3 developers × 40 hours = 120 hours
Productive hours = 120 hours × 65% = 78 hours
Velocity = 78 productive hours / 7 hours per point = 11 points per sprint
```

**Result**: This team can complete approximately **11 story points per 2-week sprint**.

---

## Productive Percentage Guidelines

The productive percentage accounts for non-development activities like meetings, email, interruptions, and context switching.

### 70-80% - Mature, Dedicated Team

**Characteristics**:
- Established processes and workflows
- Minimal meetings (daily standup + sprint ceremonies only)
- Few interruptions
- Dedicated to single project
- Clear requirements
- Strong team communication

**Use when**:
- Experienced team working together
- Well-defined project scope
- Minimal external dependencies
- Few support responsibilities

---

### 60-70% - Typical Team

**Characteristics**:
- Regular meetings (standup, planning, review, retro, plus ad-hoc)
- Some context switching between tasks
- Normal level of distractions
- Some support or maintenance responsibilities
- Standard project complexity

**Use when**:
- Average project environment
- Normal meeting load
- Balanced workload
- Standard development team

---

### 50-60% - New or Interrupted Team

**Characteristics**:
- Frequent meetings
- Learning new technology or domain
- Multiple project context switching
- High interrupt rate
- Onboarding new team members
- Unclear requirements requiring frequent clarification

**Use when**:
- New team formation
- Learning phase of project
- Complex or changing requirements
- High support load
- Training/mentoring responsibilities

---

### 40-50% - Highly Interrupted Team

**Characteristics**:
- Excessive meeting load
- Constant context switching across multiple projects
- Significant production support responsibilities
- Major training or mentoring duties
- Part-time allocation to project

**Use when**:
- Team split across many projects
- Heavy support/maintenance load
- Extensive client meetings
- Significant non-development responsibilities

---

### 30-40% - Severely Constrained Team

**Characteristics**:
- Majority of time spent on non-development work
- Extreme meeting load
- Emergency response responsibilities
- Minimal dedicated project time

**Use when**:
- Team has minimal capacity for new development
- Consider if this is sustainable or needs adjustment

---

## Average Hours Per Story Point

The average hours per point varies by team experience, technology familiarity, and project complexity.

### 4-5 Hours Per Point - Senior Team

**Characteristics**:
- Highly experienced developers
- Deep familiarity with technology stack
- Clean, well-architected codebase
- Strong team collaboration
- Minimal technical debt

---

### 6-7 Hours Per Point - Standard Team

**Characteristics**:
- Mix of senior and mid-level developers
- Good familiarity with stack
- Typical codebase quality
- Normal project complexity
- Some technical debt

---

### 8-10 Hours Per Point - Junior Team or Complex Project

**Characteristics**:
- Less experienced developers
- Learning new technologies
- Legacy codebase with significant debt
- High project complexity
- Unclear requirements

---

## Calibration Process

### Phase 1: Initial Estimate (Sprint 0)

Use conservative estimates based on team composition:

**Standard starting point**:
- Productive percentage: 65%
- Hours per point: 6 hours

Calculate theoretical velocity:
```
Velocity = (Team size × Hours per sprint × 65%) / 6 hours
```

---

### Phase 2: Learning Phase (Sprints 1-3)

**Track actual performance**:
- Story points committed vs. completed
- Actual hours spent (if possible)
- Blockers and delays encountered

**Example Tracking**:
```
Sprint 1:
- Committed: 30 points
- Completed: 24 points
- Actual hours: 168 hours
- Calculated: 168 hours / 24 points = 7 hours per point

Sprint 2:
- Committed: 28 points
- Completed: 28 points
- Actual hours: 170 hours
- Calculated: 170 hours / 28 points = 6.1 hours per point

Sprint 3:
- Committed: 25 points
- Completed: 22 points (1 developer on vacation)
- Actual hours: 112 hours
- Calculated: 112 hours / 22 points = 5.1 hours per point
```

**Adjust assumptions**:
- If completing fewer points than planned, lower velocity estimate
- If hours per point is higher than expected, adjust conversion
- Identify patterns (e.g., always overcommit)

---

### Phase 3: Calibration Phase (Sprints 4-6)

**Calculate actual velocity from historical data**:

```
Average velocity = Sum of completed points / Number of sprints

Example:
Sprint 1: 24 points
Sprint 2: 28 points
Sprint 3: 22 points
Sprint 4: 26 points
Sprint 5: 30 points
Sprint 6: 27 points

Total: 157 points over 6 sprints
Average: 157 / 6 = 26.2 points per sprint
```

**Calculate actual hours per point**:

```
Average hours per point = Total hours / Total points

Example:
Total hours: 960 hours (6 sprints × 160 team hours)
Total points: 157 points
Average: 960 / 157 = 6.1 hours per point
```

**Refine productive percentage**:

```
Productive % = (Avg velocity × Avg hours per point) / (Team size × Hours per sprint)

Example:
Productive % = (26 points × 6.1 hours per point) / (3 devs × 80 hours)
Productive % = 159 / 240 = 66%
```

---

### Phase 4: Steady State (Sprint 7+)

**Use historical velocity for planning**:
- Use average velocity from last 3-6 sprints
- Adjust for known changes (vacation, holidays, team changes)
- Re-calibrate quarterly or when significant changes occur

**Example Planning**:
```
Historical velocity: 26-30 points per sprint
Average: 28 points
Planning for Sprint 7: 26-28 points (conservative)
```

---

## Adjusting Velocity

### For Team Changes

**Adding a team member**:
- New member is not immediately productive
- Onboarding overhead reduces team velocity
- Expect 50% productivity from new member in first sprint
- Expect 75% productivity in second sprint
- Full productivity by third sprint

**Example**:
```
Original team: 3 devs, 28 points per sprint
Add 1 developer:

Sprint 1 (onboarding): 28 + (28/3 × 0.5) = 28 + 4.7 ≈ 33 points
Sprint 2 (ramping up): 28 + (28/3 × 0.75) = 28 + 7 = 35 points
Sprint 3+ (full speed): 28 + (28/3 × 1.0) = 28 + 9.3 ≈ 37 points
```

**Removing a team member**:
- Immediate reduction proportional to team size
- Knowledge transfer overhead may further reduce velocity

**Example**:
```
Original team: 4 devs, 32 points per sprint
Remove 1 developer:
New velocity: 32 × (3/4) = 24 points per sprint
```

---

### For Vacation or Holidays

**Single developer vacation**:
```
Adjusted velocity = Normal velocity × (Team available / Team size)

Example:
Normal: 3 devs, 28 points per sprint
1 dev on vacation for 1 week of 2-week sprint:
Adjusted: 28 × ((2 + 0.5) / 3) = 28 × 0.833 = 23 points
```

**Team-wide holiday**:
```
Adjusted velocity = Normal velocity × (Working days / Total sprint days)

Example:
Normal: 28 points per 2-week sprint
1-day holiday in sprint:
Adjusted: 28 × (9/10) = 25.2 ≈ 25 points
```

---

### For Technical Debt Sprints

**Dedicated tech debt sprint**:
- Expect 30-50% reduction in velocity
- Tech debt work is harder to estimate
- Benefits appear in future sprints

**Example**:
```
Normal velocity: 28 points
Tech debt sprint: 28 × 0.7 = 19.6 ≈ 20 points
```

---

### For New Technology

**Learning new stack or framework**:
- Expect 40-60% reduction in first sprint
- Gradual return to normal velocity over 3-6 sprints

**Example**:
```
Normal velocity: 28 points
Sprint 1 (learning): 28 × 0.5 = 14 points
Sprint 2: 28 × 0.6 = 16.8 ≈ 17 points
Sprint 3: 28 × 0.75 = 21 points
Sprint 4: 28 × 0.85 = 23.8 ≈ 24 points
Sprint 5+: Return to 28 points
```

---

## Using Velocity for Timeline Projections

### Calculate Sprints Required

```
Sprints required = Total story points / Average velocity

Example:
Total project: 150 story points
Team velocity: 28 points per sprint
Sprints needed: 150 / 28 = 5.36 ≈ 6 sprints
Timeline: 6 sprints × 2 weeks = 12 weeks
```

---

### Add Buffer for Uncertainty

**Buffer percentages by project type**:
- **Well-defined project**: +10-15% buffer
- **Moderate uncertainty**: +20-30% buffer
- **High uncertainty**: +30-50% buffer
- **New technology or domain**: +50-100% buffer

**Example with buffer**:
```
Baseline: 12 weeks (6 sprints)
Moderate uncertainty: +20% buffer
Total estimate: 12 weeks × 1.20 = 14.4 ≈ 15 weeks
```

---

### Account for Non-Sprint Time

**Add time for**:
- Project kickoff and discovery
- Sprint 0 (setup and architecture)
- UAT and stakeholder review between phases
- Final testing and launch prep
- Post-launch support period

**Example**:
```
Development: 12 weeks (6 sprints)
Sprint 0 (setup): 2 weeks
UAT per phase: 1 week × 3 phases = 3 weeks
Launch prep: 1 week
Total project: 12 + 2 + 3 + 1 = 18 weeks
```

---

## Common Velocity Mistakes

### Mistake 1: Not Adjusting for Team Changes
**Problem**: Use same velocity after adding/removing team members
**Solution**: Adjust velocity proportionally and account for onboarding time

### Mistake 2: Ignoring Vacation and Holidays
**Problem**: Plan sprints without considering PTO and holidays
**Solution**: Reduce velocity for sprints with reduced team capacity

### Mistake 3: Comparing Velocities Across Teams
**Problem**: Expect all teams to have similar velocity
**Solution**: Velocity is team-specific; don't compare across teams

### Mistake 4: Pushing to Increase Velocity
**Problem**: Pressure team to increase points completed
**Solution**: Velocity is a measurement, not a goal; focus on value delivered

### Mistake 5: Not Calibrating
**Problem**: Use theoretical velocity without actual data
**Solution**: Track actual velocity and adjust planning accordingly

### Mistake 6: Ignoring Sprint Context
**Problem**: Expect same velocity every sprint regardless of circumstances
**Solution**: Adjust for tech debt sprints, learning, and external factors

---

## Velocity in Different Contexts

### Kanban (No Fixed Sprints)

**Calculate throughput instead of velocity**:
```
Throughput = Story points completed / Time period (week/month)

Example:
Week 1: 15 points
Week 2: 18 points
Week 3: 14 points
Week 4: 16 points

Average throughput: (15 + 18 + 14 + 16) / 4 = 15.75 points per week
Monthly throughput: 15.75 × 4 = 63 points per month
```

### Fixed Scope Projects

**Calculate timeline from velocity**:
```
Timeline = Total points / Velocity

Example:
Fixed scope: 200 story points
Team velocity: 28 points per sprint
Timeline: 200 / 28 = 7.14 ≈ 8 sprints = 16 weeks
```

### Fixed Timeline Projects

**Calculate team size needed**:
```
Required velocity = Total points / Available sprints
Team size = (Required velocity × Avg hours per point) / (Hours per sprint × Productive %)

Example:
Fixed timeline: 3 months (6 sprints)
Total work: 180 story points
Required velocity: 180 / 6 = 30 points per sprint
Team needed: (30 × 6 hours) / (80 hours × 70%) = 180 / 56 = 3.2 ≈ 4 developers
```

---

## Best Practices

1. **Use Historical Data**: Actual velocity is the best predictor of future velocity
2. **Track Consistently**: Use same estimation approach across all sprints for accurate comparison
3. **Adjust for Context**: Account for team changes, holidays, and special circumstances
4. **Don't Game the System**: Velocity is a measurement, not a target
5. **Re-calibrate Regularly**: Review and adjust velocity calculations quarterly
6. **Focus on Trends**: Single sprint velocity can vary; look at averages over 3-6 sprints
7. **Communicate Clearly**: Help stakeholders understand what velocity means and doesn't mean
