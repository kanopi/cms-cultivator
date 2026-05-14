#!/usr/bin/env bash
# Package each skill in skills/ as a .skill zip in dist/skills/, ready to
# upload to Claude Desktop's Chat or CoWork surfaces via the Skills UI.
#
# A .skill file is a zip containing <skill-name>/SKILL.md (and optionally
# <skill-name>/templates/...). This script produces one .skill per
# skills/<name>/ directory, plus a bundled cms-cultivator-skills.zip
# containing all of them.
#
# Usage:
#   ./scripts/package-skills.sh             # build all skills + bundle
#   ./scripts/package-skills.sh <name>      # build a single skill
#   ./scripts/package-skills.sh --list      # list skill names that would be built
#   ./scripts/package-skills.sh --no-bundle # build .skill files but skip the bundle

set -euo pipefail

cd "$(dirname "$0")/.."

DIST_DIR="dist/skills"
BUNDLE_PATH="dist/cms-cultivator-skills.zip"

BUILD_BUNDLE=1
TARGET=""

# Parse arguments
while [ $# -gt 0 ]; do
  case "$1" in
    --list)
      for skill_dir in skills/*/; do
        skill_name=$(basename "$skill_dir")
        [ -f "$skill_dir/SKILL.md" ] && echo "$skill_name"
      done
      exit 0
      ;;
    --no-bundle)
      BUILD_BUNDLE=0
      shift
      ;;
    -h|--help)
      sed -n '2,/^$/p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    --*)
      echo "Unknown flag: $1" >&2
      exit 1
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

# Sanity check
if [ ! -d "skills" ]; then
  echo "Error: skills/ directory not found. Run from the repo root." >&2
  exit 1
fi

# Clean our own output for full builds; preserve for single-skill builds.
# Don't wipe sibling outputs (e.g. cms-cultivator.zip from package-plugin.sh).
if [ -z "$TARGET" ]; then
  rm -rf "$DIST_DIR"
  rm -f "$BUNDLE_PATH"
fi
mkdir -p "$DIST_DIR"

count=0
for skill_dir in skills/*/; do
  skill_name=$(basename "$skill_dir")

  # Skip if filtering and no match
  if [ -n "$TARGET" ] && [ "$TARGET" != "$skill_name" ]; then
    continue
  fi

  # Skip directories without SKILL.md (e.g. README.md siblings)
  if [ ! -f "$skill_dir/SKILL.md" ]; then
    continue
  fi

  output="$(pwd)/$DIST_DIR/${skill_name}.skill"
  rm -f "$output"

  # Build .skill — zip contains <skill-name>/SKILL.md (+ templates/, etc.)
  # Exclude macOS .DS_Store and the Codex-specific openai.yaml policy files
  # (irrelevant to Claude Desktop).
  ( cd skills && zip -qr "$output" "$skill_name" \
      -x "*.DS_Store" \
      -x "$skill_name/agents/openai.yaml" )

  count=$((count + 1))
  printf "  %s → %s\n" "$skill_name" "$DIST_DIR/${skill_name}.skill"
done

if [ "$count" -eq 0 ]; then
  if [ -n "$TARGET" ]; then
    echo "Error: no skill named '$TARGET' found under skills/" >&2
    exit 1
  fi
  echo "Error: no skills with SKILL.md found under skills/" >&2
  exit 1
fi

# Build the bundle (single skill builds skip it)
if [ "$BUILD_BUNDLE" -eq 1 ] && [ -z "$TARGET" ]; then
  rm -f "$BUNDLE_PATH"
  ( cd "$DIST_DIR" && zip -qr "../$(basename "$BUNDLE_PATH")" . )
  echo ""
  echo "Bundle → $BUNDLE_PATH ($(ls -1 "$DIST_DIR"/*.skill | wc -l | tr -d ' ') skills)"
fi

echo ""
echo "Built $count skill(s) → $DIST_DIR/"
echo ""
echo "Next steps:"
echo "  • Upload each .skill to Claude Desktop via Settings → Skills"
echo "  • Or download .skill files from a tagged GitHub release:"
echo "    https://github.com/kanopi/cms-cultivator/releases/latest"
