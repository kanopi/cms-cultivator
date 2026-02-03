---
description: Comprehensive security vulnerability scanning and compliance reporting using security specialist
argument-hint: "[options]"
allowed-tools: Task, Bash(git:*)
---

Spawn the **security-specialist** agent using:

```
Task(cms-cultivator:security-specialist:security-specialist,
     prompt="Perform comprehensive security auditing and vulnerability scanning with the following parameters:
       - Depth mode: [quick/standard/comprehensive - parsed from arguments, default: standard]
       - Scope: [current-pr/module/file/user-input/auth/api/entire - parsed from arguments, default: entire]
       - Format: [report/json/summary/sarif - parsed from arguments, default: report]
       - Minimum severity: [high/medium/low - parsed from arguments, default: medium]
       - Focus area: [use legacy focus argument if provided, otherwise 'complete audit']
       - Files to analyze: [file list based on scope]
     Scan for OWASP Top 10 vulnerabilities, check input validation and output encoding, analyze authentication/authorization, review CMS-specific security patterns for Drupal and WordPress, and check dependencies for CVEs. Save the comprehensive audit report to a file (audit-security-YYYY-MM-DD-HHMM.md) and present the file path to the user.")
```

## Arguments

This command supports flexible argument modes for different use cases:

### Depth Modes
- `--quick` - OWASP Top 3 only (~5 min) - SQL injection, XSS, auth issues
- `--standard` - OWASP Top 10 (default, ~15 min) - Comprehensive vulnerability scan
- `--comprehensive` - OWASP Top 10 + CVE scanning + config review (~30 min) - Deep security analysis

### Scope Control
- `--scope=current-pr` - Only files changed in current PR (uses git diff)
- `--scope=user-input` - Focus on forms, queries, file uploads, API endpoints
- `--scope=auth` - Focus on authentication/authorization logic
- `--scope=api` - Focus on API endpoints and integrations
- `--scope=module=<name>` - Specific module/directory (e.g., `--scope=module=src/api`)
- `--scope=file=<path>` - Single file (e.g., `--scope=file=src/UserController.php`)
- `--scope=entire` - Full codebase (default)

### Output Formats
- `--format=report` - Detailed security report with remediation steps (default)
- `--format=json` - Structured JSON for CI/CD integration
- `--format=summary` - Executive summary with risk assessment
- `--format=sarif` - SARIF format for security tools integration

### Severity Thresholds
- `--min-severity=high` - Only report high and critical issues (reduce noise)
- `--min-severity=medium` - Report medium, high, and critical issues (default)
- `--min-severity=low` - Report all findings including informational

### Legacy Focus Areas (Still Supported)
For backward compatibility, single-word focus areas without `--` prefix are treated as legacy focus filters:
- `injection` - Focus on SQL injection and command injection
- `xss` - Focus on Cross-Site Scripting vulnerabilities
- `csrf` - Focus on Cross-Site Request Forgery protection
- `auth` - Focus on authentication/authorization issues
- `encryption` - Focus on crypto and data protection
- `dependencies` - Focus on dependency CVE scanning

## Usage Examples

### Quick Checks
```bash
# Quick security check on your changes
/audit-security --quick --scope=current-pr

# Quick check on user input handling
/audit-security --quick --scope=user-input

# Quick check with high-severity issues only
/audit-security --quick --min-severity=high
```

### Standard Audits
```bash
# Standard audit (same as legacy `/audit-security`)
/audit-security

# Standard audit on PR changes
/audit-security --scope=current-pr

# Standard audit with JSON for CI/CD
/audit-security --standard --format=json

# Focus on authentication
/audit-security --standard --scope=auth
```

### Comprehensive Audits
```bash
# Comprehensive pre-release audit
/audit-security --comprehensive

# Comprehensive audit with executive summary
/audit-security --comprehensive --format=summary

# Comprehensive audit with SARIF output for security tools
/audit-security --comprehensive --format=sarif
```

### Legacy Syntax (Still Works)
```bash
# Focus on specific area (legacy)
/audit-security injection
/audit-security xss
/audit-security auth

# Combine legacy focus with new modes
/audit-security injection --quick
/audit-security xss --scope=current-pr --min-severity=high
```

## How It Works

This command spawns the **security-specialist** agent, which uses the **security-scanner** skill and performs comprehensive OWASP Top 10 security audits.

### 1. Parse Arguments

