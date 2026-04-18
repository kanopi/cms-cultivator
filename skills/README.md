# CMS Cultivator Agent Skills

This directory contains 38 Agent Skills that Claude automatically invokes during conversation when contextually appropriate.

## What Are Agent Skills?

Agent Skills are **model-invoked** capabilities—Claude decides when to use them based on your conversation, without you needing to type explicit commands.

### How Agent Skills Are Invoked

Agent Skills are the universal invocation format — they work in Claude Code, Claude Desktop, and OpenAI Codex. Claude activates them automatically based on conversation context, or they can be explicitly invoked by name.

## Available Skills

### 1. commit-message-generator

**Triggers**: "commit", "staged", "ready to commit"
**Purpose**: Generate conventional commit messages
**Related Command**: `/pr-commit-msg`

### 2. code-standards-checker

**Triggers**: "standards", "code style", "PHPCS", "ESLint"
**Purpose**: Check code against coding standards
**Related Command**: `/quality-standards`

### 3. test-scaffolding

**Triggers**: "need tests", "how to test", "untested code"
**Purpose**: Generate test scaffolding for classes/functions
**Related Command**: `/test-generate`

### 4. documentation-generator

**Triggers**: "document", "API docs", "README", "docblock"
**Purpose**: Generate documentation for code
**Related Command**: `/docs-generate`

### 5. test-plan-generator

**Triggers**: "test plan", "QA", "what to test"
**Purpose**: Generate QA test plans
**Related Command**: `/test-plan`

### 6. accessibility-checker

**Triggers**: "accessible?", "WCAG", "screen reader"
**Purpose**: Quick accessibility checks on specific elements
**Related Command**: `/audit-a11y`

### 7. performance-analyzer

**Triggers**: "slow", "optimize", "performance issue"
**Purpose**: Analyze performance of specific code
**Related Command**: `/audit-perf`

### 8. security-scanner

**Triggers**: "secure?", "SQL injection", "XSS"
**Purpose**: Scan code for security vulnerabilities
**Related Command**: `/audit-security`

### 9. coverage-analyzer

**Triggers**: "coverage", "untested", "what's not tested"
**Purpose**: Analyze test coverage gaps
**Related Command**: `/test-coverage`

### 10. gtm-performance-audit

**Triggers**: "GTM", "tag manager", "marketing tags", "tracking tags slow", "too many tags"
**Purpose**: Audit Google Tag Manager for performance impact

### 11. accessibility-audit

**Triggers**: "/audit-a11y", "full accessibility audit", "WCAG compliance report", "comprehensive accessibility analysis"
**Purpose**: Comprehensive WCAG 2.1 Level AA accessibility audit, spawns accessibility-specialist for full site analysis

### 12. performance-audit

**Triggers**: "/audit-perf", "full performance audit", "Core Web Vitals analysis", "LCP, INP, CLS"
**Purpose**: Comprehensive performance analysis and Core Web Vitals optimization, spawns performance-specialist

### 13. security-audit

**Triggers**: "/audit-security", "full security audit", "OWASP compliance review", "comprehensive vulnerability scanning"
**Purpose**: Comprehensive OWASP Top 10 security vulnerability scanning, spawns security-specialist

### 14. quality-audit

**Triggers**: "/quality-analyze", "full code quality audit", "technical debt assessment", "comprehensive code quality analysis"
**Purpose**: Comprehensive code quality analysis and technical debt assessment, spawns code-quality-specialist

### 15. live-site-audit

**Triggers**: "/audit-live-site", "comprehensive site health assessment", "full multi-dimensional audit", "unified audit report"
**Purpose**: Multi-dimensional site audit orchestrating performance, accessibility, security, and code quality specialists in parallel

### 16. pr-review

**Triggers**: "review a PR", "code review", "review my changes", "pr-review self", PR number provided
**Purpose**: Review a pull request or analyze local changes using the workflow-specialist agent

### 17. audit-export

**Triggers**: "export audit to CSV", "create tasks from audit", audit report file provided with export request
**Purpose**: Export audit findings from markdown report files to Teamwork-compatible CSV format for project management tools

### 18. audit-report

**Triggers**: "generate a client report from this audit", "create an executive summary", "non-technical version of this audit", "summarize audit findings for stakeholders"
**Purpose**: Generate client-facing executive summaries from existing audit report files

### 19. design-to-wp-block

**Triggers**: "create a WordPress block from this design", "convert this Figma to a block pattern", Figma URL with WordPress context
**Purpose**: Create WordPress block patterns from Figma designs or screenshots using the design-specialist agent

### 20. design-to-drupal-paragraph

**Triggers**: "create a Drupal paragraph from this design", "convert this mockup to a paragraph type", design reference with Drupal context
**Purpose**: Create Drupal paragraph types from Figma designs or screenshots using the design-specialist agent

