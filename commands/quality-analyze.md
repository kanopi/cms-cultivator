---
description: Analyze code quality (refactoring, complexity, technical debt)
argument-hint: [focus]
allowed-tools: Read, Glob, Grep, Bash(composer:*), Bash(ddev composer:*), Bash(vendor/bin/*:*), Bash(ddev exec vendor/bin/*:*), Bash(npm:*), Bash(ddev exec npm:*)
---

# Code Quality Analysis

Analyze code quality including refactoring opportunities, complexity metrics, and technical debt assessment.

## Usage

- `/quality-analyze` - Run all quality analyses (refactor, complexity, debt)
- `/quality-analyze refactor` - Identify refactoring opportunities only
- `/quality-analyze complexity` - Analyze code complexity only
- `/quality-analyze debt` - Assess technical debt only

## Quick Start (Kanopi Projects)

### Drupal - Run All Quality Checks
```bash
# Single command runs: phpstan + rector + code-sniff
ddev composer code-check

# For detailed analysis
ddev composer phpstan      # Static analysis
ddev composer rector-check # Modernization opportunities
ddev composer code-sniff   # Coding standards
ddev composer twig-lint    # Twig template quality
```

### WordPress - Run All Quality Checks
```bash
# Run each tool individually
ddev composer phpstan       # Static analysis
ddev composer rector-check  # Modernization opportunities
ddev composer phpcs         # Coding standards
```

### Using Kanopi Tools for Quality Analysis

**PHPStan (Static Analysis):**
```bash
# Drupal/WordPress: Analyze custom code
ddev composer phpstan

# CI version with JUnit output
ddev composer phpstan-ci  # → phpstan-report.xml
```

**Rector (Modernization Check):**
```bash
# Drupal: Check modules AND themes
ddev composer rector-check

# WordPress: Check plugins AND themes
ddev composer rector-check

# Check specific areas
ddev composer rector-modules  # Drupal modules only
ddev composer rector-themes   # Themes only
ddev composer rector-plugins  # WordPress plugins only
```

**Apply Fixes:**
```bash
# Drupal: Fix everything
ddev composer code-fix      # Fixes code standards + applies rector

# WordPress: Apply rector fixes
ddev composer rector-fix

# Fix specific areas
ddev composer rector-fix-modules  # Drupal modules
ddev composer rector-fix-themes   # Themes
ddev composer rector-fix-plugins  # WordPress plugins
```

---

## Analysis Types

### 1. Refactoring Opportunities (`refactor`)

Identify code smells and refactoring opportunities.

**Code Smells Detected:**
- Long methods (>50 lines)
- Large classes (too many responsibilities)
- Duplicated code (copy-paste)
- Long parameter lists (>4-5 parameters)
- Complex conditionals (deeply nested if/else)
- Dead code (unused functions/variables)
- Magic numbers (hardcoded values)

**Example Output:**

```markdown
# Refactoring Opportunities

## Summary
- Code Smells Found: 23
- High Priority: 8
- Medium Priority: 12
- Low Priority: 3

## High Priority Refactoring

### 1. Long Method: OrderController::processCheckout()
**File**: `src/Controller/OrderController.php:123`
**Lines**: 189
**Complexity**: 28
**Priority**: High

**Issue**: Method is too long and does too many things

**Responsibilities**:
- Payment processing
- Inventory update
- Email notifications
- Logging
- Analytics tracking

**Recommendation**: Extract each responsibility into separate methods

**Before**:
```php
public function processOrder($orderId) {
  // 189 lines of code doing everything
  $order = $this->loadOrder($orderId);

  // Payment processing (40 lines)
  $payment = $this->stripe->charge(...);

  // Inventory update (30 lines)
  foreach ($order->getItems() as $item) {
    $this->updateInventory($item);
  }

  // Email notifications (45 lines)
  $this->mailer->send(...);

  // Continue for 189 lines...
}
```

**After**:
```php
public function processOrder($orderId) {
  $order = $this->loadOrder($orderId);
  $this->processPayment($order);
  $this->updateInventory($order);
  $this->sendNotifications($order);
  $this->logOrderCompletion($order);
  $this->trackAnalytics($order);
  return $order;
}

private function processPayment(Order $order) {
  // 40 lines focused on payment
}

private function updateInventory(Order $order) {
  // 30 lines focused on inventory
}
// etc...
```

**Effort**: 4 hours
**Benefit**: Easier to test, maintain, and debug

---

### 2. Duplicated Code
**Locations**:
- `UserService.php:45-67`
- `AdminController.php:123-145`
- `ApiController.php:234-256`

**Duplicated Block**:
```php
// Appears 3 times with slight variations
$user = User::load($uid);
if ($user && $user->isActive() && $user->hasPermission('edit')) {
  // Do something
}
```

**Recommendation**: Extract to method

```php
class PermissionChecker {
  public function userCanEdit($uid): bool {
    $user = User::load($uid);
    return $user && $user->isActive() && $user->hasPermission('edit');
  }
}

// Usage
if ($this->permissionChecker->userCanEdit($uid)) {
  // Do something
}
```

**Effort**: 2 hours
**Benefit**: DRY principle, single source of truth

---

[Continue with all refactoring opportunities...]
```

See full documentation in original `/quality-refactor.md`

---

### 2. Code Complexity (`complexity`)

Analyze cyclomatic complexity, cognitive complexity, and maintainability.

**Complexity Metrics:**

- **Cyclomatic Complexity**: Number of linearly independent paths
  - 1-10: Simple, low risk
  - 11-20: Moderate complexity
  - 21-50: High complexity, refactor recommended
  - 50+: Very high risk, must refactor

- **Cognitive Complexity**: How difficult code is to understand

- **Maintainability Index**: Combined metric (0-100)
  - 85-100: Good maintainability
  - 65-84: Moderate maintainability
  - 0-64: Low maintainability

**Example Output:**

```markdown
# Code Complexity Analysis

## Summary
- Average Complexity: 8.5 (✓ Good)
- Maintainability Index: 72 (Moderate)
- High Complexity Functions: 12
- Functions Needing Refactoring: 8

## High Complexity Functions (Cyclomatic > 20)

### 1. DataProcessor::validateInput()
**File**: `src/Service/DataProcessor.php:45`
**Cyclomatic Complexity**: 35 (⚠️ HIGH RISK)
**Cognitive Complexity**: 42
**Parameters**: 8
**Lines**: 145
**Maintainability**: Low (45/100)

**Issue**: Too many nested conditions and parameters

**Code Structure**:
```php
public function validateInput($data, $type, $required, $options,
                               $context, $user, $timestamp, $locale) {
  if ($type === 'email') {
    if (!filter_var($data, FILTER_VALIDATE_EMAIL)) {
      if ($required) {
        if ($options['strict']) {
          if ($context === 'registration') {
            // More nesting...
          }
        }
      }
    }
  } elseif ($type === 'phone') {
    // More conditions...
  }
  // 100+ more lines...
}
```

**Recommendation**:
1. Break into smaller methods per validation type
2. Use strategy pattern for different validators
3. Reduce parameters with ValidationRequest object

**Refactored**:
```php
// Complexity: 3
public function validateInput(ValidationRequest $request): ValidationResult {
  $validator = $this->getValidator($request->getType());
  return $validator->validate($request);
}
```

**Effort**: 8 hours
**Impact**:
- Complexity: 35 → 3 (91% reduction)
- Maintainability: 45 → 85 (89% improvement)
- Test coverage: Easier to test individual validators

---

[Continue with all high complexity functions...]

## Complexity Distribution

| Complexity Range | Count | Percentage |
|-----------------|-------|------------|
| 1-10 (Simple) | 245 | 82% |
| 11-20 (Moderate) | 42 | 14% |
| 21-50 (High) | 10 | 3% |
| 50+ (Very High) | 2 | 1% |

## Maintainability Trends

| Month | Avg Complexity | Maintainability |
|-------|----------------|-----------------|
| Oct | 10.2 | 68 |
| Nov | 9.5 | 70 |
| Dec | 8.9 | 71 |
| Jan | 8.5 | 72 |

📈 Trend: Improving
```

**Tools Used:**
- PHPMetrics
- PHPMD (PHP Mess Detector)
- ESComplex (JavaScript)

See full documentation in original `/quality-complexity.md`

---

### 3. Technical Debt (`debt`)

Assess technical debt including TODOs, FIXMEs, deprecated code, and legacy patterns.

**Debt Categories:**
- Code Debt (TODOs, FIXMEs, hacks)
- Design Debt (poor architecture)
- Documentation Debt (missing docs)
- Test Debt (low coverage)
- Dependency Debt (outdated packages)

**Example Output:**

```markdown
# Technical Debt Assessment

## Summary
**Total Debt**: 520 hours (13 weeks)

| Category | Items | Hours | Priority |
|----------|-------|-------|----------|
| Code Debt | 145 | 180h | High |
| Design Debt | 23 | 240h | Medium |
| Documentation | 89 | 45h | Low |
| Test Debt | 12 | 40h | High |
| Dependencies | 8 | 15h | High |

## Critical Items

### 1. Payment Processing Has No Tests
**Type**: Test Debt
**File**: `src/Service/PaymentProcessor.php`
**Risk**: Critical - handles money
**Effort**: 16 hours
**Priority**: 🔴 URGENT

**Issue**: Zero test coverage for payment processing logic

**Impact**:
- Can't safely refactor
- Bugs could cost money
- PCI compliance risk

**Recommendation**:
- Add unit tests (8h)
- Add integration tests with Stripe test mode (8h)

---

### 2. 145 TODO Comments

**Breakdown**:
- Security-related: 12 TODOs (24h) - 🔴 Critical
- Performance: 23 TODOs (30h) - 🟠 High
- Bug fixes: 34 TODOs (40h) - 🟠 High
- Features: 76 TODOs (26h) - 🟡 Medium

**Top 5 Critical TODOs**:

1. `src/Service/AuthService.php:45`
   ```php
   // TODO: Add rate limiting to prevent brute force
   ```
   **Risk**: Security vulnerability
   **Effort**: 4h

2. `src/Controller/ApiController.php:123`
   ```php
   // TODO: Add input sanitization
   ```
   **Risk**: XSS vulnerability
   **Effort**: 3h

[Continue with TODO analysis...]

## Deprecated Code

**Found**: 23 uses of deprecated APIs

1. Symfony 4 deprecated code (will break on upgrade to 6)
   - `GetResponseEvent` → use `RequestEvent`
   - Found in 12 files
   - Effort: 24 hours

2. Drupal deprecated functions
   - `drupal_set_message()` → use Messenger service
   - Found in 8 files
   - Effort: 8 hours

## Dead Code

**Found**: 34 unused functions/classes

- `LegacyProcessor.php` - Not called anywhere (last used 2 years ago)
- `oldHelper()` function - Replaced but not removed
- `TemporaryFix` class - No longer needed

**Recommendation**: Remove dead code (reduces confusion)
**Effort**: 4 hours

## Debt Trends

| Quarter | Total Hours | Trend |
|---------|-------------|-------|
| 2024-Q1 | 521h | - |
| 2024-Q2 | 547h | 📈 +5% |
| 2024-Q3 | 591h | 📈 +8% |
| 2024-Q4 | 680h | 📈 +15% |

⚠️ **Warning**: Technical debt increasing 5-15% per quarter

## Action Plan

### Sprint 1 (2 weeks)
- Add tests for PaymentProcessor (16h)
- Fix 12 security-related TODOs (24h)
- Update deprecated Symfony code (24h)
**Total**: 64 hours

### Quarter 2
- Refactor architecture (80h)
- Address remaining TODOs (50h)
- Add documentation (24h)
**Total**: 154 hours

## ROI of Debt Paydown

**Investment**: 520 hours over 6 months
**Benefits**:
- Reduced bug rate (est. -40%)
- Faster feature development (est. +30%)
- Easier onboarding (est. -50% ramp time)

**Payback Period**: 9-12 months
```

See full documentation in original `/quality-debt.md`

---

## Running All Analyses

When run without arguments, executes all three analyses:

```bash
/quality-analyze
```

**Combined Report:**

```markdown
# Code Quality Analysis Report

**Date**: 2024-01-15

## Executive Summary

| Analysis | Score | Issues | Priority |
|----------|-------|--------|----------|
| Refactoring | 🟡 Good | 23 smells | Medium |
| Complexity | 🟢 Good | 12 high | Low |
| Technical Debt | 🔴 High | 520h | High |

## Top 5 Quality Issues

1. **Technical Debt** - 520 hours, growing 15%/quarter
2. **Payment processing** - No tests, high complexity (35)
3. **145 TODO comments** - 12 security-related
4. **Deprecated code** - 23 uses, will break on upgrade
5. **Long methods** - 8 methods >100 lines

## Recommendations

### Immediate (This Sprint)
- Add tests for PaymentProcessor
- Fix security TODOs
- Refactor high complexity functions

### Short-term (This Quarter)
- Address technical debt backlog
- Update deprecated code
- Improve architecture

**Estimated Effort**: 218 hours over 3 months
**Expected ROI**: 9-12 month payback
```

## Integration with Other Commands

**Quality Workflow:**

```bash
# Analyze quality
/quality-analyze                # Identify all issues

# Check standards
/quality-standards             # Run PHPCS/ESLint

# Generate tests for uncovered code
/test-generate                 # Add missing tests

# Run tests
/test-coverage                 # Verify coverage improved
```

## Best Practices

1. **Regular Analysis** - Run `/quality-analyze` monthly
2. **Track Trends** - Monitor improvement over time
3. **Address Critical First** - Fix security/payment code first
4. **Prevent New Debt** - Code review for quality
5. **Allocate Time** - 20% of sprint to quality/debt
6. **CI Integration** - Fail builds on complexity thresholds

## Resources

- [Refactoring Guru](https://refactoring.guru/)
- [Martin Fowler - Refactoring](https://refactoring.com/)
- [PHPMetrics](https://phpmetrics.github.io/website/)
- [Cognitive Complexity](https://www.sonarsource.com/docs/CognitiveComplexity.pdf)
- [Technical Debt Quadrant](https://martinfowler.com/bliki/TechnicalDebtQuadrant.html)
