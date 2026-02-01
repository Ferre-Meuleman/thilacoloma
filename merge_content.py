#!/usr/bin/env python3

import os
import re
import yaml
from pathlib import Path

def parse_frontmatter_and_content(file_path):
    """Parse frontmatter and content from a markdown file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Split frontmatter and content
    if content.startswith('---\n'):
        parts = content.split('---\n', 2)
        if len(parts) >= 3:
            frontmatter = yaml.safe_load(parts[1])
            body_content = parts[2].strip()
            return frontmatter, body_content
    
    return {}, content

def update_pages_with_takken_content():
    """Update pages collection with content from takken collection."""
    takken_dir = Path('content/collections/takken')
    pages_dir = Path('content/collections/pages')
    
    # Mapping of takken files to update
    takken_files = ['kapoenen.md', 'welpen.md', 'verkenners.md', 'jongverkenners.md', 'voortrekkers.md']
    
    for filename in takken_files:
        takken_file = takken_dir / filename
        pages_file = pages_dir / filename
        
        if not takken_file.exists() or not pages_file.exists():
            print(f"Skipping {filename} - file not found")
            continue
            
        # Read takken content
        takken_fm, _ = parse_frontmatter_and_content(takken_file)
        
        # Read pages content  
        pages_fm, pages_content = parse_frontmatter_and_content(pages_file)
        
        # Add description field to pages frontmatter if it exists in takken
        if 'description' in takken_fm:
            pages_fm['description'] = takken_fm['description']
            print(f"Added description to {filename}")
        
        # Write updated pages file
        with open(pages_file, 'w', encoding='utf-8') as f:
            f.write('---\n')
            yaml.dump(pages_fm, f, default_flow_style=False, allow_unicode=True)
            f.write('---\n')
            if pages_content:
                f.write(pages_content)

if __name__ == '__main__':
    update_pages_with_takken_content()
    print("Content merge completed!")