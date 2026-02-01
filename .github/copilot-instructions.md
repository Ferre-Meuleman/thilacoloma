# Thila Coloma - Statamic CMS Project

Scout group website for Thila Coloma (Mechelen, Belgium) built with Statamic 5 on Laravel 12. Migrated from Craft CMS.

## Architecture Overview

- **CMS**: Statamic 5 (flat-file CMS, no database for content)
- **Framework**: Laravel 12 with Vite + Tailwind CSS 4
- **Templates**: Antlers templating engine (`.antlers.html` files)
- **Content**: Flat-file YAML/Markdown in `content/` directory

### Key Data Flow: Leidingsploegen (Scout Leaders)
The **Leidingsploegen global** (`content/globals/leidingsploegen.yaml`) is the single source of truth for all scout leaders (~17 ploegen). Each entry has:
- `tak_naam`: Display name (e.g., "Kapoenen 1") - **matched in templates**
- `tak_groep`: Category (kapoenen|welpen|jongverkenners|verkenners|voortrekkers|tictak)
- `actief`: Boolean visibility toggle
- `leiding`: Nested array of leaders with `voornaam`, `achternaam`, `totem`, `email`, `functie`

Tak pages query this global to display leader cards:
```antlers
{{ leidingsploegen:leidingsploegen }}
    {{ if tak_naam == naam && actief }}
        {{ leiding }}
            <div class="leiding-card {{ if functie == 'takleider' }}takleider{{ /if }}">
                {{ totem_parts = totem | explode: ' ' }}
                {{ animal_name = totem_parts | last }}
                <img src="/assets/images/leidingfotos/{{ animal_name }}.jpg">
            </div>
        {{ /leiding }}
    {{ /if }}
{{ /leidingsploegen:leidingsploegen }}
```

### Leader Photo Convention
Photos at `/assets/images/leidingfotos/{AnimalName}.jpg`. Extract animal from totem:
- Totem "Zachtaardige Coscoroba" → photo `Coscoroba.jpg`
- Email format: `{animal_name_lowercase}@thilacoloma.be`

### Collections & Globals
- **Collections**: `pages` (main site), `news` (at `/nieuws/{slug}`)
- **Globals**: `leidingsploegen`, `site_settings` (scoutsjaar), `slideshow_content`, `homepage_content`

### Templates Pattern
Each tak has a dedicated template in `resources/views/` with identical structure:
1. Page intro from `{{ content }}`
2. Loop through `{{ subtakken }}` (defined in page YAML)
3. Query leidingsploegen global matching `tak_naam == naam`

## Development Commands

```bash
composer dev                    # Start all services (server, queue, logs, vite)
npm run build                   # Build frontend assets
php please cache:clear && php please stache:clear  # Clear caches
```

## Three-Way Content Synchronization

### 1. Local ↔ Server (SCP)
```bash
./sync-content.sh from-server   # Pull content from production
./sync-content.sh to-server     # Push content to production
./sync-content.sh --diff        # Show differences without syncing
./sync-content.sh --auto        # Full sync: GitHub → Local → Server
```
VS Code tasks available: "Content: Pull from Server", "Content: Push to Server", etc.

### 2. Production → GitHub (Auto Git Sync)
Content edits in Control Panel (`/cp`) trigger automatic commits:
- `AutoGitSyncListener.php` catches Statamic events (EntrySaved, GlobalSaved, etc.)
- Sends POST to `auto-git-sync.php` with token auth
- Commits with message: `[AUTO-SYNC] X modified: file.yaml (by user at timestamp)`

### 3. GitHub → Namecheap (Deploy)
Pushes to `master` trigger `.github/workflows/deploy.yml`:
- FTP sync to `tc_app/` (application) and `public_html/tc/` (public)
- Uses `index-hosting.php` for production routing

## CSS Design System

Static CSS in `public/assets/css/` with variables in `variables.css`:
```css
--primary-color: #374794;       /* Main blue */
--dark-color: #282471;          /* Darker blue */
--pink-color: #c0589a;          /* Accent */
--font-title: 'acier-bat-solid';
--font-regular: 'Edmondsans Regular';
--spacing-xs: 5px; --spacing-sm: 10px; --spacing-md: 20px;
--spacing-lg: 30px; --spacing-xl: 40px; --spacing-xxl: 50px;
```

## Blueprint-Template Mapping

Blueprints in `resources/blueprints/collections/pages/`:
- `tak_pagina.yaml` - Scout branch pages with `tak_groep`, `subtakken` replicator
- `kalender.yaml`, `verhuur.yaml` - Special page types

Page YAML defines `subtakken` array with `naam` field that **must match** `tak_naam` in leidingsploegen global.

## Key Files Reference

| Purpose | File |
|---------|------|
| Leader data (central) | `content/globals/leidingsploegen.yaml` |
| Site settings | `content/globals/site_settings.yaml` |
| Base layout | `resources/views/layout.antlers.html` |
| Tak template example | `resources/views/kapoenen.antlers.html` |
| Auto-sync listener | `app/Listeners/AutoGitSyncListener.php` |
| Git sync script | `auto-git-sync.php` |
| Server sync | `sync-content.sh` |
| CSS variables | `public/assets/css/variables.css` |
| Deploy workflow | `.github/workflows/deploy.yml` |
| Leader photos | `public/assets/images/leidingfotos/` |

## Debugbar Workaround

Laravel Debugbar is dev-only. Production exclusion via:
1. `composer.json`: `dont-discover: ["barryvdh/laravel-debugbar"]`
2. `DummyDebugbarServiceProvider.php` - stub provider
3. Conditional registration in `AppServiceProvider`

**Never** commit debugbar to production - it causes 500 errors.
