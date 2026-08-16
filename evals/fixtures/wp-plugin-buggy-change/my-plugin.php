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
	return esc_html__( 'Hello from the eval fixture.', 'eval-fixture' );
}
