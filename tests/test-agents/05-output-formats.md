# Test 05: Agent Output Format Validation

**Category:** Output Quality & Consistency
**Purpose:** Verify agents produce correctly formatted, actionable output
**Focus:** Report structure, code examples, prioritization, CMS-specificity

---

## Test 5.1: Report Structure Standards

### Required Elements for All Reports

Every agent report MUST include:

1. **Clear Status Indicator**
   - ✅ Pass / ⚠️ Issues Found / ❌ Critical Issues
   - Traffic light system: 🟢 🟡 🔴

2. **Issue Prioritization**
   - Critical → High → Medium → Low
   - Clear severity labels
   - Impact statements

3. **Specific Locations**
   - File paths (relative to project root)
   - Line numbers when applicable
   - Function/class names

4. **Actionable Fixes**
   - Before/after code examples
   - Step-by-step instructions
   - CMS-specific guidance

5. **Context & Impact**
   - Who is affected
   - Why it matters
   - Business/technical impact

---

## Test 5.2: Accessibility Specialist Output

### Test 5.2.1: Basic Report Format

**Test Procedure:**
```
User: Run /audit-a11y on homepage template
```

**Required Output Elements:**
- [ ] Status indicator (✅/⚠️/❌)
- [ ] WCAG success criteria referenced (e.g., "1.1.1", "4.1.2")
- [ ] File paths with line numbers
- [ ] Before/after code examples
- [ ] Priority levels assigned

**Expected Format:**
```markdown
## Accessibility Findings

**Status:** ⚠️ Issues Found

**Critical Issues:**
1. [CRITICAL] Missing alt text on 3 images (WCAG 1.1.1)
   - **File:** templates/homepage.php line 42
   - **Impact:** Screen reader users cannot understand image content
   - **Fix:**
     ```php
     // Before
     <img src="hero.jpg">

     // After
     <img src="hero.jpg" alt="Dashboard showing analytics data">
     ```

**High Priority:**
2. [HIGH] Color contrast fails (2.8:1, needs 4.5:1) (WCAG 1.4.3)
   - **File:** assets/css/style.css line 156
   - **Impact:** Low vision users cannot read button text
   - **Fix:** Change #888 to #595959 or darker
```

**Validation Checklist:**
- [ ] All WCAG references valid (X.X.X format)
- [ ] File paths relative to project root
- [ ] Line numbers accurate
- [ ] Code examples include before/after
- [ ] Impact explains user effect

---

### Test 5.2.2: CMS-Specific Guidance

**Drupal Project Test:**
```
User: Check accessibility of Views configuration
```

**Expected Output:**
- [ ] Drupal-specific patterns mentioned
- [ ] Form API examples
- [ ] Views accessibility recommendations
- [ ] Module/theme-specific guidance

**Example:**
```markdown
### Drupal-Specific Issues:

1. [HIGH] Views table missing caption
   - **File:** config/sync/views.view.content_list.yml
   - **Fix (Drupal):**
     ```yaml
     table:
       caption: 'List of content items'
       summary: 'Sortable table showing title, author, status'
     ```

2. [MEDIUM] Form API label missing
   - **File:** src/Form/ContactForm.php line 34
   - **Fix (Drupal Form API):**
     ```php
     $form['email'] = [
       '#type' => 'email',
       '#title' => $this->t('Email Address'),  // ✓ Has label
       '#required' => TRUE,
     ];
     ```
```

**WordPress Project Test:**
```
User: Check accessibility of custom block
```

**Expected Output:**
- [ ] WordPress-specific patterns
- [ ] Block editor examples
- [ ] Theme template guidance

---

## Test 5.3: Performance Specialist Output

### Test 5.3.1: Core Web Vitals Format

**Test Procedure:**
```
User: Run /audit-perf on the product page
```

**Required Output Elements:**
- [ ] Core Web Vitals metrics (LCP, INP, CLS)
- [ ] Threshold indicators (Good/Needs Improvement/Poor)
- [ ] Specific bottlenecks identified
- [ ] Optimization recommendations with impact estimates

**Expected Format:**
```markdown
## Performance Analysis

**Core Web Vitals:**
- **LCP:** 2.5s (🟢 Good - under 2.5s threshold)
- **INP:** 100ms (🟢 Good - under 200ms threshold)
- **CLS:** 0.05 (🟢 Good - under 0.1 threshold)

**Bottlenecks Identified:**

1. [CRITICAL] Unoptimized database queries causing 3s delay
   - **File:** includes/post-query.php line 89
   - **Issue:** N+1 query loading post meta in loop (500 queries)
   - **Impact:** Page load time 3x slower, poor UX
   - **Fix:**
     ```php
     // Before (N+1 problem)
     foreach ($posts as $post) {
       $meta = get_post_meta($post->ID);  // Query per post
     }

     // After (single query)
     update_post_meta_cache(wp_list_pluck($posts, 'ID'));
     foreach ($posts as $post) {
       $meta = get_post_meta($post->ID);  // Cached
     }
     ```
   - **Expected Impact:** Reduce queries from 500 to 1, save 2.8s
```

