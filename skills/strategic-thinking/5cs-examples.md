# 5 Cs Strategic Thinking — Example Interactions

Reference file for the strategic-thinking skill. Contains worked examples of the 5 Cs framework applied to real CMS decision scenarios.

---

## Example 1: Architecture Decision

```
User: "Should we go headless for this project?"

[Skill activates]

"Before we weigh in — let's think through this with the 5 Cs.

Context first: Is there history here? Has the team explored headless before, or is there a reason the current architecture was chosen?"

User: "We tried it 2 years ago and it was abandoned due to editorial complexity."

"Good to know — that history matters a lot.

Color: What does headless success look like for this project specifically? And is this a committed direction or still being explored?"

[... continues through Cost, Connective Tissue, Consequence ...]

## Strategic Analysis: Headless Architecture Decision

### Context
- Previous headless attempt abandoned due to editorial complexity — root cause not yet resolved
- ...

## Recommendation
Defer the headless evaluation until the editorial workflow requirements are defined.
**Confidence**: High
**Key risk**: Repeating the previous failure without addressing the root cause
**Next step**: Document editorial workflow requirements before revisiting the architecture decision
```

---

## Example 2: Quick Prioritization (Audit Triage)

```
User: "We have 3 critical issues from the audit — security vuln, accessibility failure, and a performance regression. Which do we fix first?"

[Skill activates — recognizes prioritization decision]

"Classic triage question. Let me ask about Consequence and Connective Tissue quickly.

Consequence: Does the security vuln have an active threat or disclosure deadline? Is the a11y failure blocking any users from core functionality? Is the performance regression above an SLA threshold?"

User: "Security is a known CVE, no deadline yet. A11y blocks screen reader users from checkout. Performance is bad but no SLA."

"That's clear. Connective Tissue: does the performance fix involve any of the same code as the security patch?"

User: "No, completely different."

## Recommendation
Fix order: (1) Accessibility — blocks real users from checkout right now. (2) Security — known CVE with escalating risk. (3) Performance — real but no immediate threshold breach.
**Confidence**: High
**Key risk**: Security CVE timeline could accelerate — revisit if a disclosure date emerges
**Next step**: Open tickets for all three; start a11y fix today
```

---

## Example 3: CMS Platform Selection

```
User: "Client wants us to recommend Drupal vs WordPress for their new intranet."

[Skill activates]

"Good decision to think carefully about — this has long-term Cost and Connective Tissue implications.

Context: What do we know about their team? Do they have in-house developers? Content editors? What's their budget for ongoing maintenance?"

User: "Small team, 2 content editors, no developers. Budget is tight."

"That context strongly shapes the recommendation.

Color: What does success look like for the intranet in year 1? And year 3?"

[... continues ...]

## Recommendation
WordPress for this client. Drupal's editorial experience and developer overhead don't fit a small non-technical team with tight budget.
**Confidence**: High
**Key consideration**: If requirements expand significantly (complex workflows, granular permissions), revisit.
**Next step**: Confirm hosting requirements and plugin budget.
```
