# Agents and Skills

CMS Cultivator features a two-tier architecture:

1. **Specialist Agents** - Orchestrate complex workflows (spawned by skills)
2. **Agent Skills** - Knowledge base (auto-invoked by context, or explicitly invoked)

---

## Specialist Agents

Agents are specialized AI assistants that handle complex, multi-step workflows. When you run a command, it spawns the appropriate agent to coordinate the work.

### Agent Architecture

**Leaf Specialists** (work independently):

- **accessibility-specialist** - WCAG 2.1 Level AA compliance audits
- **performance-specialist** - Core Web Vitals and optimization analysis
- **security-specialist** - OWASP Top 10 vulnerability scanning
- **documentation-specialist** - API docs, guides, and changelogs
- **code-quality-specialist** - Code standards and technical debt assessment
- **structured-data-specialist** - JSON-LD/Schema.org auditing for SEO and AI discoverability
- **gtm-specialist** - Google Tag Manager performance auditing (requires Chrome DevTools MCP)
- **drupal-pantheon-devops-specialist** - Kanopi DevOps onboarding for Drupal/Pantheon projects

**Orchestrators** (coordinate complex workflows):

- **testing-specialist** - Test generation and coverage (inline security and accessibility test scenarios)
- **design-specialist** - Design-to-code generation (code generation only; skill spawns responsive-styling and browser-validator agents)

PR and development-workflow skills (`pr-create`, `pr-review`, `pr-release`, `commit-message-generator`, `worktree-manager`) run **directly from the main session** without an orchestrator agent — each skill contains its complete workflow.

### How Agents Work

```
"I need to commit my changes"
    ↓
Main session runs commit-message-generator skill directly
    ↓
    ├─→ Analyzes staged changes (git status, git diff)
    ├─→ Generates conventional commit message
    ↓
Presents for user approval → runs git commit

"create a PR"
    ↓
Main session runs pr-create skill directly
    ↓
    ├─→ Analyzes git changes
    ├─→ Reviews test coverage inline (Read/Glob)
    ├─→ Checks security concerns inline (Grep patterns)
    ├─→ Checks accessibility concerns inline (Grep on UI files)
    ├─→ Detects Drupal/WordPress deployment requirements
    ↓
Presents full PR description for user approval → runs gh pr create
```

### Agent Orchestration Patterns

#### Skill-Level Parallel Spawning

The **live-site-audit skill** spawns all 4 leaf specialists simultaneously from the main session:

```
/live-site-audit https://example.com
    ↓
Main session spawns ALL in parallel:
    ├─→ performance-specialist (Core Web Vitals)
    ├─→ accessibility-specialist (WCAG compliance)
    ├─→ security-specialist (vulnerability scan)
    └─→ code-quality-specialist (technical debt)
    ↓
Waits for all results
    ↓
Main session synthesizes unified report:
    - Executive summary
    - Critical issues
    - Prioritized remediation roadmap
```

#### Inline Quality Checks (Skill-Level)

The **`pr-create`** and **`pr-review`** skills perform quality checks inline directly from the main session — no agent in between:

```
PR with UI changes:
  → Reviews accessibility concerns inline using Read/Grep

PR with authentication code:
  → Reviews security concerns inline using Read/Grep

PR with new features:
  → Reviews test coverage inline using Read/Glob
```

#### Sequential Skill-Level Spawning

The **design-to-wp-block** and **design-to-drupal-paragraph** skills orchestrate sequential agent calls:

```
/design-to-wp-block [figma-url]
    ↓
Spawns design-specialist (code generation)
    ↓
Spawns responsive-styling-specialist (SCSS from design-specialist output)
    ↓
Spawns browser-validator-specialist (validation from test URL)
```

### Agent-to-Skill Mapping (Spawned By)

