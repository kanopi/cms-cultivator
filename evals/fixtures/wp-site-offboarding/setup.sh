#!/usr/bin/env bash
# Fixture: a Composer-managed WordPress site on Pantheon with CircleCI, one paid
# plugin from a private Composer repo, and one paid plugin committed to the repo.
set -euo pipefail
rm -f setup.sh
git init -q -b main
git config user.email eval@kanopi.com
git config user.name "Behavioral Eval"
git add -A
git commit -qm "chore: initial site scaffold"
