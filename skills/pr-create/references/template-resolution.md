# PR Template Resolution

Step 7 of `SKILL.md` passes the body explicitly, which skips the host CLI's own template
population, so never rely on `gh` or `glab` to insert it. Resolve the template
explicitly for the detected host (see `git-hosts.md`) and use the first hit:

```bash
# 1. This repository — always wins over the org default
#    GitHub
ls .github/PULL_REQUEST_TEMPLATE.md PULL_REQUEST_TEMPLATE.md \
   docs/PULL_REQUEST_TEMPLATE.md .github/PULL_REQUEST_TEMPLATE/ 2>/dev/null
#    GitLab — Default.md, else the only template in the directory
ls .gitlab/merge_request_templates/ 2>/dev/null

# 2. GitHub only: the organization's public .github repository
ORG=$(gh repo view --json owner -q .owner.login)
for P in .github/PULL_REQUEST_TEMPLATE.md PULL_REQUEST_TEMPLATE.md \
         docs/PULL_REQUEST_TEMPLATE.md; do
  gh api "repos/$ORG/.github/contents/$P" -q .content 2>/dev/null \
    | base64 -d && break
done
```

Skip step 2 on any host other than GitHub — the org `.github` repository is a GitHub
feature. Bitbucket keeps default descriptions in repository settings, not files, so
step 1 finds nothing there.

If neither exists, use the built-in template in `SKILL.md` — Kanopi's org default.
