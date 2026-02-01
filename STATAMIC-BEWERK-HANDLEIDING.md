# Thila Coloma - Statamic Bewerk Handleiding

**Complete roadmap voor het bewerken van alle content via het Statamic Control Panel**

---

## 🚀 Toegang tot het Control Panel

1. **Ga naar**: http://84.252.101.243/cp
2. **Inloggen** met je Statamic gebruikersnaam en wachtwoord
3. Je komt op het dashboard met alle bewerkingsopties

---

## 📋 Wat Kun Je Nu Bewerken?

### ✅ **Globals** (Globale Content)

Globals zijn herbruikbare content die op meerdere pagina's verschijnt.

#### 1. **Navigatie** (`Globals → Navigation`)
- **Wat**: Alle navigatieknoppen op de homepage
- **Wat kun je aanpassen**:
  - Label (tekst op de knop)
  - URL (waar de knop naartoe gaat)
  - Icoon pad (pad naar het SVG icoon bestand)
  - Zichtbaarheid (on/off toggle)
- **Waar verschijnt dit**: 
  - Homepage navigatie grid
  - Mogelijk ook in de header (indien geïmplementeerd)

#### 2. **Contact Informatie** (`Globals → Contact Info`)
- **Wat**: Alle contactgegevens van Thila Coloma
- **Wat kun je aanpassen**:
  - Organisatie naam
  - Adres (2 lijnen)
  - Contact email adressen met labels en iconen
- **Waar verschijnt dit**: 
  - Footer van alle pagina's
  - Meer pagina → Info tab → Contact sectie

#### 3. **Social Media** (`Globals → Social Media`)
- **Wat**: Links naar sociale media
- **Wat kun je aanpassen**:
  - Facebook URL
  - Instagram URL
  - YouTube URL
  - TikTok URL
- **Waar verschijnt dit**: 
  - Footer van alle pagina's

#### 4. **Meer Pagina Content** (`Globals → Meer Content`)
- **Wat**: Alle inhoud van de "Meer" pagina
- **Wat kun je aanpassen**:
  - **Visie sectie**:
    - Intro tekst
    - Kernwaarden
    - Volledige visie tekst (markdown ondersteund)
  - **Groepsleiding**:
    - Intro tekst
    - Scoutsjaar
    - Groepsleiding leden (replicator):
      - Totem
      - Naam
      - Foto pad
      - Hoofdtaken
      - Beschrijving
      - Email adres
  - **Inschrijvingen**:
    - Inschrijvingsformulier link
    - Stamhoofd link
    - Scoutsjaar
  - **Financiën**:
    - Lidgeld (standaard en verminderd)
    - Kampgeld (standaard en verminderd)
  - **Uniform**:
    - Waarom uniform tekst
    - Uniform benodigdheden (replicator)
    - Tak kleuren (replicator)
- **Waar verschijnt dit**: 
  - /meer pagina → Info tab

#### 5. **Leidingsploegen** (`Globals → Leidingsploegen`)
- **Wat**: Alle leiding per tak
- **Wat kun je aanpassen**:
  - Per tak: naam, groep, actief status
  - Per leider: voornaam, achternaam, totem, email, functie
- **Waar verschijnt dit**: 
  - Alle tak pagina's (kapoenen, welpen, jongverkenners, verkenners, voortrekkers)

#### 6. **Slideshow Content** (`Globals → Slideshow Content`)
- **Wat**: Nieuwsslides op de homepage
- **Wat kun je aanpassen**:
  - Per slide: titel, content, afbeelding, button tekst, link
- **Waar verschijnt dit**: 
  - Homepage → Nieuwssectie (slideshow)

#### 7. **Homepage Content** (`Globals → Homepage Content`)
- **Wat**: Homepage specifieke content
- **Wat kun je aanpassen**:
  - Intro titel
  - Intro tekst
  - Extra intro tekst
  - Nieuwssectie titel
- **Waar verschijnt dit**: 
  - Homepage

#### 8. **Kalender Content** (`Globals → Kalender Content`)
- **Wat**: Kalender pagina specifieke content
- **Waar verschijnt dit**: 
  - /kalender pagina

#### 9. **Site Instellingen** (`Globals → Site Instellingen`)
- **Wat**: Algemene site instellingen
- **Wat kun je aanpassen**:
  - Huidig scoutsjaar
  - Andere site-brede instellingen
