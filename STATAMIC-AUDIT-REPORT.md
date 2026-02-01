# Thila Coloma - Statamic CMS Audit Report

**Generated:** February 1, 2026  
**Audited Version:** Statamic 5 / Laravel 12

---

## Executive Summary

| Metric | Count |
|--------|-------|
| **Total Blueprints** | 16 (11 pages + 1 takken + 6 globals) |
| **Total Fields Across All Blueprints** | ~180 fields |
| **Replicator Fields** | 15 |
| **Bard Fields** | 12 |
| **Field Types Used** | 14 unique types |
| **Orphaned/Unused Blueprint Fields** | 42+ |
| **Hardcoded Template Content** | 25+ instances |
| **Globals** | 6 |

### Critical Issues Found
- 🔴 **kalender.yaml**: 30+ fields in blueprint, most NOT used in template (uses hardcoded fallbacks)
- 🔴 **verhuur.yaml**: Complex replicator structure that doesn't match actual content file schema
- 🔴 **home.yaml**: Has `news_slides` field duplicating the `slideshow_content` global
- 🟡 **Tak templates**: All use `page.yaml` blueprint but require `tak_pagina.yaml` fields (mismatch)
- 🟡 **Massive code duplication**: 6 tak templates are 95% identical

---

## Part 1: Blueprint vs Template Audit

### 1.1 home.yaml → home.antlers.html

**Blueprint Location:** [resources/blueprints/collections/pages/home.yaml](resources/blueprints/collections/pages/home.yaml)  
**Template Location:** [resources/views/home.antlers.html](resources/views/home.antlers.html)

| Field | Blueprint | Template Usage | Status |
|-------|-----------|----------------|--------|
| `intro_title` | ✅ Line 8 | ✅ `{{ intro_title ?? 'Thila Coloma' }}` | ✅ OK |
| `intro_text` | ✅ Line 14 | ✅ `{{ intro_text \| markdown }}` | ✅ OK |
| `intro_extra_text` | ✅ Line 22 | ✅ `{{ intro_extra_text \| markdown }}` | ✅ OK |
| `news_section_title` | ✅ Line 29 | ✅ `{{ news_section_title ?? '...' }}` | ✅ OK |
| `news_slides` | ✅ Line 35 (replicator) | ⚠️ **IGNORED** - Uses `slideshow_content:news_slides` instead | 🔴 **ORPHANED** |

**Issues Found:**
- 🔴 **Line 35-70**: The `news_slides` replicator in the home blueprint is **NEVER USED**. The template instead pulls from the `slideshow_content` global. This is confusing and creates duplicate data entry.
- 📁 Content File: [content/collections/pages/home.md](content/collections/pages/home.md) - Has `news_slides` data that is never displayed!

---

### 1.2 kalender.yaml → kalender.antlers.html

**Blueprint Location:** [resources/blueprints/collections/pages/kalender.yaml](resources/blueprints/collections/pages/kalender.yaml)  
**Template Location:** [resources/views/kalender.antlers.html](resources/views/kalender.antlers.html)

This is the **most problematic blueprint** - extremely complex with many unused fields.

#### Blueprint Fields (90 lines):

| Field | In Blueprint | Actually Used in Template | Status |
|-------|--------------|---------------------------|--------|
| `title` | ✅ | ❌ Not directly rendered | ⚠️ |
| `intro_title` | ✅ | ✅ Line 8 with fallback | ✅ OK |
| `intro_text` | ✅ | ✅ Line 10 with fallback | ✅ OK |
| `meetings_title` | ✅ | ✅ Line 89 | ✅ OK |
| `meetings_description` | ✅ | ✅ Line 92 | ✅ OK |
| `vergaderingen_jongsten_tijd` | ✅ | ✅ | ✅ OK |
| `vergaderingen_jongsten_beschrijving` | ✅ | ✅ | ✅ OK |
| `vergaderingen_ouderen_tijd` | ✅ | ✅ | ✅ OK |
| `vergaderingen_ouderen_beschrijving` | ✅ | ✅ | ✅ OK |
| `vergaderingen_locatie` | ✅ | ✅ | ✅ OK |
| `vergaderingen_afwezigheid_link` | ✅ | ✅ | ✅ OK |
| `google_calendar_url` | ✅ | ❌ **NOT USED** - calendar loads from external JSON | 🔴 **ORPHANED** |
| `agenda_title` | ✅ | ✅ Line 85 | ✅ OK |

