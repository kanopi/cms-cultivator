# Testing Environment URL

Load this only when the repository deploys to a hosting environment. A plugin,
library, CLI tool, config repo, or docs repo has nowhere to preview: omit Affected URL
entirely, with no note explaining its absence, and write the validation steps as local
commands.

## Which host

| Evidence | Host |
|---|---|
| `.tugboat/config.yml` | Tugboat |
| `pantheon.yml`, `pantheon.upstream.yml`, `terminus` in CI or Composer scripts | Pantheon |

Derive the URL when the PR is created. Do not wait for the build, and do not omit the
link because the environment is not up yet.

## The Affected URL section holds the link and nothing else

No label ("Tugboat preview:", "Multidev:"), no dashboard link, no sentence on how the
URL was derived or fetched, no findings from exercising the preview.

```markdown
## Affected URL
https://pr347-zaozxpd7kyyvob1fbbczj2tpodelylso.tugboatqa.com
```

What you learned by using the preview belongs elsewhere: a deploy-time requirement it
exposed goes in Deploy Notes, a verification result goes in Assumptions. Never
cross-reference Affected URL for detail — it has none.

**Placement.** Use whichever section the resolved template provides — "Affected URL",
"Preview", "Test environment". If it has none, add `## Affected URL` above the Quality
Report. Deep links in Steps to Validate supplement this section; they never replace it.

## Pantheon — construct it

```text
https://<env>-<site-machine-name>.pantheonsite.io
```

- **Site machine name:** `TERMINUS_SITE` in the CI config, any existing environment
  URL, or `terminus site:info`.
- **Environment name:** read the CI job that creates the multidev. Never assume it
  matches the git branch — environment names cap at 11 characters, so
  `feature/12345-add-fancy-block` cannot be one. CI normally creates a tracking
  environment from the PR number, such as `pr-123`.
- **Reserved, never valid:** `master`, `settings`, `team`, `support`, `debug`,
  `multidev`, `files`, `tags`, `billing`.

## Tugboat — fetch it in two passes

Preview URLs carry a high-entropy hash so they cannot be guessed. Nothing is derivable
from the branch or PR number — but the URL **is** retrievable once the build the PR
triggered has finished. A dashboard link is a placeholder, never the answer.

### Pass 1 — at PR creation

```markdown
## Affected URL
Tugboat preview build in progress.
```

Write Steps to Validate with bare paths for now.

### Pass 2 — once the build completes

**Get the preview ID from the PR checks.** Tugboat's checks ("Tugboat", "Tugboat -
Lighthouse Reports") link to the dashboard, not the preview. The last path segment of
that link is the preview ID.

```bash
ID=$(gh pr checks <pr-number> --json link -q '.[].link' \
  | grep -om1 'dashboard\.tugboatqa\.com/[^/?#]*' | cut -d/ -f2)
```

**Route A — the Tugboat API. Authoritative; use it first.** The token is in
`~/.tugboat.yml`. Call the API directly rather than the `tugboat` CLI, which may be an
Intel-only build that will not run on Apple Silicon. Never print the token.

```bash
TOKEN=$(awk '/^token:/{print $2}' ~/.tugboat.yml)
[ -n "$TOKEN" ] || { echo "No token in ~/.tugboat.yml; use route B."; exit 1; }

curl -fsS -H "Authorization: Bearer $TOKEN" \
  "https://api.tugboatqa.com/v3/previews/$ID" \
  | jq '{ref, state, url: (.url // .urls[0])}'
```

Before using `url`, check that `ref` is this PR (`pr<number>`) and `state` is `ready`.
Anything else means the build has not finished — keep the placeholder.

**Route B — Tugboat's PR comment. Only when there is no token.** Tugboat posts
"Tugboat has finished building the preview…" with both the preview and dashboard
links. Match the preview shape specifically; a loose `*.tugboatqa.com` match can return
the dashboard link.

```bash
gh pr view <pr-number> --json comments -q '.comments[].body' \
  | grep -Eom1 'https://pr[0-9]+-[a-z0-9]+\.tugboat(qa\.com|\.qa)'
```

The comment is posted under the account that connected the integration, not a bot —
never filter by author. It cannot confirm `ref` or `state`, and Tugboat sometimes skips
it or drops it on rebuild, which is why route A comes first.

**Rules:**

- **Only this PR yields this PR's URL.** Never search other PRs' comments for a link.
- **Do not block waiting, and do not give up.** If `state` is not `ready`, keep the
  placeholder and say the URL is pending. Run pass 2 when next asked, or poll `state`
  through the API. Never invent a URL.
- **`ready` does not mean the site works.** In kanopi/moscone#347, `drush updatedb`
  and `drush cim` ran out of memory, the site sat in maintenance mode serving 503s,
  and the build still reported success. Request a page and check for a 200 before
  claiming anything renders. If it errors, read the build log — a failure there is a
  Deploy Notes item:

  ```bash
  curl -fsS -H "Authorization: Bearer $TOKEN" \
    "https://api.tugboatqa.com/v3/previews/$ID/log"
  ```

**Writing pass 2 back.** It replaces only the placeholder and the bare paths written
at creation, so it adds no new content — report the substitution after writing. Edit the sections above the Quality Report:

```bash
BODY=$(gh pr view <pr-number> --json body -q .body | tr -d '\r')
[ -n "$BODY" ] || { echo "Could not read PR body; aborting."; exit 1; }
# Substitute the base URL into the placeholder and the bare paths, then:
printf '%s\n' "$BODY_UPDATED" | gh pr edit <pr-number> --body-file -
```

The emptiness check is not optional: a failed read would otherwise overwrite the
description with nothing.

## Deep links in Steps to Validate

Each step that asks the reviewer to open a page carries an absolute link to that path
on the testing environment. The reviewer never assembles a URL by hand.

```markdown
- [ ] Visit [/admin/structure/types](https://pr-123-clientsite.pantheonsite.io/admin/structure/types) and confirm the Fancy Block type is listed.
- [ ] Run `drush cr`, then reload [/news](https://pr-123-clientsite.pantheonsite.io/news) and confirm the sidebar order is unchanged.
```

- **Link text is the path; the href is the full URL.**
- **Only steps that navigate.** A CLI command, a log check, or an inbox check gets no
  link.
- **One environment per PR**, the same one as Affected URL. If a step needs another,
  say which and why.
- **On Tugboat**, bare paths are the pass-1 state, not the finished one.