| Agent | Spawned By Skills | Notes |
|-------|-------------------|-------|
| accessibility-specialist | `accessibility-audit`, `live-site-audit` | Leaf |
| performance-specialist | `performance-audit`, `live-site-audit` | Leaf |
| gtm-specialist | `gtm-performance-audit` | Leaf |
| security-specialist | `security-audit`, `live-site-audit` | Leaf |
| testing-specialist | `test-scaffolding`, `test-plan-generator`, `coverage-analyzer` | Inline security/a11y test scenarios |
| documentation-specialist | `documentation-generator` | Leaf |
| code-quality-specialist | `quality-audit`, `code-standards-checker`, `live-site-audit` | Leaf |
| structured-data-specialist | `structured-data-analyzer` | Leaf |
| drupal-pantheon-devops-specialist | `devops-setup` | Leaf |
| design-specialist | `design-to-wp-block`, `design-to-drupal-paragraph` | Code generation only |
| responsive-styling-specialist | `design-to-wp-block`, `design-to-drupal-paragraph` | Leaf |
| browser-validator-specialist | `design-to-wp-block`, `design-to-drupal-paragraph`, `browser-validator` | Leaf |

PR skills (`pr-create`, `pr-review`, `pr-release`, `commit-message-generator`) run directly from the main session — no agent is spawned.

### Agent-to-Skill Mapping

Each agent uses specific skills for detailed "how-to" knowledge:

| Agent | Uses Skills |
|-------|-------------|
| accessibility-specialist | accessibility-checker |
| performance-specialist | performance-analyzer |
| gtm-specialist | gtm-performance-audit |
| security-specialist | security-scanner |
| testing-specialist | test-scaffolding, test-plan-generator, coverage-analyzer |
| documentation-specialist | documentation-generator |
| code-quality-specialist | code-standards-checker |
| structured-data-specialist | structured-data-analyzer |
| drupal-pantheon-devops-specialist | (none) |
| design-specialist | design-analyzer, responsive-styling, strategic-thinking |

Teamwork skills (`teamwork-task-creator`, `teamwork-integrator`, `teamwork-exporter`) and PR skills (`pr-create`, `pr-review`, `pr-release`, `commit-message-generator`) run directly from the main session — they use the relevant MCP server (Teamwork MCP, GitHub CLI) without an orchestrator agent.

### Why Agents?

**Benefits for Users:**
- 🚀 **Parallel Execution** - Multiple specialists work simultaneously (e.g., live audits)
- 🎯 **Comprehensive Checks** - Orchestrators ensure nothing is missed
- 📊 **Unified Reporting** - Clear, consolidated findings from multiple specialists
- 🔄 **Consistent Quality** - Each specialist follows best practices

**Benefits for Development:**
- 🧩 **Modular Design** - Each agent has one clear responsibility
- 🔧 **Composable** - Agents can be combined in new ways
- ✅ **Maintainable** - Clean separation of concerns
- 🔍 **Testable** - Each agent can be tested independently

---

## Agent Skills

Agent Skills are **model-invoked** capabilities—Claude decides when to use them based on your conversation context, without you needing to remember specific command names.

### Two-Tier System Explained

| Feature | Specialist Agents | Agent Skills |
|---------|-------------------|--------------|
| **Invocation** | Spawned by skills | Claude activates automatically, or user invokes explicitly |
| **Use Case** | Multi-step orchestration | Conversational assistance |
| **Execution** | Coordinates workflow with tools | Provides knowledge and guidance |
| **Example** | live-site-audit skill spawns 4 specialists in parallel | "I need to commit my changes" → commit-message-generator activates |
| **Explicit invoke** | — | `/pr-create PROJ-123` (Claude Code) or `@pr-create` (Codex) |

### Available Skills

#### 1. commit-message-generator

**Automatically triggers when you:**
- Say "I need to commit" or "ready to commit"
- Mention "staged changes" or "git commit"
- Ask "what should my commit message be?"

**What it does:**
- Analyzes `git diff --staged`
- Generates conventional commit message
- Follows project's commit style
- Includes proper scope and description

**Example:**
```
You: "I fixed the login bug, ready to commit"
Claude: "I'll generate a commit message for your login fix..."

Generated:
fix(auth): resolve session timeout on remember-me login

- Correct cookie expiration logic
- Add test coverage for remember-me flow

Would you like me to commit with this message?
```

**Explicit invocation:** `/commit-message-generator` - For explicit commit message generation

---

### 2. code-standards-checker

**Automatically triggers when you:**
- Ask "does this follow standards?"
- Show code and ask "is this properly formatted?"
- Mention "coding standards", "PHPCS", or "ESLint"
- Ask "should I fix the style?"

**What it does:**
- Detects project type (Drupal/WordPress/JavaScript)
- Runs appropriate linter (PHPCS, ESLint)
- Identifies style violations
- Provides fixes for common issues

