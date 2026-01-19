# Argument Mode Expansion Analysis

**Date:** 2026-01-18
**Purpose:** Identify commands that would benefit from enhanced argument modes and multiple operation modes

## Executive Summary

**Current state:** 14 of 17 commands accept arguments, but most use simple single-purpose arguments.

**Recommendation:** Add **mode-based arguments** to audit and quality commands to provide multiple levels of analysis depth, output formats, and scope options.

**Priority targets:** audit-a11y, audit-perf, audit-security, quality-analyze (4 commands)

---

## Current Argument Usage

### Commands with Arguments (14/17)

```
audit-a11y: [focus-area]
audit-live-site: [url]
audit-perf: [focus-area]
audit-security: [focus-area]
design-to-block: [design-source] [pattern-name] [theme-namespace]
design-to-paragraph: [design-source] [paragraph-name] [module-name]
design-validate: [test-url] [design-reference]
docs-generate: [doc-type]
pr-create: [ticket-number] [--concise]
pr-release: [version-or-focus]
pr-review: [pr-number|self] [focus-area]
quality-analyze: [focus-area]
quality-standards: [standard]
test-coverage: [path]
test-generate: [test-type]
test-plan: [focus-area]
```

### Commands without Arguments (3/17)

```
pr-commit-msg: (no arguments)
```

Note: pr-commit-msg doesn't need arguments (operates on staged changes)

---

## Argument Mode Patterns

### Pattern 1: Focus Area (Current)
Simple filtering by area of concern.

**Example:** `/audit-a11y contrast`
- Focuses on color contrast only
- Other checks are skipped

