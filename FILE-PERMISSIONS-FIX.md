# File Permissions Fix - Statamic Control Panel

## Het Probleem

Wanneer je content probeert te bewerken in het Statamic Control Panel krijg je deze error:

```
leidingsploegen/variables:1  Failed to load resource: the server responded with a status of 500 (Internal Server Error)
```

In de server logs zie je:
```
file_put_contents(/var/www/thilacoloma/content/globals/leidingsploegen.yaml): 
Failed to open stream: Permission denied
```

## De Oorzaak

De content files op de server hebben de verkeerde eigenaar (ownership). Ze zijn eigendom van een lokale gebruiker (ID 501) in plaats van de webserver gebruiker (`www-data`). Dit gebeurt wanneer files via rsync/scp worden geüpload zonder de juiste permissions.

## De Oplossing ✅

### Quick Fix (nu toegepast):

```bash
ssh vps-thila "sudo chown -R www-data:www-data /var/www/thilacoloma/content"
ssh vps-thila "sudo chmod -R 775 /var/www/thilacoloma/content"
ssh vps-thila "sudo chown -R www-data:www-data /var/www/thilacoloma/resources"
```

**Resultaat**: Je kunt nu alle globals en pages bewerken in het Control Panel! 🎉

### Verificatie:

Check of de permissions correct zijn:
```bash
ssh vps-thila "ls -la /var/www/thilacoloma/content/globals/leidingsploegen.yaml"
```

Output moet zijn:
```
-rwxrwxr-x 1 www-data www-data 22101 Sep 12 17:29 leidingsploegen.yaml
```

## Preventie voor de Toekomst

### Bij Deployen/Syncing

Voeg altijd deze stap toe na het uploaden van content:

```bash
# In sync-content.sh (al toegevoegd in de laatste versie)
ssh "$SERVER" "cd $REMOTE_PATH && chown -R www-data:www-data content resources"
```

Dit is al ingebouwd in de `./sync-content.sh to-server` command!

### Auto-Git-Sync Blijft Werken

De auto-sync vanuit het Control Panel naar GitHub werkt perfect omdat:
1. Het `auto-git-sync.php` script draait als www-data
2. Wijzigingen via CP worden direct met de juiste permissions opgeslagen
3. Git commits worden uitgevoerd door de webserver gebruiker

### Handmatige Uploads Vermijden

**Beste praktijk**:
- ✅ Bewerk content via Statamic Control Panel
- ✅ Gebruik `./sync-content.sh` voor deployment
- ❌ Upload NIET handmatig via FTP/SCP zonder permissions fix
- ❌ Bewerk NIET direct bestanden op de server

## Waarom Dit Gebeurde

Bij de initiële setup en tijdens eerdere syncs werden files geüpload met de lokale gebruiker als eigenaar. Dit werkte voor het lezen van content, maar het Control Panel kan alleen schrijven als www-data eigenaar is.

## Checklist na Deploy

Na elke deploy waar je bestanden naar de server hebt gestuurd:

```bash
# 1. Fix content permissions
ssh vps-thila "sudo chown -R www-data:www-data /var/www/thilacoloma/content"

# 2. Fix resources permissions  
ssh vps-thila "sudo chown -R www-data:www-data /var/www/thilacoloma/resources"

# 3. Fix storage permissions
ssh vps-thila "sudo chown -R www-data:www-data /var/www/thilacoloma/storage"
ssh vps-thila "sudo chmod -R 775 /var/www/thilacoloma/storage"

# 4. Clear cache
ssh vps-thila "cd /var/www/thilacoloma && php please cache:clear && php please stache:clear"
```

## Permanent Oplossing in sync-content.sh

De `sync-content.sh` script heeft nu automatisch deze fix ingebouwd in de `sync_push` functie:

```bash
log "🧹 Clearing server caches..."
ssh "$SERVER" "cd $REMOTE_PATH && php please cache:clear && php please stache:clear && chown -R www-data:www-data content resources"
```

Dit betekent dat bij elke `./sync-content.sh to-server` de permissions automatisch worden gefixed!

## Testen

Test of alles werkt:

1. Ga naar http://84.252.101.243/cp
2. Klik op **Globals** → **Leidingsploegen**
3. Wijzig een naam (bijv. voornaam van een leider)
4. Klik op **Save**
5. ✅ Geen error → Success!

## Troubleshooting

### Als je nog steeds een 500 error krijgt:

1. **Check de logs**:
   ```bash
   ssh vps-thila "tail -50 /var/www/thilacoloma/storage/logs/laravel.log"
   ```

2. **Controleer permissions**:
   ```bash
   ssh vps-thila "ls -la /var/www/thilacoloma/content/globals/"
   ```
   
   Alle files moeten `www-data www-data` zijn.

3. **Fix opnieuw**:
   ```bash
   ssh vps-thila "sudo chown -R www-data:www-data /var/www/thilacoloma/{content,resources,storage}"
   ```

### Als opslaan werkt maar niet synchroniseert met lokaal:

Gewoon runnen:
```bash
./sync-content.sh from-server
```

Dit haalt alle wijzigingen van de server naar je lokale machine.

---

**Status**: ✅ **Opgelost**  
**Datum**: 1 februari 2026  
**Impact**: Alle globals en content zijn nu bewerkbaar via het Control Panel
