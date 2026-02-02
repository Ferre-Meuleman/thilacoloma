<?php

namespace App\Modifiers;

use Statamic\Modifiers\Modifier;

class MergeLeidingsploegen extends Modifier
{
    /**
     * Merge all tak groep arrays from the leidingsploegen global into a single array.
     * This maintains backward compatibility with templates after restructuring the global.
     *
     * Usage: {{ leidingsploegen | merge_leidingsploegen }}
     *
     * @param  mixed  $value  The leidingsploegen global data
     * @return array
     */
    public function index($value): array
    {
        // Debug: log what we receive
        \Log::info('MergeLeidingsploegen received:', ['type' => gettype($value), 'value' => $value]);
        
        // If value is null or empty, return empty array
        if (empty($value)) {
            return [];
        }
        
        // If it's already a simple array with numeric keys, it might be the old merged structure
        if (is_array($value) && isset($value[0])) {
            return $value;
        }

        // If it's already a flat array (old structure), return as is
        if (isset($value['leidingsploegen']) && is_array($value['leidingsploegen'])) {
            return $value['leidingsploegen'];
        }

        // Merge all tak groep arrays into one
        $merged = [];
        $takGroepen = ['groepsleiding', 'kapoenen', 'welpen', 'tictak', 'jongverkenners', 'verkenners', 'voortrekkers'];

        foreach ($takGroepen as $groep) {
            if (isset($value[$groep]) && is_array($value[$groep])) {
                \Log::info("Merging {$groep}:", ['count' => count($value[$groep])]);
                $merged = array_merge($merged, $value[$groep]);
            }
        }
        
        \Log::info('MergeLeidingsploegen result:', ['count' => count($merged)]);

        return $merged;
    }
}
