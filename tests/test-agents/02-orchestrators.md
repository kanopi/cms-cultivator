# Test 02: Orchestrator Agents (Retired)

As of CMS Cultivator 2.0 there are **no orchestrating agents**. Every remaining
agent is a leaf agent — none has the Task tool, and no agent spawns another
agent.

What replaced the old orchestration tests:

- **testing-specialist** no longer coordinates with other specialists. It
  generates security-focused and accessibility-focused test scenarios inline
  using its own tools. See Test 1.2 in `01-leaf-specialists.md` and Test 4.2
  in `04-orchestration.md`.
- **Design pipeline** — the `design-to-wp-block` and
  `design-to-drupal-paragraph` skills spawn `design-specialist`, then
  `responsive-styling-specialist` and `browser-validator-specialist`
  sequentially from the **main session** (the invoking skill spawns them, not
  an agent). See Test 4.3 in `04-orchestration.md`.
- The audit specialists and their orchestration workflows moved to separate
  internal Kanopi libraries and are no longer tested here.

This file is retained only so historical links resolve. All current
orchestration-pattern tests live in `04-orchestration.md`.
