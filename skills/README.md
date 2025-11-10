# CMS Cultivator Agent Skills

This directory contains 9 Agent Skills that Claude automatically invokes during conversation when contextually appropriate.

## What Are Agent Skills?

Agent Skills are **model-invoked** capabilities—Claude decides when to use them based on your conversation, without you needing to type explicit commands.

### Skills vs. Slash Commands

| Feature | Slash Commands | Agent Skills |
|---------|----------------|--------------|
| **Location** | `/commands/` directory | `/skills/` directory |
| **Invocation** | User types `/command` | Claude activates automatically |
| **Use Case** | Explicit workflows | Conversational assistance |
| **Example** | `/pr-create PROJ-123` | "I need to commit my changes" |

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

### Complementary to Commands

Skills provide quick, conversational help. Commands provide comprehensive analysis:

- **Skill**: "Is this secure?" → Quick security scan of shown code
- **Command**: `/audit-security` → Full OWASP Top 10 site-wide scan

## File Structure

Each skill has its own directory with a `SKILL.md` file:

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
└── coverage-analyzer/
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
4. Consider if a slash command is more appropriate

## Skill Activation Philosophy

### When Skills Work Best

✅ Quick, focused assistance during conversation
✅ Single file/function/element analysis
✅ Immediate feedback needed
✅ User doesn't know specific command name

### When Commands Work Better

✅ Comprehensive project-wide analysis
✅ Structured workflows with side effects
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
