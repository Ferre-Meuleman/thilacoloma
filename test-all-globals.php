<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

// List all globals
echo "All globals:\n";
$allGlobals = \Statamic\Facades\GlobalSet::all();
foreach ($allGlobals as $global) {
    echo " - " . $global->handle() . " (Title: " . $global->title() . ")\n";
}

echo "\n\nLeidingsploegen global:\n";
$leidingGlobal = \Statamic\Facades\GlobalSet::findByHandle('leidingsploegen');
if ($leidingGlobal) {
    $data = $leidingGlobal->inDefaultSite()->data()->all();
    echo "Keys: " . implode(', ', array_keys($data)) . "\n";
    echo "leidingsploegen count: " . (isset($data['leidingsploegen']) ? count($data['leidingsploegen']) : '0') . "\n";
}

echo "\n\nGroepsleiding global:\n";
$groepsleidingGlobal = \Statamic\Facades\GlobalSet::findByHandle('groepsleiding');
if ($groepsleidingGlobal) {
    echo "Found: YES\n";
    echo "Blueprint: " . $groepsleidingGlobal->blueprint()->handle() . "\n";
    $data = $groepsleidingGlobal->inDefaultSite()->data()->all();
    echo "Data keys: " . implode(', ', array_keys($data)) . "\n";
} else {
    echo "NOT FOUND\n";
}
