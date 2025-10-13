---
description: Scan for vulnerabilities, secrets, and permission issues
argument-hint: [focus]
allowed-tools: Bash(composer:*), Bash(ddev exec composer:*), Bash(npm:*), Bash(ddev exec npm:*), Bash(find:*), Bash(ls:*), Bash(stat:*), Bash(chmod:*), Read, Glob, Grep
---

# Security Scan

Scan codebase for dependency vulnerabilities, exposed secrets, and file/user permission issues.

## Usage

- `/security-scan` - Run all security scans (dependencies, secrets, permissions)
- `/security-scan deps` - Check dependency vulnerabilities only
- `/security-scan secrets` - Scan for exposed secrets only
- `/security-scan permissions` - Audit permissions only

## Scan Types

### 1. Dependency Vulnerabilities (`deps`)

Scan for known CVEs in PHP and JavaScript dependencies.

**What it checks:**
- Composer dependencies (composer.lock)
- NPM dependencies (package-lock.json)
- Yarn dependencies (yarn.lock)
- Known security advisories
- Outdated security-sensitive packages

**Commands run:**
```bash
composer audit
npm audit
```

**Output:**
- List of vulnerable packages
- CVE numbers and severity
- Fixed versions available
- Update recommendations

See `/security-deps` command documentation for full details.

---

### 2. Exposed Secrets (`secrets`)

Scan for accidentally committed secrets, API keys, and credentials.

**What it checks:**
- API keys and tokens (AWS, Stripe, GitHub, etc.)
- Database credentials
- Private keys (SSH, SSL, PGP)
- Passwords in code
- OAuth tokens
- Git history for removed secrets

**Search patterns:**
- AWS keys: `AKIA[0-9A-Z]{16}`
- API keys: `api_key.*['"][0-9a-zA-Z]{32,}`
- Private keys: `-----BEGIN.*PRIVATE KEY-----`
- Database credentials: `mysql://.*:.*@`

**Tools:**
- Pattern matching (grep/ripgrep)
- TruffleHog (git history)
- Gitleaks
- git-secrets

**Output:**
- Location of exposed secrets
- Type of secret (API key, password, etc.)
- Risk level (Critical/High/Medium)
- Remediation steps

See `/security-secrets` command documentation for full details.

---

### 3. Permission Issues (`permissions`)

Audit file system and user role permissions.

**File Permissions Check:**
- World-writable files (security risk)
- Incorrect file ownership
- Overly permissive directories (777)
- Config files that should be read-only
- Web-accessible .git directory

**User Permissions Check (Drupal):**
- Anonymous/Authenticated user permissions
- Admin permission assignments
- Dangerous permissions on non-admin roles
- Permission escalation risks

**User Permissions Check (WordPress):**
- User role capabilities
- Editor/Contributor elevated permissions
- File editing enabled in production
- Custom roles with admin capabilities

**Output:**
- Files with incorrect permissions
- Recommended permission fixes
- User roles with security issues
- Commands to fix permissions

See `/security-permissions` command documentation for full details.

---

## Running All Scans

When run without arguments, executes all three scans:

```bash
/security-scan
```

**Output Format:**

```markdown
# Security Scan Report

**Date**: 2024-01-15
**Scans**: Dependencies, Secrets, Permissions

## Summary

| Scan Type | Critical | High | Medium | Low | Status |
|-----------|----------|------|--------|-----|--------|
| Dependencies | 2 | 3 | 5 | 2 | 🔴 Action Required |
| Secrets | 1 | 0 | 0 | 0 | 🔴 URGENT |
| Permissions | 0 | 4 | 8 | 3 | 🟠 Needs Work |

---

## 🔴 CRITICAL: Exposed Database Password

**Type**: Secret Exposure
**Location**: `.env` (committed in git history)
**Risk**: Critical

**Finding**: Production database password found in git commit abc123 (3 months ago)

**Remediation**:
1. Immediately rotate database password
2. Clean git history: `git filter-repo --path .env --invert-paths`
3. Review database logs for unauthorized access
4. Add .env to .gitignore

---

## 🔴 CRITICAL: Vulnerable Payment Processing Library

**Type**: Dependency Vulnerability
**Package**: stripe/stripe-php
**Current**: 7.50.0
**Fixed In**: 7.128.0
**CVE**: CVE-2024-12345
**CVSS**: 9.1 (Critical)

**Impact**: Remote code execution via malformed payment webhook

**Remediation**:
```bash
composer require stripe/stripe-php:^7.128.0
```

---

## 🟠 HIGH: World-Writable Settings File

**Type**: Permission Issue
**Location**: `web/sites/default/settings.php`
**Current**: 666 (rw-rw-rw-)
**Expected**: 444 (r--r--r--)

**Risk**: File can be modified by web server, allowing code injection

**Remediation**:
```bash
chmod 444 web/sites/default/settings.php
```

---

[Continue with all findings...]

## Recommendations

### Immediate (Today)
1. ✅ Rotate database password (Critical)
2. ✅ Update stripe/stripe-php (Critical)
3. ✅ Fix settings.php permissions (High)

### This Week
1. Update 3 high-severity dependencies
2. Fix 4 high-priority permission issues
3. Remove/rotate exposed API keys

### This Month
1. Implement pre-commit hooks for secret detection
2. Set up automated dependency scanning in CI
3. Review and document permission requirements
```

## Quick Scan (Summary Only)

For a quick overview without detailed findings:

```bash
/security-scan --summary
```

Returns just the summary table and critical items count.

## Integration with Other Commands

**Full Security Workflow:**

1. **`/security-scan`** - Identify all security issues
2. **`/security-audit`** - Deep dive into code vulnerabilities (OWASP Top 10)
3. **`/security-report`** - Generate stakeholder report

**Typical Usage:**
```bash
# Before deployment
/security-scan                    # Quick scan for known issues
/security-audit                   # Deep code analysis
/security-report                  # Generate report for approval
```

## Best Practices

1. **Regular Scans** - Run `/security-scan` weekly
2. **Pre-Deployment** - Always scan before production deploy
3. **CI Integration** - Add to CI/CD pipeline
4. **Rotate Secrets** - If secrets found, rotate immediately
5. **Fix Critical First** - Prioritize by severity
6. **Track Progress** - Monitor improvement over time

## CI/CD Integration

**GitHub Actions:**
```yaml
- name: Security Scan
  run: |
    composer audit
    npm audit --audit-level=high
    find . -name ".env" ! -name ".env.example"

- name: Check for secrets
  uses: trufflesecurity/trufflehog@main
  with:
    path: ./
```

**GitLab CI:**
```yaml
security-scan:
  script:
    - composer audit
    - npm audit
  only:
    - merge_requests
```

## Resources

- [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/)
- [TruffleHog](https://github.com/trufflesecurity/trufflehog)
- [Gitleaks](https://github.com/gitleaks/gitleaks)
- [Drupal Security](https://www.drupal.org/security)
- [WordPress Security](https://developer.wordpress.org/apis/security/)
