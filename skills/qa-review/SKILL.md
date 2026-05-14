---
name: qa-review
description: >
  Perform a full QA review of a Teamwork task by reading the task and all its comments for context,
  extracting the multi-dev URL, generating dynamic validation steps tailored to the task type, and
  using CoWork browser automation to execute those steps on the multi-dev environment. Produces a
  structured validation report with pass/fail per step, screenshots, internal notes, and a
  client-facing summary — all shown in chat.

  Use this skill whenever the user asks to QA, test, validate, or review a Teamwork task or
  multi-dev environment — even if they just say "can you QA this?" or paste a Teamwork link.
  Also triggers for phrases like "run QA on", "check the multi-dev", "validate this task",
  "test the dev link", or "review the ticket". Works across Drupal/CMS updates, WordPress/plugin
  updates, bug fixes, new feature development, and general web development tasks.
---

# QA Review Skill

Performs end-to-end QA on a Teamwork task: reads context, extracts the multi-dev URL, builds
a validation plan, executes it via CoWork browser automation, and produces a full report.

---

## Step 1 — Read the Teamwork Task

Use the Teamwork MCP to fetch:
- The full task description
- **All comments** on the task (not just the most recent)

Extract and summarize:
- **What was done** (the change, fix, or feature)
- **Task type** (Drupal/CMS update, WordPress/plugin update, bug fix, new feature, general web dev)
- **Platform** — detect whether this is a **WordPress** or **Drupal** site based on task content, comments, URLs, or plugin/module names mentioned. If unclear, infer from the URL (e.g. WP Engine = likely WordPress; Pantheon = could be either — look for Drupal module names vs. WP plugin names). If still ambiguous, ask the user before proceeding.
- **Any specific areas to test** mentioned by the developer
- **Known issues or caveats** noted in the comments
- **The multi-dev URL** — scan all comments and the description; it may be labeled "Multi-Dev:", "multidev:", "staging:", or just be a bare URL (e.g. *.pantheonsite.io, *.wpengine.com, *.kinsta.cloud, *.pantheon.io, or similar dev/staging domains). If multiple URLs are found, list them and ask the user which to test unless one is clearly labeled as the primary environment.

If no URL is found, stop and ask the user to provide it before continuing.

---

## Step 2 — Build the Validation Plan

Combine a **base checklist** with **dynamic steps** derived from the task context and detected platform.

### Base Checklist (always included, all platforms)

- [ ] Site loads without errors (no PHP errors, white screen, or 500s)
- [ ] Homepage renders correctly
- [ ] Navigation works (primary menu, links resolve)
- [ ] No JavaScript console errors on key pages
- [ ] Admin/backend is accessible (if applicable)
- [ ] Forms render and appear functional
- [ ] Mobile responsiveness — check at least one key page at mobile width

---

### Dynamic Steps (generated from task context)

Select steps from the relevant platform section below based on the detected platform and task type.

---

#### Drupal-Specific Steps

**Drupal Core / Module Update:**
- Verify the specific modules or core version mentioned are active (check /admin/modules)
- Test any functionality the updated modules affect (e.g. cloning, access checks, field display, views)
- Check content editing experience for relevant content types
- Verify user role access is correct (admin vs. editor vs. anonymous)
- Look for visible PHP warnings, notices, or deprecation messages in the page output
- Check the Drupal status report (/admin/reports/status) for any new warnings or errors

**Drupal Bug Fix:**
- Reproduce the original bug scenario — confirm it no longer occurs
- Test the affected page, view, or component directly
- Check adjacent functionality (e.g. if a field was fixed, test the full form it belongs to)
- Verify fix holds for different user roles if relevant

**Drupal New Feature:**
- Walk through the feature end-to-end as a content editor and as an anonymous user
- Test edge cases mentioned in the task (empty states, required fields, access denial)
- Verify the feature works correctly across relevant content types and user roles

---

#### WordPress-Specific Steps

