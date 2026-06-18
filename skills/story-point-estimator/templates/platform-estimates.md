# Platform-Specific Estimation Patterns

Different platforms have unique characteristics that affect estimation. This guide provides platform-specific patterns and adjustments.

---

## Drupal (Recipe-Based Projects)

### Recipe Creation Tasks

**Recipe Configuration (2-3 points per recipe)**:
- Content type creation with 5-10 fields: 2 points
- Content type creation with 10+ fields: 3 points
- Taxonomy vocabulary creation: 1 point
- View creation (simple listing): 2 points
- View creation (complex filters/relationships): 3 points
- Image style creation: 1 point
- Pathauto pattern creation: 1 point
- Metatag template creation: 1 point

**Configuration Export (1 point per recipe)**:
- Export configuration to recipe directory
- Verify clean export
- Test configuration installation

**Recipe.yml Creation (1 point per recipe)**:
- Define recipe metadata
- List configuration dependencies
- Document installation instructions

**Total per simple recipe**: 4-5 points
**Total per complex recipe**: 6-8 points

---

### Shared Field Storage

Shared field storage requires careful coordination across recipes to prevent installation conflicts.

**Simple Shared Field (1 point)**:
- Field used by 1-2 content types
- No complex configuration
- Clear ownership

**Example**:
- `field_phone`: Phone number field used by Person and Location content types
- Created in: `saplings_person` recipe
- Reused in: `saplings_location` recipe
- Estimate: 1 point for coordination

**Moderate Shared Field (2 points)**:
- Field used by 3-4 content types
- Some configuration variations
- Requires dependency planning

**Example**:
- `field_services`: Entity reference to Services taxonomy
- Created in: `saplings_services` recipe
- Reused in: Person, Location, Event content types
- Requires: Dependency documentation, installation order planning
- Estimate: 2 points for coordination

**Complex Shared Field (3-5 points)**:
- Field used by 5+ content types
- Complex configuration (widget/formatter variations)
- Intricate dependency chain
- May require refactoring

**Example**:
- `field_location`: Complex entity reference with custom widget
- Created in: Base recipe
- Reused in: 6+ content types across multiple recipes
- Requires: Architecture decisions, testing across all uses
- Estimate: 4 points for coordination and testing

---

### Recipe Dependencies

**Linear Dependencies (standard)**:
```
Base Recipe → Feature Recipe A → Feature Recipe B
```
- Clear dependency chain
- No special estimation adjustment
- Document in recipe.yml

**Parallel Dependencies (add 1 point per recipe)**:
```
Base Recipe → Feature A
            → Feature B
            → Feature C
```
- Multiple recipes depend on same base
- Testing coordination required
- Add 1 point for integration testing

**Circular Dependencies (add 3-5 points to resolve)**:
```
Recipe A ↔ Recipe B (should not exist)
```
- Architecture problem
- Requires refactoring
- Add 3-5 points to resolve dependency conflict

---

### Testing Recipes

**Clean Environment Testing (1 point per recipe)**:
- Install on fresh Drupal site
- Verify all configuration imports
- Test content creation
- Verify no errors or warnings

**Shared Field Testing (1 point)**:
- Test installation order
- Verify field reuse works correctly
- Test across all content types using field

**Integration Testing (1-2 points)**:
- Install all related recipes in sequence
- Test cross-recipe functionality
- Verify views, relationships work
- Test demo content installation

**Example Total Testing for 5-Recipe System**:
```
Clean testing: 5 recipes × 1 point = 5 points
Shared field testing: 3 shared fields × 1 point = 3 points
Integration testing: 2 points
Total testing: 10 points
```

---

### Documentation

**Recipe README (1 point per recipe)**:
- Installation instructions
- Configuration overview
- Dependencies listed
- Example content usage

**Dependency Diagram (1 point)**:
- Visual representation of recipe dependencies
- Shared field matrix
- Installation order documentation

**Demo Content Creation (1-2 points per recipe)**:
- Create example content for each content type
- Populate taxonomies with sample terms
- Demonstrate all major features
- Export as default content or migration

**Example Recipe System (5 recipes)**:
```
Base recipe: 5 points
Feature recipe 1: 6 points
Feature recipe 2: 6 points
Feature recipe 3: 5 points
Feature recipe 4: 7 points

Shared field coordination: 4 points
Testing: 10 points
Documentation: 8 points

Total: 51 points
```

---

## WordPress (Block-Based Projects)

### Block Creation

**Simple Block (3-5 points)**:
- Static block with minimal configuration
- No dynamic data
- Simple controls
- Basic styling

