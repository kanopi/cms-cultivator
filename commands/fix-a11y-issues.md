---
description: Generate specific fixes for accessibility issues
allowed-tools: Read, Glob, Grep, Edit, Write
---

Analyze accessibility issues and provide concrete code fixes.

## Instructions

1. **Analyze current issues** using other a11y commands or user input
2. **Prioritize by impact**:
   - Critical: Blocks access completely
   - High: Major barrier
   - Medium: Significant inconvenience
   - Low: Minor issue
3. **Generate specific fixes** with before/after code
4. **Provide implementation guidance**

## Output Format

```markdown
# Accessibility Fixes

## High Priority Fixes

### 1. Add Missing Form Labels
**Impact**: Screen readers cannot identify form fields
**Effort**: Low
**Files**: contact-form.html, signup.html

**Before**:
\`\`\`html
<input type="text" name="username">
\`\`\`

**After**:
\`\`\`html
<label for="username">Username</label>
<input type="text" id="username" name="username">
\`\`\`

**Implementation**:
1. Add id to input
2. Add label with matching for attribute
3. Ensure label text is descriptive

---

### 2. Fix Color Contrast
**Impact**: Low vision users cannot read text
**Effort**: Low
**Files**: styles.css

**Before**:
\`\`\`css
.text { color: #999; }
\`\`\`

**After**:
\`\`\`css
.text { color: #767676; } /* 4.5:1 contrast */
\`\`\`

## Medium Priority Fixes

[Continue with more fixes...]

## Implementation Roadmap

Week 1:
- [ ] Fix form labels (2 hours)
- [ ] Fix color contrast (1 hour)

Week 2:
- [ ] Add skip links (3 hours)
- [ ] Fix ARIA attributes (4 hours)

## Testing Plan

After each fix:
1. Test with keyboard
2. Test with screen reader
3. Run automated scan
4. Verify no regressions
```
