---
description: Check code against coding standards (PHPCS, ESLint, WordPress/Drupal) using code-quality specialist
argument-hint: "[standard]"
allowed-tools: Task
---

Spawn the **code-quality-specialist** agent using:

```
Task(cms-cultivator:code-quality-specialist:code-quality-specialist,
     prompt="Check code against coding standards. Standard: [use argument if provided, otherwise 'auto-detect']. Run PHPCS, ESLint, and Prettier checks. Apply CMS-specific standards (Drupal Coding Standards or WordPress Coding Standards). Report violations with file/line locations.")
```

The code-quality specialist will:
1. **Run coding standards checks** - PHPCS, ESLint, Prettier
2. **Apply CMS standards**:
   - **Drupal**: Drupal Coding Standards via PHPCS
   - **WordPress**: WordPress Coding Standards via PHPCS
3. **Check JavaScript standards** - ESLint with appropriate configs
4. **Identify violations** - Errors and warnings with file/line locations
5. **Provide auto-fix recommendations** - Which issues can be auto-fixed

**Standards**: `drupal`, `wordpress`, `psr12`, `eslint`, `prettier`

---

## Tool Usage

**Allowed operations:**
- ✅ Spawn code-quality-specialist agent
- ✅ Run PHPCS with Drupal or WordPress coding standards
- ✅ Run ESLint with appropriate configurations
- ✅ Run Prettier for code formatting checks
- ✅ Identify violations with file/line locations
- ✅ Provide auto-fix recommendations

**Not allowed:**
- ❌ Do not automatically fix violations (provide --fix commands for user)
- ❌ Do not modify code files
- ❌ Do not commit changes

The code-quality-specialist agent performs all standards checking operations.

---

## Agent Used

**code-quality-specialist** - Coding standards specialist with CMS-specific configuration knowledge.
