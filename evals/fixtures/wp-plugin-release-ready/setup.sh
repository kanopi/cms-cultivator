#!/usr/bin/env bash
# Fixture: WP plugin repo ready for a release — tagged 1.0.0, two
# conventional commits since (input for pr-release cases).
set -euo pipefail
rm -f setup.sh
git init -q -b main
git config user.email eval@kanopi.com
git config user.name "Behavioral Eval"
git add -A
git commit -qm "feat: initial plugin scaffold"
git tag v1.0.0

cat >> my-plugin.php <<'PHP'

function eval_fixture_goodbye() {
	return esc_html__( 'Goodbye from the eval fixture.', 'eval-fixture' );
}
PHP
git add my-plugin.php
git commit -qm "feat(greeting): add eval_fixture_goodbye()"

cat >> my-plugin.php <<'PHP'

function eval_fixture_shout( $text ) {
	return esc_html( strtoupper( $text ) );
}
PHP
git add my-plugin.php
git commit -qm "fix(greeting): escape shouted text before output"
