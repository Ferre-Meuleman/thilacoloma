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
        // If it's already a flat array (old structure), return as is
        if (isset($value['leidingsploegen']) && is_array($value['leidingsploegen'])) {
            return $value['leidingsploegen'];
        }

        // Merge all tak groep arrays into one
        $merged = [];
        $takGroepen = ['groepsleiding', 'kapoenen', 'welpen', 'tictak', 'jongverkenners', 'verkenners', 'voortrekkers'];

        foreach ($takGroepen as $groep) {
            if (isset($value[$groep]) && is_array($value[$groep])) {
                $merged = array_merge($merged, $value[$groep]);
            }
        }

        return $merged;
    }
}
