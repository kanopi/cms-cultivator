---
description: Generate comprehensive security compliance report for stakeholders
allowed-tools: Bash(composer:*), Bash(ddev exec composer:*), Bash(npm:*), Bash(ddev exec npm:*), Bash(drush:*), Bash(ddev exec drush:*), Bash(wp:*), Bash(ddev exec wp:*), Bash(find:*), Read, Glob, Grep, Write
---

# Security Compliance Report

Generate a comprehensive, executive-friendly security report suitable for stakeholders, compliance audits, and management review.

## Report Structure

The report should provide both technical details and business context, suitable for different audiences:

1. **Executive Summary** - High-level overview for non-technical stakeholders
2. **Security Posture** - Current state assessment
3. **Vulnerability Summary** - Issues found by severity
4. **Compliance Status** - Standards and regulations
5. **Risk Assessment** - Business impact analysis
6. **Remediation Plan** - Action items with timeline
7. **Recommendations** - Strategic improvements
8. **Appendices** - Technical details

## Report Generation Process

### 1. Gather Security Data

Run comprehensive security analysis:

```bash
# Dependency vulnerabilities
composer audit > reports/composer-audit.txt
npm audit --json > reports/npm-audit.json

# Code security scanning
phpcs --standard=Security web/modules/custom/ > reports/phpcs-security.txt

# Secret scanning
gitleaks detect --report-format json --report-path reports/secrets.json

# File permissions
find web/ -type f -perm -002 > reports/writable-files.txt

# User permissions (Drupal)
drush security:review --format=json > reports/drupal-security.json

# User permissions (WordPress)
wp user list --role=administrator --format=json > reports/wp-admins.json
```

### 2. Analyze Security Findings

Categorize and prioritize all findings:

**By Severity:**
- Critical: Immediate action required (RCE, SQLi, exposed credentials)
- High: Action required within 1 week (XSS, CSRF, privilege escalation)
- Medium: Action required within 1 month (information disclosure, misconfigurations)
- Low: Address when convenient (hardening opportunities)

**By Category:**
- Dependencies (vulnerable packages)
- Code vulnerabilities (SQL injection, XSS, etc.)
- Configuration issues (permissions, settings)
- Access control (user roles, file permissions)
- Secrets management (exposed credentials)
- Infrastructure (server configuration)

### 3. Assess Business Impact

For each finding, evaluate:

**Likelihood:**
- High: Easily exploitable, publicly known
- Medium: Requires some skill/knowledge
- Low: Difficult to exploit, requires insider access

**Impact:**
- Critical: Data breach, complete system compromise
- High: Significant data loss, service disruption
- Medium: Limited data exposure, partial service impact
- Low: Minimal impact, mostly theoretical

**Risk Score** = Likelihood × Impact

## Executive Summary Template

