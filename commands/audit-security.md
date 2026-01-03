---
description: Comprehensive security vulnerability scanning and compliance reporting using security specialist
argument-hint: "[focus-area]"
allowed-tools: Task
---

I'll use the **security specialist** agent to perform comprehensive security auditing and vulnerability scanning.

The security specialist will:
1. **Scan for OWASP Top 10 vulnerabilities** - SQL injection, XSS, CSRF, authentication issues
2. **Check input validation and output encoding** - Sanitization and escaping patterns
3. **Analyze authentication/authorization** - Access control and permissions
4. **Review CMS-specific security** - Drupal Form API, WordPress nonces/capabilities
5. **Check dependencies for CVEs** - `composer audit`, `npm audit`
6. **Generate prioritized findings** - Critical → High → Medium → Low with remediation steps

**Quick Code Checks:**
For quick security checks on specific functions, the **security-scanner** Agent Skill auto-activates when you ask "is this secure?" See: [`skills/security-scanner/SKILL.md`](../skills/security-scanner/SKILL.md)

## Agent Used

**security-specialist** - OWASP Top 10 specialist with CMS-specific security knowledge for Drupal and WordPress.
