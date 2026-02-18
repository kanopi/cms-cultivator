# Plan: Make DDEV Setup Process More Robust

## Context

Real-world testing of the devops-setup agent revealed that the DDEV setup flow (steps 4.1d–4.1g) doesn't complete reliably. Several issues were found:

1. **npm install needed** — `ddev theme-install` / `ddev cypress-install` fail when `package-lock.json` is missing (uses `npm ci` which requires a lock file)
2. **Redis never installed** — Steps 4.1f and 4.1g are skipped entirely if the browser check (4.1e) fails, meaning Redis/PAPC modules never get installed
3. **Cypress test users not created** — `ddev cypress-users` is gated on 4.1e+4.1f passing, so it's skipped too
4. **No Cypress e2e.js customization** — Modules like Mailchimp (popup modals) and editoria11y (uncaught JS exceptions) break Cypress tests
5. **Flood table locks out test user** — After failed login attempts, Drupal's flood control blocks subsequent logins
6. **Performance settings** — CSS/JS aggregation and page caching not enabled (add to follow-up checklist)

## File to Modify

- `agents/drupal-pantheon-devops-specialist/AGENT.md`

## Changes

### Change 1: Add npm recovery steps after `ddev init` (Step 4.1d, ~line 637)

After the `ddev init` command and its sequence list, add recovery logic for when theme-install or cypress-install fail due to missing lock files.

**After the existing "Watch for prompts..." paragraph, add:**

```markdown
**If `ddev theme-install` or `ddev cypress-install` fail** (common when `package-lock.json` is missing — `npm ci` requires a lock file):

1. **Check for missing lock file in the theme directory:**
   ```
   Glob(pattern="{theme-path}/package-lock.json")
   ```

2. **If missing, run `npm install` directly on the host** to generate the lock file:
   ```bash
   npm --prefix {theme-path} install
   ```
   Where `{theme-path}` is relative to the project root (e.g., `web/themes/custom/mytheme`).

3. **Re-run theme build:**
   ```bash
   ddev theme-build
   ```

4. **Check for missing lock file in Cypress directory:**
   ```
   Glob(pattern="tests/cypress/package-lock.json")
   ```

5. **If missing, run `npm install` directly on the host** for Cypress:
   ```bash
   npm --prefix tests/cypress install
   ```

6. **Re-run Cypress install via DDEV:**
   ```bash
   ddev cypress-install
   ```
```

### Change 2: Decouple Redis/PAPC install from browser validation (Steps 4.1e/4.1f, ~lines 679–688)

The current flow says "Skip steps 4.1f and 4.1g if the site is not loading." This is wrong — Redis/PAPC should be installed regardless, and test users should be created regardless.

**In step 4.1e (~line 679), replace:**
```
**If the site fails to load:**
- Check `ddev logs` for PHP/webserver errors
- Verify `ddev init` completed without errors
- Check that `settings.php` has correct database connection info
- Report the issue and continue with remaining phases (code changes can proceed without a running site)
- **Skip steps 4.1f and 4.1g** if the site is not loading
```

**With:**
```
**If the site fails to load:**
- Check `ddev logs` for PHP/webserver errors
- Verify `ddev init` completed without errors
- Check that `settings.php` has correct database connection info
- Report the issue but **continue with steps 4.1f and 4.1g** — Redis/PAPC install and Cypress test user creation do not require a working frontend
```

**In step 4.1f (~line 688), replace:**
```
**Only proceed with this step after Chrome DevTools validation passes.**
```

**With:**
```
**Proceed with this step regardless of whether Chrome DevTools validation (4.1e) passed.** Redis and PAPC modules should be installed even if the site isn't loading in the browser — `ddev drush` commands work as long as DDEV is running and Drupal can bootstrap.
```

### Change 3: Decouple Cypress validation from browser check (Step 4.1g, ~line 741)

**Replace:**
```
**Only proceed with this step after steps 4.1e and 4.1f pass.**
```

**With:**
```
**Proceed with this step as long as DDEV is running and Drupal bootstraps** (Gate 4A checks 1-2 passed). Test user creation works independently of browser validation. Only skip the actual Cypress test run if the site is not loading.
```

### Change 4: Add flood table clearing before Cypress tests (Step 4.1g, ~line 745)

**Before the "Run the system checks Cypress test" step, insert a new step:**

```markdown
2. **Clear flood table** to prevent login lockouts from any prior failed attempts:
   ```bash
   ddev drush sql:query "TRUNCATE TABLE flood"
   ```
```

(Renumber subsequent steps.)

### Change 5: Add Cypress e2e.js customization (Step 4.9b, after ~line 1060)

After copying Cypress files from drupal-starter and updating `cypress.config.js`, add a new subsection:

