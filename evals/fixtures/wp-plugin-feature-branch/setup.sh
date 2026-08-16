#!/usr/bin/env bash
# Fixture: WP plugin repo on a feature branch, two commits ahead of main.
set -euo pipefail
rm -f setup.sh
git init -q -b main
git config user.email eval@kanopi.com
git config user.name "Behavioral Eval"
git add -A
git commit -qm "feat: initial plugin scaffold"

git checkout -qb feature/goodbye-message

cat >> my-plugin.php <<'PHP'

function eval_fixture_goodbye() {
	return esc_html__( 'Goodbye from the eval fixture.', 'eval-fixture' );
}
PHP
git add my-plugin.php
git commit -qm "feat(greeting): add eval_fixture_goodbye()"

cat >> readme.txt <<'TXT'

== Changelog ==
= 1.1.0 =
* Add goodbye message helper.
TXT
git add readme.txt
git commit -qm "docs(readme): document goodbye helper in changelog"
