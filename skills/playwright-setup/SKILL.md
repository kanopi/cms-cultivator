---
name: playwright-setup
description: Scaffold Playwright end-to-end testing on a Kanopi Drupal + Pantheon project running in DDEV. Creates the root runner (package.json, playwright.config.ts), a tests/e2e tree with Drupal login/global-setup and starter specs, wires a CircleCI job that runs against the PR multidev, and pulls the playwright-* DDEV commands from the kanopi/ddev-kanopi-drupal add-on. Invoke when the user says "add Playwright", "set up Playwright", "Playwright e2e", "browser tests for this Drupal site", or uses /playwright-setup.
---

# Playwright Setup (Drupal + Pantheon + DDEV)

Scaffold a working Playwright e2e suite on a Kanopi Drupal project: runnable locally
against DDEV and in CircleCI against the PR's Pantheon multidev. This mirrors the
proven setup on `amca` (WordPress) and `smalley` (Drupal).

For WordPress projects, the shape is identical but the login form, user-creation
commands, and REST checks differ — adapt `/user/login` → `wp-login.php`, `drush
user:create` → `wp user create`, and use `wp-json` for the API smoke test.

## ⚠️ Side Effect Warning

Creates/modifies files and adds a CircleCI job. Nothing is irreversible, but it
touches shared `.circleci/config.yml`. Confirm before committing/pushing.

## Prerequisites

- DDEV project (Drupal 8+), reachable at `https://<PROJECT>.ddev.site`
- `kanopi/ddev-kanopi-drupal` add-on **v1.5.1+** installed (ships the `playwright-*`
  DDEV commands)
- CircleCI already deploying PR branches to Pantheon multidev (the `cypress` job
  pattern is the model to copy)
- Node available on the host (via NVM, as the DDEV commands expect)

## Per-project variables

Only these change between projects — everything else is copy-paste:

- `<PROJECT>` — DDEV project name / site slug (e.g. `smalley`); base URL is
  `https://<PROJECT>.ddev.site`
- Test-user roles — Drupal Standard profile ships `administrator` and
  `content_editor`; adjust if the site renamed them (`ddev drush role:list`)

## Quick Start (Kanopi projects)

```bash
# 1. Ensure the add-on (which provides the playwright-* commands) is current
ddev add-on get kanopi/ddev-kanopi-drupal
ddev restart

# 2. Scaffold the files below (this skill creates them)

# 3. Install + create users + run
ddev playwright-install     # npm install + browser download (one-time)
ddev playwright-users       # creates the `playwright` admin user via drush
ddev playwright-run         # runs the suite against the local DDEV URL
```

The three `playwright-*` commands come from the add-on with the `#ddev-generated`
marker — do **not** author project-local copies; let the add-on manage them.

## Files to create

### `package.json` (project root)

```json
{
  "name": "<PROJECT>-e2e-tests",
  "version": "1.0.0",
  "private": true,
  "scripts": {
    "test:e2e": "playwright test",
    "test:e2e:headed": "playwright test --headed",
    "test:e2e:debug": "playwright test --debug",
    "test:e2e:ui": "playwright test --ui",
    "test:e2e:report": "playwright show-report",
    "test:e2e:codegen": "playwright codegen"
  },
  "devDependencies": {
    "@axe-core/playwright": "^4.11.1",
    "@playwright/test": "^1.60.0",
    "@types/node": "^20.11.0",
    "axe-core": "^4.11.2",
    "dotenv": "^16.4.0"
  }
}
```

### `playwright.config.ts` (project root)

Chromium-only in CI/by default; full desktop+mobile matrix via `ALL_BROWSERS=1`.
**The `Deterrence-Bypass` header is required** — Pantheon dev/multidev serve a
"Sandbox Environment Notice" interstitial to browsers that otherwise hides the
page from headless Chromium.

