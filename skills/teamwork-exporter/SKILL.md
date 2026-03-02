---
name: teamwork-exporter
description: Automatically export audit findings, security issues, performance problems, or accessibility violations to Teamwork tasks when other agents complete their analysis. Converts technical findings into actionable project management tasks with appropriate priorities and templates. Invoke when audit agents finish reports, user says "export to Teamwork", or findings need project tracking.
---

# Teamwork Exporter Skill

## Philosophy

**Bridge the gap between technical findings and project execution.** Audit reports identify problems; this skill transforms them into tracked, prioritized work items that teams can action.

## When to Use This Skill

This skill activates when:
- Audit agents complete their analysis (security, performance, accessibility, quality)
- User says "export to Teamwork", "create tasks from this report"
- Findings need to be tracked in project management
- Technical debt needs to be prioritized and scheduled

**Do NOT activate for:**
- Single task creation (use teamwork-task-creator instead)
- Quick status checks (use teamwork-integrator instead)
- Manual task updates (escalate to teamwork-specialist)

## Core Responsibilities

### 1. Parse Audit Reports

Recognize and parse these audit report formats:

**Markdown reports:**
- Headers indicate finding categories
- Severity levels: Critical, High, Medium, Low
- Code blocks show affected code
- File paths and line numbers

**JSON reports:**
- Structured data from automated tools
- Severity scores (0-10 or Critical/High/Medium/Low)
- File paths and rules violated
- Remediation suggestions

**Common audit types:**
- Security audits (OWASP Top 10, CVE findings)
- Performance audits (Core Web Vitals, lighthouse scores)
- Accessibility audits (WCAG violations)
- Code quality audits (complexity, standards violations)

### 2. Convert Findings to Tasks

**Transformation rules:**

1. **Group related findings**
   - Same file/component
   - Same vulnerability type
   - Same fix strategy

2. **Create epic for multiple related issues**
   - If 3+ findings in same category
   - Example: "Security Fixes - XSS Vulnerabilities"

3. **Individual tasks for each finding**
   - Clear title: "[Type] in [File/Component]"
   - Complete description with context
   - Remediation steps
   - Testing requirements

4. **Set appropriate template**
   - Security/bugs → Bug Report template
   - Performance improvements → Little Task template
   - Major refactors → Big Task/Epic template
   - Completed work needing validation → QA Handoff template

### 3. Priority Mapping

Map audit severity to Teamwork priority:

| Audit Severity | Teamwork Priority | Rationale |
|----------------|-------------------|-----------|
| Critical | P0 | Production down, data loss, active exploit |
| High | P1 | Major vulnerability, significant performance issue |
| Medium | P2 | Standard fixes, moderate issues |
| Low | P3 | Minor improvements, best practices |
| Info | P4 | Technical debt, future considerations |

**Severity Score Mapping (0-10 scale):**
- 9.0-10.0 → P0 (Critical)
- 7.0-8.9 → P1 (High)
- 4.0-6.9 → P2 (Medium)
- 1.0-3.9 → P3 (Low)
- 0.0-0.9 → P4 (Info)

### 4. Template Selection Logic

```python
def select_export_template(finding):
    # Security vulnerabilities and bugs → Bug Report
    if finding.type in ['security', 'vulnerability', 'bug', 'error']:
        return 'bug-report'

    # Completed work needing validation → QA Handoff
    if finding.type == 'completed' or 'needs testing' in finding.description:
        return 'qa-handoff'

    # Large refactors, architectural changes → Big Task
    if finding.effort == 'high' or finding.files_affected > 5:
        return 'big-task-epic'

    # Default: straightforward fixes → Little Task
    return 'little-task'
```

## Audit Type Handlers

### Security Audit Export

**Input:** Security scan results (OWASP, CVE, custom scans)

**Output:** Bug Report tasks for vulnerabilities

**Example transformation:**

**Finding:**
```markdown
### Critical: SQL Injection in User Search

**File:** `includes/search.php:45`
**CWE:** CWE-89
**OWASP:** A03:2021 - Injection

User input from search form is directly concatenated into SQL query without sanitization.

```php
$query = "SELECT * FROM users WHERE name LIKE '%{$_POST['search']}%'";
```

**Recommendation:** Use prepared statements with parameterized queries.
```

