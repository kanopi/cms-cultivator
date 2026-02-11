# Implementation Plan: `/wp-add-skills` Command

## Overview

Create a new command that installs the official WordPress agent-skills repository globally, making 13 WordPress-specific skills available to Claude Code.

**Approach:** Direct execution (no agent spawning) - follows pattern from `/drupal-cleanup.md`

**Installation Target:** `~/.claude/skills/` (global, works across all projects)

**Command Length:** ~180 lines (within 90-200 line guideline)

---

## 1. Create Command File

**File:** `/commands/wp-add-skills.md`

### Frontmatter

```yaml
---
description: Install official WordPress agent-skills from WordPress/agent-skills repository
argument-hint: "[--update] [--list]"
allowed-tools: Bash(git:*), Bash(node:*), Bash(npm:*), Bash(mkdir:*), Bash(rm:*), Bash(ls:*), Bash(date:*), Bash(df:*), Bash(command:*), Read
---
```

**Allowed Tools Breakdown:**
- `Bash(git:*)` - Clone repository, check git availability
- `Bash(node:*)` - Run build/install scripts
- `Bash(npm:*)` - Check npm availability
- `Bash(mkdir:*)` - Create `~/.claude/skills/` if needed
- `Bash(rm:*)` - Cleanup temp directory
- `Bash(ls:*)` - List and verify installed skills
- `Bash(date:*)` - Generate timestamp for temp directory
- `Bash(df:*)` - Check disk space
- `Bash(command:*)` - Check if git/node commands exist
- `Read` - Verify SKILL.md files after installation

### Content Sections (Following Zensical Style)

1. **How It Works** - Overview, 6-step process
2. **Quick Start** - Common use cases
3. **Usage** - Detailed examples for all arguments
4. **Prerequisites** - Requirements and check commands
5. **Installation Process** - Step-by-step with timing (~70 seconds)
6. **Arguments** - `--list` and `--update` flags
7. **What Gets Installed** - List of 13 WordPress skills
8. **Troubleshooting** - Common issues and solutions
9. **Related Commands** - Links to CMS Cultivator docs

### Implementation Details

**Prerequisites Check (Fail Fast):**
```bash
# 1. Check git
command -v git || exit with error

# 2. Check Node.js
command -v node || exit with error

# 3. Check Node version (warn if < 16)
node --version | check version

# 4. Create/verify ~/.claude/skills/
mkdir -p ~/.claude/skills

# 5. Check write permissions
test -w ~/.claude/skills || exit with error

# 6. Check disk space (warn if < 100MB)
df -k ~ | check available space
```

**Installation Workflow:**
```bash
TIMESTAMP=$(date +%s)
CLONE_DIR="/tmp/wordpress-agent-skills-${TIMESTAMP}"
REPO_URL="https://github.com/WordPress/agent-skills.git"

# 1. Shallow clone (faster, smaller)
git clone --depth 1 "$REPO_URL" "$CLONE_DIR"

# 2. Build skills
cd "$CLONE_DIR"
node shared/scripts/skillpack-build.mjs --clean

# 3. Install globally
node shared/scripts/skillpack-install.mjs --global

# 4. Verify (count skills, check SKILL.md files)
ls -1 ~/.claude/skills/ | grep "^wp-\|^wordpress-" | wc -l

# 5. Cleanup
rm -rf "$CLONE_DIR"

# 6. Report success
echo "✅ Installation Complete!"
echo "Installed: 13 WordPress skills"
echo "Location: ~/.claude/skills/"
```

**Error Handling:**
- Exit code checks after git clone, build, install
- Cleanup temp directory on all failure paths
- Clear, actionable error messages
- Trap to ensure cleanup happens

**Arguments:**

`--list`: Show installed WordPress skills
```bash
ls -1 ~/.claude/skills/ | grep "^wp-\|^wordpress-"
# Check for SKILL.md in each directory
# Report count and status
```