```ts
import { defineConfig, devices } from '@playwright/test';
import * as dotenv from 'dotenv';
import { config } from './tests/e2e/utils/config';

dotenv.config({ path: '.env.playwright' });

const baseURL = config.baseURL;

export default defineConfig({
  testDir: './tests/e2e/specs',
  globalSetup: './tests/e2e/global-setup.ts',
  fullyParallel: true,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  workers: process.env.CI ? 1 : undefined,
  timeout: 90000,
  expect: { timeout: 10000 },
  globalTimeout: process.env.CI ? 1200000 : undefined,
  reporter: [
    ['list'],
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['json', { outputFile: 'test-results/results.json' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
    process.env.CI ? ['github'] : ['null']
  ].filter(Boolean),
  outputDir: 'test-results',
  use: {
    baseURL,
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    video: process.env.CI ? 'retain-on-failure' : 'on',
    ignoreHTTPSErrors: true,
    navigationTimeout: 30000,
    actionTimeout: 15000,
    // Bypass Pantheon's "Sandbox Environment Notice" gate. Harmless on DDEV.
    extraHTTPHeaders: { 'Deterrence-Bypass': '1' }
  },
  projects: process.env.CI || !process.env.ALL_BROWSERS ? [
    { name: 'chromium', use: { ...devices['Desktop Chrome'], viewport: { width: 1920, height: 1080 } } }
  ] : [
    { name: 'chromium', use: { ...devices['Desktop Chrome'], viewport: { width: 1920, height: 1080 } } },
    { name: 'firefox', use: { ...devices['Desktop Firefox'], viewport: { width: 1920, height: 1080 } } },
    { name: 'webkit', use: { ...devices['Desktop Safari'], viewport: { width: 1920, height: 1080 } } },
    { name: 'Mobile Chrome', use: { ...devices['Pixel 5'], viewport: { width: 393, height: 851 } } },
    { name: 'Mobile Safari', use: { ...devices['iPhone 12'], viewport: { width: 390, height: 844 } } }
  ],
  webServer: undefined
});
```

### `tests/e2e/utils/config.ts`

```ts
export const config = {
  baseURL: (
    process.env.BASE_URL ||
    process.env.DDEV_PRIMARY_URL ||
    'https://<PROJECT>.ddev.site'
  ).replace(/\/$/, ''),
  defaultUser: {
    username: process.env.DRUPAL_USERNAME || 'playwright',
    password: process.env.DRUPAL_PASSWORD || 'playwright',
    email: 'playwright@test.local',
    role: 'administrator'
  },
  testUsers: {
    admin: {
      username: process.env.DRUPAL_ADMIN_USERNAME || 'playwright',
      password: process.env.DRUPAL_ADMIN_PASSWORD || 'playwright',
      email: 'playwright@test.local',
      role: 'administrator'
    },
    editor: {
      username: process.env.DRUPAL_EDITOR_USERNAME || 'playwright-editor',
      password: process.env.DRUPAL_EDITOR_PASSWORD || 'playwright',
      email: 'playwright-editor@test.local',
      role: 'content_editor'
    }
  },
  isCI: !!process.env.CI,
  timeouts: { default: 30000, adminUI: 60000, navigation: 30000 }
};

export type TestRole = keyof typeof config.testUsers;
export function getUserCredentials(role: TestRole = 'admin') { return config.testUsers[role]; }
export function getBaseURL(): string { return config.baseURL; }
```

### `tests/e2e/utils/login-helper.ts`

Drupal core login form: `#user-login-form`, `#edit-name`, `#edit-pass`, `#edit-submit`.
Kept free of `@playwright/test` fixtures so it can be imported from `global-setup.ts`.

```ts
import type { Page } from '@playwright/test';
import { config, getUserCredentials, TestRole } from './config';

export async function loginToDrupal(
  page: Page, username?: string, password?: string, role: TestRole = 'admin'
) {
  const baseURL = config.baseURL;
  const credentials = username && password ? { username, password } : getUserCredentials(role);

  await page.goto(`${baseURL}/user/login`, { waitUntil: 'load', timeout: 30000 });
  await page.waitForSelector('#user-login-form', { state: 'visible', timeout: 30000 });
  await page.fill('#edit-name', credentials.username);
  await page.fill('#edit-pass', credentials.password);
  // Submitting navigates; wait for the new document, not a specific URL.
  await Promise.all([
    page.waitForLoadState('domcontentloaded'),
    page.click('#edit-submit')
  ]);
  const stillOnLogin = await page.locator('#user-login-form').count();
  if (stillOnLogin > 0) {
    const message = await page.locator('.messages--error').first().textContent().catch(() => null);
    throw new Error(
      `Drupal login as "${credentials.username}" failed.` +
      (message ? ` Site said: ${message.trim()}` : '')
    );
  }
  return page;
}
```