**Exported Task:**
```markdown
# Bug Report: SQL Injection in User Search

## Bug Description
Critical SQL injection vulnerability in user search functionality. User input is directly concatenated into SQL query without sanitization, allowing potential data exfiltration or modification.

## Security Impact
**Severity:** Critical (P0)
**CWE:** CWE-89 - SQL Injection
**OWASP:** A03:2021 - Injection

**Potential Impact:**
- Unauthorized data access (all user records)
- Data modification or deletion
- Potential server compromise

## Location
- **File:** `includes/search.php`
- **Line:** 45
- **Function:** `search_users()`

## Vulnerable Code
```php
$query = "SELECT * FROM users WHERE name LIKE '%{$_POST['search']}%'";
$results = mysqli_query($conn, $query);
```

## Steps to Reproduce
1. Go to `/search` page
2. Enter payload: `%'; DROP TABLE users; --`
3. Observe SQL error or successful injection

## Expected Behavior
User search should safely query database using parameterized queries.

## Remediation
Replace direct concatenation with prepared statements:

```php
$stmt = $conn->prepare("SELECT * FROM users WHERE name LIKE ?");
$search_param = "%{$search_term}%";
$stmt->bind_param("s", $search_param);
$stmt->execute();
$results = $stmt->get_result();
```

## Testing Requirements
- [ ] Test search with normal queries
- [ ] Test with SQL injection payloads (safe testing)
- [ ] Verify prepared statements used
- [ ] Run security scan to confirm fix

## References
- OWASP SQL Injection: https://owasp.org/www-community/attacks/SQL_Injection
- CWE-89: https://cwe.mitre.org/data/definitions/89.html

## Priority
**P0 (Critical)** - Active security vulnerability in production
```

### Performance Audit Export

**Input:** Performance scan results (Lighthouse, Core Web Vitals)

**Output:** Little Task for improvements

**Example transformation:**

**Finding:**
```markdown
### High: Large JavaScript Bundle Size

**Impact:** 1.2s delay in Time to Interactive
**File:** `bundle.js` (847 KB)
**Lighthouse Score:** 62/100

Main JavaScript bundle is too large, causing slow page load. Multiple unused libraries included.

**Recommendation:**
- Remove unused dependencies
- Implement code splitting
- Lazy load non-critical modules
```

**Exported Task:**
```markdown
# Little Task: Reduce JavaScript Bundle Size

## Task Description
Optimize main JavaScript bundle (`bundle.js`) which is currently 847 KB and causing 1.2s delay in Time to Interactive. Performance audit identified unused libraries and lack of code splitting.

**Current State:**
- Bundle size: 847 KB
- TTI delay: 1.2s
- Lighthouse score: 62/100

**Target:**
- Bundle size: < 300 KB
- TTI delay: < 500ms
- Lighthouse score: > 90/100

## Acceptance Criteria
- [ ] Remove unused dependencies (identified in audit)
- [ ] Implement code splitting for route-based chunks
- [ ] Lazy load non-critical modules (analytics, chat widget)
- [ ] Bundle size reduced to < 300 KB
- [ ] Lighthouse performance score > 90
- [ ] Time to Interactive < 500ms

## Technical Approach
1. **Analyze bundle:** Run `npm run analyze` to identify large dependencies
2. **Remove unused:**
   - `lodash` (use individual imports)
   - `moment` (replace with `date-fns`)
   - Unused vendor libraries
3. **Code split:** Implement route-based splitting with React.lazy()
4. **Lazy load:** Move analytics and chat to separate chunks

## Testing Steps
1. Run `npm run build`
2. Check bundle size: `ls -lh dist/*.js`
3. Run Lighthouse audit
4. Test page load on 3G connection (DevTools throttling)
5. Verify all features still work

## Validation
- Test URL: https://staging.example.com
- Expected result: Lighthouse score > 90, bundle < 300 KB, TTI < 500ms

## Files to Change
- `webpack.config.js` - Add code splitting config
- `src/App.js` - Implement React.lazy()
- `package.json` - Remove unused dependencies
- `src/analytics.js` - Lazy load analytics

## Deployment Notes
- Clear CDN cache after deployment
- Monitor bundle size in CI (add check to prevent regression)

