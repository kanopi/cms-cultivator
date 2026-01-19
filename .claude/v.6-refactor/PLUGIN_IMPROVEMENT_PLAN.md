# CMS Cultivator Plugin Improvement Plan

## Executive Summary

This document analyzes 6 official Claude Code plugins and provides actionable recommendations to improve cms-cultivator's commands, agents, and skills based on best practices from Anthropic's plugin ecosystem.

**Analyzed Plugins:**
- code-review (multi-agent PR review with confidence scoring)
- commit-commands (streamlined git workflow)
- feature-dev (comprehensive feature development with phased approach)
- frontend-design (skill-based UI/UX implementation)
- pr-review-toolkit (specialized PR review agents)
- ralph-wiggum (self-referential iterative development loops)

**Key Finding:** cms-cultivator is architecturally sound but can benefit from pattern refinements in command design, agent orchestration, and skill activation.

---

## Phase 1: Command Structure Analysis & Improvements

**Output `<promise>DONE</promise>` when all phases done.**

### 1.1 Current State Analysis

**cms-cultivator commands (17 total):**
- PR workflow: pr-commit-msg, pr-create, pr-release, pr-review
- Testing: test-generate, test-coverage, test-plan
- Quality: quality-analyze, quality-standards
- Accessibility: audit-a11y
- Security: audit-security
- Performance: audit-perf
- Documentation: docs-generate
- Design: design-to-block, design-to-paragraph, design-validate
- Live auditing: audit-live-site

### 1.2 Patterns from Official Plugins

#### Pattern 1: Minimal Context Commands (commit-commands)

**Example:** `commit.md`
```yaml
---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)
description: Create a git commit
---

## Context
- Current git status: !`git status`
- Current git diff: !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task
Based on the above changes, create a single git commit.
Stage and create the commit using a single message.
Do not use any other tools or do anything else.
```

**Key Insights:**
- Extremely focused commands with minimal instruction
- Use shell expansion (`!`) to inject live context
- Clear boundaries: "Do not use any other tools"
- Single-purpose execution

**Application to cms-cultivator:**

✅ **Good:** Our commands already spawn agents/skills properly
⚠️ **Improve:** Add more shell expansion for live context injection
⚠️ **Improve:** Clarify tool boundaries more explicitly

#### Pattern 2: Phased Workflow Commands (feature-dev)

**Example:** `feature-dev.md` structure
```markdown
## Phase 1: Discovery
**Goal**: Understand what needs to be built
**Actions**: 1. Create todo list, 2. Ask clarifying questions, 3. Confirm understanding

## Phase 2: Codebase Exploration
**Goal**: Understand existing code
**Actions**: Launch 2-3 code-explorer agents in parallel

## Phase 3: Clarifying Questions
**CRITICAL**: DO NOT SKIP
**Actions**: Identify ambiguities, present questions, wait for answers

## Phase 4: Architecture Design
**Actions**: Launch 2-3 code-architect agents with different focuses

## Phase 5: Implementation
**DO NOT START WITHOUT USER APPROVAL**
```

**Key Insights:**
- Clear phase gates with approval checkpoints
- Explicit "DO NOT SKIP" for critical phases
- Parallel agent execution within phases
- User approval before destructive actions

**Application to cms-cultivator:**

✅ **Good:** Our workflow commands (pr-create, pr-release) already use phases
⚠️ **Improve:** Add explicit phase gates and approval checkpoints
⚠️ **Improve:** Mark critical phases with "CRITICAL" or "DO NOT SKIP"
⚠️ **Improve:** Add "DO NOT START WITHOUT USER APPROVAL" to destructive commands

#### Pattern 3: Argument-Driven Behavior (pr-review-toolkit)

**Example:** `review-pr.md`
```yaml
---
argument-hint: "[review-aspects]"
allowed-tools: ["Bash", "Glob", "Grep", "Read", "Task"]
---

## Review Aspects (optional): "$ARGUMENTS"

Available aspects:
- comments - Analyze comment accuracy
- tests - Review test coverage
- errors - Check error handling
- types - Analyze type design
- code - General code review
- simplify - Simplify code
- all - Run all reviews (default)
```

**Key Insights:**
- Single command with multiple modes
- Clear argument documentation
- Default behavior when no args provided
- Flexible scope control

**Application to cms-cultivator:**

✅ **Good:** We use focus parameters (pr-review, audit-* commands)
⚠️ **Improve:** Document all possible argument values more clearly
⚠️ **Improve:** Add "default" behavior documentation
⚠️ **Improve:** Consider consolidating related commands with argument modes

### 1.3 Recommended Command Improvements

#### Improvement 1: Add Shell Expansion for Live Context

**Commands to update:** pr-commit-msg, pr-create, pr-review

**Example for pr-commit-msg.md:**
```markdown
## Context
- Current branch: !`git branch --show-current`
- Staged files: !`git diff --cached --name-only`
- Last 5 commits: !`git log --oneline -5`
- Commit message format: !`git log -1 --pretty=format:%s 2>/dev/null || echo "No previous commits"`

## Your task
Generate a conventional commit message using the workflow-specialist agent.
```

#### Improvement 2: Add Phase Gates to Workflow Commands

**Commands to update:** pr-create, pr-release, audit-live-site

**Example for pr-create.md:**
```markdown
## Phase 1: Analysis
**Goal**: Understand changes to include in PR
**Actions**:
1. Run git diff to see all commits since branch divergence
2. Analyze commit history
3. Identify scope and impact

## Phase 2: Description Generation
**Goal**: Create comprehensive PR description
**Actions**:
1. Spawn workflow-specialist agent
2. Generate summary, test plan, documentation

## Phase 3: Review & Approval
**CRITICAL - DO NOT SKIP**
**Goal**: Get user approval before creating PR
**Actions**:
1. Show generated PR description
2. Ask user: "Ready to create PR with this description?"
3. Wait for explicit approval

## Phase 4: PR Creation
**DO NOT START WITHOUT USER APPROVAL**
**Goal**: Create and push PR
**Actions**:
1. Push branch if needed
2. Create PR with gh cli
3. Display PR URL
```

#### Improvement 3: Clarify Tool Boundaries

**All commands:** Add explicit boundary statements

**Template:**
```markdown
## Tool Usage

**Allowed operations:**
- Read files for analysis
- Run git commands (read-only)
- Spawn {agent-name} agent

**Not allowed:**
- Do not modify files directly
- Do not commit changes
- Do not push to remote

The {agent-name} agent will perform all necessary operations.
```

