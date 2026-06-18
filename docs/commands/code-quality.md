# Code Quality Skills

Maintain standards and reduce technical debt with flexible argument modes for different use cases.

## Skills

- `quality-audit [options]` — Comprehensive code quality analysis and technical debt assessment
- `code-standards-checker [standard]` — Check coding standards compliance (PHPCS, ESLint)

## quality-audit Skill

### Flexible Argument Modes

CMS Cultivator now supports multiple operation modes for quality analysis:

#### Quick Checks During Development
```bash
/quality-audit --quick --scope=current-pr
/quality-audit --quick --max-complexity=10
/quality-audit --quick --min-grade=B
```
- ⚡ Fast execution (~5 min)
- 🎯 Complexity + critical code smells only
- 💰 Lower token costs
- ✅ Perfect for pre-commit checks

#### Standard Analysis (Default)
```bash
/quality-audit
/quality-audit --scope=current-pr
/quality-audit --standard --scope=module=src/services
```
- 🔍 Comprehensive analysis (~15 min)
- ✅ Full complexity, standards, debt, maintainability
- 📊 Detailed refactoring recommendations

#### Comprehensive Analysis (Pre-Release)
```bash
/quality-audit --comprehensive
/quality-audit --comprehensive --format=refactoring-plan
/quality-audit --comprehensive --scope=recent-changes
```
- 🔬 Deep analysis (~30 min)
- 💎 Design patterns + SOLID principles review
- 📋 Architectural recommendations

### Argument Options

#### Depth Modes
- `--quick` - Complexity + critical code smells (~5 min)
- `--standard` - Full quality analysis (default, ~15 min)
- `--comprehensive` - Include design patterns review (~30 min)

#### Scope Control
- `--scope=current-pr` - Only files changed in current PR
- `--scope=recent-changes` - Files changed since main branch
- `--scope=module=<name>` - Specific module/directory
- `--scope=file=<path>` - Single file
- `--scope=entire` - Full codebase (default)

#### Output Formats
- `--format=report` - Detailed technical report (default)
- `--format=json` - JSON for CI/CD integration
- `--format=summary` - High-level summary with grades
- `--format=refactoring-plan` - Prioritized refactoring recommendations

#### Quality Thresholds
- `--max-complexity=N` - Report functions with complexity > N (default: 15)
- `--min-grade=A|B|C` - Report files below specified grade

### Legacy Focus Options (Still Supported)

For backward compatibility, focus areas without `--` prefix still work:
- `complexity` - Cyclomatic and cognitive complexity
- `debt` - Technical debt and code smells
- `patterns` - Design patterns and SOLID principles
- `maintainability` - Code readability and documentation
- `standards` - Coding standards compliance

### CI/CD Integration

Export results as JSON for quality gates:

```yaml
# GitHub Actions example
- name: Run quality analysis
  run: /quality-audit --standard --format=json > quality.json

- name: Check complexity threshold
  run: |
    AVG_COMPLEXITY=$(jq '.summary.average_complexity' quality.json)
    if (( $(echo "$AVG_COMPLEXITY > 10" | bc -l) )); then
      echo "Average complexity exceeds threshold"
      exit 1
    fi

- name: Check grade threshold
  run: |
    GRADE=$(jq -r '.quality_score' quality.json)
    if [[ "$GRADE" != "A" && "$GRADE" != "B" ]]; then
      echo "Quality grade below B threshold"
      exit 1
    fi
```

### Common Workflows

**Pre-Commit:**
```bash
/quality-audit --quick --scope=current-pr --max-complexity=10
```

**PR Review:**
```bash
/quality-audit --standard --scope=current-pr
```

**Pre-Release:**
```bash
/quality-audit --comprehensive --format=refactoring-plan
```

**Specific Module:**
```bash
/quality-audit --standard --scope=module=src/services
```

**Recent Changes:**
```bash
/quality-audit --standard --scope=recent-changes
```

## code-standards-checker Skill

Check coding standards compliance with PHPCS/ESLint for Drupal and WordPress projects.

```bash
/code-standards-checker          # Auto-detect standards
/code-standards-checker drupal   # Drupal coding standards
/code-standards-checker wordpress # WordPress coding standards
```

See [Skills Overview](overview.md) for detailed usage.
