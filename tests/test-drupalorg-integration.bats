#!/usr/bin/env bats

# Integration tests for drupal.org functionality
# Run with: bats tests/test-drupalorg-integration.bats
# NOTE: These tests hit real services - run sparingly

setup() {
  export PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  export DRUPAL_CONTRIB_DIR="$HOME/.cache/drupal-contrib"
  cd "$PROJECT_ROOT"
}

# ==============================================================================
# PREREQUISITE TESTS
# ==============================================================================

@test "glab CLI is installed" {
  command -v glab || skip "glab not installed"
}

@test "git is installed" {
  command -v git
}

@test "glab can reach git.drupalcode.org" {
  if ! command -v glab &> /dev/null; then
    skip "glab not installed"
  fi
  run glab api --hostname git.drupalcode.org /api/v4/version
  [ "$status" -eq 0 ] || skip "Not authenticated to git.drupalcode.org"
}

# ==============================================================================
# CLONE DIRECTORY TESTS
# ==============================================================================

@test "contrib cache directory can be created" {
  mkdir -p "$DRUPAL_CONTRIB_DIR"
  [ -d "$DRUPAL_CONTRIB_DIR" ]
}

@test "can clone drupal.org project to cache directory" {
  # Only run if not already cloned (expensive operation)
  if [ -d "$DRUPAL_CONTRIB_DIR/easy_lqp" ]; then
    skip "easy_lqp already cloned"
  fi

  # Skip if no network or auth
  if ! ssh -o BatchMode=yes -o ConnectTimeout=5 git@git.drupal.org true 2>/dev/null; then
    skip "Cannot connect to git.drupal.org via SSH"
  fi

  run git clone git@git.drupal.org:project/easy_lqp.git "$DRUPAL_CONTRIB_DIR/easy_lqp"
  [ "$status" -eq 0 ]
  [ -d "$DRUPAL_CONTRIB_DIR/easy_lqp/.git" ]
}

@test "cloned repo is not in current project directory" {
  # Verify isolation from plugin project
  [ ! -d "$PROJECT_ROOT/easy_lqp" ]
}

# ==============================================================================
# GLAB FUNCTIONALITY TESTS
# ==============================================================================

@test "glab can list MRs for drupal project" {
  if ! command -v glab &> /dev/null; then
    skip "glab not installed"
  fi
  run glab mr list --hostname git.drupalcode.org --repo project/easy_lqp 2>&1
  # May fail if not authenticated, that's ok for CI
  [ "$status" -eq 0 ] || skip "Cannot access git.drupalcode.org MRs"
}

# ==============================================================================
# CLEANUP TESTS
# ==============================================================================

@test "can list cloned repos" {
  if [ ! -d "$DRUPAL_CONTRIB_DIR" ]; then
    skip "No contrib directory exists"
  fi

  run ls -la "$DRUPAL_CONTRIB_DIR"
  [ "$status" -eq 0 ]
}

@test "can remove cloned repo" {
  if [ -d "$DRUPAL_CONTRIB_DIR/easy_lqp" ]; then
    rm -rf "$DRUPAL_CONTRIB_DIR/easy_lqp"
    [ ! -d "$DRUPAL_CONTRIB_DIR/easy_lqp" ]
  else
    skip "easy_lqp not cloned"
  fi
}

# ==============================================================================
# BRANCH NAMING CONVENTION TESTS
# ==============================================================================

@test "branch naming follows drupal convention" {
  # Test pattern: {issue_number}-{description}
  valid_branches=(
    "3456789-fix-validation"
    "1234567-add-feature"
    "9999999-update-docs"
  )

  for branch in "${valid_branches[@]}"; do
    # Should match: starts with digits, followed by hyphen, then description
    [[ "$branch" =~ ^[0-9]+-[a-z0-9-]+$ ]]
  done
}

@test "invalid branch names detected" {
  invalid_branches=(
    "feature-branch"      # No issue number
    "fix_validation"      # Underscores instead of hyphens
    "3456789"             # No description
  )

  for branch in "${invalid_branches[@]}"; do
    # Should NOT match the valid pattern
    if [[ "$branch" =~ ^[0-9]+-[a-z0-9-]+$ ]]; then
      echo "Invalid branch '$branch' incorrectly matched valid pattern"
      return 1
    fi
  done
}

# ==============================================================================
# COMMIT MESSAGE FORMAT TESTS
# ==============================================================================

@test "commit message format is correct" {
  valid_messages=(
    "Issue #3456789: Fix validation error"
    "Issue #1234567: Add new feature for exports"
    "Issue #9999999: Update documentation"
  )

  for msg in "${valid_messages[@]}"; do
    # Should match: Issue #{number}: {description}
    [[ "$msg" =~ ^Issue\ #[0-9]+:\ .+$ ]]
  done
}

# ==============================================================================
# URL FORMAT TESTS
# ==============================================================================

@test "drupal.org issue URL format is correct" {
  url="https://www.drupal.org/project/paragraphs/issues/3456789"
  [[ "$url" =~ ^https://www\.drupal\.org/project/[a-z_]+/issues/[0-9]+$ ]]
}

@test "git.drupalcode.org project URL format is correct" {
  url="git@git.drupal.org:project/paragraphs.git"
  [[ "$url" =~ ^git@git\.drupal\.org:project/[a-z_]+\.git$ ]]
}

@test "issue fork URL format is correct" {
  url="git@git.drupal.org:issue/paragraphs-3456789.git"
  [[ "$url" =~ ^git@git\.drupal\.org:issue/[a-z_]+-[0-9]+\.git$ ]]
}

# ==============================================================================
# REMOTE CONFIGURATION TESTS
# ==============================================================================

@test "issue fork remote command is correct" {
  # Simulate the command that would be run
  project="paragraphs"
  issue="3456789"
  expected_remote="git@git.drupal.org:issue/${project}-${issue}.git"

  [ "$expected_remote" = "git@git.drupal.org:issue/paragraphs-3456789.git" ]
}
