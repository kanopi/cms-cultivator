---
description: Generate documentation (API, README, guides, changelog) using documentation specialist
argument-hint: "[doc-type]"
allowed-tools: Task
---

Spawn the **documentation-specialist** agent using:

```
Task(cms-cultivator:documentation-specialist:documentation-specialist,
     prompt="Generate comprehensive documentation. Documentation type: [use argument if provided, otherwise 'all types']. Generate API docs (PHPDoc/JSDoc), user guides, developer docs, and changelogs. Apply CMS-specific documentation patterns for Drupal and WordPress.")
```

The documentation specialist will:
1. **Generate API documentation** - PHPDoc, JSDoc with examples
2. **Create user guides** - Step-by-step instructions with screenshots
3. **Write developer docs** - Architecture, contributing, setup guides
4. **Generate changelogs** - Keep a Changelog format from git history
5. **Build documentation sites** - Zensical-based documentation sites with modern theming
6. **Document CMS patterns**:
   - **Drupal**: Hooks, services, plugins, configuration
   - **WordPress**: Filters/actions, shortcodes, custom post types

**Doc types**: `api`, `readme`, `guide`, `changelog`, `inline`, `site`

---

## Tool Usage

**Allowed operations:**
- ✅ Spawn documentation-specialist agent
- ✅ Read code files to extract documentation
- ✅ Generate API documentation (PHPDoc, JSDoc)
- ✅ Create README files and user guides
- ✅ Generate changelogs from git history
- ✅ Run documentation generation tools (phpDocumentor, JSDoc)

**Not allowed:**
- ❌ Do not modify source code files
- ❌ Do not commit documentation (provide files for review)
- ❌ Do not publish documentation to external sites

The documentation-specialist agent performs all documentation generation operations.

---

## Agent Used

**documentation-specialist** - Documentation generation specialist with CMS-specific knowledge.
