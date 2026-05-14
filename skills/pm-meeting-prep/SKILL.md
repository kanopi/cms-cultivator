---
name: pm-meeting-prep
description: >
  Quickly prepare a PM for an upcoming client check-in by pulling together context from Teamwork (tasks + messages), Gmail, Slack, and Fathom meeting recordings. Produces a structured briefing with talking points, ticket progress, new feature requests, and suggested next steps — then optionally generates a formatted agenda.

  Use this skill whenever the user says things like:
  - "prep me for my meeting with [client]"
  - "I have a check-in with [project] tomorrow, help me prep"
  - "what do I need to know before my call with [client]?"
  - "get me ready for [project name] meeting"
  - "meeting prep for [project]"

  Always trigger this skill when meeting preparation is the goal, even if the user doesn't say "skill" or "prep" explicitly. If the user mentions a client name or project name alongside a meeting, check-in, or call — use this skill.
---

# PM Meeting Prep

A skill for preparing a PM for an upcoming client check-in. It aggregates context from Teamwork, Gmail, Slack, and Fathom, then produces a clear briefing.

---

## Step 1: Gather Inputs

If not already provided, ask for:

1. **Project name** — used to find the Teamwork project and Slack channel
2. **Time range** — "How far back should I look? (e.g. last 7 days, last 2 weeks, since last meeting)" — default to 2 weeks if not specified

Do not ask for the Slack channel name upfront — search for it using the project name first (see Step 3).

---

## Step 2: Pull Teamwork Data

Use the Teamwork MCP to:

1. **Find the project** — search by name using `twprojects-list_projects` or `twprojects-search`
2. **List recent tasks** — use `twprojects-list_tasks` filtered to the project, looking for:
   - Tasks updated or completed within the time range
   - Tasks that are overdue or blocked
   - Any tasks with recent comments
3. **List recent messages** — use `twprojects-list_messages` for the project to find any updates, discussions, or announcements posted in the time range
4. **Note task statuses** — capture what's in progress, what's done, what's stuck

---

## Step 3: Pull Slack Messages

1. **Search for the channel** — use `slack_search_channels` with the project name as the query
   - If a clear match is found, use it
   - If multiple matches or no clear match, ask the user: "I found these channels: [list]. Which one should I use?"
2. **Read recent messages** — use `slack_read_channel` for the matched channel, scoped to the time range
3. **Look for** — client questions, action items mentioned in chat, any issues raised, tone/sentiment shifts

---

## Step 4: Pull Gmail Threads

Use Gmail MCP to search for recent email threads related to the project/client:

1. Search using `search_threads` with the project or client name as the query, filtered to the time range
2. Read relevant threads using `get_thread`
3. **Look for** — outstanding questions from the client, action items promised by the team, any concerns or escalations, feedback on deliverables

---

## Step 5: Pull Fathom Meeting Recordings

Use Fathom MCP to find any recent recorded meetings related to the project:

1. Use `search_meetings` with the project/client name
2. Filter to meetings within the time range (or slightly before, to capture the last check-in)
3. For any matches, use `get_meeting_summary` to pull the AI summary — no need to pull the full transcript unless the summary is sparse
4. **Look for** — unresolved action items from the last call, topics that were flagged for follow-up, any commitments made by either side

---

## Step 6: Synthesize and Present the Briefing

Present the output in this format in chat — clean, scannable, PM-friendly:

---

### 📋 Meeting Prep: [Project Name]
**Period reviewed:** [date range]
**Sources checked:** Teamwork · Slack · Gmail · Fathom

---

#### ✅ Progress Since Last Meeting
A bullet list of what has been completed or meaningfully advanced. Be specific — reference ticket names or task descriptions where relevant.

#### 🔄 In Progress / Ongoing
Tasks or items actively being worked on. Flag anything that's behind schedule or blocked.

#### 💬 Talking Points
The 3–6 most important things to cover in the meeting. These should be actionable and client-relevant — not just status updates, but things that require a conversation (decisions needed, feedback requested, concerns raised).

#### 🆕 New Feature Requests / Scope Discussions
Any requests that came up in Slack, email, or Teamwork messages that haven't been formally scoped or ticketed. Flag these clearly as items that may require estimation or separate discussion.

#### ⚠️ Blockers or Concerns
Anything flagged as blocked, overdue, or unresolved — including outstanding client questions that haven't been answered.

#### 🔜 Suggested Next Steps
3–5 concrete next steps the PM should be prepared to discuss or confirm in the meeting.

---

After presenting the briefing, ask:

> "Would you like me to turn this into a formatted meeting agenda you could share or use as a template?"

If yes, see **Agenda Format** below.

---

## Agenda Format (on request)

If the user wants a formatted agenda, produce the following in a clean copyable block:

```
Meeting Agenda — [Project Name]
Date: [date]

1. Quick wins & progress update (~5 min)
   - [bullet from Progress section]

2. In-progress items & blockers (~10 min)
   - [bullet from In Progress / Blockers]

3. Open discussion topics (~10 min)
   - [bullet from Talking Points]

4. New requests / scope items (~5 min)
   - [bullet from Feature Requests]

5. Next steps & action items (~5 min)
   - [bullet from Next Steps]
```

---

## Tips & Edge Cases

- **If Fathom has no results** — note it in the briefing ("No recent Fathom recordings found") and continue without it
- **If Slack channel is ambiguous** — ask before proceeding, don't guess
- **If the time range yields sparse results** — mention this and offer to expand the range
- **If the project can't be found in Teamwork** — ask the user to confirm the exact project name
- **Tone** — the briefing should be direct and PM-readable. No filler. Assume the reader is busy.