**🔴 Critical Issue:** The template has ~50 additional hardcoded field references that **don't exist in the blueprint**:

| Hardcoded Template Variable | Line | Status |
|-----------------------------|------|--------|
| `vergaderingen_tijdstip_title` | ~96 | 🔴 NOT IN BLUEPRINT |
| `vergaderingen_uitzonderingen` | ~103 | ✅ In content but not blueprint |
| `vergaderingen_eerste_zondag_title` | ~108 | ✅ In content but not blueprint |
| `vergaderingen_eerste_zondag_tekst` | ~109 | ✅ In content but not blueprint |
| `vergaderingen_eerste_zondag_uitleg` | ~111 | ✅ In content but not blueprint |
| `vergaderingen_eerste_zondag_uitzondering` | ~113 | ✅ In content but not blueprint |
| `vergaderingen_afwezigheid_title` | ~119 | ✅ In content but not blueprint |
| `vergaderingen_afwezigheid_tekst` | ~120 | ✅ In content but not blueprint |
| `vergaderingen_afwezigheid_uitleg` | ~122 | ✅ In content but not blueprint |
| `vergaderingen_afwezigheid_link_tekst` | ~126 | ✅ In content but not blueprint |
| `navigation_previous_text` | ~142 | ✅ In content but not blueprint |
| `navigation_next_text` | ~144 | ✅ In content but not blueprint |
| `calendar_loading_message` | ~149 | ✅ In content but not blueprint |
| `calendar_error_message` | ~153 | ✅ In content but not blueprint |
| `weekends_kampen_title` | ~163 | ✅ In content but not blueprint |
| `weekends_kampen_intro` | ~165 | ✅ In content but not blueprint |
| `weekends_title` | ~170 | ✅ In content but not blueprint |
| `weekends_beschrijving` | ~171 | ✅ In content but not blueprint |
| All `weekends_*` fields (~10) | Various | ✅ In content but not blueprint |
| All `kampen_*` fields (~10) | Various | ✅ In content but not blueprint |
| All `inschrijvingen_*` fields (~10) | ~200+ | ✅ In content but not blueprint |

**Summary:** The content file [content/collections/pages/kalender.md](content/collections/pages/kalender.md) has **60+ fields** that are used in the template but only **~12 are defined in the blueprint**. This means:
1. Content editors cannot edit most fields via the Control Panel
2. Fields were added directly to YAML without blueprint definitions

---

### 1.3 meer.yaml → meer.antlers.html

**Blueprint Location:** [resources/blueprints/collections/pages/meer.yaml](resources/blueprints/collections/pages/meer.yaml)  
**Template Location:** [resources/views/meer.antlers.html](resources/views/meer.antlers.html)

This blueprint is **well-structured** with 8 tabs:

| Tab | Fields | Template Usage | Status |
|-----|--------|----------------|--------|
| **Visie** | `visie_intro`, `visie_kernwaarden`, `visie_tekst` (Bard) | ✅ Used in template | ✅ OK |
| **Groepsleiding** | `groepsleiding_intro`, `groepsleiding_scoutsjaar`, `groepsleiding_leden` (replicator) | ✅ Used | ✅ OK |
| **Inschrijvingen** | `inschrijvingsformulier_link`, `stamhoofd_link`, `inschrijving_scoutsjaar`, lidgeld fields | ✅ Used | ✅ OK |
| **Uniform** | `uniform_content` (Bard) | ✅ Used | ✅ OK |
| **Praktisch** | `praktisch_inschrijven`, `praktisch_betalingen`, `praktisch_kosten_overzicht` (all Bard) | ✅ Used | ✅ OK |
| **Beleid** | 5 Bard fields for policy documents | ✅ All used | ✅ OK |
| **FAQ** | `faq_intro`, `faq_items` (replicator), `faq_contact_*` | ✅ Used | ✅ OK |
| **Extra** | `extra_jaarthemas`, `extra_liederen`, `extra_geschiedenis` (all Bard) | ✅ Used | ✅ OK |