---

## Phase 2: Agent Design Analysis & Improvements

**Output `<promise>DONE</promise>` when all phases done.**

### 2.1 Current State Analysis

**cms-cultivator agents (11 total):**
- Leaf specialists: accessibility, code-quality, documentation, performance, responsive-styling, security, testing, browser-validator
- Orchestrators: design-specialist, live-audit-specialist, workflow-specialist

### 2.2 Patterns from Official Plugins

#### Pattern 1: Agent Role Clarity (code-architect)

**Example:** `code-architect.md`
```yaml
---
name: code-architect
description: Designs feature architectures by analyzing existing codebase patterns and conventions, then providing comprehensive implementation blueprints with specific files to create/modify, component designs, data flows, and build sequences
tools: Glob, Grep, LS, Read, NotebookRead, WebFetch, TodoWrite, WebSearch, KillShell, BashOutput
model: sonnet
color: green
---

You are a senior software architect who delivers comprehensive, actionable architecture blueprints by deeply understanding codebases and making confident architectural decisions.

## Core Process
1. Codebase Pattern Analysis
2. Architecture Design
3. Complete Implementation Blueprint

## Output Guidance
Deliver a decisive, complete architecture blueprint including:
- Patterns & Conventions Found
- Architecture Decision
- Component Design
- Implementation Map
- Data Flow
- Build Sequence
- Critical Details
```

**Key Insights:**
- Description is WHEN to use agent (not WHAT it does)
- Clear role definition: "senior software architect"
- Specific output format expectations
- Tool list is comprehensive but focused
- Color for UI distinction

**Application to cms-cultivator:**

✅ **Good:** Our agents have clear names and descriptions
⚠️ **Improve:** Rewrite descriptions to focus on WHEN to invoke
⚠️ **Improve:** Add clear role definitions ("You are a...")
⚠️ **Improve:** Specify expected output formats more explicitly
⚠️ **Improve:** Add color field to all agents

#### Pattern 2: Confidence Scoring (code-reviewer)

**Example:** `code-reviewer.md`
```yaml
---
name: code-reviewer
description: Use this agent when you need to review code for adherence to project guidelines...
model: opus
color: green
---

## Issue Confidence Scoring
Rate each issue from 0-100:
- 0-25: Likely false positive
- 26-50: Minor nitpick
- 51-75: Valid but low-impact
- 76-90: Important issue
- 91-100: Critical bug

**Only report issues with confidence ≥ 80**

## Output Format
For each high-confidence issue:
- Clear description and confidence score
- File path and line number
- Specific rule or bug explanation
- Concrete fix suggestion

Group by severity (Critical: 90-100, Important: 80-89).
```

**Key Insights:**
- Numerical confidence scores reduce false positives
- Explicit threshold for reporting (≥ 80)
- Structured output format
- Severity grouping
- Uses opus model for higher quality

**Application to cms-cultivator:**

⚠️ **Improve:** Add confidence scoring to: accessibility-specialist, security-specialist, code-quality-specialist
⚠️ **Improve:** Set explicit reporting thresholds
⚠️ **Improve:** Standardize output format across review agents

#### Pattern 3: Proactive Invocation Examples (code-reviewer)

**Example:** `code-reviewer.md` description field
```yaml
description: Use this agent when you need to review code for adherence to project guidelines, style guides, and best practices. This agent should be used proactively after writing or modifying code, especially before committing changes or creating pull requests.

Examples:
<example>
Context: The user has just implemented a new feature.
user: "I've added the new authentication feature. Can you check if everything looks good?"
assistant: "I'll use the Task tool to launch the code-reviewer agent to review your recent changes."
</example>
<example>
Context: The assistant has just written a new utility function.
assistant: "Now I'll use the Task tool to launch the code-reviewer agent to review this implementation."
<commentary>Proactively use the code-reviewer agent after writing new code.</commentary>
</example>
```

**Key Insights:**
- Description includes WHEN to use agent
- Provides concrete invocation examples
- Shows both user-triggered and proactive use cases
- Includes commentary explaining reasoning

**Application to cms-cultivator:**

⚠️ **Improve:** Add examples to all agent descriptions
⚠️ **Improve:** Show both user-triggered and proactive scenarios
⚠️ **Improve:** Include commentary for learning

### 2.3 Recommended Agent Improvements

#### Improvement 1: Rewrite Agent Descriptions (WHEN not WHAT)

**Current pattern:** "Specialist agent for X"
**New pattern:** "Use this agent when..."

**Example for accessibility-specialist/AGENT.md:**

**Before:**
```yaml
description: WCAG 2.1 Level AA compliance specialist. Performs accessibility audits including semantic HTML validation, ARIA usage, keyboard navigation, color contrast, and screen reader compatibility.
```

**After:**
```yaml
description: Use this agent when you need to check WCAG 2.1 Level AA compliance for Drupal or WordPress components. This agent should be used proactively after creating UI components, forms, or interactive elements, especially before committing changes or creating pull requests. It will validate semantic HTML, ARIA attributes, keyboard navigation, color contrast, and screen reader compatibility.

Examples:
<example>
Context: User has just created a custom form component.
user: "I've built a multi-step form with custom validation. Can you check if it's accessible?"
assistant: "I'll use the Task tool to launch the accessibility-specialist agent to perform WCAG 2.1 Level AA compliance checks."
</example>
<example>
Context: Assistant has just written a modal dialog component.
assistant: "Now I'll use the Task tool to launch the accessibility-specialist agent to verify keyboard navigation and screen reader compatibility."
<commentary>Proactively check accessibility after creating interactive UI components.</commentary>
</example>
```

#### Improvement 2: Add Confidence Scoring to Review Agents

**Agents to update:** accessibility-specialist, security-specialist, code-quality-specialist

**Template to add:**
```markdown
## Issue Confidence Scoring

Rate each issue from 0-100:
- **0-25**: Likely false positive or minor suggestion
- **26-50**: Minor nitpick not explicitly required
- **51-75**: Valid but low-impact issue
- **76-90**: Important issue requiring attention
- **91-100**: Critical violation or security risk

**Only report issues with confidence ≥ 75**

## Output Format

For each high-confidence issue:
- **Description**: Clear explanation with confidence score
- **Location**: File path and line number
- **Rule**: Specific WCAG/OWASP/standard violated
- **Impact**: How this affects users/security
- **Fix**: Concrete remediation steps

Group issues by severity:
- **Critical (90-100)**: Must fix before deployment
- **Important (75-89)**: Should fix before PR approval
```