```markdown
# Security Compliance Report
**Project**: [Project Name]
**Date**: [Report Date]
**Prepared by**: Kanopi Studios Security Team
**Report Period**: [Date Range]

## Executive Summary

### Overall Security Posture: [EXCELLENT | GOOD | FAIR | POOR | CRITICAL]

This report presents the findings from a comprehensive security audit of [Project Name] conducted on [Date]. The audit covered application security, dependency vulnerabilities, access controls, and compliance with industry standards.

### Key Findings

✅ **Strengths:**
- All dependencies are up to date with no critical vulnerabilities
- Strong password policies and authentication controls
- Regular security updates applied
- Proper separation of development and production environments

⚠️ **Areas of Concern:**
- 2 Critical vulnerabilities requiring immediate attention
- 5 High-priority security issues identified
- File permissions need adjustment in production environment
- Security monitoring and logging could be enhanced

### Risk Summary

| Severity | Count | Status |
|----------|-------|--------|
| Critical | 2 | 🔴 Immediate Action Required |
| High | 5 | 🟠 Action Required This Week |
| Medium | 12 | 🟡 Action Required This Month |
| Low | 8 | 🟢 Monitored |

### Business Impact

**Potential Financial Impact**: $[X] - $[Y] in potential losses if vulnerabilities exploited
**Data at Risk**: [Number] customer records, [sensitive data types]
**Compliance Risk**: [GDPR, HIPAA, PCI-DSS, etc.] violations possible
**Reputation Risk**: Medium - data breach could impact customer trust

### Immediate Actions Required

1. **[Critical Issue #1]** - Deploy patch by [Date]
2. **[Critical Issue #2]** - Rotate credentials by [Date]
3. **Review and approve remediation plan** - By [Date]
4. **Allocate resources for security improvements** - [Hours/Budget]

### Recommendations

**Short-term (0-30 days):**
- Address all critical and high-severity vulnerabilities
- Implement automated security scanning in CI/CD
- Enhance access controls and audit logging

**Long-term (30-90 days):**
- Establish security training program
- Implement Web Application Firewall (WAF)
- Conduct penetration testing
- Establish bug bounty program

### Cost Estimate

**Remediation Effort**: [X] development hours, $[Y] budget
**ROI**: Prevents potential breach costing $[Z], compliance fines of $[W]

---

## Detailed Findings

### 1. Critical Vulnerabilities (2)

#### 1.1 SQL Injection in Custom Module

**Severity**: Critical (CVSS 9.8)
**Category**: Code Vulnerability
**Location**: `web/modules/custom/mymodule/src/Controller/MyController.php:45`
**Status**: 🔴 Open

**Description**:
User input is directly interpolated into SQL query without sanitization, allowing attackers to execute arbitrary SQL commands.

**Technical Details**:
```php
// Vulnerable code
$uid = \Drupal::request()->query->get('uid');
$query = \Drupal::database()->query("SELECT * FROM users WHERE uid = " . $uid);
```

**Exploitation Scenario**:
An attacker could craft a URL like:
```
/mymodule/users?uid=1 OR 1=1
```
This would return all users, potentially exposing sensitive data.

**Business Impact**:
- **Likelihood**: High (easily exploitable, no authentication required)
- **Impact**: Critical (complete database compromise, data breach)
- **Risk Score**: 9.8/10
- **Potential Loss**: $50,000 - $500,000 (breach response, fines, reputation)
- **GDPR Violation**: Yes (Article 32 - Security of Processing)

**Remediation**:
```php
// Fixed code
$uid = \Drupal::request()->query->get('uid');
$query = \Drupal::database()->query(
  "SELECT * FROM {users} WHERE uid = :uid",
  [':uid' => $uid]
);
```

**Timeline**:
- **Discovery**: [Date]
- **Fix Required By**: [Date] (48 hours)
- **Estimated Effort**: 2 hours
- **Testing Required**: 4 hours
- **Deployment**: [Date]

**Verification**:
- [ ] Code fix implemented
- [ ] Security test passed
- [ ] Code review completed
- [ ] Deployed to production
- [ ] Logs reviewed for exploitation attempts

---

#### 1.2 Production Database Credentials Exposed in Git History

**Severity**: Critical
**Category**: Secrets Management
**Location**: `.env` file (removed but in git history)
**Status**: 🔴 Open

**Description**:
Production database credentials were committed to git repository 3 months ago. While the file has been removed, credentials remain in git history and may have been exposed.

**Technical Details**:
```bash
# Example of exposed credentials found in commit abc123 (3 months ago)
DB_HOST=production.rds.amazonaws.com
DB_USER=prod_user
DB_PASSWORD=SuperSecretProd123_example
```

**Exploitation Scenario**:
Anyone with repository access (past or present) could extract credentials from git history and gain unauthorized database access.

**Business Impact**:
- **Likelihood**: High (credentials still valid, history accessible)
- **Impact**: Critical (full database access, data breach)
- **Risk Score**: 9.5/10
- **Potential Loss**: $100,000 - $1,000,000 (GDPR fines, breach costs)
- **GDPR Violation**: Yes (Article 32 - Security of Processing)
- **Compliance**: PCI-DSS violation if storing payment data

**Remediation**:
1. Immediately rotate database credentials
2. Update all production systems with new credentials
3. Clean git history (coordinate with team):
   ```bash
   git filter-repo --path .env --invert-paths
   git push --force --all
   ```
4. Review database logs for unauthorized access (past 3 months)
5. Implement pre-commit hooks to prevent future commits
6. Move to secrets management system (AWS Secrets Manager, Vault)

**Timeline**:
- **Discovery**: [Date]
- **Password Rotation**: [Date] (immediate - within 4 hours)
- **Git History Cleanup**: [Date] (within 24 hours)
- **Log Analysis**: [Date] (within 48 hours)
- **Secrets Manager**: [Date] (within 2 weeks)

**Cost**:
- **Immediate**: 8 hours ($800)
- **Secrets Manager Setup**: 16 hours ($1,600)
- **Total**: $2,400

---

### 2. High Severity Vulnerabilities (5)

[Similar detailed format for each vulnerability...]

---

### 3. Medium Severity Issues (12)

[Summarized table format with key details...]

---

### 4. Low Severity Issues (8)

[Brief list with recommendations...]

---

## Compliance Status

### GDPR Compliance (EU General Data Protection Regulation)

**Overall Status**: ⚠️ Partially Compliant

| Requirement | Status | Notes |
|------------|--------|-------|
| Article 32 - Security of Processing | 🔴 Non-Compliant | Critical vulnerabilities present |
| Article 33 - Breach Notification | 🟢 Compliant | Incident response plan in place |
| Article 25 - Data Protection by Design | 🟡 Partially Compliant | Some security best practices missing |

**Required Actions**:
- Address critical vulnerabilities (Article 32)
- Implement data encryption at rest (Article 32)
- Document security measures (Article 30)

### WCAG 2.1 AA (Accessibility)

**Overall Status**: 🟢 Compliant

*(See separate accessibility report for details)*

### PCI-DSS (Payment Card Industry Data Security Standard)

**Applicable**: [Yes/No]

If applicable:
**Overall Status**: [Status]

| Requirement | Status | Notes |
|------------|--------|-------|
| Build and Maintain Secure Network | [Status] | [Notes] |
| Protect Cardholder Data | [Status] | [Notes] |
| Vulnerability Management Program | [Status] | [Notes] |

---

## Risk Assessment

### Top 5 Risks by Business Impact

#### 1. SQL Injection → Data Breach
- **Risk Score**: 9.8/10
- **Financial Impact**: $100K - $1M
- **Probability**: High (80%)
- **Mitigation**: Code fix (2 hours)

#### 2. Exposed Database Credentials
- **Risk Score**: 9.5/10
- **Financial Impact**: $100K - $1M
- **Probability**: High (70%)
- **Mitigation**: Rotate credentials, clean history (8 hours)

[Continue for top 5...]

### Risk Matrix

```
         │ CATASTROPHIC │ MAJOR │ MODERATE │ MINOR │