```markdown
#### 4.9c Customize Cypress Support Files

After copying Cypress files, check for modules that require Cypress configuration:

1. **Check for modules with uncaught JS exceptions:**
   ```
   Grep(pattern="editoria11y", path="composer.json")
   ```
   If found, use the `Edit` tool to add an exception handler to `tests/cypress/cypress/support/e2e.js`:
   ```javascript
   // Ignore uncaught exceptions from third-party modules (e.g., editoria11y)
   Cypress.on('uncaught:exception', (err, runnable) => {
     return false;
   });
   ```

2. **Check for popup/modal modules:**
   ```
   Grep(pattern="mailchimp\\|popup\\|newsletter\\|webform_popup", path="composer.json")
   ```
   If found, use the `Edit` tool to add modal dismissal to `tests/cypress/cypress/support/commands.js`:
   ```javascript
   // Dismiss common popups/modals before interacting with the page
   Cypress.Commands.add('dismissPopups', () => {
     cy.get('body').then(($body) => {
       // Close Mailchimp/newsletter popups if present
       const closeSelectors = [
         '.mc-closeModal',
         '.popup-close',
         '[data-dismiss="modal"]',
         '.newsletter-close'
       ];
       closeSelectors.forEach((selector) => {
         if ($body.find(selector).length > 0) {
           cy.get(selector).first().click({ force: true });
         }
       });
     });
   });
   ```
   Then add a `beforeEach` hook in `tests/cypress/cypress/support/e2e.js`:
   ```javascript
   beforeEach(() => {
     cy.dismissPopups();
   });
   ```

3. **Report** any customizations made so the user is aware of site-specific Cypress changes.
```

### Change 6: Strengthen step 4.13 — actually install+enable, don't just verify (Step 4.13, ~line 1138)

The current step 4.13 says "This step only needs to confirm they are present" — but if 4.1f was reached with a non-bootstrapping site, modules may not have been enabled. Make this step always ensure modules are installed AND enabled.

**Replace the entire step 4.13 content with:**

```markdown
### 4.13 Drupal Modules

Ensure `drupal/redis` and `drupal/pantheon_advanced_page_cache` are installed, enabled, and config is exported. Step 4.1f should have handled this, but verify and fix if needed:

1. **Check if modules are installed in composer:**
   ```bash
   ddev composer show drupal/redis
   ```
   If not present:
   ```bash
   ddev composer require drupal/redis
   ```

   ```bash
   ddev composer show drupal/pantheon_advanced_page_cache
   ```
   If not present:
   ```bash
   ddev composer require drupal/pantheon_advanced_page_cache
   ```

2. **Check if modules are enabled:**
   ```bash
   ddev drush pm:list --status=enabled --filter=redis
   ```
   If not enabled:
   ```bash
   ddev drush en redis -y
   ```

   ```bash
   ddev drush pm:list --status=enabled --filter=pantheon_advanced_page_cache
   ```
   If not enabled:
   ```bash
   ddev drush en pantheon_advanced_page_cache -y
   ```

3. **Export configuration** if any modules were newly installed or enabled:
   ```bash
   ddev drush cex -y
   ```

4. **Verify config was exported** — use Grep tool:
   ```
   Grep(pattern="redis", path="config/sync/core.extension.yml")
   Grep(pattern="pantheon_advanced_page_cache", path="config/sync/core.extension.yml")
   ```
```

### Change 7: Expand Gate 4A validation (~line 1792)

Add checks for theme node_modules and Cypress installation.

**Add these rows to the Gate 4A table:**

```
| 5 | Theme node_modules installed | `Glob(pattern="{theme-path}/node_modules/.package-lock.json")` | No |
| 6 | Cypress node_modules installed | `Glob(pattern="tests/cypress/node_modules/.package-lock.json")` | No |
```

**Update the "On warning" text to:**
```
**On warning:** Record Drupal bootstrap, database, or npm install issues. If theme or Cypress node_modules are missing, run the npm recovery steps from 4.1d before proceeding to 4.1e.
```

### Change 8: Add performance settings to verification checklist (Step 5.6, ~line 1571)

In the Manual Follow-Up Tasks list (after the existing items), add:

```markdown
7. **Performance Settings** (if not already configured):
   - Enable CSS/JS aggregation: `ddev drush config:set system.performance js.preprocess 1 -y` and `css.preprocess 1`
   - Enable page caching: `ddev drush config:set system.performance cache.page.max_age 3600 -y`
   - Export config: `ddev drush cex -y`
```

(Renumber the Gulp 3 warning to 8.)

## Verification

After making all changes:
1. Read steps 4.1d through 4.1g to confirm:
   - npm recovery steps are documented after `ddev init`
   - 4.1f is NOT gated on 4.1e passing
   - 4.1g is NOT gated on 4.1e passing (only on DDEV running)
   - Flood table cleared before Cypress test run
2. Read step 4.9c to confirm Cypress e2e.js customization detects modules before adding handlers
3. Read step 4.13 to confirm it always ensures install+enable (not just verify)
4. Read Gate 4A to confirm expanded checks
5. Read step 5.6 to confirm performance settings in follow-up checklist
6. Run `bats tests/test-plugin.bats` to ensure no test regressions
