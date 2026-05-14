---
name: frd-generator
description: Generate comprehensive FRD markdown structure with all required sections. Provides section templates, numbering conventions (FR-XXX, TR-XXX, US-XXX), platform-specific additions, and output format guidelines. Invoke when requirements are gathered and ready to structure into FRD document.
---

# FRD Generator Skill

Generate the complete FRD markdown structure with all required sections, numbering conventions, and platform-specific elements.

## Philosophy

A well-structured FRD serves both as client communication and developer specification.

### Core Beliefs

1. **Structure Enables Clarity** - Consistent sections help readers find information
2. **Traceability Through Numbers** - Requirements need unique identifiers (FR-001, TR-002)
3. **Client and Developer Dual Purpose** - Balance readability with technical precision
4. **Platform Context Matters** - Drupal recipes need different structure than WordPress blocks

### Why FRD Structure Matters

- **Organized Information** - Clear sections prevent information overload
- **Requirement Traceability** - Numbered requirements link to tickets and tests
- **Professional Quality** - Consistent format signals thoroughness
- **Developer Reference** - Technical sections provide implementation guidance

## When to Use This Skill

Activate this skill when:
- Requirements gathering is complete
- Platform and architecture are identified
- Ready to generate the FRD markdown document
- Need to structure requirements into standardized format
- Agent needs to apply FRD templates and numbering

## FRD Document Structure

### Core Sections (All Projects)

The FRD follows this 10-section structure:

#### 1. Executive Summary
**Purpose**: High-level overview for stakeholders

**Required Content**:
- Project vision and business objectives
- High-level scope and key deliverables
- Expected business value and ROI
- Target launch date or milestone
- Success criteria summary

**Numbering**: None (narrative section)

#### 2. Technical Requirements
**Purpose**: Platform, architecture, and technology decisions

**Required Content**:
- Platform & architecture overview (with specific versions)
- Technology stack with justifications
- Architecture patterns (recipe-based, microservices, monolithic)
- Module/package dependencies
- Third-party integrations and APIs
- Performance requirements and SLAs
- Security requirements and data protection
- Development environment setup

**Numbering**: TR-001, TR-002, TR-003...

**Note**: Place BEFORE Functional Requirements for technical projects

#### 3. Functional Requirements
**Purpose**: User stories, features, and business logic

**Required Content**:
- User stories with acceptance criteria
- Feature specifications with priority levels (Must Have/Should Have/Nice to Have)
- User roles and permissions matrix
- Business logic and workflow descriptions

**Numbering**:
- FR-001, FR-002, FR-003... (functional requirements)
- US-001, US-002, US-003... (user stories)

**Format for Recipe-Based Projects**:
```markdown
## FR-001: saplings_person Recipe [MUST HAVE]

**Purpose**: Provider/staff directory with biographical information

**Recipe Structure**:
- Content Type: Person
- Taxonomies: Specialties, Languages
- Fields: field_phone (SHARED), field_services (SHARED)
- Views: Provider Directory with filters
- Pathauto: /providers/[node:title]
- Image Style: person_headshot (300×300)

**Story Points**: 8 points
**Priority**: Must Have
**Dependencies**: drupal_cms_starter (base fields)
```

#### 4. User Interface Requirements
**Purpose**: Design, UX, and accessibility specifications

**Required Content**:
- Key user flows and wireframe descriptions
- Responsive design requirements (breakpoints)
- Accessibility standards (WCAG compliance level)
- Branding and design system considerations
- Theme/styling approach

**Numbering**: UI-001, UI-002, UI-003...

#### 5. Data Requirements
**Purpose**: Data models, storage, and migration

**Required Content**:
- Data models and entity relationships
- Data validation rules
- Storage and backup requirements
- Data migration needs (if applicable)
- Demo/sample data requirements

**Numbering**: DR-001, DR-002, DR-003...

**Platform-Specific**:
- **Drupal**: Include field storage matrix for shared fields
- **WordPress**: Include custom post type and taxonomy structure

#### 6. Non-Functional Requirements
**Purpose**: Performance, scalability, compatibility

**Required Content**:
- Performance benchmarks (specific tools: Lighthouse, Core Web Vitals)
- Scalability considerations
- Browser/device compatibility matrix
- Availability and uptime requirements
- SEO requirements

**Numbering**: NFR-001, NFR-002, NFR-003...

#### 7. Implementation Plan
**Purpose**: Phased delivery with milestones and dependencies

**Required Content**:
- Phase breakdown with objectives
- Epic and story structure
- Dependencies and critical path
- Risk assessment matrix
- Team velocity assumptions
- Timeline with sprint projections

**Numbering**: PHASE-1, PHASE-2, PHASE-3...

**Format**:
```markdown
## Phase 1: Foundation [21 points, Sprint 1]

**Objective**: Establish development environment and base architecture

**Epics**:
- EPIC-001: Development Environment Setup [8 points]
- EPIC-002: Base Theme Configuration [5 points]
- EPIC-003: Content Model Foundation [8 points]

**Dependencies**: None (critical path start)
**Risks**: Environment compatibility issues
```