─────────┼──────────────┼───────┼──────────┼───────┤
HIGH     │ ██ ██        │ ██    │          │       │
         │ #1  #2       │ #3    │          │       │
─────────┼──────────────┼───────┼──────────┼───────┤
MEDIUM   │ ██           │ ██    │ ██       │       │
         │ #4           │ #5    │          │       │
─────────┼──────────────┼───────┼──────────┼───────┤
LOW      │              │       │ ██       │ ██    │
         │              │       │          │       │
─────────┴──────────────┴───────┴──────────┴───────┘
```

---

## Remediation Plan

### Phase 1: Critical (0-7 days)

| # | Issue | Effort | Owner | Due Date | Status |
|---|-------|--------|-------|----------|--------|
| 1 | SQL Injection fix | 2h | Dev Team | [Date] | 🔴 Open |
| 2 | Rotate DB credentials | 8h | DevOps | [Date] | 🔴 Open |

**Total Effort**: 10 hours
**Budget**: $1,000

### Phase 2: High Priority (7-30 days)

| # | Issue | Effort | Owner | Due Date | Status |
|---|-------|--------|-------|----------|--------|
| 3 | Fix XSS vulnerabilities | 8h | Dev Team | [Date] | 🟠 Planned |
| 4 | Update dependencies | 4h | Dev Team | [Date] | 🟠 Planned |

**Total Effort**: 12 hours
**Budget**: $1,200

### Phase 3: Medium Priority (30-90 days)

[Similar table...]

**Total Effort**: 24 hours
**Budget**: $2,400

### Phase 4: Security Hardening (90+ days)

- Implement WAF
- Security training program
- Penetration testing
- Bug bounty program

**Total Effort**: 80 hours
**Budget**: $8,000

---

## Recommendations

### Immediate Improvements

1. **Automated Security Scanning**
   - Integrate security tools into CI/CD pipeline
   - Prevent vulnerable code from being deployed
   - Cost: $500/month (tools) + 16 hours setup

2. **Secrets Management**
   - Implement AWS Secrets Manager or HashiCorp Vault
   - Rotate secrets automatically
   - Cost: $100/month + 16 hours setup

3. **Security Monitoring**
   - Implement SIEM (Security Information and Event Management)
   - Real-time alerting for security events
   - Cost: $200/month + 24 hours setup

### Long-term Strategy

1. **Security Training** - Quarterly training for development team
2. **Penetration Testing** - Annual third-party security audit
3. **Bug Bounty Program** - Incentivize external security research
4. **Security Champions** - Dedicated security role/team

---

## Metrics & Monitoring

### Current Security Metrics

- **Mean Time to Detect (MTTD)**: [X] days
- **Mean Time to Respond (MTTR)**: [Y] days
- **Vulnerability Density**: [Z] per 1000 lines of code
- **Security Debt**: [W] hours of remediation work

### Target Metrics (6 months)

- **MTTD**: < 1 day (automated scanning)
- **MTTR**: < 7 days (for high-severity)
- **Vulnerability Density**: < 1 per 1000 LOC
- **Zero Critical Vulnerabilities**: Maintained continuously

---

## Appendices

### Appendix A: Vulnerability Details
[Full technical details of all findings]

### Appendix B: Compliance Checklist
[Complete compliance requirement checklist]

### Appendix C: Tool Output
[Raw output from security scanning tools]

### Appendix D: References
- OWASP Top 10: https://owasp.org/Top10/
- NIST Cybersecurity Framework: https://www.nist.gov/cyberframework
- CWE Top 25: https://cwe.mitre.org/top25/
- Drupal Security Best Practices: https://www.drupal.org/security
- WordPress Security Handbook: https://developer.wordpress.org/apis/security/

---

**Report Prepared By**: Kanopi Studios Security Team
**Review Date**: [Date]
**Next Review**: [Date + 90 days]
```