### `tests/e2e/global-setup.ts`

**Must set `Deterrence-Bypass` on its own context** — global setup builds a
context that does NOT inherit `playwright.config.ts` `use`. Omitting it makes CI
report "0 tests" because this login times out on the Pantheon gate.

```ts
import { chromium, FullConfig } from '@playwright/test';
import path from 'path';
import { getUserCredentials } from './utils/config';
import { loginToDrupal } from './utils/login-helper';

export const ADMIN_AUTH_FILE = path.join(__dirname, '.auth/admin.json');

async function globalSetup(_config: FullConfig) {
  const browser = await chromium.launch();
  const context = await browser.newContext({
    ignoreHTTPSErrors: true,
    extraHTTPHeaders: { 'Deterrence-Bypass': '1' }
  });
  const page = await context.newPage();
  const { username, password } = getUserCredentials('admin');
  try {
    await loginToDrupal(page, username, password);
  } catch (error) {
    throw new Error(
      `Admin login as "${username}" failed — the authenticated suite cannot run.\n` +
        '  1. Test user missing (wiped by `ddev db-refresh`) — run `ddev playwright-users`.\n' +
        '  2. Site not started/served — run `ddev start` (or `ddev init`).\n' +
        `Original error: ${error instanceof Error ? error.message : String(error)}`
    );
  }
  await context.storageState({ path: ADMIN_AUTH_FILE });
  await browser.close();
}

export default globalSetup;
```

### `tests/e2e/.auth/.gitignore`

```
# Saved authenticated browser state — contains session cookies; never commit.
admin.json
```

### `tests/e2e/specs/smoke.spec.ts` (anonymous)

```ts
import { test, expect } from '@playwright/test';
import { config } from '../utils/config';

test.describe('Smoke tests (anonymous)', () => {
  test('homepage loads', async ({ page }) => {
    await page.goto(config.baseURL);
    await expect(page).toHaveTitle(/.+/);
  });
  test('login page is reachable', async ({ page }) => {
    await page.goto(`${config.baseURL}/user/login`);
    await expect(page.locator('#user-login-form')).toBeVisible();
  });
  test('404 page returns not-found status', async ({ page }) => {
    const response = await page.goto(`${config.baseURL}/this-path-should-not-exist-123`);
    expect(response?.status()).toBe(404);
  });
});
```

### `tests/e2e/specs/admin.spec.ts` (authenticated)

```ts
import { test, expect } from '@playwright/test';
import { config } from '../utils/config';
import { ADMIN_AUTH_FILE } from '../global-setup';

test.use({ storageState: ADMIN_AUTH_FILE });

test.describe('Admin (authenticated)', () => {
  test('can reach the admin content overview', async ({ page }) => {
    await page.goto(`${config.baseURL}/admin/content`);
    await expect(page).toHaveURL(/\/admin\/content/);
    await expect(page.locator('#user-login-form')).toHaveCount(0);
  });
});
```

## Files to modify

### `.gitignore`

```
# Playwright e2e
/playwright-report/
/test-results/
/tests/e2e/.auth/admin.json
/.env.playwright
```

### `.circleci/config.yml`

Model the job on the project's existing `cypress` job (same image, so terminus +
node are available) and provision the Drupal test user via `terminus drush`. Wire
it into the deploy workflow after the Pantheon deploy, with `ignore: main`.

