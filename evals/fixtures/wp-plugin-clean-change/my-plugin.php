<?php
/**
 * Plugin Name: Eval Fixture Plugin
 * Description: Fixture for behavioral evals.
 * Version: 1.0.0
 */

/**
 * Return the greeting shown on the front end.
 *
 * @return string Escaped greeting text.
 */
function eval_fixture_greeting() {
	return esc_html( 'Hello from the eval fixture.' );
}

/**
 * Render the greeting.
 *
 * @return void
 */
function eval_fixture_render() {
	echo '<p>' . esc_html( eval_fixture_greeting() ) . '</p>';
}