**Limitation:** Binary (check area or don't)

---

### Pattern 2: Mode-Based (Proposed)
Multiple operation modes with different depths/outputs.

**Example:** `/audit-a11y --quick` or `/audit-a11y --comprehensive`
- `--quick`: Fast check, critical issues only
- `--standard`: Normal depth (default)
- `--comprehensive`: Deep dive, all issues

**Benefit:** Flexible depth control

---

### Pattern 3: Output Format (Proposed)
Different output formats for different audiences.

**Example:** `/audit-a11y --format=json` or `/audit-a11y --format=markdown`
- `--format=json`: Machine-readable for CI/CD
- `--format=markdown`: Human-readable report
- `--format=executive`: Stakeholder summary

**Benefit:** Integration flexibility

---

### Pattern 4: Scope Control (Proposed)
Different scopes of analysis.

**Example:** `/audit-security --scope=recent-changes` or `/audit-security --scope=entire-codebase`
- `--scope=recent-changes`: Git diff since main
- `--scope=pr`: Current PR changes only
- `--scope=entire-codebase`: Full project scan

**Benefit:** Time/cost control

---

## Priority Command Analysis

### 1. audit-a11y (High Priority)

**Current arguments:** `[focus-area]`
- Options: `contrast`, `keyboard`, `aria`, `semantic-html`

**Proposed enhancement:**

```bash
# Depth modes
/audit-a11y --quick              # Critical WCAG AA failures only (5 min)
/audit-a11y --standard           # Default, full WCAG AA audit (15 min)
/audit-a11y --comprehensive      # WCAG AA + AAA + best practices (30 min)

# Scope modes
/audit-a11y --scope=current-pr   # Only files changed in current PR
/audit-a11y --scope=module       # Specific module/component
/audit-a11y --scope=entire       # Full codebase (default)

# Output formats
/audit-a11y --format=report      # Detailed markdown report (default)
/audit-a11y --format=json        # JSON for CI/CD integration
/audit-a11y --format=checklist   # Simple pass/fail checklist

# Combined
/audit-a11y --quick --scope=current-pr --format=checklist
```

**Benefits:**
- ✅ Quick pre-commit checks (`--quick --scope=current-pr`)
- ✅ Comprehensive pre-release audits (`--comprehensive`)
- ✅ CI/CD integration (`--format=json`)
- ✅ Stakeholder reports (`--format=executive`)

---

### 2. audit-perf (High Priority)

**Current arguments:** `[focus-area]`
- Options: `queries`, `assets`, `caching`, `core-web-vitals`

**Proposed enhancement:**

```bash
# Depth modes
/audit-perf --quick              # Core Web Vitals only (5 min)
/audit-perf --standard           # CWV + major bottlenecks (15 min)
/audit-perf --comprehensive      # Full profiling + recommendations (30 min)

# Scope modes
/audit-perf --scope=frontend     # Assets, CSS, JS, images only
/audit-perf --scope=backend      # Database, queries, caching only
/audit-perf --scope=both         # Frontend + backend (default)

# Output formats
/audit-perf --format=report      # Detailed report with metrics
/audit-perf --format=metrics     # Key metrics only (LCP, INP, CLS)
/audit-perf --format=recommendations  # Actionable fixes only

# Target thresholds
/audit-perf --target=good        # Report only if < 2.5s LCP
/audit-perf --target=needs-improvement  # Report if > 4.0s LCP

# Combined
/audit-perf --quick --scope=frontend --format=metrics
```

**Benefits:**
- ✅ Quick health checks (`--quick --format=metrics`)
- ✅ Focused optimization (`--scope=frontend`)
- ✅ CI/CD performance budgets (`--target=good --format=json`)

---

### 3. audit-security (High Priority)

**Current arguments:** `[focus-area]`
- Options: `injection`, `auth`, `xss`, `csrf`

**Proposed enhancement:**

```bash
# Depth modes
/audit-security --quick          # OWASP Top 3 only (SQL injection, XSS, auth)
/audit-security --standard       # OWASP Top 10 (default)
/audit-security --comprehensive  # OWASP Top 10 + CVE scanning + config review

# Scope modes
/audit-security --scope=user-input     # Focus on forms, queries, file uploads
/audit-security --scope=auth           # Focus on authentication/authorization
/audit-security --scope=api            # Focus on API endpoints
/audit-security --scope=entire         # Full codebase (default)

# Severity thresholds
/audit-security --min-severity=high    # Only report high/critical
/audit-security --min-severity=medium  # Report medium+ (default)
/audit-security --min-severity=low     # Report all findings

# Output formats
/audit-security --format=report        # Detailed security report
/audit-security --format=summary       # Executive summary
/audit-security --format=sarif         # SARIF format for security tools

# Combined
/audit-security --quick --scope=user-input --min-severity=high
```

**Benefits:**
- ✅ Fast pre-commit checks (`--quick --scope=user-input`)
- ✅ Focused reviews (`--scope=auth`)
- ✅ Security tool integration (`--format=sarif`)
- ✅ Noise reduction (`--min-severity=high`)

---

### 4. quality-analyze (Medium Priority)

**Current arguments:** `[focus-area]`
- Options: `complexity`, `debt`, `patterns`, `maintainability`, `standards`

**Proposed enhancement:**

```bash
# Depth modes
/quality-analyze --quick          # Complexity + critical code smells only
/quality-analyze --standard       # Full analysis (default)
/quality-analyze --comprehensive  # Include design patterns review

# Scope modes
/quality-analyze --scope=recent-changes  # Git diff since main
/quality-analyze --scope=module          # Specific module
/quality-analyze --scope=entire          # Full codebase (default)

# Thresholds
/quality-analyze --max-complexity=15     # Report functions > 15 complexity
/quality-analyze --min-grade=B           # Report files below B grade

# Output formats
/quality-analyze --format=report         # Detailed technical report
/quality-analyze --format=summary        # High-level summary
/quality-analyze --format=refactoring-plan  # Prioritized refactoring recommendations

# Combined
/quality-analyze --quick --scope=recent-changes --max-complexity=10
```

**Benefits:**
- ✅ Fast pre-commit quality checks
- ✅ Focused refactoring (`--format=refactoring-plan`)
- ✅ Complexity budgets in CI/CD

---

## Implementation Strategy

### Phase 1: Add Mode Support to Priority Commands (Week 1)

**Commands:** audit-a11y, audit-perf, audit-security, quality-analyze

**Implementation:**
1. Update command frontmatter to document new argument syntax
2. Parse mode arguments in command prompt
3. Pass modes to specialist agents
4. Update agent prompts to respect modes

**Example implementation for audit-a11y:**

```markdown
---
description: Comprehensive accessibility audit
argument-hint: [options]
allowed-tools: Task
---

## Arguments

### Depth Modes
- `--quick` - Critical WCAG AA failures only (5 min)
- `--standard` - Full WCAG AA audit (default, 15 min)
- `--comprehensive` - WCAG AA + AAA + best practices (30 min)

### Scope Modes
- `--scope=current-pr` - Only files in current PR
- `--scope=module=<name>` - Specific module/component
- `--scope=entire` - Full codebase (default)

### Output Formats
- `--format=report` - Detailed markdown (default)
- `--format=json` - JSON for CI/CD
- `--format=checklist` - Simple pass/fail list

## Usage Examples

```bash
# Quick check before commit
/audit-a11y --quick --scope=current-pr

# Full audit before release
/audit-a11y --comprehensive

# CI/CD integration
/audit-a11y --standard --format=json

# Focus on specific module
/audit-a11y --scope=module=user-profile
```
```

---

### Phase 2: Add Format Output Support (Week 2)

**Implement format handlers:**
- `--format=json` → Structured JSON output
- `--format=markdown` → Human-readable report (default)
- `--format=summary` → Executive summary
- `--format=checklist` → Simple pass/fail

**Benefits:**
- CI/CD integration (JSON)
- Stakeholder reports (summary)
- Quick checks (checklist)

---

### Phase 3: Add Scope Control (Week 3)

**Implement scope handlers:**
- `--scope=current-pr` → Analyze git diff only
- `--scope=module=<name>` → Analyze specific directory
- `--scope=file=<path>` → Analyze specific file
- `--scope=entire` → Full codebase (default)

**Benefits:**
- Faster execution
- Targeted analysis
- Cost control (fewer tokens)

---

## Secondary Command Enhancements

### 5. quality-standards (Low Priority)

**Current:** `[standard]` (e.g., `drupal`, `wordpress`, `psr12`)

**Proposed enhancement:**

```bash
# Auto-fix modes
/quality-standards --fix          # Auto-fix all fixable violations
/quality-standards --dry-run      # Show what would be fixed

# Severity filters
/quality-standards --errors-only  # Only report errors (not warnings)
```

---

### 6. test-coverage (Low Priority)

**Current:** `[path]`

**Proposed enhancement:**

```bash
# Thresholds
/test-coverage --min=80           # Fail if coverage < 80%
/test-coverage --critical-only    # Only check critical code paths

# Output formats
/test-coverage --format=report    # Detailed report
/test-coverage --format=summary   # Just percentages
```

---

### 7. test-generate (Low Priority)

**Current:** `[test-type]` (e.g., `unit`, `integration`, `e2e`)

**Proposed enhancement:**

```bash
# Generation modes
/test-generate --all              # Generate all test types
/test-generate --missing-only     # Only for untested code

# Frameworks
/test-generate --framework=jest   # Use Jest (JavaScript)
/test-generate --framework=phpunit # Use PHPUnit (PHP)
```

---

## Implementation Guidelines

### Argument Parsing Pattern

```markdown
## Parse Arguments

Check for mode flags:
- `--quick` or `--standard` or `--comprehensive` → Set depth mode
- `--scope=<value>` → Set analysis scope
- `--format=<value>` → Set output format
- `--min-severity=<value>` → Set threshold

Default values:
- Depth: `--standard` (if not specified)
- Scope: `--scope=entire` (if not specified)
- Format: `--format=report` (if not specified)

Pass to agent:
```
Task(cms-cultivator:accessibility-specialist:accessibility-specialist,
     prompt="Run accessibility audit with mode: {depth}, scope: {scope}, format: {format}")
```
```

---

## Backward Compatibility

### Maintain Legacy Arguments

**Old style:** `/audit-a11y contrast`
**New style:** `/audit-a11y --focus=contrast`

**Support both:**
- If argument doesn't start with `--`, treat as focus area (legacy)
- If argument starts with `--`, parse as mode flag

**Example:**
```
/audit-a11y contrast           → Focus on contrast (legacy)
/audit-a11y --focus=contrast   → Focus on contrast (new)
/audit-a11y --quick            → Quick mode (new)
```

---

## User Documentation

### Add to Command Documentation

For each enhanced command, add:

```markdown
## Command Modes

This command supports multiple operation modes:

### Quick Mode (`--quick`)
Fast analysis focusing on critical issues only.
**Use when:** Pre-commit checks, rapid iteration
**Time:** ~5 minutes
**Example:** `/audit-a11y --quick --scope=current-pr`

### Standard Mode (default)
Comprehensive analysis of all areas.
**Use when:** Regular development, PR reviews
**Time:** ~15 minutes
**Example:** `/audit-a11y` or `/audit-a11y --standard`

### Comprehensive Mode (`--comprehensive`)
Deep analysis including best practices.
**Use when:** Pre-release audits, compliance reviews
**Time:** ~30 minutes
**Example:** `/audit-a11y --comprehensive`

## Scope Control

Control what code is analyzed:
- `--scope=current-pr` - Only files changed in current PR
- `--scope=module=<name>` - Specific module/directory
- `--scope=file=<path>` - Single file
- `--scope=entire` - Full codebase (default)

## Output Formats

Choose how results are presented:
- `--format=report` - Detailed markdown report (default)
- `--format=json` - JSON for CI/CD integration
- `--format=summary` - Executive summary
- `--format=checklist` - Simple pass/fail list

## Combining Options

```bash
# Quick check on current changes
/audit-a11y --quick --scope=current-pr --format=checklist

# Comprehensive audit for release
/audit-a11y --comprehensive --format=report

# CI/CD integration
/audit-a11y --standard --format=json --scope=entire
```
```

---

## Final Recommendations

### ✅ Implement Argument Modes for These 4 Commands

**Priority 1 (Week 1):**
1. **audit-a11y** - Add `--quick`, `--comprehensive`, `--scope`, `--format`
2. **audit-perf** - Add `--quick`, `--comprehensive`, `--scope`, `--format`
3. **audit-security** - Add `--quick`, `--comprehensive`, `--scope`, `--format`, `--min-severity`
4. **quality-analyze** - Add `--quick`, `--comprehensive`, `--scope`, `--format`

**Benefits:**
- ✅ Faster pre-commit checks (`--quick --scope=current-pr`)
- ✅ Flexible audit depth
- ✅ CI/CD integration (`--format=json`)
- ✅ Cost control (scope limiting)

### 📋 Document Argument Patterns

Add comprehensive argument documentation to each enhanced command showing:
- All available modes
- Usage examples
- When to use each mode
- Performance characteristics

### 🔄 Maintain Backward Compatibility

- Support legacy argument style (no `--` prefix)
- Default to standard mode if no mode specified
- Preserve existing behavior

---

## Effort Estimate

**Per command:**
- Command documentation update: 1 hour
- Agent prompt updates: 0.5 hours
- Testing: 0.5 hours
- **Total per command:** 2 hours

**For 4 priority commands:**
- **Total effort:** 8 hours

**Matches improvement plan estimate:** ✅ 6-8 hours

---

## Success Metrics

Track after implementation:

### Adoption Metrics
- [ ] % of audit commands using `--quick` mode
- [ ] % of audit commands using `--scope` filters
- [ ] % of audit commands using `--format` options

### Performance Metrics
- [ ] Average execution time with `--quick` vs. `--standard`
- [ ] Token usage with `--scope=current-pr` vs. `--scope=entire`

### User Satisfaction
- [ ] User feedback on mode flexibility
- [ ] CI/CD integration success rate

---

## Conclusion

**Decision: Implement argument mode expansion for 4 priority commands**

1. **audit-a11y**
2. **audit-perf**
3. **audit-security**
4. **quality-analyze**

**Key enhancements:**
- ✅ Depth modes (`--quick`, `--standard`, `--comprehensive`)
- ✅ Scope control (`--scope=current-pr`, `--scope=module`)
- ✅ Format options (`--format=json`, `--format=report`, `--format=summary`)
- ✅ Threshold controls (severity, complexity)

**Benefits:**
- Faster development workflow (quick modes)
- Better CI/CD integration (JSON output)
- Cost control (scope limiting)
- Flexible for different use cases

**Effort:** 8 hours total (2 hours per command)