**Example:**
```
You: "Does this follow WordPress coding standards?"
Claude: "Let me check against WordPress Coding Standards...

✅ Proper tab indentation
✅ Output properly escaped
⚠️ Missing docblock

Overall good! Just add a docblock above the function."
```

**Explicit invocation:** `/code-standards-checker` - For comprehensive project-wide standards checks

---

### 3. test-scaffolding

**Automatically triggers when you:**
- Show code and say "I need tests"
- Ask "how do I test this?"
- Mention "no tests yet" or "untested code"
- Say "should write unit tests"

**What it does:**
- Analyzes the code to test
- Generates appropriate test scaffolding
- Creates PHPUnit/Jest/Cypress tests
- Includes test cases for happy path and errors

**Example:**
```
You: "I just wrote this UserManager class, need tests"
Claude: "I'll generate PHPUnit tests for UserManager.

I see 3 methods: createUser(), getUser(), deleteUser().
I'll create tests for:
- Valid input (happy path)
- Invalid input (error cases)
- Edge cases (null, empty values)

[Generates test file with complete structure]"
```

**Explicit invocation:** `/test-scaffolding` - For batch test generation across modules

---

### 4. documentation-generator

**Automatically triggers when you:**
- Say "I need to document this"
- Ask "how do I write API docs?"
- Mention "README", "docblock", or "API documentation"
- Show code and ask "what docs do I need?"

**What it does:**
- Generates API documentation (docblocks)
- Creates README files
- Writes user guides
- Produces changelog entries

**Example:**
```
You: "Need to document this API endpoint"
Claude: "I'll generate API documentation for your endpoint.

[Generates complete docblock with:
- Description
- @param tags with types
- @return documentation
- @throws for exceptions
- Usage example]"
```

**Explicit invocation:** `/documentation-generator` - For comprehensive documentation projects

---

### 5. test-plan-generator

**Automatically triggers when you:**
- Ask "what should QA test?"
- Say "need a test plan"
- Mention "test scenarios" or "test cases"
- Show a feature and ask "how to test this?"

**What it does:**
- Analyzes features and changes
- Creates structured test scenarios
- Identifies test cases (happy path, errors, edge cases)
- Produces QA-ready test plans

**Example:**
```
You: "What should QA test for this login feature?"
Claude: "I'll create a test plan for the login feature.

Test Scenarios:
1. Successful login (valid credentials)
2. Failed login (invalid password)
3. Account lockout (3 failed attempts)
4. Remember me functionality
5. Password reset flow

[Generates complete test plan with steps and expected results]"
```

**Explicit invocation:** `/test-plan-generator` - For comprehensive QA documentation

---

### 6. accessibility-checker

**Automatically triggers when you:**
- Ask "is this accessible?"
- Show an element and ask "WCAG compliant?"
- Mention "screen reader", "keyboard navigation"
- Ask about "alt text" or "ARIA labels"

**What it does:**
- Checks specific elements for a11y issues
- Validates WCAG 2.1 Level AA compliance
- Identifies contrast, ARIA, keyboard issues
- Provides code fixes

**Example:**
```
You: "Is this button accessible?"
Claude: "Let me check that button for accessibility...

✅ Has accessible name (aria-label)
✅ Keyboard focusable
❌ Missing focus indicator (WCAG 2.4.7)
❌ Low contrast: 3.1:1 (needs 4.5:1)

Fixes:
button:focus { outline: 2px solid #0066cc; }
color: #333; /* Improves contrast to 4.8:1 */"
```

**Explicit invocation:** `/accessibility-audit` - For comprehensive site-wide accessibility audits

---

### 7. performance-analyzer

**Automatically triggers when you:**
- Say "this is slow" or "performance issue"
- Show code and ask "how to optimize?"
- Mention "page speed", "N+1 queries"
- Ask "why is this query slow?"

**What it does:**
- Analyzes database queries for N+1 issues
- Identifies missing indexes
- Suggests caching strategies
- Recommends optimization techniques

**Example:**
```
You: "This query is slow"
Claude: "I see an N+1 query problem:

Current: 101 queries (1 + 100 in loop)
Issue: Loading users in loop

Fix: Use eager loading
[Shows optimized code]

Impact: 101 queries → 2 queries (98% reduction)"
```

**Explicit invocation:** `/performance-audit` - For comprehensive performance audits with Core Web Vitals

---

