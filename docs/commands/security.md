# Security Commands

Scan for vulnerabilities, exposed secrets, and security misconfigurations with a single comprehensive command.

## Command

`/audit-security [focus]` - Comprehensive security audit with vulnerability scanning and compliance reporting

## Usage Modes

- `/audit-security` - Complete security audit with detailed findings
- `/audit-security [focus]` - Focused scans (deps, secrets, permissions)
- `/audit-security report` - Generate stakeholder-friendly compliance report

## Focus Options

- `deps` - Check dependency vulnerabilities only (composer audit, npm audit)
- `secrets` - Scan for exposed secrets only (API keys, passwords, credentials)
- `permissions` - Audit file/user permissions only

## What It Checks

**Comprehensive Audit:**
- Dependency vulnerabilities (PHP and JavaScript)
- Exposed secrets and credentials
- Drupal/WordPress security best practices
- OWASP Top 10 vulnerabilities
- File and user permissions
- Authentication and authorization issues
- Security configuration

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