`--update`: Update existing skills
```bash
# Check if skills already installed
# If yes: proceed with installation (overwrites)
# If no: suggest running without --update
```

---

## 2. Update Tests

**File:** `/tests/test-plugin.bats`

### Line 74: Update Command Count

```bash
# Change from:
@test "command count matches expected (22)" {
  count=$(find commands -maxdepth 1 -name "*.md" | wc -l)
  [ "$count" -eq 22 ]
}

# Change to:
@test "command count matches expected (23)" {
  count=$(find commands -maxdepth 1 -name "*.md" | wc -l)
  [ "$count" -eq 23 ]
}
```

### Add New Tests (After Line 183)

```bash
@test "wordpress skills command exists" {
  [ -f "commands/wp-add-skills.md" ]
}

@test "wp-add-skills has required frontmatter" {
  cmd="commands/wp-add-skills.md"
  grep -q "^description:" "$cmd"
  grep -q "^allowed-tools:" "$cmd"
}

@test "wp-add-skills allows git and node" {
  tools=$(sed -n 's/^allowed-tools: *//p' commands/wp-add-skills.md)
  echo "$tools" | grep -q "git:"
  echo "$tools" | grep -q "node:"
}
```

**Expected Results:** 54 tests → 57 tests (3 new tests)

---

## 3. Update Plugin Metadata

**File:** `/.claude-plugin/plugin.json` (Line 4)

```json
// Change from:
"description": "13 specialist agents + 22 commands + 14 skills for Drupal/WordPress..."

// Change to:
"description": "13 specialist agents + 23 commands + 14 skills for Drupal/WordPress..."
```

---

## 4. Documentation Updates

### 4.1 Create WordPress Skills Guide

**File:** `/docs/wordpress-skills.md` (NEW)

**Content:**
- Overview of WordPress agent-skills project
- What gets installed (13 skills with descriptions)
- How to install (`/wp-add-skills`)
- How to manage (`--list`, `--update`)
- Relationship to CMS Cultivator skills (no conflicts)
- Usage examples
- Link to GitHub repository

### 4.2 Update Commands Overview

**File:** `/docs/commands/overview.md`

Add new section at bottom:

```markdown
---

### ⚙️ Setup & Configuration

Extend CMS Cultivator with additional skills.

| Command | Description |
|---------|-------------|
| `/wp-add-skills [options]` | Install official WordPress agent-skills globally |

**Options:**
- `--list` - Show installed WordPress skills
- `--update` - Update skills to latest version

**What it installs:** 13 WordPress-specific skills for block development, REST API, WP-CLI, performance, and more.

**Learn more:** [WordPress Skills Guide](../wordpress-skills.md)
```

### 4.3 Update Quick Start Guide

**File:** `/docs/quick-start.md`

Add WordPress skills setup section (location TBD based on document flow):

```markdown
## Optional: WordPress Skills

Install official WordPress agent-skills for specialized WordPress development:

```bash
/wp-add-skills
```

Adds 13 WordPress-specific skills including block development, REST API, WP-CLI, and performance optimization.

**Learn more:** [WordPress Skills Guide](wordpress-skills.md)
```

### 4.4 Update Navigation

**File:** `/zensical.toml`

Add WordPress Skills page to appropriate navigation section.

### 4.5 Update CHANGELOG

**File:** `/CHANGELOG.md`

Add to [Unreleased] section:

```markdown
### Added
- `/wp-add-skills` command - Install official WordPress agent-skills
  - Installs 13 WordPress-specific skills to ~/.claude/skills/
  - Supports `--list` flag to show installed skills
  - Supports `--update` flag to update to latest version
  - Prerequisite checking for git, Node.js, disk space
  - Installation time: ~70 seconds
```

---

## 5. Critical Files Reference

### Primary Implementation