### 8. security-scanner

**Automatically triggers when you:**
- Ask "is this secure?"
- Show code handling user input
- Mention "SQL injection", "XSS", "security"
- Ask "could this be exploited?"

**What it does:**
- Scans for OWASP Top 10 vulnerabilities
- Detects SQL injection risks
- Identifies XSS vulnerabilities
- Checks for missing CSRF protection

**Example:**
```
You: "Is this database query secure?"
Claude: "🔴 CRITICAL: SQL Injection vulnerability!

Current code concatenates user input directly.

Vulnerable:
$query = "SELECT * FROM users WHERE id = " . $_GET['id'];

Secure fix:
$query = db_select('users')->condition('id', $id, '=');

This prevents SQL injection attacks."
```

**Explicit invocation:** `/security-audit` - For comprehensive OWASP Top 10 security audits

---

### 9. coverage-analyzer

**Automatically triggers when you:**
- Ask "what's not tested?"
- Mention "test coverage" or "coverage report"
- Say "which code is untested?"
- Show code and ask "is this tested?"

**What it does:**
- Analyzes PHPUnit/Jest coverage
- Identifies untested code paths
- Suggests missing test cases
- Prioritizes critical untested code

**Example:**
```
You: "What code doesn't have tests?"
Claude: "Analyzing test coverage...

Overall: 72%

🔴 Critical gaps (0% coverage):
- PaymentProcessor.php (handles money!)
- AuthService.php (security-sensitive)

🟡 Partial coverage:
- UserManager.php (45%)
  ✅ Tested: getUser(), createUser()
  ❌ Missing: deleteUser(), updatePermissions()

Recommendation: Add tests for payment/auth first."
```

**Explicit invocation:** `/coverage-analyzer` - For comprehensive coverage analysis with trends

---

### 10. structured-data-analyzer

**Automatically triggers when you:**
- Ask "does this page have structured data?"
- Mention "JSON-LD", "Schema.org", or "rich results"
- Show HTML/template code for articles, events, products, or FAQs
- Ask "what Schema.org type should I use?"
- Say "add structured data" or "SEO schema"

**What it does:**
- Checks pages or templates for existing JSON-LD blocks
- Identifies applicable Schema.org types for content
- Validates against Google Rich Results requirements
- Provides ready-to-use JSON-LD examples
- Recommends CMS modules/plugins (Drupal Schema.org Metatag, WordPress Yoast)

**Example:**
```
You: "Does this blog template need structured data?"
Claude: "Yes! Blog posts should have Article/BlogPosting markup.

Required properties:
- headline, author, datePublished, image

Here's JSON-LD for your template:
{
  '@context': 'https://schema.org',
  '@type': 'Article',
  'headline': '...',
  'author': { '@type': 'Person', 'name': '...' },
  'datePublished': '...'
}

Use @id: '/blog/slug/#article' for entity linking."
```

**Explicit invocation:** `/structured-data-analyzer` - For comprehensive site-wide structured data audits with scoring
### 10. teamwork-task-creator

**Automatically triggers when you:**
- Say "create a task" or "make a ticket"
- Mention "track this work" or "create Teamwork task"
- Provide requirements that need documentation
- Ask "how do I create a task?"

**What it does:**
- Performs context-aware template selection
- Uses appropriate task template (bug/feature/qa/epic)
- Ensures all required sections included
- Provides properly formatted Teamwork task

**Example:**
```
You: "Create a task for fixing the broken newsletter signup"
Claude: "I'll create a Bug Report task since you mentioned 'broken'.

I need a few more details:
1. What's the exact error?
2. Where does this happen? (URL)
3. What browser did you observe this on?
4. What were the steps that led to the issue?

Once you provide these, I'll create a complete bug report."
```

**Explicit invocation:** `/teamwork-task-creator` in Claude Code, `@teamwork-task-creator` in Codex.

---

### 11. teamwork-integrator

**Automatically triggers when you:**
- Mention ticket numbers (PROJ-123, SITE-456)
- Ask "what's the status of [ticket]?"
- Say "show me task [number]"
- Reference Teamwork tasks conversationally

**What it does:**
- Quick status checks (read-only)
- Retrieves task details
- Links tickets in PR descriptions
- Provides project context