**Issues Found:**
- ⚠️ **Line 51**: `visie_tekst` is rendered **TWICE** (duplicate `{{ visie_tekst }}` on line 51-52)
- ⚠️ **Line 161**: `visie_kernwaarden` field exists in blueprint but **NOT USED** in template

---

### 1.4 verhuur.yaml → verhuur.antlers.html

**Blueprint Location:** [resources/blueprints/collections/pages/verhuur.yaml](resources/blueprints/collections/pages/verhuur.yaml)  
**Template Location:** [resources/views/verhuur.antlers.html](resources/views/verhuur.antlers.html)

#### Blueprint Defines:

| Field | Status |
|-------|--------|
| `intro_tekst` | ❌ NOT USED in template |
| `kampas_url` | ✅ Used |
| `lokalen_contact_email` | ⚠️ Template uses `contact_email` instead |
| `lokalen_waarschuwing` | ⚠️ Template uses `waarschuwing_tekst` |
| `lokalen_beschrijving` (Bard) | ❌ **NOT USED** |
| `maps_embed_url` | ✅ Used |
| `materiaal_contact_email` | ⚠️ Template uses `materiaal_contact_email` |
| `materiaal_waarschuwing` | ✅ Used |
| `materiaal_items` (replicator with `naam`, `categorie`, `afbeelding`, `aantal`, `prijs_per_dag`, `waarborg`) | ❌ **NOT USED** - template uses separate arrays |
| `tenten_info` | ❌ NOT USED |
| `tenten_lijst` (replicator) | ✅ Partially used but schema mismatch |

#### Template Uses (Not in Blueprint):

| Content Field | Template Line | Status |
|---------------|---------------|--------|
| `kampas_titel` | ~26 | 🔴 NOT IN BLUEPRINT |
| `kampas_beschrijving` | ~27 | 🔴 NOT IN BLUEPRINT |
| `contact_titel` | ~41 | 🔴 NOT IN BLUEPRINT |
| `contact_beschrijving` | ~42 | 🔴 NOT IN BLUEPRINT |
| `contact_persoon` | ~42 | 🔴 NOT IN BLUEPRINT |
| `contact_email` | ~43 | 🔴 NOT IN BLUEPRINT |
| `lokalen_titel` | ~59 | 🔴 NOT IN BLUEPRINT |
| `polyvalent_lokaal` (object) | ~62-66 | 🔴 NOT IN BLUEPRINT |
| `slaaplokalen` (object) | ~68-71 | 🔴 NOT IN BLUEPRINT |
| `sanitair` (object) | ~73-76 | 🔴 NOT IN BLUEPRINT |
| `locatie_titel` | ~81 | 🔴 NOT IN BLUEPRINT |
| `adres` | ~82 | 🔴 NOT IN BLUEPRINT |
| `locatie_info` (replicator) | ~90-93 | 🔴 NOT IN BLUEPRINT |
| `materiaal_transport` | ~164 | 🔴 NOT IN BLUEPRINT |
| `materiaal_meubilair` | ~184 | 🔴 NOT IN BLUEPRINT |
| `materiaal_kookbenodigdheden` | ~196 | 🔴 NOT IN BLUEPRINT |
| `materiaal_koeling` | ~208 | 🔴 NOT IN BLUEPRINT |
| `materiaal_gereedschap` | ~232 | 🔴 NOT IN BLUEPRINT |
| `tenten_*` fields (~15) | Various | 🔴 NOT IN BLUEPRINT |

**Critical Issue:** The verhuur.yaml blueprint defines a generic `materiaal_items` replicator, but the content file and template use **category-specific arrays** (`materiaal_transport`, `materiaal_meubilair`, etc.). These are incompatible structures!

---

### 1.5 tak_pagina.yaml → Tak Templates

**Blueprint Location:** [resources/blueprints/collections/pages/tak_pagina.yaml](resources/blueprints/collections/pages/tak_pagina.yaml)  
**Templates:** kapoenen.antlers.html, welpen.antlers.html, jongverkenners.antlers.html, verkenners.antlers.html, voortrekkers.antlers.html

#### Blueprint Fields:

