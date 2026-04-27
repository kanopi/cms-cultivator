# Teamwork Integration

Comprehensive project management integration for Drupal, WordPress, and NextJS projects. Create properly formatted tasks, export audit findings, link code changes to tickets, and manage workflows with expert guidance.

---

## Overview

The Teamwork integration provides:

- **Template-Based Task Creation**: Four task templates (Big Task/Epic, Little Task, QA Handoff, Bug Report) with automatic selection
- **Audit Export**: Convert security, performance, accessibility, and quality findings into tracked tasks
- **Git Integration**: Auto-link PRs to tickets, detect ticket numbers in branches and commits
- **Quick Lookups**: Status checks and task details without leaving the CLI
- **CMS-Specific Context**: Automatic inclusion of Drupal, WordPress, and NextJS-specific information

---

## Setup

### Prerequisites

**Required:**
- CMS Cultivator plugin installed
- Teamwork account with API access

**Optional:**
- Teamwork MCP server (for direct API integration)

### Teamwork MCP Server Installation

The Teamwork MCP server enables direct API integration from Claude Code.

**Step 1: Get Bearer Token**

```bash
npm i @teamwork/get-bearer-token@latest -g
teamwork-get-bearer-token
```

Follow the interactive prompts to generate your bearer token.

**Step 2: Enable MCP in Teamwork**

Ask your Teamwork admin to enable MCP under **Settings → AI** in your Teamwork instance.

**Step 3: Add Server to Claude Code**

```bash
# HTTP mode (recommended) - hosted remote server
claude mcp add --transport http teamwork https://mcp.ai.teamwork.com \
  --header "Authorization: Bearer YOUR_TOKEN_HERE"

# Alternative: STDIO mode - download binary from releases, rename to tw-mcp
claude mcp add --transport stdio --env TW_MCP_BEARER_TOKEN=YOUR_TOKEN teamwork -- tw-mcp
```

**Step 4: Authenticate**

```bash
# In Claude Code, authenticate
/mcp
```