## Priority
**P2 (Medium)** - Performance optimization, not blocking but impacts user experience
```

### Accessibility Audit Export

**Input:** WCAG compliance scan results

**Output:** Little Task or Bug Report based on severity

**Example transformation:**

**Finding:**
```markdown
### High: Missing Alt Text on Images

**WCAG:** 1.1.1 Non-text Content (Level A)
**Impact:** Screen readers cannot describe images
**Affected:** 47 images across site

Missing `alt` attributes on images throughout the site, preventing screen reader users from understanding visual content.

**Example:**
```html
<img src="/products/widget.jpg">
```

**Recommendation:** Add descriptive alt text to all images.
```

**Exported Task:**
```markdown
# Bug Report: Missing Alt Text Prevents Screen Reader Access

## Bug Description
47 images across the site are missing `alt` attributes, violating WCAG 2.1 Level A success criterion 1.1.1 (Non-text Content). Screen reader users cannot access image content.

## Accessibility Impact
**Severity:** High (P1)
**WCAG:** 1.1.1 Non-text Content (Level A)
**Compliance:** Currently fails WCAG 2.1 Level A

**User Impact:**
- Screen reader users cannot understand visual content
- Images announced as "image" with no description
- Product images lack context (significant for e-commerce)

## Affected Areas
- Product pages: 23 images
- Blog posts: 12 images
- Homepage: 8 images
- About page: 4 images

**Total:** 47 images

## Steps to Reproduce
1. Install NVDA or JAWS screen reader
2. Navigate to any product page
3. Listen to image announcements
4. Observe: images announced as "image" with no description

## Expected Behavior
All images should have descriptive `alt` attributes:
```html
<img src="/products/widget.jpg" alt="Blue widget with chrome finish, 12-inch diameter">
```

## Actual Behavior
Images have no alt attributes:
```html
<img src="/products/widget.jpg">
```

## Remediation Plan

### 1. Audit All Images
Run accessibility scan to identify all missing alt text:
```bash
/audit-a11y images
```

### 2. Add Alt Text Guidelines
**Decorative images:** Use `alt=""`
**Informative images:** Describe content/function
**Product images:** Include key features/characteristics

### 3. Implement Fixes

**Product images:**
```html
<img src="widget.jpg" alt="Blue widget with chrome finish, 12-inch diameter">
```

**Blog feature images:**
```html
<img src="blog-header.jpg" alt="Developer working on laptop with code visible">
```

**Logos:**
```html
<img src="logo.png" alt="Company Name logo">
```

**Decorative images:**
```html
<img src="background-pattern.png" alt="">
```

## Testing Requirements
- [ ] All 47 images have alt attributes
- [ ] Alt text is descriptive and meaningful
- [ ] Decorative images use `alt=""`
- [ ] Screen reader testing (NVDA/JAWS)
- [ ] Automated scan passes (axe, WAVE)

## Validation
- Test URLs: All site pages
- Screen reader: NVDA on Windows, VoiceOver on Mac
- Expected: All images described appropriately

## Files to Change
- `templates/product-card.php`
- `templates/blog-post.php`
- `header.php`
- `footer.php`
- (47 image instances across multiple files)

## Deployment Notes
- No cache clearing required
- Update content guidelines for future images

## Priority
**P1 (High)** - WCAG Level A violation, blocks accessibility compliance
```

### Code Quality Audit Export

**Input:** Code quality scan (PHPCS, ESLint, complexity analysis)

**Output:** Little Task for improvements, Epic for major refactors

**Example transformation:**

**Finding:**
```markdown
### Medium: High Cyclomatic Complexity in checkout.php

**Complexity:** 47 (target: <10)
**File:** `checkout.php`
**Function:** `process_checkout()`

The `process_checkout()` function has 47 cyclomatic complexity (target is < 10), making it difficult to test and maintain. Function is 350 lines with deeply nested conditionals.

**Recommendation:** Refactor into smaller functions with single responsibilities.
```

**Exported Task:**
```markdown
# Little Task: Refactor process_checkout() Function

## Task Description
The `process_checkout()` function in `checkout.php` has high cyclomatic complexity (47, target < 10) and is 350 lines long. Function handles multiple responsibilities and has deeply nested conditionals, making it difficult to test and maintain.

**Current State:**
- Complexity: 47
- Lines: 350
- Responsibilities: validation, payment, inventory, email, logging
- Test coverage: 23%

