# Code Quality Audit Export Handler

Transform code quality scan results into Little Task or Epic templates based on complexity.

## Input Format

Code quality scan (PHPCS, ESLint, complexity analysis) with:
- Complexity metrics
- Standards violations
- Code smells
- Refactoring suggestions

## Output Template

Little Task for improvements, Epic for major refactors

## Example Transformation

### Input Finding:

```markdown
### Medium: High Cyclomatic Complexity in checkout.php

**Complexity:** 47 (target: <10)
**File:** `checkout.php`
**Function:** `process_checkout()`

The `process_checkout()` function has 47 cyclomatic complexity (target is < 10), making it difficult to test and maintain. Function is 350 lines with deeply nested conditionals.

**Recommendation:** Refactor into smaller functions with single responsibilities.
```

### Exported Task:

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
