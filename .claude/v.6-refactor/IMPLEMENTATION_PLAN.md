# CMS Cultivator Implementation Plan

**Date:** 2026-01-18
**Based on:** Argument Mode Expansion, Model Selection, and Skill-Command Consolidation analyses
**Priority:** High
**Estimated Effort:** 8-10 hours

---

## Executive Summary

This implementation plan addresses plugin improvements based on three comprehensive analyses:

1. ✅ **Keep current architecture** - No consolidation of skills/commands needed
2. ✅ **Keep all agents on sonnet** - Current quality is production-ready
3. 🎯 **Add argument mode expansion** - Priority enhancement for 4 commands

**Primary Goal:** Add flexible mode-based arguments to audit and quality commands to support multiple use cases (quick checks, comprehensive audits, CI/CD integration).

---

## Decisions from Analyses

### 1. Model Selection (APPROVED)
**Decision:** Keep all 11 agents on sonnet
**Rationale:**
- Current quality is production-ready
- Orchestration works reliably
- 5x cost increase for opus not justified for marginal improvements
- Sonnet excels at structured tasks

**Action:** No changes needed

---

### 2. Skill-Command Architecture (APPROVED)
**Decision:** Keep hybrid architecture with 17 commands and 12 skills
**Rationale:**
- Clear separation: Skills for quick checks, Commands for comprehensive analysis
- User choice is valuable (conversational vs. explicit)
- Low maintenance overhead
- Minimal redundancy (only 2 high-overlap pairs, both intentional)

**Action:** No changes needed

---

### 3. Argument Mode Expansion (IMPLEMENT)
**Decision:** Add mode-based arguments to 4 priority commands
**Rationale:**
- Enables faster pre-commit checks (`--quick`)
- Supports CI/CD integration (`--format=json`)
- Provides cost control (`--scope=current-pr`)
- Flexible for different use cases

**Action:** Implement as detailed below

---

## Phase 1: Argument Mode Expansion (Priority)

### Commands to Enhance (4 total)

1. **audit-a11y** - Accessibility audits
2. **audit-perf** - Performance audits
3. **audit-security** - Security audits
4. **quality-analyze** - Code quality analysis

### New Argument Types

#### Depth Modes
Control analysis thoroughness:
- `--quick` - Fast check, critical issues only (~5 min)
- `--standard` - Normal depth (default, ~15 min)
- `--comprehensive` - Deep dive, all issues (~30 min)

#### Scope Control
Control what code is analyzed:
- `--scope=current-pr` - Only files changed in current PR
- `--scope=module=<name>` - Specific module/directory
- `--scope=file=<path>` - Single file
- `--scope=entire` - Full codebase (default)

#### Output Formats
Control how results are presented:
- `--format=report` - Detailed markdown report (default)
- `--format=json` - JSON for CI/CD integration
- `--format=summary` - Executive summary
- `--format=checklist` - Simple pass/fail list

#### Threshold Controls (Command-Specific)
- **audit-security:** `--min-severity=high|medium|low`
- **audit-perf:** `--target=good|needs-improvement`
- **quality-analyze:** `--max-complexity=N`, `--min-grade=A|B|C`

---

## Implementation Steps

### Step 1: Update Command Documentation (2 hours)

For each of the 4 commands, update the command file in `/commands/`:

#### 1.1 Update Frontmatter
```yaml
---
description: Comprehensive accessibility audit
argument-hint: [options]
allowed-tools: Task, Bash(git:*), Read, Glob, Grep
---
```

#### 1.2 Add Arguments Section
```markdown
## Arguments

This command supports flexible argument modes:

### Depth Modes
- `--quick` - Critical issues only (~5 min)
- `--standard` - Full analysis (default, ~15 min)
- `--comprehensive` - Deep dive with best practices (~30 min)

### Scope Control
- `--scope=current-pr` - Only files changed in current PR
- `--scope=module=<name>` - Specific module/directory
- `--scope=file=<path>` - Single file
- `--scope=entire` - Full codebase (default)

### Output Formats
- `--format=report` - Detailed markdown (default)
- `--format=json` - JSON for CI/CD
- `--format=summary` - Executive summary
- `--format=checklist` - Simple pass/fail

## Usage Examples

```bash
# Quick check before commit
/audit-a11y --quick --scope=current-pr

