# CMS Cultivator Agent Skills

This directory contains Agent Skills that Claude automatically invokes during conversation when contextually appropriate.

## What Are Agent Skills?

Agent Skills are **model-invoked** capabilities—Claude decides when to use them based on your conversation, without you needing to type explicit commands.

### How Agent Skills Are Invoked

Agent Skills are the universal invocation format — they work in Claude Code, Claude Desktop, and OpenAI Codex. Claude activates them automatically based on conversation context, or they can be explicitly invoked by name.

## Available Skills

### 1. commit-message-generator

**Triggers**: "commit", "staged", "ready to commit"
**Purpose**: Generate conventional commit messages
**Related Command**: `/commit-message-generator`

### 2. code-standards-checker

**Triggers**: "standards", "code style", "PHPCS", "ESLint"
**Purpose**: Check code against coding standards
**Related Command**: `/code-standards-checker`

### 3. test-scaffolding

**Triggers**: "need tests", "how to test", "untested code"
**Purpose**: Generate test scaffolding for classes/functions
**Related Command**: `/test-scaffolding`

### 4. documentation-generator

**Triggers**: "document", "API docs", "README", "docblock"
**Purpose**: Generate documentation for code
**Related Command**: `/documentation-generator`

### 5. test-plan-generator

**Triggers**: "test plan", "QA", "what to test"
**Purpose**: Generate QA test plans
**Related Command**: `/test-plan-generator`

### 6. coverage-analyzer

**Triggers**: "coverage", "untested", "what's not tested"
**Purpose**: Analyze test coverage gaps
**Related Command**: `/coverage-analyzer`

### 7. pr-create

**Triggers**: "create a PR", "open a pull request"
**Purpose**: Generate a PR description and create a GitHub pull request (with confirmation)
**Related Command**: `/pr-create`

### 8. pr-review

**Triggers**: "review this PR", "review my changes"
**Purpose**: Review a pull request or analyze local changes before submitting
**Related Command**: `/pr-review`

### 9. pr-release

**Triggers**: "prepare a release", "changelog", "deployment checklist"
**Purpose**: Generate changelog entries and deployment checklists for release PRs
**Related Command**: `/pr-release`

### 10. worktree-manager

**Triggers**: "create a worktree", "work on two tickets at once"
**Purpose**: Create, list, and tear down git worktrees with DDEV isolation
**Related Command**: `/worktree-manager`

### 11. design-analyzer

**Triggers**: Figma URLs, design mockups, "implement this design"
**Purpose**: Extract technical requirements from design references
**Related Command**: `/design-analyzer`

### 12. design-to-wp-block

**Triggers**: design reference + WordPress context
**Purpose**: Create WordPress block patterns from Figma designs or screenshots
**Related Command**: `/design-to-wp-block`

### 13. design-to-drupal-paragraph

**Triggers**: design reference + Drupal context
**Purpose**: Create Drupal paragraph types from Figma designs or screenshots
**Related Command**: `/design-to-drupal-paragraph`

### 14. responsive-styling

**Triggers**: "responsive", "mobile styles", "breakpoints", "SCSS"
**Purpose**: Generate mobile-first responsive CSS/SCSS with WCAG AA compliance
**Related Command**: `/responsive-styling`

### 15. browser-validator

**Triggers**: "test this", "validate", after code generation
**Purpose**: Validate implementations in real browsers via Chrome DevTools MCP
**Related Command**: `/browser-validator`

### 16. drupal-contribute

**Triggers**: "contribute to drupal.org", "issue fork"
**Purpose**: Guided drupal.org contribution workflow (with confirmation)
**Related Command**: `/drupal-contribute`

### 17. drupal-issue

**Triggers**: "drupal.org issue", "bug report"
**Purpose**: Create and manage drupal.org issues (with confirmation)
**Related Command**: `/drupal-issue`

### 18. drupal-mr

**Triggers**: "merge request", "MR", "patch"
**Purpose**: Create merge requests for drupal.org projects (with confirmation)
**Related Command**: `/drupal-mr`

### 19. drupal-cleanup

**Triggers**: "clean up drupal", module/config cleanup requests
**Purpose**: Drupal codebase and configuration cleanup workflows (with confirmation)
**Related Command**: `/drupal-cleanup`

### 20. drupalorg-contribution-helper

**Triggers**: "how do I contribute to drupal.org?", "drupal.org git workflow"
**Purpose**: Quick help with drupal.org contribution workflows
**Related Command**: `/drupalorg-contribution-helper`

### 21. drupalorg-issue-helper

**Triggers**: "how do I write a bug report?", "issue template"
**Purpose**: Quick help with drupal.org issue formatting and templates
**Related Command**: `/drupalorg-issue-helper`

### 22. drupal-sdc-twig

**Triggers**: "SDC", "Single Directory Component", "component.yml"
**Purpose**: Best practices for Drupal Single Directory Components with Twig
**Related Command**: `/drupal-sdc-twig`

### 23. wp-add-skills

**Triggers**: "add WordPress skills", WordPress meta-skill requests
**Purpose**: Install curated WordPress development skills into a project (with confirmation)
**Related Command**: `/wp-add-skills`

### 24. composer-patch-generator

**Triggers**: "composer patch", "generate a patch"
**Purpose**: Generate and wire up Composer patches for contrib projects
**Related Command**: `/composer-patch-generator`

### 25. drupal-rector-update

**Triggers**: "update rector", "rector.php", "composer-based sets", "DrupalSetProvider"
**Purpose**: Migrate Drupal Rector config to Composer-based sets (auto version selection)
**Related Command**: `/drupal-rector-update`

## How Skills Work

### Automatic Activation

Claude analyzes your conversation context and automatically invokes the appropriate skill:

```
User: "I need to commit my changes"
→ Claude invokes commit-message-generator skill
→ Analyzes git diff, generates commit message
→ Presents message for approval
```

### Natural Language

No need to remember command syntax—just express what you need:

```
✅ "Create a block pattern from this Figma design"
✅ "I need tests for this class"
✅ "Does this follow Drupal standards?"
✅ "Set up a worktree for this ticket"
```

## File Structure

Each skill has its own directory with a `SKILL.md` file. Skills that require
explicit user confirmation also include an `agents/openai.yaml` policy file
for Codex compatibility, and some ship supporting `templates/`:

```
skills/
├── <skill-name>/
│   ├── SKILL.md
│   ├── agents/openai.yaml   # only for confirmation-gated skills
│   └── templates/           # only where a skill ships templates
└── README.md
```

## SKILL.md Format

Each `SKILL.md` file has YAML frontmatter with required fields:

```markdown
---
name: skill-name
description: When and how this skill should be invoked. Include trigger terms and use cases.
---

# Skill Name

Detailed instructions for Claude on how to execute this skill...
```

### Required Fields

- **name**: Kebab-case skill identifier
- **description**: When to invoke, what it does, trigger terms

### Best Practices

1. **Clear trigger terms** - List words/phrases that should activate the skill
2. **Specific description** - Explain exactly when to use this vs. related commands
3. **Detailed instructions** - Provide step-by-step workflow
4. **Examples** - Show expected interactions

## Where did the audit, PM, DevOps, and Delivery Record skills go?

As of 2.0, CMS Cultivator focuses on CMS development workflows. Delivery
Record moved to its own public library:
<https://github.com/kanopi/delivery-record>. Audit, DevOps, and PM
capabilities moved to separate internal Kanopi libraries. The final 1.x
release remains available as a tagged reference for anyone pinned to it.
