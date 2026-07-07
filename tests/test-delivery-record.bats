#!/usr/bin/env bats

# Test suite for the Delivery Record spec + /delivery-record skill (PR 1).
# Run with: bats tests/test-delivery-record.bats

setup() {
  export PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  cd "$PROJECT_ROOT"
  export VSPEC="spec/delivery-record/v1"
  export VALIDATOR="scripts/delivery_record_verify.py"
}

# Returns 0 when the Python validator and its deps are available.
have_validator() {
  command -v python3 >/dev/null 2>&1 && python3 -c 'import yaml, jsonschema' >/dev/null 2>&1
}

# The activity-type list is derived from the schema enum so tests grow with the
# spec instead of hardcoding a count. Call inside a test (after setup cd's to root).
activity_types() {
  jq -r '.properties.activity_type.enum[]' "$VSPEC/schema.json"
}

# The example filename for an activity type (code is the one that differs).
example_file() {
  case "$1" in
    code) echo "$VSPEC/examples/code-pr.md" ;;
    *)    echo "$VSPEC/examples/$1.md" ;;
  esac
}

# ==============================================================================
# SPEC STRUCTURE
# ==============================================================================

@test "spec directory and version layout exist" {
  [ -d "spec/delivery-record" ]
  [ -f "spec/delivery-record/VERSIONING.md" ]
  [ -d "$VSPEC" ]
  [ -f "$VSPEC/schema.json" ]
  [ -f "$VSPEC/README.md" ]
  [ -d "$VSPEC/checks" ]
  [ -d "$VSPEC/examples" ]
}

@test "schema.json is valid JSON" {
  run jq empty "$VSPEC/schema.json"
  [ "$status" -eq 0 ]
}

@test "a checks/<activity_type>.json file exists and is valid JSON for every activity type" {
  for t in $(activity_types); do
    [ -f "$VSPEC/checks/$t.json" ] || { echo "missing checks/$t.json"; return 1; }
    run jq empty "$VSPEC/checks/$t.json"
    [ "$status" -eq 0 ] || { echo "invalid JSON in checks/$t.json"; return 1; }
  done
}

@test "predicate_type uses the resolvable docs-site URL form" {
  run jq -r '.properties.predicate_type.pattern' "$VSPEC/schema.json"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q 'kanopi\\\.github\\\.io/cms-cultivator/spec/delivery-record'
}