# Comprehensive audit before release
/audit-a11y --comprehensive

# CI/CD integration
/audit-a11y --standard --format=json

# Focus on specific module
/audit-a11y --scope=module=user-profile
```
```

#### 1.3 Add Argument Parsing Logic
```markdown
## How It Works

### 1. Parse Arguments

The command checks for mode flags and sets defaults:

**Depth mode:**
- If `--quick`, `--standard`, or `--comprehensive` provided → Use that mode
- Default: `--standard`

**Scope:**
- If `--scope=<value>` provided → Use that scope
- Default: `--scope=entire`

**Format:**
- If `--format=<value>` provided → Use that format
- Default: `--format=report`

### 2. Determine Files to Analyze

Based on scope:
- `current-pr` → Use `git diff --name-only origin/main...HEAD`
- `module=<name>` → Analyze files in that directory
- `file=<path>` → Analyze single file
- `entire` → Analyze entire codebase

### 3. Spawn Specialist Agent

Pass parsed arguments to specialist:
```

**Files to update:**
1. `/commands/audit-a11y.md`
2. `/commands/audit-perf.md`
3. `/commands/audit-security.md`
4. `/commands/quality-analyze.md`

---

### Step 2: Update Agent Prompts (1 hour)

Update specialist agents to respect mode arguments:

#### 2.1 Add Mode Handling to Agent Prompts

For each specialist agent in `/agents/`:

```markdown
## Mode Handling

This agent respects the following modes passed from commands:

### Depth Mode
- `quick` - Focus on critical issues only (WCAG Level A violations, high severity)
- `standard` - Full analysis (WCAG Level AA compliance)
- `comprehensive` - Deep analysis (WCAG Level AA + AAA + best practices)

### Scope
- `current-pr` - Analyze only files provided in the file list
- `module=<name>` - Analyze files in specified directory
- `file=<path>` - Analyze single file
- `entire` - Analyze entire codebase

### Output Format
- `report` - Detailed markdown report with examples and recommendations
- `json` - Structured JSON: `{"issues": [...], "summary": {...}}`
- `summary` - Executive summary: High-level findings and priorities
- `checklist` - Simple list: `[PASS]` or `[FAIL]` with issue count

## Adjusting Analysis Based on Mode

**Quick Mode:**
- Skip best practice checks
- Focus on failures only (skip warnings)
- Limit examples to 3 per issue type
- Skip detailed explanations

**Standard Mode (Default):**
- Full compliance checks
- Include warnings and failures
- Provide detailed examples
- Include remediation steps

**Comprehensive Mode:**
- All standard checks PLUS best practices
- Include suggestions for improvements
- Provide multiple examples per issue
- Include advanced recommendations
```

**Files to update:**
1. `/agents/accessibility-specialist/AGENT.md`
2. `/agents/performance-specialist/AGENT.md`
3. `/agents/security-specialist/AGENT.md`
4. `/agents/code-quality-specialist/AGENT.md`

---

### Step 3: Maintain Backward Compatibility (0.5 hours)

Ensure legacy argument syntax still works:

#### 3.1 Support Legacy Focus Area Arguments

**Old style:** `/audit-a11y contrast`
**New style:** `/audit-a11y --focus=contrast`

**Implementation in command files:**

```markdown
## Legacy Argument Support

For backward compatibility, this command supports both old and new argument styles:

**Legacy (still works):**
```bash
/audit-a11y contrast           # Focus on contrast checks
/audit-security injection      # Focus on injection vulnerabilities
```

**New (recommended):**
```bash
/audit-a11y --quick --scope=current-pr
/audit-security --quick --scope=user-input --min-severity=high
```

**Parsing logic:**
- If argument doesn't start with `--`, treat as focus area (legacy)
- If argument starts with `--`, parse as mode flag (new)
- Both can be combined: `/audit-a11y contrast --quick`
```

