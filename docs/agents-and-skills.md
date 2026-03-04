# Agents and Skills

CMS Cultivator features a three-tier architecture:

1. **Specialist Agents** - Orchestrate complex workflows (spawned by commands)
2. **Slash Commands** - User-facing interfaces (you invoke explicitly)
3. **Agent Skills** - Knowledge base (Claude invokes automatically during conversation)

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
- **gtm-specialist** - Google Tag Manager performance auditing (requires Chrome DevTools MCP)

**Orchestrators** (delegate to other agents):

- **workflow-specialist** - PR workflows (delegates to testing, security, accessibility)
- **live-audit-specialist** - Comprehensive site audits (delegates to performance, accessibility, security, code-quality)
- **testing-specialist** - Test generation and coverage (delegates to security, accessibility)

### How Agents Work

```
/pr-create PROJ-123
    ↓
Spawns workflow-specialist
    ↓
    ├─→ Analyzes git changes
    ├─→ Generates commit message (uses commit-message-generator skill)
    ├─→ Spawns testing-specialist (if tests changed)
    │   └─→ May spawn security-specialist (for security tests)
    ├─→ Spawns security-specialist (if security-critical code)
    ├─→ Spawns accessibility-specialist (if UI changes)
    ↓
Compiles all findings into PR description
    ↓
Creates PR via GitHub CLI
```

### Agent Orchestration Patterns

#### Parallel Execution

The **live-audit-specialist** spawns all 4 leaf specialists simultaneously:

```
/audit-live-site https://example.com
    ↓
Spawns live-audit-specialist
    ↓
Spawns ALL in parallel:
    ├─→ performance-specialist (Core Web Vitals)
    ├─→ accessibility-specialist (WCAG compliance)
    ├─→ security-specialist (vulnerability scan)
    └─→ code-quality-specialist (technical debt)
    ↓
Waits for all results
    ↓
Synthesizes unified report:
    - Executive summary
    - Critical issues
    - Prioritized remediation roadmap
```

#### Conditional Delegation

The **workflow-specialist** intelligently delegates based on code changes:

```
PR with UI changes:
  → Spawns accessibility-specialist

PR with authentication code:
  → Spawns security-specialist

PR with new features:
  → Spawns testing-specialist
      → May spawn security-specialist (if security tests needed)
      → May spawn accessibility-specialist (if UI tests needed)
```

### Agent-to-Command Mapping

| Agent | Used By Commands | Can Delegate To |
|-------|------------------|-----------------|
| workflow-specialist | `/pr-commit-msg`, `/pr-create`, `/pr-review`, `/pr-release` | testing, security, accessibility |
| accessibility-specialist | `/audit-a11y` | (none - leaf) |
| performance-specialist | `/audit-perf` | (none - leaf) |
| gtm-specialist | `/audit-gtm` | (none - leaf) |
| security-specialist | `/audit-security` | (none - leaf) |
| testing-specialist | `/test-generate`, `/test-plan`, `/test-coverage` | security, accessibility |
| documentation-specialist | `/docs-generate` | (none - leaf) |
| live-audit-specialist | `/audit-live-site` | performance, accessibility, security, code-quality |
| code-quality-specialist | `/quality-analyze`, `/quality-standards` | (none - leaf) |

### Agent-to-Skill Mapping

Each agent uses specific skills for detailed "how-to" knowledge:

| Agent | Uses Skills |
|-------|-------------|
| workflow-specialist | commit-message-generator |
| accessibility-specialist | accessibility-checker |
| performance-specialist | performance-analyzer |
| gtm-specialist | gtm-performance-audit |
| security-specialist | security-scanner |
| testing-specialist | test-scaffolding, test-plan-generator, coverage-analyzer |
| documentation-specialist | documentation-generator |
| code-quality-specialist | code-standards-checker |
| teamwork-specialist | teamwork-task-creator, teamwork-integrator, teamwork-exporter |
| live-audit-specialist | (none - pure orchestrator) |

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

