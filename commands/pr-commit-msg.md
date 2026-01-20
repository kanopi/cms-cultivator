---
description: Generate conventional commit messages from staged changes using workflow specialist
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Task
---

## Context

- **Current branch**: !`git branch --show-current`
- **Staged files**: !`git diff --cached --name-only | head -20`
- **Staged changes summary**: !`git diff --cached --stat`
- **Last 5 commits**: !`git log --oneline -5`
- **Recent commit style**: !`git log -1 --pretty=format:%s 2>/dev/null || echo "No previous commits"`

## Your Task

Generate a conventional commit message that:
1. Follows the existing commit style (see above)
2. Summarizes all staged changes (see above)
3. Uses conventional commit format: `type(scope): description`
4. Focuses on "why" rather than "what"

## Tool Usage

**Allowed operations:**
- ✅ Read staged changes context (provided above)
- ✅ Spawn workflow-specialist agent with commit message generation task
- ✅ Present generated commit message to user for approval

**Not allowed:**
- ❌ Do not commit directly (just generate message)
- ❌ Do not modify files
- ❌ Do not push to remote

The workflow-specialist agent will perform all generation operations.

## Workflow-Specialist Agent

Spawn the **workflow-specialist** agent using:

```
Task(cms-cultivator:workflow-specialist:workflow-specialist,
     prompt="Generate a conventional commit message from the user's staged changes. Use the context provided above (branch, staged files, commit history). Analyze the changes, review recent commit style for consistency, and create a properly formatted commit message following Conventional Commits specification.")
```

The workflow specialist will:
1. Use the context provided above (git status, diff, history)
2. Apply the **commit-message-generator** skill
3. Generate a conventional commit message (feat, fix, refactor, etc.)
4. Include appropriate scope and detailed body
5. Add CMS-specific context (Drupal/WordPress patterns)
6. **Present the FULL commit message for your approval or edits**
7. Execute commit with approved message (without "Co-Authored-By: Claude...")
8. **Suggest running `/pr-create`** as the next step

## How It Works

This command uses **shell expansion** (`!`) to inject live git context, then spawns the **workflow-specialist** agent, which uses the **commit-message-generator** Agent Skill.

**For complete technical details about the commit-message-generator skill**, see:
→ [`skills/commit-message-generator/SKILL.md`](../skills/commit-message-generator/SKILL.md)

## When to Use

**Use this command (`/pr-commit-msg`)** when:
- ✅ You want explicit control over commit message generation
- ✅ Working through multiple commits in batch
- ✅ Need structured commit workflow

**The skill auto-activates** when you say:
- "I need to commit my changes"
- "What should my commit message be?"
- "Ready to commit"

## Example Output

```
feat(auth): add two-factor authentication support

- Implement TOTP-based 2FA
- Add backup codes generation
- Include recovery flow for lost devices
- Update user profile settings UI
```

## Related Commands

- **[`/pr-create`](pr-create.md)** - Create PR with generated description
- **[`/pr-review self`](pr-review.md)** - Review your changes before committing
