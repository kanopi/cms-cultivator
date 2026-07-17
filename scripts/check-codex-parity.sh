#!/usr/bin/env bash
# Codex-parity validation: ensure OpenAI Codex translation artifacts don't
# drift from their Claude source of truth.
#
# Checks:
#   1. agents/<name>/ <-> .codex/agents/<name>.toml is a bijection
#   2. Each TOML's `name` matches its filename
#   3. Each TOML's `description` matches the AGENT.md frontmatter description
#      (whitespace-normalized)
#   4. Each TOML has `model` and `developer_instructions`
#   5. Each skills/*/agents/openai.yaml is valid YAML with
#      policy.allow_implicit_invocation
#
# Repos with no agents/ directory skip checks 1-4.

set -euo pipefail

cd "$(dirname "$0")/.."

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

errors=0

echo "🔁 Codex-parity validation"
echo "=========================================="

if [ -d "agents" ]; then
  # 1. Bijection: every agent dir has a TOML, every TOML has an agent dir
  for agent_dir in agents/*/; do
    [ -d "$agent_dir" ] || continue
    name=$(basename "$agent_dir")
    if [ ! -f ".codex/agents/${name}.toml" ]; then
      echo -e "  ${RED}✗${NC} agents/$name has no .codex/agents/${name}.toml"
      ((errors++)) || true
    fi
  done

  for toml in .codex/agents/*.toml; do
    [ -f "$toml" ] || continue
    name=$(basename "$toml" .toml)
    if [ ! -d "agents/$name" ]; then
      echo -e "  ${RED}✗${NC} $toml has no agents/$name/ directory"
      ((errors++)) || true
    fi
  done

  # 2-4. Field presence + name/description parity, via python (yaml + tomllib)
  for agent_dir in agents/*/; do
    [ -d "$agent_dir" ] || continue
    name=$(basename "$agent_dir")
    agent_md="agents/$name/AGENT.md"
    toml=".codex/agents/${name}.toml"
    [ -f "$agent_md" ] || continue
    [ -f "$toml" ] || continue

    echo -n "  Checking $name... "
    if output=$(python3 - "$agent_md" "$toml" "$name" <<'PYEOF'
import re
import sys

agent_md, toml_path, name = sys.argv[1], sys.argv[2], sys.argv[3]

# --- AGENT.md frontmatter description ---
with open(agent_md) as f:
    content = f.read()
lines = content.split("\n")
if lines[0] != "---":
    print("AGENT.md missing frontmatter")
    sys.exit(1)
fm_lines = []
for line in lines[1:]:
    if line == "---":
        break
    fm_lines.append(line)

try:
    import yaml
    fm = yaml.safe_load("\n".join(fm_lines)) or {}
    md_desc = str(fm.get("description", ""))
    md_name = str(fm.get("name", ""))
except ImportError:
    # Fallback: single-line description extraction
    md_desc = ""
    md_name = ""
    for i, line in enumerate(fm_lines):
        m = re.match(r"^description:\s*(.*)$", line)
        if m:
            parts = [m.group(1)] if m.group(1) else []
            for cont in fm_lines[i + 1:]:
                if re.match(r"^\s+\S", cont):
                    parts.append(cont.strip())
                else:
                    break
            md_desc = " ".join(parts)
        m = re.match(r"^name:\s*(.*)$", line)
        if m:
            md_name = m.group(1).strip()

# --- TOML fields ---
toml_desc = toml_name = None
has_model = has_dev = False
try:
    import tomllib
    with open(toml_path, "rb") as f:
        data = tomllib.load(f)
    toml_desc = str(data.get("description", ""))
    toml_name = str(data.get("name", ""))
    has_model = "model" in data
    has_dev = "developer_instructions" in data
except ImportError:
    with open(toml_path) as f:
        raw = f.read()
    m = re.search(r'^name = "(.*)"$', raw, re.M)
    toml_name = m.group(1) if m else ""
    m = re.search(r'^description = "(.*)"$', raw, re.M)
    toml_desc = m.group(1).replace('\\"', '"') if m else ""
    has_model = bool(re.search(r"^model = ", raw, re.M))
    has_dev = bool(re.search(r"^developer_instructions", raw, re.M))

def norm(s):
    return re.sub(r"\s+", " ", s or "").strip()

problems = []
if toml_name != name:
    problems.append(f"TOML name '{toml_name}' != filename '{name}'")
if md_name and md_name != name:
    problems.append(f"AGENT.md name '{md_name}' != directory '{name}'")
if not has_model:
    problems.append("TOML missing model field")
if not has_dev:
    problems.append("TOML missing developer_instructions")
if norm(md_desc) != norm(toml_desc):
    problems.append(
        "description drift between AGENT.md and TOML:\n"
        f"      AGENT.md: {norm(md_desc)[:120]}...\n"
        f"      TOML:     {norm(toml_desc)[:120]}..."
    )

if problems:
    for p in problems:
        print(p)
    sys.exit(1)
PYEOF
    ); then
      echo -e "${GREEN}✓${NC}"
    else
      echo -e "${RED}✗${NC}"
      echo "$output" | sed 's/^/      /'
      ((errors++)) || true
    fi
  done
else
  echo "  (no agents/ directory — skipping agent TOML parity)"
fi

# 5. openai.yaml policy files
for yaml_file in skills/*/agents/openai.yaml; do
  [ -f "$yaml_file" ] || continue
  skill=$(basename "$(dirname "$(dirname "$yaml_file")")")
  echo -n "  Checking $skill/agents/openai.yaml... "
  if ! python3 -c "import yaml, sys; yaml.safe_load(open(sys.argv[1]))" "$yaml_file" 2>/dev/null; then
    echo -e "${RED}✗${NC} invalid YAML"
    ((errors++)) || true
    continue
  fi
  if ! grep -q "allow_implicit_invocation:" "$yaml_file"; then
    echo -e "${RED}✗${NC} missing policy.allow_implicit_invocation"
    ((errors++)) || true
    continue
  fi
  echo -e "${GREEN}✓${NC}"
done

echo "=========================================="
if [ "$errors" -gt 0 ]; then
  echo -e "${RED}❌ Codex parity failed with $errors error(s)${NC}"
  exit 1
fi
echo -e "${GREEN}✅ Codex artifacts are in parity${NC}"
