# Agent Integration

How audit agents pass data to the exporter for task creation.

## Security Specialist → Exporter

**Trigger:** Security audit completes

**Data passed:**
- Vulnerability findings
- Severity levels
- CWE/OWASP classifications
- Affected files and lines
- Remediation suggestions

**Action:** Create bug report tasks for each vulnerability

## Performance Specialist → Exporter

**Trigger:** Performance audit completes

**Data passed:**
- Core Web Vitals metrics
- Lighthouse scores
- Performance bottlenecks
- Optimization opportunities

**Action:** Create little tasks for each optimization

## Accessibility Specialist → Exporter

**Trigger:** Accessibility audit completes

**Data passed:**
- WCAG violations
- Severity levels
- Affected elements
- Remediation steps

**Action:** Create bug reports for violations, little tasks for improvements

## Code Quality Specialist → Exporter

**Trigger:** Quality audit completes

**Data passed:**
- Complexity metrics
- Standards violations
- Code smells
- Refactoring suggestions

**Action:** Create little tasks for simple fixes, epics for major refactors
