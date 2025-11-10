---
description: Generate comprehensive QA test plan based on code changes
allowed-tools: Bash(git:*), Read, Glob, Grep, Write
---

# Generate QA Test Plan

Generate comprehensive manual and automated test plans based on code changes, feature requirements, and risk analysis.

## Quick Start

```bash
# Generate test plan from current changes
/test-plan

# Claude will:
# - Analyze git changes
# - Identify features and risks
# - Create test scenarios
# - Generate test cases with steps
# - Provide acceptance criteria
```

## How It Works

This command uses the **test-plan-generator** Agent Skill to create structured test plans.

**For complete test plan structure and examples**, see:
→ [`skills/test-plan-generator/SKILL.md`](../skills/test-plan-generator/SKILL.md)

The skill provides detailed instructions for:
- Analyzing code changes for test scenarios
- Creating structured test cases
- Defining acceptance criteria
- Identifying test data requirements
- Assessing risk and priority

## When to Use

**Use this command (`/test-plan`)** when:
- ✅ Preparing comprehensive QA documentation
- ✅ Need formal test plan for stakeholders
- ✅ Planning testing for major feature release
- ✅ Documenting test strategy

**The skill auto-activates** when you ask:
- "What should QA test?"
- "Need test scenarios for this feature"
- "How do we test this?"

## Related Commands

- **[`/test-generate`](test-generate.md)** - Generate automated tests
- **[`/test-coverage`](test-coverage.md)** - Analyze test coverage
- **[`/pr-review`](pr-review.md)** - Review changes that need testing

## Resources

- [IEEE 829 Test Plan](https://en.wikipedia.org/wiki/IEEE_829)
- [Test Case Management Best Practices](https://www.guru99.com/test-case-management.html)
- [test-plan-generator Agent Skill](../skills/test-plan-generator/SKILL.md)
