---
description: Comprehensive code quality analysis and technical debt assessment using code-quality specialist
argument-hint: "[options]"
allowed-tools: Task, Bash(git:*)
---

Spawn the **code-quality-specialist** agent using:

```
Task(cms-cultivator:code-quality-specialist:code-quality-specialist,
     prompt="Analyze code quality and technical debt with the following parameters:
       - Depth mode: [quick/standard/comprehensive - parsed from arguments, default: standard]
       - Scope: [current-pr/recent-changes/module/file/entire - parsed from arguments, default: entire]
       - Format: [report/json/summary/refactoring-plan - parsed from arguments, default: report]
       - Max complexity threshold: [number - parsed from arguments, optional]
       - Min grade threshold: [A/B/C - parsed from arguments, optional]
       - Focus area: [use legacy focus argument if provided, otherwise 'complete analysis']
       - Files to analyze: [file list based on scope]
     Analyze code complexity, assess technical debt, review design patterns, check maintainability, and apply CMS-specific standards for Drupal and WordPress projects. Save the comprehensive audit report to a file (quality-analyze-YYYY-MM-DD-HHMM.md) and present the file path to the user.")
```

## Arguments

This command supports flexible argument modes for different use cases:

### Depth Modes
- `--quick` - Complexity + critical code smells only (~5 min) - Fast quality check
- `--standard` - Full analysis (default, ~15 min) - Comprehensive quality assessment
- `--comprehensive` - Include design patterns review (~30 min) - Deep analysis with architectural recommendations

### Scope Control
- `--scope=current-pr` - Only files changed in current PR (uses git diff)
- `--scope=recent-changes` - Files changed since main branch (git diff main...HEAD)
- `--scope=module=<name>` - Specific module/directory (e.g., `--scope=module=src/services`)
- `--scope=file=<path>` - Single file (e.g., `--scope=file=src/UserService.php`)
- `--scope=entire` - Full codebase (default)

### Output Formats
- `--format=report` - Detailed technical report with code examples (default)
- `--format=json` - Structured JSON for CI/CD integration
- `--format=summary` - High-level summary with quality scores
- `--format=refactoring-plan` - Prioritized refactoring recommendations

### Quality Thresholds
- `--max-complexity=N` - Report functions with cyclomatic complexity > N (default: 15)
- `--min-grade=A|B|C` - Report files below specified grade (A=excellent, B=good, C=acceptable)

### Legacy Focus Areas (Still Supported)
For backward compatibility, single-word focus areas without `--` prefix are treated as legacy focus filters:
- `complexity` - Focus on cyclomatic and cognitive complexity
- `debt` - Focus on technical debt and code smells
- `patterns` - Focus on design patterns and SOLID principles
- `maintainability` - Focus on code readability and documentation
- `standards` - Focus on coding standards compliance (use `/quality-standards` for auto-fix)

## Usage Examples

### Quick Checks
```bash
# Quick quality check on your changes
/quality-analyze --quick --scope=current-pr

# Quick check with strict complexity threshold
/quality-analyze --quick --max-complexity=10

# Quick check for below-B-grade code
/quality-analyze --quick --min-grade=B
```

### Standard Analysis
```bash
# Standard analysis (same as legacy `/quality-analyze`)
/quality-analyze

# Standard analysis on PR changes
/quality-analyze --scope=current-pr

# Standard analysis with JSON for CI/CD
/quality-analyze --standard --format=json

# Standard analysis on specific module
/quality-analyze --standard --scope=module=src/services
```

### Comprehensive Analysis
```bash
# Comprehensive pre-release analysis
/quality-analyze --comprehensive

# Comprehensive analysis with refactoring plan
/quality-analyze --comprehensive --format=refactoring-plan

# Comprehensive analysis on recent changes
/quality-analyze --comprehensive --scope=recent-changes
```

### Legacy Syntax (Still Works)
```bash
# Focus on specific area (legacy)
/quality-analyze complexity
/quality-analyze debt
/quality-analyze patterns

# Combine legacy focus with new modes
/quality-analyze complexity --quick
/quality-analyze debt --scope=current-pr --max-complexity=10
```