**Full documentation:** [Teamwork MCP Usage Guide](https://github.com/Teamwork/mcp/blob/main/usage.md)
**Claude Code MCP docs:** [code.claude.com/docs/en/mcp](https://code.claude.com/docs/en/mcp)

### Without MCP Server

If MCP server unavailable, the agent provides:
- Formatted markdown for manual task creation
- Task templates ready to copy/paste
- Guidance on manual linking

---

## Task Templates

> **Note:** Template details are organized in `templates/` subdirectories within each skill and agent for easier maintenance. All content remains accessible via markdown links in the skill/agent documentation.

### Template Selection Guide

The agent automatically selects appropriate templates based on context:

| Template | Use When | Key Indicators |
|----------|----------|----------------|
| **Big Task/Epic** | Complex features, multiple developers | "epic", "multiple devs", "integration branch", ">8 hours" |
| **Little Task** | Straightforward work, single developer | "quick fix", "simple", "add button", "<8 hours" |
| **QA Handoff** | Work ready for testing | "ready for qa", "testing", "validate", "handoff" |
| **Bug Report** | Defects and broken functionality | "bug", "error", "broken", "not working", "crash" |

### 1. Big Task/Epic Template

**When to use:**
- Multiple developers required
- Integration branch/multidev needed
- Complex scope with dependencies
- Phased delivery
- Epic-level coordination

**Required sections:**
- Background (business context)
- Requirements (checkboxes)
- Technical Approach
- Integration Branch/Multidev
- Dependencies (blocks/blocked by)
- Acceptance Criteria
- Testing Plan
- Deployment Notes
- Resources (designs, docs)

**Example task:**
```markdown
# Epic: Implement OAuth Authentication

## Background
Users need ability to sign in with Google and GitHub accounts to simplify
registration and reduce password fatigue.

## Requirements
- [ ] Google OAuth integration
- [ ] GitHub OAuth integration
- [ ] User profile creation on first login
- [ ] Account linking for existing users
- [ ] Admin panel for OAuth configuration

## Technical Approach
- Use Laravel Socialite for OAuth
- Store provider tokens securely (encrypted)
- Implement middleware for OAuth routes
- Add database migrations for provider tables

## Integration Branch/Multidev
- Branch: `integration/oauth-auth`
- Multidev: `multidev-oauth`
- URL: https://multidev-oauth.pantheonsite.io

## Dependencies
- Depends on: PROJ-100 (Database schema updates)
- Blocks: PROJ-125 (User profile page)

## Acceptance Criteria
- [ ] Users can sign in with Google
- [ ] Users can sign in with GitHub
- [ ] Profile created automatically
- [ ] Existing users can link accounts
- [ ] Token refresh works

## Testing Plan
- Unit tests: Provider integration
- Integration tests: Full OAuth flow
- Manual: Test with real Google/GitHub accounts

## Deployment Notes
- Add OAuth credentials to .env
- Run migrations: `php artisan migrate`
- Clear cache: `php artisan cache:clear`
- Update documentation

## Resources
- Design: https://figma.com/file/abc123
- OAuth docs: https://docs.example.com/oauth
- Related: PROJ-100, PROJ-125
```

### 2. Little Task Template

**When to use:**
- Single developer
- Clear, focused scope
- Estimated < 8 hours
- No complex dependencies

**Required sections:**
- Task Description
- Acceptance Criteria
- Testing Steps
- Validation (test URL, expected result)
- Files to Change
- Deployment Notes

**Example task:**
```markdown
# Add Logout Button to Header

## Task Description
Add a logout button to the main header navigation (desktop and mobile) that
logs out the user and redirects to homepage.

## Acceptance Criteria
- [ ] Logout button appears in header (logged-in users only)
- [ ] Button styled to match existing navigation
- [ ] Click logs out user and redirects to homepage
- [ ] Works on desktop and mobile
- [ ] Accessible (keyboard, screen reader)

## Testing Steps
1. Log in to site
2. Navigate to any page
3. Click logout button in header
4. Verify: redirected to homepage
5. Verify: session cleared (not logged in)
6. Test keyboard navigation (Tab to button, Enter to click)
7. Test mobile (<768px)

## Validation
- Test URL: https://staging.example.com
- Expected: Logout button visible, functional, responsive

## Files to Change
- `header.php` - Add logout button HTML
- `style.css` - Style logout button
- `functions.php` - Add logout handler (if needed)

## Deployment Notes
- No database changes
- Clear browser cache to see CSS changes
- Test on staging before production
```

### 3. QA Handoff Template

**When to use:**
- Work complete, needs validation
- Handing off to QA team
- Specific test scenarios required
- Regression testing needed

**Required sections:**
- What Was Built
- Test Environment
- Testing Instructions (test cases)
- Regression Testing
- Known Issues
- Success Criteria
- Notes for QA

**Example task:**
```markdown
# QA: Contact Form Validation

## What Was Built
Enhanced contact form validation with client-side and server-side checks.
Added real-time field validation and improved error messages.

## Test Environment
- URL: https://staging.example.com/contact
- Credentials: Not required (public form)
- Browsers: Chrome, Firefox, Safari (latest versions)
- Devices: Desktop, tablet, mobile

## Testing Instructions

### Test Case 1: Successful Submission
**Steps:**
1. Go to /contact page
2. Fill all fields with valid data:
   - Name: "Test User"
   - Email: "test@example.com"
   - Subject: "Test inquiry"
   - Message: "This is a test message."
3. Click "Submit"

**Expected Result:**
- Success message displays
- Email sent to admin@example.com
- Form clears

### Test Case 2: Empty Required Fields
**Steps:**
1. Go to /contact page
2. Leave all fields empty
3. Click "Submit"

**Expected Result:**
- Error messages display for all required fields
- No submission occurs
- Focus moves to first error field

### Test Case 3: Invalid Email Format
**Steps:**
1. Go to /contact page
2. Enter invalid email: "notanemail"
3. Click "Submit"

**Expected Result:**
- Error message: "Please enter a valid email address"
- Field highlighted in red

### Test Case 4: Real-Time Validation
**Steps:**
1. Start typing in email field
2. Enter invalid email
3. Tab to next field

**Expected Result:**
- Error message appears after leaving field
- Message disappears when corrected

## Regression Testing
- [ ] Existing contact submissions still work
- [ ] Email notifications still sent
- [ ] Admin panel shows submissions
- [ ] Spam filtering still active

## Known Issues
- Safari on iOS 12: Real-time validation slightly delayed (acceptable)

## Success Criteria
- [ ] All 4 test cases pass
- [ ] No console errors
- [ ] Responsive on mobile/tablet/desktop
- [ ] Accessible (keyboard, screen reader)
- [ ] Regression tests pass

## Notes for QA
- Test with real email addresses to verify delivery
- Check spam folder if emails not received
- Mobile: Test in portrait and landscape
```

### 4. Bug Report Template

**When to use:**
- Reporting a defect
- Something broken
- Need reproduction steps
- Issue needs investigation

**Required sections:**
- Bug Description
- Steps to Reproduce (reliable!)
- Expected Behavior
- Actual Behavior
- Environment
- Screenshots/Video
- Console Errors
- Frequency
- Impact
- Workaround (if any)
- Additional Context

**Example task:**
```markdown
# Bug: Contact Form 500 Error on Production

## Bug Description
Contact form on /contact page returns 500 Internal Server Error when submitted
with valid data. Form worked on staging but fails on production.

## Steps to Reproduce
**CRITICAL: These steps are 100% reliable**

1. Go to https://example.com/contact
2. Fill in all fields:
   - Name: "Test User"
   - Email: "test@example.com"
   - Subject: "Test"
   - Message: "Test message"
3. Click "Submit"
4. Observe 500 error page

## Expected Behavior
- Form submits successfully
- Confirmation message displays: "Thank you! We'll respond within 24 hours."
- Email sent to admin@example.com
- User redirected to /thank-you

## Actual Behavior
- 500 Internal Server Error page displays
- No email sent
- Form data lost
- User sees generic error page

## Environment
- **Browser:** Chrome 120 (also tested Firefox 121, Safari 17 - same issue)
- **OS:** macOS 14 (also tested Windows 11 - same issue)
- **Device:** Desktop
- **URL:** https://example.com/contact
- **User role:** Anonymous (not logged in)
- **Time:** Started occurring after deploy on Jan 15, 2024 at 3pm

## Screenshots/Video
[Screenshot of 500 error page attached]
[Screenshot of Chrome DevTools console attached]

## Console Errors
```
POST /contact/submit 500 Internal Server Error
Error: Failed to send email (connection timeout)
```

## Server Logs
```
PHP Fatal error: Uncaught exception 'SMTPConnectionException'
Connection timed out to smtp.example.com:587
```

## Frequency
- [x] Happens every time (100% reproduction rate)
- [ ] Happens intermittently

## Impact
- [x] Critical - Blocks core functionality
- Contact form is primary lead generation tool
- Estimated 20+ lost inquiries per day

## Workaround
Users can email directly to info@example.com (mentioned on error page)

## Additional Context
- Form works correctly on staging: https://staging.example.com/contact
- Deployed to production on Jan 15 (day issue started)
- No code changes to contact form in that deploy
- Issue appears to be SMTP configuration difference between staging and production
- Staging SMTP: smtp-dev.example.com (works)
- Production SMTP: smtp.example.com (fails)

## Suspected Root Cause
Production SMTP server (smtp.example.com:587) may be firewalled or
credentials incorrect. Need to verify:
1. Firewall rules allow outbound 587
2. SMTP credentials match .env.production
3. SMTP server status and logs
```

---

## Integration with Audit Commands

### Exporting Security Findings

**Workflow:**
```bash
# Run security audit
/audit-security --comprehensive

# After audit completes, export findings
/teamwork export --source=security --batch
```

**What happens:**
1. Agent analyzes security findings
2. Maps severity to priority (Critical→P0, High→P1, etc.)
3. Creates epic: "Security Fixes - OWASP Vulnerabilities"
4. Creates individual bug report tasks for each vulnerability
5. Links dependencies (e.g., fix SQL injection before XSS)
6. Provides export summary with task links

**Example output:**
```
✓ Export complete!

## Created Tasks

**Epic:** SEC-2024: Security Fixes (https://example.teamwork.com/tasks/1000)

**Critical (P0):**
- SEC-101: SQL Injection in User Search (https://...)

**High (P1):**
- SEC-102: XSS in User Profile (https://...)
- SEC-103: XSS in Comment Form (https://...)
- SEC-104: XSS in Search Results (https://...)

**Medium (P2):**
- SEC-105-108: CSRF and Validation Issues (4 tasks)

**Dependencies:**
- SEC-102, 103, 104 depend on SEC-101 (fix sanitization first)

**Recommended order:**
1. SEC-101 (critical, blocks others)
2. SEC-102-104 in parallel (after SEC-101)
3. SEC-105-108 next sprint
```

### Exporting Performance Findings

**Workflow:**
```bash
/audit-perf --comprehensive
/teamwork export --source=performance
```

**What happens:**
1. Agent analyzes performance findings
2. Creates Little Task templates for optimizations
3. Sets priorities based on impact (Core Web Vitals score)
4. Includes specific metrics and targets

### Exporting Accessibility Findings

**Workflow:**
```bash
/audit-a11y --standard
/teamwork export --source=accessibility --batch
```

**What happens:**
1. Agent analyzes WCAG violations
2. Critical violations (Level A) → Bug Report template (P1)
3. Medium violations (Level AA) → Little Task template (P2)
4. Groups by component for epic structure

### Exporting Code Quality Findings

**Workflow:**
```bash
/quality-analyze --comprehensive
/teamwork export --source=quality
```

**What happens:**
1. Agent analyzes code quality issues
2. Simple fixes → Little Task template
3. Major refactors → Big Task/Epic template
4. Sets priorities based on technical debt impact

---

## Git Integration

### Auto-Detect Ticket Numbers

The agent automatically detects ticket numbers in:

**Branch names:**
```bash
git checkout -b feature/PROJ-123-user-auth
# Agent detects: PROJ-123
```

**Commit messages:**
```bash
git commit -m "PROJ-123: Implement OAuth providers"
# Agent detects: PROJ-123
```

**PR titles:**
```bash
gh pr create --title "PROJ-123: Add user authentication"
# Agent detects: PROJ-123
```

### Link PR to Ticket

**Manual linking:**
```bash
/teamwork link PROJ-123
```

**Auto-linking during PR creation:**
```bash
/pr-create
# Agent detects PROJ-123 in branch name
# Automatically adds ticket link to PR description
```

**What gets added to PR:**
```markdown
## Related Tickets

Implements: [PROJ-123: Implement user authentication](https://example.teamwork.com/tasks/123)

## Summary from Teamwork

OAuth2 authentication with Google and GitHub providers.
Users can sign in using either provider.

**Status:** In Progress → Completed (when merged)

## Testing

From PROJ-123 acceptance criteria:
- [ ] Google OAuth integration works
- [ ] GitHub OAuth integration works
- [ ] User profile created on first login
```

---

## CMS-Specific Examples

### Drupal Project Example

**Scenario:** Create task for adding custom module

```bash
/teamwork create --type=task
```

**Agent prompts:**
```
Agent: "What would you like to create a task for?"

You: "Create a custom Drupal module for newsletter subscriptions"

Agent: "I'll use the Little Task template since this is focused module work.

I need some details:
1. Module machine name? (e.g., custom_newsletter)
2. Which entity types? (User, custom entity?)
3. Configuration forms needed?
4. Integration with external service?"

[After gathering details]

Agent creates task with Drupal-specific context:

## Drupal Notes
- Version: Drupal 10.2
- Multidev: `multidev-newsletter`
- URL: https://multidev-newsletter.pantheonsite.io
- Dependencies: None (standalone custom module)
- Config: Yes - module provides config form
- Cache: Clear after installation (`drush cr`)
- Module path: `web/modules/custom/custom_newsletter`

## Files to Create
- `custom_newsletter.info.yml`
- `custom_newsletter.module`
- `src/Form/NewsletterConfigForm.php`
- `src/Service/NewsletterService.php`
- `config/install/custom_newsletter.settings.yml`

## Installation Steps
1. Enable module: `drush en custom_newsletter`
2. Clear cache: `drush cr`
3. Configure at: /admin/config/system/newsletter
```

### WordPress Project Example

**Scenario:** Report bug in custom theme

```bash
/teamwork create --type=bug
```

**Agent prompts:**
```
Agent: "I'll use the Bug Report template. What's the issue?"

You: "Mobile menu not closing on iPhone"

Agent: "I need reproduction steps:
1. What device/browser?
2. What URL?
3. Exact steps to reproduce?"

[After gathering details]

Agent creates bug report with WordPress context:

## WordPress Notes
- Version: WordPress 6.4
- Theme: custom-theme v2.1
- PHP: 8.2
- Staging: https://staging.example.com
- Device: iPhone 14, iOS 17, Safari

## Environment
- **Browser:** Safari on iOS 17
- **Device:** iPhone 14
- **Theme:** custom-theme v2.1
- **URL:** https://example.com (all pages)

## Files to Check
- `header.php` - Mobile menu HTML
- `mobile-menu.js` - Menu toggle JavaScript
- `style.css` - Mobile menu styles
```

### NextJS Project Example

**Scenario:** Create epic for new API routes

```bash
/teamwork create --type=epic
```

**Agent prompts:**
```
Agent: "I'll use the Big Task/Epic template. Tell me about the API routes:"

You: "Need REST API for user management: create, read, update, delete users"

[After gathering details]

Agent creates epic with NextJS context:

## NextJS Notes
- Next: 14.1
- Node: 20.x
- Deployment: Vercel
- API Routes: New `/api/users` endpoints

## API Endpoints
- POST /api/users - Create user
- GET /api/users/:id - Get user
- PUT /api/users/:id - Update user
- DELETE /api/users/:id - Delete user
- GET /api/users - List users

## Environment Variables
Add to Vercel:
- `DATABASE_URL` - Postgres connection
- `JWT_SECRET` - JWT signing key
- `API_RATE_LIMIT` - Requests per minute

## Build & Deployment
- Build: `npm run build` required
- Deploy: Auto-deploy on merge to main (Vercel)
- Preview: Auto-generated for PRs
```

---

## Best Practices

### Task Creation

**DO:**
- ✅ Provide specific page URLs for validation
- ✅ Include numbered testing steps
- ✅ Note all deployment requirements
- ✅ Link to designs and documentation
- ✅ Specify browser/device testing needs
- ✅ Include CMS-specific context
- ✅ Use ticket numbers in branch names

**DON'T:**
- ❌ Create vague descriptions ("fix the thing")
- ❌ Omit testing instructions
- ❌ Forget deployment notes
- ❌ Assume implicit requirements
- ❌ Skip reproduction steps (bugs)
- ❌ Create 50+ individual tasks (use epics)

### Priority Setting

Use this guideline:

| Priority | Use When | Examples |
|----------|----------|----------|
| **P0 (Critical)** | Production down, data loss, security exploit | SQL injection, site crash, payment broken |
| **P1 (High)** | Major feature broken, blocks work, high impact | Login broken, checkout fails, WCAG Level A violation |
| **P2 (Medium)** | Standard work, moderate bugs, improvements | New feature, performance optimization, minor bug |
| **P3 (Low)** | Minor bugs, small enhancements, nice-to-haves | Typo, color tweak, console warning |
| **P4 (Backlog)** | Future work, ideas, technical debt | Refactoring, code cleanup, future features |

### Template Selection

**When unsure, ask yourself:**

1. **How many developers?**
   - Multiple → Big Task/Epic
   - Single → Little Task

2. **Is it broken?**
   - Yes → Bug Report
   - No → Feature/Task

3. **Is work complete?**
   - Yes, needs testing → QA Handoff
   - No → Task/Epic

4. **How long will it take?**
   - > 8 hours → Big Task/Epic
   - < 8 hours → Little Task

---

## Troubleshooting

### MCP Server Connection Issues

**Problem:** "Unable to connect to Teamwork MCP server"

**Solutions:**
1. Verify MCP server installed: `npm list -g @modelcontextprotocol/server-teamwork`
2. Check configuration in `~/.config/claude/mcp.json`
3. Verify API key valid (test in Teamwork UI)
4. Check domain format: `yourcompany.teamwork.com` (no https://)
5. Restart Claude Code

**Fallback:** Agent provides formatted markdown for manual task creation

### Template Selection Confusion

**Problem:** Agent picks wrong template

**Solution:** Use explicit template flag:
```bash
/teamwork create --template=bug-report
/teamwork create --template=little-task
```

### Missing Required Information

**Problem:** Can't provide all required template sections

**Solution:** Use placeholders:
```markdown
## Testing Steps
(will add detailed steps when starting implementation)

## Browser Requirements
(to be determined based on analytics - Firefox/Chrome/Safari likely)
```

Agent allows this and marks sections as "TBD"

---

## Related Skills

- [`pr-create`](../commands/pr-workflow.md) — Auto-links PRs to tickets
- [`audit-security`](../commands/security.md) — Can export findings
- [`audit-perf`](../commands/performance.md) — Can export findings
- [`audit-a11y`](../commands/accessibility.md) — Can export findings
- [`quality-analyze`](../commands/code-quality.md) — Can export tasks

---

## Further Reading

- [Agents and Skills Overview](../agents-and-skills.md)
- [Skills Overview](../commands/overview.md)
- [Quick Start Guide](../quick-start.md)
