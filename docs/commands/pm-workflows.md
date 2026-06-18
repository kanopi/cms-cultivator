# PM Workflows

Four PM-focused skills that pull context from connected MCP servers (Teamwork, Slack, Gmail, Fathom, CoWork) to handle client communication, meeting preparation, status updates, and QA review.

!!! warning "MCP servers required"
    These skills rely on connected MCP servers to gather context. Without the relevant MCPs configured, they cannot fetch tasks, messages, recordings, or browser sessions. Set up the MCPs in your Claude Code or Claude Desktop configuration before invoking.

---

## Available Skills

### client-request-triage

**Purpose:** PM triage of a client Teamwork task or comment — researches solutions and drafts a client-facing reply before developer involvement.

**Auto-invoked triggers:** "triage this", "look at this Teamwork task", "help me respond to this client", "draft a reply to this"

**MCP dependencies:**

- **Teamwork MCP** — fetches the task, description, and comments
- **Web search** — researches 1–3 implementation options (Drupal modules, WordPress plugins, or general web patterns)

**Workflow:**

1. Fetches the task and identifies client vs. internal comments
2. Detects the platform (Drupal/WordPress/general web)
3. Researches relevant solution options
4. Presents a summary with the recommended approach and pauses for PM confirmation
5. Drafts a warm, professional client-facing reply — no estimates, no internal jargon

**Special behavior:** If the task is clearly a bug report rather than a feature request or question, the skill stops and asks the PM how to proceed before continuing.

---

### pm-meeting-prep

**Purpose:** Prepare a PM for an upcoming client check-in by aggregating context from across the project.

**Auto-invoked triggers:** "prep me for my meeting", "check-in with [client] tomorrow", "meeting prep for [project]", "what do I need to know before my call?"

**MCP dependencies:**

- **Teamwork MCP** — recent tasks, status changes, project messages
- **Slack MCP** — recent channel activity (channel searched by project name)
- **Gmail MCP** — recent client email threads
- **Fathom MCP** — summaries of recent recorded meetings

**Output sections:**

- Progress since last meeting
- In-progress / ongoing work (with blockers flagged)
- Talking points (3–6 items needing conversation)
- New feature requests / scope discussions
- Blockers and concerns
- Suggested next steps

After presenting the briefing, the skill optionally generates a formatted meeting agenda on request.

---

### project-heartbeat

**Purpose:** Draft a client-facing project status update message ready to post as a Teamwork reply.

**Auto-invoked triggers:** "draft the heartbeat", "time for a project update", "send a status update for [project]", "write the update for [project]"

**MCP dependencies:**

- **Teamwork MCP** — completed tasks, project messages, heartbeat message thread replies
- **Slack MCP** — substantive project channel messages within the reporting window
- **Fathom MCP** — summaries of meetings during the reporting window

**Workflow:**

1. Confirms the project (inferred from the named Claude Project when possible)
2. Finds the existing heartbeat message thread and reads its most recent reply to determine the reporting window start
3. Pulls activity from Teamwork, Slack, and Fathom in parallel for the window
4. Drafts the update in Andrew's established voice: warm, progress-forward, transparent
5. Leaves explicit placeholders for budget and timeline (these are not pulled automatically)

!!! note "Voice"
    `project-heartbeat` is written in Andrew Nichols's personal voice (warm/collegial opener, narrative paragraphs, signed "Cheers, Andrew"). Other PMs are welcome to use the skill — adjust the signature and tone after the draft is generated to match your own voice.

---

### qa-review

**Purpose:** Full QA validation of a multidev environment from a Teamwork task — reads context, builds a validation plan, executes it in a browser, and produces a structured report.

**Auto-invoked triggers:** "QA this", "validate this multidev", "test the dev link", "run QA on [task]", "review this ticket"

**MCP dependencies:**

- **Teamwork MCP** — fetches the task, description, all comments, and the multidev URL
- **CoWork browser automation** — navigates the multidev environment, executes validation steps, captures screenshots

**Workflow:**

1. Reads the Teamwork task and all comments; extracts the multidev URL (Pantheon, WP Engine, Kinsta, etc.)
2. Detects the platform (Drupal vs. WordPress) from task content, URLs, or plugin/module names
3. Builds a validation plan: base checklist + dynamic steps based on the task type (update, bug fix, new feature)
4. Executes each step via CoWork, capturing screenshots and pass/fail/warning results
5. Produces a structured report: overall result, step-by-step results table, issues with screenshots, internal notes, and a client-facing summary

!!! warning "CoWork dependency"
    `qa-review` cannot execute validation steps without CoWork browser automation. Without it, the skill will produce the validation plan but not the report.

---

## When to Use These Skills

### Use `client-request-triage` when:

- A client posts a new task or comment requesting a feature or asking a question
- You need to understand what's being asked and what the realistic options are
- You want a polished reply ready to send back before looping in a developer

### Use `pm-meeting-prep` when:

- A scheduled client check-in is coming up
- You need a single briefing that pulls from every project context source
- You want a meeting agenda template based on real recent activity

### Use `project-heartbeat` when:

- It's time to send a recurring project status update
- You have a long-running "Project Update" message thread in Teamwork and need to draft the next reply
- You want a draft that reflects actual completed work and meeting outcomes without manual aggregation

### Use `qa-review` when:

- A developer hands off a task on a multidev environment and you need to validate before merging
- You want a structured report with both internal notes and a client-facing summary
- Browser automation is available (CoWork connected)

---

## MCP Setup Notes

Configure these MCPs in your Claude Code or Claude Desktop client to use the PM skills:

| Skill | Required MCPs |
|-------|----------------|
| `client-request-triage` | Teamwork + web search |
| `pm-meeting-prep` | Teamwork + Slack + Gmail + Fathom |
| `project-heartbeat` | Teamwork + Slack + Fathom |
| `qa-review` | Teamwork + CoWork browser automation |

If a non-blocking source returns no results (e.g., Fathom has no recent meetings), the skills note it and continue with the remaining sources rather than failing.

---

## Next Steps

- **[Agents & Skills](../agents-and-skills.md)** — How skills auto-activate from natural language
- **[Project Management Skills](project-management.md)** — Teamwork task creation and audit export
- **[Project Planning](planning.md)** — FRD, story point, and CSV export skills