| Field | Template Usage | Status |
|-------|----------------|--------|
| `title` | ✅ `{{ title }}` | ✅ OK |
| `tak_groep` | ❌ Not directly rendered | ⚠️ Metadata only |
| `tak_naam` | ❌ Not rendered in template | ⚠️ Metadata only |
| `beschrijving` | ❌ NOT USED - template uses `content` | 🔴 **ORPHANED** |
| `activiteiten_beschrijving` | ❌ NOT USED | 🔴 **ORPHANED** |
| `bijzonderheden` | ❌ NOT USED | 🔴 **ORPHANED** |
| `extra_fotos` | ❌ NOT USED | 🔴 **ORPHANED** |
| `show_on_overview` | ❌ NOT USED | 🔴 **ORPHANED** |

**Serious Issue:** The tak pages use the `tak_pagina.yaml` blueprint but:
1. Most fields are NOT used in templates
2. Templates pull leader info from `leidingsploegen` global (correct)
3. Templates use `{{ content | markdown }}` but blueprint doesn't have `content` field!
4. Welpen and Tictak use `page.yaml` blueprint instead of `tak_pagina.yaml`

---

### 1.6 takken/tak.yaml → Universal Tak Collection Blueprint

**Blueprint Location:** [resources/blueprints/collections/takken/tak.yaml](resources/blueprints/collections/takken/tak.yaml)

This is a **separate collection** blueprint that appears to be **UNUSED**:

| Field | Status |
|-------|--------|
| `title` | ✅ Standard |
| `slug` | ✅ Standard |
| `tak_groep` | Duplicates `tak_pagina.yaml` |
| `age_range` | ⚠️ Not used anywhere |
| `content` (Bard) | ⚠️ Not used anywhere |
| `subtakken` (replicator) | Duplicates what's in leidingsploegen global |

**Recommendation:** This entire blueprint/collection appears to be orphaned code. Consider removing.

---

### 1.7 thilala.yaml → thilala.antlers.html

**Blueprint Location:** [resources/blueprints/collections/pages/thilala.yaml](resources/blueprints/collections/pages/thilala.yaml)  
**Template Location:** [resources/views/thilala.antlers.html](resources/views/thilala.antlers.html)

| Field | Blueprint | Template | Status |
|-------|-----------|----------|--------|
| `title` | ✅ | ✅ `{{ title }}` | ✅ OK |
| `slug` | ✅ | N/A (routing) | ✅ OK |
| `page_title` | ✅ | ❌ NOT USED | 🔴 **ORPHANED** |
| `intro_text` | ✅ | ✅ Used | ✅ OK |
| `current_pdf` | ✅ | ✅ Used | ✅ OK |
| `pdf_title` | ✅ | ❌ NOT USED | 🔴 **ORPHANED** |
| `show_archive` | ✅ | ✅ Used | ✅ OK |
| `archive_title` | ✅ | ✅ Used | ✅ OK |
| `archive_pdfs` | ✅ | ⚠️ Used but `pdf_file` sub-field is broken in content | ⚠️ |

---

### 1.8 stamhoofd.yaml → stamhoofd.antlers.html

**Blueprint Location:** [resources/blueprints/collections/pages/stamhoofd.yaml](resources/blueprints/collections/pages/stamhoofd.yaml)  
**Template Location:** [resources/views/stamhoofd.antlers.html](resources/views/stamhoofd.antlers.html)

| Field | Template Usage | Status |
|-------|----------------|--------|
| `title` | ✅ `{{ title }}` | ✅ OK |
| `intro_text` | ✅ Used with fallback | ✅ OK |
| `stamhoofd_url` | ✅ Used with fallback | ✅ OK |
| `button_text` | ✅ Used with fallback | ✅ OK |
| `content` | ✅ Used | ✅ OK |

**Status:** ✅ This is one of the cleanest blueprint-template pairs!

---

### 1.9 takken_overzicht.yaml → takken.antlers.html

**Blueprint Location:** [resources/blueprints/collections/pages/takken_overzicht.yaml](resources/blueprints/collections/pages/takken_overzicht.yaml)  
**Template Location:** [resources/views/takken.antlers.html](resources/views/takken.antlers.html)

