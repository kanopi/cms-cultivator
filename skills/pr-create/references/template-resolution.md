# PR Template Resolution

Step 9 passes the body with `--body-file`, which skips `gh`'s own template
population, so never rely on `gh` to insert it. Resolve the template explicitly
and use the first hit:

```bash
# 1. This repository — always wins over the org default
ls .github/PULL_REQUEST_TEMPLATE.md PULL_REQUEST_TEMPLATE.md \
   docs/PULL_REQUEST_TEMPLATE.md .github/PULL_REQUEST_TEMPLATE/ 2>/dev/null

# 2. The organization's public .github repository
ORG=$(gh repo view --json owner -q .owner.login)
for P in .github/PULL_REQUEST_TEMPLATE.md PULL_REQUEST_TEMPLATE.md \
         docs/PULL_REQUEST_TEMPLATE.md; do
  gh api "repos/$ORG/.github/contents/$P" -q .content 2>/dev/null \
    | base64 -d && break
done
```

If neither exists, use the built-in template in `SKILL.md` — Kanopi's org default.
