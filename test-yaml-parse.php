<?php
require __DIR__.'/vendor/autoload.php';

use Symfony\Component\Yaml\Yaml;

$content = file_get_contents('/var/www/thilacoloma/content/globals/groepsleiding.md');
echo "File content length: " . strlen($content) . "\n";
echo "First 200 chars:\n" . substr($content, 0, 200) . "\n\n";

try {
    $parsed = Yaml::parse($content);
    echo "Parsed successfully!\n";
    echo "Keys: " . implode(', ', array_keys($parsed)) . "\n";
    if (isset($parsed['groepsleiding_leden'])) {
        echo "groepsleiding_leden count: " . count($parsed['groepsleiding_leden']) . "\n";
    }
} catch (\Exception $e) {
    echo "Parse error: " . $e->getMessage() . "\n";
}
