---
description: Generate conventional commit messages from staged changes
allowed-tools: Bash(git:*), Read, Glob
---

# Generate Commit Messages

Generate conventional commit messages from staged changes following best practices.

## Quick Start

```bash
# 1. Stage your changes
git add .

# 2. Run this command
/pr-commit-msg

# Claude will:
# - Analyze your staged changes
# - Review recent commit style
# - Generate conventional commit message
# - Present for your approval
```

## How It Works

This command uses the **commit-message-generator** Agent Skill to generate commit messages.

**For complete workflow and technical details**, see:
→ [`skills/commit-message-generator/SKILL.md`](../skills/commit-message-generator/SKILL.md)

The skill provides detailed instructions for:
- Analyzing git staged changes
- Determining commit type (feat, fix, docs, etc.)
- Identifying appropriate scope
- Generating conventional commit message format
- Platform-specific patterns for Drupal and WordPress

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

Co-Authored-By: Claude <noreply@anthropic.com>
```

## Related Commands

- **[`/pr-create`](pr-create.md)** - Create PR with generated description
- **[`/pr-review self`](pr-review.md)** - Review your changes before committing

## Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [commit-message-generator Agent Skill](../skills/commit-message-generator/SKILL.md)