**Example:**
```
You: "What's the status of PROJ-123?"
Claude: "Let me check that for you...

## PROJ-123 Status

**Title:** Implement user authentication
**Status:** In Progress ⏳
**Assignee:** jane.developer
**Priority:** P1 (High)
**Due:** Jan 20, 2024

**Link:** https://example.teamwork.com/tasks/123

Jane updated this 2 hours ago: 'Google OAuth working on staging'"
```

**Explicit invocation:** `/teamwork-integrator` in Claude Code, `@teamwork-integrator` in Codex.

---

### 12. teamwork-exporter

**Automatically triggers when you:**
- Other agents complete audit reports
- Say "export to Teamwork" or "create tasks from this"
- Findings need project tracking
- Ask "can we track these in Teamwork?"

**What it does:**
- Converts audit findings to Teamwork tasks
- Maps severity to priority (Critical→P0, High→P1)
- Groups related issues into epics
- Links dependencies

**Example:**
```
You: "Export these security findings to Teamwork"
Claude: "I'll export these 8 security findings.

**Analysis:**
- 1 Critical (SQL injection) → P0
- 3 High (XSS vulnerabilities) → P1
- 4 Medium (CSRF) → P2

**Plan:**
- Create epic: 'Security Fixes'
- 8 individual bug report tasks
- Link dependencies

Creating tasks now...

✓ Export complete! Created:
- Epic: SEC-2024 (link)
- SEC-101: SQL Injection (P0)
- SEC-102-104: XSS Issues (P1)
- SEC-105-108: CSRF (P2)"
```

**Explicit invocation:** `/teamwork-exporter` in Claude Code, `@teamwork-exporter` in Codex.

---

### 13. strategic-thinking

**Automatically triggers when you:**
- Ask "should we do this?" or "is this the right approach?"
- Say "help me decide" or "help me think through this"
- Ask "what are the trade-offs?" or "pros and cons?"
- Are weighing options about architecture, tooling, platform, or delegating work
- Face a prioritization or go/no-go decision

**What it does:**
- Guides you through Brene Brown's 5 Cs of Strategic Thinking from *Strong Ground*
- Works through Context, Color, Connective Tissue, Cost, and Consequence conversationally
- Asks 1–2 focused questions per C to surface what's known and what's missing
- Synthesizes findings into a structured analysis with a clear recommendation

**The 5 Cs:**
- **Context** — History, parallel work, stakeholder expectations, prerequisites
- **Color** — Vision of success, urgency, ideation vs. committed decision
- **Connective Tissue** — Dependencies, ripple effects, anticipatory thinking
- **Cost** — Time, money, bandwidth, focus, opportunity cost
- **Consequence** — Stakes, cost of inaction, risk of getting it wrong

**Example:**
```
You: "Should we migrate to headless for this project?"
Claude: "Let's think through this with the 5 Cs. Context first: has the team
tried headless before, or is there a reason the current architecture was chosen?"

[... works through each C ...]

## Strategic Analysis: Headless Architecture Decision

### Context
- Previous attempt abandoned due to editorial complexity — root cause not resolved

### Consequence
- Repeating the same failure has high organizational cost

## Recommendation
Defer until editorial workflow requirements are defined.
Confidence: High | Next step: Document editorial requirements first
```

**Explicit invocation:** None — this skill activates conversationally for any significant decision

---

### 14. drupal-sdc-twig

**Automatically triggers when you:**
- Mention "SDC", "Single Directory Component", or "component.yml"
- Work with `components/` folders in a Drupal theme or module
- Write or review an SDC Twig template
- Ask "props or slots?", "embed vs include?", or "how should I structure this Drupal component?"

**What it does:**
- Guides props vs slots decisions (the most common SDC refactor source)
- Explains `.twig` extension (not `.html.twig`) and schema requirements
- Shows correct `attributes` object usage on root elements
- Demonstrates `include()` vs `embed` patterns for composition
- Covers escaping rules (never pass raw HTML through props)
- Provides accessibility checklist for component development
- Explains `libraryOverrides`, component replacement, and variants (Drupal 11.2+)

**Example:**
```
You: "Should this heading be a prop or a slot?"
Claude: "Use the props vs slots decision tree:

1. Will the template's HTML structure change based on this value?
   → Yes (heading_level affects <h2> vs <h3>) → prop
2. Will you render it 1:1 inside a container? → slot
3. Could it be a render array or nested component someday? → slot

For headings: expose heading_level as a prop (enum 2-6) and
heading_text as a slot. This lets consumers control the
document outline while passing any markup for the text."
```