**WordPress Core / Plugin / Theme Update:**
- Verify the site loads and the WordPress admin (/wp-admin) is accessible
- Check that updated plugins are active and show the correct version under Plugins
- Test any functionality the updated plugins affect (e.g. forms, eCommerce, SEO, page builder blocks)
- Check the front-end for visual regressions — especially if a theme or page builder was updated
- Verify the block editor (Gutenberg) or classic editor loads correctly and content is editable
- Look for PHP errors or warnings in the page output or admin notices
- Check WooCommerce checkout flow if applicable (cart to checkout to order confirmation)

**WordPress Bug Fix:**
- Reproduce the original bug — confirm it no longer occurs
- Test the affected page, post type, or plugin feature directly
- Check adjacent functionality that could have been impacted by the fix
- Verify fix holds across user roles (admin, editor, subscriber, logged-out)

**WordPress New Feature:**
- Walk through the feature end-to-end as an admin and as a front-end user
- Test edge cases mentioned in the task
- If a custom post type, ACF field group, or shortcode is involved, test create/edit/publish/display
- Verify the feature displays correctly in both the editor and on the published front-end

---

#### General Steps (applies to all platforms)

**Bug Fix:**
- Reproduce the original bug scenario — confirm it no longer occurs
- Test the affected page/feature directly
- Check adjacent functionality that could have been impacted

**New Feature:**
- Walk through the feature end-to-end as a user
- Test edge cases mentioned in the task
- Verify the feature behaves correctly for different user roles if relevant

**General Web Dev:**
- Test the specific pages or components mentioned
- Verify visual output matches intent described in the task

---

Present the full validation plan to the user **before** executing — list all steps (base + dynamic) and confirm they want to proceed, or let them add/remove steps.

---

## Step 3 — Execute the Validation via CoWork

Use CoWork browser automation to work through each validation step:

- Navigate to the multi-dev URL
- For each step:
  - Perform the action
  - Take a **screenshot** as evidence
  - Record a **pass**, **fail**, or **warning** result
  - Note any observations (what you saw, any errors, anything unexpected)
- If a step fails or produces a warning, take an additional screenshot and note the exact error or issue observed
- Check the browser console for JS errors on key pages where relevant

Keep a running log as you go — don't wait until the end to compile results.

---

## Step 4 — Produce the Validation Report

Once all steps are complete, output the full report in chat using the format below.

---

### Report Format

```
## QA Validation Report
**Task:** [Task name + Teamwork link]
**Multi-Dev URL:** [URL tested]
**Platform:** [WordPress / Drupal]
**Date:** [Today's date]
**Overall Result:** PASS / PASS WITH WARNINGS / FAIL

---

### Validation Steps

| # | Step | Result | Notes |
|---|------|--------|-------|
| 1 | Site loads without errors | Pass | No errors observed |
| 2 | Homepage renders correctly | Pass | |
| 3 | [Dynamic step] | Fail | [Description of issue] |
...

---

### Issues Found

> Only include this section if there are failures or warnings.

**[Issue Title]** — [FAIL / WARNING]
- **Where:** [Page or component]
- **What happened:** [Description]
- **Screenshot:** [Attached or described]

---

### Internal Notes

[Anything the developer or team should know — technical observations, potential causes, suggested follow-up]

---

### Client-Facing Summary

[2-4 sentence plain-English summary suitable for sending to a client. Tone should match the
examples in the user's preferences: professional, friendly, concise. If all passed: confirm
the feature/fix is working as expected and invite their review. If issues were found: describe
what was found plainly and what the next step is.]
```

---

## Notes & Edge Cases

- If CoWork can't access the multi-dev URL (auth wall, VPN required, etc.), stop and notify the user.
- If a step can't be completed due to missing credentials (e.g. admin login required), skip it, mark as **Skipped**, and note what access would be needed.
- If the task has no clear multi-dev URL and none can be inferred, ask before proceeding.
- **Drupal:** Pay special attention to PHP notices/warnings in the page output — they often indicate module compatibility issues even when the page appears functional.
- **WordPress:** Pay attention to admin notices and plugin conflict warnings at the top of the /wp-admin dashboard — these often surface issues that don't appear on the front-end.
- Screenshots should be captured at key moments: initial page load, after interactions, and on any failures.
