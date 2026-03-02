# Security Audit Export Handler

Transform security scan results into Bug Report tasks.

## Input Format

Security scan results (OWASP, CVE, custom scans) with:
- Vulnerability findings
- Severity levels
- CWE/OWASP classifications
- Affected files and lines
- Remediation suggestions

## Output Template

Bug Report tasks for vulnerabilities

## Example Transformation

### Input Finding:

```markdown
### Critical: SQL Injection in User Search

**File:** `includes/search.php:45`
**CWE:** CWE-89
**OWASP:** A03:2021 - Injection

User input from search form is directly concatenated into SQL query without sanitization.

```php
$query = "SELECT * FROM users WHERE name LIKE '%{$_POST['search']}%'";
```

**Recommendation:** Use prepared statements with parameterized queries.
```

### Exported Task:

```markdown
# Bug Report: SQL Injection in User Search

## Bug Description
Critical SQL injection vulnerability in user search functionality. User input is directly concatenated into SQL query without sanitization, allowing potential data exfiltration or modification.

## Security Impact
**Severity:** Critical (P0)
**CWE:** CWE-89 - SQL Injection
**OWASP:** A03:2021 - Injection

**Potential Impact:**
- Unauthorized data access (all user records)
- Data modification or deletion
- Potential server compromise

## Location
- **File:** `includes/search.php`
- **Line:** 45
- **Function:** `search_users()`

## Vulnerable Code
```php
$query = "SELECT * FROM users WHERE name LIKE '%{$_POST['search']}%'";
$results = mysqli_query($conn, $query);
```

## Steps to Reproduce
1. Go to `/search` page
2. Enter payload: `%'; DROP TABLE users; --`
3. Observe SQL error or successful injection

## Expected Behavior
User search should safely query database using parameterized queries.

## Remediation
Replace direct concatenation with prepared statements:

```php
$stmt = $conn->prepare("SELECT * FROM users WHERE name LIKE ?");
$search_param = "%{$search_term}%";
$stmt->bind_param("s", $search_param);
$stmt->execute();
$results = $stmt->get_result();
```

## Testing Requirements
- [ ] Test search with normal queries
- [ ] Test with SQL injection payloads (safe testing)
- [ ] Verify prepared statements used
- [ ] Run security scan to confirm fix

## References
- OWASP SQL Injection: https://owasp.org/www-community/attacks/SQL_Injection
- CWE-89: https://cwe.mitre.org/data/definitions/89.html

## Priority
**P0 (Critical)** - Active security vulnerability in production
```