#### 8. Testing Requirements
**Purpose**: Test scenarios, benchmarks, and UAT process

**Required Content**:
- Functional test scenarios by feature
- Performance testing benchmarks
- Accessibility testing requirements (WCAG compliance)
- Security testing requirements
- Cross-browser/device testing matrix
- UAT process and timeline

**Numbering**: TS-001, TS-002, TS-003... (test scenarios)

#### 9. Risk Assessment
**Purpose**: Identify and mitigate technical and project risks

**Required Content**:
- Technical risks (integrations, dependencies, performance)
- Project risks (scope, resources, timeline)
- Risk matrix with likelihood and impact
- Mitigation strategies for each risk
- Contingency plans
- Early warning signs

**Numbering**: RISK-001, RISK-002, RISK-003...

**Format**: See `templates/risk-framework.md`

#### 10. Success Criteria
**Purpose**: Define measurable outcomes

**Required Content**:
- Functional success metrics (features delivered, tests passed)
- Technical success metrics (performance, accessibility, security)
- Business success metrics (timeline, budget, stakeholder satisfaction)

**Numbering**: None (metric-based section)

### Sprint Planning Section (Appendix)

Add at end of FRD:

**Required Content**:
1. Total story points - Sum of all work
2. Suggested sprint breakdown - Based on team velocity
3. Critical path identification - Dependencies and blockers
4. Next steps for stakeholder review
5. Questions requiring client input
6. Recommended technical spikes or POCs
7. Suggested project kickoff activities

## Numbering Conventions

### Requirement Prefixes

Use these prefixes for all requirements:

- **FR-XXX** - Functional Requirements (features, user stories)
- **TR-XXX** - Technical Requirements (platform, architecture)
- **US-XXX** - User Stories (specific user-facing scenarios)
- **UI-XXX** - User Interface Requirements (design, UX)
- **DR-XXX** - Data Requirements (models, storage)
- **NFR-XXX** - Non-Functional Requirements (performance, security)
- **TS-XXX** - Test Scenarios (specific test cases)
- **RISK-XXX** - Risk Items (identified risks)
- **PHASE-X** - Implementation Phases (1, 2, 3...)
- **EPIC-XXX** - Epic Work Items (large features)

### Numbering Rules

1. **Zero-padded**: Use 3 digits (001, 002, ..., 999)
2. **Sequential**: Number within each type sequentially
3. **No Gaps**: Don't skip numbers (enables traceability)
4. **Cross-Reference**: Link related requirements (e.g., "See FR-001")

**Example**:
```markdown
## Technical Requirements

### TR-001: Drupal 10.2 LTS Platform

The project will use Drupal 10.2 LTS (Long-Term Support) with Composer-based architecture.

**Justification**: LTS version provides stability and security updates through November 2026.

**Dependencies**: PHP 8.1+, MySQL 8.0+, Composer 2.x

**Related Requirements**: FR-001, FR-002 (content types depend on platform)

### TR-002: Recipe-Based Architecture

Use recipe-based architecture for modular, reusable configuration management.

**Structure**: See FR-001 through FR-008 for individual recipe specifications.

**Related Requirements**: DR-001 (shared field storage)
```

## Platform-Specific Section Additions

### Drupal Recipe-Based Projects

Add these subsections when recipe architecture is detected:

**In Technical Requirements (TR-XXX)**:
- Recipe architecture overview
- Recipe naming conventions (`[project]_[feature]`)
- Master recipe structure
- Base recipe dependencies (Drupal CMS, Saplings)

**In Functional Requirements (FR-XXX)**:
- Recipe structure for each feature
- Shared field storage documentation
- Recipe dependencies and installation order

**In Data Requirements (DR-XXX)**:
- Shared field storage matrix (which recipes create/use each field)
- Field storage installation order
- Demo content strategy (Default Content module)

**Appendices**:
- Recipe dependency diagram
- Shared field storage reference table
- Recipe installation order flowchart

### WordPress Block Theme Projects

For WordPress block theme projects, add these subsections:

