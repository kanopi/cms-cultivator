# Fibonacci Scale for Story Point Estimation

Use the Fibonacci sequence for estimation to account for increasing uncertainty with larger tasks:

**1, 2, 3, 5, 8, 13, 21, 34+**

The gaps between numbers increase as tasks get larger, reflecting the reality that larger tasks have more uncertainty and are harder to estimate accurately.

---

## 1 Point - Trivial Change

**Time estimate:** <2 hours
**Complexity:** Minimal
**Risk:** Very low
**Uncertainty:** Almost none

### Characteristics
- Simple text or configuration change
- Minor styling adjustment
- Update existing content
- No testing complexity
- Clear implementation path

### Examples
- Update footer copyright year
- Change button color in CSS
- Update text on a page
- Add a simple link to navigation
- Fix typo in code or documentation

### When to use
- Task is completely straightforward
- No dependencies on other work
- No architecture decisions needed
- Can be done in one sitting

---

## 2 Points - Small Feature

**Time estimate:** 2-4 hours
**Complexity:** Low
**Risk:** Low
**Uncertainty:** Minimal

### Characteristics
- Small feature or component
- Basic bug fix
- Simple form field addition
- Limited testing requirements
- Well-understood implementation

### Examples
- Add form field validation (single field)
- Create basic UI component (button, card)
- Fix simple bug with known cause
- Add configuration option
- Write unit tests for simple function

### When to use
- Clear requirements
- Established patterns to follow
- Minimal integration complexity
- Straightforward testing

---

## 3 Points - Standard Feature

**Time estimate:** 4-8 hours (1 day)
**Complexity:** Moderate
**Risk:** Moderate
**Uncertainty:** Some

### Characteristics
- Standard feature with testing
- Moderate complexity
- Requires some design decisions
- Integration with existing systems
- Code review time included

### Examples
- Implement search filter with multiple criteria
- Create API endpoint with CRUD operations
- Add authentication to specific feature
- Create content type with 5-10 fields
- Write integration tests for module

### When to use
- Requires multiple files/components
- Some architectural decisions needed
- Testing across different scenarios required
- Standard complexity for the team

---

## 5 Points - Complex Feature

**Time estimate:** 12-24 hours (2-3 days)
**Complexity:** High
**Risk:** Moderate-High
**Uncertainty:** Moderate

### Characteristics
- Complex feature requiring multiple components
- Integration with external systems
- Performance considerations
- Significant testing requirements
- Multiple edge cases to handle

### Examples
- User authentication flow (registration + login + password reset)
- Payment gateway integration
- Complex data migration
- Multi-step form with conditional logic
- Real-time notification system (basic)

### When to use
- Multiple components must work together
- External dependencies involved
- Performance optimization required
- Significant edge cases to consider

---

## 8 Points - Major Feature

**Time estimate:** 24-40 hours (3-5 days)
**Complexity:** Very High
**Risk:** High
**Uncertainty:** High

### Characteristics
- Major feature requiring architecture decisions
- Significant research or learning
- Complex integrations
- Extensive testing requirements
- Multiple developers may need coordination

### Examples
- Real-time notifications system with WebSockets
- Complex reporting dashboard with multiple data sources
- Advanced search with facets and filters
- Multi-tenant architecture implementation
- Recipe-based CMS feature with shared field coordination

### When to use
- Requires significant architectural design
- New technology or approach for the team
- Complex state management
- Extensive test coverage needed
- High risk of unknown unknowns

---

## 13 Points - Epic

**Time estimate:** 40-80 hours (1-2 weeks)
**Complexity:** Epic-level
**Risk:** High
**Uncertainty:** Very High

### Characteristics
- Epic-level work that should typically be broken down
- Multiple related features
- Cross-cutting concerns
- Extensive coordination required
- Multiple phases of implementation

### Examples
- Complete user management system (auth + profiles + permissions + admin)
- Full e-commerce checkout flow (cart + payment + order + confirmation)
- Complete recipe-based content model (3-4 recipes with dependencies)
- Admin dashboard with analytics and reporting

### When to use
- Multiple user stories involved
- Should be broken into smaller stories for sprint planning
- Requires phased delivery
- Cross-team coordination needed

**Recommendation:** Break into 3-5 point stories before sprint planning

---

## 21 Points - Large Epic

**Time estimate:** 80-120 hours (2-3 weeks)
**Complexity:** Very large epic
**Risk:** Very High
**Uncertainty:** Extreme

### Characteristics
- Large epic requiring decomposition
- Multiple epics bundled together
- Significant unknowns
- Requires discovery and planning
- Should be split before implementation

### Examples
- Complete theme development from scratch
- Full content model implementation (5+ content types, 10+ recipes)
- Major platform migration
- Complete API redesign and implementation

### When to use
- Multiple related epics
- Requires extensive planning phase
- Unknown technical challenges
- Must be broken down into 8-13 point epics

**Requirement:** MUST be decomposed into smaller epics (8-13 points) before sprint planning

---

## 34+ Points - Too Large

**Time estimate:** 120+ hours (3+ weeks)
**Complexity:** Unestimatable
**Risk:** Extreme
**Uncertainty:** Cannot be estimated accurately

### Characteristics
- Too large to estimate accurately
- Requires extensive discovery
- Multiple phases of work
- Should be broken into multiple 21-point epics

### Action Required
Decompose into smaller epics immediately

### Examples
- Complete platform rebuild
- Entire application rewrite
- Large-scale migration project
- Multi-phase implementation program

---

## Choosing Between Adjacent Values

### 1 vs 2 Points
- **1 point**: No thinking required, completely mechanical
- **2 points**: Requires some thought, simple problem-solving

### 2 vs 3 Points
- **2 points**: Single component, minimal testing
- **3 points**: Multiple files, integration testing required

### 3 vs 5 Points
- **3 points**: Standard patterns, clear path
- **5 points**: Complex patterns, some unknowns

### 5 vs 8 Points
- **5 points**: Well-understood complexity
- **8 points**: Architectural decisions needed

### 8 vs 13 Points
- **8 points**: Single major feature
- **13 points**: Multiple related features (should break down)

### When in Doubt
- Choose the higher value
- Uncertainty suggests more points
- Can always adjust after learning more
