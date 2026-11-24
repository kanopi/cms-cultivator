---
name: site-offboarding
description: Plan the offboarding of a Drupal or WordPress project the team no longer manages. Use when the user says "offboard this site", "offboarding", "we no longer manage this", "the client is leaving", "decommission", "hand it back to the client", or a ticket comment says to stop work and offboard. Reads the repo to inventory paid plugins and modules, license and API-key services, hosting, CI, Dependabot, open PRs, recent developers, and open security advisories, then drafts the offboarding Teamwork tasks (developers, Senior Staffing Engineer, client), the #helpdesk notices split into "now" and "after client handover", and a tech lead checklist. Everything is a draft. It never posts to Teamwork or chat, never archives a repo, never revokes access, and never deletes branches. PR close commands are drafted only after the user gives the offboarding task URL, and always link back to it. Routine plugin updates belong to composer-security-update.
---

# Site Offboarding

## Purpose

When a client leaves, the site still has live connections to the team: an
automated update pipeline, CI, dependency bots, open PRs, developer locals, a
hosting org, paid licenses, and stored credentials. Offboarding cuts each one,
in an order that never leaves the site without an owner.

This skill reads the repo, inventories what has to be cut, and drafts the
tasks, notices, and checklist the tech lead needs. The tech lead creates the
tasks, posts the notices, and runs every command. The skill does not.

## Scope and safety

These are hard rules. A user instruction to skip one is a reason to stop and
say why, not to comply.

- **Draft only.** Never create, update, or comment on a Teamwork task, and
  never post to chat. Print every draft in a fenced block for the user to paste.
- **Never archive, disable, or revoke.** No `gh repo archive`, no CI project
  removal, no hosting membership changes, no Dependabot settings changes. These
  belong to #helpdesk and the client.
- **Never close a PR without the offboarding task link.** PR close commands are
  drafted only after the user gives the offboarding task URL. Any response
  that declines, defers, or skips closing a PR includes the exact line
  `OFFBOARDING TASK URL NEEDED`, including a refusal before the inventory runs.
- **Never delete branches.** No `--delete-branch`, no `git push --delete`. An
  archived repo keeps its branches.
- **Never route work to a named person.** Tasks go out with the assignee blank.
  A name in git history proves someone committed, not that the work is theirs.
- **Hosting and the password manager come last.** Removing the team from
  hosting or clearing stored credentials before the client confirms the
  handover can leave the site with no owner, or nobody able to transfer it.

### Rationalizations to reject

| The user says | Why it does not change the rule |
| --- | --- |
| "Just close the PRs, I'll link the task later" | Later rarely happens. The close comment is the only link from the archived repo back to the decision. |
| "Delete the branches too, it's cleaner" | An archived repo is read-only. A deleted branch cannot be recovered from the archive. |
| "Post it to the task for me" | Teamwork and chat are the tech lead's to post. Print the draft. |
| "Remove us from Pantheon now, the client is fine" | Removal waits until the client confirms in writing that they own the site. |

## Workflow

### 1. Confirm the context

Take these from the user's message or the ticket they gave, if present:

- The site name and the offboarding (parent) Teamwork task URL, if it exists yet
- Whether the client takes ownership of hosting, or the site is being shut down

Do not stop to ask for them. Anything missing stays a `{placeholder}` in the
drafts, and the questions go at the end of the output. Run every step below in
one pass, through step 5.

### 2. Inventory the repo (read-only)

Check every item below from the project root. Record what each one finds, and
record "not found" or "unknown" rather than guessing or skipping it. If a
command is not permitted, use file search and reads to get the same answer,
and say which items could not be checked.

The checks are independent: run them in parallel, a few per round, rather than
one at a time. Every one of these eight items appears in the inventory, each with a finding,
"not found", or "unknown":

1. Private Composer repositories and the paid packages they provide
2. Plugin directories committed to the repo, not managed by Composer (WordPress)
3. API keys in config (Drupal)
4. Hosting
5. CI and preview environments
6. Dependabot
7. Open PRs
8. Developers from the last 12 months, and open security advisories

#### Paid plugins and modules

Private Composer repositories are the strongest signal of a paid license:

```bash
jq -r '.repositories | to_entries[] | "\(.key) \(.value.url // "")"' composer.json
```