**Target:**
- Complexity: < 10 per function
- Lines: < 50 per function
- Single responsibility per function
- Test coverage: > 80%

## Acceptance Criteria
- [ ] Extract validation logic to `validate_checkout_data()`
- [ ] Extract payment logic to `process_payment()`
- [ ] Extract inventory logic to `update_inventory()`
- [ ] Extract email logic to `send_order_confirmation()`
- [ ] Main `process_checkout()` orchestrates calls
- [ ] Each function has < 10 complexity
- [ ] Unit tests for each extracted function
- [ ] All existing functionality preserved

## Technical Approach

**Before (current):**
```php
function process_checkout($data) {
    // 350 lines of validation, payment, inventory, email, logging
    // Complexity: 47
}
```

**After (refactored):**
```php
function process_checkout($data) {
    $validated = validate_checkout_data($data);
    $payment = process_payment($validated);
    $inventory = update_inventory($validated);
    $confirmation = send_order_confirmation($validated, $payment);
    log_checkout_event($validated, $payment);
    return $confirmation;
}
```

## Testing Steps
1. Run existing tests to establish baseline
2. Refactor validation logic first
3. Run tests after each extraction
4. Add unit tests for new functions
5. Verify all checkout scenarios still work

## Validation
- Test URL: https://staging.example.com/checkout
- Test scenarios:
  - Successful purchase
  - Invalid card
  - Out of stock
  - Coupon codes
  - Multiple items

## Files to Change
- `checkout.php` - Refactor main function
- `tests/CheckoutTest.php` - Add unit tests
- (create new files if needed: `CheckoutValidator.php`, `PaymentProcessor.php`)

## Deployment Notes
- No database changes
- Backward compatible (same public API)
- Deploy during low-traffic window as precaution

## Priority
**P2 (Medium)** - Code quality improvement, not blocking but reduces technical debt
```

## Batch Export Patterns

### Pattern 1: Epic with Sub-Tasks

**When:** 3+ related findings in same category

**Structure:**
```
Epic: Security Fixes - XSS Vulnerabilities [P1]
├── Task 1: XSS in User Profile [P1]
├── Task 2: XSS in Comment Form [P1]
└── Task 3: XSS in Search Results [P1]
```

**Epic content includes:**
- Overview of vulnerability type
- Total count and severity
- Remediation strategy
- Testing approach
- Rollout plan

### Pattern 2: Priority Buckets

**When:** Mixed severity findings (10+ issues)

**Structure:**
```
Epic: Accessibility Improvements [P2]
├── Critical Fixes (P0)
│   └── Task 1: Keyboard trap in modal [P0]
├── High Priority (P1)
│   ├── Task 2: Missing alt text [P1]
│   └── Task 3: Color contrast issues [P1]
└── Medium Priority (P2)
    ├── Task 4: Focus indicators [P2]
    └── Task 5: ARIA labels [P2]
```

### Pattern 3: Component-Based

**When:** Multiple issues in same component

**Structure:**
```
Epic: Fix Product Card Component [P2]
├── Task 1: Accessibility - ARIA labels [P1]
├── Task 2: Performance - Image optimization [P2]
└── Task 3: Security - XSS in product name [P1]
```

## Dependency Management

### Auto-detect Dependencies

**Blocking relationships:**
- Database schema changes block feature development
- Security fixes block deployment
- Infrastructure changes block application changes

**Example:**
```markdown
**Finding 1:** SQL Injection in User Search [P0]
**Finding 2:** Missing Input Validation [P1]

**Relationship:** Finding 2 depends on Finding 1
- Fix SQL injection first (sanitization layer)
- Then add comprehensive input validation
- Testing requires both fixes
```

**Exported as:**
```
Task A: Fix SQL Injection [P0]
Task B: Add Input Validation [P1]
  └─ Depends on: Task A
