# Slash commands → Skills: what changed and why

> **The core shift:** Slash commands required explicit invocation by the user. Skills are loaded automatically — Claude scans available skills and pulls in the right one based on task context. No `/command` syntax needed.

Agent Skills launched October 2025 and replaced custom slash commands as the primary extensibility model for Claude Code plugins and OpenAI Codex plugins.

---

## What Skills are

A Skill is a folder containing a `SKILL.md` file plus any supporting scripts and resources. Claude loads only the minimal content from a relevant skill when needed, keeping response quality high without bloating context.

| Property | Description |
|---|---|
| **Composable** | Multiple skills stack automatically. Claude identifies which are needed and coordinates them. |
| **Portable** | Same format everywhere — Claude apps, Claude Code, and the API all use the same skill structure. |
| **Efficient** | Only loads what's needed, when it's needed. Context is not polluted with unused instructions. |
| **Executable** | Skills can include runnable code for tasks where traditional programming is more reliable than token generation. |

---

## Two kinds of skills

Understanding which type you're building affects how you write and test it.

### Type 1: Capability uplift

Helps Claude do something it can't do consistently on its own — e.g. the document-creation skills (`docx`, `pptx`, `pdf`). These may become less necessary as base models improve. Evals can tell you when that's happened and the skill is no longer needed.

### Type 2: Encoded preference

Claude can already do each individual step; the skill sequences them according to your team's specific workflow — e.g. NDA review against set criteria, or generating CMS block patterns from a Figma design. These are more durable over time. Evals verify fidelity to the actual workflow.

---

## Installing skills

### Claude Code

Skills in Claude Code are installed in one of two ways:

- Via **plugins** from the `anthropics/skills` marketplace
- Manually by placing skill folders in `~/.claude/skills`

Claude loads them automatically when relevant. Skills can be shared across a team through version control — just commit the skill folder.

### OpenAI Codex

Skills in Codex are distributed as part of plugins. Install a plugin via the Codex plugin browser (`codex/plugins`) or CLI (`codex plugin marketplace add owner/repo`), and its bundled skills become available automatically. Codex loads skills from the `skills/` directory specified in `.codex-plugin/plugin.json`.

Skills activate by natural language context, or invoke them explicitly with `@skill-name` in the prompt.

---

## Plugin structure: the container for skills and agents

The **plugin** is the distribution and installation unit — it's what gets installed via `claude plugins install` and what lives in version control. Skills and agents are the functional components that live inside it.

| Layer | Role |
|---|---|
| **Plugin** | Container/package — handles installation, versioning, and scoping (project-level or global) |
| **Skills** | Encoded workflow knowledge — `SKILL.md` files that Claude pulls in automatically when context matches |
| **Agents** | Autonomous, goal-directed task runners — can use tools and execute multi-step workflows independently |

This means a plugin like `cms-cultivator` is the right home for *both* skills and agents. They serve different purposes within the same package:

- **Skills** handle context-triggered, Claude-assisted tasks — e.g. generating a WordPress block pattern from a Figma design, or scaffolding a Drupal paragraph type from a screenshot. Claude loads these automatically when it recognizes the task.
- **Agents** handle heavier workflows that need to run autonomously — e.g. auditing all blocks in a theme for accessibility, or migrating templates to FSE format. A subagent is spun up with a clear goal and the tools it needs to complete it.

One important implication: skills distributed inside a plugin use the same description-matching mechanism as standalone skills. The description precision work that skill-creator helps with (see below) applies equally to plugin-bundled skills. Running the description optimizer across plugin skills is worthwhile after any significant edits or after a model update.

---

## Testing and maintaining skills with skill-creator

Skill-creator (available as a Claude Code plugin and for OpenAI Codex) adds software-development rigor to skill authoring — no code required.

### Evals

Define test prompts, describe what good output looks like, and skill-creator checks whether the skill holds up. Two primary uses:

- Catching regressions after model updates
- Knowing when base model capabilities have outgrown a capability-uplift skill (it passes evals without the skill loaded)

### Benchmark mode

Runs a standardized assessment tracking eval pass rate, elapsed time, and token usage. Run it after model updates or after editing a skill. Results can be stored locally, piped to a dashboard, or integrated with CI.

### Multi-agent eval runs

Evals run in parallel using independent agents — each in a clean context with its own metrics. Comparator agents support A/B testing of two skill versions (or skill vs. no skill), judging outputs without knowing which is which.

### Description optimization

Skill-creator analyzes your skill description against sample prompts and suggests edits that reduce both false positives and false negatives. This is the key lever for reliable triggering — too broad and unrelated tasks load the skill, too narrow and it never fires.

---

## Looking ahead

Today a `SKILL.md` tells Claude *how* to do something. As models improve, a plain description of *what* the skill should do may be sufficient — with the model working out the rest. The eval framework is a step in that direction: evals already describe the "what."

---

## Official docs and resources

### Blog posts

- [Introducing Agent Skills (Oct 2025)](https://claude.com/blog/skills) — The launch post covering the full architecture, how skills work across all Claude products, and getting started links.
- [Improving skill-creator: Test, measure, and refine Agent Skills (Mar 2026)](https://claude.com/blog/improving-skill-creator-test-measure-and-refine-agent-skills) — Covers evals, benchmark mode, multi-agent testing, and description optimization.
- [Improving frontend design through Skills (Nov 2025)](https://claude.com/blog/improving-frontend-design-through-skills) — Real-world example of a capability-uplift skill improving Claude's design output quality.
- [Engineering blog: Agent Skills architecture deep-dive](https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills) — Design patterns, architecture, and development best practices from the Anthropic engineering team.

### Documentation

- [Claude Code Skills docs](https://docs.claude.com/en/docs/claude-code/skills) — Installing, building, and sharing skills specifically within Claude Code.
- [Agent Skills overview (API docs)](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview) — Full reference covering the Skills format, the `/v1/skills` endpoint, and Code Execution Tool requirements.
- [User guide: Teach Claude your workflow using Skills](https://support.claude.com/en/articles/12580051-teach-claude-your-way-of-working-using-skills) — End-user guide for creating and managing skills in Claude apps.

### GitHub repos

- [anthropics/skills](https://github.com/anthropics/skills) — Official skills repo — Anthropic's public skills including `docx`, `pptx`, `pdf`, `skill-creator`, and examples to customize.
- [skill-creator plugin for Claude Code](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator) — Install this plugin to get skill authoring, evals, benchmarking, and description optimization directly in Claude Code.
- [skill-creator skill source](https://github.com/anthropics/skills/tree/main/skills/skill-creator) — The skill-creator skill itself — useful for understanding how Anthropic structures their own skills.
