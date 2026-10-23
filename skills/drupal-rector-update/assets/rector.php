<?php

declare(strict_types=1);

use DrupalRector\Set\DrupalSetProvider;
use Rector\Config\RectorConfig;

/**
 * Drupal Rector — Composer-based sets.
 *
 * Set selection is driven by what is actually installed. Rector reads
 * drupal/core (and twig, phpunit, symfony) from composer.json and loads every
 * set up to and including your installed minor. A site on 11.4 loads the
 * 11.0 -> 11.4 rules; a site on 11.2 loads 11.0 -> 11.2. When you upgrade core,
 * the set selection moves with you — no version numbers to maintain here.
 *
 * This is the backward-compatibility-safe setup: it fixes what is deprecated on
 * YOUR installed core. To look AHEAD and prepare for the next major before you
 * upgrade, use the explicit Drupal{N}SetList sets with ->setDrupalVersion()
 * instead (see the drupal-rector README).
 */
return RectorConfig::configure()
  // Point Rector at your custom code only. Adjust `web` to `docroot` if that is
  // your document root. Never point it at contrib or core.
  ->withPaths([
    __DIR__ . '/web/modules/custom',
    __DIR__ . '/web/themes/custom',
  ])
  // Register the Drupal rule sets so Rector knows they exist.
  ->withSetProviders(DrupalSetProvider::class)
  // Select those sets automatically from composer.json. `drupal: true` is the
  // new part; the others give you the matching framework upgrades for free.
  ->withComposerBased(twig: TRUE, phpunit: TRUE, symfony: TRUE, drupal: TRUE)
  // Keep Rector away from things that should not be rewritten.
  ->withSkip([
    __DIR__ . '/web/modules/custom/*/tests/fixtures/*',
  ]);

/*
 * Optional — DrupalRectorSettings (backward-compatibility wrapping).
 *
 * BC wrapping is DISABLED by default, which is what site projects want. Turn it
 * on only when the same code must run on several Drupal versions at once — a
 * contrib module, typically — and set the minimum core you still support.
 *
 * This file uses the RectorConfig::configure() builder, which gives you no
 * $rectorConfig instance to call ->singleton() on, so the service has to be
 * registered the way the installed release documents. Read
 * vendor/palantirnet/drupal-rector/README.md before wiring it up.
 */
