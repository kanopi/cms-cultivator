# Priority Mapping

Map audit severity to Teamwork priority levels.

## Severity to Priority Table

| Audit Severity | Teamwork Priority | Rationale |
|----------------|-------------------|-----------|
| Critical | P0 | Production down, data loss, active exploit |
| High | P1 | Major vulnerability, significant performance issue |
| Medium | P2 | Standard fixes, moderate issues |
| Low | P3 | Minor improvements, best practices |
| Info | P4 | Technical debt, future considerations |

## Numeric Score Mapping (0-10 scale)

For tools that use numeric severity scores:

- 9.0-10.0 → P0 (Critical)
- 7.0-8.9 → P1 (High)
- 4.0-6.9 → P2 (Medium)
- 1.0-3.9 → P3 (Low)
- 0.0-0.9 → P4 (Info)
