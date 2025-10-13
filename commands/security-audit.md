---
description: Comprehensive security audit for Drupal/WordPress projects
allowed-tools: Bash(composer:*), Bash(ddev composer:*), Bash(ddev exec composer:*), Bash(npm:*), Bash(ddev exec npm:*), Bash(drush:*), Bash(ddev exec drush:*), Bash(wp:*), Bash(ddev exec wp:*), Bash(vendor/bin/*:*), Bash(ddev exec vendor/bin/*:*), Read, Glob, Grep
---

# Security Audit

Perform a comprehensive security audit of the codebase, checking for vulnerabilities, exposed secrets, and security best practices.

## Audit Scope

Run all security checks:
1. Dependency vulnerabilities (composer.lock, package.json)
2. Hardcoded secrets and credentials
3. Drupal/WordPress security best practices
4. Common vulnerability patterns (SQL injection, XSS, CSRF)
5. File permissions and access controls
6. Authentication and authorization issues

## Analysis Steps

## Quick Start (Kanopi Projects)

### Run Automated Security Checks

**Drupal - All-in-One:**
```bash
# Run comprehensive quality check (includes security patterns)
ddev composer code-check

# Individual checks
ddev composer phpstan        # Static analysis with security rules
ddev composer audit          # Dependency vulnerabilities
ddev exec npm audit          # JavaScript dependencies
```

**WordPress:**
```bash
# Individual checks
ddev composer phpstan        # Static analysis with security rules
ddev composer audit          # Dependency vulnerabilities
ddev exec npm audit          # JavaScript dependencies
```

### PHPStan for Security Analysis

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

**Example PHPStan Security Finding:**
```
------ ---------------------------------------------------------------
Line   Error
------ ---------------------------------------------------------------
45     Potential SQL injection: variable $uid used in query without
       proper sanitization. Use parameterized queries instead.

78     Unescaped output: $user_input passed to print without
       Html::escape(). This could lead to XSS vulnerabilities.

123    Missing capability check: current_user_can() not called before
       sensitive operation. Add authorization check.
------ ---------------------------------------------------------------
```

### Dependency Vulnerability Scanning

```bash
# Check PHP dependencies
ddev composer audit

# Check JavaScript dependencies
ddev exec npm audit

# Check for high/critical only
ddev exec npm audit --audit-level=high
```

---

### 1. Dependency Vulnerabilities

Check for known security vulnerabilities in dependencies:

```bash
# PHP dependencies
composer audit

# JavaScript dependencies
npm audit
yarn audit
```

Analyze:
- Critical/high severity vulnerabilities
- Available patches and updates
- Breaking changes in security updates
- Dependency tree conflicts

### 2. Secrets Detection

Scan for hardcoded secrets and credentials:

**Search patterns:**
- API keys and tokens
- Database credentials
- AWS/cloud credentials
- Private keys
- Passwords and secrets
- .env file contents in commits

**Files to check:**
- Committed .env files
- Configuration files
- Git history (for accidentally committed secrets)
- JavaScript files (exposed API keys)
- Comments and debug code

### 3. Drupal Security Best Practices

Check Drupal-specific security:

**Core Security:**
- Drupal core version (security updates applied?)
- Contrib module security advisories
- Custom module permissions and access checks
- Database query security (parameterized queries)
- Form API and validation
- User input sanitization

**Configuration:**
- Trusted host settings
- File permissions (sites/default/files)
- Private file system configuration
- Error reporting (disabled in production?)
- Update module status

**Code Patterns:**
- Direct database queries (use Database API)
- Unescaped output (use render API)
- Missing access checks
- Improper use of user input
- Cache poisoning vectors

### 4. WordPress Security Best Practices

Check WordPress-specific security:

**Core Security:**
- WordPress core version (security updates?)
- Plugin/theme security advisories
- Custom theme/plugin vulnerabilities
- Database query security ($wpdb->prepare())
- Nonce verification
- User capability checks

**Configuration:**
- wp-config.php security keys
- File permissions (wp-content/uploads)
- Debug mode disabled in production
- Database table prefix
- Admin username (not "admin")

**Code Patterns:**
- Direct SQL queries (use $wpdb properly)
- Missing sanitization/escaping
- Missing nonce checks
- Missing capability checks
- Unvalidated redirects
- File upload vulnerabilities

### 5. Common Vulnerability Patterns

Scan for OWASP Top 10 vulnerabilities:

**SQL Injection:**
```php
// Bad
db_query("SELECT * FROM users WHERE uid = " . $uid);
$wpdb->query("SELECT * FROM {$wpdb->users} WHERE ID = " . $user_id);

// Good
db_query("SELECT * FROM {users} WHERE uid = :uid", [':uid' => $uid]);
$wpdb->prepare("SELECT * FROM {$wpdb->users} WHERE ID = %d", $user_id);
```

**XSS (Cross-Site Scripting):**
```php
// Bad - Drupal
print $user_input;

// Good - Drupal
print Xss::filter($user_input);
print Html::escape($user_input);

// Bad - WordPress
echo $_GET['name'];

// Good - WordPress
echo esc_html($_GET['name']);
echo esc_attr($attribute);
echo esc_url($url);
```

**CSRF (Cross-Site Request Forgery):**
```php
// Drupal - Form API automatically includes tokens
// Check for custom AJAX/REST endpoints

// WordPress - Check nonce usage
if (!wp_verify_nonce($_POST['nonce'], 'action_name')) {
    die('Security check failed');
}
```

**Insecure Direct Object References:**
```php
// Check all entity/post access
// Drupal
$entity->access('view', $account);

// WordPress
current_user_can('edit_post', $post_id);
```

### 6. Authentication & Authorization

Check access control implementation:

**Drupal:**
- Permission definitions
- Access callbacks/requirements
- Entity access handlers
- Route access checks
- Custom access logic

**WordPress:**
- Capability checks
- Role definitions
- current_user_can() usage
- is_user_logged_in() checks
- Custom authorization logic

### 7. File Upload Security

Check file upload handling:

- File type validation (whitelist, not blacklist)
- File size limits
- File name sanitization
- Storage location (outside webroot if possible)
- Virus scanning (if applicable)
- Access controls on uploaded files

### 8. Session & Cookie Security

Check session management:

- Secure cookie flags (HttpOnly, Secure)
- Session timeout configuration
- Session fixation prevention
- Cookie-based authentication security

## Security Report Format

Generate a comprehensive security report with:

### Executive Summary
- Overall security posture (Critical/High/Medium/Low risk)
- Number of issues by severity
- Immediate actions required
- Estimated remediation effort

### Vulnerability Details

For each issue found:

**Issue Title**: [Brief description]

**Severity**: Critical | High | Medium | Low | Info

**Category**: [SQL Injection | XSS | Secrets | Dependencies | etc.]

**Location**: `file/path/file.php:123`

**Description**: Detailed explanation of the vulnerability

**Impact**: What could happen if exploited

**Proof of Concept**: Example of how it could be exploited

**Remediation**: Step-by-step fix instructions with code examples

**References**:
- OWASP guidelines
- Drupal/WordPress security docs
- CVE numbers (if applicable)

### Dependency Vulnerabilities

List all vulnerable dependencies:

| Package | Current | Fixed In | Severity | Advisory |
|---------|---------|----------|----------|----------|
| example/package | 1.0.0 | 1.0.1 | High | CVE-2024-1234 |

### Secrets Found

List any exposed secrets (mask actual values):

| Type | Location | Risk |
|------|----------|------|
| API Key | config.js:45 | High |
| Database Password | .env (committed) | Critical |

### Security Checklist

- [ ] All critical vulnerabilities addressed
- [ ] All high vulnerabilities addressed
- [ ] Dependencies updated
- [ ] Secrets removed/rotated
- [ ] Security headers configured
- [ ] HTTPS enforced
- [ ] File permissions correct
- [ ] Error reporting disabled in production
- [ ] Security monitoring enabled

## Platform-Specific Checks

### Drupal-Specific

**Security Review Module**: Run if available
```bash
drush pm:enable security_review
drush security-review
```

**Check for:**
- Untrusted PHP code execution
- Private files accessible
- Dangerous tags allowed in text formats
- Admin permissions
- File permissions
- SQL injection in custom modules
- XSS in custom modules

### WordPress-Specific

**Security Plugins**: Recommend installation
- Wordfence Security
- Sucuri Security
- iThemes Security

**Check for:**
- File editing disabled (DISALLOW_FILE_EDIT)
- XML-RPC disabled if not needed
- REST API authentication
- User enumeration prevention
- Login attempt limiting
- Two-factor authentication

## Tools & Resources

**Automated Scanning Tools:**
- `composer audit` - PHP dependency scanning
- `npm audit` - JavaScript dependency scanning
- PHPCS with security standards
- SonarQube security rules
- Snyk for dependency scanning
- git-secrets for secret detection

**Manual Review Tools:**
- PHPStan with security rules
- Psalm with taint analysis
- ESLint security plugins

**Resources:**
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Drupal Security Best Practices](https://www.drupal.org/security/secure-coding-practices)
- [WordPress Security Handbook](https://developer.wordpress.org/apis/security/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)

## Deliverables

1. **Security Audit Report** (Markdown format)
2. **Issue Tracker Items** (for each vulnerability)
3. **Remediation Roadmap** (prioritized action plan)
4. **Security Checklist** (for ongoing monitoring)

## Notes

- Focus on actual vulnerabilities, not just style issues
- Prioritize by risk: exploitability × impact
- Provide actionable remediation steps
- Include code examples for fixes
- Consider false positives (validate findings)
- Document any security exceptions/waivers
