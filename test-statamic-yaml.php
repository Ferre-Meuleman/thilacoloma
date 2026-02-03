<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use Statamic\Facades\YAML;

$file = '/var/www/thilacoloma/content/globals/groepsleiding.md';
$rawContent = file_get_contents($file);

echo "Raw file content (first 300 chars):\n";
echo substr($rawContent, 0, 300) . "\n\n";

// Parse with Statamic's YAML
$parsed = YAML::file($file)->parse();
echo "Statamic YAML parse:\n";
echo "Keys: " . implode(', ', array_keys($parsed)) . "\n";
if (isset($parsed['groepsleiding_leden'])) {
    echo "groepsleiding_leden count: " . count($parsed['groepsleiding_leden']) . "\n";
}

// Check global path
$globalPath = base_path('content/globals/groepsleiding.md');
echo "\nGlobal path exists: " . (file_exists($globalPath) ? 'YES' : 'NO') . "\n";
echo "Permissions: " . substr(sprintf('%o', fileperms($globalPath)), -4) . "\n";
