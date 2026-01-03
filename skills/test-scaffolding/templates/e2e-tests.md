# End-to-End (E2E) Test Templates

Complete templates for testing complete user workflows in a real browser.

## When to Use E2E Tests

**E2E Tests** are for user workflows:
- Login/authentication flows
- Multi-step forms
- Content creation workflows
- Admin interfaces
- Shopping cart/checkout
- Critical user journeys

## Cypress Test

```javascript
/**
 * E2E tests for user authentication.
 */

describe('User Authentication', () => {
  beforeEach(() => {
    cy.visit('/');
  });

  it('allows user to login successfully', () => {
    cy.get('[data-test="login-button"]').click();
    cy.url().should('include', '/login');

    cy.get('[name="username"]').type('testuser');
    cy.get('[name="password"]').type('password123');
    cy.get('[type="submit"]').click();

    cy.url().should('include', '/dashboard');
    cy.contains('Welcome, testuser').should('be.visible');
  });

  it('shows error for invalid credentials', () => {
    cy.get('[data-test="login-button"]').click();

    cy.get('[name="username"]').type('wronguser');
    cy.get('[name="password"]').type('wrongpass');
    cy.get('[type="submit"]').click();

    cy.contains('Invalid credentials').should('be.visible');
    cy.url().should('include', '/login');
  });

  it('allows user to logout', () => {
    // Login first
    cy.login('testuser', 'password123');

    // Then logout
    cy.get('[data-test="logout-button"]').click();
    cy.url().should('not.include', '/dashboard');
  });
});
```

## Cypress Custom Commands

```javascript
// cypress/support/commands.js

/**
 * Login command for reusability.
 */
Cypress.Commands.add('login', (username, password) => {
  cy.visit('/login');
  cy.get('[name="username"]').type(username);
  cy.get('[name="password"]').type(password);
  cy.get('[type="submit"]').click();
  cy.url().should('include', '/dashboard');
});

/**
 * Create a test post (WordPress example).
 */
Cypress.Commands.add('createPost', (title, content) => {
  cy.login('admin', 'password');
  cy.visit('/wp-admin/post-new.php');
  cy.get('#title').type(title);
  cy.get('#content').type(content);
  cy.get('#publish').click();
  cy.contains('Post published').should('be.visible');
});

/**
 * Create a test node (Drupal example).
 */
Cypress.Commands.add('createNode', (type, title, body) => {
  cy.login('admin', 'password');
  cy.visit(`/node/add/${type}`);
  cy.get('[name="title[0][value]"]').type(title);
  cy.get('[name="body[0][value]"]').type(body);
  cy.get('#edit-submit').click();
  cy.contains('has been created').should('be.visible');
});
```

## Playwright Test

```javascript
/**
 * E2E tests using Playwright.
 */

import { test, expect } from '@playwright/test';

test.describe('Shopping Cart', () => {
  test('complete purchase flow', async ({ page }) => {
    // Navigate to shop
    await page.goto('/shop');

    // Add items to cart
    await page.click('[data-product="item-1"] .add-to-cart');
    await page.click('[data-product="item-2"] .add-to-cart');

    // Verify cart count
    await expect(page.locator('.cart-count')).toHaveText('2');

    // Go to cart
    await page.click('.cart-link');
    await expect(page).toHaveURL(/.*cart/);

    // Proceed to checkout
    await page.click('.checkout-button');
    await expect(page).toHaveURL(/.*checkout/);

    // Fill checkout form
    await page.fill('[name="email"]', 'test@example.com');
    await page.fill('[name="name"]', 'Test User');
    await page.fill('[name="address"]', '123 Test St');

    // Submit order
    await page.click('.submit-order');

    // Verify success
    await expect(page.locator('.order-success')).toBeVisible();
    await expect(page.locator('.order-number')).toContainText('#');
  });

  test('apply discount code', async ({ page }) => {
    await page.goto('/cart');

    const originalTotal = await page.locator('.total-amount').textContent();

    await page.fill('[name="discount-code"]', 'SAVE10');
    await page.click('.apply-discount');

    await expect(page.locator('.discount-applied')).toBeVisible();

    const newTotal = await page.locator('.total-amount').textContent();
    expect(newTotal).not.toBe(originalTotal);
  });
});
```

## E2E Test Best Practices

### Use Data Attributes for Selectors

✅ **Good** - Stable, semantic selectors:
```javascript
cy.get('[data-test="login-button"]').click();
cy.get('[data-testid="user-profile"]').should('be.visible');
```

❌ **Bad** - Fragile selectors that break with styling changes:
```javascript
cy.get('.btn.btn-primary.login-btn').click();
cy.get('div.container > div.row > button:nth-child(2)').click();
```

### Wait for Elements Properly

```javascript
// Good - Cypress automatically waits
cy.get('[data-test="submit"]').click();

// Also good - Explicit wait when needed
cy.get('[data-test="loading"]', { timeout: 10000 }).should('not.exist');
cy.get('[data-test="content"]').should('be.visible');
```

### Clean Up Test Data

```javascript
beforeEach(() => {
  // Reset database state
  cy.task('db:seed');
});

afterEach(() => {
  // Clean up
  cy.task('db:clean');
});
```

### Test One Thing Per Test

