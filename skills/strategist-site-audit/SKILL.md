---
name: strategist-site-audit
description: Strategist-focused site audit for discovery and pre-discovery. Given a site URL and optional qualitative research data, navigates the site via CoWork, audits against all 21 UX Laws from lawsofux.com, reviews content hierarchy, synthesises qualitative data, runs Lighthouse, and produces two deliverables — a Project Knowledge Summary (Markdown for Claude Desktop Projects) and a polished, iterable HTML Artifact for client sharing. Use when a strategist, UX lead, or PM asks for a discovery audit, UX laws audit, content hierarchy review, pre-discovery site review, "audit this site for strategy", "strategist audit", "UX audit", or pastes a site URL with discovery context. Not for developer audits — use accessibility-audit, performance-audit, or live-site-audit for those.
---

# Strategist Site Audit

A strategist-, UX-lead-, and PM-facing audit skill for discovery and pre-discovery phases. Produces presentation-ready, client-safe deliverables — not developer technical reports.

## ⚠️ Side Effect Warning

**This skill drives a browser via CoWork** and writes two artifacts to disk (a Markdown summary and an HTML report). It does not push code, post anywhere, or modify the audited site. The HTML Artifact is generated as a draft — the strategist iterates on tone and emphasis before sharing.

## Who It's For

- **Strategists** running discovery on a new client
- **UX leads** establishing baseline observations before redesign
- **PMs** preparing client kickoff materials and discovery decks

**Not for developers.** Technical audits (WCAG conformance, OWASP, Core Web Vitals deep-dive) belong to `accessibility-audit`, `security-audit`, `performance-audit`, or `live-site-audit`. This skill's output is client-readable, jargon-light, and frames findings as opportunities — not bug tickets.

## Tool Dependencies

- **CoWork browser automation** — required for navigation, annotated screenshots (desktop + mobile), and Lighthouse runs
- **Web search** — optional, used to reference UX law definitions or industry benchmarks when needed

