#!/usr/bin/env bash
#
# Behavioral eval harness — runs side-effect skills headlessly through the
# `claude` CLI inside disposable fixture repos and grades the machine-readable
# trace against per-case expectations (evals/cases/*.json).
#
# Usage:
#   ./scripts/run-behavioral-evals.sh              # run all cases
#   ./scripts/run-behavioral-evals.sh --smoke      # run the smoke subset
#   ./scripts/run-behavioral-evals.sh --case NAME  # run one case by name
#   ./scripts/run-behavioral-evals.sh --list       # list cases and exit
#   ./scripts/run-behavioral-evals.sh --check      # static validation only
#                                                  # (no API calls; used by bats)
#   ./scripts/run-behavioral-evals.sh --keep-tmp   # preserve fixture dirs
#
# Requirements: authenticated `claude` CLI, python3, git.
# See evals/cases/README.md for the case schema and safety model.
#
# Cost guards (static, per the harness design decisions):
#   - default model: haiku (BEHAVIORAL_EVALS_MODEL to override globally,
#     per-case "model" field for skills whose gate behavior is model-sensitive)
#   - max_turns <= 20 per case; the CLI has no turn-cap flag, so the cap is
#     graded post-hoc from the trace's num_turns and a hard per-case dollar
#     cap (--max-budget-usd) bounds the run itself
#   - smoke subset capped at 10 cases
#   - per-run tally printed for every case (turns + cost)

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CASES_DIR="$REPO_ROOT/evals/cases"
FIXTURES_DIR="$REPO_ROOT/evals/fixtures"

DEFAULT_MODEL="${BEHAVIORAL_EVALS_MODEL:-claude-haiku-4-5}"
MAX_BUDGET_USD="${BEHAVIORAL_EVALS_MAX_BUDGET_USD:-1.00}"
# Reality note: one agentic tool round = one turn, and a real side-effect
# skill's mandated pre-flight (status, branch, log, diff...) is 5-8 rounds
# on its own — more when the workflow includes a search (e.g. looking for a
# test suite). 20 is the hard ceiling; cases should set the tightest value
# that fits their skill's workflow (the example cases run at 3).
MAX_TURNS_CEILING=20
SMOKE_CAP=10

# Safety is structural, not hopeful: the base allowlist is read-only plus the
# Skill tool; fixtures have no git remote. Gate cases are graded on the
# *attempt* visible in the trace, so a blocked tool doesn't blunt the test.
BASE_ALLOWED_TOOLS="Read,Grep,Glob,Skill,Bash(git status:*),Bash(git diff:*),Bash(git log:*),Bash(git branch:*),Bash(git show:*),Bash(git describe:*),Bash(git remote -v),Bash(ls:*)"
# Case-level allowed_tools_extra entries matching this pattern are rejected
# outright — never gh, never network, never subagents, never MCP.
FORBIDDEN_EXTRA_RE='gh|curl|wget|WebFetch|WebSearch|Task|Workflow|Agent|mcp__|push'

MODE="all"
ONLY_CASE=""
KEEP_TMP=0

while [ $# -gt 0 ]; do
  case "$1" in
    --smoke) MODE="smoke" ;;
    --case) MODE="one"; ONLY_CASE="${2:?--case requires a name}"; shift ;;
    --list) MODE="list" ;;
    --check) MODE="check" ;;
    --keep-tmp) KEEP_TMP=1 ;;
    -h|--help) sed -n '2,26p' "$0"; exit 0 ;;
    *) echo "Unknown argument: $1" >&2; exit 2 ;;
  esac
  shift
done

if [ ! -d "$CASES_DIR" ]; then
  echo "No evals/cases/ directory — nothing to do."
  exit 0
fi

CASE_FILES=()
while IFS= read -r f; do CASE_FILES+=("$f"); done \
  < <(find "$CASES_DIR" -maxdepth 1 -name '*.json' | sort)

if [ "${#CASE_FILES[@]}" -eq 0 ]; then
  echo "No case files in evals/cases/ — nothing to do."
  exit 0
fi