**Components**:
- Block registration (block.json): 1 point
- JSX template: 1 point
- Basic styles: 1 point
- Block controls: 1 point
- Testing: 1 point

**Example**: Call-to-action block with title, text, button
**Total**: 3-4 points

---

**Standard Block (5-8 points)**:
- Dynamic content loading
- Multiple configuration options
- Responsive styling
- Editor and frontend views

**Components**:
- Block registration with attributes: 2 points
- Dynamic rendering (PHP): 2 points
- Block controls (InspectorControls): 2 points
- Responsive styles: 2 points
- Testing: 2 points

**Example**: Post grid block with category filter, layout options
**Total**: 6-8 points

---

**Complex Block (8-13 points)**:
- Advanced functionality
- External API integration
- Complex state management
- Extensive customization options

**Components**:
- Block registration and architecture: 3 points
- API integration: 3 points
- Complex controls and state: 3 points
- Advanced styling and responsive: 2 points
- Comprehensive testing: 2 points

**Example**: Dynamic map block with location search, custom markers, info windows
**Total**: 10-13 points

---

### Block Patterns

**Simple Pattern (1 point)**:
- Combination of core blocks
- Minimal custom styling
- Straightforward layout

**Example**: Hero section with heading, paragraph, button

---

**Complex Pattern (2-3 points)**:
- Multiple nested blocks
- Custom block integration
- Responsive considerations
- Multiple variations

**Example**: Complete homepage layout with sections

---

### Block Variations

**Single Variation (1 point per variation)**:
- Predefined block configuration
- Different default attributes
- Specific use case

**Example**: Button block variations (primary, secondary, outline)

---

### Theme Integration

**Block Styles Registration (1-2 points)**:
- Register custom block styles
- Add theme-specific options
- Integrate with design system

**Theme.json Configuration (2-3 points)**:
- Define color palettes
- Configure typography scale
- Set spacing units
- Configure layout settings

**Example WordPress Block Theme**:
```
Base theme setup: 5 points
Theme.json configuration: 3 points
Custom block (CTA): 4 points
Custom block (Team member): 5 points
Custom block (Testimonial): 4 points
Block patterns (3 patterns): 3 points
Block styles registration: 2 points
Testing and documentation: 5 points

Total: 31 points
```

---

## General Web Development

### Frontend Components

**Simple Component (2-3 points)**:
- Single responsibility
- Minimal state
- Basic styling
- Unit tests

**Examples**:
- Button component
- Card component
- Form input

---

**Standard Component (3-5 points)**:
- Multiple props/configuration
- Local state management
- Responsive styling
- Integration tests

**Examples**:
- Modal component
- Dropdown menu
- Data table (basic)

---

**Complex Component (5-8 points)**:
- Complex state management
- Multiple sub-components
- Advanced interactions
- Accessibility requirements
- Comprehensive tests

**Examples**:
- Autocomplete search
- Multi-step form
- Data table (advanced filtering/sorting)

---

### API Development

**Simple Endpoint (2-3 points)**:
- Single resource CRUD
- Basic validation
- Simple response format
- Unit tests

**Example**: GET /api/users, POST /api/users

---

**Standard Endpoint (3-5 points)**:
- Multiple operations
- Request validation
- Error handling
- Authentication/authorization
- Integration tests

**Example**: Complete REST resource with filtering, pagination

---

**Complex Endpoint (5-8 points)**:
- Complex business logic
- Multiple data sources
- Advanced querying
- Caching strategy
- Performance optimization
- Comprehensive tests

**Example**: Search endpoint with faceted filtering, aggregations

---

### Database Work

**Simple Schema (2-3 points)**:
- Single table/collection
- Basic relationships
- Standard fields
- Migrations

**Example**: Users table with basic profile fields

---

**Standard Schema (3-5 points)**:
- Multiple tables/collections
- Several relationships
- Indexes and constraints
- Data migrations

**Example**: Blog system (posts, categories, tags, authors)

---

**Complex Schema (5-8 points)**:
- Many tables/collections
- Complex relationships
- Performance optimization
- Data integrity constraints
- Comprehensive migrations

**Example**: E-commerce product catalog with variants, inventory, pricing rules

---

## Platform Adjustment Factors

### Add Points When

**Legacy Codebase (+1-2 points)**:
- Technical debt
- Poor documentation
- Outdated dependencies
- Complex workarounds needed

**New Technology (+1-3 points)**:
- Team learning curve
- Unknown patterns
- Trial and error
- Documentation gaps