> **Without CoWork**, the skill cannot capture screenshots or run Lighthouse automatically. Fallback: the strategist provides screenshots manually and runs Lighthouse via [PageSpeed Insights](https://pagespeed.web.dev/). Document this limitation up front if CoWork isn't connected.

## Usage

- "Audit this site for strategy: https://example.com"
- "Strategist audit of https://client.com — they shared some heatmap data and a user survey, can you fold those in?"
- "Run a discovery audit on https://example.com — focus on home, about, and product pages"
- "UX laws audit of https://example.com"
- "Pre-discovery review of https://example.com"

### Optional inputs

The skill accepts (and will explicitly ask for) any of the following qualitative data the strategist already has:

- A/B test results (winning variants, lift)
- Tree testing results (information architecture findings)
- User survey or interview synthesis
- Heatmap data (Hotjar, FullStory, etc.) — descriptions or summary, not raw exports
- Analytics summaries (top pages, drop-off points, bounce rates)
- Stakeholder priorities or known pain points

If none are provided, the skill runs from site observations alone and notes the absence of qualitative context as a discovery follow-up.

## Workflow

### 1. Confirm scope

Before navigating anything, ask the strategist:

1. **Site URL** — the starting URL (typically the homepage)
2. **Pages in scope** — which pages to audit beyond the homepage. Default: homepage + 4 representative pages the strategist names (e.g., "About, Services, a typical product/article, Contact"). The strategist can also say "you choose — 5 pages that represent the site" and the skill picks from primary nav.
3. **Qualitative data available** — A/B tests, tree testing, surveys, heatmaps, analytics, prior research. The skill folds these in if provided.
4. **Audience for the deliverable** — internal team only, internal + client review, or client-facing presentation. Tone calibrates accordingly.
5. **CoWork connected?** — Confirm before proceeding. If not, switch to manual fallback mode (see below).

### 2. Capture site evidence (via CoWork)

For each page in scope, capture:

- **Desktop screenshot** at 1440px width — full page
- **Mobile screenshot** at 375px width — full page
- **Targeted issue screenshots** — close-ups of specific UX law violations, content hierarchy issues, or interactions the strategist will reference in the report

Catalogue each screenshot with a clear filename and a short caption that will appear in the HTML Artifact and the Markdown Summary. Save to a working directory (e.g., `./strategist-audit-screenshots/<domain>/`).

### 3. Audit against the 21 UX Laws

Apply all 21 core laws from [Jon Yablonski's Laws of UX](https://lawsofux.com/):

| # | Law | What to look for |
|---|-----|------------------|
| 1 | **Jakob's Law** | Conventions match user expectations from similar sites |
| 2 | **Fitts's Law** | Target size and distance — primary CTAs large enough and near user attention |
| 3 | **Hick's Law** | Choice overload in nav, filters, forms; decision time vs. option count |
| 4 | **Miller's Law** | Chunked information — no list with > 7 items without grouping |
| 5 | **Peak-End Rule** | Strongest impressions: hero moment and final CTA / thank-you state |
| 6 | **Von Restorff Effect** | Distinct items stand out (one primary CTA per view, not five) |
| 7 | **Aesthetic-Usability Effect** | Visual polish aligned with brand and trust signals |
| 8 | **Doherty Threshold** | Perceived response < 400ms — loading states, skeleton screens, progressive disclosure |
| 9 | **Law of Proximity** | Related elements grouped; unrelated elements separated |
| 10 | **Law of Similarity** | Visually similar elements perceived as related |
| 11 | **Law of Common Region** | Bordered/background-separated regions group their contents |
| 12 | **Law of Uniform Connectedness** | Connected elements feel related (lines, shared backgrounds) |
| 13 | **Law of Prägnanz** | Visual simplicity — viewers default to the simplest interpretation |
| 14 | **Serial Position Effect** | First and last items in lists carry more weight (nav order, content priority) |
| 15 | **Zeigarnik Effect** | Incomplete tasks linger in attention — progress indicators, save-for-later states |
| 16 | **Tesler's Law** | Conservation of complexity — system absorbs complexity so users don't have to |
| 17 | **Postel's Law** | Be liberal in input acceptance (forms forgiving of formatting variations) |
| 18 | **Goal-Gradient Effect** | Progress acceleration — visible progress toward a goal increases completion |
| 19 | **Occam's Razor** | Simplest design solution that satisfies the requirement |
| 20 | **Pareto Principle** | 80% of effects from 20% of causes — focus on the high-impact issues |
| 21 | **Parkinson's Law** | Work expands to fill available time — constrain form fields, decision points |

For each violation found, record:

- **Law:** name + one-line definition
- **Where:** page + region (e.g., "homepage hero", "Services > pricing table")
- **What's happening:** plain-language description of the observation
- **Why it matters:** the user impact (not just "violates the law")
- **Recommendation:** specific, actionable — what to do, not just what's wrong
- **Severity:** High / Medium / Low based on user impact and frequency
- **Screenshot reference:** filename of the targeted screenshot

Do not pad findings. If a law is observed correctly (positive pattern), note it under "What's working" — those are as useful for strategy decks as violations.

### 4. Review content hierarchy

For each page in scope, evaluate:

- **Visual hierarchy** — does the eye flow follow the intended priority? (F-pattern vs. Z-pattern; primary CTA dominance)
- **Content prioritisation** — does what matters most appear first? Is the value proposition clear within the first viewport?
- **Reading patterns** — scanability, headline / subhead / body rhythm, paragraph length, list usage
- **Messaging clarity** — does the page tell the user what this is, what it does for them, and what to do next within 5 seconds?

Capture findings per page, with specific recommendations (e.g., "Move pricing above the testimonials block — pricing is currently below the fold on mobile and is the user's primary question on this page").

### 5. Synthesise qualitative data

If the strategist provided qualitative inputs (Step 1.3), weave them through the findings:

- **Cross-reference** — when a UX law violation aligns with a survey complaint or a heatmap dead zone, flag it explicitly (high-confidence finding)
- **Contradict carefully** — if observations conflict with user data, surface the conflict and offer hypotheses, don't pick a winner
- **Fill gaps** — if data is sparse on a specific page or area, name it as a discovery follow-up

If no qualitative data was provided, note the absence as a discovery activity to schedule (interviews, heatmap install, survey design).

### 6. Run Lighthouse (via CoWork)

For each page in scope, capture:

- **Performance** score + top 3 flagged issues
- **Accessibility** score + top 3 flagged issues (high-level — for the technical deep-dive, recommend running `accessibility-audit` next)
- **Best Practices** score
- **SEO** score + top 3 flagged issues

Present scores as gauges in the HTML Artifact. Frame issues in client-friendly language (e.g., "Images are slow to load on mobile" instead of "LCP > 2.5s").

### 7. Identify patterns

Synthesise across pages:

- **Recurring issues (systemic)** — same problem on 3+ pages. These become high-impact recommendations because fixing once fixes everywhere.
- **Isolated issues** — only on one page. Lower priority unless severity is high.
- **Positive patterns** — what's working consistently across the site. Use these to anchor "build on what's working" recommendations.
- **Inconsistencies** — same component or pattern handled differently across pages (e.g., CTA styles, form field layouts, breadcrumb usage). Flag for design system audit.

### 8. Produce the two deliverables

#### Deliverable A: Project Knowledge Summary (Markdown)

Save to `./strategist-audit-<domain>-knowledge-summary.md`. Structured for the strategist to paste into their Claude Desktop Project for the client.

```markdown
# Strategist Site Audit — <Client Name> (<domain>)

**Date:** <YYYY-MM-DD>
**Pages audited:** <list>
**Qualitative data sources:** <list, or "None provided — see Discovery Follow-ups">

---

## Executive Summary

[3–5 sentences: the most important takeaways. Tone: confident, specific, non-prescriptive.
"The site shows strong consistency in visual brand application; the largest opportunities
sit in [primary CTA hierarchy], [mobile navigation depth], and [content prioritisation on
the Services page]."]

---

## What's Working

- [Positive pattern with specific example]
- [Positive pattern with specific example]
- [Positive pattern with specific example]

---

## Highest-Impact Opportunities (Prioritised)

### 1. [Opportunity title]
**Severity:** High
**Pages affected:** [list]
**UX laws involved:** [list]
**Recommendation:** [specific, actionable]
**Why it matters:** [user impact]

### 2. [Opportunity title]
[...]

---

## UX Laws Audit — Findings by Law

### Jakob's Law
- **Status:** [Met / Partially Met / Violated]
- **Observations:** [...]
- **Recommendations:** [...]
- **Screenshot:** ./strategist-audit-screenshots/<domain>/<filename>.png

[... repeat for all 21 laws ...]

---

## Content Hierarchy Review — by Page

### Homepage
- **Visual hierarchy:** [observations]
- **Content priorities:** [observations]
- **Reading patterns:** [observations]
- **Messaging clarity:** [observations]
- **Recommendations:** [specific list]

[... repeat for each page in scope ...]

---

## Lighthouse Snapshot

| Page | Performance | Accessibility | Best Practices | SEO | Top Issues |
|------|-------------|---------------|----------------|-----|------------|
| Home | 78 | 84 | 92 | 91 | Slow image load on mobile; missing alt text on hero |
| ... | | | | | |

---

## Qualitative Data Synthesis

[If qualitative data was provided: how it aligned with or contradicted observations. If not: list of recommended discovery activities to fill the gaps.]

---

## Discovery Follow-ups

- [Activity 1 — e.g., "Schedule 6 user interviews focused on Services page flow"]
- [Activity 2 — e.g., "Install heatmap tracking on top 5 pages for 2 weeks"]
- [Activity 3 — e.g., "Run tree test on proposed navigation"]

---

## How to Use This Document

Paste this entire document into the client's Claude Desktop Project as a knowledge file. Future questions like:

- "What were the Fitts's Law violations we found on Services?"
- "Summarise content hierarchy issues before I write the discovery deck"
- "What did the survey data confirm vs. contradict?"

— will be answerable in any session for this client.
```

#### Deliverable B: HTML Artifact

Save to `./strategist-audit-<domain>.html`. A polished, self-contained, print-safe report designed for client sharing.

Required sections in the rendered HTML:

1. **Cover** — client name, domain, date, strategist name (ask if not provided)
2. **Executive Summary** — same content as Markdown summary, set in a readable serif body type
3. **What's Working** — green-accented panel, 3–5 positive patterns with thumbnails
4. **UX Law Violation Cards** — one card per finding: law name, severity badge, location, screenshot, recommendation. Filterable by severity in the print version's table of contents.
5. **Screenshot Gallery** — desktop + mobile per page, with captions
6. **Lighthouse Score Gauges** — visual gauges (0–100, color-coded) for Performance, Accessibility, Best Practices, SEO per page
7. **Content Hierarchy per Page** — annotated sections with observations and recommendations
8. **Prioritised Recommendations Table** — High → Medium → Low, with effort estimate (Low / Medium / High) so the client can sequence
9. **Discovery Follow-ups** — what to learn next
10. **Appendix: Methodology** — short explanation of the 21 UX Laws, link to lawsofux.com, what the strategist's process covered and didn't

**Styling requirements:**

- Self-contained HTML — no external CDN dependencies; inline CSS; base64-encoded screenshots so the file can be emailed
- Print stylesheet — page breaks before each major section; A4 and Letter compatible; no orphan headings
- Restrained palette: neutral backgrounds, one accent color (suggest a neutral teal or warm grey unless the strategist provides client brand colors)
- Severity badges: High = warm red, Medium = amber, Low = neutral grey. Color-blind safe.
- Sans-serif headings, serif body, system fallback fonts
- Mobile-readable in case the client opens on a phone

**After rendering, tell the strategist:**

> "Here's the first draft of the HTML report. You can iterate before sharing — for example:
> - 'Make the recommendations more concise'
> - 'Soften the tone in the executive summary'
> - 'Add the client's brand color #XXXXXX as the accent'
> - 'Remove the appendix — keep the report focused on findings'
>
> The Project Knowledge Summary is also ready: `./strategist-audit-<domain>-knowledge-summary.md`. Paste it into the client's Claude Desktop Project."

### 9. Offer next steps

After delivery, suggest:

- **Schedule the discovery activities** named in Follow-ups
- **Run `accessibility-audit`** if the Lighthouse accessibility score flagged real issues
- **Run `live-site-audit`** for the technical companion audit (performance + security + code quality) — different audience, different deliverable
- **Use `frd-generator`** to translate audit findings into a discovery FRD if scope and budget have been confirmed

## Manual Fallback (CoWork Unavailable)

If CoWork is not connected:

1. Ask the strategist to provide screenshots themselves (desktop + mobile per page)
2. Ask them to run Lighthouse via [PageSpeed Insights](https://pagespeed.web.dev/) for each page and paste the scores
3. Proceed with the UX Laws audit and content hierarchy review based on the screenshots
4. The HTML Artifact references the strategist-provided screenshots instead of automated captures
5. Note in the Project Knowledge Summary that "screenshots were manually captured" so future sessions know the audit wasn't fully automated

## Tone Guidelines

- **Confident, specific, opportunity-framed** — "The Services page would benefit from elevating pricing above testimonials" not "The Services page is poorly organized"
- **Client-safe** — no internal jargon ("CTA" is fine; "MVP", "sprint", "ticket" are not)
- **Reference the laws by name** — strategists often present findings with the law name as the framing device
- **Avoid the word "fail"** — use "opportunity", "gap", "missing", "could be strengthened"
- **Specific, not vague** — every recommendation should answer "what specifically would you change?"

## What This Skill Doesn't Do

- **Technical accessibility audit** — use `accessibility-audit` for WCAG 2.1 conformance reporting
- **Security audit** — use `security-audit` for OWASP scanning
- **Performance deep-dive** — use `performance-audit` for Core Web Vitals optimisation with specific code fixes
- **Comprehensive multi-specialist audit** — use `live-site-audit` for the developer-facing parallel audit

The strategist-site-audit complements those: it sits earlier in the engagement (discovery), serves a different audience (strategy/client), and produces a different deliverable (presentation-ready, not implementation-ready).

## Related Skills

- **frd-generator** — translate audit findings into a structured discovery FRD once scope is confirmed
- **story-point-estimator** — estimate the work to address prioritised recommendations
- **csv-exporter** — convert prioritised recommendations into a Teamwork backlog
- **live-site-audit** — developer-facing companion audit (run separately, different deliverable)
- **accessibility-audit** — deeper technical accessibility review if the Lighthouse a11y score flags real issues

## References

- [Laws of UX — Jon Yablonski](https://lawsofux.com/)
- [Lighthouse documentation](https://developer.chrome.com/docs/lighthouse/overview)
- [Nielsen Norman Group — Heuristic Evaluation](https://www.nngroup.com/articles/ten-usability-heuristics/) (companion reference for the UX laws)