@test "activity_type enum matches the checks/ files exactly (parity, no drift)" {
  enum=$(jq -r '.properties.activity_type.enum[]' "$VSPEC/schema.json" | sort | tr '\n' ' ')
  files=$(for f in "$VSPEC"/checks/*.json; do basename "$f" .json; done | sort | tr '\n' ' ')
  if [ "$enum" != "$files" ]; then
    echo "enum ($enum) != checks files ($files)"
    return 1
  fi
}

# ==============================================================================
# PER-ACTIVITY REQUIRED KEYS (the prose-table contract)
# ==============================================================================

@test "each checks/<activity_type>.json requires exactly the prose-table keys" {
  # Uses a case statement (not associative arrays) for macOS bash 3.2 support.
  expected_keys() {
    case "$1" in
      code)                echo '["audits","review","standards","tests"]' ;;
      frd)                 echo '["completeness","hour_total_vs_cap","sow_alignment","stakeholder_review"]' ;;
      audit)               echo '["findings_verified","methodology","sample_size","severity_rubric"]' ;;
      discovery)           echo '["bias_check","sample_size","sources_cited","stakeholder_review"]' ;;
      design-handoff)      echo '["audiences","cd_review","figma_urls","goals_kpis","journeys"]' ;;
      strategy)            echo '["alternatives_considered","recommendations_defensible","sources_grounded"]' ;;
      client-comm)         echo '["facts_verified","no_unauthorized_commitments","tone_reviewed"]' ;;
      design)              echo '["accessibility_review","brand_alignment","design_system","stakeholder_review"]' ;;
      qa)                  echo '["acceptance_criteria","evidence_captured","regressions_checked","test_coverage"]' ;;
      launch)              echo '["dns_ssl_verified","prelaunch_audits","rollback_plan","stakeholder_signoff"]' ;;
      deployment)          echo '["backup_taken","migrations_verified","release_notes","smoke_test"]' ;;
      devops)              echo '["change_documented","rollback_plan","secrets_handled","tested_lower_env"]' ;;
      project-setup)       echo '["access_confirmed","context_accurate","sources_verified","stakeholder_review"]' ;;
      ongoing-improvement) echo '["findings_verified","metrics_reviewed","recommendations_prioritized","stakeholder_review"]' ;;
      *)                   echo "UNMAPPED:$1" ;;
    esac
  }

  for t in $(activity_types); do
    got=$(jq -c '.required | sort' "$VSPEC/checks/$t.json")
    want=$(expected_keys "$t")
    if [ "$got" != "$want" ]; then
      echo "checks/$t.json required mismatch: got $got, expected $want"
      return 1
    fi
  done
}

@test "schema.json if/then branches stay in sync with checks/<activity_type>.json" {
  for t in $(activity_types); do
    from_schema=$(jq -c --arg t "$t" \
      '.allOf[] | select(.if.properties.activity_type.const==$t) | .then.properties.checks.required | sort' \
      "$VSPEC/schema.json")
    from_checks=$(jq -c '.required | sort' "$VSPEC/checks/$t.json")
    if [ "$from_schema" != "$from_checks" ]; then
      echo "$t: schema branch ($from_schema) != checks file ($from_checks)"
      return 1
    fi
  done
}

# ==============================================================================
# EXAMPLES / VALIDATION
# ==============================================================================

@test "an example record exists for every activity type" {
  for t in $(activity_types); do
    f=$(example_file "$t")
    [ -f "$f" ] || { echo "missing example for $t ($f)"; return 1; }
  done
}

@test "spec validates against itself — every example passes (strict)" {
  have_validator || skip "python3 + pyyaml + jsonschema not available"
  run python3 "$VALIDATOR" --strict "$VSPEC"/examples/*.md
  echo "$output"
  [ "$status" -eq 0 ]
}

@test "bad records fail validation with descriptive errors" {
  have_validator || skip "python3 + pyyaml + jsonschema not available"
  tmp="$(mktemp -d)"

  # Wrong predicate_type (bare path, not the resolvable URL).
  printf -- '---\npredicate_type: kanopi/delivery-record/v1\nactivity_type: code\nsubject: {kind: pr, title: x}\nassisted_by: {models: [m]}\nchecks: {standards: {phpcs: pass}, tests: {unit: pass}, audits: {a11y: pass}, review: {qa: pass}}\nsign_off: {produced_by: a, reviewed_by: b}\n---\nbody\n' > "$tmp/bad-predicate.md"
  run python3 "$VALIDATOR" "$tmp/bad-predicate.md"
  [ "$status" -eq 1 ]
  echo "$output" | grep -qi "predicate_type"

  # Unknown activity_type.
  printf -- '---\npredicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1\nactivity_type: banana\nsubject: {kind: pr, title: x}\nassisted_by: {models: [m]}\nchecks: {standards: {phpcs: pass}}\nsign_off: {produced_by: a, reviewed_by: b}\n---\nbody\n' > "$tmp/bad-activity.md"
  run python3 "$VALIDATOR" "$tmp/bad-activity.md"
  [ "$status" -eq 1 ]
  echo "$output" | grep -qi "activity_type"

  # Missing sign_off.reviewed_by.
  printf -- '---\npredicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1\nactivity_type: code\nsubject: {kind: pr, title: x}\nassisted_by: {models: [m]}\nchecks: {standards: {phpcs: pass}, tests: {unit: pass}, audits: {a11y: pass}, review: {qa: pass}}\nsign_off: {produced_by: a}\n---\nbody\n' > "$tmp/bad-signoff.md"
  run python3 "$VALIDATOR" "$tmp/bad-signoff.md"
  [ "$status" -eq 1 ]
  echo "$output" | grep -qi "reviewed_by"

  rm -rf "$tmp"
}

# ==============================================================================
# SKILL STRUCTURE
# ==============================================================================

@test "delivery-record skill exists and is well-formed" {
  [ -f "skills/delivery-record/SKILL.md" ]
  grep -q "^name: delivery-record$" "skills/delivery-record/SKILL.md"
  grep -q "^description:" "skills/delivery-record/SKILL.md"
  [ -f "skills/delivery-record/agents/openai.yaml" ]
  grep -q "allow_implicit_invocation:" "skills/delivery-record/agents/openai.yaml"
}

@test "delivery-record ships a body template for every activity type" {
  for t in $(activity_types); do
    [ -f "skills/delivery-record/templates/$t.md" ] || { echo "missing template $t.md"; return 1; }
  done
}

@test "delivery-record doc page exists" {
  [ -f "docs/commands/delivery-record.md" ]
  [ -f "docs/spec/delivery-record/v1.md" ]
}