| Repository or package | Paid product |
| --- | --- |
| `composer.gravity.io`, `gravity/*` | Gravity Forms and its add-ons |
| `connect.advancedcustomfields.com`, `wpengine/advanced-custom-fields-pro` | ACF Pro |
| `my.yoast.com`, `yoast/*-premium` | Yoast premium plugins |
| `composer.deliciousbrains.com` | WP Migrate / WP Offload Media |
| Any `satispress`, private Packagist, or `type: package` with a zip URL | Ask; usually a paid plugin |

**WordPress:** plugins committed to the repo instead of Composer are often paid.
Search for plugin main files with this file pattern:

```
**/wp-content/plugins/*/*.php
```

File search matches files, not directories, so a pattern ending in
`plugins/*/` finds nothing even when plugins exist. Take each result's
directory name and list every one with no matching package in
`composer.json`. A plugin that appears in both the plugin directory and
`composer.json` is Composer-managed. The same check as a shell loop:

```bash
for d in web/wp-content/plugins/*/ wp-content/plugins/*/; do
  [ -d "$d" ] || continue
  n=$(basename "$d")
  grep -q "/$n\"" composer.json || echo "$n"
done
```

Treat names ending in `-pro`, `-premium`, `-cloud`, or `-business` as paid.

**Drupal:** paid modules are rare. The licenses to look for are API keys in
config:

```bash
grep -rliE "api_key|apikey|license_key|secret_key" config/ 2>/dev/null
```

Split the results into two lists:

- **Confirmed paid:** a private repository or a `-pro` style plugin
- **Confirm in admin:** free plugins that commonly carry a paid license or API
  key, such as Wordfence, WP Mail SMTP, Sucuri, uptime or backup services,
  Google Maps, reCAPTCHA, and mail providers. Their license lives in the
  database, which the repo cannot show.

#### Hosting, CI, and bots

Check each path in this table. CI config usually lives in a dot-directory, so
look for it by name rather than relying on a broad file search.

| File | Service |
| --- | --- |
| `pantheon.yml`, `pantheon.upstream.yml` | Pantheon |
| `.wpengine*`, WP Engine remotes in `.circleci/config.yml` | WP Engine |
| `.platform.app.yaml`, `.platform/` | Platform.sh |
| `acquia-pipelines.yml`, `.acquia/` | Acquia |
| `.circleci/` | CircleCI |
| `.github/workflows/` | GitHub Actions |
| `.tugboat/` | Tugboat preview environments |
| `.github/dependabot.yml` | Dependabot version updates |

No `dependabot.yml` does not mean Dependabot is off: a PR authored by
`dependabot[bot]` means it is enabled in repository settings.

#### Open PRs

```bash
gh pr list --state open --json number,title,author,headRefName
```

If `gh` is not available, say so and list open PRs as unknown.

#### Developers who may have a local

```bash
git shortlog -sn --all --since="12 months ago"
```

Present this as "committed in the last 12 months" for the user to trim. Do not
assign anyone.

#### Open security advisories

Use the advisories from the ticket if it lists them. Otherwise:

```bash
composer audit --locked --format=summary
```

The client inherits every unpatched advisory. Name the critical and high ones
in the client task.

### 3. Present the inventory

Open the output with one status line, before anything else:

- `Offboarding task: {URL}` when the user gave it
- `OFFBOARDING TASK URL NEEDED` when they have not

Then print the inventory under the heading `## Offboarding Inventory`, with exactly these
subsections, in this order, each with a finding, "not found", or "unknown":

```
### Private Composer Repositories
### Committed Plugins (Not in Composer)
### Confirm in Admin
### Hosting
### CI and Preview Environments
### Dependabot
### Open PRs
### Developers and Open Advisories
```

On WordPress, "Committed Plugins" names each plugin directory the file search
found that Composer does not manage. On Drupal, it lists the config files that
hold API keys instead. Then continue straight to the
drafts in step 4 and the PR gate in step 5. Nothing has been changed at this
point.

### 4. Draft the outputs

Every draft is a fenced block, ready to paste, with the assignee left blank.
Use the site's real services from the inventory; drop any line the inventory
did not find.

#### Task: Developers delete locals