- **Waar verschijnt dit**: 
  - Overal waar {{ site_settings:scoutsjaar }} wordt gebruikt

---

### ✅ **Collections** (Pagina's en Posts)

#### 1. **Pages** (`Collections → Pages`)

Alle hoofdpagina's van de website.

##### **Tak Pagina's** (kapoenen, welpen, jongverkenners, verkenners, voortrekkers)
- **Blueprint**: `tak_pagina`
- **Template**: Specifiek per tak (bijv. `kapoenen.antlers.html`)
- **Wat kun je aanpassen**:
  - **Title**: Pagina titel
  - **Tak groep**: Categorie (kapoenen, welpen, etc.)
  - **Content**: Hoofd beschrijving van de tak (markdown)
  - **Subtakken** (replicator):
    - Naam (bijv. "Kapoenen 1")
    - Afwezigheidsformulier link
    - Rekeningnummer
- **Voorbeeld structuur**:
  ```yaml
  title: Kapoenen
  tak_groep: kapoenen
  content: |
    Het leven van een kapoen (6-8 jaar)...
  subtakken:
    - naam: 'Kapoenen 1'
      afwezigheids_formulier: 'https://forms.gle/...'
      rekeningnummer: 'BE83 9735 0413 6215'
  ```

##### **Homepage** (`Collections → Pages → Home`)
- **Blueprint**: `home`
- **Template**: `home.antlers.html`
- **Wat kun je aanpassen**:
  - Gebruikt voornamelijk globals (zie Homepage Content global)

##### **Kalender** (`Collections → Pages → Kalender`)
- **Blueprint**: `kalender`
- **Template**: `kalender.antlers.html`
- **Wat kun je aanpassen**:
  - Kalender specifieke content

##### **Meer** (`Collections → Pages → Meer`)
- **Blueprint**: `meer`
- **Template**: `meer.antlers.html`
- **Wat kun je aanpassen**:
  - Gebruikt voornamelijk de `Meer Content` global

##### **Stamhoofd** (`Collections → Pages → Stamhoofd`)
- **Blueprint**: `stamhoofd`
- **Template**: `stamhoofd.antlers.html`
- **Wat kun je aanpassen**:
  - Stamhoofd pagina content

##### **Takken Overzicht** (`Collections → Pages → Takken`)
- **Blueprint**: `takken_overzicht`
- **Template**: `takken.antlers.html`
- **Wat kun je aanpassen**:
  - Overzichtspagina van alle takken

##### **Thilala** (`Collections → Pages → Thilala`)
- **Blueprint**: `thilala`
- **Template**: `thilala.antlers.html`
- **Wat kun je aanpassen**:
  - Thilala pagina content (lokaal/gebouw)

##### **Verhuur** (`Collections → Pages → Verhuur`)
- **Blueprint**: `verhuur`
- **Template**: `verhuur.antlers.html`
- **Wat kun je aanpassen**:
  - Verhuur informatie

#### 2. **News** (`Collections → News`)
- **Wat**: Nieuwsartikelen/berichten
- **Wat kun je aanpassen**:
  - Titel
  - Content
  - Afbeelding
  - Publicatiedatum
- **Waar verschijnt dit**: 
  - Nieuwspagina (indien geïmplementeerd)
  - Mogelijk in slideshow

---

## 🛠️ Stap-voor-Stap: Content Bewerken

### **Methode 1: Via Globals**

1. Log in op `/cp`
2. Klik in het linker menu op **"Globals"**
3. Kies de global die je wilt bewerken (bijv. "Navigation")
4. Bewerk de velden:
   - Voor **replicators** (lijsten): klik op "+ Add Item" om een nieuw item toe te voegen
   - Gebruik de **drag handle** (☰) om items te verslepen
   - Klik op de **trashcan icon** om items te verwijderen
5. Klik op **"Save"** rechtsboven
6. De wijzigingen zijn **direct live** op de website!

### **Methode 2: Via Collections**

1. Log in op `/cp`
2. Klik in het linker menu op **"Collections"**
3. Kies de collection (bijv. "Pages")
4. Klik op de pagina die je wilt bewerken
5. Bewerk de velden in het formulier
6. Klik op **"Save"** rechtsboven
7. De wijzigingen zijn **direct live**!

---

## 📝 Specifieke Bewerkingsscenario's

