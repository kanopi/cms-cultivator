---
name: commit-message-generator
description: Automatically generate conventional commit messages when user has staged changes and mentions committing. Analyzes git diff and status to create properly formatted commit messages following conventional commits specification, and appends the Assisted-by git trailer recording which AI model (Claude, GPT, Gemini, or any other LLM) assisted the change. Invoke when user mentions "commit", "staged", "committing", or asks for help with commit messages.
---

# Commit Message Generator

Automatically generate conventional commit messages for staged changes.

## Philosophy

Commit messages are the history and documentation of your code's evolution.

### Core Beliefs

1. **Commits Tell a Story**: Each commit should explain what changed and why
2. **Conventional Format Enables Automation**: Structured messages power changelogs and semantic versioning
3. **Clarity Over Brevity**: A clear 2-line message beats a cryptic 5-word one
4. **Context Matters**: Messages should be understandable months later without additional context

### Why Conventional Commits

- **Automated Changelogs**: Generate release notes from commit history
- **Semantic Versioning**: Determine version bumps (major/minor/patch) automatically
- **Better Searchability**: Find specific types of changes quickly
- **Team Communication**: Consistent format aids code review and collaboration

## When to Use This Skill

Activate this skill when the user:
- Mentions "commit", "committing", "staged changes", or "ready to commit"
- Shows `git add` or `git status` output with staged changes
- Asks "what should my commit message be?"
- Says "I need to commit my changes"
- Asks for help writing commit messages

## Decision Framework

Before generating a commit message, ask yourself:

### Is This Ready to Commit?

- ✅ **Yes** - Staged changes represent a single logical unit of work
- ❌ **No** - Multiple unrelated changes staged → Suggest splitting into separate commits
- ⚠️ **Maybe** - Large changeset → Review to ensure it's cohesive

### What Type of Change Is This?

1. **New functionality** → `feat` type
2. **Bug fix** → `fix` type
3. **Code improvement without behavior change** → `refactor` type
4. **Documentation only** → `docs` type
5. **Tests only** → `test` type
6. **Multiple types** → Suggest splitting commits

### What Scope Makes Sense?

- **Module/component name** - For focused changes (e.g., `auth`, `api`, `ui`)
- **Feature area** - For cross-cutting changes (e.g., `validation`, `logging`)
- **No scope** - For global changes (e.g., dependencies, config)

### Should This Be Multiple Commits?

Split if staged changes include:
- ✅ Unrelated features or fixes
- ✅ Refactoring + new feature (split: refactor first, feature second)
- ✅ Multiple bug fixes
- ❌ Feature + tests (keep together)
- ❌ Feature + documentation (keep together)

### Decision Tree

```
User mentions commit
    ↓
Check: Staged changes?
    ↓ Yes
Check: Multiple unrelated changes?
    ↓ No
Check: Follows conventional commits pattern?
    ↓ Generate message
    ↓
Review with user → Commit
```

## Workflow

### 1. Check for Staged Changes

```bash
git status
git diff --staged
```

If no staged changes, inform the user and suggest staging files first.

### 2. Analyze Recent Commits for Style

```bash
git log --oneline -10
```

Learn the repository's commit message conventions.

### 3. Generate Conventional Commit Message

**Format**: `<type>(<scope>): <description>`

**Types**:
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes (formatting, semicolons, etc.)
- `refactor` - Code refactoring (no functional changes)
- `test` - Adding or updating tests
- `chore` - Build process, dependency updates, etc.
- `perf` - Performance improvements
- `ci` - CI/CD changes

**Example**:
```
feat(auth): add two-factor authentication support

- Implement TOTP-based 2FA
- Add backup codes generation
- Include recovery flow for lost devices
- Update user profile settings UI
```

### 4. Drupal/WordPress-Specific Patterns

**Drupal**:
- Config changes: `feat(config): add user profile field configuration`
- Module work: `fix(custom_module): correct permission check in access callback`
- Hooks: `refactor(hooks): simplify hook_form_alter implementation`

**WordPress**:
- Theme work: `style(theme): improve mobile navigation styles`
- Plugin work: `fix(plugin): correct ACF field validation`
- Blocks: `feat(blocks): add testimonial Gutenberg block`

