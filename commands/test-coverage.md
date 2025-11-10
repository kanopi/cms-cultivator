---
description: Analyze test coverage and identify untested code paths
allowed-tools: Bash(vendor/bin/phpunit:*), Bash(ddev exec vendor/bin/phpunit:*), Bash(npm:*), Bash(ddev exec npm:*), Bash(ddev cypress-run:*), Bash(ddev cypress-install:*), Bash(ddev critical-run:*), Bash(ddev critical-install:*), Read, Glob, Grep
---

# Analyze Test Coverage

Analyze test coverage and identify untested code paths for PHP and JavaScript.

## Quick Start

### PHP Coverage (PHPUnit)

```bash
# Generate coverage report
vendor/bin/phpunit --coverage-text

# HTML coverage report
vendor/bin/phpunit --coverage-html coverage/

# Kanopi projects
ddev exec vendor/bin/phpunit --coverage-text
```

### JavaScript Coverage (Jest)

```bash
# Terminal coverage
npm test -- --coverage

# HTML report
npm test -- --coverage --coverageReporters=html
```

## How It Works

This command uses the **coverage-analyzer** Agent Skill to identify test gaps.

**For detailed coverage analysis and recommendations**, see:
→ [`skills/coverage-analyzer/SKILL.md`](../skills/coverage-analyzer/SKILL.md)

The skill provides detailed instructions for:
- Running coverage analysis (PHPUnit, Jest, Cypress)
- Identifying untested code paths
- Prioritizing coverage improvements
- Analyzing coverage trends
- Suggesting missing test cases

## When to Use

**Use this command (`/test-coverage`)** when:
- ✅ Need comprehensive coverage analysis
- ✅ Tracking coverage metrics over time
- ✅ Identifying critical untested code
- ✅ Preparing coverage reports for stakeholders

**The skill auto-activates** when you ask:
- "What code isn't tested?"
- "What's my test coverage?"
- "Which functions have no tests?"

## Example Output

```markdown
## Test Coverage Analysis

### Summary
- **Overall Coverage**: 72%
- **Files Analyzed**: 45
- **Tested**: 32 files
- **Untested**: 13 files

### Coverage by Type
- Classes: 85% (34/40)
- Methods: 68% (156/230)
- Lines: 72% (2,340/3,250)
- Branches: 58% (89/153)

### 🔴 Critical Gaps (No Tests)

**1. PaymentProcessor.php** - 0% coverage
- **Risk**: High - handles money
- **Methods untested**: processPayment(), refund(), validate()
- **Recommendation**: Add unit tests immediately

**2. AuthenticationService.php** - 0% coverage
- **Risk**: Critical - security component
- **Methods untested**: authenticate(), validateToken()
- **Recommendation**: Add security tests ASAP

### 🟡 Partial Coverage

**3. UserManager.php** - 45% coverage
- ✅ Tested: getUser(), createUser()
- ❌ Untested: deleteUser(), updatePermissions()
- **Recommendation**: Complete test suite

### ✅ Well Tested
- DataProcessor.php - 95%
- EmailService.php - 88%
- ValidationHelper.php - 100%
```

## Coverage Goals

### Industry Standards
- **Minimum**: 70% coverage
- **Good**: 80% coverage
- **Excellent**: 90%+ coverage

**Remember**: 100% coverage ≠ bug-free code

### What to Prioritize

**High Priority** (must test):
- Authentication/authorization
- Payment processing
- Data validation
- Security-sensitive code
- Critical business logic

**Medium Priority** (should test):
- API endpoints
- Form handlers
- Data transformations

**Low Priority** (optional):
- Simple getters/setters
- Configuration classes
- View rendering

## Related Commands

- **[`/test-generate`](test-generate.md)** - Generate tests for untested code
- **[`/test-plan`](test-plan.md)** - Create QA test plan
- **[`/quality-analyze`](quality-analyze.md)** - Comprehensive quality analysis

## Resources

- [PHPUnit Code Coverage](https://phpunit.de/manual/current/en/code-coverage-analysis.html)
- [Jest Coverage](https://jestjs.io/docs/cli#--coverageboolean)
- [Martin Fowler on Test Coverage](https://martinfowler.com/bliki/TestCoverage.html)
- [coverage-analyzer Agent Skill](../skills/coverage-analyzer/SKILL.md)
