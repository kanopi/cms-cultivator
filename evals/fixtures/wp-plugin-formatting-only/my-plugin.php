<?php
/**
 * Plugin Name: Eval Fixture Plugin
 * Description: Fixture for behavioral evals.
 * Version: 1.0.0
 */

function eval_fixture_greeting() {
	return esc_html__( 'Hello from the eval fixture.', 'eval-fixture' );
}

function eval_fixture_render() {
	echo '<p>' . esc_html( eval_fixture_greeting() ) . '</p>';
}