#### Improvement 3: Add Color Field to All Agents

**Color scheme:**
- Green: Review/audit agents (accessibility, code-quality, security)
- Blue: Generation agents (documentation, testing, responsive-styling)
- Purple: Orchestrators (design-specialist, live-audit-specialist, workflow-specialist)
- Orange: Browser interaction (browser-validator-specialist)

**Update all AGENT.md files:**
```yaml
---
name: accessibility-specialist
description: ...
tools: Read, Glob, Grep, Bash
model: sonnet
color: green  # ADD THIS
---
```

#### Improvement 4: Standardize Output Format

**All agents should include:**
```markdown
## Output Format

### Summary
- Total issues found: X
- Critical: X
- Important: X
- Suggestions: X

### Critical Issues (must fix)
1. **[File:Line]** Description (Confidence: XX)
   - Rule: Specific standard violated
   - Fix: Concrete steps

### Important Issues (should fix)
...

### Suggestions (nice to have)
...

### Positive Observations
- What's working well
```

---

## Phase 3: Skill Design Analysis & Improvements

**Output `<promise>DONE</promise>` when all phases done.**

### 3.1 Current State Analysis

**cms-cultivator skills (12 total):**
- accessibility-checker
- browser-validator
- code-standards-checker
- commit-message-generator
- coverage-analyzer
- design-analyzer
- documentation-generator
- performance-analyzer
- responsive-styling
- security-scanner
- test-plan-generator
- test-scaffolding

### 3.2 Patterns from Official Plugins

#### Pattern 1: Rich Skill Descriptions (frontend-design)

**Example:** `frontend-design/SKILL.md`
```yaml
---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, or applications. Generates creative, polished code that avoids generic AI aesthetics.
license: Complete terms in LICENSE.txt
---

This skill guides creation of distinctive, production-grade frontend interfaces...

## Design Thinking
Before coding, understand the context and commit to a BOLD aesthetic direction:
- Purpose: What problem does this interface solve?
- Tone: Pick an extreme (minimal, chaos, retro, organic, luxury, etc.)
- Constraints: Technical requirements
- Differentiation: What makes this UNFORGETTABLE?

## Frontend Aesthetics Guidelines
Focus on:
- Typography: Choose distinctive fonts
- Color & Theme: Commit to cohesive aesthetic
- Motion: Use animations for effects
- Spatial Composition: Unexpected layouts
- Backgrounds & Visual Details: Create atmosphere

NEVER use generic AI aesthetics like...
```

**Key Insights:**
- Description is crisp and action-oriented
- Includes concrete decision frameworks
- Provides specific "DO" and "DON'T" guidance
- Rich context and philosophy
- License field for legal clarity

**Application to cms-cultivator:**

✅ **Good:** Our skills have detailed workflows
⚠️ **Improve:** Add more "DO" and "DON'T" guidance
⚠️ **Improve:** Include decision frameworks
⚠️ **Improve:** Add philosophy/approach sections

#### Pattern 2: Skill-Command Relationship

**Finding:** Official plugins keep skills and commands separate
- frontend-design: Only skill, no command (model-invoked)
- feature-dev: Command spawns agents (no skill)
- pr-review-toolkit: Command spawns agents (no skill)

**Current cms-cultivator approach:** Hybrid (skills + commands for same functionality)

**Examples:**
- accessibility-checker skill + audit-a11y command
- security-scanner skill + audit-security command
- test-scaffolding skill + test-generate command

**Analysis:**
✅ **Good:** Provides both quick checks (skills) and comprehensive analysis (commands)
✅ **Good:** Clear distinction in scope
⚠️ **Consider:** Are both needed for every feature? Or just comprehensive commands?

### 3.3 Recommended Skill Improvements

#### Improvement 1: Add Decision Frameworks

**Skills to update:** All skills with subjective decisions

**Example for design-analyzer skill:**
```markdown
## Design Analysis Framework

Before extracting specifications, analyze the design through these lenses:

### 1. Hierarchy Assessment
- Primary focal points (largest, boldest, highest contrast)
- Secondary elements (supporting content)
- Tertiary details (metadata, decorative)

### 2. Responsive Breakpoint Strategy
- Mobile-first baseline (320px)
- Tablet breakpoint (768px)
- Desktop breakpoint (1024px+)
- Content-driven breakpoints (when design breaks)

### 3. Component Identification
Decision tree:
- Repeating pattern → Component candidate
- Single use → Inline implementation
- 3+ variations → Consider variant prop
- Platform-specific → Separate implementations

### 4. Accessibility Implications
Check list:
- Color contrast ratios (WCAG AA: 4.5:1 normal, 3:1 large)
- Touch target sizes (44px minimum)
- Focus indicators (visible, 2px minimum)
- Keyboard navigation (logical tab order)
```

#### Improvement 2: Add "DO" and "DON'T" Sections

**Template for all skills:**
```markdown
## Best Practices

### DO:
- ✅ Use semantic HTML5 elements (header, nav, main, article)
- ✅ Implement mobile-first responsive design
- ✅ Test with keyboard navigation before submitting
- ✅ Run automated accessibility checks (axe, WAVE)
- ✅ Provide meaningful alt text for images

### DON'T:
- ❌ Use div soup (nested divs without semantic meaning)
- ❌ Rely on color alone to convey information
- ❌ Skip keyboard navigation testing
- ❌ Use CSS that breaks at uncommon viewport sizes
- ❌ Ignore WCAG AA color contrast requirements
```

#### Improvement 3: Add Philosophy Sections

**Skills to update:** All skills

**Example for accessibility-checker skill:**
```markdown
## Accessibility Philosophy

Accessibility is not a checklist—it's a mindset of inclusive design.

### Core Beliefs:
1. **Universal Design**: Build for everyone from the start, not as an afterthought
2. **Progressive Enhancement**: Core functionality works for all, enhancements are optional
3. **Semantic First**: Meaningful HTML structure over ARIA workarounds
4. **Real Users**: Test with actual assistive technology users when possible

### Scope Balance:
- **Quick checks** (this skill): Fast feedback on specific components
- **Comprehensive audits** (/audit-a11y command): Full site analysis with parallel specialists
- **Manual testing**: Keyboard, screen readers, user testing (irreplaceable)

This skill catches 60-70% of common issues. Comprehensive testing catches the rest.
```

---

## Phase 4: Cross-Cutting Pattern Improvements

**Output `<promise>DONE</promise>` when all phases done.**

