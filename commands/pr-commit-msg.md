---
description: Generate conventional commit messages from staged changes using workflow specialist
allowed-tools: Task
---

I'll use the **workflow specialist** agent to generate a conventional commit message from your staged changes.

The workflow specialist will:
1. Analyze your staged changes (`git status`, `git diff`)
2. Review recent commit style for consistency
3. Apply the **commit-message-generator** skill
4. Generate a conventional commit message (feat, fix, refactor, etc.)
5. Include appropriate scope and detailed body
6. Add CMS-specific context (Drupal/WordPress patterns)
7. Present the message for your approval

## How It Works

This command spawns the **workflow-specialist** agent, which uses the **commit-message-generator** Agent Skill to analyze staged changes and create properly formatted commit messages following the [Conventional Commits specification](https://www.conventionalcommits.org/).

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

🤖 Generated with Claude Code

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

## Related Commands

- **[`/pr-create`](pr-create.md)** - Create PR with generated description
- **[`/pr-review self`](pr-review.md)** - Review your changes before committing

## Agent Used

**workflow-specialist** - Orchestrates commit message generation using the commit-message-generator skill.
