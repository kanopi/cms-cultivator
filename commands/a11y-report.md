---
description: Generate comprehensive accessibility compliance report
allowed-tools: Read, Glob, Grep, Write
---

Create a detailed accessibility report for stakeholders.

## Instructions

1. **Run comprehensive audit** using `/a11y-audit`
2. **Compile findings** into stakeholder-friendly report
3. **Include**:
   - Executive summary
   - Conformance level
   - Issues by severity
   - Remediation timeline
   - Testing methodology

## Output Format

```markdown
# Accessibility Compliance Report

**Project**: [Project Name]
**Date**: [Date]
**Auditor**: [Name]
**WCAG Version**: 2.1
**Target Level**: AA

## Executive Summary

This report summarizes the accessibility audit of [Project Name] conducted on [Date]. The site was evaluated against WCAG 2.1 Level AA success criteria.

**Overall Status**: [Partial Conformance / Non-Conformance]

**Key Findings**:
- [X] issues identified
- [Y] critical issues blocking access
- [Z] moderate issues causing inconvenience
- Estimated remediation effort: [hours/weeks]

## Conformance Summary

| WCAG Principle | Level A | Level AA | Status |
|----------------|---------|----------|--------|
| Perceivable    | 15/15   | 8/9      | ⚠️ Partial |
| Operable       | 12/12   | 5/7      | ⚠️ Partial |
| Understandable | 10/10   | 5/5      | ✅ Full |
| Robust         | 3/3     | 2/2      | ✅ Full |

## Critical Issues (Priority 1)

### 1. Missing Form Labels
**WCAG**: 1.3.1, 4.1.2
**Impact**: Screen reader users cannot identify form fields
**Affected**: Contact form, signup form
**Users Impacted**: Blind users, screen reader users

**Recommendation**: Add proper label elements to all form inputs
**Effort**: 2 hours
**Priority**: Critical

### 2. Insufficient Color Contrast
**WCAG**: 1.4.3
**Impact**: Low vision users cannot read content
**Affected**: Body text, button text, links
**Users Impacted**: Low vision, color blind users

**Recommendation**: Adjust colors to meet 4.5:1 ratio
**Effort**: 3 hours
**Priority**: Critical

## Serious Issues (Priority 2)

[Continue with serious issues...]

## Moderate Issues (Priority 3)

[Continue with moderate issues...]

## Testing Methodology

**Automated Testing**:
- axe DevTools
- Lighthouse
- WAVE

**Manual Testing**:
- Keyboard navigation
- Screen reader (NVDA 2024, JAWS 2024, VoiceOver)
- 200% zoom
- Color contrast analyzer

**Browsers Tested**:
- Chrome 120
- Firefox 121
- Safari 17
- Edge 120

## Remediation Roadmap

**Phase 1** (Week 1-2): Critical Issues
- Fix form labels
- Correct color contrast
- Add skip links
**Effort**: 15 hours

**Phase 2** (Week 3-4): Serious Issues
- Improve heading structure
- Fix ARIA usage
- Add image alt text
**Effort**: 20 hours

**Phase 3** (Week 5-6): Moderate Issues
- Enhance keyboard navigation
- Improve focus indicators
- Add additional landmarks
**Effort**: 10 hours

**Total Estimated Effort**: 45 hours

## Recommendations

1. Implement critical fixes immediately
2. Establish accessibility review process
3. Train development team on WCAG
4. Integrate automated testing in CI/CD
5. Conduct regular audits

## Legal & Compliance

**ADA Compliance**: Current issues may expose organization to ADA complaints
**Section 508**: Several Section 508 requirements not met
**Risk Level**: Medium-High

## Appendix A: Detailed Findings

[Detailed technical findings from audit...]

## Appendix B: Resources

- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
- [WebAIM Resources](https://webaim.org/)
- [Deque University](https://dequeuniversity.com/)

---

**Report Prepared By**: [Name]
**Contact**: [Email]
**Date**: [Date]
```
