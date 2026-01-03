---
description: Comprehensive security vulnerability scanning and compliance reporting using security specialist
argument-hint: "[focus-area]"
allowed-tools: Task
---

Spawn the **security-specialist** agent using:

```
Task(cms-cultivator:security-specialist:security-specialist,
     prompt="Perform comprehensive security auditing and vulnerability scanning. Focus area: [use argument if provided, otherwise 'complete audit']. Scan for OWASP Top 10 vulnerabilities, check input validation and output encoding, analyze authentication/authorization, review CMS-specific security patterns for Drupal and WordPress, and check dependencies for CVEs.")
```

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