1. **`/commands/wp-add-skills.md`** (NEW, ~180 lines)
   - Main command implementation
   - Pattern: Follow `/commands/drupal-cleanup.md` structure
   - Direct bash execution, no agent spawning

### Test Updates

2. **`/tests/test-plugin.bats`** (MODIFY)
   - Line 74: Change command count from 22 to 23
   - After line 183: Add 3 new tests

### Metadata Updates

3. **`/.claude-plugin/plugin.json`** (MODIFY)
   - Line 4: Change "22 commands" to "23 commands"

### Documentation Updates

4. **`/docs/wordpress-skills.md`** (NEW)
   - Comprehensive guide to WordPress skills

5. **`/docs/commands/overview.md`** (MODIFY)
   - Add new "Setup & Configuration" section

6. **`/docs/quick-start.md`** (MODIFY)
   - Add WordPress skills installation section

7. **`/zensical.toml`** (MODIFY)
   - Add navigation entry

8. **`/CHANGELOG.md`** (MODIFY)
   - Add new command to [Unreleased] section

---

## 6. What Gets Installed

**13 WordPress Skills (installed to `~/.claude/skills/`):**

1. **wordpress-router** - WordPress project detection
2. **wp-project-triage** - Auto-detect tooling and versions
3. **wp-block-development** - Gutenberg blocks (block.json, InnerBlocks)
4. **wp-block-themes** - Block themes and theme.json
5. **wp-plugin-development** - Plugin architecture, hooks, security
6. **wp-rest-api** - REST API endpoints and authentication
7. **wp-interactivity-api** - Frontend directives (@wordpress/interactivity)
8. **wp-abilities-api** - Capabilities system
9. **wp-wpcli-and-ops** - WP-CLI automation and operations
10. **wp-performance** - Performance optimization, caching
11. **wp-phpstan** - Static analysis configuration
12. **wp-playground** - WordPress Playground integration
13. **wpds** - WordPress Design System

**Repository:** https://github.com/WordPress/agent-skills

**License:** GPL-2.0-or-later (compatible with CMS Cultivator)

**Total Size:** < 5MB after cleanup

---

## 7. Integration Considerations

### No Naming Conflicts

**CMS Cultivator skills (14):**
- accessibility-checker, browser-validator, code-standards-checker, etc.

**WordPress skills (13):**
- All use `wp-*` or `wordpress-*` prefix

**No overlap** - Skills complement each other

### Skill Activation

- WordPress skills auto-activate in WordPress projects
- `wordpress-router` detects WordPress context
- Works alongside CMS Cultivator skills
- No manual configuration needed

### Global vs Plugin-Level

- **CMS Cultivator skills:** Plugin-level (commands/, skills/)
- **WordPress skills:** Global (~/.claude/skills/)
- **Both available** when CMS Cultivator plugin is enabled
- **WordPress skills work** even without CMS Cultivator plugin

---

## 8. User Experience

### Installation Flow

```
User: /wp-add-skills

Claude:
📋 Checking prerequisites...
✅ Git found: v2.39.0
✅ Node.js found: v20.10.0
✅ Skills directory: ~/.claude/skills/
✅ Write permissions: OK
✅ Disk space: 2.4GB available

📦 Cloning WordPress agent-skills repository...
   → Time: 28s

🔨 Building skill packages...
   → Time: 14s

📥 Installing to ~/.claude/skills/...
   → 13 skills installed

✅ Verifying installation...
   → All skills present

🧹 Cleaning up temporary files...

✅ **Installation Complete!**

**Installed:** 13 WordPress skills
**Location:** ~/.claude/skills/
**Total time:** 78 seconds

**Next steps:**
- Test: "How do I create a custom Gutenberg block?"
- List skills: /wp-add-skills --list
- Learn more: https://github.com/WordPress/agent-skills
```

### List Skills

