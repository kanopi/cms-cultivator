---
description: Generate comprehensive QA test plan based on code changes
allowed-tools: Bash(git:*), Read, Glob, Grep, Write
---

# QA Test Plan Generator

Generate comprehensive manual and automated test plans based on code changes, feature requirements, and risk analysis.

## Test Plan Structure

### 1. Test Scope
### 2. Test Scenarios
### 3. Test Cases
### 4. Acceptance Criteria
### 5. Test Environment
### 6. Test Data Requirements

## Sample Test Plan

```markdown
# QA Test Plan - User Authentication Feature

## Overview

**Feature**: Two-Factor Authentication
**Sprint**: 2024-Q1-S3
**QA Lead**: QA Team
**Developers**: Dev Team

## Test Scope

### In Scope
- ✅ 2FA setup flow
- ✅ 2FA login flow
- ✅ Backup codes generation
- ✅ Recovery process
- ✅ Mobile app integration

### Out of Scope
- ❌ SMS 2FA (future sprint)
- ❌ Biometric authentication

## Test Scenarios

### 1. 2FA Setup

| Scenario | Steps | Expected Result | Priority |
|----------|-------|-----------------|----------|
| Enable 2FA | 1. Login<br>2. Go to Security<br>3. Enable 2FA<br>4. Scan QR code | 2FA enabled, backup codes shown | High |
| Invalid code | Enter wrong code | Error message, 2FA not enabled | High |
| Cancel setup | Start setup, click cancel | 2FA remains disabled | Medium |

### 2. Login with 2FA

| Scenario | Steps | Expected Result | Priority |
|----------|-------|-----------------|----------|
| Successful login | Enter password + valid 2FA code | Logged in | Critical |
| Invalid 2FA code | Enter valid password + invalid code | Login rejected, remain on 2FA page | Critical |
| Use backup code | Enter backup code | Logged in, backup code marked as used | High |

## Browser/Device Matrix

| Browser | Desktop | Mobile | Status |
|---------|---------|--------|--------|
| Chrome | ✅ | ✅ | To Test |
| Firefox | ✅ | ✅ | To Test |
| Safari | ✅ | ✅ | To Test |
| Edge | ✅ | ❌ | To Test |

## Test Environment

- **URL**: https://staging.example.com
- **Database**: Staging DB (refreshed 2024-01-10)
- **Test Accounts**: See test-accounts.md
- **2FA App**: Google Authenticator / Authy

## Test Data

### Test Accounts
- user1@test.com / password123 (2FA enabled)
- user2@test.com / password123 (2FA disabled)
- admin@test.com / password123 (admin with 2FA)

### Test Scenarios Data
- Valid 2FA codes (time-based)
- Backup codes (see fixtures)
- Invalid codes for negative testing

## Pass/Fail Criteria

**Pass**: All critical and high priority scenarios pass
**Fail**: Any critical scenario fails

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Users locked out | High | Test recovery flow thoroughly |
| Backup codes lost | Medium | Provide recovery via email |
| Time sync issues | Medium | Test with various time zones |

## Test Results

| Date | Tester | Pass | Fail | Blocked | Notes |
|------|--------|------|------|---------|-------|
| 2024-01-15 | QA1 | 12 | 2 | 1 | Issue #123 logged |

## Issues Found

| ID | Severity | Description | Status |
|----|----------|-------------|--------|
| #123 | High | Backup codes not displayed | Open |
| #124 | Low | Text alignment issue | Fixed |

## Sign-off

- [ ] QA Lead Review
- [ ] Product Owner Approval
- [ ] Ready for Production
```

## Best Practices

1. **Risk-Based** - Focus on high-risk areas
2. **Traceability** - Link to requirements
3. **Clear Steps** - Anyone can execute
4. **Data Included** - Specify test data
5. **Environment** - Document setup
6. **Results** - Track pass/fail
7. **Sign-off** - Get approval

## Resources

- [IEEE 829 Test Plan](https://en.wikipedia.org/wiki/IEEE_829)
- [Test Case Management](https://www.guru99.com/test-case-management.html)
