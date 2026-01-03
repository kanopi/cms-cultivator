---
description: Comprehensive code quality analysis and technical debt assessment using code-quality specialist
argument-hint: "[focus-area]"
allowed-tools: Task
---

Spawn the **code-quality-specialist** agent using:

```
Task(cms-cultivator:code-quality-specialist:code-quality-specialist,
     prompt="Analyze code quality and technical debt. Focus area: [use argument if provided, otherwise 'complete analysis']. Analyze code complexity, assess technical debt, review design patterns, check maintainability, and apply CMS-specific standards for Drupal and WordPress projects.")
```

The code-quality specialist will:
1. **Analyze code complexity** - Cyclomatic complexity, cognitive complexity
2. **Assess technical debt** - Code smells, anti-patterns, refactoring needs
3. **Review design patterns** - SOLID principles, DRY, separation of concerns
4. **Check maintainability** - Code readability, documentation, naming conventions
5. **CMS-specific patterns**:
   - **Drupal**: Drupal coding standards, dependency injection, render arrays
   - **WordPress**: WordPress coding standards, hooks over direct calls, security practices

**Focus areas**: `complexity`, `debt`, `patterns`, `maintainability`, `standards`

## Agent Used

**code-quality-specialist** - Code quality and technical debt analyst with CMS-specific standards knowledge.
