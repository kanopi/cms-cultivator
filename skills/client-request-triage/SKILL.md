---
name: client-request-triage
description: PM triage skill for reviewing client-submitted Teamwork tasks or comments (feature requests, general questions). Given a Teamwork link, fetches the task, detects the platform (Drupal/WordPress/general web), researches potential solutions, and drafts a warm client-facing reply. Use this skill whenever a user shares a Teamwork task or comment link and wants to understand the client's request, explore implementation options, or draft a response — even if they just say "can you look at this task?" or "help me respond to this client". Also triggers for phrases like "triage this", "review this client request", "what should we tell the client", or "help me draft a reply to this Teamwork task". No estimates are included at this stage.
---

# Client Request Triage

A PM triage skill that takes a client Teamwork task or comment, researches solutions, and helps draft a clear client-facing reply — before any developer involvement is needed.

---

## Workflow

### Step 1: Fetch the Task

Use the Teamwork MCP to retrieve the task from the provided link. Extract:
- Task title and full description
- All comments (identify which are from the client vs. internal team)
- Project name and any tags or metadata
- Any linked tasks or context

If the link points to a specific comment, focus on that comment but read the full task thread for context.

---

### Step 2: Detect the Platform

Infer the platform from the project name, task language, module/plugin mentions, or any other context clues:

- **Drupal** — mentions of content types, views, paragraphs, modules, Pantheon, etc.
- **WordPress** — mentions of plugins, Gutenberg, WooCommerce, themes, etc.
- **General web** — if unclear or platform-agnostic, treat as general web best practices

If the platform is ambiguous, note it and proceed with general web guidance — don't ask the user unless truly impossible to infer.

---

### Step 3: Understand and Summarize the Request

Distill the client's ask into plain language. Cover:
- What they are asking for
- The problem they are trying to solve (if inferable)
- Any constraints or preferences they mentioned
- Any ambiguities or missing information that would be good to clarify

---

### Step 4: Research Solutions

Use web search to research relevant options. Look for:
- Drupal modules (drupal.org/project/...) or WordPress plugins (wordpress.org/plugins/...) that address the need
- Established web patterns or approaches for solving this type of problem
- Any known limitations, gotchas, or trade-offs worth flagging

Find **1 to 3 options** based on what makes sense for the request:
- If there's one obvious best approach, present just that
- If there are meaningfully different ways to solve it (e.g. simpler vs. more flexible), present 2–3
- Describe the options naturally — no "Simple / Moderate / Complex" labels. Let the description convey the trade-offs
- Lead with what you'd recommend and why, briefly

---

### Step 5: Present Summary and Pause

Before drafting anything, present the following to the PM and **wait for confirmation**:

```
**Request Summary**
[Plain-language summary of what the client is asking]

**Potential Approaches**
[1–3 options with natural descriptions and trade-offs]

**Recommendation**
[Which approach you'd suggest and a brief reason]

**Clarifying Questions (if any)**
[Any gaps in the request that might be worth asking the client about]

---
Ready to draft the client reply? Let me know if anything looks off first.
```

Do not proceed to drafting until the PM confirms or provides adjustments.

---

### Step 6: Draft the Client-Facing Reply

Once confirmed, draft a reply following these guidelines:

**Tone:** Professional, warm, and clear. Match the tone of the person using the skill. When in doubt, use the default style: friendly and direct, not overly formal, with a helpful closing.

**Structure:**
1. Acknowledge the request and show you understood it
2. Summarize the recommended approach(es) in plain language the client can follow
3. If multiple options, explain them naturally without jargon
4. End with a clear next step or call to action (e.g. "let us know if this aligns with your vision" or "happy to discuss further before we move ahead")
5. Close warmly

**Rules:**
- No estimates or timelines
- No internal jargon (no "sprint", "ticket", "dev", "module machine name", etc.)
- Keep it concise — clients should be able to read it in under 2 minutes
- The draft should be paste-ready (no placeholders like [NAME] unless truly needed)

Present the draft in a clearly labelled block so it's easy to copy.

---

## Notes

- This skill is for **initial PM triage only** — the goal is to start the conversation with the client before looping in a developer
- If the task is clearly a bug report rather than a feature request or question, **stop and flag it to the PM** before proceeding. Say something like: "This looks like a bug report rather than a feature request or question — this skill is optimized for triage of feature requests and general questions. Would you like me to continue anyway, or handle this differently?" Do not proceed with the research and drafting workflow until the PM confirms.
- If the client's request is very vague, the clarifying questions in Step 5 become especially important — surface those clearly
