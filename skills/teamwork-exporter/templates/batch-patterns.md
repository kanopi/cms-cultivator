# Batch Export Patterns

Common patterns for organizing multiple findings into epics and sub-tasks.

## Pattern 1: Epic with Sub-Tasks

**When:** 3+ related findings in same category

**Structure:**
```
Epic: Security Fixes - XSS Vulnerabilities [P1]
├── Task 1: XSS in User Profile [P1]
├── Task 2: XSS in Comment Form [P1]
└── Task 3: XSS in Search Results [P1]
```

**Epic content includes:**
- Overview of vulnerability type
- Total count and severity
- Remediation strategy
- Testing approach
- Rollout plan

## Pattern 2: Priority Buckets

**When:** Mixed severity findings (10+ issues)

**Structure:**
```
Epic: Accessibility Improvements [P2]
├── Critical Fixes (P0)
│   └── Task 1: Keyboard trap in modal [P0]
├── High Priority (P1)
│   ├── Task 2: Missing alt text [P1]
│   └── Task 3: Color contrast issues [P1]
└── Medium Priority (P2)
    ├── Task 4: Focus indicators [P2]
    └── Task 5: ARIA labels [P2]
```

## Pattern 3: Component-Based

**When:** Multiple issues in same component

**Structure:**
```
Epic: Fix Product Card Component [P2]
├── Task 1: Accessibility - ARIA labels [P1]
├── Task 2: Performance - Image optimization [P2]
└── Task 3: Security - XSS in product name [P1]
```
