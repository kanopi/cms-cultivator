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

The test suite covers multiple categories:

### Plugin Manifest Tests

- ✅ Manifest file exists and is valid JSON
- ✅ Required fields present (name, version, description)
- ✅ Version follows semver
- ✅ Repository URL configured

### Skill File Structure Tests

- ✅ Skills directory exists with correct files
- ✅ All skill directories contain a `SKILL.md`
- ✅ Skill counts stay in parity with the docs (dynamic checks, no hardcoded totals)

### Skill Frontmatter Tests

- ✅ All skills have YAML frontmatter
- ✅ Required fields: name, description
- ✅ Valid YAML syntax
- ✅ No empty descriptions

### Skill Naming Convention Tests

- ✅ PR skills: `pr-*`
- ✅ Testing: `test-*`
- ✅ Design: `design-*`
- ✅ Drupal.org contribution: `drupal-*` / `drupalorg-*`
- ✅ Skill names match their directory names

### Skill Content Tests

- ✅ All skills have markdown headers
- ✅ Skills contain code examples
- ✅ No uncommitted TODO markers

### Documentation Tests

- ✅ README exists with proper badges
- ✅ Zensical configuration valid
- ✅ All documentation pages exist
- ✅ GitHub Actions workflow configured

### Kanopi Integration Tests

- ✅ Kanopi tools documentation present
- ✅ Skills reference Kanopi where appropriate

### License and Metadata Tests

- ✅ LICENSE file exists
- ✅ CHANGELOG.md exists
- ✅ CLAUDE.md exists

### File Hygiene Tests

- ✅ No trailing whitespace
- ✅ No merge conflict markers
- ✅ No debug statements

### Security Tests

- ✅ No hardcoded secrets
- ✅ No private URLs

### Cross-Reference Tests

- ✅ README skill roster matches actual skill directories
- ✅ Docs and README stay in parity with the skills directory

### Performance Tests

- ✅ No skill file exceeds 100KB
- ✅ Total size is reasonable

### Integration Tests (optional)

- ✅ Zensical can build documentation
- ✅ Markdown files pass linting

## CI/CD Integration

Tests run automatically via GitHub Actions on:

- Push to main branch
- Pull requests
- Manual workflow dispatch

See [`.github/workflows/test.yml`](https://github.com/kanopi/cms-cultivator/blob/1.x/.github/workflows/test.yml) for the complete CI/CD configuration.

### GitHub Actions Jobs

1. **BATS Tests** - Runs all BATS test suite
2. **Frontmatter Validation** - Validates skill frontmatter
3. **Documentation Build** - Builds Zensical site
4. **Parity Validation** - Verifies docs stay in sync with skill directories
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

All tests passed, 0 failures
```

### Failure Output

```
✗ all skills have description in frontmatter
   (in test file tests/test-plugin.bats, line 78)
     `if ! grep -q "^description:" "$skill"; then' failed
   Missing description in skills/example/SKILL.md

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
- [GitHub Actions Workflows](https://github.com/kanopi/cms-cultivator/tree/1.x/.github/workflows)

---

**Last updated:** 2026-05-14
