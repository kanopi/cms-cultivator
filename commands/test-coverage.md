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

## Related Commands

- **[`/test-generate`](test-generate.md)** - Generate tests for untested code
- **[`/test-plan`](test-plan.md)** - Create QA test plan
- **[`/quality-analyze`](quality-analyze.md)** - Comprehensive quality analysis

## Resources

- [PHPUnit Code Coverage](https://phpunit.de/manual/current/en/code-coverage-analysis.html)
- [Jest Coverage](https://jestjs.io/docs/cli#--coverageboolean)
- [Martin Fowler on Test Coverage](https://martinfowler.com/bliki/TestCoverage.html)
- [coverage-analyzer Agent Skill](../skills/coverage-analyzer/SKILL.md)
