# Git Hosts

Not every repository is on GitHub. Detect the host from the remote before running any
host command, and use that host's column everywhere `SKILL.md` shows a `gh` command.

## Detect the host

```bash
git remote get-url origin
```

| Remote contains | Host | CLI |
|---|---|---|
| `github.com`, or a GitHub Enterprise host `gh auth status` lists | GitHub | `gh` |
| `gitlab.com`, `git.drupalcode.org`, or a self-hosted host `glab auth status` lists | GitLab | `glab` |
| `bitbucket.org` | Bitbucket Cloud | none |
| anything else (Azure DevOps, Gitea, self-hosted Bitbucket) | other | none |

A hostname that is none of the above is not GitHub by default. When neither `gh auth
status` nor `glab auth status` lists it, treat it as "other".

GitLab calls a pull request a merge request (MR) and numbers it with an IID, used below
as `<n>`. Say "merge request" in what you report to the user on a GitLab repository.

## Commands by host

| Need | GitHub | GitLab |
|---|---|---|
| Default branch | `gh repo view --json defaultBranchRef --jq .defaultBranchRef.name` | `glab repo view -F json \| jq -r .default_branch` |
| Auth check | `gh auth status` | `glab auth status` |
| Create | `gh pr create --base <base> --head <branch> --title "<title>" --body-file -` | `glab mr create --source-branch <branch> --target-branch <base> --title "<title>" --description "$(cat "$BODY_FILE")" --yes` |
| Read body | `gh pr view <n> --json body -q .body` | `glab mr view <n> -F json \| jq -r .description` |
| Write body | `gh pr edit <n> --body-file -` | `glab mr update <n> --description "$(cat "$BODY_FILE")" --yes` |
| Comments | `gh pr view <n> --json comments -q '.comments[].body'` | `glab mr view <n> --comments` |
| Checks / statuses | `gh pr checks <n>` | `glab api "projects/:id/repository/commits/$(git rev-parse HEAD)/statuses"` |

The host-independent fallback for the default branch:

```bash
git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'
```

### GitLab body handling

`glab` has no `--body-file`, so write the body to a file with a quoted heredoc, then
pass it with `"$(cat "$BODY_FILE")"`. The quoted delimiter still keeps the shell from
touching the body; the double quotes around the substitution keep it one argument.

```bash
BODY_FILE=$(mktemp)
cat > "$BODY_FILE" <<'PRBODY'
<description>
PRBODY
glab mr create --source-branch <branch> --target-branch <base> \
  --title "<title>" --description "$(cat "$BODY_FILE")" --yes
```

`glab mr create` does not push unless told to. Push the branch first
(`git push -u origin <branch>`), or the create call fails on a missing source branch.

### Bitbucket Cloud and other hosts

There is no standard CLI, so the PR cannot be created from here. Push the branch, then
hand the user the title, the body in a fenced block, and the host's new-PR page:

- **Bitbucket Cloud:** `https://bitbucket.org/<workspace>/<repo>/pull-requests/new?source=<branch>&dest=<base>`
- **Other:** the repository's web URL; name the host so the user knows where to open it.

This is the same as the no-CLI fallback in `SKILL.md`, not a reason to stop early.

## Templates

| Host | Repository template |
|---|---|
| GitHub | `.github/PULL_REQUEST_TEMPLATE.md`, `PULL_REQUEST_TEMPLATE.md`, `docs/PULL_REQUEST_TEMPLATE.md`, `.github/PULL_REQUEST_TEMPLATE/` |
| GitLab | `.gitlab/merge_request_templates/Default.md`, else the only file in `.gitlab/merge_request_templates/` |
| Bitbucket | none in the repository; default descriptions live in repository settings |

Only GitHub has an org-level `.github` repository fallback. On every other host, the
repository template or the built-in template in `SKILL.md` is the whole search.