### 4.1 TodoWrite Usage

**Pattern from official plugins:** Aggressive TodoWrite usage

**Example from feature-dev.md:**
```markdown
## Core Principles
- **Use TodoWrite**: Track all progress throughout
```

**Analysis of cms-cultivator:**
- Orchestrator agents (live-audit-specialist, workflow-specialist) use TodoWrite
- Leaf specialists don't consistently use TodoWrite

**Recommendation:**
✅ Keep current usage in orchestrators
❌ Don't add TodoWrite to leaf specialists (creates clutter)
✅ Add TodoWrite guidance to commands that spawn multiple agents

**Example for audit-live-site command:**
```markdown
## Workflow

1. **Planning Phase**
   - Create todo list with all audit categories
   - Mark items as in_progress when spawning agents

2. **Execution Phase**
   - Spawn all specialists in parallel
   - Update todos as agents complete

3. **Synthesis Phase**
   - Mark todos complete
   - Generate unified report
```

### 4.2 Parallel Execution Clarity

**Pattern from official plugins:** Explicit parallel vs. sequential guidance

**Example from pr-review-toolkit/review-pr.md:**
```markdown
5. **Launch Review Agents**

   **Sequential approach** (one at a time):
   - Easier to understand and act on
   - Good for interactive review

   **Parallel approach** (user can request):
   - Launch all agents simultaneously
   - Faster for comprehensive review
   - Results come back together
```

**Recommendation:**
Add explicit parallel execution guidance to orchestrator commands.

**Example for audit-live-site.md:**
```markdown
## Execution Strategy

By default, this command launches all specialists **in parallel** for maximum speed:
- performance-specialist
- accessibility-specialist
- security-specialist
- code-quality-specialist

**Why parallel?**
- Reduces total audit time from ~10 minutes to ~3 minutes
- Each specialist works independently
- Results aggregated at the end

**Sequential alternative:**
If you prefer to review results one at a time, request "sequential" in your message.
```

### 4.3 Model Selection Strategy

**Pattern from official plugins:**
- opus: High-complexity analysis (code-reviewer, code-architect)
- sonnet: Most agents
- haiku: Not used in examples reviewed

**Current cms-cultivator usage:**
- All agents use sonnet (default)

**Recommendation:**
Consider opus for highest-stakes agents:
- workflow-specialist (orchestrates complex PR workflows)
- design-specialist (makes architectural decisions)
- live-audit-specialist (aggregates multiple agent outputs)

**Trade-off:** opus is 5x cost of sonnet, so use judiciously

### 4.4 Allowed Tools Patterns

**Pattern from official plugins:**
```yaml
# Minimal (commit-commands)
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*)

# Moderate (pr-review-toolkit)
allowed-tools: ["Bash", "Glob", "Grep", "Read", "Task"]

# Agent tools (feature-dev agents)
tools: Glob, Grep, LS, Read, NotebookRead, WebFetch, TodoWrite, WebSearch, KillShell, BashOutput
```

**Current cms-cultivator pattern:**
```yaml
# Commands (well-scoped)
allowed-tools: Bash(git:*), Read, Glob, Grep, Write, Edit

# Agents (comprehensive)
tools: Read, Glob, Grep, Bash
```

**Analysis:**
✅ **Good:** Commands are well-scoped
⚠️ **Improve:** Consider being more specific in Bash patterns

**Recommendation:**
```yaml
# Before (too broad)
allowed-tools: Bash(git:*), Bash(gh:*)

# After (specific)
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(gh pr view:*)
```

---

## Phase 5: Documentation & README Improvements

**Output `<promise>DONE</promise>` when all phases done.**

### 5.1 Plugin README Patterns

**Official plugin READMEs:**
- Extremely concise (50-150 lines)
- Focus on installation and usage
- Link to individual command/agent docs
- Minimal examples

**Example from feature-dev/README.md:**
```markdown
# Feature Development Plugin

Guided feature development with deep codebase understanding and architecture focus.

## Installation
`claude plugins install feature-dev`

## Usage
`/feature-dev [feature description]`

## What it does
1. Explores codebase with parallel agents
2. Asks clarifying questions
3. Designs architecture with multiple approaches
4. Implements with user approval
5. Reviews quality before completion

## Commands
- `/feature-dev` - Start guided feature development

## Agents
- `code-explorer` - Deep codebase exploration
- `code-architect` - Architecture design
- `code-reviewer` - Quality review

See individual files for details.
```

**Current cms-cultivator README:**
- Comprehensive (400+ lines)
- Includes architecture details
- Lists all commands/agents/skills
- Has detailed "How It Works" sections

**Analysis:**
✅ **Good:** Comprehensive documentation site (MkDocs)
⚠️ **Improve:** README should be minimal, link to docs site

**Recommendation:**
Simplify README to ~150 lines:
```markdown
# CMS Cultivator

14 specialist agents + 17 commands + 12 skills for Drupal/WordPress development.

**Full documentation:** https://kanopi.github.io/cms-cultivator/

## Quick Start
`claude plugins install cms-cultivator`

## Key Features
- **PR Workflows**: Generate commit messages, PR descriptions, changelogs
- **Quality Analysis**: Code standards, test coverage, accessibility, security
- **Design-to-Code**: Figma → WordPress blocks, Drupal paragraphs with browser validation
- **Live Site Audits**: Comprehensive performance/a11y/security audits

## Command Categories
- PR Workflow: /pr-create, /pr-commit-msg, /pr-release, /pr-review
- Testing: /test-generate, /test-coverage, /test-plan
- Quality: /quality-analyze, /quality-standards
- Auditing: /audit-a11y, /audit-security, /audit-perf, /audit-live-site
- Design: /design-to-block, /design-to-paragraph, /design-validate
- Documentation: /docs-generate

**See docs site for complete command reference, agent details, and usage examples.**

## Kanopi Integration
Integrates with Kanopi's DDEV add-ons for Drupal and WordPress projects.

## License
GPL-2.0-or-later
```

### 5.2 Agent Documentation in Commands

**Pattern from official plugins:** Commands include brief agent descriptions

**Example from pr-review-toolkit/review-pr.md:**
```markdown
## Agent Descriptions:

**comment-analyzer**:
- Verifies comment accuracy vs code
- Identifies comment rot
- Checks documentation completeness

**pr-test-analyzer**:
- Reviews behavioral test coverage
- Identifies critical gaps
- Evaluates test quality
```

**Current cms-cultivator:** Agents described in separate docs, not in commands