**Validation Checklist:**
- [ ] All Core Web Vitals included
- [ ] Thresholds shown (Good/Needs Improvement/Poor)
- [ ] Metrics have units (ms, s, score)
- [ ] Performance impact quantified
- [ ] Optimization ROI estimated

---

## Test 5.4: Security Specialist Output

### Test 5.4.1: OWASP Vulnerability Format

**Test Procedure:**
```
User: Run /audit-security on authentication code
```

**Required Output Elements:**
- [ ] OWASP Top 10 category (e.g., "A03:2021")
- [ ] CVE numbers (for dependency issues)
- [ ] Severity rating (Critical/High/Medium/Low)
- [ ] Exploit scenario explanation
- [ ] Secure code examples

**Expected Format:**
```markdown
## Security Audit Results

**Status:** ❌ Critical Vulnerabilities Found

**Critical Issues:**

1. [CRITICAL] SQL Injection vulnerability (OWASP A03:2021 - Injection)
   - **File:** includes/database.php line 89
   - **Severity:** 9.8/10 (CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H)
   - **Exploit Scenario:**
     Attacker can inject SQL via user_id parameter:
     `?user_id=1 OR 1=1; DROP TABLE users;--`

   - **Vulnerable Code:**
     ```php
     // INSECURE
     $query = "SELECT * FROM users WHERE id = " . $_GET['user_id'];
     $result = $db->query($query);
     ```

   - **Secure Fix:**
     ```php
     // SECURE (Prepared Statement)
     $stmt = $db->prepare("SELECT * FROM users WHERE id = ?");
     $stmt->bind_param("i", $_GET['user_id']);
     $stmt->execute();
     $result = $stmt->get_result();
     ```

**Dependency Vulnerabilities:**

2. [HIGH] Known vulnerability in jQuery 2.1.4 (CVE-2020-11023)
   - **Package:** jquery@2.1.4
   - **Fix:** Upgrade to jquery@3.6.0 or later
   - **Command:** `npm update jquery`
```

**Validation Checklist:**
- [ ] OWASP categories referenced
- [ ] CVE numbers for dependencies
- [ ] Severity scores (CVSS when available)
- [ ] Exploit scenario explained
- [ ] Secure alternatives provided
- [ ] CMS-specific security functions used (wp_prepare, db_query, etc.)

---

## Test 5.5: Testing Specialist Output

### Test 5.5.1: Test Suite Format

**Test Procedure:**
```
User: Generate tests for UserAuthentication class
```

**Required Output Elements:**
- [ ] Multiple test types (unit, integration, e2e)
- [ ] Test coverage analysis
- [ ] CMS-specific test frameworks
- [ ] Setup/teardown patterns
- [ ] Assertions and expectations

**Expected Format:**
```php
/**
 * Unit Tests for UserAuthentication
 *
 * Test Coverage: 85% (15 of 18 methods)
 * Framework: PHPUnit 9.x
 */

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use App\Auth\UserAuthentication;

class UserAuthenticationTest extends TestCase
{
    private $auth;

    protected function setUp(): void
    {
        parent::setUp();
        $this->auth = new UserAuthentication();
    }

    /**
     * @test
     * @covers UserAuthentication::validatePassword
     */
    public function it_validates_correct_password()
    {
        $result = $this->auth->validatePassword('user@example.com', 'SecurePass123!');
        $this->assertTrue($result);
    }

    /**
     * @test
     * @covers UserAuthentication::validatePassword
     * @dataProvider invalidPasswordProvider
     */
    public function it_rejects_invalid_passwords($email, $password)
    {
        $result = $this->auth->validatePassword($email, $password);
        $this->assertFalse($result);
    }

    public function invalidPasswordProvider()
    {
        return [
            ['user@example.com', ''],
            ['user@example.com', 'short'],
            ['user@example.com', 'NoNumber!'],
        ];
    }
}

/**
 * Test Coverage Report
 */
// ✓ Covered (85%):
//   - validatePassword()
//   - hashPassword()
//   - verifyToken()
//   [...]
//
// ✗ Not Covered (15%):
//   - resetPassword() [TODO: Add integration test]
//   - sendResetEmail() [TODO: Mock email service]
```

**Validation Checklist:**
- [ ] Test class properly structured
- [ ] setUp/tearDown methods included
- [ ] Multiple test methods
- [ ] Data providers for parameterized tests
- [ ] Coverage report included
- [ ] Annotations/attributes present (@test, @covers)

