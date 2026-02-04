#!/usr/bin/env python3
"""
Script om leidingsploegen.yaml te updaten op basis van Stamhoofd CSV export.
"""

import csv
import io
import os
from collections import defaultdict

# Lees alle beschikbare foto's
foto_dir = 'public/assets/images/leidingfotos/'
fotos_raw = [f for f in os.listdir(foto_dir) if f.lower().endswith('.jpg') and not f.startswith('.')]
fotos_map = {f.replace('.jpg', '').replace('.JPG', '').lower(): f for f in fotos_raw}

# Bekende variaties/aliases
TOTEM_ALIASES = {
    'chigi': 'chigy',
    'cardelino': 'cardellino',
    'walloewie': 'waloewie',
    'kaaimansnoek': 'snoek',  # Alleen als dit echt dezelfde is
}

def find_foto(totem_dier):
    """
    Zoek de beste match voor een totem dier naam.
    Probeert: exact match, known aliases, anders None.
    """
    if not totem_dier or totem_dier == '/':
        return None
    
    totem_lower = totem_dier.lower()
    
    # Exact match (case-insensitive)
    if totem_lower in fotos_map:
        return fotos_map[totem_lower]
    
    # Check aliases
    if totem_lower in TOTEM_ALIASES:
        alias = TOTEM_ALIASES[totem_lower]
        if alias in fotos_map:
            return fotos_map[alias]
    
    # Geen match
    return None

# Lees de CSV en fix Windows line endings
with open('Stamhoofd Leiding.csv', 'r', encoding='utf-8-sig') as f:
    content = f.read().replace('\r\n', '\n').replace('\r', '\n')

# Parse CSV
leiding_per_tak = defaultdict(list)
missing_photos = []
fuzzy_matches = []

reader = csv.DictReader(io.StringIO(content))
for row in reader:
    # Strip keys and values
    row = {k.strip(): v.strip() if v else '' for k, v in row.items()}
    
    tak = row.get('Tak', '').strip()
    if tak == '/' or not tak:
        continue
    
    voornaam = row.get('Voornaam', '').strip()
    achternaam = row.get('Achternaam', '').strip()
    
    # Normaliseer de totem
    voortotem = row.get('Voortotem', '').strip()
    if voortotem and voortotem != '/':
        voortotem = voortotem.capitalize()
    else:
        voortotem = ''
        
    totem_dier = row.get('Totem', '').strip()
    if totem_dier and totem_dier != '/':
        totem_dier = totem_dier.capitalize()
    else:
        totem_dier = ''
    
    if voortotem and totem_dier:
        full_totem = f"{voortotem} {totem_dier}"
    elif totem_dier:
        full_totem = totem_dier
    else:
        full_totem = voornaam
    
    # Email op basis van totem dier
    if totem_dier and totem_dier != '/' and totem_dier.lower() != voornaam.lower():
        email = f"{totem_dier.lower()}@thilacoloma.be"
    else:
        email = f"{voornaam.lower()}@thilacoloma.be"
    
    # Check of foto bestaat
    foto_file = find_foto(totem_dier)
    if not foto_file and totem_dier:
        missing_photos.append((totem_dier, voornaam))
    elif foto_file and foto_file.replace('.jpg', '').lower() != totem_dier.lower():
        fuzzy_matches.append((totem_dier, foto_file, voornaam))
    
    is_takleider = row.get('Takleiding', '').strip().lower() == 'ja'
    
    leiding_per_tak[tak].append({
        'voornaam': voornaam,
        'achternaam': achternaam,
        'totem': full_totem,
        'email': email,
        'is_takleider': is_takleider
    })

# Definieer de tak structuur
tak_mapping = {
    'Kapoenen 1': ('kapoenen', 'kap1'),
    'Kapoenen 2': ('kapoenen', 'kap2'),
    'Kapoenen 3': ('kapoenen', 'kap3'),
    'Jongwelpen': ('welpen', 'jw'),
    'Welpen': ('welpen', 'w'),
    'Seniorwelpen': ('welpen', 'sw'),
    'Jongverkenners 1': ('jongverkenners', 'jv1'),
    'Jongverkenners 2': ('jongverkenners', 'jv2'),
    'Jongverkenners 3': ('jongverkenners', 'jv3'),
    'Verkenners 1': ('verkenners', 'v1'),
    'Verkenners 2': ('verkenners', 'v2'),
    'Verkenners 3': ('verkenners', 'v3'),
    'Voortrekkers': ('voortrekkers', 'vt'),
    'Akabe': ('akabe', 'akabe'),
}