### Three-Tier System Explained

| Feature | Slash Commands | Specialist Agents | Agent Skills |
|---------|----------------|-------------------|--------------|
| **Invocation** | User types `/command` | Commands spawn agents | Claude activates automatically |
| **Use Case** | User-facing interface | Multi-step orchestration | Conversational assistance |
| **Execution** | Spawns an agent | Coordinates workflow | Provides knowledge |
| **Example** | `/pr-create PROJ-123` | workflow-specialist orchestrates PR creation | "I need to commit my changes" |

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

**Related Command:** `/pr-commit-msg` - For explicit commit message generation

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

**Related Command:** `/quality-standards` - For comprehensive project-wide standards checks

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

**Related Command:** `/test-generate` - For batch test generation across modules

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

**Related Command:** `/docs-generate` - For comprehensive documentation projects

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

**Related Command:** `/test-plan` - For comprehensive QA documentation

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

**Related Command:** `/audit-a11y` - For comprehensive site-wide accessibility audits

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

**Related Command:** `/audit-perf` - For comprehensive performance audits with Core Web Vitals

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

**Related Command:** `/audit-security` - For comprehensive OWASP Top 10 security audits

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

**Related Command:** `/test-coverage` - For comprehensive coverage analysis with trends

---

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

**Related Command:** `/teamwork create` - For explicit Teamwork task creation

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

**Related Command:** `/teamwork status` - For explicit status checks

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

**Related Command:** `/teamwork export` - For explicit audit export

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

### When to Use Slash Commands Instead

Use explicit slash commands when you want:

**Full comprehensive analysis:**
- `/audit-a11y` - Complete WCAG audit (not just one element)
- `/audit-perf` - Full performance analysis with Lighthouse
- `/audit-security` - Complete OWASP Top 10 scan

**Structured workflows:**
- `/pr-create` - Create PR with full description
- `/pr-review 123` - Review specific PR
- `/pr-release` - Generate changelog and deployment notes

**Batch operations:**
- `/test-generate` - Generate tests for entire module
- `/docs-generate api` - Generate all API documentation

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

| Skill | Triggers On | Best For | Related Command |
|-------|-------------|----------|-----------------|
| commit-message-generator | "commit", "staged" | Quick commits | `/pr-commit-msg` |
| code-standards-checker | "standards", "style" | Code review | `/quality-standards` |
| test-scaffolding | "need tests", "how to test" | Single class tests | `/test-generate` |
| documentation-generator | "document", "API docs" | Quick docblocks | `/docs-generate` |
| test-plan-generator | "test plan", "QA" | Test scenarios | `/test-plan` |
| accessibility-checker | "accessible?", "WCAG" | Element checks | `/audit-a11y` |
| performance-analyzer | "slow", "optimize" | Query optimization | `/audit-perf` |
| gtm-performance-audit | "GTM", "tag manager", "marketing tags" | GTM tag analysis | `/audit-gtm` |
| security-scanner | "secure?", "exploit" | Code security | `/audit-security` |
| coverage-analyzer | "coverage", "untested" | Test gaps | `/test-coverage` |
| teamwork-task-creator | "create task", "make ticket" | Single task creation | `/teamwork create` |
| teamwork-integrator | "PROJ-123", "status of" | Quick lookups | `/teamwork status` |
| teamwork-exporter | "export to Teamwork" | Audit export | `/teamwork export` |

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
Simply use explicit slash commands instead—Claude will respect your explicit command choice.

## Learning More

- **General Skills Documentation**: [Claude Code Skills](https://code.claude.com/docs/en/skills)
- **Creating Custom Skills**: See [Contributing](contributing.md) guide
- **Slash Commands Reference**: See [Commands Overview](commands/overview.md)

---

**Key Takeaway**: Agent Skills make CMS Cultivator proactive—Claude helps automatically when it sees you need assistance, while Slash Commands give you explicit control over comprehensive workflows.