---

## Test 5.6: Documentation Specialist Output

### Test 5.6.1: API Documentation Format

**Test Procedure:**
```
User: Generate documentation for Payment class
```

**Required Output Elements:**
- [ ] PHPDoc/JSDoc format
- [ ] Parameter types and descriptions
- [ ] Return types and values
- [ ] Usage examples
- [ ] Exception documentation

**Expected Format:**
```php
/**
 * Processes a payment transaction.
 *
 * Validates payment information, processes through payment gateway,
 * and records transaction in database.
 *
 * @param array $payment_data {
 *     Payment information array.
 *
 *     @type string $amount      Payment amount in USD (e.g., "29.99")
 *     @type string $card_number Credit card number (masked after processing)
 *     @type string $cvv         Card verification value
 *     @type string $exp_date    Expiration date (MM/YY format)
 * }
 * @param int $user_id User ID making the payment
 *
 * @return array {
 *     Transaction result array.
 *
 *     @type bool   $success       Whether payment succeeded
 *     @type string $transaction_id Unique transaction identifier
 *     @type string $message       Success/error message
 *     @type int    $code          HTTP status code (200, 400, 500)
 * }
 *
 * @throws InvalidArgumentException If payment_data is malformed
 * @throws PaymentGatewayException If gateway communication fails
 *
 * @since 2.0.0
 *
 * @example
 * ```php
 * $payment = new Payment();
 * $result = $payment->process([
 *     'amount' => '49.99',
 *     'card_number' => '4111111111111111',
 *     'cvv' => '123',
 *     'exp_date' => '12/25'
 * ], 42);
 *
 * if ($result['success']) {
 *     echo "Transaction ID: " . $result['transaction_id'];
 * }
 * ```
 */
public function process(array $payment_data, int $user_id): array
{
    // Implementation
}
```

**Validation Checklist:**
- [ ] Complete PHPDoc block
- [ ] All parameters documented with types
- [ ] Return value structure explained
- [ ] Exceptions documented
- [ ] Usage example included
- [ ] @since version tag present

---

## Test 5.7: Code Quality Specialist Output

### Test 5.7.1: Standards Violations Format

**Test Procedure:**
```
User: Run /quality-standards on UserService.php
```

**Required Output Elements:**
- [ ] Violation count and percentage
- [ ] Standards reference (PHPCS, ESLint rule names)
- [ ] File/line numbers
- [ ] Severity levels
- [ ] Fix recommendations

**Expected Format:**
```markdown
## Code Quality Analysis

**Standards Compliance:** 82% (18 violations found)
**Standard:** Drupal Coding Standards (PHPCS)

**Errors (Must Fix):**

1. [ERROR] Line exceeds 80 characters
   - **File:** src/Service/UserService.php line 45
   - **Rule:** Drupal.Files.LineLength.TooLong
   - **Current:** 127 characters
   - **Fix:** Break into multiple lines
     ```php
     // Before (127 chars)
     $result = $this->database->query("SELECT * FROM users WHERE status = 1 AND role = 'admin' AND created > " . $timestamp);

     // After (wrapped)
     $result = $this->database->query(
       "SELECT * FROM users WHERE status = 1 " .
       "AND role = 'admin' AND created > " . $timestamp
     );
     ```

**Warnings (Should Fix):**

2. [WARNING] Function has cyclomatic complexity of 15
   - **File:** src/Service/UserService.php line 100
   - **Rule:** Generic.Metrics.CyclomaticComplexity.MaxExceeded
   - **Threshold:** 10
   - **Recommendation:** Refactor into smaller, single-purpose methods
     ```php
     // Before (complexity: 15)
     public function processUser($user) {
       if (...) {
         if (...) {
           foreach (...) {
             if (...) {
               // deeply nested logic
             }
           }
         }
       }
     }

     // After (complexity: 5 each)
     public function processUser($user) {
       if (!$this->validateUser($user)) return;
       $this->updateUserData($user);
       $this->notifyUser($user);
     }

     private function validateUser($user) { /* ... */ }
     private function updateUserData($user) { /* ... */ }
     private function notifyUser($user) { /* ... */ }
     ```
```

**Validation Checklist:**
- [ ] Compliance percentage shown
- [ ] Standards referenced by name
- [ ] Rule IDs included (e.g., Drupal.Files.LineLength.TooLong)
- [ ] Severity levels clear (Error/Warning)
- [ ] Refactoring suggestions provided
- [ ] Complexity scores quantified

---

## Test 5.8: Live Audit Specialist Output (Synthesis)

### Test 5.8.1: Unified Report Format

**Test Procedure:**
```
User: Run /audit-live-site https://staging.example.com
```

