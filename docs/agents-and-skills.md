# Agents and Skills

CMS Cultivator features a two-tier architecture:

1. **Specialist Agents** - Orchestrate complex workflows (spawned by skills)
2. **Agent Skills** - Knowledge base (auto-invoked by context, or explicitly invoked)

---

## Specialist Agents

Agents are specialized AI assistants that handle complex, multi-step workflows. When you run a command, it spawns the appropriate agent to coordinate the work.

### Agent Architecture

**Leaf Specialists** (work independently):

- **documentation-specialist** - API docs, guides, and changelogs
- **responsive-styling-specialist** - Mobile-first SCSS generation with WCAG AA contrast
- **browser-validator-specialist** - Real-browser validation via Chrome DevTools MCP
- **drupalorg-issue-specialist** - drupal.org issue drafting and formatting
- **drupalorg-mr-specialist** - Merge request setup on git.drupalcode.org

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
| testing-specialist | `test-scaffolding`, `test-plan-generator`, `coverage-analyzer` | Inline security/a11y test scenarios |
| documentation-specialist | `documentation-generator` | Leaf |
| design-specialist | `design-to-wp-block`, `design-to-drupal-paragraph` | Code generation only |
| responsive-styling-specialist | `design-to-wp-block`, `design-to-drupal-paragraph` | Leaf |
| browser-validator-specialist | `design-to-wp-block`, `design-to-drupal-paragraph`, `browser-validator` | Leaf |
| drupalorg-issue-specialist | `drupal-contribute`, `drupal-issue` | Leaf |
| drupalorg-mr-specialist | `drupal-contribute`, `drupal-mr` | Leaf |

PR skills (`pr-create`, `pr-review`, `pr-release`, `commit-message-generator`) run directly from the main session — no agent is spawned.

### Agent-to-Skill Mapping

Each agent uses specific skills for detailed "how-to" knowledge:

| Agent | Uses Skills |
|-------|-------------|
| testing-specialist | test-scaffolding, test-plan-generator, coverage-analyzer |
| documentation-specialist | documentation-generator |
| design-specialist | design-analyzer, responsive-styling |
| drupalorg-issue-specialist | drupalorg-issue-helper |
| drupalorg-mr-specialist | drupalorg-contribution-helper |

PR skills (`pr-create`, `pr-review`, `pr-release`, `commit-message-generator`, `worktree-manager`) run directly from the main session — they use the relevant tooling (GitHub CLI, git) without an orchestrator agent.

### Why Agents?

**Benefits for Users:**
- 🚀 **Parallel Execution** - Multiple specialists work simultaneously (e.g., design-to-code pipelines)
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
| **Example** | design-to-wp-block skill spawns design, styling, and validation specialists | "I need to commit my changes" → commit-message-generator activates |
| **Explicit invoke** | — | `/pr-create PROJ-123` (Claude Code) or `@pr-create` (Codex) |

### Available Skills

### 1. commit-message-generator

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

### 6. coverage-analyzer

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

### 7. drupal-sdc-twig

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
✅ "How do I test this function?"
✅ "Does this follow Drupal standards?"
✅ "Should this heading be a prop or a slot?"
✅ "Need to document this API endpoint"
```

No need to remember command names or syntax!

### When to Invoke Skills Explicitly

Use explicit skill invocation when you want:

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
"Does this follow standards?" → Triggers code-standards-checker
"I need tests for this class" → Triggers test-scaffolding
"What's not covered by tests?" → Triggers coverage-analyzer
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
| pr-create | "create a PR", "open a pull request" | PR creation with generated description | `pr-create` |
| pr-review | "review this PR", "review my changes" | PR review or pre-PR self-review | `pr-review` |
| pr-release | "prepare a release", "generate a changelog" | Changelog + deployment checklist | `pr-release` |
| worktree-manager | "new worktree", "work on two tickets at once" | Parallel tickets/sessions with DDEV isolation | `worktree-manager` |
| code-standards-checker | "standards", "style" | Code review | `code-standards-checker` |
| test-scaffolding | "need tests", "how to test" | Single class tests | `test-scaffolding` |
| test-plan-generator | "test plan", "QA" | Test scenarios | `test-plan-generator` |
| coverage-analyzer | "coverage", "untested" | Test gaps | `coverage-analyzer` |
| documentation-generator | "document", "API docs" | Quick docblocks | `documentation-generator` |
| design-analyzer | Figma URL, uploaded mockup, "implement this design" | Extracting technical specs from designs | — |
| design-to-wp-block | "create a WordPress block from this design" | WordPress block patterns from designs | `design-to-wp-block` |
| design-to-drupal-paragraph | "create a Drupal paragraph from this design" | Drupal paragraph types from designs | `design-to-drupal-paragraph` |
| responsive-styling | Component styling, "responsive design" | Mobile-first SCSS with WCAG AA contrast | — |
| browser-validator | "test this", implementation just written | Real-browser responsive + accessibility validation | `browser-validator` |
| drupal-sdc-twig | "SDC", "Single Directory Component", "props or slots?", "embed vs include" | Drupal SDC + Twig best practices (props vs slots, attributes, escaping, schema, accessibility) | — |
| drupal-contribute | "contribute to drupal.org" | Full issue + MR contribution workflow | `drupal-contribute` |
| drupal-issue | "create a drupal.org issue" | drupal.org issue creation and updates | `drupal-issue` |
| drupal-mr | "create a drupal.org MR" | Merge requests on git.drupalcode.org | `drupal-mr` |
| drupal-cleanup | "cleanup drupal repos" | Local drupal.org clone cache cleanup | `drupal-cleanup` |
| drupalorg-issue-helper | "drupal.org issue template" | Quick issue formatting reference | — |
| drupalorg-contribution-helper | "drupal.org git workflow", "issue fork" | Quick git workflow reference | — |
| composer-patch-generator | "composer patch", "patch a contrib module", "cweagans", "diff -ruN", "extra.patches", "applies locally but fails in CI" | CI-safe patches for Composer packages (correct diff -ruN format, dist-archive base, composer.json wiring, verification) | `composer-patch-generator` |
| drupal-rector-update | "update rector", "rector.php", "DrupalSetProvider", "withComposerBased", "composer-based sets", "stop maintaining rector set lists" | Migrating Drupal Rector to Composer-based sets (automatic version selection, PHPStan 2.x upgrade, dry-run before apply) | `drupal-rector-update` |
| wp-add-skills | "add WordPress skills", "install the official WordPress agent-skills" | Installing the WordPress/agent-skills catalog | `wp-add-skills` |

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
- **self-review** → pr-review analyzes your branch
- **browser check** → browser-validator tests responsive behavior and accessibility
- **standards check** → code-standards-checker validates style

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