---

### Step 4: Add Documentation (1 hour)

#### 4.1 Update Command Overview Docs

Update `/docs/commands/audit.md` and `/docs/commands/quality.md`:

```markdown
## Command Modes

All audit and quality commands now support flexible argument modes:

### Quick Checks During Development
```bash
/audit-a11y --quick --scope=current-pr
/audit-security --quick --scope=user-input
```
- ⚡ Fast execution (5 min)
- 🎯 Critical issues only
- 💰 Lower token costs

### Standard Audits (Default)
```bash
/audit-a11y
/audit-perf
```
- 🔍 Comprehensive analysis (15 min)
- ✅ Full compliance checks
- 📊 Detailed reports

### Comprehensive Audits (Pre-Release)
```bash
/audit-a11y --comprehensive
/audit-security --comprehensive
```
- 🔬 Deep analysis (30 min)
- 💎 Best practices included
- 📋 Stakeholder-ready reports

## CI/CD Integration

Export results as JSON for automated pipelines:

```yaml
# GitHub Actions example
- name: Run accessibility audit
  run: |
    /audit-a11y --standard --format=json > audit-results.json

- name: Check results
  run: |
    if [ $(jq '.summary.failures' audit-results.json) -gt 0 ]; then
      exit 1
    fi
```
```

#### 4.2 Update README

Add section highlighting new capabilities:

```markdown
## Flexible Audit Modes

Commands now support multiple operation modes:

- **Quick checks** (`--quick --scope=current-pr`) - Fast pre-commit validation
- **Standard audits** (default) - Comprehensive analysis for PR reviews
- **Deep dives** (`--comprehensive`) - Exhaustive pre-release audits
- **CI/CD integration** (`--format=json`) - Machine-readable output

**Example:**
```bash
# Before committing
/audit-a11y --quick --scope=current-pr

# Before releasing
/audit-a11y --comprehensive --format=report
```
```

#### 4.3 Create Usage Guide

New file: `/docs/guides/using-argument-modes.md`

```markdown
# Using Argument Modes

Complete guide to using flexible argument modes in CMS Cultivator commands.

## Overview

Four commands support advanced argument modes:
- `/audit-a11y` - Accessibility audits
- `/audit-perf` - Performance audits
- `/audit-security` - Security audits
- `/quality-analyze` - Code quality analysis

## Depth Modes

Control how thorough the analysis is...

## Scope Control

Control what code is analyzed...

## Output Formats

Control how results are presented...

## Common Workflows

### Pre-Commit Workflow
```bash
# Quick check on your changes
/audit-a11y --quick --scope=current-pr --format=checklist
```

### PR Review Workflow
```bash
# Standard audit on PR changes
/audit-security --standard --scope=current-pr
```

### Pre-Release Workflow
```bash
# Comprehensive audit for stakeholders
/audit-a11y --comprehensive --format=report
```

### CI/CD Integration
```bash
# Machine-readable output
/audit-perf --standard --format=json
```
```

---

### Step 5: Testing (2 hours)

#### 5.1 Manual Testing Checklist

For each of the 4 commands:

**Test Cases:**

1. ✅ **No arguments (default behavior)**
   - Should run standard mode, entire scope, report format

2. ✅ **Depth modes**
   - `/command --quick` → Fast execution, critical issues only
   - `/command --standard` → Normal execution
   - `/command --comprehensive` → Thorough execution

3. ✅ **Scope control**
   - `/command --scope=current-pr` → Only PR files analyzed
   - `/command --scope=module=src` → Only src/ directory analyzed
   - `/command --scope=file=path/to/file.php` → Single file analyzed

