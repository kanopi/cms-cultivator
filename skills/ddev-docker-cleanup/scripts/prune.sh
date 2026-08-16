#!/usr/bin/env bash
# prune.sh - remove ONLY safe DDEV/Docker artifacts. Dry run unless --apply.
#
# Passes (all three run by default; name one or more to scope):
#   volumes  orphaned volumes not tied to any current DDEV project
#   cache    docker build cache (rebuildable)
#   images   dangling images only, via docker image prune -f (re-pulled later)
#
# Flags:
#   --apply       actually make changes (default: dry run, changes nothing)
#   --poweroff    run `ddev poweroff` first so nothing is attached
#   --volumes     include only the volumes pass (combine with others)
#   --images      include only the images pass
#   --cache       include only the cache pass
#   --help
#
# This script never runs `docker volume prune`, `docker system prune --volumes`,
# or `docker image prune -a`, because those would delete current project
# databases or force a full image re-pull. Volume removal is limited to the
# orphan list built from the `ddev list` allowlist.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib.sh
. "$DIR/lib.sh"

APPLY=0; POWEROFF=0; DO_VOL=0; DO_IMG=0; DO_CACHE=0; PICKED=0
for a in "$@"; do
  case "$a" in
    --apply|-f) APPLY=1 ;;
    --poweroff) POWEROFF=1 ;;
    --volumes)  DO_VOL=1; PICKED=1 ;;
    --images)   DO_IMG=1; PICKED=1 ;;
    --cache)    DO_CACHE=1; PICKED=1 ;;
    --help|-h)  grep '^#' "$0" | sed 's/^#\{1,\} \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $a (try --help)" >&2; exit 1 ;;
  esac
done
if [ "$PICKED" -eq 0 ]; then DO_VOL=1; DO_IMG=1; DO_CACHE=1; fi

require_deps

MODE="DRY RUN"; [ "$APPLY" -eq 1 ] && MODE="APPLY"
echo "Mode: $MODE"
echo

if [ "$POWEROFF" -eq 1 ]; then
  if [ "$APPLY" -eq 1 ]; then
    echo "Powering off DDEV..."
    ddev poweroff || true
  else
    echo "[dry run] would run: ddev poweroff"
  fi
  echo
fi

load_projects
if [ "$DO_VOL" -eq 1 ] && [ "${#PROJECTS[@]}" -eq 0 ]; then
  echo "No DDEV projects found in \`ddev list\`." >&2
  echo "Refusing to prune volumes with an empty allowlist (that would target every volume)." >&2
  DO_VOL=0
fi

if [ "$DO_VOL" -eq 1 ]; then
  echo "=== Orphaned volumes ==="
  mapfile -t ORPH < <(orphan_volumes || true)
  if [ "${#ORPH[@]}" -eq 0 ]; then
    echo "  (none)"
  else
    printf '  %s\n' ${ORPH[@]+"${ORPH[@]}"}
    if [ "$APPLY" -eq 1 ]; then
      echo "Removing ${#ORPH[@]} volume(s)..."
      docker volume rm ${ORPH[@]+"${ORPH[@]}"}
    else
      echo "[dry run] would remove ${#ORPH[@]} volume(s)."
    fi
  fi
  echo
fi

if [ "$DO_CACHE" -eq 1 ]; then
  echo "=== Build cache ==="
  if [ "$APPLY" -eq 1 ]; then
    docker builder prune -af
  else
    echo "[dry run] would run: docker builder prune -af"
  fi
  echo
fi

if [ "$DO_IMG" -eq 1 ]; then
  echo "=== Dangling images ==="
  if [ "$APPLY" -eq 1 ]; then
    docker image prune -f
  else
    n="$(docker images -f dangling=true -q | wc -l | tr -d ' ')"
    echo "[dry run] would run: docker image prune -f  (${n} dangling image(s))"
  fi
  echo
fi

echo "Done ($MODE)."
if [ "$APPLY" -eq 1 ]; then
  echo
  echo "Post-cleanup usage:"
  docker system df
fi
