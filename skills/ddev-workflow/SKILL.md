---
name: ddev-workflow
description: >-
  Operate a Kanopi DDEV site day to day — get a fresh clone or worktree actually
  serving pages, pull a database from the hosting provider, compile the front-end
  build, and drive the Cypress or Playwright suites. Reads the project's real command
  set from `ddev help` and `.ddev/commands/` rather than assuming one. Invoke when a
  local site serves errors or a blank page, containers are up but nothing works, the
  database is empty or stale, compiled assets are missing after a clone, or the user
  mentions `ddev start`, `ddev init`, `db-refresh`, `db-rebuild`, `theme-build`,
  `theme-npm`, `cypress-run`, or `playwright-run`, or asks which ddev commands a
  project has.
---

# DDEV Workflow

Daily work in an already-provisioned Kanopi Drupal or WordPress site. Creating and
tearing down worktrees is `worktree-manager`; this skill is what you run inside one.

`ddev start` boots containers and nothing else. A fresh clone has no database, no
vendor directory, and no compiled theme assets, so the site will serve errors or a
blank page until the project's init command finishes. That gap is the single most
common cause of "my local is broken."

**Read-before-name (hard rule):** do not name a single `ddev` command until you have
read this project's command set, in step 2. Every table in this file is a description
of the add-on *defaults*; sites add, rename, and remove commands, so a name that is
right in general can be wrong here. Answering from these tables without reading
`.ddev/commands/` is CANT-20 in the
[Catalog of Agent Neutralization Techniques](https://github.com/kanopi/cant), and it
is the exact failure this skill exists to prevent. If you cannot read the command set,
say so and name none.

Red flags — stop if you catch yourself thinking:

- "I know the Kanopi commands, I don't need to look" (CANT-20)
- "It's a Kanopi site, so it'll have `db-refresh`" (CANT-20)
- "Close enough, they can run `ddev help` themselves" (CANT-7)

## 1. Detect

```bash
test -f .ddev/config.yaml && echo "DDEV project"
ls .ddev/commands/host .ddev/commands/web    # Kanopi add-on commands live here
```

Platform, from the command set and the repo:

- **Drupal** — `drupal-uli`, `drupal-open`, `recipe-apply` in `.ddev/commands/`;
  `web/core/lib/Drupal.php` or `docroot/core/`.
- **WordPress** — `wp-open`, `theme-activate`, `theme-create-block`;
  `wp-config.php` or `public/wp-content/`.

The two add-ons overlap by roughly 90 percent. Where they differ, it is the
platform-prefixed commands and the set of hosts `db-refresh` supports.

## 2. Read the real command set

Required before you answer. Sites customize their commands, and the add-ons ship more
than any document tracks.

```bash
ddev help                                  # every command available in this project
ddev help <command>                        # usage and flags for one command
```

If `ddev` cannot be run here — not installed, not started, command denied — read the
command files instead. They are plain text and each declares its own contract:

```bash
ls .ddev/commands/host .ddev/commands/web
grep -H '^## \(Description\|Usage\|Example\|Aliases\):' .ddev/commands/*/*
```

Command files carry `## Description`, `## Usage`, `## Example`, and `## Aliases`.
The aliases matter: most commands answer to two or three names, and the short one is
what people say out loud.

Then answer using **the names this project actually defines**, quoting the alias from
the header. If the project has no command for what was asked, say that, rather than
reaching for the name a different project would use. A project that ships
`db-refresh-scrubbed` and no plain `db-refresh` is telling you something about its
policy; recommending the command it deliberately does not have is worse than
answering "this project has no unscrubbed refresh."

## 3. Lifecycle

The *shape* below is stable across sites; the command **names** are add-on defaults
and must be confirmed against step 2 before you repeat any of them.

### Getting a site running

| Step | Command | Notes |
|---|---|---|
| Boot containers | `ddev start` | Containers only. The site is not usable yet |
| Everything else | `ddev init` (alias for `project-init`) | Composer, npm, Lefthook, NVM, and a database pull. Several minutes; run it in the background and do other work |
| First-time setup wizard | `ddev configure` (`project-configure`) | Interactive; sets hosting provider, theme path, and the rest |

After `ddev start` on a fresh clone or a new worktree, always run `ddev init`. A bare
`ddev start` is why the site serves nothing.

### Database

| Command | Does |
|---|---|
| `ddev db-refresh [env]` (alias `refresh`) | Pull a database from the hosting provider. Drupal: Pantheon, Acquia. WordPress: Pantheon, WPEngine, Kinsta, remote SSH |
| `ddev db-rebuild` (alias `rebuild`) | `composer install` plus a refresh. The "put it back how it was" command |
| `ddev db-prep-migrate` | Create and configure the migration database in the web container |

### Theme assets

Build output is compiled and usually gitignored, so a fresh clone has no CSS until
you build.

| Command | Does |
|---|---|
| `ddev theme-install` | Install the theme's build tooling. Once per clone |
| `ddev theme-build` (alias `production`) | Production build |
| `ddev theme-watch` (alias `development`) | Watch mode while developing |
| `ddev theme-npm <args>` | npm inside the container, in the theme directory |
| `ddev theme-npx <args>` | npx, same |

**Never `cd` into the theme and run bare `npm`.** The Node version and the install
live in the container, not on the host. `ddev theme-npm` runs in the right directory
with the right toolchain; a host-side `npm run build` either fails or silently
produces assets built against the wrong Node.

### Testing

| Command | Does |
|---|---|
| `ddev playwright-run` (`pwr`) | Playwright e2e suite. `playwright-install` first, `playwright-users` to seed logins |
| `ddev cypress-run` (`cy`, `cyr`) | Cypress suite. Same install/users pattern |
| `ddev critical-run` (`crr`) | Critical CSS generation |

### Getting into the site

| Platform | Command |
|---|---|
| Drupal | `ddev drupal-uli` (alias `uli`) for a one-time login link, `ddev drupal-open` (`open`) to launch |
| WordPress | `ddev wp-open` (`open`) to launch, `ddev wp-restore-admin-user` when the admin account is missing from a pulled database |

### Aliases worth knowing

`init`, `configure`, `refresh`, `rebuild`, `production`, `development`, `open`,
`testenv`, `uli`. These are what the add-on documentation and other developers use.

## 4. Host versus web commands

`.ddev/commands/host/` runs on your machine; `.ddev/commands/web/` runs inside the
container. It matters when a command needs host credentials or a browser:
`pantheon-terminus`, `cypress-*`, and `playwright-*` are host commands, while
`db-refresh`, `theme-*`, and `recipe-*` run in the web container.

You do not normally choose. `ddev <command>` dispatches correctly on its own. The
distinction shows up when a command fails on a missing binary: check which side it
runs on before installing anything.

## 5. Drupal and WordPress specifics

**Drupal** adds recipe tooling: `ddev recipe-apply` (alias `recipe`, `ra`) to apply a
recipe, `recipe-unpack` for one already required by the project, and `recipe-uuid-rm`
to strip UUIDs and `_core` metadata from exported config.

**WordPress** adds `ddev theme-create-block` (alias `create-block`) to scaffold a
block, and `ddev theme-activate` to switch the active theme.

Both add `ddev pantheon-testenv` (alias `testenv`) to stand up a testing environment,
and `ddev pantheon-tickle` to keep a sleepy Pantheon environment awake.

## Troubleshooting

| Symptom | Cause | Fix |
|---|---|---|
| Site loads but is blank or all errors | Containers started, nothing installed | `ddev init` |
| Content is missing or ancient | No database, or a stale one | `ddev db-refresh` |
| Page renders unstyled | Theme never built | `ddev theme-install` then `ddev theme-build` |
| `npm` errors about Node version | Ran npm on the host | Use `ddev theme-npm` |
| Cannot log in after a database pull | Production accounts, not local ones | Drupal: `ddev drupal-uli`. WordPress: `ddev wp-restore-admin-user` |
| A command in this file does not exist | The project customized its commands | `ddev help`. The project is right, this file is a snapshot |

## Related Skills

- `worktree-manager` creates and tears down the worktrees this skill runs inside.
- `code-standards-checker` for linting after you change code.
- The command reference in
  [DDEV Commands](https://kanopi.github.io/cms-cultivator/kanopi-tools/ddev-commands/)
  is a snapshot of the add-ons. `ddev help` is the live source.