4. ✅ **Output formats**
   - `/command --format=report` → Markdown report
   - `/command --format=json` → Valid JSON structure
   - `/command --format=summary` → Executive summary
   - `/command --format=checklist` → Simple pass/fail list

5. ✅ **Combined arguments**
   - `/command --quick --scope=current-pr --format=checklist`
   - `/command --comprehensive --format=summary`

6. ✅ **Legacy arguments**
   - `/audit-a11y contrast` → Still works as focus area
   - `/audit-security injection` → Still works as focus area

7. ✅ **Backward compatibility**
   - Old syntax produces same results as before
   - No breaking changes to existing workflows

#### 5.2 Create Test Script

New file: `/tests/test-argument-modes.bats`

```bats
#!/usr/bin/env bats

@test "audit-a11y accepts --quick mode" {
  run /audit-a11y --quick --scope=current-pr
  [ "$status" -eq 0 ]
}

@test "audit-a11y accepts --format=json" {
  run /audit-a11y --format=json
  [ "$status" -eq 0 ]
  # Verify output is valid JSON
  echo "$output" | jq . >/dev/null
}

@test "audit-a11y maintains backward compatibility" {
  run /audit-a11y contrast
  [ "$status" -eq 0 ]
}

# ... more tests for other commands
```

#### 5.3 CI/CD Integration Testing

Test JSON output in GitHub Actions workflow:

```yaml
name: Test Argument Modes
on: [push, pull_request]

jobs:
  test-modes:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Run quick accessibility check
        run: /audit-a11y --quick --scope=current-pr --format=json > results.json

      - name: Verify JSON structure
        run: |
          jq -e '.summary.failures' results.json
          jq -e '.issues[]' results.json
```

---

## Implementation Timeline

### Week 1: Documentation Updates (4 hours)

**Day 1-2:**
- Update 4 command files with argument documentation (2 hours)
- Update 4 agent files with mode handling (1 hour)
- Update overview documentation (1 hour)

### Week 2: Testing & Refinement (4 hours)

**Day 3-4:**
- Manual testing of all argument combinations (2 hours)
- Create automated tests (1 hour)
- Documentation refinements based on testing (1 hour)

### Week 3: Polish & Release (2 hours)

**Day 5:**
- Final review and edge case testing (1 hour)
- Update CHANGELOG.md (0.5 hours)
- Create release notes (0.5 hours)

**Total effort:** 10 hours

---

## Success Metrics

### Immediate Metrics (Week 1-2)

- [ ] All 4 commands accept new argument syntax
- [ ] All 4 agents respect mode parameters
- [ ] Backward compatibility maintained (legacy syntax works)
- [ ] Documentation complete with examples
- [ ] All test cases pass

### Adoption Metrics (Month 1)

- [ ] % of audit commands using `--quick` mode
- [ ] % of audit commands using `--scope` filters
- [ ] % of audit commands using `--format=json`
- [ ] User feedback on mode flexibility

### Performance Metrics (Month 2)

- [ ] Average execution time: `--quick` vs. `--standard` vs. `--comprehensive`
- [ ] Token usage: `--scope=current-pr` vs. `--scope=entire`
- [ ] CI/CD integration success rate

### User Satisfaction (Ongoing)

- [ ] User feedback on flexibility
- [ ] Bug reports related to argument parsing
- [ ] Feature requests for additional modes

---

## Rollout Strategy

### Phase 1: Beta Testing (Week 1)

- Release to internal Kanopi team
- Test on real Drupal and WordPress projects
- Gather feedback on argument syntax

### Phase 2: Documentation & Announcement (Week 2)

- Publish updated documentation
- Write blog post explaining new capabilities
- Update plugin README with prominent examples

### Phase 3: General Release (Week 3)

- Bump version to 2.0.0 (major feature addition)
- Deploy to production
- Monitor for issues

---

## Risk Mitigation

### Risk 1: Argument Parsing Conflicts

**Risk:** New arguments conflict with legacy focus area syntax