**Explicit invocation:** None — this skill activates conversationally for Drupal SDC questions

---

## How to Use Agent Skills

### Natural Conversation

Simply talk to Claude naturally—the skills activate automatically:

```
✅ "I need to commit my changes"
✅ "Is this code accessible?"
✅ "How do I test this function?"
✅ "This query is slow"
✅ "Does this follow Drupal standards?"
```

No need to remember command names or syntax!

### When to Invoke Skills Explicitly

Use explicit skill invocation when you want:

**Full comprehensive analysis:**
- `accessibility-audit` / `@accessibility-audit` - Complete WCAG audit (not just one element)
- `performance-audit` / `@performance-audit` - Full performance analysis with Lighthouse
- `security-audit` / `@security-audit` - Complete OWASP Top 10 scan

**Structured workflows:**
- `pr-create` / `@pr-create` - Create PR with full description
- `pr-review 123` / `@pr-review 123` - Review specific PR
- `pr-release` / `@pr-release` - Generate changelog and deployment notes

**Batch operations:**
- `test-scaffolding` / `@test-scaffolding` - Generate tests for entire module
- `documentation-generator api` / `@documentation-generator api` - Generate all API documentation

!!! tip "Syntax by platform"
    Claude Code: prefix with `/` (e.g. `/pr-create PROJ-123`)
    OpenAI Codex: prefix with `@` (e.g. `@pr-create PROJ-123`)

## Skill Activation Tips

### Be Specific About Context

**Less effective:**
```
"Check this code"
```

**More effective:**
```
"Is this button accessible?" → Triggers accessibility-checker
"Is this query secure?" → Triggers security-scanner
"Does this follow standards?" → Triggers code-standards-checker
```

### Show Relevant Code

Skills work best when you show the code you're asking about:

```
"Here's my UserManager class:
[paste code]

I need tests for this."

→ Triggers test-scaffolding skill
```

### Use Natural Language

Don't try to "game" the system—just describe what you need:

```
✅ "I fixed the bug and I'm ready to commit"
❌ "Use commit-message-generator skill"
```

## Skills Reference Table

