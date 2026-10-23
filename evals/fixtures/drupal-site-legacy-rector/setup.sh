#!/usr/bin/env bash
# Fixture: Drupal 11 site on PHPStan 1 with a hand-maintained Drupal{N}SetList
# rector.php, committed on a clean tree (input for drupal-rector-update cases).
set -euo pipefail
rm -f setup.sh
git init -q -b main
git config user.email eval@kanopi.com
git config user.name "Behavioral Eval"
git add -A
git commit -qm "chore: initial Drupal site scaffold"