**Recommendation:**
Add brief agent descriptions to commands that spawn agents.

**Example for audit-live-site.md:**
```markdown
## Specialists Deployed

This command orchestrates 4 parallel specialists:

**performance-specialist** (Green):
- Core Web Vitals analysis (LCP, INP, CLS)
- Database query optimization
- Caching strategy review
- Asset optimization recommendations

**accessibility-specialist** (Green):
- WCAG 2.1 Level AA compliance
- Semantic HTML validation
- ARIA usage patterns
- Keyboard navigation testing
- Color contrast analysis

**security-specialist** (Green):
- OWASP Top 10 vulnerability scanning
- Input validation review
- Output encoding analysis
- Authentication/authorization checks
- CMS-specific security patterns

**code-quality-specialist** (Green):
- Coding standards compliance (PHPCS, ESLint)
- Cyclomatic complexity analysis
- Technical debt assessment
- SOLID principles review

Each specialist provides confidence-scored findings (75-100 only reported).
```

---

## Phase 6: Recommended Implementation Priorities

**Output `<promise>DONE</promise>` when all phases done.**

### Priority 1: High-Impact, Low-Effort (Week 1)

#### 1. Add color field to all agents
- **Effort:** 5 minutes
- **Impact:** Better UI distinction
- **Files:** All 11 agents (AGENT.md frontmatter)

#### 2. Simplify README
- **Effort:** 30 minutes
- **Impact:** Clearer entry point, drives to docs site
- **Files:** README.md

#### 3. Add shell expansion to workflow commands
- **Effort:** 1 hour
- **Impact:** Better context for PR workflows
- **Files:** pr-commit-msg.md, pr-create.md, pr-review.md

#### 4. Add "DO/DON'T" sections to top 3 skills
- **Effort:** 2 hours
- **Impact:** Clearer guidance
- **Files:** accessibility-checker, security-scanner, test-scaffolding

### Priority 2: Medium-Impact, Medium-Effort (Week 2)

#### 5. Rewrite all agent descriptions with examples
- **Effort:** 4 hours
- **Impact:** Better agent invocation
- **Files:** All 11 agents (AGENT.md descriptions)

#### 6. Add confidence scoring to review agents
- **Effort:** 3 hours
- **Impact:** Reduce false positives
- **Files:** accessibility-specialist, security-specialist, code-quality-specialist

#### 7. Add phase gates to workflow commands
- **Effort:** 3 hours
- **Impact:** Clearer user approval checkpoints
- **Files:** pr-create.md, pr-release.md

#### 8. Standardize output format across agents
- **Effort:** 4 hours
- **Impact:** Consistent user experience
- **Files:** All 11 agents (add output format section)

### Priority 3: Lower-Impact, Higher-Effort (Week 3-4)

#### 9. Add decision frameworks to skills
- **Effort:** 6 hours
- **Impact:** Better skill guidance
- **Files:** All 12 skills

#### 10. Add philosophy sections to all skills
- **Effort:** 4 hours
- **Impact:** Clearer purpose and scope
- **Files:** All 12 skills

#### 11. Clarify tool boundaries in commands
- **Effort:** 3 hours
- **Impact:** Clearer command scope
- **Files:** All 17 commands

#### 12. Add agent descriptions to orchestrator commands
- **Effort:** 2 hours
- **Impact:** Better understanding of what's happening
- **Files:** audit-live-site.md, pr-review.md, design-to-block.md, design-to-paragraph.md

### Priority 4: Strategic Considerations (Future)

#### 13. Model selection review
- **Effort:** 2 hours (analysis) + ongoing cost
- **Impact:** Higher quality for complex agents, increased cost
- **Decision:** Analyze cost/benefit for workflow-specialist, design-specialist, live-audit-specialist

#### 14. Skill-command consolidation review
- **Effort:** 8 hours (analysis + refactoring)
- **Impact:** Simpler plugin structure, potential loss of quick-check functionality
- **Decision:** Survey users on skill vs. command preference

#### 15. Argument mode expansion
- **Effort:** 6 hours
- **Impact:** More flexible commands, steeper learning curve
- **Decision:** Identify commands that would benefit from modes (audit-*, quality-*)

---

## Phase 7: Testing Strategy

**Output `<promise>DONE</promise>` when all phases done.**

### 7.1 Validation Checklist

After each improvement phase:

#### Agent Testing:
- [ ] Agent spawns successfully from command
- [ ] Agent spawns successfully from skill
- [ ] Agent description triggers correct invocation
- [ ] Agent examples are accurate
- [ ] Confidence scores filter appropriately
- [ ] Output format is consistent
- [ ] Color displays correctly in UI

#### Command Testing:
- [ ] Command executes with no arguments
- [ ] Command executes with all argument variations
- [ ] Shell expansion populates correctly
- [ ] Phase gates wait for approval
- [ ] Tool boundaries are respected
- [ ] Agent spawning works (parallel and sequential)

#### Skill Testing:
- [ ] Skill activates on correct trigger phrases
- [ ] Decision frameworks guide correctly
- [ ] DO/DON'T guidance is clear
- [ ] Philosophy section sets expectations
- [ ] Output matches expected format

### 7.2 BATS Test Updates

**Current BATS tests:** 54 tests covering plugin structure

**Additional tests needed:**
```bash
# Test agent frontmatter completeness
@test "all agents have color field" {
  for agent in agents/*/AGENT.md; do
    grep -q "^color: " "$agent" || fail "Missing color in $agent"
  done
}

# Test agent descriptions include examples
@test "all agents have description examples" {
  for agent in agents/*/AGENT.md; do
    grep -q "<example>" "$agent" || fail "Missing examples in $agent"
  done
}

# Test confidence scoring in review agents
@test "review agents have confidence scoring" {
  for agent in agents/{accessibility,security,code-quality}-specialist/AGENT.md; do
    grep -q "Confidence Scoring" "$agent" || fail "Missing confidence scoring in $agent"
  done
}

# Test output format standardization
@test "all agents have output format section" {
  for agent in agents/*/AGENT.md; do
    grep -q "## Output Format" "$agent" || fail "Missing output format in $agent"
  done
}

# Test shell expansion in workflow commands
@test "workflow commands use shell expansion" {
  for cmd in commands/pr-{commit-msg,create,review}.md; do
    grep -q '!\`git' "$cmd" || fail "Missing shell expansion in $cmd"
  done
}
```

### 7.3 User Acceptance Testing

**Test scenarios:**