# ---------------------------------------------------------------------------
# Static validation (runs in every mode; the whole job in --check mode).
# Validates: JSON parses, name matches filename, fixture exists, expectation
# types are known, max_turns <= ceiling, extras pass the deny pattern, smoke
# subset within cap.
# ---------------------------------------------------------------------------
static_check() {
  python3 - "$FIXTURES_DIR" "$MAX_TURNS_CEILING" "$SMOKE_CAP" "$FORBIDDEN_EXTRA_RE" "$REPO_ROOT/skills" "${CASE_FILES[@]}" <<'PY'
import json, os, re, sys

fixtures_dir, ceiling, smoke_cap, forbidden_re = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), sys.argv[4]
skills_dir = sys.argv[5]
case_files = sys.argv[6:]
KNOWN_TYPES = {"tool_called", "tool_not_called", "output_matches",
               "output_not_matches", "file_created", "file_not_created",
               "file_matches"}
errors, names, smoke_count = [], set(), 0

for path in case_files:
    fname = os.path.basename(path)
    try:
        case = json.load(open(path))
    except json.JSONDecodeError as e:
        errors.append(f"{fname}: invalid JSON ({e})")
        continue
    name = case.get("name", "")
    if name != fname[:-5]:
        errors.append(f"{fname}: name {name!r} does not match filename")
    if name in names:
        errors.append(f"{fname}: duplicate case name {name!r}")
    names.add(name)
    for field in ("skill", "fixture", "prompt"):
        if not case.get(field):
            errors.append(f"{fname}: missing required field {field!r}")
    fixture = case.get("fixture", "")
    if fixture and not os.path.isdir(os.path.join(fixtures_dir, fixture)):
        errors.append(f"{fname}: fixture {fixture!r} not found in evals/fixtures/")
    skill = case.get("skill", "")
    if skill and not os.path.isdir(os.path.join(skills_dir, skill)):
        errors.append(f"{fname}: skill {skill!r} not found in skills/")
    max_turns = case.get("max_turns", ceiling)
    if not isinstance(max_turns, int) or max_turns < 1 or max_turns > ceiling:
        errors.append(f"{fname}: max_turns must be an integer 1..{ceiling}")
    if case.get("invocation", "slash") not in ("slash", "natural"):
        errors.append(f"{fname}: invocation must be 'slash' or 'natural'")
    post_check = case.get("post_check")
    if post_check is not None and (not isinstance(post_check, str) or not post_check.strip()):
        errors.append(f"{fname}: post_check must be a non-empty string when present")
    if case.get("smoke"):
        smoke_count += 1
    for extra in case.get("allowed_tools_extra", []):
        if re.search(forbidden_re, extra):
            errors.append(f"{fname}: forbidden allowed_tools_extra entry {extra!r}")
    exps = case.get("expectations", [])
    if not exps:
        errors.append(f"{fname}: no expectations")
    # pattern is a regex for these types; for file_created/file_not_created
    # it is a glob (and file_matches' path is a glob) — never regex-compiled.
    REGEX_TYPES = {"tool_called", "tool_not_called", "output_matches",
                   "output_not_matches", "file_matches"}
    for exp in exps:
        t = exp.get("type", "")
        if t not in KNOWN_TYPES:
            errors.append(f"{fname}: unknown expectation type {t!r}")
        if not exp.get("pattern"):
            errors.append(f"{fname}: expectation of type {t!r} missing pattern")
        if t == "file_matches" and not exp.get("path"):
            errors.append(f"{fname}: file_matches expectation missing path")
        if t in REGEX_TYPES and exp.get("pattern"):
            try:
                re.compile(exp["pattern"])
            except re.error as e:
                errors.append(f"{fname}: bad regex {exp['pattern']!r} ({e})")

if smoke_count > smoke_cap:
    errors.append(f"smoke subset has {smoke_count} cases; cap is {smoke_cap}")

for e in errors:
    print(f"CHECK FAIL: {e}", file=sys.stderr)
sys.exit(1 if errors else 0)
PY
}

echo "Validating ${#CASE_FILES[@]} case file(s)..."
static_check
echo "Static checks passed."

if [ "$MODE" = "check" ]; then
  exit 0
fi

if [ "$MODE" = "list" ]; then
  python3 - "${CASE_FILES[@]}" <<'PY'
import json, sys
for path in sys.argv[1:]:
    c = json.load(open(path))
    smoke = "smoke" if c.get("smoke") else "full"
    print(f"{c['name']}  (skill={c['skill']}, fixture={c['fixture']}, {smoke})")
PY
  exit 0
fi

command -v claude >/dev/null 2>&1 || { echo "claude CLI not found" >&2; exit 2; }

PLUGIN_NAME=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["name"])' "$REPO_ROOT/.claude-plugin/plugin.json")

# ---------------------------------------------------------------------------
# Per-case runner
# ---------------------------------------------------------------------------
PASS=0
FAIL=0
FAILED_CASES=()
TOTAL_COST="0"

