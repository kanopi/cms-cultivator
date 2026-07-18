#!/usr/bin/env bash
# Fixture: WP plugin repo with a staged, uncommitted change (input for
# commit-message-generator cases).
set -euo pipefail
rm -f setup.sh
git init -q -b main
git config user.email eval@kanopi.com
git config user.name "Behavioral Eval"
git add -A
git commit -qm "feat: initial plugin scaffold"

cat >> my-plugin.php <<'PHP'

function eval_fixture_farewell() {
	return esc_html__( 'Farewell from the eval fixture.', 'eval-fixture' );
}
PHP
git add my-plugin.php