## How It Works

This command spawns the **code-quality-specialist** agent, which uses the **code-standards-checker** skill and performs comprehensive code quality analysis.

### 1. Parse Arguments

The command first parses the arguments to determine the analysis parameters:

**Depth mode:**
- Check for `--quick`, `--standard`, or `--comprehensive` flags
- Default: `--standard` (if not specified)

**Scope:**
- Check for `--scope=<value>` flag
- If `--scope=current-pr`: Get changed files using `git diff --name-only origin/main...HEAD`
- If `--scope=recent-changes`: Get files changed since main using `git diff main...HEAD --name-only`
- If `--scope=module=<name>`: Target specific directory
- If `--scope=file=<path>`: Target single file
- Default: `--scope=entire` (analyze entire codebase)

**Format:**
- Check for `--format=<value>` flag
- Options: `report` (default), `json`, `summary`, `refactoring-plan`
- Default: `--format=report`

**Thresholds:**
- Check for `--max-complexity=N` flag (report functions with complexity > N)
- Check for `--min-grade=<grade>` flag (report files below grade)
- Used for CI/CD quality gates

**Legacy focus area:**
- If argument doesn't start with `--`, treat as legacy focus area
- Examples: `complexity`, `debt`, `patterns`, `maintainability`, `standards`
- Can be combined with new flags: `/quality-analyze complexity --quick`

### 2. Determine Files to Analyze

Based on the scope parameter:

**For `current-pr`:**
```bash
git diff --name-only origin/main...HEAD | grep -E '\.(php|tsx?|jsx?)$'
```

**For `recent-changes`:**
```bash
git diff main...HEAD --name-only | grep -E '\.(php|tsx?|jsx?)$'
```

**For `module=<name>` or `file=<path>`:**
Analyze the specified directory or single file.

**For `entire`:**
Analyze all relevant files in the codebase.

### 3. Spawn Code Quality Specialist

Pass all parsed parameters to the agent:
```
Task(cms-cultivator:code-quality-specialist:code-quality-specialist,
     prompt="Run code quality analysis with:
       - Depth mode: {depth}
       - Scope: {scope}
       - Format: {format}
       - Max complexity: {max_complexity or 15}
       - Min grade: {min_grade or 'none'}
       - Focus area: {focus or 'complete analysis'}
       - Files to analyze: {file_list}")
```

### The Code Quality Specialist Will

1. **Analyze code complexity** - Cyclomatic complexity, cognitive complexity
2. **Assess technical debt** - Code smells, anti-patterns, refactoring needs
3. **Review design patterns** - SOLID principles, DRY, separation of concerns
4. **Check maintainability** - Code readability, documentation, naming conventions
5. **CMS-specific patterns**:
   - **Drupal**: Drupal coding standards, dependency injection, render arrays
   - **WordPress**: WordPress coding standards, hooks over direct calls, security practices

**Focus areas**: `complexity`, `debt`, `patterns`, `maintainability`, `standards`

---

## Tool Usage

**Allowed operations:**
- ✅ Spawn code-quality-specialist agent
- ✅ Analyze cyclomatic and cognitive complexity
- ✅ Check coding standards compliance (PHPCS, ESLint, Drupal/WordPress standards)
- ✅ Review design patterns and SOLID principles
- ✅ Assess technical debt and maintainability
- ✅ Generate quality reports with refactoring recommendations

**Not allowed:**
- ❌ Do not modify code directly (provide recommendations in report)
- ❌ Do not automatically refactor code
- ❌ Do not commit changes

The code-quality-specialist agent performs all quality analysis operations.

---

## Agent Used

**code-quality-specialist** - Code quality and technical debt analyst with CMS-specific standards knowledge.

---

## Exporting to Project Management Tools

After audit completes, export findings as CSV:

```bash
/export-audit-csv [report-filename]
```

Generates Teamwork-compatible CSV for importing tasks into project management tools (also works with Jira, Monday, Linear).
