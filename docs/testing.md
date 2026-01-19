# Testing

CMS Cultivator includes a comprehensive automated test suite to ensure plugin quality and reliability.

## Test Framework

Tests are written using [BATS (Bash Automated Testing System)](https://github.com/bats-core/bats-core), a TAP-compliant testing framework for Bash scripts.

## Prerequisites

### Install BATS

=== "macOS"

    ```bash
    brew install bats-core
    ```

=== "Ubuntu/Debian"

    ```bash
    sudo apt-get install bats
    ```

=== "Manual Installation"

    ```bash
    git clone https://github.com/bats-core/bats-core.git
    cd bats-core
    ./install.sh /usr/local
    ```

### Install Dependencies

**Required:**

- `jq` - JSON processor
- `yq` - YAML processor (optional but recommended)

=== "macOS"

    ```bash
    brew install jq yq
    ```

=== "Ubuntu/Debian"

    ```bash
    sudo apt-get install jq
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod +x /usr/local/bin/yq
    ```

**Optional (for additional validation):**

- `markdownlint` - Markdown linting
- `zensical` - Documentation builds

## Running Tests

### Run All Tests

```bash
bats tests/test-plugin.bats
```

### Run Specific Test

```bash
bats tests/test-plugin.bats --filter "plugin manifest"
```

### Run with Verbose Output

```bash
bats tests/test-plugin.bats --verbose
```

### Run with TAP Output

```bash
bats tests/test-plugin.bats --tap
```

## Test Coverage

The test suite includes **54 tests** across multiple categories:

### Plugin Manifest Tests (7 tests)

- ✅ Manifest file exists and is valid JSON
- ✅ Required fields present (name, version, description)
- ✅ Version follows semver
- ✅ Repository URL configured

### Command File Structure Tests (5 tests)

- ✅ Commands directory exists with correct files
- ✅ All files have .md extension
- ✅ Command count matches expected (25)

### Command Frontmatter Tests (5 tests)

- ✅ All commands have YAML frontmatter
- ✅ Required fields: description, allowed-tools
- ✅ Valid YAML syntax
- ✅ No empty descriptions

### Command Naming Convention Tests

- ✅ PR commands: `pr-*`
- ✅ Accessibility: `audit-a11y`
- ✅ Performance: `audit-perf`
- ✅ Security: `audit-security`
- ✅ Testing: `test-*`
- ✅ Quality: `quality-*`
- ✅ Documentation: `docs-*`
- ✅ Design: `design-*`
- ✅ Live auditing: `audit-live-site`

### Command Content Tests (3 tests)

- ✅ All commands have markdown headers
- ✅ Commands contain code examples
- ✅ No uncommitted TODO markers

### Allowed-Tools Validation Tests (2 tests)

- ✅ Valid tool patterns in frontmatter
- ✅ Both direct and DDEV variants for composer

### Documentation Tests (9 tests)

- ✅ README exists with proper badges
- ✅ Zensical configuration valid
- ✅ All documentation pages exist
- ✅ GitHub Actions workflow configured

### Kanopi Integration Tests (3 tests)

- ✅ Kanopi tools documentation present
- ✅ Commands reference Kanopi where appropriate

### License and Metadata Tests (3 tests)

- ✅ LICENSE file exists
- ✅ CHANGELOG.md exists
- ✅ CLAUDE.md exists

### File Hygiene Tests (3 tests)

- ✅ No trailing whitespace
- ✅ No merge conflict markers
- ✅ No debug statements

### Security Tests (2 tests)

- ✅ No hardcoded secrets
- ✅ No private URLs

### Cross-Reference Tests (2 tests)

- ✅ README commands match actual files
- ✅ Command counts in README are accurate

### Performance Tests (2 tests)

- ✅ No command file exceeds 100KB
- ✅ Total size is reasonable

### Integration Tests (2 tests - optional)

- ✅ MkDocs can build documentation
- ✅ Markdown files pass linting

## CI/CD Integration

Tests run automatically via GitHub Actions on:

- Push to main branch
- Pull requests
- Manual workflow dispatch

See [`.github/workflows/test.yml`](https://github.com/kanopi/cms-cultivator/blob/main/.github/workflows/test.yml) for the complete CI/CD configuration.

### GitHub Actions Jobs

1. **BATS Tests** - Runs all BATS test suite
2. **Frontmatter Validation** - Validates command frontmatter
3. **Documentation Build** - Builds Zensical site
4. **Command Count Validation** - Verifies expected counts
5. **Security Scan** - Checks for secrets and conflicts
6. **JSON/YAML/TOML Validation** - Validates config files

## Test Output

### Success Output

```
✓ plugin manifest exists
✓ plugin manifest is valid JSON
✓ plugin manifest has required fields
✓ plugin name is cms-cultivator
✓ plugin version follows semver
...

54 tests, 0 failures
```

### Failure Output

```
✗ all commands have description in frontmatter
   (in test file tests/test-plugin.bats, line 78)
     `if ! grep -q "^description:" "$cmd"; then' failed
   Missing description in commands/example.md

1 test, 1 failure
```

## Writing New Tests

### Test Structure

```bash
@test "descriptive test name" {
  # Setup (if needed)
  local variable="value"

  # Execute test
  run command_to_test

  # Assertions
  [ "$status" -eq 0 ]
  [ "$output" = "expected" ]
}
```

### Common Assertions

```bash
# Status code
[ "$status" -eq 0 ]           # Success
[ "$status" -ne 0 ]           # Failure

# File/directory checks
[ -f "file.txt" ]             # File exists
[ -d "directory" ]            # Directory exists
[ ! -f "file.txt" ]           # File does not exist

# String comparisons
[ "$output" = "exact" ]       # Exact match
[[ "$output" =~ regex ]]      # Regex match
[ -z "$string" ]              # String is empty
[ -n "$string" ]              # String is not empty

# Numeric comparisons
[ "$count" -eq 5 ]            # Equal
[ "$count" -ne 5 ]            # Not equal
[ "$count" -gt 5 ]            # Greater than
[ "$count" -lt 5 ]            # Less than
```

### Adding a New Test

1. Add test to `tests/test-plugin.bats`
2. Run locally: `bats tests/test-plugin.bats --filter "your new test"`
3. Verify it passes
4. Commit and push

## Troubleshooting

### Test fails with "command not found"

Install missing dependencies:

=== "macOS"

    ```bash
    brew install jq yq bats-core
    ```

=== "Linux"

    ```bash
    sudo apt-get install jq bats
    ```

### YAML validation fails

Install yq:

```bash
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod +x /usr/local/bin/yq
```

### Zensical build test fails

Install Zensical:

```bash
pip install zensical
```

### Tests pass locally but fail in CI

- Check that all dependencies are installed in CI workflow
- Verify file paths are correct (CI runs from project root)
- Check for platform-specific differences (line endings, etc.)

## Resources

- [BATS Documentation](https://bats-core.readthedocs.io/)
- [BATS GitHub Repository](https://github.com/bats-core/bats-core)
- [Test Anything Protocol (TAP)](https://testanything.org/)
- [GitHub Actions Workflows](https://github.com/kanopi/cms-cultivator/tree/main/.github/workflows)

---

**Last updated:** 2025-10-13
