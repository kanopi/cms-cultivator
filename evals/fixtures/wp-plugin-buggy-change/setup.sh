#!/usr/bin/env bash
# Fixture: a branch adding a function with an off-by-one loop bound on an added
# line. Unambiguous, in-diff, and not something a linter reports.
set -euo pipefail
rm -f setup.sh
git init -q -b main
git config user.email eval@kanopi.com
git config user.name "Behavioral Eval"
git add -A
git commit -qm "feat: initial plugin scaffold"

git checkout -qb feature/recent-post-titles
cat >> my-plugin.php <<'PHP'

/**
 * Collect the titles of the most recent posts.
 *
 * @param int $limit How many posts to return.
 * @return string[] Post titles.
 */
function eval_fixture_recent_titles( $limit = 5 ) {
	$posts  = get_posts( array( 'numberposts' => $limit ) );
	$titles = array();

	for ( $i = 0; $i <= count( $posts ); $i++ ) {
		$titles[] = $posts[ $i ]->post_title;
	}

	return $titles;
}
PHP
git add my-plugin.php
git commit -qm "feat(posts): add eval_fixture_recent_titles()"
