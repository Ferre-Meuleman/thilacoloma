<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CalendarController;
use App\Http\Controllers\LiveSearchController;

// Homepage route - load entry data explicitly
// (Statamic's built-in URL resolving has performance issues on this VPS)
Route::get('/', function() {
    $entry = \Statamic\Facades\Entry::query()
        ->where('slug', 'home')
        ->where('collection', 'pages')
        ->first();
    
    if (!$entry) {
        abort(404);
    }
    
    return (new \Statamic\View\View)
        ->template('home')
        ->layout('layouts/app')
        ->cascadeContent($entry)
        ->render();
});

// Calendar proxy route to avoid CORS issues
Route::get('/api/calendar/feed', [CalendarController::class, 'getCalendarFeed']);

// Live search API endpoint
Route::get('/api/search', [LiveSearchController::class, 'search']);
