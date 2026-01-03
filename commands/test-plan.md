---
description: Generate comprehensive QA test plan based on code changes using testing specialist
argument-hint: "[focus-area]"
allowed-tools: Task
---

Spawn the **testing-specialist** agent using:

```
Task(cms-cultivator:testing-specialist:testing-specialist,
     prompt="Generate a comprehensive QA test plan based on code changes. Focus area: [use argument if provided, otherwise 'all changes']. Analyze code changes, generate test scenarios (functional, security, performance, accessibility), create test checklists with step-by-step validation instructions, and include CMS-specific tests for Drupal and WordPress.")
```

The testing specialist will:
1. **Analyze code changes** - Review commits, diffs, and modified functionality
2. **Generate test scenarios** - Functional, security, performance, accessibility tests
3. **Create test checklists** - Step-by-step validation instructions
4. **Include CMS-specific tests**:
   - **Drupal**: Config imports, update hooks, permissions, cache clearing
   - **WordPress**: Permalinks, ACF sync, CPTs, shortcodes
5. **Provide acceptance criteria** - Clear pass/fail conditions

**Focus areas**: `functional`, `security`, `performance`, `accessibility`, `regression`

## Agent Used

**testing-specialist** - QA planning specialist with CMS-specific testing knowledge.
