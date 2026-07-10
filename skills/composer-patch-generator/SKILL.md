---
name: composer-patch-generator
description: Generate and maintain patches for Composer-installed packages (Drupal contrib modules, WordPress packages, PHP libraries) using cweagans/composer-patches. Invoke when the user needs to modify a contrib or vendor package, mentions "composer patch", "patch a module", "patch a contrib module", "cweagans", "diff -ruN", "extra.patches", or needs a package change that applies cleanly in CI. Covers generating diff -ruN patches, handling new files, wiring composer.json, and verifying the patch applies.
---

# Composer Patch Generator

Generate reliable, CI-safe patches for Composer-managed packages you cannot edit
directly (Drupal contrib modules, WordPress plugins/packages, PHP libraries).

## Philosophy

Contrib and vendor code is not yours to fork. Patches let you carry a change on
top of an upstream release, re-apply it on every `composer install`, and drop it
the moment upstream ships a fix.

### Core Beliefs

1. **Patches are temporary by design** — always describe the change so it can be
   removed when upstream merges it.
2. **CI is the source of truth** — a patch that applies locally but fails in CI
   is a broken patch. Generate for how CI applies, not how your laptop does.
3. **Minimal surface** — a patch should contain only your delta, never build
   artifacts, `.git` metadata, or tooling files.
4. **Never edit `vendor/` or `web/modules/contrib/` directly** — those dirs are
   git-ignored and rebuilt on install. The patch is the only durable artifact.

## When to Use This Skill

Activate when the user:
- Wants to change a Composer-installed package (contrib module, plugin, library).
- Mentions "composer patch", "patch this module", "cweagans", "extra.patches".
- Says a change "needs to be a patch" or "applies in CI but not locally" (or vice versa).
- Needs to create, update, or debug an entry under `extra.patches` in `composer.json`.

Do **not** use for changes to custom (first-party) modules/themes — edit those directly.

## Critical Rules (why patches fail in CI)

These are the failure modes that cause "works locally, fails on CI":

1. **Use `diff -ruN`, NOT `git diff`.** `cweagans/composer-patches` tries
   `git apply` only when the install dir has a `.git` folder. CI installs with
   `--prefer-dist` (archives, no `.git`), so it falls back to the `patch`
   command — which cannot parse git headers (`diff --git`, `new file mode
   100644`, `index abc..def`). `diff -ruN` is universally compatible.
2. **Base the diff on the dist archive, not a `git clone`.** Drupal.org dist
   `.zip`/`.tar.gz` files differ from the git repo: they add `LICENSE.txt` and
   packaging metadata (version/datestamp lines appended to `.info.yml`). CI uses
   the dist. If you diff against a clone, those files show up as spurious "new
   file" hunks that fail when `patch` finds them already present.
3. **Never pass `--exclude` to `diff -ruN`.** It leaks into the header lines
   (`diff -ruN --ex a/file b/file`) and breaks `patch` parsing. Delete unwanted
   dirs (`.git`, `node_modules`) *before* diffing instead.
4. **Exclude tool artifacts.** After a patched install, the package dir contains
   a `PATCHES.txt` written by composer-patches. Never let it into your diff.

## Workflow

### 1. Identify the package, version, and prior patches

```bash
# Exact installed version (drives which dist archive to download).
grep -E "^version|datestamp" web/modules/contrib/<module>/<module>.info.yml
# Or from the lock file:
grep -A2 '"name": "drupal/<module>"' composer.lock | head -3

# Any patches already applied (yours must stack cleanly on top of these).
grep -A6 '"drupal/<module>"' composer.json
```

### 2. Snapshot a pristine base BEFORE editing

Edit the installed files in place (so you can test live), and diff them against
a clean snapshot of the *same version*.

```bash
WORK=/tmp/patch_gen && rm -rf "$WORK" && mkdir -p "$WORK"
# Preferred base = the dist archive CI will use:
curl -sL "https://ftp.drupal.org/files/projects/<module>-<version>.zip" -o "$WORK/dist.zip"
unzip -q "$WORK/dist.zip" -d "$WORK/base_dl"     # -> $WORK/base_dl/<module>
cp -r "$WORK/base_dl/<module>" "$WORK/base"

# If earlier patches exist, apply them to the base first so your diff is a
# clean delta ON TOP of them (order matters — composer applies in listed order):
( cd "$WORK/base" && patch -p1 --no-backup-if-mismatch < /path/to/earlier-patch.patch )
```

If you cannot download the dist (no network, private package), snapshot the
current installed dir *before* you edit as the base — acceptable as long as no
uncommitted edits exist yet and no unpatched files you'll touch differ from dist.

### 3. Make your edits to the installed package