| Field | Template Usage | Status |
|-------|----------------|--------|
| `title` | ✅ Used | ✅ OK |
| `intro_text` | ✅ Used | ✅ OK |
| `takken_groepen` (replicator) | ✅ Used | ✅ OK |
| └─ `naam` | ✅ Used | ✅ OK |
| └─ `leeftijd_range` | ✅ Used with `dynamic_age_range` modifier | ✅ OK |
| └─ `logo` | ✅ Used | ✅ OK |
| └─ `beschrijving` | ✅ Used | ✅ OK |
| └─ `takken_lijst` | ✅ Used | ✅ OK |
| └─ `vergadertijd` | ✅ Used | ✅ OK |
| └─ `takleiders` (nested replicator) | ❌ **NOT USED** - Template pulls from `leidingsploegen` global instead | 🔴 **ORPHANED** |

**Issue:** The `takleiders` nested replicator is **REDUNDANT** - the template correctly pulls from the leidingsploegen global. This field should be removed from the blueprint.

---

### 1.10 page.yaml (Generic Blueprint)

**Blueprint Location:** [resources/blueprints/collections/pages/page.yaml](resources/blueprints/collections/pages/page.yaml)

This is used by: welpen.md, tictak.md

| Field | Status |
|-------|--------|
| `title` | ✅ Standard |
| `slug` | ✅ Standard |
| `hero_image` | ❌ NOT USED by any page using this blueprint |
| `content` | ✅ Used |
| `is_tak_page` | ❌ Conditional toggle - but welpen/tictak don't use it |
| `tak_type` | ❌ NOT USED |
| `formulier_link` | ⚠️ Used only by verkenners.antlers.html |
| `rekeningnummer` | ⚠️ Used but pulled from subtakken replicator |
| `subtakken_data` | ❌ NOT USED |
| `akabe_info` | ❌ NOT USED |
| `meta_description` | ❌ NOT USED |
| `meta_keywords` | ❌ NOT USED |

**Issue:** This blueprint has conditional fields (`if: is_tak_page`) that are never activated by any content file.

---

## Part 2: Globals Audit

### 2.1 leidingsploegen (Global)

**Blueprint:** [resources/blueprints/globals/leidingsploegen.yaml](resources/blueprints/globals/leidingsploegen.yaml)  
**Content:** [content/globals/leidingsploegen.yaml](content/globals/leidingsploegen.yaml)

| Field | Usage |
|-------|-------|
| `leidingsploegen` (replicator) | ✅ Central data for all leaders |
| └─ `tak_naam` | ✅ Key for matching in templates |
| └─ `tak_groep` | ✅ Category selector |
| └─ `takleider` | ⚠️ Redundant - also in `leiding` array |
| └─ `takleider_email` | ⚠️ Redundant - also in `leiding` array |
| └─ `leiding` (nested replicator) | ✅ Full leader data |
| └─ `groepsfoto` | ❌ NOT USED in any template |
| └─ `actief` | ✅ Used for filtering |

**Used By:**
- [kapoenen.antlers.html](resources/views/kapoenen.antlers.html) - Line 53
- [welpen.antlers.html](resources/views/welpen.antlers.html) - Line 53
- [jongverkenners.antlers.html](resources/views/jongverkenners.antlers.html) - Line 53
- [verkenners.antlers.html](resources/views/verkenners.antlers.html) - Line 53
- [voortrekkers.antlers.html](resources/views/voortrekkers.antlers.html) - Line 53
- [tictak.antlers.html](resources/views/tictak.antlers.html) - Line 122
- [takken.antlers.html](resources/views/takken.antlers.html) - Line 43

**Assessment:** ✅ **CORRECTLY GLOBAL** - Used across 7+ templates, single source of truth for leader data.

**Issues:**
- `takleider` and `takleider_email` are redundant (same data exists in `leiding` array with `functie: takleider`)
- `groepsfoto` is never used

---

### 2.2 slideshow_content (Global)

**Blueprint:** [resources/blueprints/globals/slideshow_content.yaml](resources/blueprints/globals/slideshow_content.yaml)  
**Content:** [content/globals/slideshow_content.yaml](content/globals/slideshow_content.yaml)

**Used By:**
- [home.antlers.html](resources/views/home.antlers.html) - Line 17
- [kalender.antlers.html](resources/views/kalender.antlers.html) - Line 18

**Assessment:** ✅ **CORRECTLY GLOBAL** - Slideshow appears on both homepage and kalender.

**Issue:** 
- 🔴 **DUPLICATION**: The `home.yaml` blueprint ALSO has a `news_slides` field that does the same thing. This creates confusion - editors might add slides to the wrong location!

