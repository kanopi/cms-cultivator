---
predicate_type: https://kanopi.github.io/delivery-record/spec/v1
activity_type: devops
subject:
  kind: pr
  ref: "kanopi/cms-cultivator#55"
  sha: 79ef594
  title: "CMS Cultivator repo split — five-library topology, shared template, 2.0 release"
scope: milestone
assisted_by:
  models: [claude-fable-5]
  skills: [pr-create, commit-message-generator, delivery-record]
checks:
  change_documented:
    readme_updated: pass
    runbook: pass
    migration_docs: pass
  tested_lower_env:
    multidev: n/a
    ci_pipeline: pass
  secrets_handled:
    no_secrets_in_repo: pass
    env_vars_documented: n/a
  rollback_plan:
    documented: pass
    revert_tested: n/a
sign_off:
  produced_by: "Claude/claude-fable-5, session driven by @thejimbirch 2026-07-17"
  reviewed_by: "@thejimbirch 2026-07-17"
---

n/a — `multidev`: plugin repositories have no hosting environment; CI is the lower environment.
n/a — `env_vars_documented`: no environment variables were introduced by the change.
n/a — `revert_tested`: rollback is pinning to the frozen v1.7.0 tag (verified installable), not a revert of the split.

## What changed

kanopi/cms-cultivator (54 skills / 14 agents) was split into a five-library
family, each cloned from a new shared template with identical CI gates:

- **kanopi/skills-plugin-template** (new, public) — frontmatter validation,
  BATS scaffold with dynamic count parity, TF-IDF routing evals with a CI
  rank-1 floor and description-collision checks, Codex parity validation,
  packaging, workflows.
- **kanopi/delivery-record** (new, public, relicensed GPL→MIT) — 2 skills +
  the spec, new canonical URI with permanent legacy alias, Pages spec site.
- **kanopi/premium-service-skills** (existing, private) — 13 audit skills +
  6 specialist agents, shared `references/` criteria, metric-honesty rule.
- **kanopi/devops-skills**, **kanopi/pm-skills** (new, private) — 4 + 11 skills.
- **kanopi/cms-cultivator 2.0** (PR #55) — the subtraction: 24 skills /
  7 agents remain; 1.x frozen at v1.7.0; v2.0.0 and v2.1.0 released;
  default branch, docs deploy, and Pages environment repointed to main.

No application code paths change; this is repository/CI/packaging topology.

## What the AI produced

All extraction, re-namespacing (`cms-cultivator:` → per-repo prefixes, grep
gate zero), template tooling, docs sweeps, releases, and runbook execution —
in a Claude Code session with per-phase human approval gates. Skills run:
pr-create (PRs #55, #56, marketplace and site PRs), commit-message-generator
(Assisted-by trailers), delivery-record (this record). GitHub repo creation
and every push executed only after explicit human confirmation.

## What the human verified

Checkpoint 1 (plan approval): Approved the committed migration plan
(`plans/2026-07-16-cms-cultivator-repo-split.md`) — five-repo topology, MIT
relicense for delivery-record, 1.x freeze with no public redirect table —
and gated each phase at its boundary before execution.

Checkpoint 2 (final approval): Opened the five repos on GitHub and checked
visibility and licenses landed right (public template + delivery-record,
private premium/devops/pm); read PR #55 and PR #56 before merging; clicked
through the delivery-record release and spec site.

## Issues found and resolved

- Two invalid Codex TOMLs (unescaped backslashes) and description drift in
  design-specialist — caught by the new parity check, fixed.
- Routing-eval extractor truncated multi-paragraph descriptions; slash-only
  skills wrongly participated in routing — both fixed in the template and
  propagated (100% rank-1 in all six repos).
- Docs deployment was pinned to the frozen 1.x branch in three layers
  (workflow trigger, deploy-job gate, Pages environment policy) — all fixed.
- Secret-scan false positive on playwright-setup's throwaway multidev test
  credential — annotated as test-fixture, exclusion taught to the scanner.
- v2.0.0 release artifacts initially built from the frozen default branch —
  wiped and rebuilt from main.

## Deferred or known risks

- Behavioral eval harness (Osmani #6) — bd issue cms-cultivator-m8o, owner @thejimbirch.
- premium-service-skills `skill/ai-visibility-assessment` branch merge —
  guidance in that repo's MIGRATION.md, owner of the branch.
- Internal comms + delivery-record promotion posting — drafts in
  plans/2026-07-17-repo-split-announcements.md, owner @thejimbirch.
- Template is clone-and-detach: fixes must be manually propagated to the
  five consumer repos.
