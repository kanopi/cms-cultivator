---
description: Generate documentation (API, README, guides, changelog) using documentation specialist
argument-hint: "[doc-type]"
allowed-tools: Task
---

I'll use the **documentation specialist** agent to generate comprehensive documentation.

The documentation specialist will:
1. **Generate API documentation** - PHPDoc, JSDoc with examples
2. **Create user guides** - Step-by-step instructions with screenshots
3. **Write developer docs** - Architecture, contributing, setup guides
4. **Generate changelogs** - Keep a Changelog format from git history
5. **Document CMS patterns**:
   - **Drupal**: Hooks, services, plugins, configuration
   - **WordPress**: Filters/actions, shortcodes, custom post types

**Doc types**: `api`, `readme`, `guide`, `changelog`, `inline`

## Agent Used

**documentation-specialist** - Documentation generation specialist with CMS-specific knowledge.