**Required Output Elements:**
- [ ] Executive summary
- [ ] Overall health score
- [ ] Cross-category prioritization
- [ ] Findings from ALL 4 specialists
- [ ] Remediation roadmap

**Expected Format:**
```markdown
# Live Site Audit Report

**Site:** https://staging.example.com
**Date:** 2026-01-02
**Overall Health:** 72/100 (🟡 Needs Improvement)

## Executive Summary

Site has **3 critical issues** requiring immediate attention before launch:
- 1 security vulnerability (SQL injection risk)
- 1 accessibility blocker (missing alt text)
- 1 performance issue (8s page load)

Overall, the site is 72% ready for production with 48 total issues identified across all categories.

---

## Critical Issues (Must Fix Before Launch)

### 1. [SECURITY] SQL Injection in search endpoint
- **Specialist:** security-specialist
- **OWASP:** A03:2021 - Injection
- **File:** includes/search.php line 67
- **Fix Time:** 2 hours
- **Fix:** [details from security-specialist]

### 2. [A11Y] Missing alt text blocks screen readers
- **Specialist:** accessibility-specialist
- **WCAG:** 1.1.1 - Non-text Content
- **File:** templates/homepage.php line 42
- **Fix Time:** 30 minutes
- **Fix:** [details from accessibility-specialist]

### 3. [PERF] 8-second page load exceeds threshold
- **Specialist:** performance-specialist
- **Metric:** LCP 8.2s (Poor, needs <2.5s)
- **File:** includes/post-query.php line 89
- **Fix Time:** 4 hours
- **Fix:** [details from performance-specialist]

---

## Findings by Specialist

### Performance Specialist Report
[Full report from performance-specialist]

### Accessibility Specialist Report
[Full report from accessibility-specialist]

### Security Specialist Report
[Full report from security-specialist]

### Code Quality Specialist Report
[Full report from code-quality-specialist]

---

## Prioritized Remediation Roadmap

**Phase 1: Critical (Before Launch) - 6.5 hours**
1. Fix SQL injection vulnerability (2h)
2. Add missing alt text (0.5h)
3. Optimize database queries (4h)

**Phase 2: High Priority (Week 1) - 12 hours**
4. Fix color contrast issues (2h)
5. Add keyboard navigation (4h)
6. Implement caching strategy (6h)

**Phase 3: Medium Priority (Month 1) - 24 hours**
7. Refactor complex functions (8h)
8. Add comprehensive tests (16h)

**Phase 4: Low Priority (Ongoing) - 40 hours**
9. Code style cleanup (8h)
10. Documentation improvements (32h)

**Total Estimated Effort:** 82.5 hours
```

**Validation Checklist:**
- [ ] Executive summary at top
- [ ] Overall health score (X/100)
- [ ] Critical issues listed first (cross-category)
- [ ] Findings from all 4 specialists included
- [ ] Remediation roadmap with time estimates
- [ ] Prioritization based on impact, not specialist
- [ ] Professional formatting for stakeholders

---

## Test 5.9: Common Output Issues

### Issues to Check For:

**Format Problems:**
- [ ] Missing status indicators
- [ ] No file paths or line numbers
- [ ] Vague recommendations ("improve this")
- [ ] No before/after examples
- [ ] Missing priority levels

**Content Problems:**
- [ ] Generic advice (not CMS-specific)
- [ ] No quantified impact
- [ ] Technical jargon without explanation
- [ ] No actionable steps
- [ ] Missing context

**Structure Problems:**
- [ ] Inconsistent headings
- [ ] Poor markdown formatting
- [ ] Walls of text
- [ ] No prioritization
- [ ] Missing summary

---

## Output Quality Scoring

Rate each agent output on these criteria (1-5 scale):

| Criteria | Score | Notes |
|----------|-------|-------|
| **Clarity** | /5 | Easy to understand? |
| **Actionability** | /5 | Can you fix it from this? |
| **Specificity** | /5 | File/line numbers present? |
| **Prioritization** | /5 | Clear priority levels? |
| **CMS-Relevance** | /5 | CMS-specific guidance? |
| **Examples** | /5 | Before/after code included? |
| **Impact** | /5 | Business/user impact explained? |
| **Professional** | /5 | Stakeholder-ready format? |

**Total Score:** __/40

**Pass Threshold:** 32/40 (80%)

---

## Summary: Output Format Test Results

| Agent | Structure | Specificity | Actions | CMS-Specific | Professional |
|-------|-----------|-------------|---------|--------------|--------------|
| accessibility-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| performance-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| security-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| testing-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| workflow-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| documentation-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| code-quality-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| live-audit-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |

**Pass Criteria:** All checkboxes must be ✅

---

*Test Date: _________*
*Tester: _________*
*Results: _________*