```
User: /wp-add-skills --list

Claude:
📋 Installed WordPress Skills

Found 13 WordPress skills:

✅ wordpress-router
✅ wp-block-development
✅ wp-block-themes
... (all 13 listed)

**Location:** ~/.claude/skills/
**Commands:**
  - Update: /wp-add-skills --update
```

### Error Example

```
User: /wp-add-skills

Claude:
📋 Checking prerequisites...
❌ Node.js not found

**Required:** Node.js v16+ (v18+ recommended)
**Install:** https://nodejs.org/

Cannot proceed without Node.js.
```

---

## 9. Verification Steps

After implementation, verify:

### Command Tests

```bash
# Run test suite
bats tests/test-plugin.bats

# Expected: 57 tests pass (was 54)
```

### Manual Testing

```bash
# 1. Enable plugin
claude plugins enable cms-cultivator

# 2. Test list (should show no skills initially)
/wp-add-skills --list

# 3. Run installation
/wp-add-skills

# 4. Verify skills installed
ls -la ~/.claude/skills/ | grep wp-
# Should show 13 directories

# 5. Test list again
/wp-add-skills --list
# Should show 13 skills

# 6. Test update
/wp-add-skills --update
# Should re-install successfully

# 7. Test usage
# Ask: "How do I create a custom Gutenberg block?"
# Claude should reference wp-block-development skill
```

### Documentation Build

```bash
# Build documentation
zensical build --clean

# Should complete without errors
# Check new pages rendered correctly
```

---

## 10. Success Criteria

Implementation is complete and successful when:

1. ✅ Command file created with proper frontmatter
2. ✅ Tests pass (57 total, including 3 new tests)
3. ✅ Plugin metadata updated (23 commands)
4. ✅ Documentation pages created and updated
5. ✅ Navigation includes new WordPress skills page
6. ✅ CHANGELOG updated
7. ✅ Manual testing confirms:
   - Prerequisites checked correctly
   - Installation completes in ~70 seconds
   - 13 WordPress skills appear in ~/.claude/skills/
   - `--list` flag works
   - `--update` flag works
   - Error handling works (tested with missing Node.js)
   - Cleanup happens (temp directory removed)
8. ✅ WordPress skills activate in WordPress projects
9. ✅ No naming conflicts with existing CMS Cultivator skills
10. ✅ Documentation builds without errors

---

## 11. Implementation Notes

### Pattern Reference

Follow `/commands/drupal-cleanup.md` pattern:
- Direct bash execution (no agent spawning)
- Clear progress indicators with emoji
- Safety checks before operations
- Confirmation prompts for destructive actions (not needed here)
- Cleanup on all paths (success and failure)
- Actionable error messages

### Code Style

- Use emoji for visual progress: 📋 ✅ ❌ 📦 🔨 📥 🧹
- Show timing estimates: "~70 seconds"
- Provide specific file paths: `~/.claude/skills/`
- Include next steps after completion
- Link to external resources

### Testing Strategy

- Test with Node.js v16, v18, v20
- Test with missing git (error case)
- Test with missing Node.js (error case)
- Test with low disk space (warning case)
- Test `--list` with no skills
- Test `--list` with skills installed
- Test `--update` with no skills (error case)
- Test `--update` with skills (success case)

---

## Timeline Estimate

**Total Implementation:** ~3-4 hours

1. **Command file creation:** 90 minutes
   - Write frontmatter and structure: 15 min
   - Implement bash scripts: 45 min
   - Write documentation sections: 30 min

2. **Test updates:** 20 minutes
   - Update command count: 5 min
   - Add 3 new tests: 15 min

3. **Documentation updates:** 60 minutes
   - Create wordpress-skills.md: 30 min
   - Update other docs: 20 min
   - Update navigation/changelog: 10 min

4. **Testing and refinement:** 60 minutes
   - Run test suite: 5 min
   - Manual testing: 30 min
   - Fix issues: 20 min
   - Final verification: 5 min

**Note:** These are estimates for planning purposes only. Actual time may vary.
