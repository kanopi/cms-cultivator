---
description: Analyze test coverage and identify untested code paths
allowed-tools: Bash(vendor/bin/phpunit:*), Bash(ddev exec vendor/bin/phpunit:*), Bash(npm:*), Bash(ddev exec npm:*), Bash(ddev cypress-run:*), Bash(ddev cypress-install:*), Bash(ddev critical-run:*), Bash(ddev critical-install:*), Read, Glob, Grep
---

# Test Coverage Analysis

Analyze test coverage for PHP and JavaScript code, identify untested code paths, and generate coverage reports.

## What is Code Coverage?

Code coverage measures which lines of code are executed during test runs. It helps identify:
- Untested code
- Dead code
- Critical paths without tests
- Overall test suite effectiveness

## Coverage Metrics

### Line Coverage
Percentage of code lines executed during tests

### Branch Coverage
Percentage of conditional branches (if/else) tested

### Function Coverage
Percentage of functions/methods called during tests

### Coverage Goals
- **Critical Code**: 100% (authentication, payments, data processing)
- **Business Logic**: 80-90%
- **General Code**: 70-80%
- **UI Code**: 50-70%

## Running Coverage Analysis

### PHP Coverage (PHPUnit)

```bash
# Generate coverage report (HTML)
vendor/bin/phpunit --coverage-html ./coverage

# Generate coverage report (text)
vendor/bin/phpunit --coverage-text

# Generate coverage report (Clover XML for CI)
vendor/bin/phpunit --coverage-clover ./coverage/clover.xml

# Coverage for specific directory
vendor/bin/phpunit --coverage-html ./coverage web/modules/custom/mymodule/tests
```

### JavaScript Coverage (Jest)

```bash
# Run tests with coverage
npm test -- --coverage

# Coverage for specific files
npm test -- --coverage --collectCoverageFrom="src/**/*.js"

# Watch mode with coverage
npm test -- --coverage --watch

# Generate lcov report
npm test -- --coverage --coverageReporters=lcov
```

### JavaScript Coverage (Cypress)

```bash
# Install coverage plugin
npm install --save-dev @cypress/code-coverage

# Run with coverage
npm run cypress:run

# Coverage report in coverage/ directory
```

---

## Kanopi Testing Tools (DDEV Commands)

### End-to-End Testing with Cypress

Kanopi projects include Cypress for E2E testing with DDEV commands:

```bash
# Install Cypress dependencies
ddev cypress-install

# Run all Cypress tests
ddev cypress-run

# Manage test users
ddev cypress-users
```

**Test Coverage Insights from Cypress:**
- **User Flow Coverage**: Which user journeys are tested
- **Feature Coverage**: Which features have E2E tests
- **Integration Coverage**: How components work together
- **Regression Coverage**: What's protected against breaking

**Example Cypress Test Coverage Report:**
```markdown
## Cypress E2E Coverage

**Tests Run**: 45 specs
**Passed**: 43 (95.6%)
**Failed**: 2 (4.4%)

### User Flows Covered:
- ✅ Authentication flow (login, logout, password reset)
- ✅ Content creation (create, edit, publish)
- ✅ Commerce flow (add to cart, checkout, payment)
- ⚠️ Admin settings (partial coverage)
- ❌ Import/export workflow (no coverage)

### Critical Paths Tested:
- User registration → Email verification → First login
- Product browse → Add to cart → Checkout → Order confirmation
- Admin login → Create content → Publish → Verify public view
```

### Performance Testing with Critical

Kanopi projects may include Critical for Critical CSS testing:

```bash
# Install Critical testing tools
ddev critical-install

# Run Critical CSS tests
ddev critical-run
```

**What Critical Tests Cover:**
- **Above-the-fold CSS**: Ensures critical styles load first
- **Render Performance**: Measures initial page render
- **CSS Coverage**: Identifies unused CSS in critical path
- **Load Time Impact**: Tracks performance improvements

**Example Critical Test Report:**
```markdown
## Critical CSS Coverage

**Pages Tested**: 12
**Critical CSS Generated**: 15.2 KB
**Original CSS**: 245 KB
**Reduction**: 93.8%

### Performance Impact:
- First Contentful Paint: 0.8s → 0.3s (62% faster)
- Largest Contentful Paint: 2.1s → 1.2s (43% faster)
- Critical CSS covers 100% of above-the-fold content

### Pages Analyzed:
- ✅ Homepage (critical CSS: 12 KB)
- ✅ Product listing (critical CSS: 14 KB)
- ✅ Article page (critical CSS: 11 KB)
- ✅ Contact form (critical CSS: 9 KB)
```

