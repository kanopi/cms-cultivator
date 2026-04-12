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
     prompt="Generate a conventional commit message from the user's staged changes. First, gather git context by running: git status, git diff --cached (for staged changes), git log (for recent commit history). Analyze the changes, review recent commit style for consistency, and create a properly formatted commit message following Conventional Commits specification. CRITICAL OUTPUT FORMAT: Your response must START IMMEDIATELY with '=== COMMIT MESSAGE READY FOR APPROVAL ===' followed by the commit message. DO NOT write ANY text before this header. NO context, NO summaries, NO explanations like 'I've analyzed...' or 'Good, GitHub CLI...'. Your ENTIRE response must be ONLY: 1. The header '=== COMMIT MESSAGE READY FOR APPROVAL ===' 2. The complete commit message in a code block 3. The separator '===================================' 4. The approval request 'Reply \"approve\" to commit with this message, or provide your edits.' NOTHING ELSE. No preamble, no summary, no analysis notes.")
```

### Your Role as Main Agent

**CRITICAL:** When you receive output from the workflow-specialist:

1. **If the output starts with `=== COMMIT MESSAGE READY FOR APPROVAL ===`:**
   - Present it DIRECTLY to the user WITHOUT any additional commentary
   - Do NOT add "Let me show you" or "Here's what was generated"
   - Do NOT explain what happened or provide context
   - Simply output the workflow-specialist's response verbatim

2. **Wait for user response** (approve/edits)

3. **Resume the workflow-specialist agent** with the user's response using the agentId

The workflow specialist will:
1. Gather git context (status, staged diff, commit history)
2. Apply the **commit-message-generator** skill
3. Generate a conventional commit message (feat, fix, refactor, etc.)
4. Include appropriate scope and detailed body
5. Add CMS-specific context (Drupal/WordPress patterns)
6. **Present ONLY the complete commit message** - NO summaries, NO explanations, ONLY the message and approval request
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
