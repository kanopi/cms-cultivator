# Error Handling

Fallback strategies for common error scenarios during export.

## MCP Server Unavailable

**Fallback:** Provide formatted markdown for manual entry

```markdown
Unable to connect to Teamwork MCP server. Here are formatted tasks to manually create:

---

## Task 1: SQL Injection in User Search

[Complete bug report template]

**Manual steps:**
1. Go to Teamwork
2. Create new task in [Project]
3. Copy/paste above content
4. Set priority: P0 (Critical)
5. Assign to: [Security Lead]

---

[Repeat for each task]
```

## Ambiguous Findings

**Response:**
```markdown
I found some audit findings that need clarification before creating tasks:

**Finding:** "Performance issues in checkout"

**Needs:**
- Which specific metrics are slow? (LCP, FID, CLS?)
- What's the target performance level?
- Which files/components are affected?

Would you like me to re-run a performance audit with more details, or would you like to provide this context now?
```