def yaml_quote(s):
    """Escape a string for YAML - use double quotes if contains special chars."""
    if "'" in s:
        # Use double quotes and escape any double quotes inside
        return '"' + s.replace('"', '\\"') + '"'
    else:
        return "'" + s + "'"

# Genereer YAML output
def generate_yaml():
    output = []
    
    # Groepeer per tak_groep
    groepen_data = defaultdict(list)
    for tak_naam, (tak_groep, tak_id) in tak_mapping.items():
        if tak_naam not in leiding_per_tak:
            print(f"  WAARSCHUWING: Geen leiding gevonden voor {tak_naam}")
            continue
            
        leden = leiding_per_tak[tak_naam]
        
        # Vind takleider
        takleiders = [l for l in leden if l['is_takleider']]
        takleider = takleiders[0] if takleiders else leden[0]
        
        # Bouw de tak data
        tak_data = []
        tak_data.append(f"    -")
        tak_data.append(f"      id: {tak_id}")
        tak_data.append(f"      type: leidingsploeg")
        tak_data.append(f"      tak_naam: {yaml_quote(tak_naam)}")
        tak_data.append(f"      tak_groep: {tak_groep}")
        tak_data.append(f"      actief: true")
        tak_data.append(f"      leiding:")
        
        # Sorteer: takleider eerst, dan alfabetisch
        leden_sorted = sorted(leden, key=lambda x: (not x['is_takleider'], x['voornaam']))
        
        for i, lid in enumerate(leden_sorted):
            lid_id = f"l{tak_id}_{i+1}"
            functie = 'takleider' if lid['is_takleider'] else 'leiding'
            
            tak_data.append(f"        -")
            tak_data.append(f"          id: {lid_id}")
            tak_data.append(f"          type: leider")
            tak_data.append(f"          voornaam: {lid['voornaam']}")
            tak_data.append(f"          achternaam: {yaml_quote(lid['achternaam'])}")
            tak_data.append(f"          totem: {yaml_quote(lid['totem'])}")
            tak_data.append(f"          email: {lid['email']}")
            tak_data.append(f"          functie: {functie}")
            tak_data.append(f"          enabled: true")
        
        tak_data.append(f"      enabled: true")
        
        groepen_data[tak_groep].append('\n'.join(tak_data))
    
    # Schrijf per groep
    groep_order = ['kapoenen', 'welpen', 'jongverkenners', 'verkenners', 'voortrekkers', 'akabe']
    
    for groep in groep_order:
        if groep not in groepen_data:
            output.append(f"{groep}: []")
            continue
        
        output.append(f"{groep}:")
        for tak_data in groepen_data[groep]:
            output.append(tak_data)
    
    # Voeg ook tictak toe (alias voor akabe maar met tak_naam "Tictak")
    if 'akabe' in groepen_data:
        output.append(f"tictak:")
        for tak_data in groepen_data['akabe']:
            # Replace tak_naam 'Akabe' met 'Tictak' en tak_groep met tictak
            tictak_data = tak_data.replace("tak_naam: 'Akabe'", "tak_naam: 'Tictak'")
            tictak_data = tictak_data.replace("tak_groep: akabe", "tak_groep: tictak")
            tictak_data = tictak_data.replace("id: akabe", "id: tictak")
            tictak_data = tictak_data.replace("id: lakabe_", "id: ltictak_")
            output.append(tictak_data)
    
    return '\n'.join(output)

# Schrijf naar bestand
yaml_content = generate_yaml()
with open('content/globals/default/leidingsploegen.yaml', 'w', encoding='utf-8') as f:
    f.write(yaml_content)

print("Leidingsploegen.yaml is geüpdatet!")
print(f"\nTakken in CSV: {list(leiding_per_tak.keys())}")
print(f"\nAantal leiding per tak:")
for tak, leden in sorted(leiding_per_tak.items()):
    takleiders = [l for l in leden if l['is_takleider']]
    print(f"  {tak}: {len(leden)} leden, takleider: {takleiders[0]['voornaam'] if takleiders else 'GEEN!'}")

# Rapportage foto's
if fuzzy_matches:
    print(f"\n⚠️  FUZZY FOTO MATCHES (controleer of dit correct is):")
    for totem, foto, voornaam in fuzzy_matches:
        print(f"  {totem} → {foto} (voor {voornaam})")

if missing_photos:
    print(f"\n❌ ONTBREKENDE FOTO'S ({len(missing_photos)}):")
    for totem, voornaam in missing_photos:
        print(f"  {totem}.jpg (voor {voornaam})")
    print(f"\n💡 Deze foto's moeten geüpload worden naar public/assets/images/leidingfotos/")
else:
    print(f"\n✅ Alle foto's gevonden!")