Edit files under `web/modules/contrib/<module>/` (or `vendor/<pkg>/`) directly.
Run the project's checks on the changed files (e.g. `composer phpcs`,
`composer phpstan`, unit tests) before generating the patch.

### 4. Generate the patch with `diff -ruN`

```bash
# Mirror the edited install into a clean "modified" tree (drop noise + artifacts).
rsync -a --exclude='.git' --exclude='node_modules' \
  web/modules/contrib/<module>/ "$WORK/modified/"
rm -f "$WORK/modified/PATCHES.txt"          # composer-patches artifact — never patch it
rm -rf "$WORK/base/.git" "$WORK/modified/.git"

# Confirm ONLY the files you intended changed:
diff -qr "$WORK/base" "$WORK/modified"

# Emit the patch, normalizing paths to a/ … b/ (what `patch -p1` expects):
( cd "$WORK" && diff -ruN base/ modified/ \
  | sed 's|^--- base/|--- a/|; s|^+++ modified/|+++ b/|; \
         s|^diff -ruN base/|diff -ruN a/|; s| modified/| b/|' \
  ) > patches/<module>-<short-description>.patch
```

New files are handled automatically by `diff -ruN` (uses an epoch timestamp on
the `---` line), unlike `git diff`'s unparseable `new file mode` header.

### 5. Wire it into `composer.json`

```json
"extra": {
    "patches": {
        "drupal/<module>": {
            "Short description of the change (link to upstream issue/MR if any)": "patches/<module>-<short-description>.patch"
        }
    }
}
```

Patches for one package apply in listed order; each must apply on top of the
previous. If a patch needs a non-default strip level, add
`"extra": { "patchLevel": { "drupal/<module>": "-p1" } }`.

### 6. Verify (the step that catches CI failures)

```bash
# a) CI-equivalent dry run on a fresh pristine copy:
cp -r "$WORK/base_dl/<module>" "$WORK/verify"
( cd "$WORK/verify" && patch -p1 --dry-run --no-backup-if-mismatch < patches/<module>-<desc>.patch; echo "exit: $?" )

# b) End-to-end through Composer (definitive):
composer reinstall drupal/<module> --no-interaction
# NOTE: reinstall deletes the dir then reports "Uninstall failed / not installed".
# That is a known cweagans quirk — follow with:
composer install --no-interaction
# Look for: "Applying patches for drupal/<module>" with no errors.
```

Both must succeed. Re-run the project's lint/tests once more against the
freshly patched install to confirm nothing drifted.

## Updating an existing patch

Regenerate against a base that has all *prior* patches applied but not the one
you are rewriting. The diff then captures the new delta only. Re-verify with the
full stack applied in order.

## Report Format

When done, summarize:

```
## Composer Patch: <module>-<description>

- Package: drupal/<module> <version> (dist)
- Files changed: <list>
- New files: <list or none>
- composer.json: entry added under extra.patches["drupal/<module>"]
- Verified: patch -p1 dry-run ✅ | composer install "Applying patches" ✅
- Checks: phpcs ✅ | phpstan ✅ | tests ✅
- Upstream: <issue/MR link, or "none — local customization">
```

## Common Gotchas

- **Works locally, fails on CI:** almost always `git diff` format or a `.git`
  dir enabling `git apply` locally. Regenerate with `diff -ruN`.
- **"Cannot apply patch" on a new file:** the file already exists in dist (you
  based the diff on a git clone). Rebuild the base from the dist archive.
- **Lock-file warning after editing `composer.json`:** adding an `extra.patches`
  entry does not change dependency versions, so no `composer update` is needed;
  the warning is benign. Only re-lock if you changed a `require`.
- **Patch silently does nothing:** wrong strip level — set `extra.patchLevel`.
- **Package dir is git-ignored:** expected. Only the patch file in `patches/`
  and the `composer.json` entry are committed; the module files are not tracked.

## Example Interactions

```
You: "I need to fix a bug in the drupal/ai contrib module and it has to survive composer install."
Claude: "I'll create a composer patch. First, the installed version and any existing
patches for drupal/ai, then I'll snapshot the pristine dist as the base, apply your
edit, generate a diff -ruN patch, wire it into extra.patches, and verify it applies
via composer install."
```

```
You: "My patch applies on my machine but the pipeline says 'Cannot apply patch'."
Claude: "That's the classic git-diff-vs-patch mismatch. CI installs from dist archives
with no .git dir, so composer-patches falls back to the `patch` command, which can't
read git headers. Let me regenerate it in diff -ruN format based on the dist archive."
```

## Resources

- [cweagans/composer-patches](https://github.com/cweagans/composer-patches)
- [Drupal.org: patch conventions](https://www.drupal.org/docs/develop/git/using-git-to-contribute-to-drupal/creating-a-patch)
- `patch(1)` and `diff(1)` man pages
