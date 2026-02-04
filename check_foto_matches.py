#!/usr/bin/env python3
"""
Check welke foto bestanden matchen met de totem namen uit CSV.
"""

import csv
import io
import os

# Lees CSV
with open('Stamhoofd Leiding.csv', 'r', encoding='utf-8-sig') as f:
    content = f.read().replace('\r\n', '\n').replace('\r', '\n')

reader = csv.DictReader(io.StringIO(content))
totems_needed = {}
for row in reader:
    row = {k.strip(): v.strip() if v else '' for k, v in row.items()}
    totem_dier = row.get('Totem', '').strip()
    voornaam = row.get('Voornaam', '').strip()
    if totem_dier and totem_dier != '/':
        totems_needed[totem_dier.capitalize()] = voornaam

# Lees foto bestanden
foto_dir = 'public/assets/images/leidingfotos/'
fotos_raw = [f for f in os.listdir(foto_dir) if f.lower().endswith('.jpg')]
fotos = {f.replace('.jpg', '').replace('.JPG', ''): f for f in fotos_raw}

print("MATCHING STATUS:")
print("=" * 80)

matches = {}
no_match = []

for totem in sorted(totems_needed.keys()):
    naam = totems_needed[totem]
    
    # Exacte match
    if totem in fotos:
        matches[totem] = fotos[totem]
        print(f"✅ {totem:30s} → {fotos[totem]:30s} (voor {naam})")
    else:
        # Case-insensitive match
        found = False
        for foto_name, foto_file in fotos.items():
            if foto_name.lower() == totem.lower():
                matches[totem] = foto_file
                print(f"⚠️  {totem:30s} → {foto_file:30s} (case mismatch, voor {naam})")
                found = True
                break
        
        if not found:
            # Fuzzy match (levenshtein-achtig, maar simpel)
            for foto_name, foto_file in fotos.items():
                # Check if one is substring of other
                if totem.lower() in foto_name.lower() or foto_name.lower() in totem.lower():
                    print(f"🔍 {totem:30s} → mogelijk {foto_file:30s}? (voor {naam})")
                    break
            else:
                no_match.append((totem, naam))
                print(f"❌ {totem:30s} → GEEN MATCH (voor {naam})")

print("\n" + "=" * 80)
print(f"\nTOTALEN:")
print(f"  Exacte matches: {len(matches)}")
print(f"  Geen match: {len(no_match)}")
print(f"\nONTBREKENDE FOTO'S:")
for totem, naam in no_match:
    print(f"  - {totem}.jpg (voor {naam})")
