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
    __DIR__ . '/web/modules/custom/*/tests/*',
  ]);

/*
 * Optional — DrupalRectorSettings.
 *
 * Backward-compatibility wrapping is DISABLED by default, which is what most
 * site projects want (the output targets your installed core). Enable it only
 * when the same code must run on multiple Drupal versions at once — e.g. a
 * contrib module. When you do, set the minimum core you still support so BC
 * wrappers are emitted correctly:
 *
 * use DrupalRector\Drupal\DrupalRectorSettings;
 *
 * $rectorConfig->singleton(DrupalRectorSettings::class, fn () =>
 *   (new DrupalRectorSettings())
 *     ->enableBackwardCompatibility()
 *     ->setMinimumCoreVersionSupported('10.5.0')
 * );
 */