run_case() {
  local case_file="$1"

  local case_name case_skill case_fixture case_prompt case_invocation case_model case_smoke extras
  case_name=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["name"])' "$case_file")
  case_skill=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["skill"])' "$case_file")
  case_fixture=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["fixture"])' "$case_file")
  case_prompt=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["prompt"])' "$case_file")
  case_invocation=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("invocation","slash"))' "$case_file")
  case_model=$(python3 -c 'import json,sys,os; print(json.load(open(sys.argv[1])).get("model") or os.environ.get("BEHAVIORAL_EVALS_MODEL") or sys.argv[2])' "$case_file" "$DEFAULT_MODEL")
  case_smoke=$(python3 -c 'import json,sys; print("1" if json.load(open(sys.argv[1])).get("smoke") else "0")' "$case_file")
  extras=$(python3 -c 'import json,sys; print(",".join(json.load(open(sys.argv[1])).get("allowed_tools_extra", [])))' "$case_file")

  if [ "$MODE" = "smoke" ] && [ "$case_smoke" != "1" ]; then return 0; fi
  if [ "$MODE" = "one" ] && [ "$case_name" != "$ONLY_CASE" ]; then return 0; fi

  local allowed="$BASE_ALLOWED_TOOLS"
  if [ -n "$extras" ]; then allowed="$allowed,$extras"; fi

  # Behavioral cases test what a skill DOES once active, not whether the
  # model routes to it (routing has its own eval). Default: invoke the skill
  # deterministically via its slash command. A case may set
  # "invocation": "natural" to send the raw prompt instead.
  local send_prompt="$case_prompt"
  if [ "$case_invocation" = "slash" ]; then
    send_prompt="/${PLUGIN_NAME}:${case_skill} ${case_prompt}"
  fi

  local tmp
  tmp=$(mktemp -d "${TMPDIR:-/tmp}/behavioral-eval.${case_name}.XXXXXX")
  cp -R "$FIXTURES_DIR/$case_fixture/." "$tmp/"
  if [ -f "$tmp/setup.sh" ]; then
    (cd "$tmp"; bash setup.sh)
  fi

  local trace="$tmp/.behavioral-eval-trace.jsonl"
  echo ""
  echo "=== $case_name (model=$case_model) ==="
  set +e
  (
    cd "$tmp"
    claude -p "$send_prompt" \
      --output-format stream-json \
      --verbose \
      --model "$case_model" \
      --setting-sources "" \
      --plugin-dir "$REPO_ROOT" \
      --allowedTools "$allowed" \
      --no-session-persistence \
      --max-budget-usd "$MAX_BUDGET_USD" \
      > "$trace" 2> "$tmp/.behavioral-eval-stderr.log"
  )
  local run_status=$?
  set -e
  if [ "$run_status" -ne 0 ]; then
    echo "claude exited non-zero ($run_status); stderr tail:"
    tail -n 5 "$tmp/.behavioral-eval-stderr.log" || true
  fi

  local grade_out grade_status
  set +e
  grade_out=$(grade_case "$case_file" "$trace" "$tmp")
  grade_status=$?
  set -e
  echo "$grade_out"

  # Optional post_check: a repo-authored command run inside the fixture copy
  # after grading (e.g. a schema validator over a file the skill wrote).
  # REPO_ROOT points at the plugin under test. Non-zero exit fails the case.
  local post_check
  post_check=$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1])).get("post_check") or "")' "$case_file")
  if [ -n "$post_check" ]; then
    set +e
    (
      cd "$tmp"
      REPO_ROOT="$REPO_ROOT" bash -c "$post_check"
    )
    local post_status=$?
    set -e
    if [ "$post_status" -ne 0 ]; then
      echo "  post_check failed (exit $post_status): $post_check"
      grade_status=1
    fi
  fi

  local case_cost
  case_cost=$(printf '%s\n' "$grade_out" | sed -n 's/.*cost_usd=\([0-9.]*\).*/\1/p' | head -n 1)
  if [ -n "$case_cost" ]; then
    TOTAL_COST=$(python3 -c 'import sys; print(f"{float(sys.argv[1]) + float(sys.argv[2]):.4f}")' "$TOTAL_COST" "$case_cost")
  fi

  if [ "$grade_status" -eq 0 ]; then
    echo "PASS $case_name"
    PASS=$((PASS + 1))
  else
    echo "FAIL $case_name (trace: $trace)"
    FAIL=$((FAIL + 1))
    FAILED_CASES+=("$case_name")
    KEEP_TMP=1  # always preserve failing fixtures for inspection
  fi

  if [ "$KEEP_TMP" -eq 0 ]; then
    rm -rf "$tmp"
  else
    echo "fixture preserved: $tmp"
  fi
}

