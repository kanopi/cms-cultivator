<?php

declare(strict_types=1);

use DrupalRector\Set\Drupal10SetList;
use DrupalRector\Set\Drupal11SetList;
use Rector\Config\RectorConfig;

return static function (RectorConfig $rectorConfig): void {
  $rectorConfig->sets([
    Drupal10SetList::DRUPAL_10,
    Drupal11SetList::DRUPAL_11,
  ]);
  $rectorConfig->paths([
    __DIR__ . '/web/modules/custom',
  ]);
};