### 21. pr-create

**Triggers**: "create a PR", "submit a PR", "open a pull request", "/pr-create"
**Purpose**: Generate PR description and create a GitHub pull request using the workflow-specialist agent (requires user confirmation)

### 22. pr-release

**Triggers**: "prepare a release", "generate a changelog", "create a deployment checklist", "/pr-release"
**Purpose**: Generate changelog entries, deployment checklists, and update PR descriptions for releases (requires user confirmation)

### 23. devops-setup

**Triggers**: "set up DevOps for a new project", "onboard a Pantheon site", "/devops-setup"
**Purpose**: Automate Kanopi's complete Drupal/Pantheon DevOps onboarding workflow (requires explicit user confirmation at each phase)

### 24. drupal-contribute

**Triggers**: "contribute to drupal.org", "create a drupal.org issue and MR", "/drupal-contribute"
**Purpose**: Full drupal.org contribution workflow — create an issue and set up a merge request together

### 25. drupal-issue

**Triggers**: "create a drupal.org issue", "open a drupal issue", "/drupal-issue"
**Purpose**: Create, update, and manage issues on drupal.org using a guided clipboard and browser workflow

### 26. drupal-mr

**Triggers**: "create a drupal.org MR", "set up a merge request for issue", "/drupal-mr"
**Purpose**: Create and manage merge requests for drupal.org projects via git.drupalcode.org

### 27. drupal-cleanup

**Triggers**: "cleanup drupal repos", "remove cloned drupal projects", "/drupal-cleanup"
**Purpose**: List and clean up cloned drupal.org repositories in the local cache (~/.cache/drupal-contrib/)

### 28. wp-add-skills

**Triggers**: "add WordPress skills", "install WordPress agent skills", "/wp-add-skills"
**Purpose**: Install official WordPress agent-skills from the WordPress/agent-skills GitHub repository

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
✅ "Is this button accessible?"
✅ "This query is slow"
✅ "I need tests for this class"
✅ "Does this follow Drupal standards?"
```

### Focused vs. Comprehensive Skills

Some skills provide quick, conversational help; others run comprehensive analyses:

- **Focused skill**: "Is this secure?" → `security-scanner` → Quick security scan of shown code
- **Comprehensive skill**: "Run a full security audit" → `security-audit` → Full OWASP Top 10 site-wide scan

## File Structure

Each skill has its own directory with a `SKILL.md` file. Skills that require explicit user confirmation also include an `agents/openai.yaml` policy file for Codex compatibility:

```
skills/
├── commit-message-generator/
│   └── SKILL.md
├── code-standards-checker/
│   └── SKILL.md
├── test-scaffolding/
│   └── SKILL.md
├── documentation-generator/
│   └── SKILL.md
├── test-plan-generator/
│   └── SKILL.md
├── accessibility-checker/
│   └── SKILL.md
├── performance-analyzer/
│   └── SKILL.md
├── security-scanner/
│   └── SKILL.md
├── coverage-analyzer/
│   └── SKILL.md
├── accessibility-audit/
│   └── SKILL.md
├── performance-audit/
│   └── SKILL.md
├── security-audit/
│   └── SKILL.md
├── quality-audit/
│   └── SKILL.md
├── live-site-audit/
│   └── SKILL.md
├── pr-review/
│   └── SKILL.md
├── audit-export/
│   └── SKILL.md
├── audit-report/
│   └── SKILL.md
├── design-to-wp-block/
│   └── SKILL.md
├── design-to-drupal-paragraph/
│   └── SKILL.md
├── pr-create/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── pr-release/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── devops-setup/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── drupal-contribute/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── drupal-issue/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── drupal-mr/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── drupal-cleanup/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── wp-add-skills/
│   ├── SKILL.md
│   └── agents/openai.yaml
├── browser-validator/
│   └── SKILL.md
├── design-analyzer/
│   └── SKILL.md
├── drupalorg-contribution-helper/
│   └── SKILL.md
├── drupalorg-issue-helper/
│   └── SKILL.md
├── responsive-styling/
│   └── SKILL.md
├── structured-data-analyzer/
│   └── SKILL.md
├── teamwork-exporter/
│   └── SKILL.md
├── teamwork-integrator/
│   └── SKILL.md
└── teamwork-task-creator/
    └── SKILL.md
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

### 29. strategic-thinking

**Triggers**: "should we do this?", "help me decide", "what are the trade-offs", "help me think through this", "is this the right approach?", "pros and cons", "help me think through"
**Purpose**: Guide significant decisions using Brene Brown's 5 Cs of Strategic Thinking (Context, Color, Connective Tissue, Cost, Consequence) from *Strong Ground*
**Related Command**: None — skill-only

### 30. browser-validator

