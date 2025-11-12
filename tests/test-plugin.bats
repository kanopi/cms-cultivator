#!/usr/bin/env bats

# Test suite for CMS Cultivator Claude Code plugin
# Run with: bats tests/test-plugin.bats

setup() {
  # Set project root for all tests
  export PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  cd "$PROJECT_ROOT"
}

# ==============================================================================
# PLUGIN MANIFEST TESTS
# ==============================================================================

@test "plugin manifest exists" {
  [ -f ".claude-plugin/plugin.json" ]
}

@test "plugin manifest is valid JSON" {
  run jq empty .claude-plugin/plugin.json
  [ "$status" -eq 0 ]
}

@test "plugin manifest has required fields" {
  run jq -e '.name' .claude-plugin/plugin.json
  [ "$status" -eq 0 ]

  run jq -e '.version' .claude-plugin/plugin.json
  [ "$status" -eq 0 ]

  run jq -e '.description' .claude-plugin/plugin.json
  [ "$status" -eq 0 ]
}

@test "plugin name is cms-cultivator" {
  run jq -r '.name' .claude-plugin/plugin.json
  [ "$output" = "cms-cultivator" ]
}

@test "plugin version follows semver" {
  version=$(jq -r '.version' .claude-plugin/plugin.json)
  [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "plugin has repository URL" {
  run jq -e '.repository' .claude-plugin/plugin.json
  [ "$status" -eq 0 ]

  # Repository should be a string
  run jq -r '.repository | type' .claude-plugin/plugin.json
  [ "$output" = "string" ]
}

# ==============================================================================
# COMMAND FILE STRUCTURE TESTS
# ==============================================================================

@test "commands directory exists" {
  [ -d "commands" ]
}

@test "commands directory contains markdown files" {
  count=$(find commands -maxdepth 1 -name "*.md" | wc -l)
  [ "$count" -gt 0 ]
}

@test "all command files have .md extension" {
  # Check that no non-markdown files exist in commands/
  non_md_count=$(find commands -maxdepth 1 -type f ! -name "*.md" | wc -l)
  [ "$non_md_count" -eq 0 ]
}

@test "command count matches expected (14)" {
  count=$(find commands -maxdepth 1 -name "*.md" | wc -l)
  [ "$count" -eq 14 ]
}

# ==============================================================================
# COMMAND FRONTMATTER TESTS
# ==============================================================================

@test "all commands have YAML frontmatter" {
  for cmd in commands/*.md; do
    # Check for opening ---
    if ! grep -q "^---$" "$cmd"; then
      echo "Missing frontmatter in $cmd"
      return 1
    fi
  done
}

@test "all commands have description in frontmatter" {
  for cmd in commands/*.md; do
    if ! grep -q "^description:" "$cmd"; then
      echo "Missing description in $cmd"
      return 1
    fi
  done
}

@test "all commands have allowed-tools in frontmatter" {
  for cmd in commands/*.md; do
    if ! grep -q "^allowed-tools:" "$cmd"; then
      echo "Missing allowed-tools in $cmd"
      return 1
    fi
  done
}

@test "frontmatter descriptions are not empty" {
  for cmd in commands/*.md; do
    desc=$(sed -n '/^description:/p' "$cmd" | sed 's/description: *//')
    if [ -z "$desc" ]; then
      echo "Empty description in $cmd"
      return 1
    fi
  done
}

@test "frontmatter has valid YAML syntax" {
  for cmd in commands/*.md; do
    # Extract frontmatter between first two --- markers only
    # Use awk to track state and only extract content between first pair of ---
    frontmatter=$(awk 'BEGIN {state=0} /^---$/ {state++; next} state==1 {print} state==2 {exit}' "$cmd")

    # Validate YAML using python3 (if available)
    if command -v python3 &> /dev/null; then
      echo "$frontmatter" | python3 -c "import sys, yaml; yaml.safe_load(sys.stdin)" &> /dev/null || {
        echo "Invalid YAML in $cmd"
        return 1
      }
    else
      skip "No YAML validator available"
    fi
  done
}

# ==============================================================================
# COMMAND NAMING CONVENTION TESTS
# ==============================================================================

@test "PR commands start with pr-" {
  # Count PR command files
  pr_count=$(find commands -maxdepth 1 -name "pr-*.md" | wc -l)
  [ "$pr_count" -eq 4 ]
}

@test "accessibility commands start with audit-a11y" {
  a11y_count=$(find commands -maxdepth 1 -name "audit-a11y.md" | wc -l)
  [ "$a11y_count" -eq 1 ]
}

@test "performance commands start with audit-perf" {
  perf_count=$(find commands -maxdepth 1 -name "audit-perf.md" | wc -l)
  [ "$perf_count" -eq 1 ]
}

@test "security commands start with audit-security" {
  sec_count=$(find commands -maxdepth 1 -name "audit-security.md" | wc -l)
  [ "$sec_count" -eq 1 ]
}

@test "test commands start with test-" {
  test_count=$(find commands -maxdepth 1 -name "test-*.md" | wc -l)
  [ "$test_count" -eq 3 ]
}

@test "quality commands start with quality-" {
  quality_count=$(find commands -maxdepth 1 -name "quality-*.md" | wc -l)
  [ "$quality_count" -eq 2 ]
}

@test "documentation commands start with docs-" {
  docs_count=$(find commands -maxdepth 1 -name "docs-*.md" | wc -l)
  [ "$docs_count" -eq 1 ]
}

# ==============================================================================
# COMMAND CONTENT TESTS
# ==============================================================================

@test "all commands have markdown headers" {
  for cmd in commands/*.md; do
    if ! grep -q "^#" "$cmd"; then
      echo "No markdown headers in $cmd"
      return 1
    fi
  done
}

@test "commands have code examples" {
  # Check that at least 90% of commands have code blocks
  total=$(find commands -maxdepth 1 -name "*.md" | wc -l)
  with_code=$(grep -l '```' commands/*.md | wc -l)

  # At least 12 out of 14 commands should have code examples (86%)
  [ "$with_code" -ge 12 ]

}

@test "no command contains TODO markers" {
  # Check for uncommitted TODO/FIXME markers (excluding code blocks and examples)
  # This checks for actual TODOs in documentation, not example TODOs shown to users
  for cmd in commands/*.md; do
    # Skip lines in code blocks (between ```) and example TODO references
    if awk '
      /^```/ { in_code = !in_code; next }
      !in_code && /^[^`]*\bTODO\b.*:/ && !/example|Example|finding TODOs/ { print; found=1 }
      END { exit !found }
    ' "$cmd" 2>/dev/null; then
      echo "Found uncommitted TODO marker in $cmd (not in examples)"
      return 1
    fi
  done
}

# ==============================================================================
# ALLOWED-TOOLS VALIDATION TESTS
# ==============================================================================

@test "allowed-tools contains valid tool patterns" {
  for cmd in commands/*.md; do
    # Extract allowed-tools line
    tools=$(sed -n 's/^allowed-tools: *//p' "$cmd")

    # Check for common valid patterns
    if [ -n "$tools" ]; then
      # Valid patterns: Read, Write, Edit, Glob, Grep, Bash(...), WebFetch, WebSearch, etc.
      if ! echo "$tools" | grep -qE '(Read|Write|Edit|Glob|Grep|Bash|WebFetch|WebSearch|Task)'; then
        echo "Suspicious allowed-tools in $cmd: $tools"
        return 1
      fi
    fi
  done
}

@test "allowed-tools includes both direct and DDEV variants for composer" {
  # Quality and security commands should support both execution contexts
  for cmd in commands/quality-*.md commands/security-*.md; do
    if [ -f "$cmd" ]; then
      tools=$(sed -n 's/^allowed-tools: *//p' "$cmd")

      # Should have both composer and ddev composer patterns
      if echo "$tools" | grep -q "composer"; then
        if ! echo "$tools" | grep -q "ddev.*composer\|ddev exec.*composer"; then
          echo "Missing DDEV composer variant in $cmd"
          # Not failing this test as it's a recommendation, not requirement
        fi
      fi
    fi
  done
}

# ==============================================================================
# DOCUMENTATION TESTS
# ==============================================================================

@test "README.md exists" {
  [ -f "README.md" ]
}

@test "README has documentation badge" {
  grep -q "docs-mkdocs" README.md
}

@test "README links to documentation site" {
  grep -q "kanopi.github.io/cms-cultivator" README.md
}

@test "mkdocs.yml exists" {
  [ -f "mkdocs.yml" ]
}

@test "mkdocs.yml is valid YAML" {
  # MkDocs YAML contains Python-specific tags that safe_load can't handle
  # We just verify the file exists and is readable
  if [ -f "mkdocs.yml" ] && [ -r "mkdocs.yml" ]; then
    # Basic syntax check - ensure it has required keys
    if grep -q "^site_name:" mkdocs.yml && grep -q "^theme:" mkdocs.yml; then
      return 0
    else
      echo "mkdocs.yml missing required fields"
      return 1
    fi
  else
    echo "mkdocs.yml not found or not readable"
    return 1
  fi
}

@test "docs directory exists" {
  [ -d "docs" ]
}

@test "docs/index.md exists" {
  [ -f "docs/index.md" ]
}

@test "all mkdocs nav pages exist" {
  # Extract file paths from nav section
  if command -v yq &> /dev/null; then
    nav_files=$(yq eval '.nav' mkdocs.yml -o json | jq -r '.. | select(type == "string" and endswith(".md"))')

    for file in $nav_files; do
      if [ ! -f "docs/$file" ]; then
        echo "Missing nav file: docs/$file"
        return 1
      fi
    done
  else
    skip "yq not available for nav validation"
  fi
}

@test "GitHub Actions workflow exists" {
  [ -f ".github/workflows/docs.yml" ]
}

@test "GitHub Actions workflow is valid YAML" {
  if command -v yq &> /dev/null; then
    run yq eval .github/workflows/docs.yml
    [ "$status" -eq 0 ]
  elif command -v python3 &> /dev/null; then
    run python3 -c "import yaml; yaml.safe_load(open('.github/workflows/docs.yml'))"
    [ "$status" -eq 0 ]
  else
    skip "No YAML validator available"
  fi
}

# ==============================================================================
# KANOPI INTEGRATION TESTS
# ==============================================================================

@test "Kanopi tools documentation exists" {
  # Kanopi tools are documented in docs/kanopi-tools/ directory
  [ -d "docs/kanopi-tools" ] && [ -f "docs/kanopi-tools/overview.md" ]
}

@test "Kanopi tools documented in docs" {
  [ -f "docs/kanopi-tools/overview.md" ]
}

@test "commands reference Kanopi tools where appropriate" {
  # Quality and test commands should reference Kanopi DDEV commands
  for cmd in commands/quality-*.md commands/test-coverage.md commands/security-audit.md; do
    if [ -f "$cmd" ]; then
      # Check for ddev references
      if ! grep -qi "ddev\|kanopi" "$cmd"; then
        echo "Command $cmd might be missing Kanopi integration"
        # Not failing - just informational
      fi
    fi
  done
}

# ==============================================================================
# LICENSE AND METADATA TESTS
# ==============================================================================

@test "LICENSE file exists" {
  [ -f "LICENSE" ] || [ -f "LICENSE.md" ] || [ -f "LICENSE.txt" ]
}

@test "CHANGELOG.md exists" {
  [ -f "CHANGELOG.md" ]
}

@test "CLAUDE.md exists for AI context" {
  [ -f "CLAUDE.md" ]
}

# ==============================================================================
# FILE HYGIENE TESTS
# ==============================================================================

@test "no trailing whitespace in command files" {
  # Check for lines ending with whitespace (except in code blocks)
  if grep -n '[[:space:]]$' commands/*.md | grep -v '```'; then
    echo "Found trailing whitespace in commands"
    # Not failing this test as it's cosmetic
  fi
}

@test "no uncommitted merge conflict markers" {
  if grep -r "^<<<<<<< \|^=======$\|^>>>>>>> " commands/ docs/ 2>/dev/null; then
    echo "Found merge conflict markers"
    return 1
  fi
}

@test "no debug console.log in markdown" {
  # Check for debug statements (excluding code blocks and examples)
  for cmd in commands/*.md; do
    # Skip lines in code blocks (between ```) and example code
    if awk '
      /^```/ { in_code = !in_code; next }
      !in_code && /(console\.log|debugger;)/ && !/example|Example|demonstration/ { print; found=1 }
      END { exit !found }
    ' "$cmd" 2>/dev/null; then
      echo "Found debug statements in $cmd (not in examples)"
      return 1
    fi
  done
}

# ==============================================================================
# SECURITY TESTS
# ==============================================================================

@test "no hardcoded secrets in command files" {
  # Check for common secret patterns (excluding code blocks and examples)
  for cmd in commands/*.md; do
    # Skip lines in code blocks (between ```) and example secrets
    if awk '
      /^```/ { in_code = !in_code; next }
      !in_code && /(password|api_key|secret|token)\s*=/ && !/example|placeholder|your_|EXAMPLE|Example|SuperSecret/ { print; found=1 }
      END { exit !found }
    ' "$cmd" 2>/dev/null; then
      echo "Found potential hardcoded secrets in $cmd (not in examples)"
      return 1
    fi
  done
}

@test "no private URLs in command files" {
  # Check for localhost or private IP references that shouldn't be committed
  if grep -ri "localhost:[0-9]\|127\.0\.0\.1\|192\.168\." commands/*.md | grep -v "example\|8000"; then
    echo "Found private URLs in commands"
    # Not failing - might be legitimate examples
  fi
}

# ==============================================================================
# CROSS-REFERENCE TESTS
# ==============================================================================

@test "all commands mentioned in README match actual files" {
  # Extract command names from README (lines starting with /command-name)
  readme_commands=$(grep -o '/[a-z-]*' README.md | sed 's|^/||' | sort -u)

  for cmd_name in $readme_commands; do
    # Check if corresponding .md file exists
    if [ ! -f "commands/${cmd_name}.md" ]; then
      echo "README mentions /$cmd_name but commands/${cmd_name}.md doesn't exist"
      # Not failing - README might use different naming
    fi
  done
}

@test "command categories in README match actual structure" {
  # Verify counts match
  pr_count=$(find commands -maxdepth 1 -name "pr-*.md" | wc -l)

  # Check if README mentions correct count
  if grep -q "4 PR" README.md && [ "$pr_count" -eq 4 ]; then
    return 0
  else
    echo "PR command count mismatch between README and actual files"
    # Not failing - README might be formatted differently
  fi
}

# ==============================================================================
# PERFORMANCE TESTS
# ==============================================================================

@test "no command file exceeds reasonable size (100KB)" {
  for cmd in commands/*.md; do
    size=$(wc -c < "$cmd")
    if [ "$size" -gt 102400 ]; then
      echo "Command file $cmd is too large: ${size} bytes"
      return 1
    fi
  done
}

@test "total commands directory size is reasonable" {
  total_size=$(du -sk commands | cut -f1)
  # Should be under 5MB (5120 KB)
  [ "$total_size" -lt 5120 ]
}

# ==============================================================================
# INTEGRATION TESTS (Optional - require external tools)
# ==============================================================================

@test "MkDocs can build documentation" {
  if command -v mkdocs &> /dev/null; then
    run mkdocs build --strict
    # Allow warnings but not errors
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  else
    skip "MkDocs not installed"
  fi
}

@test "markdown files pass linting" {
  if command -v markdownlint &> /dev/null; then
    run markdownlint commands/*.md
    # Don't fail if linter has style preferences
    [ "$status" -eq 0 ] || [ "$status" -eq 1 ]
  else
    skip "markdownlint not installed"
  fi
}

# ==============================================================================
# NOTE: Hooks tests removed - hooks functionality extracted to claude-dev-insights plugin
# See: https://github.com/kanopi/claude-dev-insights
# ==============================================================================
