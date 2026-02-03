<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

$global = \Statamic\Facades\GlobalSet::findByHandle('groepsleiding');
if (!$global) {
    echo "Global 'groepsleiding' not found!\n";
    exit(1);
}

$data = $global->inDefaultSite()->data()->all();
echo "Global found!\n";
echo "Keys: " . implode(', ', array_keys($data)) . "\n";
echo "groepsleiding_leden count: " . (isset($data['groepsleiding_leden']) ? count($data['groepsleiding_leden']) : '0') . "\n";

if (isset($data['groepsleiding_leden'])) {
    foreach ($data['groepsleiding_leden'] as $i => $lid) {
        echo "Lid $i: " . ($lid['naam'] ?? 'no name') . "\n";
    }
}