**Triggers**: "validate in browser", "test responsive design", "check in Chrome", "test this in a real browser"
**Purpose**: Validate design implementations in real Chrome browser at 320px, 768px, and 1024px+ breakpoints. Checks WCAG AA compliance, captures screenshots, validates interactions.
**Related Agent**: browser-validator-specialist

### 31. design-analyzer

**Triggers**: Figma URL provided, "analyze this design", "extract design specs", "what are the design requirements"
**Purpose**: Extract technical requirements from Figma designs or screenshots for CMS implementation. Produces structured specs for responsive-styling-specialist.
**Related Skills**: design-to-wp-block, design-to-drupal-paragraph

### 32. drupalorg-contribution-helper

**Triggers**: "help with drupal.org contribution", "drupal.org git workflow", "how do I contribute to drupal", "drupal contrib help"
**Purpose**: Quick guidance on drupal.org contribution workflows: clone, branch, push, and MR creation steps without full automation.
**Related Command**: `/drupal-contribute`

### 33. drupalorg-issue-helper

**Triggers**: "help with drupal.org issue", "drupal issue template", "how to file a drupal bug", "drupal.org issue format"
**Purpose**: Quick help formatting drupal.org issues — bug reports, feature requests, templates — without running the full /drupal-issue workflow.
**Related Command**: `/drupal-issue`

### 34. responsive-styling

**Triggers**: "create responsive styles", "mobile-first CSS", "SCSS for this component", "breakpoints for this layout"
**Purpose**: Generate mobile-first responsive CSS/SCSS for Drupal and WordPress components with proper breakpoints (768px, 1024px), WCAG AA contrast, and touch-friendly targets.
**Related Agent**: responsive-styling-specialist

### 35. structured-data-analyzer

**Triggers**: "structured data", "JSON-LD", "schema.org", "rich results", "audit structured data"
**Purpose**: Audit and generate Schema.org JSON-LD markup for SEO, rich snippets, and AI discoverability. Validates against schema.org spec.
**Related Agent**: structured-data-specialist

### 36. teamwork-exporter

**Triggers**: "export audit to Teamwork", "create Teamwork tasks from audit", "send findings to Teamwork"
**Purpose**: Export audit findings as formatted Teamwork task entries in CSV format for project management ingestion.
**Related Agent**: teamwork-specialist

### 37. teamwork-integrator

**Triggers**: "find Teamwork task", "look up ticket", ticket number provided (e.g. PROJ-123), "link to Teamwork"
**Purpose**: Look up Teamwork tasks, cross-reference with code changes, and provide project management context during development.
**Related Agent**: teamwork-specialist

### 38. teamwork-task-creator

**Triggers**: "create a Teamwork task", "add this to Teamwork", "log this as a task", "create task for this issue"
**Purpose**: Create properly formatted Teamwork task objects from conversation context for project management integration.
**Related Agent**: teamwork-specialist

## Adding New Skills

To add a new Agent Skill:

1. **Create directory**: `mkdir skills/my-new-skill`
2. **Create SKILL.md**: `touch skills/my-new-skill/SKILL.md`
3. **Add frontmatter**:
   ```yaml
   ---
   name: my-new-skill
   description: Clear description with trigger terms...
   ---
   ```
4. **Write instructions**: Detailed workflow for Claude
5. **Test**: Try conversational triggers to verify activation
6. **Document**: Update `/docs/agent-skills.md`

## Testing Skills

### Manual Testing

Use natural language that should trigger the skill:

```bash
# In Claude Code CLI
"I need to commit my changes"
→ Should trigger commit-message-generator

"Is this code secure?"
→ Should trigger security-scanner
```

### Debugging

If a skill isn't activating:
1. Check the description has clear trigger terms
2. Verify your phrasing matches expected triggers
3. Be more explicit about context
4. Try invoking the skill by name explicitly

## Skill Activation Philosophy

### When Skills Work Best

✅ Quick, focused assistance during conversation
✅ Single file/function/element analysis
✅ Immediate feedback needed
✅ User doesn't know specific command name

### When to Use Comprehensive Skills

✅ Comprehensive project-wide analysis (`accessibility-audit`, `security-audit`, etc.)
✅ Structured workflows with side effects (`pr-create`, `pr-release`, `devops-setup`)
✅ Batch operations across multiple files
✅ CI/CD integration
✅ Formal reports for stakeholders

## Learning More

- **Skills Documentation**: https://code.claude.com/docs/en/skills
- **CMS Cultivator Docs**: https://kanopi.github.io/cms-cultivator/
- **Agent Skills Guide**: https://kanopi.github.io/cms-cultivator/agent-skills/

## Contributing

See the main [Contributing Guide](../CONTRIBUTING.md) for guidelines on adding or improving skills.

---

**Key Takeaway**: Agent Skills make CMS Cultivator proactive—Claude helps automatically when it sees you need assistance, making your development workflow more natural and efficient.
