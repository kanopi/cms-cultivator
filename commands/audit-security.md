---
description: Comprehensive security audit with vulnerability scanning and compliance reporting
argument-hint: "[focus-area]"
allowed-tools: Bash(composer:*), Bash(ddev composer:*), Bash(ddev exec composer:*), Bash(npm:*), Bash(ddev exec npm:*), Bash(drush:*), Bash(ddev exec drush:*), Bash(wp:*), Bash(ddev exec wp:*), Bash(vendor/bin/*:*), Bash(ddev exec vendor/bin/*:*), Bash(find:*), Bash(ls:*), Bash(stat:*), Bash(chmod:*), Read, Glob, Grep, Write
---

You are helping perform comprehensive security audits for Drupal and WordPress projects. This command combines full security auditing, focused scans, and compliance reporting.

## Usage

**Full Audit:**
- `/audit-security` - Complete security audit with detailed findings

**Focused Scans:**
- `/audit-security deps` - Check dependency vulnerabilities only
- `/audit-security secrets` - Scan for exposed secrets only
- `/audit-security permissions` - Audit file/user permissions only

**Reporting:**
- `/audit-security report` - Generate stakeholder-friendly compliance report

---

## MODE 1: Full Security Audit (`/audit-security`)

### Step 1: Identify Scope

- If a file path is provided as an argument, audit that specific target
- If no argument, analyze recently changed files using `git diff`
- Look for PHP files, JavaScript files, configuration files, and dependencies

### Step 2: Run Comprehensive Security Checks

#### 1. Dependency Vulnerabilities

Check for known security vulnerabilities in dependencies:

**PHP Dependencies:**
```bash
composer audit
```

**JavaScript Dependencies:**
```bash
npm audit
yarn audit
```

**Analyze:**
- Critical/high severity vulnerabilities
- Available patches and updates
- Breaking changes in security updates
- Dependency tree conflicts

**Output Format:**
```markdown
## Dependency Vulnerabilities

### Critical Issues
| Package | Current | Fixed In | Severity | Advisory |
|---------|---------|----------|----------|----------|
| example/vulnerable-lib | 1.0.0 | 1.0.1 | Critical | CVE-2024-1234 |

**Issue**: SQL injection vulnerability in query builder
**Impact**: Allows arbitrary SQL execution
**Fix**: Update to version 1.0.1 or higher
```

#### 2. Secrets Detection

Scan for hardcoded secrets and credentials:

**Search Patterns:**
- API keys and tokens (AWS, Google, Stripe, etc.)
- Database credentials
- Private keys (RSA, SSH)
- Passwords and secrets
- OAuth tokens
- .env file contents in commits

**Files to Check:**
- Committed .env files
- Configuration files (settings.php, wp-config.php)
- Git history (for accidentally committed secrets)
- JavaScript files (exposed API keys)
- Comments and debug code
- Docker files and CI/CD configs

**Patterns to Search:**
```regex
- API[_-]?KEY|APIKEY
- SECRET[_-]?KEY|SECRETKEY
- AWS[_-]?(ACCESS|SECRET)[_-]?KEY
- GITHUB[_-]?TOKEN
- STRIPE[_-]?(SECRET|PUBLISHABLE)[_-]?KEY
- password\s*=\s*['"][^'\"]+['\"]
- BEGIN (RSA|DSA|EC|OPENSSH) PRIVATE KEY
```

**Output Format:**
```markdown
## Exposed Secrets

### Critical: API Key in JavaScript
**Location**: `themes/custom/js/api.js:12`
**Type**: API Key
**Pattern**: `const API_KEY = "pk_live_*********************"`
**Risk**: High - Publicly accessible, allows API access

**Remediation**:
1. Revoke the exposed API key immediately
2. Generate new API key
3. Move to environment variables
4. Never commit .env files

```javascript
// Bad - Never do this
const API_KEY = "pk_live_abc123def456";

// Good - Use environment variables
const API_KEY = process.env.API_KEY;
```
```

#### 3. Drupal Security Best Practices

Check Drupal-specific security:

**Core Security:**
- Drupal core version (security updates applied?)
- Contrib module security advisories
- Custom module permissions and access checks
- Database query security (parameterized queries)
- Form API and validation
- User input sanitization

**Configuration:**
- Trusted host settings (`settings.php`)
- File permissions (`sites/default/files`)
- Private file system configuration
- Error reporting (disabled in production?)
- Update module status

**Code Patterns to Check:**
```php
// SQL Injection - Check for direct queries
// Bad
db_query("SELECT * FROM users WHERE uid = " . $uid);

// Good
db_query("SELECT * FROM {users} WHERE uid = :uid", [':uid' => $uid]);

// XSS - Check for unescaped output
// Bad
print $user_input;

// Good
print Html::escape($user_input);
print Xss::filter($user_input);

// Access Control - Check for missing access checks
// Bad
function mymodule_admin_page() {
    // Missing access check
    return ['#markup' => 'Admin content'];
}

// Good
function mymodule_admin_page() {
    if (!\Drupal::currentUser()->hasPermission('administer site')) {
        throw new AccessDeniedHttpException();
    }
    return ['#markup' => 'Admin content'];
}
```

#### 4. WordPress Security Best Practices

Check WordPress-specific security:

**Core Security:**
- WordPress core version (security updates?)
- Plugin/theme security advisories
- Custom theme/plugin vulnerabilities
- Database query security (`$wpdb->prepare()`)
- Nonce verification
- User capability checks

**Configuration:**
- `wp-config.php` security keys and salts
- File permissions (`wp-content/uploads`)
- Debug mode disabled in production
- Database table prefix (not `wp_`)
- Admin username (not "admin")
- `DISALLOW_FILE_EDIT` enabled

**Code Patterns to Check:**
```php
// SQL Injection - Check for improper $wpdb usage
// Bad
$wpdb->query("SELECT * FROM {$wpdb->users} WHERE ID = " . $user_id);

// Good
$wpdb->prepare("SELECT * FROM {$wpdb->users} WHERE ID = %d", $user_id);

// XSS - Check for missing escaping
// Bad
echo $_GET['name'];

// Good
echo esc_html($_GET['name']);
echo esc_attr($attribute);
echo esc_url($url);

// CSRF - Check for missing nonce verification
// Bad
if (isset($_POST['submit'])) {
    update_option('my_option', $_POST['value']);
}

// Good
if (isset($_POST['submit']) && wp_verify_nonce($_POST['nonce'], 'my_action')) {
    update_option('my_option', sanitize_text_field($_POST['value']));
}

// Access Control - Check for missing capability checks
// Bad
function my_admin_action() {
    update_option('important_setting', $_POST['value']);
}

// Good
function my_admin_action() {
    if (!current_user_can('manage_options')) {
        wp_die('Unauthorized');
    }
    update_option('important_setting', sanitize_text_field($_POST['value']));
}
```

#### 5. OWASP Top 10 Vulnerability Patterns

Scan for common web vulnerabilities:

**A01:2021 – Broken Access Control:**
- Missing authorization checks
- Insecure direct object references
- Path traversal vulnerabilities
- CORS misconfiguration

**A02:2021 – Cryptographic Failures:**
- Sensitive data transmitted in clear text
- Weak cryptographic algorithms
- Hardcoded cryptographic keys
- Insufficient SSL/TLS configuration

**A03:2021 – Injection:**
- SQL injection
- NoSQL injection
- Command injection
- LDAP injection
- XPath injection

**A04:2021 – Insecure Design:**
- Missing security requirements
- Lack of rate limiting
- Missing security controls
- Insufficient logging

**A05:2021 – Security Misconfiguration:**
- Default credentials
- Unnecessary features enabled
- Error messages revealing sensitive info
- Missing security headers

**A06:2021 – Vulnerable and Outdated Components:**
- Using components with known vulnerabilities
- Outdated OS, web server, database
- Unnecessary dependencies

**A07:2021 – Identification and Authentication Failures:**
- Weak password requirements
- Missing multi-factor authentication
- Session fixation vulnerabilities
- Predictable session IDs

**A08:2021 – Software and Data Integrity Failures:**
- Unsigned code updates
- Untrusted deserialization
- Missing integrity checks
- Insecure CI/CD pipeline

**A09:2021 – Security Logging and Monitoring Failures:**
- Insufficient logging
- Logs not monitored
- Missing alerting
- Delayed incident response

**A10:2021 – Server-Side Request Forgery (SSRF):**
- Unvalidated user-supplied URLs
- Fetch from user-controlled hosts
- Internal network scanning

#### 6. Authentication & Authorization

Check access control implementation:

**Drupal:**
- Permission definitions in *.permissions.yml
- Access callbacks/requirements in routing
- Entity access handlers
- Route access checks
- Custom access logic in controllers

**WordPress:**
- Capability checks with `current_user_can()`
- Role definitions
- `is_user_logged_in()` checks
- Custom authorization logic
- REST API authentication

#### 7. File Upload Security

Check file upload handling:

- File type validation (whitelist, not blacklist)
- File size limits
- File name sanitization
- Storage location (outside webroot if possible)
- Virus scanning (if applicable)
- Access controls on uploaded files
- MIME type validation
- Image re-encoding to strip malicious code

#### 8. Session & Cookie Security

Check session management:

- Secure cookie flags (HttpOnly, Secure, SameSite)
- Session timeout configuration
- Session fixation prevention
- Cookie-based authentication security
- Logout functionality properly implemented

### Step 3: Generate Comprehensive Report

```markdown
# Security Audit Report

**Project**: [Project Name]
**Date**: [current date]
**Auditor**: [Name]
**Scope**: [files/components audited]

---

## Executive Summary

**Overall Security Posture**: [Critical Risk / High Risk / Medium Risk / Low Risk]

**Vulnerabilities Found**:
- Critical: [count] (Immediate action required)
- High: [count] (Address within 1 week)
- Medium: [count] (Address within 1 month)
- Low: [count] (Address as resources allow)
- Info: [count] (Informational findings)

**Risk Assessment**: [Brief summary of main security concerns]

**Immediate Actions Required**:
1. [Most critical action]
2. [Second most critical]
3. [Third most critical]

**Estimated Remediation Effort**: [X] hours

---

## Critical Vulnerabilities 🔴

### 1. [Vulnerability Title]
**Severity**: Critical
**Category**: [SQL Injection | XSS | Secrets | Auth | etc.]
**OWASP**: [A01:2021 category]
**Location**: `path/to/file.php:123`

**Description**:
[Clear explanation of the vulnerability]

**Impact**:
[What could happen if exploited]
- Confidentiality: [High/Medium/Low]
- Integrity: [High/Medium/Low]
- Availability: [High/Medium/Low]

**Proof of Concept**:
```
[Example showing how it could be exploited]
```

**Current Code**:
```php
[vulnerable code snippet]
```

**Fixed Code**:
```php
[secure code example]
```

**Remediation Steps**:
1. [Step 1]
2. [Step 2]
3. [Step 3]

**References**:
- [OWASP guideline]
- [Platform-specific documentation]
- [CVE if applicable]

**Estimated Effort**: [X] hours

---

## High Severity Issues 🟠

[Same format as critical]

---

## Medium Severity Issues 🟡

[Same format as critical]

---

## Low Severity Issues 🔵

[Same format as critical]

---

## Dependency Vulnerabilities 📦

**Total Vulnerable Dependencies**: [count]

### PHP Dependencies (Composer)
| Package | Current | Fixed In | Severity | CVE | Impact |
|---------|---------|----------|----------|-----|--------|
| vendor/package | 1.0.0 | 1.0.1 | Critical | CVE-2024-1234 | RCE |
| vendor/other | 2.0.0 | 2.1.0 | High | CVE-2024-5678 | XSS |

**Update Commands**:
```bash
composer update vendor/package --with-dependencies
composer update vendor/other --with-dependencies
composer audit
```

### JavaScript Dependencies (NPM)
| Package | Current | Fixed In | Severity | Advisory | Impact |
|---------|---------|----------|----------|----------|--------|
| package-name | 1.0.0 | 1.0.1 | High | GHSA-xxxx | Prototype Pollution |

**Update Commands**:
```bash
npm update package-name
npm audit fix
```

---

## Exposed Secrets 🔑

**Secrets Found**: [count]

| Type | Location | Risk | Status |
|------|----------|------|--------|
| API Key | config.js:45 | Critical | ❌ Needs Rotation |
| DB Password | .env (committed) | Critical | ❌ Exposed in Git |
| Private Key | deploy-key.pem | High | ⚠️ Committed |

**Remediation**:
1. Immediately rotate all exposed credentials
2. Remove secrets from git history: `git filter-branch` or BFG Repo-Cleaner
3. Move all secrets to environment variables
4. Add secrets to .gitignore
5. Implement secret scanning in CI/CD
6. Use secret management tools (Vault, AWS Secrets Manager, etc.)

---

## Security Best Practices Violations

### File Permissions
**Issues Found**: [count]

| Path | Current | Recommended | Risk |
|------|---------|-------------|------|
| sites/default/settings.php | 666 | 444 | High |
| wp-config.php | 777 | 400 | Critical |
| uploads/ | 777 | 755 | Medium |

**Fix Commands**:
```bash
chmod 444 sites/default/settings.php
chmod 400 wp-config.php
chmod 755 wp-content/uploads
find . -type f -name "*.php" -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
```

### Configuration Issues

**Drupal:**
- [ ] Trusted host settings configured
- [ ] Private file system configured
- [ ] Error logging to syslog (not display)
- [ ] Update manager configured
- [ ] Security advisories enabled

**WordPress:**
- [ ] Security keys and salts unique
- [ ] `DISALLOW_FILE_EDIT` set to true
- [ ] `WP_DEBUG` disabled in production
- [ ] Database prefix not default `wp_`
- [ ] `wp-config.php` outside webroot

---

## Platform-Specific Findings

### Drupal Security Review

**Security Review Module Results** (if available):
```bash
drush pm:enable security_review
drush security-review
```

**Findings**:
- [ ] No admin role with UID 1
- [ ] No PHP text formats
- [ ] No dangerous tags in text formats
- [ ] File permissions secure
- [ ] Private files not accessible
- [ ] Upload file extensions restricted

### WordPress Security Checks

**Recommendations**:
1. Install Wordfence or similar security plugin
2. Enable two-factor authentication
3. Disable XML-RPC if not needed
4. Implement login attempt limiting
5. Add security headers

---

## Security Headers Analysis

**Missing/Incorrect Headers**:
```
X-Frame-Options: Missing (Clickjacking risk)
X-Content-Type-Options: Missing (MIME sniffing risk)
Content-Security-Policy: Missing (XSS risk)
Strict-Transport-Security: Missing (HTTPS downgrade risk)
Referrer-Policy: Missing (Information leakage)
Permissions-Policy: Missing (Feature abuse risk)
```

**Recommended Headers**:
```apache
# Apache (.htaccess)
Header always set X-Frame-Options "SAMEORIGIN"
Header always set X-Content-Type-Options "nosniff"
Header always set Referrer-Policy "strict-origin-when-cross-origin"
Header always set Permissions-Policy "geolocation=(), microphone=(), camera=()"
Header always set Strict-Transport-Security "max-age=31536000; includeSubDomains"
Header always set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'"
```

```nginx
# Nginx
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Referrer-Policy "strict-origin-when-cross-origin" always;
add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
add_header Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'" always;
```

---

## Compliance & Standards

### OWASP Top 10 (2021) Compliance
| Category | Status | Issues Found |
|----------|--------|--------------|
| A01: Broken Access Control | ⚠️ | [count] |
| A02: Cryptographic Failures | ✅ | 0 |
| A03: Injection | ❌ | [count] |
| A04: Insecure Design | ⚠️ | [count] |
| A05: Security Misconfiguration | ❌ | [count] |
| A06: Vulnerable Components | ❌ | [count] |
| A07: Auth Failures | ✅ | 0 |
| A08: Data Integrity Failures | ⚠️ | [count] |
| A09: Logging Failures | ⚠️ | [count] |
| A10: SSRF | ✅ | 0 |

### CWE Top 25 Coverage
[List relevant CWE categories found]

---

## Remediation Roadmap

### Phase 1: Critical Issues (Week 1)
**Priority**: Immediate - Blocks or critical vulnerabilities

**Tasks**:
1. Rotate exposed secrets - [X] hours
2. Fix SQL injection in [file] - [X] hours
3. Update critical dependencies - [X] hours
4. Fix authentication bypass - [X] hours

**Total Effort**: [X] hours
**Risk Reduction**: [X]%

### Phase 2: High Priority (Weeks 2-3)
**Priority**: High - Significant security risks

**Tasks**:
1. Fix XSS vulnerabilities ([count] instances) - [X] hours
2. Implement missing access controls - [X] hours
3. Fix file permissions - [X] hours
4. Add security headers - [X] hours

**Total Effort**: [X] hours
**Risk Reduction**: [X]%

### Phase 3: Medium Priority (Month 2)
**Priority**: Medium - Should be addressed

**Tasks**:
1. Update medium-risk dependencies - [X] hours
2. Implement CSRF protection - [X] hours
3. Add rate limiting - [X] hours
4. Improve error handling - [X] hours

**Total Effort**: [X] hours
**Risk Reduction**: [X]%

### Phase 4: Low Priority (Ongoing)
**Priority**: Low - Nice to have

**Tasks**:
1. Code quality improvements
2. Additional logging and monitoring
3. Security awareness training
4. Regular security reviews

---

## Security Checklist

### Immediate Actions
- [ ] All critical vulnerabilities addressed
- [ ] Exposed secrets rotated
- [ ] Critical dependencies updated
- [ ] File permissions corrected

### Short-term (1 month)
- [ ] All high vulnerabilities addressed
- [ ] Security headers implemented
- [ ] Access controls reviewed
- [ ] Logging and monitoring improved

### Ongoing
- [ ] Regular dependency updates
- [ ] Security patches applied timely
- [ ] Regular security audits
- [ ] Security training for team
- [ ] Incident response plan documented

---

## Tools & Resources

**Automated Security Tools**:
- `composer audit` - PHP dependency scanning
- `npm audit` - JavaScript dependency scanning
- PHPStan - Static analysis with security rules
- PHPCS with Security standards
- Snyk - Comprehensive dependency scanning
- git-secrets - Prevent committing secrets
- gitleaks - Find secrets in git history

**Manual Review Tools**:
- Burp Suite - Web application security testing
- OWASP ZAP - Security scanner
- Security Review (Drupal module)
- Wordfence (WordPress plugin)

**Resources**:
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/)
- [Drupal Security Best Practices](https://www.drupal.org/security/secure-coding-practices)
- [WordPress Security Handbook](https://developer.wordpress.org/apis/security/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

---

## Next Steps

**Priority Actions**:
1. [Most critical action] - Est: [X] hours - Deadline: [date]
2. [Second priority] - Est: [X] hours - Deadline: [date]
3. [Third priority] - Est: [X] hours - Deadline: [date]

**Total Estimated Effort**: [X] hours / [Y] days
**Target Completion**: [date]

**Follow-up**:
- Schedule follow-up audit after remediation
- Implement continuous security monitoring
- Schedule regular security reviews (quarterly)
- Plan security awareness training

---

**Report Prepared By**: [Name]
**Date**: [Date]
**Version**: 1.0
```

---

## MODE 2: Focused Scans (`/audit-security [focus]`)

### Dependency Scan (`/audit-security deps`)

Check only for dependency vulnerabilities.

**What to Check:**
- Composer dependencies (composer.lock)
- NPM dependencies (package-lock.json)
- Yarn dependencies (yarn.lock)
- Known security advisories
- Outdated security-sensitive packages

**Commands to Run:**
```bash
# PHP dependencies
composer audit
composer outdated --direct

# JavaScript dependencies
npm audit
npm audit --audit-level=moderate
yarn audit
```

**Output Format:**
```markdown
## Dependency Vulnerability Scan

**Scan Date**: [date]
**Scan Tool**: composer audit, npm audit

### PHP Dependencies (Composer)
**Total Vulnerabilities**: [count]
**Critical**: [count] | **High**: [count] | **Medium**: [count] | **Low**: [count]

| Package | Current | Fixed | Severity | CVE | Description |
|---------|---------|-------|----------|-----|-------------|
| vendor/package | 1.0.0 | 1.0.1 | Critical | CVE-2024-1234 | Remote code execution |

**Remediation**:
```bash
composer update vendor/package
composer audit
```

### JavaScript Dependencies (NPM)
**Total Vulnerabilities**: [count]
**Critical**: [count] | **High**: [count] | **Moderate**: [count] | **Low**: [count]

| Package | Current | Fixed | Severity | Advisory | Path |
|---------|---------|-------|----------|----------|------|
| package | 1.0.0 | 1.0.1 | High | GHSA-xxxx | package > dep > vuln |

**Remediation**:
```bash
npm audit fix
npm audit fix --force  # May introduce breaking changes
```

### Summary
- Total vulnerabilities: [count]
- Packages requiring updates: [count]
- Estimated effort: [X] hours
- Breaking changes: [Yes/No]
```

---

### Secrets Scan (`/audit-security secrets`)

Scan only for exposed secrets and credentials.

**What to Check:**
- Committed .env files
- API keys in code
- Database credentials
- Private keys
- OAuth tokens
- Cloud credentials (AWS, Azure, GCP)
- Service account keys

**Search Patterns:**
```regex
# API Keys
API[_-]?KEY|APIKEY
SECRET[_-]?KEY|SECRETKEY
AUTH[_-]?TOKEN

# Cloud Providers
AWS[_-]?(ACCESS|SECRET)[_-]?KEY
AZURE[_-]?CLIENT[_-]?(ID|SECRET)
GOOGLE[_-]?API[_-]?KEY
GCP[_-]?SERVICE[_-]?ACCOUNT

# Payment Processors
STRIPE[_-]?(SECRET|PUBLISHABLE)[_-]?KEY
PAYPAL[_-]?(CLIENT|SECRET)

# Databases
DB[_-]?(PASSWORD|PASS|PWD)
DATABASE[_-]?URL
MYSQL[_-]?PASSWORD
POSTGRES[_-]?PASSWORD

# Generic
PASSWORD\s*=\s*['"][^'"]+['"]
password:\s*.+
token:\s*.+

# Private Keys
BEGIN (RSA|DSA|EC|OPENSSH|PGP) PRIVATE KEY
```

**Files to Scan:**
- All PHP files
- All JavaScript files
- Configuration files (.env, wp-config.php, settings.php)
- Docker files
- CI/CD configuration (.github/workflows/, .gitlab-ci.yml)
- Shell scripts
- Git history (recent commits)

**Output Format:**
```markdown
## Secrets Detection Scan

**Scan Date**: [date]
**Files Scanned**: [count]
**Secrets Found**: [count]

### Critical: Exposed Secrets

#### 1. API Key in JavaScript File
**Severity**: Critical
**Location**: `themes/custom/js/api.js:12`
**Type**: API Key
**Pattern Matched**: `API_KEY = "pk_live_***"`
**Risk**: Public exposure - allows unauthorized API access

**Context**:
```javascript
// Line 12
const API_KEY = "pk_live_abc123def456ghi789";
fetch(`https://api.example.com?key=${API_KEY}`);
```

**Remediation**:
1. Immediately revoke this API key
2. Generate new API key with appropriate restrictions
3. Move to environment variables
4. Update API provider settings to restrict by domain/IP

**Fixed Code**:
```javascript
// Use environment variable
const API_KEY = process.env.REACT_APP_API_KEY;

// Or fetch from backend
fetch('/api/proxy-endpoint');
```

#### 2. Database Credentials in Committed .env
**Severity**: Critical
**Location**: `.env` (committed in git)
**Type**: Database Password
**Risk**: Database compromise

**Remediation**:
1. Change database password immediately
2. Remove .env from git history:
```bash
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env" \
  --prune-empty --tag-name-filter cat -- --all
git push origin --force --all
```
3. Add .env to .gitignore
4. Use .env.example for documentation

### Prevention Measures

**Pre-commit Hook** (install git-secrets):
```bash
# Install git-secrets
brew install git-secrets  # macOS
apt-get install git-secrets  # Linux

# Initialize
git secrets --install
git secrets --register-aws  # Add AWS patterns

# Add custom patterns
git secrets --add 'API[_-]?KEY.*=.*['"'"'"][^'"'"'"]+['"'"'"]'
```

**CI/CD Integration**:
```yaml
# .github/workflows/security.yml
- name: Secret Scanning
  run: |
    npm install -g @secretlint/quick-start
    npx secretlint "**/*"
```

### Summary
- Total secrets found: [count]
- Critical exposures: [count]
- Files requiring remediation: [count]
- Git history cleaning required: [Yes/No]
```

---

### Permissions Audit (`/audit-security permissions`)

Audit file and user permissions.

**What to Check:**

**File Permissions:**
- Web-writable files (world-writable)
- Incorrect ownership
- Executable permissions on data files
- Configuration file permissions
- Upload directory permissions

**User Permissions (Drupal):**
- Users with Administrator role
- Custom permissions assigned
- Anonymous user permissions
- Authenticated user permissions

**User Permissions (WordPress):**
- Administrator accounts
- Editor/Author capabilities
- Custom role definitions
- Unused admin accounts

**Commands to Run:**
```bash
# Find world-writable files
find . -type f -perm -002

# Find world-writable directories
find . -type d -perm -002

# Find executable PHP files
find . -type f -name "*.php" -perm -111

# Check ownership
ls -la wp-config.php
ls -la sites/default/settings.php
```

**Output Format:**
```markdown
## File & User Permissions Audit

### File Permission Issues

**World-Writable Files**: [count]
| File | Current | Recommended | Risk | Command |
|------|---------|-------------|------|---------|
| sites/default/settings.php | 666 | 444 | Critical | `chmod 444 sites/default/settings.php` |
| wp-config.php | 644 | 400 | High | `chmod 400 wp-config.php` |
| .htaccess | 666 | 644 | Medium | `chmod 644 .htaccess` |

**World-Writable Directories**: [count]
| Directory | Current | Recommended | Risk | Command |
|-----------|---------|-------------|------|---------|
| sites/default/files | 777 | 755 | High | `chmod 755 sites/default/files` |
| wp-content/uploads | 777 | 755 | High | `chmod 755 wp-content/uploads` |

**Executable PHP Files** (should not be executable): [count]
| File | Current | Recommended | Command |
|------|---------|-------------|---------|
| includes/database.php | 755 | 644 | `chmod 644 includes/database.php` |

### Recommended File Permissions

**Drupal:**
```bash
# Files directory
chmod 755 sites/default/files
find sites/default/files -type d -exec chmod 755 {} \;
find sites/default/files -type f -exec chmod 644 {} \;

# Configuration
chmod 444 sites/default/settings.php
chmod 444 sites/default/services.yml

# Code files
find . -type f -name "*.php" -exec chmod 644 {} \;
find . -type f -name "*.module" -exec chmod 644 {} \;
find . -type f -name "*.inc" -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
```

**WordPress:**
```bash
# Files directory
chmod 755 wp-content/uploads
find wp-content/uploads -type d -exec chmod 755 {} \;
find wp-content/uploads -type f -exec chmod 644 {} \;

# Configuration
chmod 400 wp-config.php

# Code files
find . -type f -name "*.php" -exec chmod 644 {} \;
find . -type d -exec chmod 755 {} \;
chmod 644 .htaccess
```

### User Permission Issues

**Drupal Users with Administrator Role**: [count]
| Username | UID | Email | Last Login | Status |
|----------|-----|-------|------------|--------|
| admin | 1 | admin@example.com | [date] | ⚠️ Default username |
| user123 | 45 | user@example.com | [date] | ✅ OK |

**Recommendations**:
- [ ] Rename or remove default "admin" user
- [ ] Review administrator role assignments
- [ ] Implement two-factor authentication
- [ ] Regular access review (quarterly)

**WordPress Administrator Accounts**: [count]
| Username | ID | Email | Last Login | Status |
|----------|-----|-------|------------|--------|
| admin | 1 | admin@example.com | Never | ⚠️ Unused default account |
| editor1 | 5 | editor@example.com | [date] | ✅ Active |

**Recommendations**:
- [ ] Remove unused "admin" account
- [ ] Review administrator role assignments
- [ ] Enable two-factor authentication
- [ ] Limit login attempts
- [ ] Regular user access review

### Anonymous/Authenticated Permissions (Drupal)

**Risky Permissions for Anonymous**:
- [ ] "access administration pages" - ❌ Critical
- [ ] "administer nodes" - ❌ Critical
- [ ] "delete any content" - ❌ Critical
- [ ] "administer users" - ❌ Critical

**Review Required**:
- "post comments" - Consider if needed
- "access user profiles" - Consider privacy implications

### Summary
- File permission issues: [count]
- Directory permission issues: [count]
- User accounts requiring review: [count]
- Estimated remediation time: [X] hours
```

---

## MODE 3: Compliance Report (`/audit-security report`)

Generate executive-friendly security compliance report for stakeholders.

**Report Structure:**
1. Executive Summary
2. Security Posture Assessment
3. Vulnerability Summary
4. Compliance Status
5. Risk Assessment
6. Remediation Roadmap
7. Recommendations
8. Appendices

**Output Format:**
```markdown
# Security Compliance Report

**Project**: [Project Name]
**Report Date**: [Date]
**Reporting Period**: [Time Range]
**Prepared By**: [Name/Team]
**Classification**: [Confidential/Internal]

---

## Executive Summary

### Purpose
This report provides a comprehensive assessment of [Project Name]'s security posture, identified vulnerabilities, and compliance with industry security standards.

### Key Findings

**Overall Security Rating**: [Excellent / Good / Fair / Poor / Critical]

**Quick Stats**:
- Total vulnerabilities: [count]
- Critical issues: [count]
- High-priority issues: [count]
- Compliance score: [X]%
- Risk level: [Low / Medium / High / Critical]

**Top 3 Security Concerns**:
1. [Most critical finding] - Critical priority
2. [Second critical finding] - High priority
3. [Third finding] - High priority

**Business Impact**:
- Estimated financial risk: $[amount] (if exploited)
- Compliance gaps: [list standards]
- Reputation risk: [High/Medium/Low]
- Legal/regulatory risk: [High/Medium/Low]

**Immediate Actions Required**:
1. [Action 1] - By [date]
2. [Action 2] - By [date]
3. [Action 3] - By [date]

---

## Security Posture Assessment

### Current State

**Infrastructure**:
- Web Application Framework: [Drupal X.X / WordPress X.X]
- PHP Version: [X.X]
- Web Server: [Apache/Nginx]
- Database: [MySQL/PostgreSQL]
- Hosting Environment: [DDEV/Production details]

**Security Controls In Place**:
- [X] HTTPS/SSL enabled
- [X] Firewall configured
- [ ] Web Application Firewall (WAF)
- [X] Regular backups
- [ ] Intrusion Detection System (IDS)
- [ ] Security Information and Event Management (SIEM)
- [ ] Two-Factor Authentication (2FA)
- [ ] Security monitoring and alerting

**Security Practices**:
- Code reviews: [Regular/Occasional/None]
- Security testing: [Regular/Occasional/None]
- Dependency updates: [Regular/Occasional/None]
- Security training: [Regular/Occasional/None]
- Incident response plan: [Yes/No/Partial]

### Comparison to Industry Standards

| Control Category | Current State | Industry Standard | Gap |
|-----------------|---------------|-------------------|-----|
| Access Control | [X]% | 95% | [Y]% |
| Encryption | [X]% | 100% | [Y]% |
| Logging & Monitoring | [X]% | 90% | [Y]% |
| Vulnerability Management | [X]% | 95% | [Y]% |
| Security Testing | [X]% | 90% | [Y]% |

---

## Vulnerability Summary

### By Severity

**Critical** (Immediate attention required): [count]
- Exploitable remotely without authentication
- Complete system compromise possible
- Data breach potential

**High** (Address within 7 days): [count]
- Significant security impact
- Authentication may be required
- Partial system compromise possible

**Medium** (Address within 30 days): [count]
- Moderate security impact
- Requires specific conditions
- Limited system impact

**Low** (Address as resources allow): [count]
- Minor security impact
- Difficult to exploit
- Limited damage potential

**Informational**: [count]
- Security best practice recommendations
- No immediate security impact

### By Category

| Category | Critical | High | Medium | Low | Total |
|----------|----------|------|--------|-----|-------|
| Injection | [X] | [X] | [X] | [X] | [X] |
| Broken Authentication | [X] | [X] | [X] | [X] | [X] |
| Sensitive Data Exposure | [X] | [X] | [X] | [X] | [X] |
| XML External Entities (XXE) | [X] | [X] | [X] | [X] | [X] |
| Broken Access Control | [X] | [X] | [X] | [X] | [X] |
| Security Misconfiguration | [X] | [X] | [X] | [X] | [X] |
| XSS | [X] | [X] | [X] | [X] | [X] |
| Insecure Deserialization | [X] | [X] | [X] | [X] | [X] |
| Using Components with Vulnerabilities | [X] | [X] | [X] | [X] | [X] |
| Insufficient Logging | [X] | [X] | [X] | [X] | [X] |

### Trend Analysis

**Compared to Previous Audit** ([date]):
- Total vulnerabilities: [X] → [Y] ([increased/decreased] by [Z]%)
- Critical issues: [X] → [Y]
- Average time to remediation: [X] days → [Y] days
- Recurring issues: [list]

---

## Compliance Status

### OWASP Top 10 (2021)

| Risk | Compliant | Issues | Status |
|------|-----------|--------|--------|
| A01: Broken Access Control | [X]% | [count] | [✅/⚠️/❌] |
| A02: Cryptographic Failures | [X]% | [count] | [✅/⚠️/❌] |
| A03: Injection | [X]% | [count] | [✅/⚠️/❌] |
| A04: Insecure Design | [X]% | [count] | [✅/⚠️/❌] |
| A05: Security Misconfiguration | [X]% | [count] | [✅/⚠️/❌] |
| A06: Vulnerable Components | [X]% | [count] | [✅/⚠️/❌] |
| A07: Auth Failures | [X]% | [count] | [✅/⚠️/❌] |
| A08: Data Integrity Failures | [X]% | [count] | [✅/⚠️/❌] |
| A09: Logging Failures | [X]% | [count] | [✅/⚠️/❌] |
| A10: SSRF | [X]% | [count] | [✅/⚠️/❌] |

**Overall OWASP Compliance**: [X]%

### CWE Top 25

**Compliance with CWE Top 25 Most Dangerous Software Weaknesses**:
[X]/25 categories addressed ([X]%)

**Most Common Weaknesses Found**:
1. CWE-79: Cross-site Scripting - [count] instances
2. CWE-89: SQL Injection - [count] instances
3. CWE-20: Improper Input Validation - [count] instances

### Industry-Specific Compliance

**[PCI DSS / HIPAA / GDPR / SOC 2 - if applicable]**:

**PCI DSS** (if handling payment data):
- Requirement 6.5.1 (Injection flaws): [Compliant/Non-Compliant]
- Requirement 6.5.7 (XSS): [Compliant/Non-Compliant]
- Requirement 6.6 (Web app security): [Compliant/Non-Compliant]
- Overall PCI DSS compliance: [X]%

**GDPR** (if handling EU data):
- Article 32 (Security of processing): [Compliant/Partial/Non-Compliant]
- Encryption at rest: [Yes/No]
- Encryption in transit: [Yes/No]
- Data breach notification process: [Documented/Not Documented]

**HIPAA** (if handling health data):
- Technical Safeguards: [Compliant/Partial/Non-Compliant]
- Access Controls: [Compliant/Partial/Non-Compliant]
- Audit Controls: [Compliant/Partial/Non-Compliant]

---

## Risk Assessment

### Risk Matrix

| Vulnerability | Likelihood | Impact | Risk Score | Priority |
|---------------|------------|--------|------------|----------|
| SQL Injection in module X | High | Critical | 9.5/10 | P0 |
| Exposed API keys | Medium | High | 7.5/10 | P1 |
| Missing access controls | Medium | High | 7.0/10 | P1 |
| Outdated dependencies | High | Medium | 6.5/10 | P2 |

**Risk Scoring**: Likelihood × Impact (1-10 scale)

### Business Impact Analysis

**If Critical Vulnerabilities Are Exploited**:

**Confidentiality Impact**:
- User data exposure: [X] records at risk
- Sensitive business data: [list types]
- Estimated cost of breach: $[amount]

**Integrity Impact**:
- Data manipulation possible: [Yes/No]
- Content defacement risk: [High/Medium/Low]
- Financial transaction integrity: [At risk/Protected]

**Availability Impact**:
- Service disruption potential: [Hours/Days]
- Revenue loss per hour: $[amount]
- Customer impact: [count] users affected

**Reputation Impact**:
- Brand damage: [Severe/Moderate/Minimal]
- Customer trust: [At risk/Stable]
- Regulatory scrutiny: [Likely/Possible/Unlikely]

**Legal/Regulatory Impact**:
- Potential fines: $[amount]
- Legal liability: [High/Medium/Low]
- Compliance violations: [list]

### Risk Mitigation Strategy

**Short-term** (1-2 weeks):
- Address all critical vulnerabilities
- Implement immediate controls
- Rotate compromised credentials

**Medium-term** (1-3 months):
- Address high-priority vulnerabilities
- Improve security controls
- Enhance monitoring

**Long-term** (3-12 months):
- Security culture improvement
- Process optimization
- Continuous improvement program

---

## Remediation Roadmap

### Phase 1: Critical Issues (Days 1-7)
**Goal**: Eliminate critical security risks

| Issue | Description | Effort | Owner | Deadline |
|-------|-------------|--------|-------|----------|
| SQL Injection | Fix parameterization | 8h | Dev Team | Day 3 |
| Exposed Secrets | Rotate credentials | 4h | DevOps | Day 1 |
| Auth Bypass | Implement checks | 16h | Dev Team | Day 7 |

**Total Effort**: [X] hours
**Risk Reduction**: [X]% → [Y]%
**Budget**: $[amount]

### Phase 2: High Priority (Weeks 2-4)
**Goal**: Address significant security gaps

| Issue | Description | Effort | Owner | Deadline |
|-------|-------------|--------|-------|----------|
| XSS Vulnerabilities | Add escaping | 24h | Dev Team | Week 3 |
| Dependency Updates | Update packages | 8h | DevOps | Week 2 |
| Access Controls | Add checks | 16h | Dev Team | Week 4 |

**Total Effort**: [X] hours
**Risk Reduction**: [Y]% → [Z]%
**Budget**: $[amount]

### Phase 3: Medium Priority (Months 2-3)
**Goal**: Strengthen overall security posture

**Total Effort**: [X] hours
**Risk Reduction**: [Z]% → [W]%
**Budget**: $[amount]

### Total Investment

**Labor**:
- Developer hours: [X] @ $[rate] = $[amount]
- DevOps hours: [X] @ $[rate] = $[amount]
- Security specialist: [X] @ $[rate] = $[amount]

**Tools/Services**:
- Security scanning tools: $[amount]
- Code review services: $[amount]
- Training: $[amount]

**Total Budget**: $[amount]
**Expected ROI**: [X]x (cost of breach vs. remediation)

---

## Strategic Recommendations

### Immediate Actions (This Week)
1. **Establish Security Response Team**
   - Assign security champions
   - Define escalation process
   - Set up communication channels

2. **Implement Emergency Patches**
   - Critical vulnerability fixes
   - Credential rotation
   - Emergency monitoring

3. **Stakeholder Communication**
   - Brief executive team
   - Notify affected parties if needed
   - Document incident response

### Short-term Improvements (1-3 Months)
1. **Security Development Lifecycle**
   - Integrate security in SDLC
   - Security requirements in stories
   - Security acceptance criteria

2. **Automated Security Testing**
   - Dependency scanning in CI/CD
   - SAST (Static Application Security Testing)
   - DAST (Dynamic Application Security Testing)
   - Secret scanning pre-commit hooks

3. **Security Training**
   - OWASP Top 10 training for developers
   - Secure coding practices
   - Security awareness for all staff

### Long-term Strategy (3-12 Months)
1. **Security Program Development**
   - Document security policies
   - Implement security standards
   - Regular security assessments (quarterly)

2. **Advanced Security Controls**
   - Web Application Firewall (WAF)
   - Intrusion Detection/Prevention System
   - Security Information and Event Management (SIEM)
   - Runtime Application Self-Protection (RASP)

3. **Security Culture**
   - Security champions program
   - Regular security awareness
   - Bug bounty program
   - Security metrics and KPIs

---

## Monitoring & Continuous Improvement

### Key Performance Indicators (KPIs)

**Security Metrics**:
- Mean Time to Detect (MTTD): [X] days
- Mean Time to Respond (MTTR): [X] days
- Vulnerability density: [X] per 1000 LOC
- Security patch cycle time: [X] days

**Target Metrics** (6 months):
- MTTD: < [X] days
- MTTR: < [X] days
- Critical vulnerabilities: 0
- High vulnerabilities: < [X]

### Regular Security Activities

**Weekly**:
- [ ] Dependency vulnerability scans
- [ ] Security log review
- [ ] Incident response check

**Monthly**:
- [ ] Security patch updates
- [ ] Access control review
- [ ] Security metrics review
- [ ] Team security sync

**Quarterly**:
- [ ] Comprehensive security audit
- [ ] Penetration testing
- [ ] Security training refresh
- [ ] Policy and procedure review

**Annually**:
- [ ] External security assessment
- [ ] Compliance audit
- [ ] Disaster recovery test
- [ ] Security program review

---

## Conclusion

### Summary
[Project Name] has [number] security vulnerabilities requiring remediation, with [number] classified as critical or high priority. The estimated effort to address all identified issues is [X] hours over [Y] weeks.

### Risk Statement
**Current Risk Level**: [Critical/High/Medium/Low]
**Target Risk Level**: Low (post-remediation)
**Residual Risk**: [description of acceptable remaining risk]

### Success Criteria
- [ ] All critical vulnerabilities remediated
- [ ] All high-priority vulnerabilities remediated
- [ ] Security controls implemented and tested
- [ ] Team trained on secure coding practices
- [ ] Continuous monitoring established
- [ ] Compliance requirements met

### Next Steps
1. **Immediate** (This week): Address critical vulnerabilities
2. **Short-term** (This month): Implement high-priority fixes
3. **Ongoing**: Establish security program and continuous monitoring

---

## Appendices

### Appendix A: Detailed Vulnerability List
[Complete technical details of all vulnerabilities]

### Appendix B: Methodology
**Tools Used**:
- Composer audit for PHP dependencies
- NPM audit for JavaScript dependencies
- PHPStan for static analysis
- Manual code review
- Configuration review

**Standards Referenced**:
- OWASP Top 10 2021
- CWE Top 25
- Drupal/WordPress Security Best Practices
- NIST Cybersecurity Framework

### Appendix C: References
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [CWE Top 25](https://cwe.mitre.org/top25/)
- [Drupal Security](https://www.drupal.org/security)
- [WordPress Security](https://wordpress.org/support/article/hardening-wordpress/)

### Appendix D: Glossary
**CVE**: Common Vulnerabilities and Exposures
**CVSS**: Common Vulnerability Scoring System
**OWASP**: Open Web Application Security Project
**XSS**: Cross-Site Scripting
**CSRF**: Cross-Site Request Forgery
**SQLi**: SQL Injection

---

**Report Classification**: [Confidential/Internal/Public]
**Distribution**: [Limited to security team and management]
**Revision History**:
- v1.0 - [Date] - Initial report

**Contact Information**:
**Security Team**: [email]
**Report Author**: [name, title]
**Questions**: [contact method]
```

---

## Quick Start (Kanopi Projects)

### Pre-Audit Security Checks

Run Kanopi's security tools before detailed audit:

**Drupal:**
```bash
# Comprehensive code check (includes security patterns)
ddev composer code-check

# Individual security checks
ddev composer phpstan        # Static analysis with security rules
ddev composer audit          # PHP dependency vulnerabilities
ddev exec npm audit          # JavaScript vulnerabilities
```

**WordPress:**
```bash
# Individual security checks
ddev composer phpstan        # Static analysis with security rules
ddev composer audit          # PHP dependency vulnerabilities
ddev exec npm audit          # JavaScript vulnerabilities
```

### PHPStan Security Analysis

Kanopi projects use PHPStan which includes security-focused rules:

```bash
# Run PHPStan (includes security checks)
ddev composer phpstan

# What it checks for:
# - SQL injection vulnerabilities
# - XSS vulnerabilities (unescaped output)
# - Type safety issues that could lead to security bugs
# - Deprecated functions with security implications
# - Incorrect API usage
```

---

## Analysis Guidelines

- **Focus on exploitable vulnerabilities** - Prioritize issues that can actually be exploited
- **Provide proof of concept** - Show how vulnerabilities could be exploited
- **Include remediation code** - Give exact code fixes, not just descriptions
- **Prioritize by risk** - Consider likelihood × impact
- **Validate findings** - Avoid false positives
- **Be specific** - Include file paths, line numbers, and code snippets
- **Consider context** - Some patterns may be safe in specific contexts
- **Document exceptions** - If a pattern is intentionally insecure for a reason

---

## Security Tools Reference

**Automated Scanning**:
- `composer audit` - PHP dependency scanning
- `npm audit` / `yarn audit` - JavaScript dependency scanning
- PHPStan - Static analysis with security rules
- PHPCS with Security standards - Code quality + security
- Snyk - Comprehensive dependency and code scanning
- Trivy - Container and filesystem scanning

**Secret Detection**:
- git-secrets - Prevent committing secrets
- gitleaks - Find secrets in git history
- truffleHog - Find secrets in git history and files
- detect-secrets - Pre-commit secret detection

**Manual Testing**:
- Burp Suite - Web application security testing
- OWASP ZAP - Free security scanner
- Postman - API security testing
- Browser DevTools - Client-side security review

**Platform-Specific**:
- Security Review (Drupal module)
- Wordfence (WordPress plugin)
- Sucuri (WordPress plugin)
- iThemes Security (WordPress plugin)

**Remember**: Security is not a one-time audit but a continuous process. Regular scans, monitoring, and updates are essential to maintain a secure application.
