# Test 01: Leaf Specialist Agents

**Category:** Agent Spawn & Skills Access
**Agents Tested:** 5 leaf specialists
**Expected Behavior:** Agents spawn, access skills, produce output, do NOT delegate

---

## Test 1.1: Accessibility Specialist

### Setup
- Project with HTML/PHP files
- At least one accessibility issue (missing alt text, contrast issue, etc.)

### Test Procedure
```
User: Run /audit-a11y on the homepage template
```

### Expected Behavior
1. ✅ Command spawns `accessibility-specialist` agent
2. ✅ Agent accesses `accessibility-checker` skill
3. ✅ Agent does NOT spawn other agents (no Task tool usage)
4. ✅ Agent produces WCAG 2.1 AA report

### Verification Checklist
- [ ] Agent spawned successfully
- [ ] Skill loaded: accessibility-checker
- [ ] No delegation occurred
- [ ] Output includes:
  - [ ] WCAG success criteria references (e.g., "1.1.1")
  - [ ] File paths and line numbers
  - [ ] Priority levels (Critical, High, Medium, Low)
  - [ ] Specific fix recommendations

### Output Format Validation
```markdown
## Accessibility Findings

**Status:** ✅ Pass | ⚠️ Issues Found | ❌ Critical Issues

**Issues:**
1. [CRITICAL] Missing alt text on 3 images (WCAG 1.1.1)
   - File: path/to/file.php line 42
   - Fix: Add meaningful alt text
```

---

## Test 1.2: Performance Specialist

### Setup
- Project with performance issues (large images, N+1 queries, etc.)

### Test Procedure
```
User: Run /audit-perf and analyze database query performance
```

### Expected Behavior
1. ✅ Command spawns `performance-specialist` agent
2. ✅ Agent accesses `performance-analyzer` skill
3. ✅ Agent does NOT spawn other agents
4. ✅ Agent produces Core Web Vitals analysis

### Verification Checklist
- [ ] Agent spawned successfully
- [ ] Skill loaded: performance-analyzer
- [ ] No delegation occurred
- [ ] Output includes:
  - [ ] Core Web Vitals metrics (LCP, INP, CLS)
  - [ ] Database query analysis
  - [ ] Caching recommendations
  - [ ] Asset optimization suggestions

### Output Format Validation
```markdown
## Performance Analysis

**Core Web Vitals:**
- LCP: 2.5s (Good)
- INP: 100ms (Good)
- CLS: 0.05 (Good)

**Issues Found:**
1. [HIGH] N+1 query detected in post loop
   - File: path/to/file.php line 156
```

---

## Test 1.3: Security Specialist

### Setup
- Project with security vulnerabilities (SQL injection risk, XSS, etc.)

### Test Procedure
```
User: Run /audit-security and check for OWASP Top 10 vulnerabilities
```

### Expected Behavior
1. ✅ Command spawns `security-specialist` agent
2. ✅ Agent accesses `security-scanner` skill
3. ✅ Agent does NOT spawn other agents
4. ✅ Agent produces security vulnerability report

### Verification Checklist
- [ ] Agent spawned successfully
- [ ] Skill loaded: security-scanner
- [ ] No delegation occurred
- [ ] Output includes:
  - [ ] OWASP Top 10 vulnerability references
  - [ ] CVE identifiers (if dependency issues)
  - [ ] Input validation issues
  - [ ] Output encoding problems

### Output Format Validation
```markdown
## Security Audit Results

**Status:** ❌ Critical Vulnerabilities Found

**Critical Issues:**
1. [CRITICAL] SQL Injection vulnerability
   - File: path/to/file.php line 89
   - Risk: OWASP A03:2021 - Injection
   - Fix: Use prepared statements
```

---

## Test 1.4: Documentation Specialist

### Setup
- Project with undocumented functions/classes

### Test Procedure
```
User: Run /docs-generate and create API documentation for the User module
```

### Expected Behavior
1. ✅ Command spawns `documentation-specialist` agent
2. ✅ Agent accesses `documentation-generator` skill
3. ✅ Agent does NOT spawn other agents
4. ✅ Agent generates documentation

### Verification Checklist
- [ ] Agent spawned successfully
- [ ] Skill loaded: documentation-generator
- [ ] No delegation occurred
- [ ] Output includes:
  - [ ] Function/class documentation
  - [ ] Parameter descriptions
  - [ ] Return value documentation
  - [ ] Usage examples

### Output Format Validation
```php
/**
 * Retrieves user data by ID.
 *
 * @param int $user_id
 *   The user ID to retrieve.
 *
 * @return array
 *   User data array or empty array if not found.
 */
```

---

## Test 1.5: Code Quality Specialist

### Setup
- Project with code quality issues (complexity, standards violations)

### Test Procedure
```
User: Run /quality-analyze and check coding standards compliance
```

### Expected Behavior
1. ✅ Command spawns `code-quality-specialist` agent
2. ✅ Agent accesses `code-standards-checker` skill
3. ✅ Agent does NOT spawn other agents
4. ✅ Agent produces code quality report

### Verification Checklist
- [ ] Agent spawned successfully
- [ ] Skill loaded: code-standards-checker
- [ ] No delegation occurred
- [ ] Output includes:
  - [ ] Coding standards violations (PHPCS, ESLint)
  - [ ] Cyclomatic complexity scores
  - [ ] Technical debt assessment
  - [ ] Refactoring recommendations

### Output Format Validation
```markdown
## Code Quality Analysis

**Standards Compliance:** 85%

**Violations:**
1. [ERROR] Line exceeds 80 characters
   - File: path/to/file.php line 45
   - Standard: Drupal.Files.LineLength.TooLong

**Complexity Issues:**
1. [WARNING] Function has cyclomatic complexity of 15
   - File: path/to/file.php line 100
   - Recommendation: Refactor into smaller functions
```

---

## Summary: Leaf Specialists Test Results

| Agent | Spawn | Skill Access | No Delegation | Output Valid |
|-------|-------|--------------|---------------|--------------|
| accessibility-specialist | ☐ | ☐ | ☐ | ☐ |
| performance-specialist | ☐ | ☐ | ☐ | ☐ |
| security-specialist | ☐ | ☐ | ☐ | ☐ |
| documentation-specialist | ☐ | ☐ | ☐ | ☐ |
| code-quality-specialist | ☐ | ☐ | ☐ | ☐ |

**Pass Criteria:** All checkboxes must be ✅

---

## Common Issues & Debugging

### Agent Doesn't Spawn
- Check: Is plugin enabled? `claude plugins list`
- Check: Is Task tool in allowed-tools?
- Check: Command file syntax correct?

### Skill Not Accessible
- Check: Skill referenced in agent YAML frontmatter?
- Check: Skill file exists in skills/ directory?

### Unexpected Delegation
- Check: Agent has Task tool in frontmatter? (should NOT)
- Check: Agent documentation mentions delegation? (should NOT)

---

*Test Date: _________*
*Tester: _________*
*Results: _________*