```yaml
  playwright:
    docker:
      - image: *CYPRESS_CIMG_PHP
        auth:
          username: $DOCKERHUB_USER
          password: $DOCKERHUB_PASS
    environment:
      TERMINUS_SITE: *TERMINUS_SITE
      PANTHEON_UUID: *PANTHEON_UUID
    resource_class: large
    steps:
      - ci-tools/set-variables
      - checkout
      - ci-tools/copy-ssh-key
      - node/install:
          node-version: *CYPRESS_NODE_VERSION
      - ci-tools/install-terminus
      - run:
          name: Authorize terminus
          command: terminus -n auth:login --machine-token="$TERMINUS_TOKEN"
      - run:
          name: Prime Cache
          command: curl -I "${SITE_URL}"
      - run:
          name: Set Variables
          command: |
            (
                echo "export BASE_URL='${SITE_URL}'"
                echo "export PR_ENVIRONMENT='${TERMINUS_SITE}.pr-${CIRCLE_PULL_REQUEST##*/}'"
            ) >> $BASH_ENV
            source $BASH_ENV
      - run:
          name: Create the Playwright test user
          command: |
            terminus -n drush "$PR_ENVIRONMENT" -- user-create playwright --mail="playwright@test.local" --password="playwright" || true
            terminus -n drush "$PR_ENVIRONMENT" -- user-password playwright "playwright" || true
            terminus -n drush "$PR_ENVIRONMENT" -- user-add-role administrator playwright || true
      - restore_cache:
          keys:
            - playwright-deps-{{ checksum "package-lock.json" }}
            - playwright-deps-
      - run:
          name: Install Playwright
          command: |
            npm ci
            npx playwright install --with-deps chromium
      - save_cache:
          key: playwright-deps-{{ checksum "package-lock.json" }}
          paths:
            - ~/.npm
      - run:
          name: Run Playwright Tests
          no_output_timeout: 15m
          environment:
            DRUPAL_USERNAME: playwright
            DRUPAL_PASSWORD: playwright
          command: |
            set +e
            npx playwright test --max-failures=5
            echo $? > /tmp/playwright-exit-code
            set -e
      - store_artifacts:
          path: playwright-report
          destination: playwright-report
      - store_artifacts:
          path: test-results
          destination: test-results
      - store_test_results:
          path: test-results
      - run:
          name: Post Playwright Results to GitHub
          when: always
          command: node .circleci/scripts/github/post-playwright-results.js
      - run:
          name: Enforce Playwright exit code
          when: always
          command: |
            CODE="$(cat /tmp/playwright-exit-code 2>/dev/null || echo 1)"
            echo "Playwright exit code: ${CODE}"
            exit "${CODE}"
```

Wire into the deploy workflow (mirror the `cypress` entry):

```yaml
      - playwright:
          requires:
            - deploy-to-pantheon
          context: kanopi-code
          pre-steps:
            - ci-tools/set-pantheon-url
          filters:
            branches:
              ignore:
                - main
```

### `.circleci/scripts/github/post-playwright-results.js`

Reads `test-results/results.json` and posts a pass/fail summary comment to the
commit. Project-agnostic — relies only on standard CircleCI env vars +
`GITHUB_TOKEN`. (Copy verbatim from a project that already has it, e.g. `smalley`,
or the `amca` reference.)

## Verify

```bash
ddev playwright-install
ddev playwright-users
ddev playwright-run          # expect the smoke + admin specs to pass
```

Then push a branch and confirm the CircleCI `playwright` job runs on the multidev
and posts a results comment.

## Gotchas (learned the hard way)

- **Pantheon deterrence gate** — the single most common CI failure. Symptom: the
  `playwright` job reports "0 passed, 0 total" but exits 1 (globalSetup login timed
  out). Fix: `Deterrence-Bypass: 1` header in **both** `playwright.config.ts` `use`
  **and** `global-setup.ts`'s own context.
- **Roles** — Drupal's Standard profile has `administrator` and `content_editor`
  only. There is no `editor` or `content_author` by default. Check with
  `ddev drush role:list`.
- **Fresh DB import** — after `ddev db-refresh`, run `ddev drush cr` before testing;
  stale cache from the imported DB can 500 the homepage. `ddev init` does this for you.
- **`.env.playwright` is optional** — `config.ts` defaults cover local DDEV. Some
  tooling blocks writing `.env*` files; document the vars instead of committing an
  example.
- **DDEV commands come from the add-on** — don't hand-author project-local
  `playwright-*` commands; `ddev add-on get kanopi/ddev-kanopi-drupal` manages them
  (`#ddev-generated`). They must be committed to the repo (like `cypress-*`).
- **Exit codes** — `ddev playwright-run` (add-on ≥1.5.1) propagates the test exit
  code; older copies always returned 0.

## Related

- `devops-setup` — full Kanopi Drupal/Pantheon onboarding (this skill adds e2e on top)
- `test-scaffolding`, `test-plan-generator` — unit/integration test generation
- `kanopi/ddev-kanopi-drupal` add-on — provides the `playwright-*` DDEV commands