---

## Comprehensive Test Coverage Strategy

### Multi-Layer Coverage Approach

**1. Unit Tests (PHPUnit/Jest)**
- **Coverage**: Individual functions and methods
- **Run with**: `ddev exec vendor/bin/phpunit --coverage-html ./coverage`
- **Target**: 80%+ coverage for business logic

**2. Integration Tests (PHPUnit/WordPress Tests)**
- **Coverage**: Multiple components working together
- **Run with**: `ddev exec vendor/bin/phpunit --testsuite=integration`
- **Target**: Cover critical integration points

**3. End-to-End Tests (Cypress)**
- **Coverage**: Complete user workflows
- **Run with**: `ddev cypress-run`
- **Target**: Cover all critical user journeys

**4. Performance Tests (Critical)**
- **Coverage**: Critical CSS and render performance
- **Run with**: `ddev critical-run`
- **Target**: All key page templates

### Combined Coverage Report Example

```markdown
# Comprehensive Test Coverage Report

## Coverage by Test Type

| Test Type | Coverage | Tests | Status |
|-----------|----------|-------|--------|
| PHP Unit Tests | 78.5% | 234 passing | 🟢 Good |
| JavaScript Unit Tests | 76.8% | 156 passing | 🟢 Good |
| Cypress E2E Tests | 45 specs | 43 passing | 🟢 Good |
| Critical CSS Tests | 12 pages | All passing | 🟢 Good |

## Coverage Gaps

### Unit Test Gaps
- PaymentProcessor.php: 0% coverage (16h to fix)
- AuthenticationService.php: 42% coverage (12h to fix)

### E2E Test Gaps
- Admin settings workflow (8h to add)
- Import/export functionality (4h to add)

### Performance Test Gaps
- Blog archive pages (2h to add)
- Search results page (2h to add)

## Action Plan

**Week 1**: Add unit tests for PaymentProcessor and AuthenticationService (28h)
**Week 2**: Add E2E tests for admin workflows (12h)
**Week 3**: Add Critical CSS tests for missing pages (4h)

**Total Effort**: 44 hours
**Timeline**: 3 weeks
```

---

## Analyzing Coverage Reports

### Reading PHPUnit Coverage

**HTML Report** (`./coverage/index.html`):
```
Code Coverage Report
────────────────────────────────────────────────────────────
Module: mymodule                           Coverage: 78.5%
────────────────────────────────────────────────────────────
Classes                                    100%  (15/15)
Methods                                     95%  (76/80)
Lines                                       78%  (892/1137)
────────────────────────────────────────────────────────────

Low Coverage Files:
  src/Service/DataProcessor.php            42%  (critical!)
  src/Controller/ApiController.php         55%
  src/EventSubscriber/UserSubscriber.php   68%
```

**Text Report**:
```bash
Code Coverage Report:
  2024-01-15 10:30:00

 Summary:
  Classes: 100.00% (15/15)
  Methods:  95.00% (76/80)
  Lines:    78.46% (892/1137)

\Drupal\mymodule::Service
  DataProcessor
    Methods:  50.00% (2/4)
    Lines:    42.31% (55/130)    ⚠️  LOW COVERAGE

  EmailValidator
    Methods: 100.00% (3/3)
    Lines:    98.50% (66/67)     ✓  GOOD

\Drupal\mymodule::Controller
  ApiController
    Methods:  80.00% (4/5)
    Lines:    55.20% (142/257)   ⚠️  LOW COVERAGE
```

### Reading Jest Coverage

```
---------------------------|---------|----------|---------|---------|
File                       | % Stmts | % Branch | % Funcs | % Lines |
---------------------------|---------|----------|---------|---------|
All files                  |   76.82 |    68.42 |   81.25 |   77.14 |
 js                        |   76.82 |    68.42 |   81.25 |   77.14 |
  api.js                   |   42.50 |    25.00 |   50.00 |   42.50 | ⚠️
  auth.js                  |   95.00 |    87.50 |  100.00 |   95.00 | ✓
  utils.js                 |   88.24 |    75.00 |   90.00 |   88.89 | ✓
  validation.js            |   60.00 |    50.00 |   66.67 |   60.00 | ⚠️
---------------------------|---------|----------|---------|---------|

Uncovered Lines:
  api.js: 23-45, 67-89
  validation.js: 12, 34-45, 78
```

