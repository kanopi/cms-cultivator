#!/usr/bin/env bash
# Fixture: same Drupal site as drupal-site-legacy-rector, but with an
# uncommitted edit to custom code, so the skill's clean-tree gate must hold.
set -euo pipefail
rm -f setup.sh
git init -q -b main
git config user.email eval@kanopi.com
git config user.name "Behavioral Eval"
git add -A
git commit -qm "chore: initial Drupal site scaffold"

cat >> web/modules/custom/example/example.module <<'PHP'

/**
 * Work in progress, not yet committed.
 */
function example_wip() {
  return \Drupal::service('date.formatter')->format(time());
}
PHP