### **Scenario 1: Navigatie-item Toevoegen**

1. Ga naar `Globals → Navigation`
2. Scroll naar "Nav Items"
3. Klik op **"+ Add Item"**
4. Vul in:
   - **Label**: De tekst op de knop (bijv. "Shop")
   - **URL**: De link (bijv. "/shop")
   - **Icon**: Pad naar het icoon bestand (bijv. "/assets/images/icons/shop.svg")
   - **Visible**: Toggle aan/uit
5. **Save**

### **Scenario 2: Groepsleiding Lid Wijzigen**

1. Ga naar `Globals → Meer Content`
2. Scroll naar "Groepsleiding Leden"
3. Klik op het lid dat je wilt wijzigen
4. Bewerk:
   - Totem
   - Naam
   - Foto (upload nieuwe foto of wijzig pad)
   - Hoofdtaken
   - Beschrijving
   - Email
5. **Save**

### **Scenario 3: Nieuwe Subtak Toevoegen aan Kapoenen**

1. Ga naar `Collections → Pages`
2. Klik op **"Kapoenen"**
3. Scroll naar "Subtakken"
4. Klik op **"+ Add Item"**
5. Vul in:
   - **Naam**: "Kapoenen 3"
   - **Afwezigheidsformulier**: Link naar Google Form
   - **Rekeningnummer**: Belgisch IBAN nummer
6. **Save**

### **Scenario 4: Slideshow Slide Wijzigen**

1. Ga naar `Globals → Slideshow Content`
2. Scroll naar "News Slides"
3. Klik op de slide die je wilt wijzigen
4. Bewerk:
   - **Title**: Titel van de slide
   - **Content**: Beschrijving
   - **Image**: Upload nieuwe afbeelding
   - **Button Text**: Tekst op de knop
   - **Button Link**: Link (optioneel)
5. **Save**

### **Scenario 5: Contact Email Adres Toevoegen**

1. Ga naar `Globals → Contact Info`
2. Scroll naar "Contact Adressen"
3. Klik op **"+ Add Item"**
4. Vul in:
   - **Label**: Bijvoorbeeld "Ledenadministratie"
   - **Email**: Het email adres
   - **Icon**: FontAwesome icon class (bijv. "fas fa-user")
5. **Save**

### **Scenario 6: Lidgeld Aanpassen**

1. Ga naar `Globals → Meer Content`
2. Scroll naar de financiële sectie
3. Bewerk:
   - **Lidgeld Standaard**: Bijv. "€75"
   - **Lidgeld Verminderd**: Bijv. "€20"
   - **Kampgeld Standaard**: Bijv. "€170"
   - **Kampgeld Verminderd**: Bijv. "€55"
4. **Save**

---

## 🖼️ Afbeeldingen Uploaden

### **Via Asset Manager**

1. Klik in het linker menu op **"Assets"**
2. Navigeer naar de juiste map (bijv. `images/leidingfotos/`)
3. Sleep afbeeldingen naar het venster of klik op **"Upload Files"**
4. De afbeeldingen zijn nu beschikbaar om te gebruiken

### **Leidingfoto's Toevoegen**

1. Upload de foto naar `Assets → images → leidingfotos`
2. **Belangrijk**: Bestandsnaam moet het dier van de totem zijn (bijv. `Mustela.jpg`)
3. In de global gebruik je dan: `/assets/images/leidingfotos/Mustela.jpg`

---

## 🔄 Synchronisatie met Lokaal & GitHub

### **Na Bewerken in Control Panel**

De wijzigingen staan nu **alleen op de server**. Om ze ook lokaal te hebben:

1. Open terminal op je lokale machine
2. Ga naar de projectmap:
   ```bash
   cd "/Users/simon/Library/CloudStorage/OneDrive-Persoonlijk/Thila Coloma/Thilacoloma_statamic"
   ```
3. Haal wijzigingen op van de server:
   ```bash
   ./sync-content.sh from-server
   ```
4. Commit de wijzigingen naar Git:
   ```bash
   git add content/
   git commit -m "Content updates via CP"
   git push origin master
   ```

### **Na Lokaal Bewerken**

Als je lokaal bestanden hebt gewijzigd en wilt uploaden:

1. Open terminal
2. Push naar server:
   ```bash
   ./sync-content.sh to-server
   ```

