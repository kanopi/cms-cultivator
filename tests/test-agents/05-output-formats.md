# Test 05: Agent Output Format Validation

**Category:** Output Quality & Consistency
**Purpose:** Verify agents produce correctly formatted, actionable output
**Focus:** Report structure, code examples, prioritization, CMS-specificity

> **Note:** As of 2.0 the audit specialists moved to separate internal Kanopi
> libraries; their output-format tests were removed from this suite.

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

## Test 5.2: Testing Specialist Output

### Test 5.2.1: Test Suite Format

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
- [ ] Security-focused and accessibility-focused scenarios generated inline (when the code warrants them)

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
- [ ] Inline security/a11y scenarios integrated into the suite (not delegated)

---

## Test 5.3: Documentation Specialist Output

### Test 5.3.1: API Documentation Format

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

## Test 5.4: Design Pipeline Output

### Test 5.4.1: Design Specialist Structured Output

**Test Procedure:**
```
User: Run /design-to-wp-block [figma-url]
```

**Required Output Elements:**
- [ ] Generated file paths (block pattern or paragraph type files)
- [ ] SCSS paths for the styling step
- [ ] Design specs (colors, typography, spacing — exact values)
- [ ] Test URL for browser validation

**Expected Format:**
```markdown
## Design Implementation Complete

**Files Created:**
- patterns/hero-banner.php
- assets/scss/components/_hero-banner.scss (stub — styled in Step 2)

**Design Specs:**
- Primary color: #1A365D
- Heading: 48px/1.2 "Inter" bold (32px mobile)
- Section padding: 96px desktop / 48px mobile

**Test URL:** http://project.ddev.site/?p=123
```

---

### Test 5.4.2: Responsive Styling Specialist Output

**Required Output Elements:**
- [ ] Mobile-first SCSS with breakpoints (768px, 1024px)
- [ ] WCAG AA contrast-compliant color values
- [ ] Touch targets ≥44px and focus indicators
- [ ] Reduced motion support
- [ ] Exact technical values (no vague "adjust spacing")

---

### Test 5.4.3: Browser Validator Specialist Report

**Required Output Elements:**
- [ ] Pass/fail per breakpoint (320px, 768px, 1024px)
- [ ] WCAG AA results (contrast ratios, keyboard navigation, ARIA)
- [ ] Console errors found (or confirmed clean)
- [ ] Specific remediation steps with file paths

**Expected Format:**
```markdown
## Browser Validation Report

**Status:** ⚠️ Issues Found

| Breakpoint | Layout | A11y | Console |
|------------|--------|------|---------|
| 320px      | ✅     | ⚠️   | ✅      |
| 768px      | ✅     | ✅   | ✅      |
| 1024px     | ✅     | ✅   | ✅      |

**Issues:**
1. [HIGH] Button contrast 3.9:1 at 320px (needs 4.5:1)
   - File: assets/scss/components/_hero-banner.scss line 24
   - Fix: Darken $btn-bg from #6B7280 to #4B5563
```

---

## Test 5.5: Drupal.org Specialist Output

### Test 5.5.1: Issue Specialist Format

**Test Procedure:**
```
User: Help me create a drupal.org issue for this bug
```

**Required Output Elements:**
- [ ] Issue title following drupal.org conventions
- [ ] Problem/Motivation section
- [ ] Steps to reproduce
- [ ] Proposed resolution
- [ ] Metadata guidance (project, version, component, category, priority)

---

### Test 5.5.2: MR Specialist Format

**Test Procedure:**
```
User: Create a merge request for this fix on drupal.org
```

**Required Output Elements:**
- [ ] Issue-fork branch name (e.g., `1234567-fix-null-pointer`)
- [ ] Exact git commands for git.drupalcode.org (clone, branch, push)
- [ ] Clear callout of the manual issue-fork creation step
- [ ] MR description content referencing the issue

---

## Test 5.6: Common Output Issues

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
| testing-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| documentation-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| design-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| responsive-styling-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| browser-validator-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| drupalorg-issue-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |
| drupalorg-mr-specialist | ☐ | ☐ | ☐ | ☐ | ☐ |

**Pass Criteria:** All checkboxes must be ✅

---

*Test Date: _________*
*Tester: _________*
*Results: _________*