## Identifying Untested Code

### 1. Critical Paths Without Tests

**Look for:**
- Authentication/authorization code
- Payment processing
- Data deletion/modification
- Security-sensitive operations

```php
// CRITICAL - NO TESTS!
class PaymentProcessor {
  public function processPayment($amount, $card) {
    // 0% coverage - HIGH RISK!
    $charge = $this->stripe->charges->create([
      'amount' => $amount,
      'currency' => 'usd',
      'source' => $card,
    ]);
    return $charge->id;
  }
}
```

### 2. Complex Functions Without Tests

Look for high cyclomatic complexity:

```php
// Complexity: 15 - NO TESTS!
public function calculateShipping($items, $destination, $options) {
  // Multiple nested if/else statements
  // Multiple loops
  // Complex business logic
  // 0% branch coverage - HIGH RISK!
}
```

### 3. Error Handling Not Tested

```php
public function fetchData($url) {
  try {
    return $this->client->get($url);
  } catch (Exception $e) {
    // Exception path never tested - 0% coverage
    $this->logger->error($e->getMessage());
    return NULL;
  }
}
```

### 4. Edge Cases Not Covered

```javascript
function divide(a, b) {
  return a / b;  // What about b = 0? Not tested!
}

function getUser(id) {
  return users[id];  // What about invalid ID? Not tested!
}
```

## Coverage Analysis Report

Generate comprehensive coverage analysis:

```markdown
# Test Coverage Analysis Report

**Project**: MyProject
**Date**: 2024-01-15
**Overall Coverage**: 78.5%

## Summary

| Metric | Coverage | Status |
|--------|----------|--------|
| **PHP Code** | 78.5% | 🟡 Good |
| **JavaScript** | 76.8% | 🟡 Good |
| **Critical Paths** | 45.0% | 🔴 **URGENT** |

## Critical Issues

### 🔴 CRITICAL: Payment Processing Untested

**File**: `src/Service/PaymentProcessor.php`
**Coverage**: 0%
**Risk**: High - handles money

**Untested Functions**:
- `processPayment()` - No tests for payment processing
- `refundPayment()` - No tests for refunds
- `validateCard()` - No tests for validation

**Recommendation**:
- Add unit tests for all payment functions
- Add integration tests with Stripe test mode
- Test error cases (declined cards, network failures)
- **Priority**: URGENT - Complete by end of week

**Estimated Effort**: 16 hours

---

### 🔴 CRITICAL: User Authentication Low Coverage

**File**: `src/Service/AuthenticationService.php`
**Coverage**: 42%
**Risk**: High - security-sensitive

**Untested Code Paths**:
- Lines 45-67: Two-factor authentication flow
- Lines 89-102: Password reset token validation
- Lines 123-145: OAuth provider integration

**Missing Tests**:
- ❌ Test invalid 2FA codes
- ❌ Test expired reset tokens
- ❌ Test OAuth failures
- ❌ Test rate limiting

**Recommendation**:
- Add tests for all authentication paths
- Test security edge cases
- Test failure scenarios
- **Priority**: URGENT - Complete this sprint

**Estimated Effort**: 12 hours

---

## High Priority Issues

### 🟠 API Controller Low Coverage

**File**: `src/Controller/ApiController.php`
**Coverage**: 55%
**Risk**: Medium - public API

**Untested Endpoints**:
- `POST /api/users` - User creation (45% coverage)
- `DELETE /api/users/{id}` - User deletion (0% coverage)
- `PUT /api/users/{id}` - User update (60% coverage)

**Missing Tests**:
- Input validation edge cases
- Authentication/authorization checks
- Error response formats
- Rate limiting

**Recommendation**: Add integration tests for all endpoints

**Estimated Effort**: 8 hours

---

## Coverage by Category

### Critical Code (Target: 100%)
| Component | Coverage | Status |
|-----------|----------|--------|
| Payment Processing | 0% | 🔴 Critical |
| Authentication | 42% | 🔴 Critical |
| User Authorization | 68% | 🟠 Needs Work |
| Data Encryption | 95% | 🟢 Good |

### Business Logic (Target: 80%)
| Component | Coverage | Status |
|-----------|----------|--------|
| User Management | 78% | 🟡 Acceptable |
| Content Management | 85% | 🟢 Good |
| Search | 72% | 🟡 Acceptable |
| Notifications | 55% | 🟠 Needs Work |

### UI Code (Target: 50%)
| Component | Coverage | Status |
|-----------|----------|--------|
| Forms | 65% | 🟢 Good |
| Components | 48% | 🟡 Acceptable |
| Utilities | 88% | 🟢 Excellent |

---

## Uncovered Lines by File

### PHP (Lines requiring tests)

**src/Service/PaymentProcessor.php** (0% coverage):
```
Lines 15-45: processPayment()
Lines 50-78: refundPayment()
Lines 82-95: validateCard()
```

**src/Service/AuthenticationService.php** (42% coverage):
```
Lines 45-67: Two-factor authentication
Lines 89-102: Password reset validation
Lines 123-145: OAuth integration
```

**src/Controller/ApiController.php** (55% coverage):
```
Lines 234-267: User deletion endpoint
Lines 301-324: Bulk operations
Lines 356-389: Error handling
```

### JavaScript (Lines requiring tests)

**js/api.js** (42.5% coverage):
```
Lines 23-45: Authentication error handling
Lines 67-89: Retry logic
Lines 112-134: Response parsing
```

**js/validation.js** (60% coverage):
```
Lines 12: Edge case for email validation
Lines 34-45: Password strength validation
Lines 78: Custom validation rules
```

---

## Recommended Actions

### Immediate (This Week)
1. ✅ Add tests for PaymentProcessor (16 hours)
2. ✅ Improve AuthenticationService coverage to 80%+ (12 hours)
3. ✅ Add tests for API user deletion endpoint (4 hours)

### Short-term (This Sprint)
1. Add tests for uncovered authentication paths
2. Improve ApiController to 75%+ coverage
3. Add tests for notification system
4. Review and test error handling

### Long-term (Next Quarter)
1. Establish coverage requirements for new code (80% minimum)
2. Add coverage checks to CI/CD pipeline
3. Schedule monthly coverage reviews
4. Improve UI test coverage

---

## Coverage Trends

| Month | Overall | PHP | JavaScript |
|-------|---------|-----|------------|
| Oct   | 65.2%   | 68% | 62%        |
| Nov   | 71.4%   | 72% | 70%        |
| Dec   | 75.8%   | 76% | 75%        |
| **Jan** | **78.5%** | **78.5%** | **76.8%** |

📈 **Trend**: Improving (+12.3% over 3 months)

---

## CI/CD Integration

Add coverage requirements to CI:

**GitHub Actions:**
```yaml
- name: Run tests with coverage
  run: |
    vendor/bin/phpunit --coverage-clover coverage.xml
    npm test -- --coverage

