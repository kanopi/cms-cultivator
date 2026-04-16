#!/usr/bin/env bats

# Test suite for CMS Cultivator Claude Code plugin
# Run with: bats tests/test-plugin.bats

setup() {
  # Set project root for all tests
  export PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
  cd "$PROJECT_ROOT"
}

# ==============================================================================
# PLUGIN MANIFEST TESTS
# ==============================================================================

@test "plugin manifest exists" {
  [ -f ".claude-plugin/plugin.json" ]
}

@test "plugin manifest is valid JSON" {
  run jq empty .claude-plugin/plugin.json
  [ "$status" -eq 0 ]
}

@test "plugin manifest has required fields" {
  run jq -e '.name' .claude-plugin/plugin.json
  [ "$status" -eq 0 ]

  run jq -e '.version' .claude-plugin/plugin.json
  [ "$status" -eq 0 ]

  run jq -e '.description' .claude-plugin/plugin.json
  [ "$status" -eq 0 ]
}

@test "plugin name is cms-cultivator" {
  run jq -r '.name' .claude-plugin/plugin.json
  [ "$output" = "cms-cultivator" ]
}

@test "plugin version follows semver" {
  version=$(jq -r '.version' .claude-plugin/plugin.json)
  [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

@test "plugin has repository URL" {
  run jq -e '.repository' .claude-plugin/plugin.json
  [ "$status" -eq 0 ]

  # Repository should be a string
  run jq -r '.repository | type' .claude-plugin/plugin.json
  [ "$output" = "string" ]
}

# ==============================================================================
# CODEX MANIFEST TESTS
# ==============================================================================

@test "codex plugin manifest exists" {
  [ -f ".codex-plugin/plugin.json" ]
}

@test "codex manifest is valid JSON" {
  run jq empty .codex-plugin/plugin.json
  [ "$status" -eq 0 ]
}

@test "codex manifest has required fields" {
  run jq -e '.name' .codex-plugin/plugin.json
  [ "$status" -eq 0 ]

  run jq -e '.version' .codex-plugin/plugin.json
  [ "$status" -eq 0 ]

  run jq -e '.skills' .codex-plugin/plugin.json
  [ "$status" -eq 0 ]
}

@test "codex manifest version is 1.0.0" {
  run jq -r '.version' .codex-plugin/plugin.json
  [ "$output" = "1.0.0" ]
}

# ==============================================================================
# SKILL STRUCTURE TESTS
# ==============================================================================

@test "skills directory exists" {
  [ -d "skills" ]
}

@test "skill count matches expected (38)" {
  count=$(find skills -mindepth 1 -maxdepth 1 -type d | wc -l)
  [ "$count" -eq 38 ]
}

@test "all skill directories have SKILL.md file" {
  for skill_dir in skills/*/; do
    if [ ! -f "${skill_dir}SKILL.md" ]; then
      echo "Missing SKILL.md in $skill_dir"
      return 1
    fi
  done
}

# ==============================================================================
# SKILL FRONTMATTER TESTS
# ==============================================================================

@test "all skill files have YAML frontmatter" {
  for skill in skills/*/SKILL.md; do
    if ! grep -q "^---$" "$skill"; then
      echo "Missing frontmatter in $skill"
      return 1
    fi
  done
}

@test "all skills have name in frontmatter" {
  for skill in skills/*/SKILL.md; do
    if ! grep -q "^name:" "$skill"; then
      echo "Missing name in $skill"
      return 1
    fi
  done
}

@test "all skills have description in frontmatter" {
  for skill in skills/*/SKILL.md; do
    if ! grep -q "^description:" "$skill"; then
      echo "Missing description in $skill"
      return 1
    fi
  done
}

# ==============================================================================
# OPENAI INVOCATION POLICY TESTS
# ==============================================================================

@test "skills with openai.yaml have valid YAML" {
  for yaml_file in skills/*/agents/openai.yaml; do
    if [ -f "$yaml_file" ]; then
      if command -v python3 &> /dev/null; then
        python3 -c "import yaml; yaml.safe_load(open('$yaml_file'))" 2>/dev/null || {
          echo "Invalid YAML in $yaml_file"
          return 1
        }
      else
        skip "No YAML validator available"
      fi
    fi
  done
}

@test "openai.yaml files have policy.allow_implicit_invocation field" {
  for yaml_file in skills/*/agents/openai.yaml; do
    if [ -f "$yaml_file" ]; then
      if ! grep -q "allow_implicit_invocation:" "$yaml_file"; then
        echo "Missing allow_implicit_invocation in $yaml_file"
        return 1
      fi
    fi
  done
}

# ==============================================================================
# AGENT DIRECTORY STRUCTURE TESTS
# ==============================================================================

@test "agents directory exists" {
  [ -d "agents" ]
}

@test "agents directory contains expected subdirectories" {
  count=$(find agents -mindepth 1 -maxdepth 1 -type d | wc -l)
  [ "$count" -eq 17 ]
}

@test "all agent directories have AGENT.md file" {
  for agent_dir in agents/*/; do
    if [ ! -f "${agent_dir}AGENT.md" ]; then
      echo "Missing AGENT.md in $agent_dir"
      return 1
    fi
  done
}

@test "agent count matches expected (17)" {
  count=$(find agents -mindepth 1 -maxdepth 1 -type d | wc -l)
  [ "$count" -eq 17 ]
}

@test "expected agent directories exist" {
  expected_agents=(
    "accessibility-specialist"
    "browser-validator-specialist"
    "code-quality-specialist"
    "design-specialist"
    "documentation-specialist"
    "drupalorg-issue-specialist"
    "drupal-pantheon-devops-specialist"
    "drupalorg-mr-specialist"
    "gtm-specialist"
    "live-audit-specialist"
    "performance-specialist"
    "responsive-styling-specialist"
    "security-specialist"
    "teamwork-specialist"
    "testing-specialist"
    "structured-data-specialist"
    "workflow-specialist"
  )

  for agent in "${expected_agents[@]}"; do
    if [ ! -d "agents/$agent" ]; then
      echo "Missing agent directory: agents/$agent"
      return 1
    fi
  done
}

# ==============================================================================
# AGENT FRONTMATTER TESTS
# ==============================================================================

@test "all agent files have YAML frontmatter" {
  for agent in agents/*/AGENT.md; do
    if ! grep -q "^---$" "$agent"; then
      echo "Missing frontmatter in $agent"
      return 1
    fi
  done
}

@test "all agents have name in frontmatter" {
  for agent in agents/*/AGENT.md; do
    if ! grep -q "^name:" "$agent"; then
      echo "Missing name in $agent"
      return 1
    fi
  done
}

@test "all agents have description in frontmatter" {
  for agent in agents/*/AGENT.md; do
    if ! grep -q "^description:" "$agent"; then
      echo "Missing description in $agent"
      return 1
    fi
  done
}

@test "all agents have tools in frontmatter" {
  for agent in agents/*/AGENT.md; do
    if ! grep -q "^tools:" "$agent"; then
      echo "Missing tools in $agent"
      return 1
    fi
  done
}

@test "all agents have skills in frontmatter" {
  for agent in agents/*/AGENT.md; do
    if ! grep -q "^skills:" "$agent"; then
      echo "Missing skills in $agent"
      return 1
    fi
  done
}

@test "all agents have model in frontmatter" {
  for agent in agents/*/AGENT.md; do
    if ! grep -q "^model:" "$agent"; then
      echo "Missing model in $agent"
      return 1
    fi
  done
}

@test "agent frontmatter has valid YAML syntax" {
  for agent in agents/*/AGENT.md; do
    frontmatter=$(awk 'BEGIN {state=0} /^---$/ {state++; next} state==1 {print} state==2 {exit}' "$agent")

    if command -v python3 &> /dev/null; then
      echo "$frontmatter" | python3 -c "import sys, yaml; yaml.safe_load(sys.stdin)" &> /dev/null || {
        echo "Invalid YAML in $agent"
        return 1
      }
    else
      skip "No YAML validator available"
    fi
  done
}

@test "agent names match directory names" {
  for agent_dir in agents/*/; do
    dir_name=$(basename "$agent_dir")
    agent_file="${agent_dir}AGENT.md"

    if [ -f "$agent_file" ]; then
      agent_name=$(sed -n 's/^name: *//p' "$agent_file")
      if [ "$agent_name" != "$dir_name" ]; then
        echo "Name mismatch in $agent_file: name=$agent_name, dir=$dir_name"
        return 1
      fi
    fi
  done
}

# ==============================================================================
# AGENT SKILLS MAPPING TESTS
# ==============================================================================

@test "leaf specialists do not have Task tool" {
  leaf_specialists=(
    "accessibility-specialist"
    "browser-validator-specialist"
    "code-quality-specialist"
    "documentation-specialist"
    "drupal-pantheon-devops-specialist"
    "gtm-specialist"
    "performance-specialist"
    "responsive-styling-specialist"
    "security-specialist"
    "structured-data-specialist"
  )

  for agent in "${leaf_specialists[@]}"; do
    agent_file="agents/$agent/AGENT.md"
    tools=$(sed -n 's/^tools: *//p' "$agent_file")

    if echo "$tools" | grep -q "Task"; then
      echo "Leaf specialist $agent should not have Task tool"
      return 1
    fi
  done
}

@test "orchestrators have Task tool" {
  orchestrators=(
    "design-specialist"
    "live-audit-specialist"
    "testing-specialist"
    "workflow-specialist"
  )

  for agent in "${orchestrators[@]}"; do
    agent_file="agents/$agent/AGENT.md"
    tools=$(sed -n 's/^tools: *//p' "$agent_file")

    if ! echo "$tools" | grep -q "Task"; then
      echo "Orchestrator $agent must have Task tool"
      return 1
    fi
  done
}

@test "live-audit-specialist has strategic-thinking and audit-report skills" {
  agent_file="agents/live-audit-specialist/AGENT.md"
  if ! grep -q "strategic-thinking" "$agent_file"; then
    echo "live-audit-specialist missing strategic-thinking skill"
    return 1
  fi
  if ! grep -q "audit-report" "$agent_file"; then
    echo "live-audit-specialist missing audit-report skill"
    return 1
  fi
}

@test "accessibility-specialist has accessibility-checker skill" {
  agent_file="agents/accessibility-specialist/AGENT.md"
  if ! grep -q "accessibility-checker" "$agent_file"; then
    echo "accessibility-specialist missing accessibility-checker skill"
    return 1
  fi
}

@test "accessibility-specialist has accessibility-audit skill" {
  agent_file="agents/accessibility-specialist/AGENT.md"
  if ! grep -q "accessibility-audit" "$agent_file"; then
    echo "accessibility-specialist missing accessibility-audit skill"
    return 1
  fi
}

@test "workflow-specialist has commit-message-generator skill" {
  agent_file="agents/workflow-specialist/AGENT.md"
  if ! grep -q "commit-message-generator" "$agent_file"; then
    echo "workflow-specialist missing commit-message-generator skill"
    return 1
  fi
}

@test "workflow-specialist has pr-create skill" {
  agent_file="agents/workflow-specialist/AGENT.md"
  if ! grep -q "pr-create" "$agent_file"; then
    echo "workflow-specialist missing pr-create skill"
    return 1
  fi
}

@test "design-specialist has design-analyzer skill" {
  agent_file="agents/design-specialist/AGENT.md"
  if ! grep -q "design-analyzer" "$agent_file"; then
    echo "design-specialist missing design-analyzer skill"
    return 1
  fi
}

@test "design-specialist has design-to-wp-block skill" {
  agent_file="agents/design-specialist/AGENT.md"
  if ! grep -q "design-to-wp-block" "$agent_file"; then
    echo "design-specialist missing design-to-wp-block skill"
    return 1
  fi
}

@test "browser-validator-specialist has browser-validator skill" {
  agent_file="agents/browser-validator-specialist/AGENT.md"
  if ! grep -q "browser-validator" "$agent_file"; then
    echo "browser-validator-specialist missing browser-validator skill"
    return 1
  fi
}

@test "responsive-styling-specialist has responsive-styling skill" {
  agent_file="agents/responsive-styling-specialist/AGENT.md"
  if ! grep -q "responsive-styling" "$agent_file"; then
    echo "responsive-styling-specialist missing responsive-styling skill"
    return 1
  fi
}

@test "gtm-specialist has gtm-performance-audit skill" {
  agent_file="agents/gtm-specialist/AGENT.md"
  if ! grep -q "gtm-performance-audit" "$agent_file"; then
    echo "gtm-specialist missing gtm-performance-audit skill"
    return 1
  fi
}

@test "drupalorg-issue-specialist model is haiku" {
  agent_file="agents/drupalorg-issue-specialist/AGENT.md"
  model=$(sed -n 's/^model: *//p' "$agent_file")
  if [ "$model" != "haiku" ]; then
    echo "drupalorg-issue-specialist model should be haiku, got: $model"
    return 1
  fi
}

# ==============================================================================
# AGENT CONTENT TESTS
# ==============================================================================

@test "all agents have markdown headers" {
  for agent in agents/*/AGENT.md; do
    if ! grep -q "^#" "$agent"; then
      echo "No markdown headers in $agent"
      return 1
    fi
  done
}

@test "all agents have Core Responsibilities section" {
  for agent in agents/*/AGENT.md; do
    if ! grep -qi "Core Responsibilities" "$agent"; then
      echo "Missing Core Responsibilities section in $agent"
      return 1
    fi
  done
}

@test "all agents document their tools" {
  for agent in agents/*/AGENT.md; do
    if ! grep -qi "Tools Available\|Tools You" "$agent"; then
      echo "Missing tools documentation in $agent"
      return 1
    fi
  done
}

@test "orchestrators document delegation patterns" {
  orchestrators=(
    "design-specialist"
    "live-audit-specialist"
    "testing-specialist"
    "workflow-specialist"
  )

  for agent in "${orchestrators[@]}"; do
    agent_file="agents/$agent/AGENT.md"

    if ! grep -qi "orchestrat\|delegat\|spawn" "$agent_file"; then
      echo "Orchestrator $agent missing delegation documentation"
      return 1
    fi
  done
}

@test "no agent file exceeds reasonable size (200KB)" {
  for agent in agents/*/AGENT.md; do
    size=$(wc -c < "$agent")
    if [ "$size" -gt 204800 ]; then
      echo "Agent file $agent is too large: ${size} bytes"
      return 1
    fi
  done
}

# ==============================================================================
# STRUCTURED DATA SPECIALIST TESTS
# ==============================================================================

@test "structured-data-specialist has structured-data-analyzer skill" {
  agent_file="agents/structured-data-specialist/AGENT.md"
  if ! grep -q "structured-data-analyzer" "$agent_file"; then
    echo "structured-data-specialist missing structured-data-analyzer skill"
    return 1
  fi
}

@test "structured-data-specialist has chrome-devtools MCP tools" {
  agent_file="agents/structured-data-specialist/AGENT.md"
  tools=$(sed -n 's/^tools: *//p' "$agent_file")
  if ! echo "$tools" | grep -q "chrome-devtools MCP"; then
    echo "structured-data-specialist should have chrome-devtools MCP tools"
    return 1
  fi
}

@test "structured-data-analyzer skill exists" {
  [ -f "skills/structured-data-analyzer/SKILL.md" ]
}

# ==============================================================================
# DOCUMENTATION TESTS
# ==============================================================================

@test "README.md exists" {
  [ -f "README.md" ]
}

@test "README has documentation badge" {
  grep -q "docs-zensical" README.md
}

@test "README links to documentation site" {
  grep -q "kanopi.github.io/cms-cultivator" README.md
}

@test "zensical.toml exists" {
  [ -f "zensical.toml" ]
}

@test "zensical.toml is valid TOML" {
  # Verify the file exists and is readable
  if [ -f "zensical.toml" ] && [ -r "zensical.toml" ]; then
    # Basic syntax check - ensure it has required keys
    if grep -q "site_name" zensical.toml && grep -q "docs_dir" zensical.toml; then
      return 0
    else
      echo "zensical.toml missing required fields"
      return 1
    fi
  else
    echo "zensical.toml not found or not readable"
    return 1
  fi
}

@test "docs directory exists" {
  [ -d "docs" ]
}

@test "docs/index.md exists" {
  [ -f "docs/index.md" ]
}

@test "all zensical nav pages exist" {
  # Extract file paths from nav section in zensical.toml
  # Parse TOML nav array and check each .md file exists
  nav_files=$(grep -E '\.md"' zensical.toml | sed 's/.*"\(.*\.md\)".*/\1/' | grep -v '^\s*#')

  for file in $nav_files; do
    if [ ! -f "docs/$file" ]; then
      echo "Missing nav file: docs/$file"
      return 1
    fi
  done
}

@test "GitHub Actions workflow exists" {
  [ -f ".github/workflows/docs.yml" ]
}

@test "GitHub Actions workflow is valid YAML" {
  if command -v yq &> /dev/null; then
    run yq eval .github/workflows/docs.yml
    [ "$status" -eq 0 ]
  elif command -v python3 &> /dev/null; then
    run python3 -c "import yaml; yaml.safe_load(open('.github/workflows/docs.yml'))"
    [ "$status" -eq 0 ]
  else
    skip "No YAML validator available"
  fi
}

# ==============================================================================
# KANOPI INTEGRATION TESTS
# ==============================================================================

@test "Kanopi tools documentation exists" {
  # Kanopi tools are documented in docs/kanopi-tools/ directory
  [ -d "docs/kanopi-tools" ] && [ -f "docs/kanopi-tools/overview.md" ]
}

@test "Kanopi tools documented in docs" {
  [ -f "docs/kanopi-tools/overview.md" ]
}

# ==============================================================================
# LICENSE AND METADATA TESTS
# ==============================================================================

@test "LICENSE file exists" {
  [ -f "LICENSE" ] || [ -f "LICENSE.md" ] || [ -f "LICENSE.txt" ]
}

@test "CHANGELOG.md exists" {
  [ -f "CHANGELOG.md" ]
}

@test "CLAUDE.md exists for AI context" {
  [ -f "CLAUDE.md" ]
}

# ==============================================================================
# FILE HYGIENE TESTS
# ==============================================================================

@test "no uncommitted merge conflict markers" {
  if grep -r "^<<<<<<< \|^=======$\|^>>>>>>> " skills/ docs/ agents/ 2>/dev/null; then
    echo "Found merge conflict markers"
    return 1
  fi
}

# ==============================================================================
# DRUPAL.ORG INTEGRATION STRUCTURE TESTS
# ==============================================================================

@test "drupalorg agents exist" {
  [ -f "agents/drupalorg-issue-specialist/AGENT.md" ]
  [ -f "agents/drupalorg-mr-specialist/AGENT.md" ]
}

@test "drupalorg skills exist" {
  [ -f "skills/drupalorg-issue-helper/SKILL.md" ]
  [ -f "skills/drupalorg-contribution-helper/SKILL.md" ]
}

@test "drupalorg agents do NOT have chrome-devtools MCP in tools (guided manual workflow)" {
  # drupalorg agents use guided manual workflow (clipboard + browser launch)
  # instead of browser automation due to drupal.org CAPTCHA protection
  for agent in agents/drupalorg-*/AGENT.md; do
    tools=$(sed -n 's/^tools: *//p' "$agent")
    if echo "$tools" | grep -q "chrome-devtools MCP"; then
      echo "drupalorg agent $agent should NOT have chrome-devtools MCP (use guided manual workflow)"
      return 1
    fi
  done
}

@test "drupalorg agents reference correct skills" {
  # Issue specialist should reference drupalorg-issue-helper
  if ! grep -q "drupalorg-issue-helper" agents/drupalorg-issue-specialist/AGENT.md; then
    echo "drupalorg-issue-specialist missing drupalorg-issue-helper skill"
    return 1
  fi

  # MR specialist should reference drupalorg-contribution-helper
  if ! grep -q "drupalorg-contribution-helper" agents/drupalorg-mr-specialist/AGENT.md; then
    echo "drupalorg-mr-specialist missing drupalorg-contribution-helper skill"
    return 1
  fi
}

@test "drupalorg agents are leaf specialists (no Task tool)" {
  for agent in agents/drupalorg-*/AGENT.md; do
    tools=$(sed -n 's/^tools: *//p' "$agent")
    if echo "$tools" | grep -q "Task"; then
      echo "drupalorg agent $agent should not have Task tool (leaf specialist)"
      return 1
    fi
  done
}

@test "drupal documentation exists" {
  [ -f "docs/drupal-contribution.md" ]
}

# ==============================================================================
# CLAUDE CODE INVOCATION POLICY TESTS
# ==============================================================================

@test "skills with openai.yaml also have disable-model-invocation in SKILL.md" {
  for yaml_file in skills/*/agents/openai.yaml; do
    [ -f "$yaml_file" ] || continue
    skill_dir=$(basename "$(dirname "$(dirname "$yaml_file")")")
    skill_file="skills/$skill_dir/SKILL.md"
    if ! grep -q "^disable-model-invocation: true" "$skill_file"; then
      echo "$skill_file has openai.yaml but missing disable-model-invocation: true"
      return 1
    fi
  done
}

# ==============================================================================
# CODEX TOML AGENT TESTS
# ==============================================================================

@test "codex agents directory exists" {
  [ -d ".codex/agents" ]
}

@test "codex agent TOML count matches AGENT.md count (17)" {
  toml_count=$(find .codex/agents -name "*.toml" | wc -l)
  [ "$toml_count" -eq 17 ]
}

@test "every AGENT.md directory has a corresponding TOML agent" {
  for agent_dir in agents/*/; do
    agent_name=$(basename "$agent_dir")
    if [ ! -f ".codex/agents/${agent_name}.toml" ]; then
      echo "Missing TOML for agent: $agent_name"
      return 1
    fi
  done
}

@test "every TOML agent has a corresponding AGENT.md directory" {
  for toml_file in .codex/agents/*.toml; do
    agent_name=$(basename "$toml_file" .toml)
    if [ ! -d "agents/$agent_name" ]; then
      echo "TOML $toml_file has no matching agents/$agent_name/ directory"
      return 1
    fi
  done
}

@test "all TOML agents have required name field" {
  for toml_file in .codex/agents/*.toml; do
    if ! grep -q "^name = " "$toml_file"; then
      echo "Missing name field in $toml_file"
      return 1
    fi
  done
}

@test "all TOML agents have required description field" {
  for toml_file in .codex/agents/*.toml; do
    if ! grep -q "^description = " "$toml_file"; then
      echo "Missing description in $toml_file"
      return 1
    fi
  done
}

@test "all TOML agents have developer_instructions field" {
  for toml_file in .codex/agents/*.toml; do
    if ! grep -q "^developer_instructions" "$toml_file"; then
      echo "Missing developer_instructions in $toml_file"
      return 1
    fi
  done
}

@test "TOML agent names match their filenames" {
  for toml_file in .codex/agents/*.toml; do
    file_name=$(basename "$toml_file" .toml)
    toml_name=$(grep "^name = " "$toml_file" | head -1 | sed 's/^name = "\(.*\)"/\1/')
    if [ "$file_name" != "$toml_name" ]; then
      echo "Name mismatch in $toml_file: file=$file_name, toml=$toml_name"
      return 1
    fi
  done
}

@test "all TOML agents have model field" {
  for toml_file in .codex/agents/*.toml; do
    if ! grep -q "^model = " "$toml_file"; then
      echo "Missing model field in $toml_file"
      return 1
    fi
  done
}

# ==============================================================================
# INTEGRATION TESTS (Optional - require external tools)
# ==============================================================================

@test "Zensical can build documentation" {
  if command -v zensical &> /dev/null; then
    run zensical build --clean
    # Should build successfully
    [ "$status" -eq 0 ]
  else
    skip "Zensical not installed"
  fi
}
