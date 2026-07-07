#!/usr/bin/env bats

# Test suite for the /delivery-record-verify skill + CI helper (PR 2).
# Run with: bats tests/test-delivery-record-verify.bats

setup() {
  export PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  cd "$PROJECT_ROOT"
  export VSPEC="spec/delivery-record/v1"
  export VALIDATOR="scripts/delivery_record_verify.py"
}

have_validator() {
  command -v python3 >/dev/null 2>&1 && python3 -c 'import yaml, jsonschema' >/dev/null 2>&1
}

# ==============================================================================
# SKILL + SCRIPT STRUCTURE
# ==============================================================================

@test "delivery-record-verify skill exists and is well-formed" {
  [ -f "skills/delivery-record-verify/SKILL.md" ]
  grep -q "^name: delivery-record-verify$" "skills/delivery-record-verify/SKILL.md"
  grep -q "^description:" "skills/delivery-record-verify/SKILL.md"
  [ -f "skills/delivery-record-verify/agents/openai.yaml" ]
  grep -q "allow_implicit_invocation:" "skills/delivery-record-verify/agents/openai.yaml"
}

@test "delivery-record-verify doc page exists" {
  [ -f "docs/commands/delivery-record-verify.md" ]
}

@test "verifier script and CI wrapper exist and are executable" {
  [ -x "scripts/delivery_record_verify.py" ]
  [ -x "scripts/delivery-record-verify.sh" ]
}

# ==============================================================================
# VALIDATION BEHAVIOR
# ==============================================================================

@test "verify passes for every example record" {
  have_validator || skip "python3 + pyyaml + jsonschema not available"
  run python3 "$VALIDATOR" "$VSPEC"/examples/*.md
  echo "$output"
  [ "$status" -eq 0 ]
  # Derive the expected count from the number of example files, so the assertion
  # grows with the spec instead of hardcoding a number.
  count=$(ls "$VSPEC"/examples/*.md | wc -l | tr -d ' ')
  echo "$output" | grep -q "$count passing"
}

@test "verify fails for a hand-crafted broken record" {
  have_validator || skip "python3 + pyyaml + jsonschema not available"
  tmp="$(mktemp -d)"
  # code record missing the required `review` check key.
  printf -- '---\npredicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1\nactivity_type: code\nsubject: {kind: pr, title: x}\nassisted_by: {models: [m]}\nchecks: {standards: {phpcs: pass}, tests: {unit: pass}, audits: {a11y: pass}}\nsign_off: {produced_by: a, reviewed_by: b}\n---\nbody\n' > "$tmp/missing-review.md"
  run python3 "$VALIDATOR" "$tmp/missing-review.md"
  echo "$output"
  [ "$status" -eq 1 ]
  rm -rf "$tmp"
}

@test "--strict escalates a threshold warning to a failure" {
  have_validator || skip "python3 + pyyaml + jsonschema not available"
  tmp="$(mktemp -d)"
  # Structurally valid, but an `n/a` with no justification near the top of the body.
  printf -- '---\npredicate_type: https://kanopi.github.io/cms-cultivator/spec/delivery-record/v1\nactivity_type: code\nsubject: {kind: pr, title: x}\nassisted_by: {models: [m]}\nchecks: {standards: {phpcs: pass}, tests: {unit: pass}, audits: {a11y: pass, performance: n/a}, review: {qa: pass}}\nsign_off: {produced_by: a, reviewed_by: b}\n---\n## What changed\nNothing notable.\n' > "$tmp/warn.md"

  # Default: warning only, still passes.
  run python3 "$VALIDATOR" "$tmp/warn.md"
  echo "$output"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "⚠"

  # Strict: the same warning becomes a failure.
  run python3 "$VALIDATOR" --strict "$tmp/warn.md"
  echo "$output"
  [ "$status" -eq 1 ]
  rm -rf "$tmp"
}

@test "auto-detect mode finds records under docs/delivery-records/" {
  have_validator || skip "python3 + pyyaml + jsonschema not available"
  tmp="$(mktemp -d)"
  mkdir -p "$tmp/docs/delivery-records"
  cp "$VSPEC/examples/code-pr.md" "$tmp/docs/delivery-records/PR-1-example.md"
  cd "$tmp"
  run python3 "$PROJECT_ROOT/$VALIDATOR"
  echo "$output"
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "1 passing"
  cd "$PROJECT_ROOT"
  rm -rf "$tmp"
}

@test "auto-detect with no records is a no-op success" {
  have_validator || skip "python3 + pyyaml + jsonschema not available"
  tmp="$(mktemp -d)"
  cd "$tmp"
  run python3 "$PROJECT_ROOT/$VALIDATOR"
  echo "$output"
  [ "$status" -eq 0 ]
  cd "$PROJECT_ROOT"
  rm -rf "$tmp"
}

@test "CI wrapper runs the validator end-to-end" {
  have_validator || skip "python3 + pyyaml + jsonschema not available"
  run scripts/delivery-record-verify.sh "$VSPEC"/examples/code-pr.md
  echo "$output"
  [ "$status" -eq 0 ]
}
