#!/usr/bin/env bash
# Fixture: a branch whose only change is whitespace reindentation. Nothing to review.
set -euo pipefail
rm -f setup.sh
git init -q -b main
git config user.email eval@kanopi.com
git config user.name "Behavioral Eval"
git add -A
git commit -qm "feat: initial plugin scaffold"

git checkout -qb chore/reformat
# Re-indent with spaces instead of tabs. No logic change whatsoever.
python3 - <<'PY'
p = "my-plugin.php"
s = open(p).read().replace("\t", "    ")
open(p, "w").write(s)
PY
git add my-plugin.php
git commit -qm "style: reindent plugin file with spaces"
