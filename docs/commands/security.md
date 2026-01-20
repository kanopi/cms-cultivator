# Security Commands

Scan for OWASP Top 10 vulnerabilities, CVEs, and security misconfigurations with flexible argument modes.

## Command

`/audit-security [options]` - Comprehensive security audit with vulnerability scanning and compliance reporting

## Flexible Argument Modes

CMS Cultivator now supports multiple operation modes for security audits:

### Quick Checks During Development
```bash
/audit-security --quick --scope=current-pr
/audit-security --quick --scope=user-input
/audit-security --quick --min-severity=high
```
- ⚡ Fast execution (~5 min)
- 🎯 OWASP Top 3 only (SQL injection, XSS, auth)
- 💰 Lower token costs
- ✅ Perfect for pre-commit checks

### Standard Audits (Default)
```bash
/audit-security
/audit-security --scope=current-pr
/audit-security --standard --scope=auth
```
- 🔍 Comprehensive analysis (~15 min)
- ✅ Full OWASP Top 10 + dependency CVEs
- 📊 Detailed remediation steps

### Comprehensive Audits (Pre-Release)
```bash
/audit-security --comprehensive
/audit-security --comprehensive --format=summary
/audit-security --comprehensive --format=sarif
```
- 🔬 Deep analysis (~30 min)
- 💎 OWASP Top 10 + CVE scanning + config review
- 📋 Stakeholder and security tool integration

## Argument Options

### Depth Modes
- `--quick` - OWASP Top 3 only (~5 min)
- `--standard` - OWASP Top 10 (default, ~15 min)
- `--comprehensive` - Full security analysis + CVE + config (~30 min)

### Scope Control
- `--scope=current-pr` - Only files changed in current PR
- `--scope=user-input` - Forms, queries, file uploads, API endpoints
- `--scope=auth` - Authentication/authorization logic only
- `--scope=api` - API endpoints and integrations only
- `--scope=module=<name>` - Specific module/directory
- `--scope=file=<path>` - Single file
- `--scope=entire` - Full codebase (default)

### Output Formats
- `--format=report` - Detailed security report (default)
- `--format=json` - JSON for CI/CD integration
- `--format=summary` - Executive summary with risk assessment
- `--format=sarif` - SARIF format for security tools (GitHub Security, Azure DevOps)

### Severity Thresholds
- `--min-severity=high` - Only report high and critical issues
- `--min-severity=medium` - Report medium+ issues (default)
- `--min-severity=low` - Report all findings including informational

## Legacy Focus Options (Still Supported)

For backward compatibility, focus areas without `--` prefix still work:
- `injection` - SQL injection and command injection
- `xss` - Cross-Site Scripting vulnerabilities
- `csrf` - Cross-Site Request Forgery protection
- `auth` - Authentication/authorization issues
- `encryption` - Cryptography and data protection
- `dependencies` - Dependency CVE scanning

## CI/CD Integration

Export results as SARIF or JSON for security tools:

```yaml
# GitHub Actions example with SARIF
- name: Run security audit
  run: /audit-security --standard --format=sarif > results.sarif

- name: Upload to GitHub Security
  uses: github/codeql-action/upload-sarif@v2
  with:
    sarif_file: results.sarif

# Or use JSON for custom checks
- name: Run security audit
  run: /audit-security --standard --format=json > security.json

- name: Check for critical issues
  run: |
    CRITICAL=$(jq '.summary.by_severity.critical' security.json)
    if [ "$CRITICAL" -gt 0 ]; then
      echo "Critical security issues found"
      exit 1
    fi
```

## Common Workflows

**Pre-Commit:**
```bash
/audit-security --quick --scope=current-pr --min-severity=high
```

**PR Review:**
```bash
/audit-security --standard --scope=current-pr
```

**Pre-Release:**
```bash
/audit-security --comprehensive --format=summary
```

**Focus on User Input:**
```bash
/audit-security --standard --scope=user-input
```

**Focus on Authentication:**
```bash
/audit-security --standard --scope=auth
```

## What It Checks

**OWASP Top 10 Coverage:**
- A01: Broken Access Control
- A02: Cryptographic Failures
- A03: Injection (SQL, XSS, Command)
- A04: Insecure Design
- A05: Security Misconfiguration
- A06: Vulnerable Components
- A07: Authentication Failures
- A08: Software/Data Integrity Failures
- A09: Logging/Monitoring Failures
- A10: Server-Side Request Forgery

**Focused Scans:**
- Target specific security areas
- Faster execution
- Detailed analysis of chosen focus

**Compliance Reporting:**
- Executive-friendly format
- Business impact analysis
- Remediation roadmap
- Compliance status (OWASP, CWE)

See [Commands Overview](overview.md) for detailed usage.
