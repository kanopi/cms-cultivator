---
name: security-audit
description: Comprehensive OWASP Top 10 security vulnerability scanning and compliance reporting for Drupal and WordPress. Spawns security-specialist for full analysis. Invoke when user runs /audit-security, requests a full security audit, needs OWASP compliance review, or asks for comprehensive vulnerability scanning. Supports --quick, --standard, --comprehensive depth modes and scope/format/severity flags.
disable-model-invocation: true
---

# Security Audit

Comprehensive OWASP Top 10 security vulnerability scanning using the security-specialist agent.

## Usage

- `/audit-security` — Full OWASP Top 10 audit (standard depth)
- `/audit-security --quick --scope=current-pr` — Pre-commit security check
- `/audit-security --comprehensive --format=summary` — Pre-release deep audit with executive summary
- `/audit-security --standard --format=sarif` — Security tools integration
- `/audit-security xss` — Legacy focus area (still supported)

## Arguments

### Depth Modes
- `--quick` — OWASP Top 3 only (~5 min): SQL injection, XSS, auth issues
- `--standard` — OWASP Top 10 (default, ~15 min)
- `--comprehensive` — OWASP Top 10 + CVE scanning + config review (~30 min)

### Scope Control
- `--scope=current-pr` — Only files changed in current PR
- `--scope=user-input` — Forms, queries, file uploads, API endpoints
- `--scope=auth` — Authentication/authorization logic
- `--scope=api` — API endpoints and integrations
- `--scope=module=<name>` — Specific module/directory
- `--scope=file=<path>` — Single file
- `--scope=entire` — Full codebase (default)

### Output Formats
- `--format=report` — Detailed security report with remediation steps (default)
- `--format=json` — Structured JSON for CI/CD
- `--format=summary` — Executive summary with risk assessment
- `--format=sarif` — SARIF format for security tools integration

### Severity Thresholds
- `--min-severity=high` — Only high and critical issues
- `--min-severity=medium` — Medium, high, and critical (default)
- `--min-severity=low` — All findings including informational

### Legacy Focus Areas (Still Supported)
`injection`, `xss`, `csrf`, `auth`, `encryption`, `dependencies`

## Environment Detection

### Tier 1 — Portable (Claude Desktop, Codex, any environment)

When Task() or bash tools are unavailable, perform security analysis directly:

1. **Parse arguments** — Determine depth, scope, format, and minimum severity
2. **Identify files to analyze** — Use Glob and Grep to find PHP, JS, and template files
3. **Analyze security directly**:
   - Use Read and Grep to scan for SQL injection patterns (raw queries, string concatenation)
   - Check for XSS vulnerabilities (unescaped output, innerHTML, echo without sanitization)
   - Review CSRF protection (nonce verification, token validation)
   - Check authentication patterns and authorization logic
   - Identify hardcoded credentials or secrets in code
   - Review CMS-specific patterns (Drupal db_query without placeholders, WordPress $wpdb without prepare())
4. **Generate report** — Format findings per requested output format, prioritized Critical → High → Medium → Low
5. **Save report** — Write to `audit-security-YYYY-MM-DD-HHMM.md` and present path to user

**Supported checks in Tier 1**: code pattern analysis for OWASP Top 10, CMS-specific vulnerability patterns.

### Tier 2 — Claude Code Enhanced

When running in Claude Code with Task() available:

1. **Parse arguments** — Determine depth, scope, format, and minimum severity
2. **Determine files** — For `--scope=current-pr`:
   ```bash
   git diff --name-only origin/main...HEAD | grep -E '\.(php|tsx?|jsx?|sql)$'
   ```
   For `--scope=user-input`: find `*Form*.php`, `*Controller*.php`, `*API*.php`
   For `--scope=auth`: find `*Auth*.php`, `*Login*.php`, `*Permission*.php`
3. **Spawn security-specialist**:
   ```
   Task(cms-cultivator:security-specialist:security-specialist,
        prompt="Perform comprehensive OWASP security audit with:
          - Depth mode: {depth}
          - Scope: {scope}
          - Format: {format}
          - Minimum severity: {min_severity}
          - Focus area: {focus or 'complete audit'}
          - Files to analyze: {file_list}
        Scan for OWASP Top 10 vulnerabilities, check input validation and output encoding, analyze authentication/authorization, review CMS-specific security for Drupal and WordPress, and check dependencies for CVEs. Save report to audit-security-YYYY-MM-DD-HHMM.md and present the file path.")
   ```
4. **Present results** to user with file path

## OWASP Top 10 Coverage

1. **A01 Broken Access Control** — Permission checks, access control bypass
2. **A02 Cryptographic Failures** — Encryption, sensitive data exposure
3. **A03 Injection** — SQL, command, LDAP injection
4. **A04 Insecure Design** — Architecture-level security issues
5. **A05 Security Misconfiguration** — Default configs, unnecessary features
6. **A06 Vulnerable Components** — Outdated dependencies with CVEs
7. **A07 Auth Failures** — Authentication/session management
8. **A08 Integrity Failures** — CI/CD pipeline security
9. **A09 Logging Failures** — Insufficient security logging
10. **A10 SSRF** — Server-side request forgery

## CMS-Specific Checks

**Drupal**: Form API CSRF tokens, db_query() with placeholders, render API XSS prevention, node access system, permissions.yml review

**WordPress**: $wpdb->prepare(), nonce verification, capability checks, sanitize_*/esc_* usage, wp_verify_nonce(), update_option() security

## Related Skills

- **security-scanner** — Quick code-level security checks (auto-activates on "is this secure?")
- **audit-export** — Export findings to CSV for project management tools
- **audit-report** — Generate client-facing executive summary from audit file