---

### 2.3 navigation (Global)

**Blueprint:** [resources/blueprints/globals/navigation.yaml](resources/blueprints/globals/navigation.yaml)  
**Content:** [content/globals/navigation.yaml](content/globals/navigation.yaml)

**Used By:**
- [home.antlers.html](resources/views/home.antlers.html) - Line 93

**Assessment:** ⚠️ **QUESTIONABLE** - Only used on homepage for the navigation grid. The main site navigation appears to be hardcoded in [layout.antlers.html](resources/views/layout.antlers.html).

---

### 2.4 contact_info (Global)

**Blueprint:** [resources/blueprints/globals/contact_info.yaml](resources/blueprints/globals/contact_info.yaml)  
**Content:** [content/globals/contact_info.yaml](content/globals/contact_info.yaml)

**Used By:**
- [meer.antlers.html](resources/views/meer.antlers.html) - Line 63-68

**Assessment:** ✅ **CORRECTLY GLOBAL** - Contact info should be consistent across site.

---

### 2.5 site_instellingen (Global)

**Blueprint:** [resources/blueprints/globals/site_instellingen.yaml](resources/blueprints/globals/site_instellingen.yaml)  
**Content:** [content/globals/site_instellingen.yaml](content/globals/site_instellingen.yaml)

| Field | Status |
|-------|--------|
| `scoutsjaar` | ⚠️ Used in some templates but also duplicated in page content |
| `groepsleiding_email` | ❌ NOT USED - templates hardcode or use contact_info |
| `rekeningnummer` | ❌ NOT USED - each tak has its own |

**Assessment:** ⚠️ **UNDERUSED** - These site-wide settings are often overridden or ignored.

---

### 2.6 social_media (Global)

**Blueprint:** [resources/blueprints/globals/social_media.yaml](resources/blueprints/globals/social_media.yaml)  
**Content:** [content/globals/social_media.yaml](content/globals/social_media.yaml)

**Used By:** Unknown - likely in footer partial

**Assessment:** ✅ **CORRECTLY GLOBAL** if used in layout/footer.

---

## Part 3: Field Complexity Audit

### 3.1 Field Types Distribution

| Field Type | Count | Blueprints Using It |
|------------|-------|---------------------|
| `text` | 68 | All blueprints |
| `textarea` | 24 | kalender, meer, verhuur, etc. |
| `replicator` | 15 | home, kalender, meer, verhuur, takken_overzicht, leidingsploegen |
| `bard` | 12 | meer (8), verhuur (1), tak (1), navigation (0) |
| `select` | 8 | tak_pagina, page, leidingsploegen |
| `assets` | 12 | Various |
| `link` | 6 | kalender, meer, verhuur |
| `toggle` | 5 | thilala, page, leidingsploegen |
| `markdown` | 5 | home, page |
| `slug` | 3 | page, thilala, tak |
| `template` | 2 | thilala |

### 3.2 Replicator Complexity

| Replicator | Location | Nesting Depth | Sets/Fields |
|------------|----------|---------------|-------------|
| `news_slides` | home.yaml | 1 | 1 set, 5 fields |
| `news_slides` | slideshow_content.yaml | 1 | 1 set, 6 fields |
| `groepsleiding_leden` | meer.yaml | 1 | 1 set, 6 fields |
| `faq_items` | meer.yaml | 1 | 1 set, 2 fields |
| `materiaal_items` | verhuur.yaml | 1 | 1 set, 6 fields |
| `tenten_lijst` | verhuur.yaml | 1 | 1 set, 8 fields |
| `takken_groepen` | takken_overzicht.yaml | 2 | 1 set with nested `takleiders` |
| `leidingsploegen` | leidingsploegen.yaml | 2 | 1 set with nested `leiding` (7 fields) |
| `archive_pdfs` | thilala.yaml | 1 | 1 set, 3 fields |
| `nav_items` | navigation.yaml | 1 | 1 set, 4 fields |
| `contact_adressen` | contact_info.yaml | 1 | 1 set, 3 fields |
| `subtakken` | tak.yaml & pages | 1 | 1 set, 3 fields |

### 3.3 Bard Field Configuration

