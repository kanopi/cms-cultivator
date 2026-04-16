---
name: strategic-thinking
description: Automatically guide users through Brene Brown's 5 Cs of Strategic Thinking (Context, Color, Connective Tissue, Cost, Consequence) when making significant decisions. From the book "Strong Ground" by Brene Brown. Invoke when user asks "should we do this?", "help me decide", "what are the trade-offs", "help me think through this", "is this the right approach?", or is weighing options about architecture, tooling, features, project approach, or delegating work.
---

# Strategic Thinking with the 5 Cs

Guide significant decisions using Brene Brown's 5 Cs framework from *Strong Ground*.

## Philosophy

Good decisions don't come from gut instinct alone — they come from slowing down long enough to see the full picture. Brene Brown's 5 Cs of Strategic Thinking, Decision Making, and Delegating provide a structured way to surface what's known, what's missing, and what's at stake before committing to a course of action.

### Core Beliefs

1. **Clarity Before Commitment**: The cost of pausing to think is almost always lower than the cost of reversing a poor decision
2. **Missing Information Is Risk**: An unanswered C is not a neutral gap — it's a known unknown that should be named and managed
3. **Decisions Have Ripples**: Every technical or strategic choice connects to past decisions and future possibilities — pull the thread
4. **Intent Shapes Everything**: A decision made with clear color (vision + urgency) is far easier to execute and course-correct than one made in ambiguity
5. **This Works at Every Scale**: Whether you're choosing a CSS approach or recommending a full platform migration, the 5 Cs apply

### Why This Framework

In CMS development work, most difficult decisions share the same failure modes: incomplete context, unclear intent, ignored dependencies, underestimated cost, and unconsidered consequences. The 5 Cs address each failure mode directly.

## When to Use This Skill

Activate this skill when the user:
- Asks "should we do this?" or "is this the right approach?"
- Says "help me decide" or "help me think through this"
- Is weighing options (architecture, tooling, CMS platform, tech stack, vendors)
- Is considering delegating a task or responsibility
- Asks "what are the trade-offs?"
- Faces a prioritization decision (which issues to fix first, which features to build)
- Is about to make a significant irreversible decision
- Mentions "pros and cons" or "not sure if we should"
- Is preparing for a stakeholder conversation about direction

## Do NOT Activate For

- Simple factual questions ("what does this function do?")
- Routine implementation tasks with a clear path forward
- Debugging specific errors
- Minor style or formatting choices

## The 5 Cs Framework

These are Brene Brown's 5 Cs of Strategic Thinking, Decision Making, and Delegating from *Strong Ground*.

### 1. Context

No one has optics on everything happening in an organization. Context ensures you're not making decisions in a vacuum.

**Key questions:**
- What's happening in other areas that will impact or be impacted by this decision?
- Is there history or previous experience that we need to understand?
- Is there a broader context to discuss — geopolitics, supply chain, unspoken expectations?
- Do we need vettings or briefs on partners, vendors, or stakeholders?

**In CMS work, this looks like:**
- Understanding why a previous approach was abandoned before proposing it again
- Knowing about an active platform migration before recommending deep customization
- Checking whether another team is already solving the same problem

### 2. Color

Setting a clear intention and painting the fullest, most detailed picture of what success looks like.

**Key questions:**
- Can you describe your vision of what this looks like or how it works?
- How would you assign the level of importance, seriousness, and urgency?
- Is this ideation and brainstorming, or are we going to do this?
- If this is "throwing out ideas," how will we know when or if it moves to a serious plan?

**In CMS work, this looks like:**
- Distinguishing "we're exploring headless" from "we're migrating to headless by Q3"
- Defining what "done" looks like for a feature before writing a line of code
- Clarifying whether a performance concern is theoretical or blocking production

### 3. Connective Tissue

Pull the thread. Every decision connects to other decisions — past, present, and future.

**Key questions:**
- How does this connect to other plans, strategies, decisions, or deliverables?
- Does this solve or amplify what's already happened or happening now?
- How does it lay the groundwork for what hasn't happened yet but is part of the vision?
- Using anticipatory thinking — what will be the ripple effect of this decision?

**In CMS work, this looks like:**
- Recognizing that a caching strategy decision affects both performance and editorial workflows
- Understanding that a third-party API integration creates a long-term dependency
- Seeing that fixing a security issue in one module may expose the same pattern in five others

### 4. Cost

Decisions are never free. Cost must be named, agreed upon, and communicated.

**Key questions:**
- What will this cost in terms of money, time, bandwidth, focus, and priority shifts?
- Is this cost tolerable? Expected? Agreed upon? Controversial? Communicated?
- Does everyone involved understand the cost AND how we're going to deal with the spend?

**In CMS work, this looks like:**
- Estimating the engineering time for a "simple" feature that touches core
- Acknowledging that adding a new dependency has a long-term maintenance cost
- Being honest that a comprehensive accessibility audit will delay the sprint

### 5. Consequence

What's at stake — for doing this, for not doing this, and for getting it wrong?

**Key questions:**
- Are there consequences of not doing this, and if so, what are they?
- What's at stake?
- What are the consequences of getting it wrong?
- Are there any unintended consequences that we can anticipate or problem-solve now?

