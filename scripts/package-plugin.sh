#!/usr/bin/env bash
# Package the entire plugin as dist/cms-cultivator.zip, ready to upload
# to Claude Desktop's "Add plugin" UI (covers the Claude Code surface
# inside Desktop). The zip contains a top-level cms-cultivator/ directory
# with the plugin manifest, agents, skills, Codex artifacts, and
# supporting docs needed at runtime.
#
# Uses `git archive` so only tracked files are included — no build
# artifacts, no .git/, no node_modules, no dist/, no site/.
#
# Usage:
#   ./scripts/package-plugin.sh             # archive HEAD
#   ./scripts/package-plugin.sh <ref>       # archive a specific ref/tag/SHA

set -euo pipefail

cd "$(dirname "$0")/.."

REF="${1:-HEAD}"
OUTPUT="dist/cms-cultivator.zip"

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is required." >&2
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: not inside a git repository." >&2
  exit 1
fi

if ! git rev-parse --verify "$REF" >/dev/null 2>&1; then
  echo "Error: '$REF' is not a valid git ref." >&2
  exit 1
fi

mkdir -p dist
rm -f "$OUTPUT"

# Include only the paths the plugin needs at runtime. Excludes internal
# tooling (.beads, scripts, tests), CI config (.github, .gitattributes),
# docs site source (docs, zensical.toml), and local state (.claude).
git archive \
  --format=zip \
  --prefix=cms-cultivator/ \
  -o "$OUTPUT" \
  "$REF" \
  -- \
  .claude-plugin \
  .codex-plugin \
  .codex \
  agents \
  skills \
  AGENTS.md \
  CHANGELOG.md \
  CLAUDE.md \
  LICENSE.md \
  README.md

size=$(ls -l "$OUTPUT" | awk '{print $5}')
files=$(unzip -l "$OUTPUT" | tail -1 | awk '{print $2}')

echo "✓ $OUTPUT"
echo "  ref:   $REF ($(git rev-parse --short "$REF"))"
echo "  size:  $size bytes"
echo "  files: $files"
echo ""
echo "Upload via Claude Desktop's plugin UI to enable the plugin in the"
echo "Claude Code surface inside Desktop."