The command first parses the arguments to determine the audit parameters:

**Depth mode:**
- Check for `--quick`, `--standard`, or `--comprehensive` flags
- Default: `--standard` (if not specified)

**Scope:**
- Check for `--scope=<value>` flag
- If `--scope=current-pr`: Get changed files using `git diff --name-only origin/main...HEAD`
- If `--scope=user-input`: Target forms, API endpoints, file uploads, query builders
- If `--scope=auth`: Target authentication controllers, middleware, permissions
- If `--scope=api`: Target API routes, controllers, integrations
- If `--scope=module=<name>`: Target specific directory
- If `--scope=file=<path>`: Target single file
- Default: `--scope=entire` (analyze entire codebase)

**Format:**
- Check for `--format=<value>` flag
- Options: `report` (default), `json`, `summary`, `sarif`
- Default: `--format=report`

**Minimum severity:**
- Check for `--min-severity=<value>` flag
- Options: `low`, `medium` (default), `high`
- Filters results to only show issues at or above the threshold

**Legacy focus area:**
- If argument doesn't start with `--`, treat as legacy focus area
- Examples: `injection`, `xss`, `csrf`, `auth`, `encryption`
- Can be combined with new flags: `/audit-security injection --quick`

### 2. Determine Files to Analyze

Based on the scope parameter:

**For `current-pr`:**
```bash
git diff --name-only origin/main...HEAD | grep -E '\.(php|tsx?|jsx?|sql)$'
```

**For `user-input`:**
```bash
# Find files likely to handle user input
find . -type f \( -name "*Form*.php" -o -name "*Controller*.php" -o -name "*API*.php" -o -name "*Query*.php" \)
```

**For `auth`:**
```bash
# Find authentication-related files
find . -type f \( -name "*Auth*.php" -o -name "*Login*.php" -o -name "*Permission*.php" -o -name "*Middleware*.php" \)
```

**For `api`:**
```bash
# Find API-related files
find . -type f \( -path "*/api/*" -o -name "*API*.php" -o -name "*Controller*.php" \)
```

**For `module=<name>` or `file=<path>`:**
Analyze the specified directory or single file.

**For `entire`:**
Analyze all relevant files in the codebase.

### 3. Spawn Security Specialist

Pass all parsed parameters to the agent:
```
Task(cms-cultivator:security-specialist:security-specialist,
     prompt="Run OWASP security audit with:
       - Depth mode: {depth}
       - Scope: {scope}
       - Format: {format}
       - Minimum severity: {min_severity}
       - Focus area: {focus or 'complete audit'}
       - Files to analyze: {file_list}")
```

### The Security Specialist Will

1. **Scan for OWASP Top 10 vulnerabilities** - SQL injection, XSS, CSRF, authentication issues
2. **Check input validation and output encoding** - Sanitization and escaping patterns
3. **Analyze authentication/authorization** - Access control and permissions
4. **Review CMS-specific security** - Drupal Form API, WordPress nonces/capabilities
5. **Check dependencies for CVEs** - `composer audit`, `npm audit`
6. **Generate prioritized findings** - Critical → High → Medium → Low with remediation steps

**Quick Code Checks:**
For quick security checks on specific functions, the **security-scanner** Agent Skill auto-activates when you ask "is this secure?" See: [`skills/security-scanner/SKILL.md`](../skills/security-scanner/SKILL.md)

---

## Tool Usage

**Allowed operations:**
- ✅ Spawn security-specialist agent
- ✅ Scan dependencies for known CVEs (composer audit, npm audit)
- ✅ Review code for OWASP Top 10 vulnerabilities
- ✅ Check input validation and output encoding
- ✅ Analyze authentication and authorization logic
- ✅ Generate security audit reports with remediation steps

**Not allowed:**
- ❌ Do not modify code directly (provide fixes in report)
- ❌ Do not run penetration tests or exploit vulnerabilities
- ❌ Do not install security scanning tools (suggest installation if needed)

The security-specialist agent performs all audit operations.

---

## Agent Used

**security-specialist** - OWASP Top 10 specialist with CMS-specific security knowledge for Drupal and WordPress.

---

## Exporting to Project Management Tools

After audit completes, export findings as CSV:

```bash
/export-audit-csv [report-filename]
```

Generates Teamwork-compatible CSV for importing tasks into project management tools (also works with Jira, Monday, Linear).
