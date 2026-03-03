# Task Templates

This document contains all four task templates used by the Teamwork Task Creator skill. Each template is optimized for specific scenarios and includes required and optional sections.

## 1. Big Task/Epic Template

**Use when:**
- Multiple developers required
- Integration branch/multidev environment needed
- Complex scope with dependencies
- Phased delivery or epic-level coordination

**Required Sections:**

```markdown
## Background
[Why this work is needed, business context, user impact]

## Requirements
- [ ] Requirement 1
- [ ] Requirement 2
- [ ] Requirement 3

## Technical Approach
[High-level technical strategy, architecture decisions]

## Integration Branch/Multidev
- Branch name: `integration/feature-name`
- Environment URL: [will be created]
- Merge strategy: [describe]

## Dependencies
- Depends on: [link related tasks]
- Blocks: [what this blocks]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Testing Plan
- Unit tests: [scope]
- Integration tests: [scope]
- Manual testing: [specific scenarios]

## Deployment Notes
[Special deployment considerations, database migrations, cache clearing]

## Resources
- Design: [Figma link]
- Documentation: [link]
- Related tickets: [links]
```

**Optional Sections:**
- **Performance Considerations**: If performance-critical
- **Security Notes**: If security-sensitive
- **Browser/Device Support**: If cross-browser issues expected

## 2. Little Task Template

**Use when:**
- Single developer can complete
- Clear, focused scope
- Estimated < 8 hours
- No complex dependencies

**Required Sections:**

```markdown
## Task Description
[Clear, concise description of what needs to be done]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Testing Steps
1. Step 1
2. Step 2
3. Step 3

## Validation
- Test URL: [specific page]
- Expected result: [what success looks like]

## Files to Change
- `path/to/file1.php`
- `path/to/file2.js`
- (add more as discovered during implementation)

## Deployment Notes
[Any special deployment steps, cache clearing, etc.]
```

**Optional Sections:**
- **Design Reference**: If design mockup available
- **Related Tasks**: If part of larger feature

## 3. QA Handoff Template

**Use when:**
- Work is complete and ready for QA team
- Testing instructions needed
- Specific validation scenarios required

**Required Sections:**

```markdown
## What Was Built
[Summary of changes, features added, bugs fixed]

## Test Environment
- URL: [staging/multidev URL]
- Credentials: [if needed]
- Browser requirements: [Chrome, Firefox, Safari, etc.]

## Testing Instructions

### Test Case 1: [Name]
**Steps:**
1. Step 1
2. Step 2
3. Step 3

**Expected Result:**
[What should happen]

### Test Case 2: [Name]
**Steps:**
1. Step 1
2. Step 2
3. Step 3

**Expected Result:**
[What should happen]

## Regression Testing
- [ ] Check [related feature 1] still works
- [ ] Check [related feature 2] still works
- [ ] Check [related feature 3] still works

## Known Issues
- [Any known limitations or issues to be aware of]

## Success Criteria
- [ ] All test cases pass
- [ ] No console errors
- [ ] Responsive on mobile/tablet/desktop
- [ ] Accessible (keyboard navigation, screen readers)

## Notes for QA
[Any additional context QA should know]
```

**Optional Sections:**
- **Performance Considerations**: If performance testing needed
- **Browser/Device Matrix**: If specific browser testing required

## 4. Bug Report Template

**Use when:**
- Reporting a defect
- Something is broken or not working as expected
- Need reliable reproduction steps

**Required Sections:**

```markdown
## Bug Description
[Clear description of the problem]

## Steps to Reproduce
**CRITICAL: These must be reliable. QA/Developers must be able to reproduce consistently.**

1. Go to [URL]
2. Click [element]
3. Enter [data]
4. Click [submit]
5. Observe [error]

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- Browser: [Chrome 120, Firefox 121, Safari 17, etc.]
- OS: [Windows 11, macOS 14, iOS 17, etc.]
- Device: [Desktop, iPhone 14, Samsung S23, etc.]
- URL: [exact URL where bug occurs]
- User role: [logged in/out, admin/editor/subscriber]

## Screenshots/Video
[Attach screenshots or screen recording]

## Console Errors
[Any JavaScript errors from browser console]

## Frequency
- [ ] Happens every time
- [ ] Happens intermittently (~X% of the time)
- [ ] Happened once

## Impact
- [ ] Critical - Blocks core functionality
- [ ] High - Impacts important feature
- [ ] Medium - Usability issue
- [ ] Low - Minor cosmetic issue

## Workaround
[If any workaround exists, describe it]

## Additional Context
[Any other relevant information]
```

**Optional Sections:**
- **Network Requests**: If API/network related
- **Database State**: If data-specific issue