**Complex Integration (+1-3 points)**:
- External APIs
- Third-party services
- Multiple system coordination
- Data synchronization

**High Compliance Requirements (+1-2 points)**:
- WCAG AA accessibility
- GDPR compliance
- Security certifications
- Audit requirements

**Performance Optimization (+1-2 points)**:
- Page speed requirements
- Large dataset handling
- Caching strategy
- Load testing

---

### Reduce Points When

**Existing Patterns (-1 point)**:
- Similar work done before
- Established patterns to follow
- Copy/adapt existing code

**Simple Requirements (-1 point)**:
- Minimal edge cases
- Clear acceptance criteria
- No integrations
- Straightforward testing

**Greenfield Project (-1 point)**:
- No technical debt
- Modern stack
- Clean architecture
- Good documentation

---

## Estimation Checklist by Platform

### Drupal Recipe Project

- [ ] Configuration entities estimated per recipe
- [ ] Configuration export time included (1 point per recipe)
- [ ] Recipe.yml creation included (1 point per recipe)
- [ ] Shared field coordination estimated
- [ ] Dependency planning included
- [ ] Clean environment testing (1 point per recipe)
- [ ] Integration testing (1-2 points)
- [ ] Documentation (README, diagrams)
- [ ] Demo content creation

---

### WordPress Block Project

- [ ] Block registration and metadata (block.json)
- [ ] Block attributes and serialization
- [ ] Editor controls and inspector
- [ ] Dynamic rendering if needed (render.php)
- [ ] Responsive styling
- [ ] Block patterns included if needed
- [ ] Block variations included if needed
- [ ] Theme.json configuration
- [ ] Testing and documentation

---

### General Web Application

- [ ] Frontend components estimated
- [ ] API endpoints estimated
- [ ] Database schema and migrations
- [ ] Authentication/authorization
- [ ] Testing (unit, integration, e2e)
- [ ] Documentation
- [ ] Deployment configuration
- [ ] Performance considerations

---

## Platform-Specific Examples

### Example 1: Drupal Recipe System (Person Directory)

**Requirements**:
- Person content type with 12 fields
- Specialties taxonomy
- Languages taxonomy
- Provider directory view with filters
- Pathauto patterns
- Metatag templates
- Person headshot image style
- Demo content (10 sample people)

**Estimation**:
```
Content type creation: 3 points (12 fields)
Taxonomies (2): 2 points (1 each)
View creation: 3 points (complex filters)
Pathauto pattern: 1 point
Metatag template: 1 point
Image style: 1 point
Recipe configuration export: 1 point
Recipe.yml creation: 1 point
Clean environment testing: 1 point
Demo content creation: 2 points
Documentation: 1 point

Total: 17 points (approx. 100 hours, 2.5 weeks)
```

---

### Example 2: WordPress Custom Block (Team Member Grid)

**Requirements**:
- Display team members in grid layout
- Filterable by department
- Multiple layout options (2, 3, 4 columns)
- Responsive design
- Hover effects
- Link to individual team member pages

**Estimation**:
```
Block registration (block.json): 1 point
Block attributes (layout, department filter): 2 points
Block controls (InspectorControls): 2 points
JSX template with grid logic: 2 points
Dynamic data loading: 2 points
Responsive styles: 2 points
Testing: 1 point
Documentation: 1 point

Total: 13 points (approx. 65 hours, 1.5-2 weeks)
```

---

### Example 3: General Web App (User Authentication System)

**Requirements**:
- User registration
- Email verification
- Login with JWT
- Password reset
- User profile page
- Change password functionality

**Estimation**:
```
Database schema (users table): 2 points
Registration API endpoint: 3 points
Email verification flow: 3 points
Login API endpoint: 2 points
JWT token handling: 2 points
Password reset flow: 3 points
User profile API: 2 points
Change password API: 2 points
Frontend forms (4 forms): 8 points
Frontend state management: 3 points
Testing: 5 points
Documentation: 2 points

Total: 37 points (approx. 220 hours, 5.5 weeks)
```

---

## Best Practices

1. **Know Your Platform**: Understand platform-specific patterns and conventions
2. **Account for Coordination**: Recipe dependencies and shared fields add complexity
3. **Include Testing**: Platform-specific testing (recipe installation, block registration)
4. **Document Platform Decisions**: Explain platform-specific architecture choices
5. **Use Platform Experience**: Adjust estimates based on team's platform familiarity
6. **Consider Platform Constraints**: Some platforms have specific limitations or requirements
7. **Leverage Platform Tools**: Use recipe system, block patterns, etc. efficiently
