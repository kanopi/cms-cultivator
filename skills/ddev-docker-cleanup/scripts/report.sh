#!/usr/bin/env bash
# report.sh - read-only audit of DDEV / Docker disk usage. Changes nothing.
#
# Shows: current DDEV projects (the protected allowlist), overall Docker disk
# usage, which volumes are kept, and which volumes are orphaned and safe to
# remove. Run this first, every time, before pruning anything.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

require_deps
load_projects

echo "=== DDEV projects (protected allowlist) ==="
if [ "${#PROJECTS[@]}" -eq 0 ]; then
  echo "  (none found in \`ddev list\`)"
else
  printf '  %s\n' ${PROJECTS[@]+"${PROJECTS[@]}"}
fi
echo

echo "=== Docker disk usage ==="
echo "Note: with projects stopped, ACTIVE reads 0 and volumes show as"
echo "reclaimable. That is normal and does NOT mean the data is junk."
echo
docker system df
echo

echo "=== Volumes kept (map to a current project or a global) ==="
all_volumes | while IFS= read -r v; do keep_volume "$v" && echo "  $v"; done
echo

echo "=== Orphaned volumes (not tied to any current project) ==="
orphans="$(orphan_volumes || true)"
if [ -z "$orphans" ]; then
  echo "  (none)"
else
  printf '%s\n' "$orphans" | sed 's/^/  /'
fi
echo

echo "Read-only report complete. Nothing was changed."
echo "Next: scripts/prune.sh        (dry run, shows what would go)"
echo "Then: scripts/prune.sh --apply (after you review the list)"