```javascript
// Good - Focused test
it('displays validation error for empty email', () => {
  cy.get('[data-test="email"]').clear();
  cy.get('[data-test="submit"]').click();
  cy.get('[data-test="email-error"]').should('contain', 'Email required');
});

// Bad - Testing too much
it('tests entire form', () => {
  // Tests validation, submission, success message, redirect...
  // If it fails, hard to know what broke
});
```

## Common E2E Test Scenarios

### Multi-Step Forms

```javascript
describe('Multi-step Registration', () => {
  it('completes registration wizard', () => {
    cy.visit('/register');

    // Step 1: Personal info
    cy.get('[name="firstName"]').type('John');
    cy.get('[name="lastName"]').type('Doe');
    cy.get('[data-test="next-step"]').click();

    // Step 2: Contact info
    cy.get('[name="email"]').type('john@example.com');
    cy.get('[name="phone"]').type('555-1234');
    cy.get('[data-test="next-step"]').click();

    // Step 3: Password
    cy.get('[name="password"]').type('SecurePass123!');
    cy.get('[name="confirmPassword"]').type('SecurePass123!');
    cy.get('[data-test="submit"]').click();

    // Verify success
    cy.url().should('include', '/welcome');
    cy.contains('Registration complete').should('be.visible');
  });
});
```

### File Upload

```javascript
it('uploads profile image', () => {
  cy.login('testuser', 'password');
  cy.visit('/profile/edit');

  cy.get('[data-test="avatar-upload"]').attachFile('avatar.jpg');

  cy.get('[data-test="save"]').click();

  cy.get('[data-test="avatar-preview"]')
    .should('have.attr', 'src')
    .and('include', 'avatar.jpg');
});
```

### Drag and Drop

```javascript
it('reorders dashboard widgets', () => {
  cy.login('admin', 'password');
  cy.visit('/dashboard');

  cy.get('[data-widget="widget-1"]')
    .drag('[data-widget="widget-3"]');

  cy.get('[data-test="save-layout"]').click();

  // Verify new order persists after refresh
  cy.reload();
  cy.get('.dashboard-widgets > div')
    .first()
    .should('have.attr', 'data-widget', 'widget-3');
});
```

### Search and Filter

```javascript
it('filters product list', () => {
  cy.visit('/products');

  // Initial count
  cy.get('[data-test="product-card"]').should('have.length', 20);

  // Apply filter
  cy.get('[data-test="category-filter"]').select('Electronics');

  // Verify filtered results
  cy.get('[data-test="product-card"]').should('have.length', 8);
  cy.get('[data-test="product-card"]').each(($card) => {
    cy.wrap($card).should('contain', 'Electronics');
  });
});
```

### Modal Interactions

```javascript
it('opens and closes modal', () => {
  cy.visit('/dashboard');

  // Modal not visible initially
  cy.get('[data-test="confirmation-modal"]').should('not.exist');

  // Open modal
  cy.get('[data-test="delete-button"]').click();
  cy.get('[data-test="confirmation-modal"]').should('be.visible');

  // Cancel
  cy.get('[data-test="cancel"]').click();
  cy.get('[data-test="confirmation-modal"]').should('not.exist');

  // Open again and confirm
  cy.get('[data-test="delete-button"]').click();
  cy.get('[data-test="confirm"]').click();

  cy.contains('Item deleted').should('be.visible');
});
```

## Visual Regression Testing

```javascript
// Using Percy or Cypress screenshot comparison
it('homepage renders correctly', () => {
  cy.visit('/');

  // Take screenshot for comparison
  cy.percySnapshot('Homepage');
  // or
  cy.screenshot('homepage', { capture: 'fullPage' });
});

it('responsive design works', () => {
  cy.viewport('iphone-x');
  cy.visit('/');
  cy.percySnapshot('Homepage - Mobile');

  cy.viewport(1280, 720);
  cy.visit('/');
  cy.percySnapshot('Homepage - Desktop');
});
```

## Accessibility Testing in E2E

```javascript
it('has no accessibility violations', () => {
  cy.visit('/');
  cy.injectAxe(); // Requires cypress-axe

  cy.checkA11y();
});

it('keyboard navigation works', () => {
  cy.visit('/');

  // Tab through interactive elements
  cy.get('body').tab();
  cy.focused().should('have.attr', 'data-test', 'first-link');

  cy.focused().tab();
  cy.focused().should('have.attr', 'data-test', 'second-link');

  // Activate with Enter
  cy.focused().type('{enter}');
  cy.url().should('include', '/second-page');
});
```

## Performance Testing

```javascript
it('loads page within acceptable time', () => {
  cy.visit('/', {
    onBeforeLoad: (win) => {
      win.performance.mark('start');
    },
  });

  cy.window().then((win) => {
    win.performance.mark('end');
    win.performance.measure('pageLoad', 'start', 'end');

    const measure = win.performance.getEntriesByName('pageLoad')[0];
    expect(measure.duration).to.be.lessThan(3000); // Under 3 seconds
  });
});
```

## Tips for Reliable E2E Tests

1. **Use explicit waits**: Wait for specific conditions, not arbitrary timeouts
2. **Make tests independent**: Each test should work in isolation
3. **Use fixtures**: Load consistent test data
4. **Handle async operations**: Wait for network requests, animations
5. **Run in CI/CD**: Automate execution on every commit
6. **Keep tests focused**: Test user journeys, not implementation details
7. **Use Page Objects**: Organize selectors and actions
8. **Mock external services**: Don't rely on third-party APIs in tests