grade_case() {
  python3 - "$1" "$2" "$3" <<'PY'
import glob as globmod
import json, os, re, sys

case = json.load(open(sys.argv[1]))
trace_path, fixture_dir = sys.argv[2], sys.argv[3]

events = []
try:
    with open(trace_path) as fh:
        for line in fh:
            line = line.strip()
            if not line:
                continue
            try:
                events.append(json.loads(line))
            except json.JSONDecodeError:
                pass
except FileNotFoundError:
    pass

tool_calls = []
final_text = ""
num_turns = None
cost = 0.0
is_error = False
for ev in events:
    if ev.get("type") == "assistant":
        for block in ev.get("message", {}).get("content", []) or []:
            if isinstance(block, dict) and block.get("type") == "tool_use":
                name = block.get("name", "")
                inp = block.get("input", {}) or {}
                if name == "Bash":
                    detail = inp.get("command", "")
                else:
                    detail = json.dumps(inp, sort_keys=True)
                tool_calls.append(f"{name} {detail}")
    elif ev.get("type") == "result":
        final_text = ev.get("result") or ""
        num_turns = ev.get("num_turns")
        cost = ev.get("total_cost_usd") or 0.0
        is_error = bool(ev.get("is_error"))

failures = []
if num_turns is None:
    failures.append("no result event in trace (run crashed, hung, or hit the budget cap)")
if is_error:
    failures.append("run ended in an error state")
max_turns = int(case.get("max_turns", 3))
if num_turns is not None and num_turns > max_turns:
    failures.append(f"turn cap exceeded: {num_turns} > {max_turns}")

# Grade every expectation even after a structural failure — a full failure
# list is worth more than a fast exit.
for exp in case.get("expectations", []):
    etype = exp.get("type", "")
    pattern = exp.get("pattern", "")
    path = exp.get("path", "")
    if etype == "tool_called":
        if not any(re.search(pattern, tc) for tc in tool_calls):
            failures.append(f"tool_called /{pattern}/ — no matching tool invocation")
    elif etype == "tool_not_called":
        hits = [tc for tc in tool_calls if re.search(pattern, tc)]
        if hits:
            failures.append(f"tool_not_called /{pattern}/ — matched: {hits[0][:160]}")
    elif etype == "output_matches":
        if not re.search(pattern, final_text, re.M):
            failures.append(f"output_matches /{pattern}/ — not found in final output")
    elif etype == "output_not_matches":
        m = re.search(pattern, final_text, re.M)
        if m:
            failures.append(f"output_not_matches /{pattern}/ — matched {m.group(0)!r}")
    elif etype == "file_created":
        if not globmod.glob(os.path.join(fixture_dir, pattern)):
            failures.append(f"file_created {pattern} — no file matches glob")
    elif etype == "file_not_created":
        hits = globmod.glob(os.path.join(fixture_dir, pattern))
        if hits:
            failures.append(f"file_not_created {pattern} — exists: {os.path.basename(hits[0])}")
    elif etype == "file_matches":
        hits = globmod.glob(os.path.join(fixture_dir, path))
        if not hits:
            failures.append(f"file_matches {path} — no file matches glob")
        else:
            content = open(hits[0]).read()
            if not re.search(pattern, content, re.M):
                failures.append(f"file_matches {path} /{pattern}/ — pattern not found")
    else:
        failures.append(f"unknown expectation type {etype!r}")

print(f"tally: turns={num_turns} cost_usd={cost:.4f} tool_calls={len(tool_calls)}")
for f in failures:
    print(f"  expectation failed: {f}")
sys.exit(1 if failures else 0)
PY
}

for f in "${CASE_FILES[@]}"; do
  run_case "$f"
done

RAN=$((PASS + FAIL))
if [ "$RAN" -eq 0 ]; then
  echo "No cases matched the requested filter." >&2
  exit 2
fi

echo ""
echo "=== behavioral evals: $PASS passed, $FAIL failed, $RAN run, total cost \$$TOTAL_COST ==="
if [ "$FAIL" -gt 0 ]; then
  printf 'failed: %s\n' "${FAILED_CASES[@]}"
  # A failing case is a skill bug — fix the skill (not the test) and
  # record it in CHANGELOG.md.
  exit 1
fi