**Mitigation:**
- Check if argument starts with `--` to distinguish new vs. old
- Test all legacy arguments to ensure they still work
- Document both syntaxes clearly

### Risk 2: Agent Prompt Bloat

**Risk:** Adding mode handling makes agent prompts too long

**Mitigation:**
- Keep mode handling concise (use bullet points)
- Document patterns, not every variation
- Test that agents still perform well with added instructions

### Risk 3: User Confusion

**Risk:** Too many argument options overwhelm users

**Mitigation:**
- Provide clear examples for common workflows
- Create "recipes" guide (pre-commit, PR review, pre-release)
- Make defaults sensible (standard mode, entire scope, report format)

---

## Future Enhancements (Post-Implementation)

### 1. Interactive Mode Selection

If no arguments provided, prompt user:

```
You ran /audit-a11y with no arguments.

What would you like to do?
[1] Quick check on current changes (--quick --scope=current-pr)
[2] Standard audit on entire codebase (default)
[3] Comprehensive pre-release audit (--comprehensive)

Enter choice [1-3]:
```

### 2. Configuration File Support

Allow users to set default modes in `.cms-cultivator.yml`:

```yaml
defaults:
  audit-a11y:
    depth: quick
    scope: current-pr
    format: report
```

### 3. Additional Output Formats

- `--format=sarif` - SARIF format for security tools
- `--format=html` - HTML report with styling
- `--format=csv` - CSV for spreadsheet import

### 4. Additional Scope Options

- `--scope=recent-changes=7d` - Files changed in last 7 days
- `--scope=by-author=username` - Files changed by specific author
- `--scope=critical-path` - Only critical business logic files

### 5. Mode Presets

- `--preset=pre-commit` → Equivalent to `--quick --scope=current-pr --format=checklist`
- `--preset=pr-review` → Equivalent to `--standard --scope=current-pr --format=report`
- `--preset=release` → Equivalent to `--comprehensive --scope=entire --format=summary`

---

## Appendix A: Example Command Updates

### Before (audit-a11y.md)

```markdown
---
description: Comprehensive accessibility audit with WCAG 2.1 Level AA compliance
argument-hint: [focus-area]
allowed-tools: Task
---

## Usage

- `/audit-a11y` - Run full audit
- `/audit-a11y contrast` - Focus on color contrast
- `/audit-a11y keyboard` - Focus on keyboard navigation

...
```

### After (audit-a11y.md)

```markdown
---
description: Comprehensive accessibility audit with WCAG 2.1 Level AA compliance
argument-hint: [options]
allowed-tools: Task, Bash(git:*)
---

## Arguments

### Depth Modes
- `--quick` - Critical WCAG AA failures only (~5 min)
- `--standard` - Full WCAG AA audit (default, ~15 min)
- `--comprehensive` - WCAG AA + AAA + best practices (~30 min)

### Scope Control
- `--scope=current-pr` - Only files in current PR
- `--scope=module=<name>` - Specific module/component
- `--scope=entire` - Full codebase (default)

### Output Formats
- `--format=report` - Detailed markdown (default)
- `--format=json` - JSON for CI/CD
- `--format=checklist` - Simple pass/fail

### Legacy Focus Areas (Still Supported)
- `contrast` - Focus on color contrast
- `keyboard` - Focus on keyboard navigation
- `aria` - Focus on ARIA usage
- `semantic-html` - Focus on HTML structure

## Usage Examples

```bash
# Quick pre-commit check
/audit-a11y --quick --scope=current-pr

# Standard audit (same as legacy `/audit-a11y`)
/audit-a11y

# Comprehensive pre-release audit
/audit-a11y --comprehensive

# CI/CD integration
/audit-a11y --standard --format=json