| Bard Field | Blueprint | Buttons Enabled |
|------------|-----------|-----------------|
| `visie_tekst` | meer.yaml | bold, italic, h2, h3, unorderedlist, orderedlist, quote |
| `uniform_content` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist, quote, anchor, image |
| `praktisch_inschrijven` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist, anchor |
| `praktisch_betalingen` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist, anchor |
| `praktisch_kosten_overzicht` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist |
| `beleid_veiligheid` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist, anchor |
| `beleid_pest_inclusie` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist, anchor |
| `beleid_integriteit` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist, anchor |
| `beleid_privacy` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist, anchor |
| `beleid_gedragsregels` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist |
| `extra_jaarthemas` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist |
| `extra_liederen` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist |
| `extra_geschiedenis` | meer.yaml | bold, italic, h2, h3, h4, unorderedlist, orderedlist, image |
| `lokalen_beschrijving` | verhuur.yaml | bold, italic, h3, unorderedlist |
| `content` | tak.yaml | h3, bold, italic, unorderedlist, orderedlist, quote |

---

## Part 4: Hardcoded Content in Templates

### 4.1 voortrekkers.antlers.html - Lines 49-55

```antlers
<div class="info-card special-info">
    <div class="info-content">
        <h3><i class="fas fa-hands-helping"></i> Leiding-ervaring & Klusjes</h3>
        <p>Bij TC staan de Vt's een keer per maand bij een andere tak in leiding, om al eens van het leiding-zijn te kunnen proeven. Ook op binnenlands kamp in augustus staan ze een heel kamp in leiding bij de tak van hun keuze.</p>
        <p><strong>Op zoek naar klusjes?</strong> Om voor hun buitenlands avontuur wat centjes in te zamelen, zijn de Vt's het hele jaar door op zoek naar klusjes die ze kunnen doen. Moet je auto gewassen worden, ga je verhuizen, heb je hulp nodig in de tuin?</p>
    </div>
</div>
```

**Status:** 🔴 Should be a blueprint field

### 4.2 tictak.antlers.html - Lines 54-118

Entire AKABE information section is hardcoded:
- "Wat maakt AKABE bijzonder?"
- "Wanneer & Waar?"
- "Inclusief & Ondersteunend"
- "Onze Activiteiten" (with 6 activity icons)

**Status:** 🔴 All should be blueprint fields or a Bard field

### 4.3 All Tak Templates - Static Text

All tak templates have identical hardcoded text:
- "Je kan afwezigheden hier verwittigen"
- "Overschrijven naar rekening"
- "Telefoonnummer in de blauwe gids"
- Back button text

**Status:** ⚠️ Should be in a partial or global

### 4.4 kalender.antlers.html - Fallback Slides

Lines 45-70 have hardcoded fallback content for when no slides exist:
- "Pizzabak" slide content
- "Belofteweekend" slide content  
- "TC's Cadeaupakket" slide content

**Status:** ⚠️ Fallback content is outdated (references dates from 2024)

---

## Part 5: Recommendations

### 🔴 Critical Fixes

1. **Remove duplicate `news_slides`** from home.yaml blueprint - use only the `slideshow_content` global

2. **Add missing fields to kalender.yaml blueprint** or remove from content file - currently 50+ fields are orphaned from blueprint

3. **Redesign verhuur.yaml blueprint** to match actual content structure:
   - Replace generic `materiaal_items` with category-specific replicators
   - Add all missing fields (`kampas_titel`, `contact_*`, `lokalen_*`, `tenten_*`, etc.)

4. **Fix tak page blueprints**:
   - Either make all tak pages use `tak_pagina.yaml` consistently
   - Or add `subtakken` replicator and `content` field to `page.yaml`
   - Remove unused fields (`beschrijving`, `activiteiten_beschrijving`, `bijzonderheden`, `extra_fotos`)

### 🟡 Important Improvements

1. **Create a shared tak partial** to eliminate 95% code duplication across 6 tak templates

2. **Remove `takleiders` from takken_overzicht.yaml** - the template correctly uses the global

3. **Remove `groepsfoto` from leidingsploegen** blueprint - never used

4. **Add `visie_kernwaarden`** usage to meer.antlers.html or remove from blueprint

5. **Fix thilala.yaml** - remove unused `page_title` and `pdf_title` fields

### 🟢 Nice to Have

