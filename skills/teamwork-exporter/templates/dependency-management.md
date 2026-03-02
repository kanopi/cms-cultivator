# Dependency Management

Automatically detect and link task dependencies when exporting findings.

## Auto-detect Dependencies

**Blocking relationships to identify:**
- Database schema changes block feature development
- Security fixes block deployment
- Infrastructure changes block application changes

## Example Dependency Detection

**Finding 1:** SQL Injection in User Search [P0]
**Finding 2:** Missing Input Validation [P1]

**Relationship:** Finding 2 depends on Finding 1
- Fix SQL injection first (sanitization layer)
- Then add comprehensive input validation
- Testing requires both fixes

**Exported as:**
```
Task A: Fix SQL Injection [P0]
Task B: Add Input Validation [P1]
  └─ Depends on: Task A
```

## Common Dependency Patterns

- **Core fixes before feature fixes** - Sanitization layer before individual validations
- **Infrastructure before application** - CDN setup before image optimization
- **Database before code** - Schema updates before code using new fields
