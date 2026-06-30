#!/usr/bin/env bash
#
# CI helper: validate Delivery Record files against the bundled spec.
#
# Drop this into a CI job to enforce that every PR ships a valid Delivery Record:
#
#   - name: Verify Delivery Records
#     run: scripts/delivery-record-verify.sh --strict
#
# With no arguments it validates docs/delivery-records/*.md in the repo root.
# Pass explicit paths to validate specific files. All flags pass through to the
# underlying Python validator (e.g. --strict, --json).
#
# Exit status mirrors the validator: 0 = all valid, 1 = validation failure,
# 2 = environment/usage error.
#
# NOTE: not enabled in cms-cultivator's own CI — this is a tool other projects
# opt into.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v python3 >/dev/null 2>&1; then
  echo "error: python3 is required to run the Delivery Record verifier" >&2
  exit 2
fi

exec python3 "${SCRIPT_DIR}/delivery_record_verify.py" "$@"