## Report Customization

### For Different Audiences

**Executive Leadership:**
- Focus on business impact and financial risk
- High-level summaries and visuals
- Clear action items and timelines
- ROI calculations

**Technical Teams:**
- Detailed vulnerability descriptions
- Code examples and remediation steps
- Tool output and scan results
- Technical references

**Compliance/Legal:**
- Regulatory requirements status
- Compliance gaps and remediation
- Documentation of controls
- Audit trail

**Clients/Stakeholders:**
- Balanced technical and business context
- Transparent about issues and solutions
- Timeline and cost estimates
- Progress tracking

## Report Formats

Generate reports in multiple formats:

- **PDF** - Executive summary for management
- **Markdown** - Detailed technical report
- **HTML** - Interactive dashboard
- **JSON** - Machine-readable for tracking tools
- **CSV** - Vulnerability tracking spreadsheet

## Best Practices

1. **Honest Assessment** - Don't downplay issues
2. **Context Matters** - Explain business impact
3. **Actionable** - Provide clear next steps
4. **Track Progress** - Update report regularly
5. **Validate Findings** - Confirm before reporting
6. **Prioritize** - Focus on what matters most
7. **Document Everything** - Maintain audit trail

## Deliverables

1. Executive summary presentation (PDF)
2. Full technical report (Markdown)
3. Vulnerability tracking spreadsheet (CSV)
4. Remediation plan with timeline (Project plan)
5. Compliance checklist (Checkbox format)
6. Monthly progress reports
