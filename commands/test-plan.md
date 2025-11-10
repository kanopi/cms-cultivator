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

## Test Plan Structure

### 1. Test Scope
What's included and excluded from testing

### 2. Test Scenarios
High-level testing areas identified

### 3. Test Cases
Detailed steps, expected results, priority

### 4. Acceptance Criteria
What must pass for feature approval

### 5. Test Environment
Required setup, URLs, test accounts

### 6. Test Data Requirements
Data needed for testing scenarios

## Example Output

```markdown
# QA Test Plan - User Authentication

## Test Scope
### In Scope
- ✅ 2FA setup flow
- ✅ 2FA login flow
- ✅ Backup codes
- ✅ Recovery process

### Out of Scope
- ❌ SMS 2FA (future sprint)

## Test Scenarios

| Scenario | Steps | Expected Result | Priority |
|----------|-------|-----------------|----------|
| Enable 2FA | 1. Login<br>2. Settings<br>3. Enable 2FA | 2FA enabled, codes shown | High |
| Login with 2FA | Enter password + code | Logged in | Critical |

## Browser/Device Matrix

| Browser | Desktop | Mobile | Status |
|---------|---------|--------|--------|
| Chrome | ✅ | ✅ | To Test |
| Firefox | ✅ | ✅ | To Test |
| Safari | ✅ | ✅ | To Test |
```

## What Gets Generated

- ✅ Test scope (in/out of scope)
- ✅ Test scenarios with priority
- ✅ Detailed test cases with steps
- ✅ Expected results for each case
- ✅ Browser/device test matrix
- ✅ Test environment requirements
- ✅ Test data specifications
- ✅ Risk assessment
- ✅ Pass/fail criteria

## Related Commands

- **[`/test-generate`](test-generate.md)** - Generate automated tests
- **[`/test-coverage`](test-coverage.md)** - Analyze test coverage
- **[`/pr-review`](pr-review.md)** - Review changes that need testing

## Resources

- [IEEE 829 Test Plan](https://en.wikipedia.org/wiki/IEEE_829)
- [Test Case Management Best Practices](https://www.guru99.com/test-case-management.html)
- [test-plan-generator Agent Skill](../skills/test-plan-generator/SKILL.md)