---

## 🎯 Belangrijke Tips

### ✅ **Do's**

- **Altijd via Control Panel werken** voor content wijzigingen
- **Markdown gebruiken** in tekstvelden voor opmaak (vet, cursief, lijsten)
- **Afbeeldingen uploaden** via Assets voordat je ze gebruikt
- **Regelmatig synchroniseren** tussen server en lokaal
- **Commits maken** na elke groep wijzigingen

### ❌ **Don'ts**

- **Niet direct bestanden bewerken** op de server via FTP/SSH
- **Geen bestandsnamen wijzigen** van kritieke assets (zoals leidingfotos)
- **Niet de blueprint structuur wijzigen** zonder kennis van Statamic
- **Geen database queries uitvoeren** (Statamic gebruikt flat files)

---

## 🔧 Handige Shortcuts & Tooltips

### **In het Control Panel**

- **Cmd/Ctrl + S**: Opslaan
- **Cmd/Ctrl + E**: Bewerken
- **Esc**: Sluiten zonder opslaan
- **?**: Help/Keyboard shortcuts tonen

### **Markdown Syntax** (voor tekstvelden)

```markdown
**Vet**
*Cursief*
[Link](https://example.com)
- Lijstitem
1. Genummerd lijstitem
```

---

## 📞 Hulp Nodig?

### **Veelvoorkomende Problemen**

#### **Probleem: Wijzigingen niet zichtbaar**
- **Oplossing**: Log uit en weer in, of clear de cache via `/cp/utilities/cache`

#### **Probleem: Kan niet inloggen**
- **Oplossing**: Controleer gebruikersnaam/wachtwoord, of reset via terminal:
  ```bash
  php please make:user
  ```

#### **Probleem: Afbeelding wordt niet getoond**
- **Oplossing**: 
  - Controleer of het pad correct is (inclusief `/assets/images/...`)
  - Controleer of de afbeelding daadwerkelijk geüpload is

#### **Probleem: Replicator item verdwenen**
- **Oplossing**: Check of je op "Save" hebt geklikt. Anders gebruik de undo functie.

---

## 📚 Aanvullende Resources

- **Statamic Documentatie**: https://statamic.dev/
- **Antlers Templating**: https://statamic.dev/antlers
- **Markdown Guide**: https://www.markdownguide.org/

---

## 🗺️ Blueprint Overzicht

### **Available Blueprints**

| Blueprint | Gebruikt Voor | Locatie |
|-----------|---------------|---------|
| `tak_pagina` | Alle tak pagina's | `resources/blueprints/collections/pages/tak_pagina.yaml` |
| `home` | Homepage | `resources/blueprints/collections/pages/home.yaml` |
| `kalender` | Kalender pagina | `resources/blueprints/collections/pages/kalender.yaml` |
| `meer` | Meer pagina | `resources/blueprints/collections/pages/meer.yaml` |
| `page` | Algemene pagina's | `resources/blueprints/collections/pages/page.yaml` |
| `navigation` | Navigatie global | `resources/blueprints/globals/navigation.yaml` |
| `contact_info` | Contact global | `resources/blueprints/globals/contact_info.yaml` |
| `social_media` | Social media global | `resources/blueprints/globals/social_media.yaml` |
| `meer_content` | Meer content global | `resources/blueprints/globals/meer_content.yaml` |
| `leidingsploegen` | Leiding global | `resources/blueprints/globals/leidingsploegen.yaml` |

---

## 🎨 Veld Types Uitleg

| Veld Type | Beschrijving | Voorbeeld Gebruik |
|-----------|--------------|-------------------|
| **Text** | Enkele regel tekst | Titel, naam, email |
| **Textarea** | Meerdere regels tekst | Korte beschrijving |
| **Markdown / Bard** | Rijke tekst editor | Lange content met opmaak |
| **Toggle** | Aan/uit schakelaar | Zichtbaarheid, actief status |
| **Replicator** | Herhaalbare sets velden | Subtakken, groepsleiding leden |
| **Assets** | Afbeelding/bestand selectie | Foto's, documenten |
| **Select** | Dropdown keuzemenu | Tak groep selectie |
| **Date** | Datum picker | Publicatiedatum |

---

**Versie**: 1.0  
**Laatst bijgewerkt**: 1 februari 2026  
**Contact**: coelho@thilacoloma.be
