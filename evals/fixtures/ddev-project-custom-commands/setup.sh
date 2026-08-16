#!/usr/bin/env bash
# Fixture: DDEV project whose commands are site-specific, not add-on defaults.
set -euo pipefail
rm -f setup.sh
git init -q -b main
git config user.email eval@kanopi.com
git config user.name "Behavioral Eval"
git add -A
git commit -qm "chore: seed ddev fixture"
