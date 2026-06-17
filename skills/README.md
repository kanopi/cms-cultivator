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

### 6. accessibility-checker

**Triggers**: "accessible?", "WCAG", "screen reader"
**Purpose**: Quick accessibility checks on specific elements
**Related Command**: `/accessibility-audit`

### 7. performance-analyzer

**Triggers**: "slow", "optimize", "performance issue"
**Purpose**: Analyze performance of specific code
**Related Command**: `/performance-audit`

### 8. security-scanner

**Triggers**: "secure?", "SQL injection", "XSS"
**Purpose**: Scan code for security vulnerabilities
**Related Command**: `/security-audit`

### 9. coverage-analyzer

**Triggers**: "coverage", "untested", "what's not tested"
**Purpose**: Analyze test coverage gaps
**Related Command**: `/coverage-analyzer`

### 10. gtm-performance-audit

**Triggers**: "GTM", "tag manager", "marketing tags", "tracking tags slow", "too many tags"
**Purpose**: Audit Google Tag Manager for performance impact

### 11. accessibility-audit

**Triggers**: "/accessibility-audit", "full accessibility audit", "WCAG compliance report", "comprehensive accessibility analysis"
**Purpose**: Comprehensive WCAG 2.1 Level AA accessibility audit, spawns accessibility-specialist for full site analysis

### 12. performance-audit

**Triggers**: "/performance-audit", "full performance audit", "Core Web Vitals analysis", "LCP, INP, CLS"
**Purpose**: Comprehensive performance analysis and Core Web Vitals optimization, spawns performance-specialist

### 13. security-audit

**Triggers**: "/security-audit", "full security audit", "OWASP compliance review", "comprehensive vulnerability scanning"
**Purpose**: Comprehensive OWASP Top 10 security vulnerability scanning, spawns security-specialist

### 14. quality-audit

**Triggers**: "/quality-audit", "full code quality audit", "technical debt assessment", "comprehensive code quality analysis"
**Purpose**: Comprehensive code quality analysis and technical debt assessment, spawns code-quality-specialist

### 15. live-site-audit

**Triggers**: "/live-site-audit", "comprehensive site health assessment", "full multi-dimensional audit", "unified audit report"
**Purpose**: Multi-dimensional site audit orchestrating performance, accessibility, security, and code quality specialists in parallel

### 16. pr-review

**Triggers**: "review a PR", "code review", "review my changes", "pr-review self", PR number provided
**Purpose**: Review a pull request or analyze local changes inline (security, breaking changes, testing gaps, performance, accessibility) with CMS-specific checks for Drupal and WordPress

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
**Purpose**: Generate a PR description and create a GitHub pull request inline (no orchestrator agent); detects Drupal/WordPress deployment requirements and runs inline quality checks. Requires user confirmation before creating the PR.

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
├── wp-plugin-to-private-package/
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
**Purpose**: Export audit findings as formatted Teamwork task entries in CSV format for project management ingestion. Runs directly from the main session using the Teamwork MCP.

### 37. teamwork-integrator

**Triggers**: "find Teamwork task", "look up ticket", ticket number provided (e.g. PROJ-123), "link to Teamwork"
**Purpose**: Look up Teamwork tasks (read-only), cross-reference with code changes, and provide project management context during development. Runs directly from the main session using the Teamwork MCP.

### 38. teamwork-task-creator

**Triggers**: "create a Teamwork task", "add this to Teamwork", "log this as a task", "create task for this issue"
**Purpose**: Create properly formatted Teamwork task objects from conversation context. Runs directly from the main session using the Teamwork MCP.

### 39. frd-generator

**Triggers**: "FRD", "functional requirements document", "requirements doc", "structure requirements"
**Purpose**: Generate comprehensive Functional Requirements Documents with standardized 10-section structure, requirement numbering conventions (FR-XXX, TR-XXX, US-XXX), and platform-specific additions for Drupal and WordPress projects.

### 40. story-point-estimator

**Triggers**: "story points", "estimate this", "how long will this take?", "complexity estimate", "velocity"
**Purpose**: Provide Fibonacci-based story point estimates (1, 2, 3, 5, 8, 13, 21, 34+) with hour conversions, platform-specific adjustments, and velocity calculations for sprint planning.