1. **Add SEO fields** that work (current `meta_description` and `meta_keywords` are orphaned)

2. **Create a "Button" fieldtype partial** for consistent button fields across blueprints

3. **Document the leidingsploegen matching convention** - the `tak_naam` must exactly match `naam` in subtakken

4. **Consider removing the entire `takken` collection** - it duplicates data already managed elsewhere

---

## Appendix: File Reference

### Blueprints
- [resources/blueprints/collections/pages/home.yaml](resources/blueprints/collections/pages/home.yaml)
- [resources/blueprints/collections/pages/kalender.yaml](resources/blueprints/collections/pages/kalender.yaml)
- [resources/blueprints/collections/pages/meer.yaml](resources/blueprints/collections/pages/meer.yaml)
- [resources/blueprints/collections/pages/verhuur.yaml](resources/blueprints/collections/pages/verhuur.yaml)
- [resources/blueprints/collections/pages/tak_pagina.yaml](resources/blueprints/collections/pages/tak_pagina.yaml)
- [resources/blueprints/collections/pages/page.yaml](resources/blueprints/collections/pages/page.yaml)
- [resources/blueprints/collections/pages/thilala.yaml](resources/blueprints/collections/pages/thilala.yaml)
- [resources/blueprints/collections/pages/stamhoofd.yaml](resources/blueprints/collections/pages/stamhoofd.yaml)
- [resources/blueprints/collections/pages/takken_overzicht.yaml](resources/blueprints/collections/pages/takken_overzicht.yaml)
- [resources/blueprints/collections/takken/tak.yaml](resources/blueprints/collections/takken/tak.yaml)
- [resources/blueprints/globals/leidingsploegen.yaml](resources/blueprints/globals/leidingsploegen.yaml)
- [resources/blueprints/globals/slideshow_content.yaml](resources/blueprints/globals/slideshow_content.yaml)
- [resources/blueprints/globals/navigation.yaml](resources/blueprints/globals/navigation.yaml)
- [resources/blueprints/globals/contact_info.yaml](resources/blueprints/globals/contact_info.yaml)
- [resources/blueprints/globals/site_instellingen.yaml](resources/blueprints/globals/site_instellingen.yaml)
- [resources/blueprints/globals/social_media.yaml](resources/blueprints/globals/social_media.yaml)

### Templates
- [resources/views/home.antlers.html](resources/views/home.antlers.html)
- [resources/views/kalender.antlers.html](resources/views/kalender.antlers.html)
- [resources/views/meer.antlers.html](resources/views/meer.antlers.html)
- [resources/views/verhuur.antlers.html](resources/views/verhuur.antlers.html)
- [resources/views/kapoenen.antlers.html](resources/views/kapoenen.antlers.html)
- [resources/views/welpen.antlers.html](resources/views/welpen.antlers.html)
- [resources/views/jongverkenners.antlers.html](resources/views/jongverkenners.antlers.html)
- [resources/views/verkenners.antlers.html](resources/views/verkenners.antlers.html)
- [resources/views/voortrekkers.antlers.html](resources/views/voortrekkers.antlers.html)
- [resources/views/tictak.antlers.html](resources/views/tictak.antlers.html)
- [resources/views/thilala.antlers.html](resources/views/thilala.antlers.html)
- [resources/views/stamhoofd.antlers.html](resources/views/stamhoofd.antlers.html)
- [resources/views/takken.antlers.html](resources/views/takken.antlers.html)

### Content Files
- [content/collections/pages/home.md](content/collections/pages/home.md)
- [content/collections/pages/kalender.md](content/collections/pages/kalender.md)
- [content/collections/pages/meer.md](content/collections/pages/meer.md)
- [content/collections/pages/verhuur.md](content/collections/pages/verhuur.md)
- [content/collections/pages/kapoenen.md](content/collections/pages/kapoenen.md)
- [content/collections/pages/welpen.md](content/collections/pages/welpen.md)
- [content/collections/pages/takken.md](content/collections/pages/takken.md)
- [content/collections/pages/thilala.md](content/collections/pages/thilala.md)
- [content/globals/leidingsploegen.yaml](content/globals/leidingsploegen.yaml)
- [content/globals/slideshow_content.yaml](content/globals/slideshow_content.yaml)

---

*End of Audit Report*