**In Technical Requirements (TR-XXX)**:
- Block/pattern inventory (custom blocks + reusable patterns)
- `theme.json` configuration specifications (palette, typography, layout)
- Plugin dependency justification (each plugin's purpose and alternatives)

**In Non-Functional Requirements (NFR-XXX)**:
- Core Web Vitals performance budget (LCP/INP/CLS targets)
- Block editor performance considerations

**Appendices**:
- Block/pattern catalog with screenshots
- `theme.json` reference

## Output Format Guidelines

### Document Formatting

**Headers**:
- Use `#` for document title
- Use `##` for major sections
- Use `###` for requirement items
- Use `####` for subsections within requirements

**Lists**:
- Use `-` for unordered lists
- Use `1.` for ordered lists (sequential steps)
- Indent sublists with 2 spaces

**Emphasis**:
- Use `**bold**` for labels (Purpose, Priority, Story Points)
- Use `_italic_` for notes and clarifications
- Use `>` blockquotes for user stories

**Code**:
- Use `` `inline code` `` for commands, paths, field names
- Use triple backticks for code blocks with language identifier

**Tables**:
- Use markdown tables for matrices (permissions, risks, dependencies)
- Include header row with alignment
- Keep columns readable

### Writing Style

**Client-Facing Sections** (Executive Summary, Functional Requirements, UI Requirements):
- Clear, jargon-free language
- Business value emphasized
- "You" and "your users" language
- Benefits over features

**Developer-Facing Sections** (Technical Requirements, Data Requirements, Implementation Plan):
- Technical precision
- Specific versions and tools
- Architecture decisions justified
- Implementation guidance included

**Shared Sections** (Non-Functional Requirements, Testing, Success Criteria):
- Balance technical and business language
- Measurable criteria
- Specific benchmarks
- Testable outcomes

### Cross-Referencing

Link related requirements:
- "See FR-001 for feature details"
- "Depends on TR-002 (recipe architecture)"
- "Relates to RISK-003 (integration complexity)"
- "Tested in TS-005"

### Visual Aids

Include placeholders for diagrams:
- Architecture diagrams
- User flow diagrams
- Data relationship diagrams
- Recipe dependency flowcharts
- Risk matrix tables

**Format**:
```markdown
**[Diagram: User Authentication Flow]**
_Placeholder for diagram showing registration → verification → login flow_
```

## FRD Generation Workflow

### Step 1: Initialize Document

Start with frontmatter and title:
```markdown
---
title: Functional Requirements Document
project: [Project Name]
version: 1.0
date: [YYYY-MM-DD]
author: [Author Name]
status: Draft
---

# Functional Requirements Document: [Project Name]

**Version**: 1.0
**Date**: [Current Date]
**Status**: Draft
```

### Step 2: Generate Each Section

Follow the 10-section structure:
1. Executive Summary (narrative)
2. Technical Requirements (TR-XXX)
3. Functional Requirements (FR-XXX, US-XXX)
4. User Interface Requirements (UI-XXX)
5. Data Requirements (DR-XXX)
6. Non-Functional Requirements (NFR-XXX)
7. Implementation Plan (PHASE-X, EPIC-XXX)
8. Testing Requirements (TS-XXX)
9. Risk Assessment (RISK-XXX)
10. Success Criteria (metrics)

### Step 3: Add Platform-Specific Content

**If Drupal + Recipe-Based**:
- Add recipe structure to FR-XXX items
- Include shared field storage matrix in DR section
- Add recipe dependency diagram to appendix

**If WordPress + Block Theme** (future):
- Add block/pattern inventory
- Include theme.json specs

### Step 4: Add Appendices

Include as needed:
- Glossary of terms
- Acronym definitions
- Dependency diagrams
- Field storage matrices
- Sprint planning details

### Step 5: Number Requirements

Ensure all requirements have proper prefixes:
- Count each type separately
- Use zero-padded 3-digit numbers
- Verify no gaps in sequence

### Step 6: Cross-Reference

Add links between related requirements:
- Link dependencies
- Reference related risks
- Connect requirements to test scenarios

## Templates

Detailed templates are available for reference:

- **[FRD Structure Template](templates/frd-structure.md)** - Complete section-by-section template
- **[Risk Framework Template](templates/risk-framework.md)** - Risk assessment format and examples

Use these templates as starting points, customizing for the specific project needs.

## Companion Skills

This skill works alongside two other planning skills in CMS Cultivator:

- **story-point-estimator** — Provide Fibonacci-based estimates with hour conversions before structuring the FRD.
- **csv-exporter** — After the FRD is complete, convert the requirements into a Teamwork-ready CSV backlog.

Typical flow: gather requirements → estimate with `story-point-estimator` → structure with `frd-generator` → export with `csv-exporter`.

## Example Output Structure

See `templates/frd-structure.md` for a complete example with all sections populated.

Quick preview of structure:

```markdown
# Functional Requirements Document: Healthcare Provider Directory

## Executive Summary
[Narrative overview...]

## Technical Requirements

### TR-001: Drupal 10.2 LTS Platform
[Platform details...]

### TR-002: Recipe-Based Architecture
[Architecture details...]

## Functional Requirements

### FR-001: saplings_person Recipe [MUST HAVE]
[Recipe structure...]

### US-001: View Provider Directory
> As a site visitor, I need to search for healthcare providers so that I can find appropriate care.

[User story details...]

## [Continue with remaining sections...]

## Appendix A: Risk Assessment Matrix
[Risk table...]

## Appendix B: Sprint Planning
[Sprint breakdown...]
```

## Best Practices

1. **Consistent Structure** - Always use the 10-section format
2. **Complete Numbering** - Never skip requirement numbers
3. **Platform Context** - Add platform-specific sections when appropriate
4. **Cross-Reference** - Link related requirements throughout
5. **Balance Audiences** - Write for both clients and developers
6. **Visual Aids** - Include diagram placeholders where helpful
7. **Measurable Criteria** - Make success criteria testable
8. **Traceability** - Number requirements for ticket linking

## Resources

- [FRD Structure Template](templates/frd-structure.md)
- [Risk Framework Template](templates/risk-framework.md)
- [IEEE 830-1998 SRS Standard](https://en.wikipedia.org/wiki/Software_requirements_specification)