```

## Integration with Audit Agents

### Security Specialist → Exporter

**Trigger:** Security audit completes

**Data passed:**
- Vulnerability findings
- Severity levels
- CWE/OWASP classifications
- Affected files and lines
- Remediation suggestions

**Action:** Create bug report tasks for each vulnerability

### Performance Specialist → Exporter

**Trigger:** Performance audit completes

**Data passed:**
- Core Web Vitals metrics
- Lighthouse scores
- Performance bottlenecks
- Optimization opportunities

**Action:** Create little tasks for each optimization

### Accessibility Specialist → Exporter

**Trigger:** Accessibility audit completes

**Data passed:**
- WCAG violations
- Severity levels
- Affected elements
- Remediation steps

**Action:** Create bug reports for violations, little tasks for improvements

### Code Quality Specialist → Exporter

**Trigger:** Quality audit completes

**Data passed:**
- Complexity metrics
- Standards violations
- Code smells
- Refactoring suggestions

**Action:** Create little tasks for simple fixes, epics for major refactors

## Teamwork MCP Tools

This skill uses these Teamwork MCP tools (loaded via ToolSearch):

```
mcp__teamwork__twprojects-create_task
mcp__teamwork__twprojects-list_projects
mcp__teamwork__twprojects-create_milestone  (for epics)
```

## Workflow

```
1. Receive audit report from specialist agent
   └─ Parse format (markdown, JSON, structured data)

2. Analyze findings
   └─ Group related issues
   └─ Determine priority mapping
   └─ Select appropriate templates

3. Decide export strategy
   └─ Single task vs. epic with sub-tasks
   └─ Identify dependencies

4. Load Teamwork MCP tools via ToolSearch
   └─ If epic: create parent first
   └─ Create individual tasks
   └─ Link dependencies

5. Confirm export
   └─ List created tasks with links
   └─ Provide summary statistics
   └─ Suggest next actions
```

## Output Format

After export, provide comprehensive summary:

```markdown
## Export Summary

**Audit Type:** Security Scan
**Findings:** 12 issues
**Tasks Created:** 13 (1 epic + 12 sub-tasks)

### Created Tasks

#### Epic
- [SEC-2024: Security Fixes - XSS Vulnerabilities](https://example.teamwork.com/tasks/100)
  - Priority: P1 (High)
  - Sub-tasks: 12

#### Critical (P0)
- [SEC-101: SQL Injection in User Search](https://example.teamwork.com/tasks/101)

#### High (P1)
- [SEC-102: XSS in User Profile](https://example.teamwork.com/tasks/102)
- [SEC-103: XSS in Comment Form](https://example.teamwork.com/tasks/103)
- [SEC-104: CSRF Missing on Forms](https://example.teamwork.com/tasks/104)

#### Medium (P2)
- 8 additional tasks (see epic for full list)

### Dependencies Configured
- SEC-102, SEC-103, SEC-104 depend on SEC-101 (fix core sanitization first)

### Recommended Actions
1. Start with SEC-101 (critical SQL injection)
2. Then tackle P1 XSS issues in parallel
3. Schedule P2 fixes for next sprint

### Next Steps
- Assign tasks to team members
- Set sprint milestones
- Update team on security priorities
```

## Best Practices

**DO:**
- ✅ Group related findings into epics
- ✅ Map severity to priority accurately
- ✅ Include complete context (files, lines, code)
- ✅ Provide remediation steps
- ✅ Link dependencies
- ✅ Add testing requirements

**DON'T:**
- ❌ Create 50+ individual tasks (use epics)
- ❌ Lose critical details in conversion
- ❌ Ignore severity levels
- ❌ Create tasks without remediation guidance
- ❌ Forget to link related tasks

## Error Handling

### MCP Server Unavailable

**Fallback:** Provide formatted markdown for manual entry

```markdown
Unable to connect to Teamwork MCP server. Here are formatted tasks to manually create:

---

## Task 1: SQL Injection in User Search

[Complete bug report template]

**Manual steps:**
1. Go to Teamwork
2. Create new task in [Project]
3. Copy/paste above content
4. Set priority: P0 (Critical)
5. Assign to: [Security Lead]

---

[Repeat for each task]
```

### Ambiguous Findings

**Response:**
```markdown
I found some audit findings that need clarification before creating tasks:

**Finding:** "Performance issues in checkout"

**Needs:**
- Which specific metrics are slow? (LCP, FID, CLS?)
- What's the target performance level?
- Which files/components are affected?

Would you like me to re-run a performance audit with more details, or would you like to provide this context now?
```

## Examples

See the detailed examples above for:
- Security audit export (SQL injection)
- Performance audit export (bundle size)
- Accessibility audit export (missing alt text)
- Code quality audit export (complexity)

Each example shows the full transformation from audit finding to complete Teamwork task.
