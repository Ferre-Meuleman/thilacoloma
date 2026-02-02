#!/usr/bin/env python3
"""
Migrate leidingsploegen.yaml from single array to tab structure.
Splits data based on tak_groep field into separate arrays.
"""

import yaml
from pathlib import Path

# Read current data
data_file = Path('content/globals/leidingsploegen.yaml')
with open(data_file, 'r', encoding='utf-8') as f:
    data = yaml.safe_load(f)

# Check if we have the old structure
if 'leidingsploegen' not in data.get('data', {}):
    print("❌ No 'leidingsploegen' array found in data")
    exit(1)

# Group by tak_groep
grouped = {
    'groepsleiding': [],
    'kapoenen': [],
    'welpen': [],
    'tictak': [],
    'jongverkenners': [],
    'verkenners': [],
    'voortrekkers': []
}

for ploeg in data['data']['leidingsploegen']:
    tak_groep = ploeg.get('tak_groep')
    if tak_groep in grouped:
        grouped[tak_groep].append(ploeg)
    else:
        print(f"⚠️  Unknown tak_groep: {tak_groep} for {ploeg.get('tak_naam', 'unknown')}")

# Print statistics
print("\n📊 Migration Statistics:")
for groep, ploegen in grouped.items():
    print(f"   {groep}: {len(ploegen)} ploegen")

# Create new data structure
new_data = {
    'title': data.get('title', 'Leidingsploegen'),
    'data': grouped
}

# Backup original
backup_file = data_file.with_suffix('.yaml.backup')
import shutil
shutil.copy(data_file, backup_file)
print(f"\n💾 Backup created: {backup_file}")

# Write new structure
with open(data_file, 'w', encoding='utf-8') as f:
    yaml.dump(new_data, f, allow_unicode=True, default_flow_style=False, sort_keys=False, width=120)

print(f"✅ Migration complete! Data written to {data_file}")
print("\n🔍 Next steps:")
print("   1. Review the migrated file")
print("   2. Upload to server: scp content/globals/leidingsploegen.yaml root@84.252.101.243:/var/www/thilacoloma/content/globals/")
print("   3. Test Control Panel tabs")
print("   4. Test all tak pages")
