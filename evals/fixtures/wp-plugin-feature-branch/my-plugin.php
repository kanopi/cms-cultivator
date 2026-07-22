<?php
/**
 * Plugin Name: Eval Fixture Plugin
 * Description: Tiny WordPress plugin used by the behavioral eval harness.
 * Version: 1.0.0
 */

function eval_fixture_greeting() {
	return esc_html__( 'Hello from the eval fixture.', 'eval-fixture' );
}
