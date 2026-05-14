---
name: project-heartbeat
description: >
  Generate a client-facing project heartbeat / status update message for a Kanopi project,
  ready to be posted as a Teamwork message. Use this skill whenever the user asks to write,
  draft, generate, or send a project update, heartbeat, status update, or progress report
  to a client. Also triggers when the user says things like "time for a project update",
  "draft the heartbeat", "write up the update for [project]", or "it's been two weeks,
  let's send an update". Always use this skill — even if the user doesn't say "heartbeat"
  — whenever the intent is to summarise recent project activity for a client audience.
---

# Project Heartbeat Skill

Generate a polished, client-facing Teamwork project update message by pulling recent
activity from Teamwork and Fathom, then drafting it in Andrew's established voice and format.

---

## Step 1 — Confirm the Project

If the conversation is happening inside a named Claude Project, infer the project from that
context and confirm with the user before proceeding:

> "I'll draft a heartbeat for **[Project Name]** — is that right?"

If the project is ambiguous or not obvious, ask directly:

> "Which Teamwork project should I pull the heartbeat for?"

Once confirmed, look up the project in Teamwork to get its `project_id`.

---

## Step 2 — Find the Last Heartbeat & Set the Reporting Window

> ⚠️ **Critical:** Heartbeat updates are posted as **replies to a single long-running message thread**, not as separate messages. The parent message may have been created months ago — its date is irrelevant. You must look at the **replies**, not the parent.

Using the Teamwork MCP:

1. Use `list_messages` to find the project's heartbeat/update message thread (typically titled "Project Update" or similar).
2. Once you have the message ID, use `list_message_replies` with that message ID to fetch all replies.
3. Find the **most recent reply** by sorting replies by `createdAt` descending and taking the first result.
4. The **reporting window start** is the `createdAt` of that most recent reply.

**Do not use the parent message's `createdAt` under any circumstances.** The parent is just the thread container — the actual updates live in the replies.

Before moving to Step 3, confirm the window with the user:

> "The last heartbeat reply was posted on **[createdAt of most recent reply]**. I'll pull activity from then through today ([TODAY]). Does that look right?"

Wait for confirmation before proceeding.

- **Reporting window start**: `createdAt` of the most recent reply in the heartbeat thread
- **Reporting window end**: today's date

If the message thread has no replies at all, fall back to the parent message's `createdAt` and note this is effectively the first update since the thread was opened.

---

## Step 3 — Gather Data (run these in parallel where possible)

> Use **Teamwork MCP** tools for all Teamwork data (projects, tasks, messages).
> Use **Fathom MCP** tools for all meeting data.

### 3a. Teamwork — Completed Tasks
Use the Teamwork MCP to pull all tasks completed within the reporting window for the project.
Group them loosely by theme or tasklist (e.g. Discovery, Technical, UX, Content).
Focus on tasks that would be meaningful to a client — skip purely internal admin tasks.

### 3b. Teamwork — Recent Messages
Use the Teamwork MCP to pull project messages from the reporting window. Scan for:
- Key decisions made
- Items shared with the client
- Open questions or action items flagged
- Any blockers or risks mentioned

### 3c. Fathom — Recent Meeting Summaries
Use the Fathom MCP to search for meetings associated with this project during the reporting window.
From each meeting, extract:
- Key topics discussed
- Decisions or outcomes
- Action items (especially ones assigned to Kanopi)
- Any blockers or risks raised

### 3d. Slack — Project Channel
Use the Slack MCP to find and read the project's Slack channel. The channel name is typically
just the client name (e.g. `#smalley` for the Smalley project, `#acme` for an Acme project).

1. Use `slack_search_channels` to find the channel by the client/project name if the channel ID isn't already known.
2. Use `slack_read_channel` to read messages within the reporting window. Filter to messages
   that fall between the reporting window start date and today.
3. Scan the messages for:
   - Key decisions or agreements made
   - Items flagged as blockers or risks
   - Action items assigned to either side
   - Any context that didn't make it into Teamwork or meetings
4. Ignore emoji reactions, bot messages, and purely social exchanges — focus on substantive
   project communication only.

If no matching channel is found, skip this step silently and proceed with the other sources.

### 3e. SOW / Project Context (if available)
If a Statement of Work or project brief has been added to this Claude Project as context,
use it to:
- Understand the project phases and deliverables
- Correctly label budget line items
- Frame "Looking Ahead" items against upcoming deliverables

### 3f. Budget
Budget data is **not pulled automatically** — leave a clear placeholder in the draft:

```
[BUDGET TABLE — Please fill in manually:
 Reporting Period: Thru [DATE]
 Total Hours Used: [X]
 Table: Item | Hours Allocated | Hours Used | Hours Remaining | Notes]
```

---

## Step 4 — Draft the Message

Use the structure and tone from the reference examples below. Write in Andrew's voice:
warm, professional, client-focused, concise. Avoid internal jargon. Do not mention
specific team member names unless they were already shared with the client.

### Message Structure

```
@[Client contacts]

[Opening paragraph — 2–4 sentences]
Warm opener referencing where the project is at. High-level summary of the period's
momentum. Keep it energetic but grounded.

[1–2 body paragraphs]
Narrative summary of what happened. Weave together completed work, meeting outcomes,
and key decisions. Don't just list — tell the story of progress.

---

### Budget
Reporting Period: Thru [DATE]

Total Hours Used: [X]

[BUDGET TABLE PLACEHOLDER]

---

### Timeline
- Projected Completion Date: [from SOW or previous update]

---

### Recent Highlights
- [Bullet per meaningful completed item, decision, or milestone]
- Keep to 6–10 bullets max
- Client-facing language only

---

### Looking Ahead
- [Bullet per upcoming task, next step, or open item needing client input]
- Flag any items requiring client action clearly

---

Please let me know if there are any items we may have missed or if there is anything
you would like to discuss in additional detail.

Cheers,

Andrew
```

---

## Step 5 — Present the Draft

Show the full draft in the chat as a clean, readable message (not HTML).
Below the draft, add a short **"Sources Used"** summary — e.g.:

> **Sources used:** 12 completed tasks (Apr 22–May 7), 3 Fathom meeting summaries
> (Apr 23, Apr 28, May 1), 4 Teamwork messages, 18 Slack messages (#smalley). Budget table left blank for manual entry.

Then ask:
> "Want me to adjust the tone, add/remove anything, or post this to Teamwork once you're happy?"

---

## Tone & Voice Reference

Based on Andrew's existing updates, the tone should be:

- **Warm and collegial** — "Hope you're both doing well!", "It's been a pleasure…"
- **Progress-forward** — emphasise momentum, not just task completion
- **Transparent** — flag blockers or redirected scope clearly and without alarm
- **Action-oriented** — "Looking Ahead" should feel like a confident plan, not a vague list
- **Concise** — paragraphs are 3–5 sentences; bullets are tight (one idea each)

Avoid:
- Internal team names or Slack-style shorthand
- Overly technical language unless the client is technical
- Passive voice ("it was decided" → "we decided")
- Filler phrases like "as per", "circling back", "per my last message"

---

## Edge Cases

- **No completed tasks in the window**: Note that the team has been in planning/prep mode
  and highlight meeting outcomes and upcoming work instead.
- **No Fathom meetings found**: Proceed with Teamwork data only; don't mention the absence.
- **Multiple projects matched**: Ask the user to clarify before proceeding.
- **First update ever**: Skip the "since our last update" framing; open with a "first formal
  project update" tone (as seen in the reference message).
