# Task Templates Overview

All four standard task templates with their use cases and required sections.

## Big Task/Epic Template

**Use when:**
- Multiple developers required
- Integration branch/multidev environment needed
- Complex scope with dependencies
- Phased delivery or epic-level coordination
- User says: "epic", "multiple devs", "integration branch", "complex feature"

**Required sections:**
- Background (why this work is needed)
- Requirements (bulleted list with checkboxes)
- Technical Approach (high-level strategy)
- Integration Branch/Multidev (environment details)
- Dependencies (what this depends on, what it blocks)
- Acceptance Criteria (specific, testable)
- Testing Plan (unit, integration, manual)
- Deployment Notes (migrations, cache, special considerations)
- Resources (Figma, docs, related tickets)

## Little Task Template

**Use when:**
- Single developer can complete
- Clear, focused scope
- Estimated < 8 hours
- No complex dependencies
- User says: "quick fix", "simple change", "add button", "update text"

**Required sections:**
- Task Description (clear, concise)
- Acceptance Criteria (checkboxes)
- Testing Steps (numbered)
- Validation (test URL, expected result)
- Files to Change (list of file paths)
- Deployment Notes (cache clearing, etc.)

## QA Handoff Template

**Use when:**
- Work is complete and ready for QA team
- Testing instructions needed
- Specific validation scenarios required
- User says: "ready for QA", "qa handoff", "needs testing", "validate this"

**Required sections:**
- What Was Built (summary)
- Test Environment (URL, credentials, browsers)
- Testing Instructions (test cases with steps and expected results)
- Regression Testing (check related features)
- Known Issues (limitations to be aware of)
- Success Criteria (all must pass)
- Notes for QA (additional context)

## Bug Report Template

**Use when:**
- Reporting a defect
- Something is broken or not working as expected
- Need reliable reproduction steps
- User says: "bug", "error", "broken", "crash", "not working"

**Required sections:**
- Bug Description (clear problem statement)
- Steps to Reproduce (reliable, numbered)
- Expected Behavior (what should happen)
- Actual Behavior (what actually happens)
- Environment (browser, OS, device, URL, user role)
- Screenshots/Video (visual evidence)
- Console Errors (JavaScript errors)
- Frequency (every time / intermittent)
- Impact (critical / high / medium / low)
- Workaround (if any exists)
- Additional Context (anything else relevant)
