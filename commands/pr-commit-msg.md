---
description: Generate conventional commit messages from staged changes using workflow specialist
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*), Task
---

## Your Task

Generate a conventional commit message by spawning the workflow-specialist agent, which will:
1. Analyze current git status and staged changes
2. Review recent commit history for style consistency
3. Create a conventional commit message following the format: `type(scope): description`
4. Focus on "why" rather than "what"

## Tool Usage

**Allowed operations:**
- ✅ Spawn workflow-specialist agent with commit message generation task
- ✅ Present generated commit message to user for approval

**Not allowed:**
- ❌ Do not commit directly (just generate message)
- ❌ Do not modify files
- ❌ Do not push to remote

The workflow-specialist agent will gather git context and perform all generation operations.

## Workflow-Specialist Agent

Spawn the **workflow-specialist** agent using:

```
Task(cms-cultivator:workflow-specialist:workflow-specialist,
     prompt="Generate a conventional commit message from the user's staged changes. First, gather git context by running: git status, git diff --cached (for staged changes), git log (for recent commit history). Analyze the changes, review recent commit style for consistency, and create a properly formatted commit message following Conventional Commits specification.")
```

The workflow specialist will:
1. Gather git context (status, staged diff, commit history)
2. Apply the **commit-message-generator** skill
3. Generate a conventional commit message (feat, fix, refactor, etc.)
4. Include appropriate scope and detailed body
5. Add CMS-specific context (Drupal/WordPress patterns)
6. **Present the FULL commit message for your approval or edits**
7. Execute commit with approved message (without "Co-Authored-By: Claude...")
8. **Suggest running `/pr-create`** as the next step

## How It Works

This command spawns the **workflow-specialist** agent, which gathers git context and uses the **commit-message-generator** Agent Skill to generate conventional commit messages.

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