**In CMS work, this looks like:**
- Recognizing that deferring a security fix creates legal and reputational risk
- Understanding that a performance regression above a certain threshold triggers SLA penalties
- Anticipating that a component architecture change will require retraining content editors

## Decision Framework

### Which Cs Are Most Critical by Decision Type?

| Decision Type | Primary Cs | Secondary Cs |
|---|---|---|
| Architecture / Platform | Connective Tissue, Consequence | Context, Cost |
| Feature prioritization | Consequence, Cost | Color, Connective Tissue |
| Delegation | Color, Cost | Context |
| Vendor / tool selection | Context, Cost, Consequence | Connective Tissue |
| Audit remediation priority | Consequence, Connective Tissue | Cost |
| Release / go-live decisions | Consequence, Color | Cost, Context |
| Ideation / brainstorming | Color | (all others optional) |

### Depth by Stakes

- **High-stakes, irreversible** — Work all 5 Cs thoroughly
- **Medium-stakes, reversible** — Focus on the 2–3 most critical Cs for that decision type
- **Low-stakes, easily changed** — A quick Color check may be sufficient

## Interactive Workflow

When this skill activates, guide the user through the 5 Cs conversationally — don't dump all questions at once. Gather one C at a time, then synthesize.

### Step 1: Name the Decision

Confirm what decision is actually being made. Restate it clearly:

> "It sounds like you're deciding whether to [X]. Is that right, or is there more to it?"

### Step 2: Work Through the 5 Cs

For each C, ask 1–2 focused questions. Wait for answers before moving to the next C. Skip Cs that are clearly not relevant (e.g., don't ask about geopolitical context for a CSS framework choice).

**Suggested question openers:**
- *Context*: "Before we dig in — is there any history or parallel work we should factor in?"
- *Color*: "What does success look like here? And is this something we're definitely doing, or still exploring?"
- *Connective Tissue*: "How does this connect to what's already in motion? What might it affect downstream?"
- *Cost*: "What's the real cost here — time, focus, money? Who has agreed to absorb that?"
- *Consequence*: "What happens if we don't do this? And what could go wrong if we do?"

### Step 3: Surface Gaps

After gathering responses, explicitly name any Cs that are unclear or unanswered:

> "We have good clarity on Context and Cost, but the Consequence of not acting isn't fully defined yet. That gap is a risk worth naming."

### Step 4: Synthesize and Recommend

Produce a structured analysis and a clear recommendation.

## Output Format

After gathering information through the 5 Cs, present a structured analysis:

```markdown
## Strategic Analysis: [Decision Title]

### Context
- [Key contextual factors: history, parallel work, stakeholder expectations]
- [Gaps: what context is still unknown]

### Color
- [Vision of success]
- [Urgency and importance level]
- [Ideation vs. committed decision]

### Connective Tissue
- [Dependencies and connections to existing work]
- [Anticipated ripple effects]
- [Groundwork this lays for future decisions]

### Cost
- [Time, money, bandwidth, focus]
- [Opportunity cost: what won't get done]
- [Communication status: who knows and agrees]

### Consequence
- [Cost of inaction]
- [Risk of getting it wrong]
- [Unintended consequences to watch for]

## Recommendation

[Clear recommendation with reasoning]

**Confidence**: High / Medium / Low
**Key risk**: [The one thing most likely to make this go wrong]
**Next step**: [Specific, actionable next step]
```

## Integration with CMS Cultivator

This skill is embedded in three specialist agents at their key decision points:

- **live-audit-specialist** — Applies the 5 Cs when prioritizing remediation roadmaps and making launch recommendations. Consequence and Connective Tissue drive issue severity; Cost validates what's achievable in each sprint.

- **workflow-specialist** — Applies Color and Consequence when deciding whether to block a PR or proceed conditionally. Color distinguishes exploratory PRs from production releases. Consequence surfaces what ships broken if the gate is bypassed.

- **design-specialist** — Applies Context and Cost when choosing between implementation approaches (e.g., MCP-based vs. YAML fallback, block pattern vs. paragraph type variant). Context surfaces project constraints; Cost surfaces the long-term maintenance reality.

## Example Interactions

For worked examples of the 5 Cs framework applied to architecture decisions, audit triage, and CMS selection, see [5cs-examples.md](5cs-examples.md).

## Best Practices

### DO

- Surface unknown Cs as explicit risks, not omissions — "We don't have clarity on Cost yet, and that's worth naming before we proceed"
- Keep the interactive conversation focused — one C at a time
- Name the decision type early to know which Cs to prioritize
- Provide a clear recommendation, not just a framework dump
- Give a confidence level so the user knows how solid the recommendation is
- Acknowledge when a decision is genuinely close and explain what would shift it

### DON'T

- Skip Cs because they seem obvious — obvious answers are worth confirming, not assuming
- Present all 25 questions at once — this is a conversation, not a form
- Use the framework as a way to avoid making a recommendation
- Apply all 5 Cs with equal depth to low-stakes decisions — match depth to stakes
- Treat the framework as a checklist — it's a thinking tool, not a compliance exercise

## Resources

- *Strong Ground: The Lessons of Daring Leadership, The Tenacity of Paradox, and the Wisdom of the Human Spirit* by Brene Brown
- Brene Brown's Dare to Lead research: brenebrown.com/daretolead