- name: Check coverage thresholds
  run: |
    php tools/check-coverage.php coverage.xml 70
    # Fail if coverage below 70%
```

**Coverage Badges:**
```markdown
![Coverage](https://img.shields.io/badge/coverage-78.5%25-yellow.svg)
```

---

## Tools & Resources

**PHP Coverage:**
- [PHPUnit Coverage](https://phpunit.de/manual/current/en/code-coverage-analysis.html)
- [PCOV](https://github.com/krakjoe/pcov) - Fast coverage driver
- [Xdebug](https://xdebug.org/) - Coverage and debugging

**JavaScript Coverage:**
- [Jest Coverage](https://jestjs.io/docs/configuration#collectcoverage-boolean)
- [Istanbul](https://istanbul.js.org/) - Coverage tool
- [Cypress Coverage](https://docs.cypress.io/guides/tooling/code-coverage)

**Coverage Services:**
- [Codecov](https://codecov.io/)
- [Coveralls](https://coveralls.io/)
- [Scrutinizer](https://scrutinizer-ci.com/)

---

**Next Review**: 2024-02-15
**Goal**: 85% overall coverage
```

## Best Practices

1. **Track Trends** - Monitor coverage over time
2. **Set Thresholds** - Require minimum coverage for new code
3. **Focus on Critical** - Prioritize high-risk code
4. **Branch Coverage** - Don't just test lines, test paths
5. **Don't Game Coverage** - 100% coverage ≠ good tests
6. **Review Regularly** - Monthly coverage reviews
7. **CI Integration** - Fail builds below threshold
8. **Visualize** - Use badges and reports

## Deliverables

1. **Coverage Report** (HTML/PDF)
2. **Critical Issues List** (prioritized)
3. **Action Plan** (with estimates)
4. **Trend Analysis** (historical data)
5. **CI Configuration** (automated checks)
