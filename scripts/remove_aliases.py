#!/usr/bin/env python3
"""
Remove `alias:` properties from YAML frontmatter in Markdown files.

Usage: python scripts/remove_aliases.py
"""
import re
from pathlib import Path

MD_GLOB = '**/*.md'
EXCLUDE_DIRS = ['.obsidian/plugins']


def should_exclude(path: Path) -> bool:
    for ex in EXCLUDE_DIRS:
        if ex in str(path):
            return True
    return False


ALIAS_RE = re.compile(r'^\s*alias\s*:\s*.*$', flags=re.IGNORECASE)


def process_file(path: Path) -> bool:
    text = path.read_text(encoding='utf-8')
    if not text.startswith('---'):
        return False

    parts = text.split('---', 2)
    # parts[0] is empty before first --- , parts[1] is frontmatter, parts[2] rest
    if len(parts) < 3:
        return False

    front = parts[1].splitlines()
    new_front = [line for line in front if not ALIAS_RE.match(line)]
    if new_front == front:
        return False

    new_text = '---\n' + '\n'.join(new_front).rstrip() + '\n---' + parts[2]
    path.write_text(new_text, encoding='utf-8')
    return True


def main():
    root = Path('.').resolve()
    md_files = list(root.glob(MD_GLOB))
    changed = []
    for p in md_files:
        if should_exclude(p):
            continue
        try:
            if process_file(p):
                changed.append(str(p.relative_to(root)))
        except Exception as e:
            print(f'Error processing {p}: {e}')

    print(f'Processed {len(md_files)} markdown files; modified {len(changed)} files.')
    for c in changed[:50]:
        print(c)


if __name__ == '__main__':
    main()
