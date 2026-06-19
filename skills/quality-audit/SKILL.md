---
name: quality-audit
description: Comprehensive code quality analysis and technical debt assessment for Drupal and WordPress projects. Spawns code-quality-specialist for full analysis. Invoke when user runs /quality-analyze, requests a full code quality audit, needs technical debt assessment, or asks for comprehensive code quality analysis. Supports --quick, --standard, --comprehensive depth modes and scope/format/threshold flags.
---

# Quality Audit

Comprehensive code quality analysis and technical debt assessment using the code-quality-specialist agent.

## Usage

- `/quality-analyze` — Full code quality analysis (standard depth)
- `/quality-analyze --quick --scope=current-pr` — Pre-commit quality check
- `/quality-analyze --comprehensive --format=refactoring-plan` — Deep analysis with refactoring plan
- `/quality-analyze --standard --format=json` — CI/CD integration output
- `/quality-analyze complexity` — Legacy focus area (still supported)

## Arguments

### Depth Modes
- `--quick` — Complexity + critical code smells only (~5 min)
- `--standard` — Full analysis (default, ~15 min)
- `--comprehensive` — Include design patterns review (~30 min)

### Scope Control
- `--scope=current-pr` — Only files changed in current PR
- `--scope=recent-changes` — Files changed since main branch
- `--scope=module=<name>` — Specific module/directory
- `--scope=file=<path>` — Single file
- `--scope=entire` — Full codebase (default)

### Output Formats
- `--format=report` — Detailed technical report with code examples (default)
- `--format=json` — Structured JSON for CI/CD
- `--format=summary` — High-level summary with quality scores
- `--format=refactoring-plan` — Prioritized refactoring recommendations

### Quality Thresholds
- `--max-complexity=N` — Report functions with cyclomatic complexity > N (default: 15)
- `--min-grade=A|B|C` — Report files below specified grade

### Legacy Focus Areas (Still Supported)
`complexity`, `debt`, `patterns`, `maintainability`, `standards`

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() or bash tools are unavailable, perform quality analysis directly:

1. **Parse arguments** — Determine depth, scope, format, complexity threshold, and grade
2. **Identify files to analyze** — Use Glob to find PHP, JS, TS files
3. **Analyze code quality directly**:
   - Use Read and Grep to count conditional branches and loops (cyclomatic complexity)
   - Identify long functions (> 50 lines), large classes, and duplicated code patterns
   - Check naming conventions and documentation presence
   - Review SOLID principle adherence (single responsibility, dependency injection)
   - Check CMS-specific patterns (Drupal dependency injection, WordPress hook over direct calls)
   - Identify code smells: magic numbers, deeply nested conditions, God objects
4. **Generate report** — Format findings per requested output format, with quality scores
5. **Save report** — Write to `quality-analyze-YYYY-MM-DD-HHMM.md` and present path to user

**Supported checks in Tier 1**: code pattern analysis, complexity estimation, naming conventions, CMS-specific quality patterns.

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() available:

1. **Parse arguments** — Determine depth, scope, format, and thresholds
2. **Determine files** — For `--scope=current-pr`:
   ```bash
   git diff --name-only origin/main...HEAD | grep -E '\.(php|tsx?|jsx?)$'
   ```
   For `--scope=recent-changes`:
   ```bash
   git diff main...HEAD --name-only | grep -E '\.(php|tsx?|jsx?)$'
   ```
3. **Spawn code-quality-specialist**:
   ```
   Task(cms-cultivator:code-quality-specialist:code-quality-specialist,
        prompt="Analyze code quality and technical debt with:
          - Depth mode: {depth}
          - Scope: {scope}
          - Format: {format}
          - Max complexity: {max_complexity or 15}
          - Min grade: {min_grade or 'none'}
          - Focus area: {focus or 'complete analysis'}
          - Files to analyze: {file_list}
        Analyze complexity, assess technical debt, review design patterns, check maintainability, and apply CMS-specific standards for Drupal and WordPress. Save report to quality-analyze-YYYY-MM-DD-HHMM.md and present the file path.")
   ```
4. **Present results** to user with file path

## Quality Dimensions

### Code Complexity
- Cyclomatic complexity (target: ≤ 10 per function)
- Cognitive complexity (how hard to understand)
- Nesting depth (target: ≤ 4 levels)

### Technical Debt
- Code smells (magic numbers, long methods, duplicated code)
- Anti-patterns (God objects, spaghetti code, tight coupling)
- Dead code and unused dependencies

### Design Patterns
- SOLID principles adherence
- DRY (Don't Repeat Yourself)
- Separation of concerns
- Appropriate use of design patterns

### CMS-Specific Standards
- **Drupal**: Drupal coding standards (PHPCS), dependency injection over \Drupal::, render arrays over raw HTML
- **WordPress**: WordPress coding standards, hooks over direct function calls, $wpdb->prepare() for queries

## Related Skills

- **code-standards-checker** — Quick standards compliance checks (auto-activates on "does this follow standards?")
- **audit-export** — Export findings to CSV for project management tools
- **audit-report** — Generate client-facing executive summary from audit file