### 5. Append the Assisted-by Trailer

When AI assisted in producing the **change itself** (not merely this commit
message), append an `Assisted-by:` git trailer as the last block of the
message — the per-commit provenance convention adopted by the Linux kernel,
Fedora, and the OpenInfra Foundation. The per-PR complement is the Delivery
Record ([kanopi/delivery-record](https://github.com/kanopi/delivery-record)).

**Format** — `Assisted-by: <Vendor>/<model-id>`, using whichever assistant
actually did the work. This is deliberately vendor-neutral:

```
Assisted-by: Claude/claude-fable-5
Assisted-by: OpenAI/gpt-5.4-codex
Assisted-by: Google/gemini-3-pro
```

Rules:

- Identify the current session's model from your own runtime context; never
  guess or hardcode a model name. One trailer line per assisting model if
  more than one contributed.
- Place trailers at the end of the message, after any `Refs:` /
  `BREAKING CHANGE:` footers, so `git interpret-trailers` and
  `git log --grep="^Assisted-by:"` work.
- **Skip the trailer** when the change was written entirely by a human and
  AI only helped phrase this commit message — the trailer attests to the
  change, not the prose. Also skip on explicit request (`--no-assisted-by`).
- This trailer replaces `Co-Authored-By` for AI attribution — never add
  `Co-Authored-By: Claude…` (or any AI co-author line) to commit messages.

The audit trail this enables:

```bash
git log --grep="^Assisted-by:"        # every AI-assisted commit
git log --grep="^Assisted-by: Claude" # by vendor
```

### 6. Present to User for Approval

Show the generated commit message in a clear code block and ask:

> "Here's a commit message based on your staged changes. Would you like me to commit with this message, or would you like to modify it?"

Wait for explicit user approval (e.g., "approve", "yes, commit", or an edited version) before running `git commit`.

### 7. Execute Commit (only after approval)

```bash
git commit -m "commit message here"
```

Or for multi-line messages:
```bash
git commit -m "$(cat <<'EOF'
feat(auth): add two-factor authentication support

- Implement TOTP-based 2FA
- Add backup codes generation
- Include recovery flow

Refs: PROJ-123
Assisted-by: Claude/claude-fable-5
EOF
)"
```

## Integration with CMS Cultivator

This skill is invoked directly by the main session when the user mentions committing — there is no orchestrator agent in between. The skill works the same way whether triggered conversationally ("I'm ready to commit") or explicitly ("generate a commit message").

The companion **`pr-create`** skill picks up where this one ends — once you've committed, ask to "create a PR" and `pr-create` will generate the PR description from your commits. The `Assisted-by:` trailers this skill writes are the per-commit half of Kanopi's provenance model; the per-PR half is the Delivery Record ([kanopi/delivery-record](https://github.com/kanopi/delivery-record)).

## Best Practices

1. **Analyze the actual changes** - Don't just use file names, understand what changed
2. **Be specific in scope** - Use module name, component name, or feature area
3. **Include breaking changes** - Add `BREAKING CHANGE:` footer if applicable
4. **Reference tickets** - Include ticket numbers if found in branch name
5. **Follow project conventions** - Match the existing commit style

## Example Interactions

**Example 1: Simple fix**
```
User: "I fixed the login bug, ready to commit"
[Skill analyzes git diff]
Skill: "I'll generate a commit message for your login fix..."

Generated:
fix(auth): resolve session timeout on remember-me login

- Correct cookie expiration logic
- Add test coverage for remember-me flow

Assisted-by: Claude/claude-fable-5

Would you like me to commit with this message?
```

**Example 2: Feature addition**
```
User: "Staged my changes, need to commit"
[Skill analyzes extensive changes]
Skill: "I see you've added a new dashboard widget. Here's a commit message..."

Generated:
feat(dashboard): add performance metrics widget

- Create new widget component
- Add database query for metrics
- Include responsive design
- Add widget to admin dashboard page
```

## Resources

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit)
- [Semantic Commit Messages](https://gist.github.com/joshbuchea/6f47e86d2510bce28f8e7f42ae84c716)