# Legacy syntax (still works)
/audit-a11y contrast
```

## How It Works

### 1. Parse Arguments

Check for mode flags and set defaults:
- Depth: `--standard` (if not specified)
- Scope: `--entire` (if not specified)
- Format: `--report` (if not specified)

Legacy handling:
- If argument doesn't start with `--`, treat as focus area

### 2. Determine Files to Analyze

Based on scope:
- `current-pr`: Get files from `git diff --name-only origin/main...HEAD`
- `module=<name>`: Glob files in that directory
- `entire`: Analyze entire codebase

### 3. Spawn Accessibility Specialist

```
Task(cms-cultivator:accessibility-specialist:accessibility-specialist,
     prompt="Run accessibility audit with:
       - Depth mode: {depth}
       - Scope: {scope}
       - Format: {format}
       - Files: {file_list}")
```

...
```

---

## Appendix B: JSON Output Structure

### Example JSON Output (`--format=json`)

```json
{
  "command": "audit-a11y",
  "mode": {
    "depth": "standard",
    "scope": "current-pr",
    "format": "json"
  },
  "timestamp": "2026-01-18T10:30:00Z",
  "files_analyzed": 12,
  "summary": {
    "total_issues": 24,
    "failures": 8,
    "warnings": 16,
    "by_severity": {
      "critical": 2,
      "high": 6,
      "medium": 10,
      "low": 6
    },
    "by_category": {
      "contrast": 5,
      "keyboard": 3,
      "aria": 8,
      "semantic-html": 8
    }
  },
  "issues": [
    {
      "id": "a11y-001",
      "severity": "critical",
      "category": "contrast",
      "file": "src/components/Button.tsx",
      "line": 42,
      "message": "Insufficient color contrast ratio (2.8:1)",
      "wcag_criterion": "1.4.3 Contrast (Minimum)",
      "level": "AA",
      "required_ratio": "4.5:1",
      "actual_ratio": "2.8:1",
      "recommendation": "Increase contrast between #888888 and #ffffff to at least 4.5:1",
      "confidence": 100
    }
  ]
}
```

---

## Appendix C: Implementation Checklist

### Command Updates
- [ ] Update `/commands/audit-a11y.md`
- [ ] Update `/commands/audit-perf.md`
- [ ] Update `/commands/audit-security.md`
- [ ] Update `/commands/quality-analyze.md`

### Agent Updates
- [ ] Update `/agents/accessibility-specialist/AGENT.md`
- [ ] Update `/agents/performance-specialist/AGENT.md`
- [ ] Update `/agents/security-specialist/AGENT.md`
- [ ] Update `/agents/code-quality-specialist/AGENT.md`

### Documentation Updates
- [ ] Update `/docs/commands/audit.md`
- [ ] Update `/docs/commands/quality.md`
- [ ] Create `/docs/guides/using-argument-modes.md`
- [ ] Update `/README.md`
- [ ] Update `/CHANGELOG.md`

### Testing
- [ ] Manual test all 4 commands with all argument types
- [ ] Test backward compatibility with legacy syntax
- [ ] Test JSON output structure
- [ ] Test scope filtering (current-pr, module, file)
- [ ] Create automated tests in `/tests/test-argument-modes.bats`

### Release
- [ ] Bump version to 2.0.0 in `.claude-plugin/plugin.json`
- [ ] Create release notes
- [ ] Update documentation site
- [ ] Announce to users

---

## Conclusion

This implementation plan provides a clear roadmap for enhancing CMS Cultivator with flexible argument modes while maintaining the excellent architecture decisions from the three analyses:

✅ **Model Selection:** Keep all agents on sonnet (production-ready quality)
✅ **Architecture:** Keep hybrid skills/commands model (user choice is valuable)
🎯 **Enhancement:** Add argument mode expansion (flexibility + CI/CD support)

**Next Steps:**
1. Review and approve this implementation plan
2. Begin Phase 1: Command and agent documentation updates
3. Progress through testing and refinement phases
4. Release version 2.0.0 with new capabilities

**Expected Outcomes:**
- Faster development workflows (quick modes)
- Better CI/CD integration (JSON output)
- Lower costs (scope limiting)
- Maintained backward compatibility
- Improved user experience
