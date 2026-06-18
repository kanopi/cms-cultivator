# Strategy Skills

Strategist-, UX-lead-, and PM-facing skills for discovery and pre-discovery work. Output is client-safe, presentation-ready, and tone-calibrated for the strategy audience — distinct from the developer-facing technical audits.

!!! warning "CoWork required"
    The strategy audit skill drives a browser via CoWork to capture screenshots and run Lighthouse. Without CoWork connected, the skill falls back to manual mode (the strategist provides screenshots and Lighthouse scores themselves) but cannot automate evidence capture. Confirm CoWork is connected before invoking.

---

## Available Skills

### strategist-site-audit

**Purpose:** A discovery-phase site audit designed for strategists, UX leads, and PMs — not developers. Audits a site against the 21 UX Laws from [lawsofux.com](https://lawsofux.com/), reviews content hierarchy, synthesises optional qualitative research data, runs Lighthouse, and produces two deliverables: a Markdown summary the strategist pastes into the client's Claude Desktop Project, and a polished HTML report ready for client sharing.

**Auto-invoked triggers:** "audit this site for strategy", "strategist audit", "UX audit", "UX laws audit", "discovery audit", "pre-discovery review", "content hierarchy review", or any site URL provided alongside discovery context.

**Tool dependencies:**

- **CoWork browser automation** — navigation, annotated screenshots (desktop + mobile per page, plus targeted issue captures), Lighthouse runs
- **Web search** — optional, used to reference UX law definitions or industry benchmarks when needed

**Optional inputs the skill will fold in if available:**

- A/B test results
- Tree testing results
- User survey or interview synthesis
- Heatmap data (descriptions or summaries — not raw exports)
- Analytics summaries (top pages, drop-off points, bounce rates)
- Stakeholder priorities or known pain points

**Workflow (high level):**

1. Confirm scope — site URL, pages to audit (default: homepage + 4 representative pages), qualitative data available, audience for the deliverable
2. Capture site evidence via CoWork — desktop and mobile screenshots per page, plus targeted issue close-ups
3. Audit against all 21 UX Laws (all core principles from lawsofux.com)
4. Review content hierarchy per page — visual hierarchy, content prioritisation, reading patterns, messaging clarity
5. Synthesise qualitative data alongside site observations
6. Run Lighthouse on each page — Performance, Accessibility, Best Practices, SEO
7. Identify patterns — systemic vs. isolated issues, positive patterns, inconsistencies
8. Produce two deliverables (see below)
9. Suggest discovery follow-ups and next steps

**The 21 UX Laws audited:**

Jakob's Law, Fitts's Law, Hick's Law, Miller's Law, Peak-End Rule, Von Restorff Effect, Aesthetic-Usability Effect, Doherty Threshold, Law of Proximity, Law of Similarity, Law of Common Region, Law of Uniform Connectedness, Law of Prägnanz, Serial Position Effect, Zeigarnik Effect, Tesler's Law, Postel's Law, Goal-Gradient Effect, Occam's Razor, Pareto Principle, Parkinson's Law.

---

## Deliverables

### Project Knowledge Summary (Markdown)

A structured Markdown document saved to `./strategist-audit-<domain>-knowledge-summary.md`. The strategist pastes this into the client's Claude Desktop Project as a knowledge file. Once pasted, findings become queryable across every future session for that client:

- "What were the Fitts's Law violations we found on the Services page?"
- "Summarise content hierarchy issues before I write the discovery deck"
- "What did the survey data confirm vs. contradict?"

Sections include: Executive Summary, What's Working, Highest-Impact Opportunities (prioritised), UX Laws Audit findings, Content Hierarchy Review per page, Lighthouse Snapshot, Qualitative Data Synthesis, and Discovery Follow-ups.

### HTML Artifact

A polished, self-contained, print-safe HTML report saved to `./strategist-audit-<domain>.html`. Designed for client sharing — emailable, downloadable, print-ready (A4 and Letter compatible).

Sections include:

- Cover page (client, domain, date, strategist)
- Executive Summary
- What's Working (green-accented positive patterns)
- UX Law Violation Cards — one per finding, with severity badges, location, screenshot, recommendation
- Screenshot Gallery — desktop + mobile per page, with captions
- Lighthouse Score Gauges (0–100, color-coded) for Performance, Accessibility, Best Practices, SEO
- Content Hierarchy per page
- Prioritised Recommendations Table (High → Medium → Low, with effort estimate)
- Discovery Follow-ups
- Appendix: Methodology (the 21 UX Laws and the audit process)

**Styling:** self-contained (no CDN dependencies, base64-encoded screenshots so the file is portable), color-blind safe severity badges, restrained palette with one accent color (the strategist can supply client brand colors).

**The HTML Artifact is iterable.** The strategist can adjust tone, emphasis, and visual style before sharing:

- "Make the recommendations more concise"
- "Soften the tone in the executive summary"
- "Add the client's brand color #XXXXXX as the accent"
- "Remove the appendix — keep the report focused on findings"

Treat the first render as a draft.

---

## When to Use This Skill

### Use `strategist-site-audit` when:

- Starting a discovery engagement with a new client and you need a baseline audit
- Preparing materials for a discovery kickoff or stakeholder readout
- Building the discovery deck and need findings backed by evidence
- A strategist asks for "an audit" — and they're not asking for a WCAG conformance report

### Do NOT use this skill for:

- **WCAG 2.1 conformance auditing** — use `accessibility-audit` (developer-facing, technical)
- **OWASP security scanning** — use `security-audit`
- **Core Web Vitals optimisation deep-dives with code fixes** — use `performance-audit`
- **Comprehensive multi-specialist developer audit** — use `live-site-audit`

The `strategist-site-audit` sits earlier in the engagement (discovery) and serves a different audience (strategy/client). It complements the developer-facing audits — run those separately when implementation decisions are needed.

---

## Manual Fallback (CoWork Unavailable)

If CoWork is not connected:

1. The skill asks the strategist to provide screenshots themselves (desktop + mobile per page)
2. The strategist runs Lighthouse via [PageSpeed Insights](https://pagespeed.web.dev/) for each page and provides the scores
3. The UX Laws audit and content hierarchy review proceed based on the manually-captured screenshots
4. The HTML Artifact references the manual screenshots; the Markdown Summary notes the audit wasn't fully automated

---

## Tone Conventions

The skill enforces a specific voice across both deliverables:

- **Confident, specific, opportunity-framed** — "The Services page would benefit from elevating pricing above testimonials" not "The Services page is poorly organized"
- **Client-safe language** — no internal jargon (no "MVP", "sprint", "ticket"); "primary action" is fine, "CTA" is fine, terms like "fail" are avoided in favor of "opportunity", "gap", or "could be strengthened"
- **Reference the UX laws by name** — strategists often frame findings with the law name as the anchor
- **Specific recommendations** — every recommendation answers "what specifically would you change?", not a generic "consider improving this"

---

## Next Steps

After running the audit, the skill suggests:

- **Schedule the discovery activities** named in the Follow-ups section
- **Run `accessibility-audit`** if the Lighthouse accessibility score flagged real issues
- **Run `live-site-audit`** for the technical companion audit — different audience, different deliverable
- **Use `frd-generator`** to translate audit findings into a discovery FRD once scope and budget are confirmed
- **Use `csv-exporter`** to convert prioritised recommendations into a Teamwork backlog

---

## References

- **[Laws of UX (Jon Yablonski)](https://lawsofux.com/)** — primary source for the 21 UX Laws audited
- **[Lighthouse documentation](https://developer.chrome.com/docs/lighthouse/overview)**
- **[Agents & Skills](../agents-and-skills.md)** — how skills auto-activate
- **[Project Planning](planning.md)** — FRD, story point, and CSV export skills (often run after a strategist audit)
- **[PM Workflows](pm-workflows.md)** — Teamwork-integrated PM skills (different scope, different audience)