1. **PR Workflow Test**
   - Create feature branch
   - Make changes
   - Run /pr-commit-msg
   - Run /pr-create
   - Verify phase gates work
   - Verify shell expansion provides context

2. **Audit Test**
   - Run /audit-live-site
   - Verify parallel execution
   - Verify confidence scores
   - Verify output format consistency
   - Verify agent descriptions are clear

3. **Design-to-Code Test**
   - Provide Figma URL or screenshot
   - Run /design-to-block
   - Verify design-specialist spawns correctly
   - Verify responsive-styling-specialist provides calculations
   - Verify browser-validator-specialist validates

4. **Skill Activation Test**
   - Ask "Is this accessible?" (should trigger accessibility-checker)
   - Ask "Is this secure?" (should trigger security-scanner)
   - Ask "What tests are missing?" (should trigger coverage-analyzer)
   - Verify skills activate without explicit commands

---

## Phase 8: Implementation Plan Summary

**Output `<promise>DONE</promise>` when all phases done.**

### Week 1: Quick Wins
- [ ] Add color to all agents (5 min)
- [ ] Simplify README (30 min)
- [ ] Add shell expansion to workflow commands (1 hr)
- [ ] Add DO/DON'T to top 3 skills (2 hr)
- [ ] Write BATS tests for new patterns (1 hr)

**Total: ~5 hours**

### Week 2: Agent & Command Improvements
- [ ] Rewrite all agent descriptions (4 hr)
- [ ] Add confidence scoring to review agents (3 hr)
- [ ] Add phase gates to workflow commands (3 hr)
- [ ] Standardize output formats (4 hr)
- [ ] Test all changes (2 hr)

**Total: ~16 hours**

### Week 3: Skill Enhancements
- [ ] Add decision frameworks to skills (6 hr)
- [ ] Add philosophy sections to skills (4 hr)
- [ ] Clarify tool boundaries in commands (3 hr)
- [ ] Add agent descriptions to orchestrators (2 hr)
- [ ] Documentation updates (2 hr)
- [ ] Test all changes (2 hr)

**Total: ~19 hours**

### Week 4: Review & Polish
- [ ] User acceptance testing (4 hr)
- [ ] Bug fixes from testing (4 hr)
- [ ] Documentation site updates (3 hr)
- [ ] CHANGELOG updates (1 hr)
- [ ] Release v0.6.0 (1 hr)

**Total: ~13 hours**

### Grand Total: ~53 hours (1.5 sprints)

---

## Appendix A: Comparison Matrix

| Feature | Official Plugins | cms-cultivator | Recommended Action |
|---------|------------------|----------------|-------------------|
| **Commands** |
| Shell expansion | ✅ Used heavily | ❌ Not used | Add to workflow commands |
| Phase gates | ✅ Explicit | ⚠️ Implicit | Add "CRITICAL" markers |
| Argument modes | ✅ Well documented | ⚠️ Some commands | Document all modes |
| Tool boundaries | ✅ Explicit | ⚠️ Implicit | Add "Not allowed" sections |
| **Agents** |
| WHEN descriptions | ✅ With examples | ❌ WHAT descriptions | Rewrite all |
| Color field | ✅ All agents | ❌ Missing | Add to all |
| Confidence scoring | ✅ Review agents | ❌ Not used | Add to review agents |
| Output format | ✅ Standardized | ⚠️ Varies | Standardize |
| Proactive examples | ✅ In descriptions | ❌ Not included | Add examples |
| **Skills** |
| Decision frameworks | ✅ frontend-design | ❌ Not used | Add to all |
| DO/DON'T sections | ✅ frontend-design | ❌ Not used | Add to all |
| Philosophy sections | ✅ frontend-design | ❌ Not used | Add to all |
| **Documentation** |
| README length | ✅ Concise | ❌ Too long | Simplify, link to docs |
| Agent descriptions in commands | ✅ Included | ❌ Separate | Add to orchestrators |
| Parallel execution guidance | ✅ Explicit | ⚠️ Mentioned | Add explicit sections |

---

## Appendix B: File Modification Checklist

### Commands to Modify (17 files)

**High Priority:**
- [ ] commands/pr-commit-msg.md (add shell expansion, phase gates)
- [ ] commands/pr-create.md (add shell expansion, phase gates)
- [ ] commands/pr-review.md (add shell expansion, argument docs)
- [ ] commands/pr-release.md (add phase gates)

**Medium Priority:**
- [ ] commands/audit-live-site.md (add agent descriptions, parallel execution guidance)
- [ ] commands/audit-a11y.md (clarify tool boundaries)
- [ ] commands/audit-security.md (clarify tool boundaries)
- [ ] commands/audit-perf.md (clarify tool boundaries)
- [ ] commands/design-to-block.md (add agent descriptions)
- [ ] commands/design-to-paragraph.md (add agent descriptions)

**Lower Priority:**
- [ ] commands/design-validate.md (clarify tool boundaries)
- [ ] commands/test-generate.md (clarify tool boundaries)
- [ ] commands/test-coverage.md (clarify tool boundaries)
- [ ] commands/test-plan.md (clarify tool boundaries)
- [ ] commands/quality-analyze.md (argument modes)
- [ ] commands/quality-standards.md (clarify tool boundaries)
- [ ] commands/docs-generate.md (clarify tool boundaries)

### Agents to Modify (11 files)

**All agents need:**
- [ ] agents/accessibility-specialist/AGENT.md (description, examples, color, confidence, output)
- [ ] agents/browser-validator-specialist/AGENT.md (description, examples, color, output)
- [ ] agents/code-quality-specialist/AGENT.md (description, examples, color, confidence, output)
- [ ] agents/design-specialist/AGENT.md (description, examples, color, output)
- [ ] agents/documentation-specialist/AGENT.md (description, examples, color, output)
- [ ] agents/live-audit-specialist/AGENT.md (description, examples, color, output)
- [ ] agents/performance-specialist/AGENT.md (description, examples, color, output)
- [ ] agents/responsive-styling-specialist/AGENT.md (description, examples, color, output)
- [ ] agents/security-specialist/AGENT.md (description, examples, color, confidence, output)
- [ ] agents/testing-specialist/AGENT.md (description, examples, color, output)
- [ ] agents/workflow-specialist/AGENT.md (description, examples, color, output)

### Skills to Modify (12 files)