### 41. csv-exporter

**Triggers**: "export to CSV", "Teamwork backlog", "project backlog file", "import to Teamwork"
**Purpose**: Convert FRD requirements into Teamwork-ready CSV backlog with task hierarchy (epic/story/task prefixes), priority mapping, story-point-to-hours conversion, and consistent tagging.

### 42. client-request-triage

**Triggers**: "triage this", "look at this task", "help me respond to this client", Teamwork task or comment link provided
**Purpose**: Fetch a client Teamwork task, detect the platform (Drupal/WordPress/general), research 1–3 solution options, and draft a warm client-facing reply. Pauses for PM confirmation before drafting. Flags bug reports for re-routing.
**MCP dependencies**: Teamwork, web search

### 43. pm-meeting-prep

**Triggers**: "prep me for my meeting", "check-in with [client] tomorrow", "meeting prep for [project]"
**Purpose**: Aggregate context from Teamwork (tasks + messages), Gmail, Slack, and Fathom recordings into a structured client check-in briefing with talking points, blockers, and suggested next steps. Optionally generates a formatted meeting agenda.
**MCP dependencies**: Teamwork, Slack, Gmail, Fathom

### 44. project-heartbeat

**Triggers**: "time for a project update", "draft the heartbeat", "write up the update for [project]", "send a status update"
**Purpose**: Generate a client-facing project status update message for posting to a Teamwork message thread. Pulls completed tasks, Teamwork messages, Fathom meeting summaries, and Slack channel activity since the last heartbeat reply. Drafted in a warm, progress-forward voice with budget and timeline placeholder sections.
**MCP dependencies**: Teamwork, Slack, Fathom

### 45. qa-review

**Triggers**: "QA this", "validate this multidev", "test the dev link", "run QA on this task", Teamwork task with multidev URL
**Purpose**: Full QA review of a Teamwork task: reads task and all comments, extracts the multidev URL, detects the platform (Drupal/WordPress), builds a dynamic validation plan (base checklist + task-specific steps), executes the plan via CoWork browser automation, and produces a report with pass/fail per step, screenshots, internal notes, and a client-facing summary.
**MCP dependencies**: Teamwork, CoWork browser automation

### 46. strategist-site-audit

**Triggers**: "audit this site for strategy", "strategist audit", "UX audit", "discovery audit", "pre-discovery review", "UX laws audit", "content hierarchy review", site URL provided with strategy/discovery context
**Purpose**: Strategist-focused site audit for discovery and pre-discovery. Navigates the site via CoWork, audits against all 21 UX Laws from lawsofux.com (Jakob's Law, Fitts's Law, Hick's Law, Miller's Law, Peak-End Rule, Von Restorff Effect, Aesthetic-Usability, Doherty Threshold, Proximity, Similarity, Common Region, Uniform Connectedness, Prägnanz, Serial Position, Zeigarnik, Tesler's Law, Postel's Law, Goal-Gradient, Occam's Razor, Pareto Principle, Parkinson's Law), reviews content hierarchy, synthesises optional qualitative data (A/B tests, surveys, heatmaps), runs Lighthouse, and produces two deliverables: a Project Knowledge Summary (Markdown for Claude Desktop Projects) and a polished, iterable, client-facing HTML Artifact.
**Audience**: strategists, UX leads, PMs — not developers.
**Tool dependencies**: CoWork browser automation, web search (optional)

### 47. wp-plugin-to-private-package

**Triggers**: "make this plugin a Kanopi package", "move this committed plugin to Composer", "publish this premium plugin to Kanopi Packagist", "stop committing this plugin", "/wp-plugin-to-private-package"
**Purpose**: Convert a committed/hand-installed WordPress premium plugin into a Kanopi private Composer package and rewire the consuming site to install it via Composer. Follows Kanopi's WordPress Core and Plugins Installation Policy (§3 paid plugins, §4 Kanopi Private Packagist): creates a private GitHub repo in the kanopi org, sets topics/teams, tags a version release, and edits the project's composer.json/.gitignore. Requires explicit user confirmation (irreversible side effects).

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
