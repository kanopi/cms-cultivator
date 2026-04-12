# Task Examples: Good vs. Bad

This document provides concrete examples of well-written tasks versus poorly-written tasks, with explanations of what makes them effective or ineffective.

## Bug Report Examples

### ❌ Bad Task Example

```
Title: Fix the form

Description:
The form is broken. Please fix it.
```

**Problems:**
- No specific form identified
- No reproduction steps
- No expected/actual behavior
- No environment information
- No acceptance criteria

### ✅ Good Task Example (Bug Report)

```
Title: Contact form submit fails with 500 error on production

## Bug Description
The contact form on `/contact` page returns a 500 error when submitted with valid data. Form worked on staging but fails on production.

## Steps to Reproduce
1. Go to https://example.com/contact
2. Fill in all fields:
   - Name: "Test User"
   - Email: "test@example.com"
   - Message: "Test message"
3. Click "Submit"
4. Observe 500 error page

## Expected Behavior
Form submits successfully, user sees confirmation message, email sent to admin@example.com

## Actual Behavior
500 error page displays, no email sent

## Environment
- Browser: Chrome 120
- OS: macOS 14
- URL: https://example.com/contact
- User role: Anonymous (not logged in)

## Console Errors
```
POST /contact/submit 500 Internal Server Error
```

## Frequency
- [x] Happens every time

## Impact
- [x] High - Contact form is primary lead generation tool

## Additional Context
- Works correctly on staging: https://staging.example.com/contact
- Deployed to production yesterday (2024-01-15)
- No code changes to contact form in that deploy
```

**Why it's good:**
- Specific URL and form identified
- Reliable reproduction steps (5 steps)
- Clear expected vs. actual behavior
- Complete environment info
- Console errors included
- Impact clearly stated
- Additional context about staging vs. production

## Feature Task Examples

### ❌ Bad Task Example (Feature)

```
Title: Add search

Description:
We need search functionality.
```

**Problems:**
- No requirements
- No scope definition
- No acceptance criteria
- No technical approach
- No testing plan

### ✅ Good Task Example (Little Task)

```
Title: Add site-wide search box to header navigation

## Task Description
Add a search input field to the main header navigation (desktop and mobile) that searches all published pages and posts. Search should use WordPress core search functionality.

## Acceptance Criteria
- [ ] Search box appears in header on all pages
- [ ] Search box is keyboard accessible (tab to focus, enter to submit)
- [ ] Search box is visible on desktop (>1024px)
- [ ] Search box is in mobile menu (<1024px)
- [ ] Search results display using existing `/search` template
- [ ] Placeholder text: "Search site..."
- [ ] Icon: Use existing magnifying glass icon from theme

## Testing Steps
1. Go to homepage
2. Click in search box (or tab to it)
3. Type "test query"
4. Press Enter
5. Verify `/search?s=test+query` loads with results
6. Test on mobile (<768px) - search in mobile menu
7. Test keyboard navigation (tab, enter)

## Validation
- Test URL: https://staging.example.com
- Expected result: Search box in header, functional search, responsive on mobile

## Files to Change
- `header.php` - Add search form markup
- `style.css` - Add search box styles
- `mobile-menu.js` - Add search to mobile menu
- (add more as discovered)

## Deployment Notes
- No database changes
- Clear browser cache to see CSS changes
- Test on staging before pushing to production

## WordPress Notes
- Version: WordPress 6.4
- Theme: custom-theme
- PHP: 8.2
- Staging: https://staging.example.com
- Uses WP core search (no plugin needed)
```

**Why it's good:**
- Clear, specific scope (header search box)
- Detailed acceptance criteria (7 items)
- Complete testing steps (7 steps with mobile and accessibility)
- Validation details (URL, expected result)
- Files identified
- Deployment notes included
- WordPress-specific context