**All skills need:**
- [ ] skills/accessibility-checker/SKILL.md (decision framework, DO/DON'T, philosophy)
- [ ] skills/browser-validator/SKILL.md (decision framework, DO/DON'T, philosophy)
- [ ] skills/code-standards-checker/SKILL.md (decision framework, DO/DON'T, philosophy)
- [ ] skills/commit-message-generator/SKILL.md (decision framework, DO/DON'T, philosophy)
- [ ] skills/coverage-analyzer/SKILL.md (decision framework, DO/DON'T, philosophy)
- [ ] skills/design-analyzer/SKILL.md (decision framework, DO/DON'T, philosophy)
- [ ] skills/documentation-generator/SKILL.md (decision framework, DO/DON'T, philosophy)
- [ ] skills/performance-analyzer/SKILL.md (decision framework, DO/DON'T, philosophy)
- [ ] skills/responsive-styling/SKILL.md (decision framework, DO/DON'T, philosophy)
- [ ] skills/security-scanner/SKILL.md (decision framework, DO/DON'T, philosophy)
- [ ] skills/test-plan-generator/SKILL.md (decision framework, DO/DON'T, philosophy)
- [ ] skills/test-scaffolding/SKILL.md (decision framework, DO/DON'T, philosophy)

### Other Files

- [ ] README.md (simplify to ~150 lines)
- [ ] tests/test-plugin.bats (add new validation tests)
- [ ] CHANGELOG.md (document v0.6.0 changes)

### Total: 43 files to modify

---

## Appendix C: Example Transformations

### Example 1: Agent Description Transformation

**File:** agents/accessibility-specialist/AGENT.md

**BEFORE:**
```yaml
---
name: accessibility-specialist
description: WCAG 2.1 Level AA compliance specialist. Performs accessibility audits including semantic HTML validation, ARIA usage, keyboard navigation, color contrast, and screen reader compatibility. Works with Drupal and WordPress projects.
tools: Read, Glob, Grep, Bash
---
```

**AFTER:**
```yaml
---
name: accessibility-specialist
description: Use this agent when you need to check WCAG 2.1 Level AA compliance for Drupal or WordPress components. This agent should be used proactively after creating UI components, forms, or interactive elements, especially before committing changes or creating pull requests. It will validate semantic HTML, ARIA attributes, keyboard navigation, color contrast (4.5:1 minimum), and screen reader compatibility.

Examples:
<example>
Context: User has just created a custom form component with multiple steps.
user: "I've built a multi-step form with custom validation. Can you check if it's accessible?"
assistant: "I'll use the Task tool to launch the accessibility-specialist agent to perform WCAG 2.1 Level AA compliance checks on your form."
<commentary>
The multi-step form has interactive elements that need keyboard navigation and screen reader testing.
</commentary>
</example>
<example>
Context: Assistant has just written a modal dialog component with focus management.
user: "Does this modal work with screen readers?"
assistant: "I'll use the Task tool to launch the accessibility-specialist agent to verify keyboard navigation, focus management, and screen reader compatibility."
<commentary>
Proactively check accessibility after creating interactive UI components like modals.
</commentary>
</example>
<example>
Context: Assistant has modified existing component styling.
assistant: "I've updated the button styles. Now I'll use the Task tool to launch the accessibility-specialist agent to verify color contrast ratios meet WCAG AA standards."
<commentary>
Color changes require contrast verification to ensure accessibility compliance.
</commentary>
</example>
tools: Read, Glob, Grep, Bash
model: sonnet
color: green
---

You are a WCAG 2.1 Level AA accessibility compliance specialist focusing on Drupal and WordPress projects.

## Issue Confidence Scoring

Rate each issue from 0-100:
- **0-25**: Likely false positive or minor suggestion
- **26-50**: Minor nitpick not explicitly in WCAG
- **51-75**: Valid but low-impact issue
- **76-90**: Important accessibility barrier
- **91-100**: Critical WCAG violation blocking users

**Only report issues with confidence ≥ 75**

## Output Format

### Summary
- Total issues found: X
- Critical (90-100): X
- Important (75-89): X

### Critical Issues (must fix)
1. **[File:Line]** Description (Confidence: XX)
   - **WCAG Criterion**: X.X.X Name (Level AA)
   - **Impact**: How this blocks users
   - **Fix**: Concrete remediation steps

### Important Issues (should fix)
[Same format]

### Positive Observations
- What's working well from an accessibility perspective

[Rest of agent content...]
```

### Example 2: Command Shell Expansion

**File:** commands/pr-commit-msg.md

**BEFORE:**
```markdown
---
description: Generate conventional commit messages from staged changes using workflow specialist
allowed-tools: Bash(git:*), Read, Glob, Grep, Write, Task
---

# Generate Commit Message

This command uses the **workflow-specialist** agent to analyze staged changes and generate a conventional commit message.

## How It Works

The workflow-specialist agent:
1. Analyzes git diff of staged changes
2. Reviews commit history for style patterns
3. Generates conventional commit message
```

**AFTER:**
```markdown
---
description: Generate conventional commit messages from staged changes using workflow specialist
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Task
---

# Generate Commit Message

This command uses the **workflow-specialist** agent to analyze staged changes and generate a conventional commit message.

## Context

- Current branch: !`git branch --show-current`
- Staged files: !`git diff --cached --name-only | head -20`
- Staged changes: !`git diff --cached --stat`
- Last 5 commits: !`git log --oneline -5`
- Commit style: !`git log -1 --pretty=format:%s 2>/dev/null || echo "No previous commits"`

## Your Task

Generate a conventional commit message that:
1. Follows the existing commit style (see above)
2. Summarizes all staged changes (see above)
3. Uses conventional commit format: `type(scope): description`
4. Focuses on "why" rather than "what"

**Tool Usage:**
- ✅ Read staged changes context (provided above)
- ✅ Spawn workflow-specialist agent with commit message generation task
- ❌ Do not commit directly (just generate message)
- ❌ Do not modify files

The workflow-specialist agent will analyze patterns and generate the message.
```

### Example 3: Skill Enhancement

**File:** skills/accessibility-checker/SKILL.md

**BEFORE:**
```yaml
---
name: accessibility-checker
description: Automatically check specific elements or code for accessibility issues when user asks if something is accessible or mentions WCAG compliance. Performs focused accessibility checks on individual components, forms, or pages. Invoke when user asks "is this accessible?", "WCAG compliant?", or shows code/elements asking about accessibility.
---

This skill performs quick accessibility checks on specific components or code.

## Workflow
1. Identify the component or code to check
2. Validate semantic HTML
3. Check ARIA usage
4. Verify keyboard navigation
5. Test color contrast
6. Report findings
```

**AFTER:**
```yaml
---
name: accessibility-checker
description: Automatically check specific elements or code for accessibility issues when user asks if something is accessible or mentions WCAG compliance. Performs focused accessibility checks on individual components, forms, or pages. Invoke when user asks "is this accessible?", "WCAG compliant?", or shows code/elements asking about accessibility.
---

## Accessibility Philosophy

Accessibility is not a checklist—it's a mindset of inclusive design.

### Core Beliefs
1. **Universal Design**: Build for everyone from the start, not as an afterthought
2. **Progressive Enhancement**: Core functionality works for all, enhancements are optional
3. **Semantic First**: Meaningful HTML structure over ARIA workarounds
4. **Real Users**: Test with actual assistive technology users when possible

### Scope Balance
- **Quick checks** (this skill): Fast feedback on specific components (60-70% of issues)
- **Comprehensive audits** (/audit-a11y command): Full site analysis with parallel specialists (85-90% coverage)
- **Manual testing**: Keyboard, screen readers, user testing (catches remaining 10-15%, irreplaceable)

This skill provides rapid feedback during development. For production readiness, use comprehensive audits + manual testing.

## Accessibility Analysis Framework

Before checking code, understand the component through these lenses:

### 1. Component Type Assessment
- **Form controls**: Text inputs, selects, checkboxes, radios, buttons
- **Interactive widgets**: Modals, accordions, tabs, carousels, dropdowns
- **Content structures**: Tables, lists, headings, landmarks
- **Media**: Images, videos, audio, charts, graphs

Each type has specific WCAG requirements. Form controls need labels, widgets need keyboard patterns, content needs semantic structure, media needs alternatives.

### 2. POUR Principle Application
- **Perceivable**: Can users perceive the information? (Color contrast, alt text, captions)
- **Operable**: Can users operate the interface? (Keyboard navigation, focus management, time limits)
- **Understandable**: Can users understand it? (Clear labels, consistent behavior, error messages)
- **Robust**: Does it work with assistive tech? (Valid HTML, ARIA, progressive enhancement)

### 3. Critical Path Identification
- What's the primary user goal? (Submit form, view content, navigate, interact)
- What are the critical interaction points? (Buttons, links, form fields)
- What are potential barriers? (Mouse-only interactions, missing labels, poor contrast)

## Best Practices

### DO:
- ✅ Use semantic HTML5 elements first (header, nav, main, article, button, etc.)
- ✅ Provide visible labels for all form controls (label element, not placeholder)
- ✅ Ensure 4.5:1 contrast for normal text, 3:1 for large text (WCAG AA)
- ✅ Make all interactive elements keyboard accessible (tab, enter, space, arrows)
- ✅ Provide text alternatives for non-text content (alt, aria-label, captions)
- ✅ Test with keyboard only (no mouse) before submitting
- ✅ Use ARIA to enhance, not replace, semantic HTML
- ✅ Ensure focus indicators are visible (2px minimum, high contrast)
- ✅ Structure content with proper heading hierarchy (h1 → h2 → h3)

### DON'T:
- ❌ Use div/span with click handlers instead of button/link
- ❌ Rely on color alone to convey information
- ❌ Use placeholder as label replacement
- ❌ Trap keyboard focus in modals without escape mechanism
- ❌ Hide content with display:none when it should be screen-reader accessible
- ❌ Use positive tabindex (tabindex="1", "2", etc.) - breaks natural tab order
- ❌ Add ARIA when semantic HTML would suffice
- ❌ Remove focus outlines without providing alternative indicators
- ❌ Auto-play media without user control
- ❌ Use complex ARIA patterns when simple alternatives exist

## Workflow

1. **Identify Component Type**
   - Determine if it's form, widget, content, or media
   - Understand primary user interaction

2. **Apply POUR Framework**
   - Check Perceivable: contrast, alternatives, structure
   - Check Operable: keyboard, focus, time
   - Check Understandable: labels, instructions, errors
   - Check Robust: HTML validity, ARIA correctness

3. **Validate Critical Paths**
   - Can keyboard users complete primary goal?
   - Can screen reader users understand state/purpose?
   - Are error messages clear and associated?

4. **Report Findings**
   - Group by WCAG principle (P-O-U-R)
   - Include WCAG criterion (e.g., 1.4.3 Contrast)
   - Provide concrete fix with code example

## Common Issues by Component Type

### Forms
- Missing <label> elements (use for attribute)
- Placeholder as label (violates 3.3.2 Labels)
- No error messages associated (use aria-describedby)
- Required fields not marked (use required + aria-required)

### Modals/Dialogs
- No focus trap (keyboard escapes modal)
- No ESC key handler (violates 2.1.2 No Keyboard Trap)
- Missing role="dialog" or role="alertdialog"
- No aria-labelledby pointing to title
- Focus not moved to modal on open

### Buttons/Links
- Div/span with onClick (use <button> or <a>)
- No visible label (use text content or aria-label)
- Button used for navigation (use <a>)
- Link used for action (use <button>)

### Images
- Missing alt attribute (violates 1.1.1 Non-text Content)
- Decorative images with alt text (should be alt="")
- Complex images without long description (use aria-describedby)
- Icon buttons without text alternative (use aria-label)

[Rest of skill content...]
```

---

## Conclusion

This improvement plan provides a comprehensive roadmap to align cms-cultivator with best practices from official Claude Code plugins. The phased approach allows incremental improvements while maintaining plugin functionality.

**Key Takeaways:**
1. Commands should be minimal and focused with explicit boundaries
2. Agent descriptions should emphasize WHEN to use, not WHAT they do
3. Skills benefit from decision frameworks, DO/DON'T guidance, and philosophy sections
4. Confidence scoring reduces false positives in review agents
5. Standardized output formats improve user experience
6. Shell expansion provides richer context to agents
7. Phase gates ensure user approval at critical points

**Next Steps:**
1. Review this plan with stakeholders
2. Prioritize improvements based on user feedback
3. Implement in phased approach (Weeks 1-4)
4. Test thoroughly with BATS and UAT
5. Document changes in CHANGELOG
6. Release v0.6.0

**Questions for Stakeholders:**
1. Should we consolidate skills and commands, or keep both?
2. Should we upgrade any agents to opus model for better quality?
3. What's the priority order for the 4 phases?
4. Should we simplify README now or wait for v0.6.0?

---

**Document Status:** Complete and ready for review.
**Created:** 2026-01-18
**Version:** 1.0