| Skill | Triggers On | Best For | Explicit Invocation |
|-------|-------------|----------|---------------------|
| commit-message-generator | "commit", "staged" | Quick commits | `commit-message-generator` |
| code-standards-checker | "standards", "style" | Code review | `code-standards-checker` |
| test-scaffolding | "need tests", "how to test" | Single class tests | `test-scaffolding` |
| documentation-generator | "document", "API docs" | Quick docblocks | `documentation-generator` |
| test-plan-generator | "test plan", "QA" | Test scenarios | `test-plan-generator` |
| accessibility-checker | "accessible?", "WCAG" | Element checks | `accessibility-audit` |
| performance-analyzer | "slow", "optimize" | Query optimization | `performance-audit` |
| gtm-performance-audit | "GTM", "tag manager", "marketing tags" | GTM tag analysis | `gtm-performance-audit` |
| security-scanner | "secure?", "exploit" | Code security | `security-audit` |
| coverage-analyzer | "coverage", "untested" | Test gaps | `coverage-analyzer` |
| structured-data-analyzer | "JSON-LD", "Schema.org", "structured data" | Schema.org checks | `structured-data-analyzer` |
| teamwork-task-creator | "create task", "make ticket" | Single task creation | `teamwork create` |
| teamwork-integrator | "PROJ-123", "status of" | Quick lookups | `teamwork status` |
| teamwork-exporter | "export to Teamwork" | Audit export | `teamwork export` |
| strategic-thinking | "should we do this?", "help me decide" | Decision making | — |
| frd-generator | "FRD", "functional requirements document", "structure requirements" | Project planning | — |
| story-point-estimator | "story points", "estimate this", "how long will this take?" | Sprint estimation | — |
| csv-exporter | "export to CSV", "Teamwork backlog", "import to Teamwork" | Backlog generation | — |
| client-request-triage | "triage this", "help me respond to this client", Teamwork link | Client request research + reply drafting (Teamwork MCP, web search) | — |
| pm-meeting-prep | "prep me for my meeting", "check-in tomorrow" | Cross-source client meeting prep (Teamwork, Slack, Gmail, Fathom MCPs) | — |
| project-heartbeat | "draft the heartbeat", "send a status update" | Client-facing status update messages (Teamwork, Slack, Fathom MCPs) | — |
| qa-review | "QA this", "validate this multidev", "test the dev link" | Multidev validation report from a Teamwork task (Teamwork MCP, CoWork) | — |
| strategist-site-audit | "audit this site for strategy", "strategist audit", "UX audit", "discovery audit" | Strategist-focused discovery audit: 21 UX Laws, content hierarchy, Lighthouse, qualitative data synthesis, Markdown summary + HTML Artifact (CoWork) | — |
| wp-plugin-to-private-package | "make this plugin a Kanopi package", "move this committed plugin to Composer", "publish this premium plugin to Kanopi Packagist" | Convert a committed WordPress premium plugin into a Kanopi private Composer package and rewire the site to install it via Composer (Installation Policy §3–§4) | `wp-plugin-to-private-package` |
| wp-devops-setup | "set up Kanopi DevOps for this Pantheon WordPress site", "onboard a Pantheon WordPress site", "convert this WP site to wp-pantheon-starter" | Onboard a Pantheon WordPress site to Kanopi's DevOps system (wp-pantheon-starter layout, DDEV, CircleCI → Pantheon, quality gates, Quicksilver); delegates premium-plugin packaging to wp-plugin-to-private-package. WordPress counterpart to devops-setup | `wp-devops-setup` |
| playwright-setup | "add Playwright", "set up Playwright", "Playwright e2e", "browser tests for this Drupal site" | Scaffold a Playwright e2e suite on a Kanopi Drupal + Pantheon project in DDEV — root runner, tests/e2e tree with Drupal login/global-setup + starter specs, CircleCI job against the PR multidev, and the playwright-* DDEV commands from the ddev-kanopi-drupal add-on (Pantheon deterrence-gate + default-role gotchas baked in) | `playwright-setup` |
| drupal-sdc-twig | "SDC", "Single Directory Component", "props or slots?", "embed vs include" | Drupal SDC + Twig best practices (props vs slots, attributes, escaping, schema, accessibility) | — |
| delivery-record | "create a delivery record", "delivery record for this PR/FRD/audit", end of a unit of work | Per-output attestation: draft a schema-typed, human-signed Delivery Record; refuses to write without a named reviewer + checkpoint notes; indexes in Teamwork (runs from the main session) | `delivery-record` |
| delivery-record-verify | "verify this delivery record", "validate the delivery records" | Validate a record against the `kanopi/delivery-record` schema + threshold rule (read-only, CI-friendly) | `delivery-record-verify` |
| composer-patch-generator | "composer patch", "patch a contrib module", "cweagans", "diff -ruN", "extra.patches", "applies locally but fails in CI" | CI-safe patches for Composer packages (correct diff -ruN format, dist-archive base, composer.json wiring, verification) | `composer-patch-generator` |

## Integration with Workflow

Agent Skills complement your development workflow:

### During Development
- **coding** → code-standards-checker validates style
- **wrote function** → documentation-generator adds docblocks
- **need tests** → test-scaffolding generates tests

### Before Committing
- **staged changes** → commit-message-generator creates message
- **is code tested?** → coverage-analyzer checks gaps

### Before PR
- **accessibility check** → accessibility-checker validates
- **security check** → security-scanner finds vulnerabilities
- **performance check** → performance-analyzer identifies issues

### During Code Review
- All skills available for reviewers to validate code

## Disabling Skills (If Needed)

Agent Skills are project-level by default. To disable:

**For current session:**
```bash
# Skills are in .claude/skills/ for team collaboration
# Or ~/.claude/skills/ for personal use
```

**To prevent auto-activation:**
Simply invoke the skill explicitly—Claude will respect your explicit choice.

## Learning More

- **General Skills Documentation**: [Claude Code Skills](https://code.claude.com/docs/en/skills)
- **Codex Plugin Documentation**: [OpenAI Codex Plugins](https://developers.openai.com/codex/plugins)
- **Creating Custom Skills**: See [Contributing](contributing.md) guide
- **Skills Reference**: See [Skills Overview](commands/overview.md)

---

**Key Takeaway**: Agent Skills make CMS Cultivator proactive—Claude helps automatically when it sees you need assistance, while explicit invocation gives you direct control over comprehensive workflows.