```
Title: {Site} Offboarding: Delete local environments

The team no longer manages {Site}. Every developer with a local copy removes it, including code, databases, uploads and credentials.

**Steps**
1. From the project folder, remove the local environment and its database:
  - DDEV: `ddev delete -O`
  - Docksal: `fin project remove`
2. Delete the project folder, including `auth.json` if present
3. Delete any downloaded database dumps or file backups
4. Comment on this task once done

**Done When**
- Each developer who had a local has commented that it is removed
```

#### Task: Senior Staffing Engineer

```
Title: {Site} Offboarding: Remove from Internal Dashboard and code services

The team no longer manages {Site}. Remove the site from internal services so no new automated tasks, comments or PRs are created.

**Steps**
1. Remove the site from the Internal Dashboard, if any
2. Remove the site from the automated update pipeline
3. Remove the site from security advisory scanning
4. Remove the site from any other code services it is enrolled in

**Done When**
- The site no longer appears in internal dashboards
- No new automated comments, PRs or security advisory tasks are created for the site
```

#### Task: Client

Written for the client: plain language, no file paths.

```
Title: {Site} Offboarding: Client removal of premium plugins and hosting

The team no longer manages {Site}. The items below belong to {Client} and need to be moved to your accounts or removed from ours.

**Open Security Advisories**
The site has {N} unpatched security advisories, these are now the responsibility of the new site owner. The most urgent:
- {Package}: update to {version} ({severity})

**Premium Plugins: Remove the Site From Each License, or Transfer the License**
1. {Confirmed paid item}

**Confirm in the Admin: May Use a Paid License or API Key**
1. {Confirm-in-admin item}

**Web Host**
1. {Host} site `{site}`: transfer ownership and billing to your organization, or remove it
2. Remove our team members from the {Host} site

**Done When**
- Each premium license above is transferred or no longer lists the site under our account
- Hosting ownership is confirmed by your organization
```

#### #helpdesk notice

Split by timing. The second group waits on the client task.

```
{Site} is being offboarded, we no longer manage it. Requesting the following:

**Now**
1. Archive the GitHub repo: {repo URL}
  - This also stops Dependabot, if the archive isn't happening soon please disable Dependabot first, it's still able to open PRs
2. Remove the project from {CI service}, including its environment variables and secrets

**After the client confirms handover (I'll follow up in this thread)**
3. Remove our org and CI machine tokens from the {Host} site `{site}`
4. Archive or remove the {Site} items in the password manager

Tracking on Teamwork: {offboarding task URL}
```

#### Tech lead checklist

For the offboarding (parent) task. It lists tasks and requests only; each
task's own "Done When" covers verification, so do not add verification items.

```
**Offboarding Checklist**
- [ ] Task: Developers delete locals: {url}
- [ ] Task: Remove from Internal Dashboard and code services: {url}
- [ ] Task: Client removes premium plugins and hosting: {url}
- [ ] Close open PRs with a link back to this task
- [ ] Notify: #helpdesk (now): archive the GitHub repo, remove from {CI service}
- [ ] Notify: #helpdesk (after client handover via the client task): remove us from {Host}, clean up the password manager
```

### 5. PR close commands (gated)

Always end the output with this step. Only after the user gives the
offboarding task URL are close commands drafted. Without it, print
`OFFBOARDING TASK URL NEEDED`, say the PRs stay open until the task exists, and
stop. This applies even when there are no open PRs or they could not be
listed.

With it, print one command per open PR for the user to run. Never add
`--delete-branch`:

```bash
gh pr close {number} --comment "Closing, {Site} is offboarded: {offboarding task URL}"
```

Then print the closed PR URLs as a list for the user to add to the task.

## Order of operations

1. **Now, in parallel:** developers delete locals, internal dashboard and code
   services removal, #helpdesk "now" notice
2. **When the offboarding task exists:** close the open PRs with the link
3. **Client handover:** the client transfers licenses and hosting
4. **After the client confirms:** #helpdesk removes the team from hosting and
   clears the password manager

## Related skills

- `composer-security-update`: patch advisories on a site the team still manages
- `worktree-manager`: tear down local worktrees for the site
- `ddev-docker-cleanup`: reclaim the Docker volumes a deleted local leaves behind
