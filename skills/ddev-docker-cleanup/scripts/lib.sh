# lib.sh - shared helpers for the ddev-docker-cleanup skill.
# Sourced by report.sh and prune.sh. Not meant to run on its own.
#
# The core safety idea: a DDEV project's database lives in a Docker volume,
# not in the project folder. So the only reliable allowlist of "volumes we
# must keep" is the set of projects currently in `ddev list`, plus the DDEV
# global volumes. Everything else is a leftover and safe to remove.

require_deps() {
  local c missing=0
  for c in docker ddev jq; do
    command -v "$c" >/dev/null 2>&1 || { echo "Missing dependency: $c" >&2; missing=1; }
  done
  if [ "$missing" -ne 0 ]; then
    echo "Install the missing tools and retry (jq: brew install jq)." >&2
    exit 1
  fi
}

# These scripts target bash 3.2, the system bash on macOS (/bin/bash, 3.2.57),
# not just bash 4+ from Homebrew. Two accommodations follow, both backward
# compatible so the scripts still run unmodified on bash 5:
#
#   1. The `mapfile` shim below. bash 3.2 has no `mapfile` builtin.
#   2. `${ARR[@]+"${ARR[@]}"}` wherever an array is expanded. Under `set -u`,
#      bash 3.2 treats "${ARR[@]}" on an *empty* array as an unbound variable
#      and aborts. The `+` form expands to nothing instead. Do not "simplify"
#      those to "${ARR[@]}" — it breaks only on macOS system bash, and only
#      when the array is empty, which is the no-projects-found path.
#
# The shim covers the only usage here: `mapfile -t VAR < <(...)`.
if ! type mapfile >/dev/null 2>&1; then
  mapfile() {
    local __var="" __line
    while [ $# -gt 0 ]; do
      case "$1" in
        -t) shift ;;
        *)  __var="$1"; shift ;;
      esac
    done
    eval "$__var=()"
    while IFS= read -r __line; do
      eval "$__var+=(\"\$__line\")"
    done
  }
fi

# Populates the global PROJECTS array from `ddev list`.
PROJECTS=()
load_projects() {
  mapfile -t PROJECTS < <(ddev list -j | jq -r '(.raw // [])[].name' | sort -u)
}

# keep_volume NAME -> exit 0 if the volume belongs to a current project or is
# a DDEV global. Separator handling matters: project "smalley" must NOT
# protect "smalley-tw30090415" (a different, untracked project). We match the
# database and mutagen names exactly, and only the "ddev-<name>_" add-on
# prefix (underscore right after the name), so clones and worktrees still get
# caught.
keep_volume() {
  local vol="$1" p
  case "$vol" in
    ddev-global-cache|ddev-ssh-agent_*|ddev-ssh-agent-*) return 0 ;;
  esac
  for p in ${PROJECTS[@]+"${PROJECTS[@]}"}; do
    case "$vol" in
      "${p}-mariadb"|"${p}-postgres"|"${p}-mysql") return 0 ;;  # database
      "${p}_project_mutagen")                      return 0 ;;  # mutagen sync
      "ddev-${p}-snapshots")                       return 0 ;;  # db snapshots
      "ddev-${p}_"*)                               return 0 ;;  # add-ons (redis, solr, etc.)
    esac
  done
  return 1
}

all_volumes() { docker volume ls --format '{{.Name}}' | sort; }

# Prints, one per line, every volume that is NOT protected.
orphan_volumes() {
  local vol
  while IFS= read -r vol; do
    [ -z "$vol" ] && continue
    keep_volume "$vol" || printf '%s\n' "$vol"
  done < <(all_volumes)
}
