#!/usr/bin/env python3
import os
import re
import argparse

def has_tag(text):
    # detect existing checkbox tag like '- [ ] Type:' or '- [ ] <Category>' or 'Tags:' block
    if re.search(r"^\s*-\s*\[\s*\]\s*(Type:)?\s*.+$", text, re.M):
        return True
    if re.search(r"^Tags:\s*$", text, re.M):
        return True
    return False


def insert_tag(path, category):
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()
    if has_tag(content):
        return False
    tag = f"- [ ] Type: {category}\n\n"
    if content.startswith('---'):
        m = re.match(r"^(---\s*\n.*?\n---\s*\n)(.*)$", content, re.S)
        if m:
            new = m.group(1) + tag + m.group(2)
        else:
            new = tag + content
    else:
        new = tag + content
    with open(path, 'w', encoding='utf-8') as f:
        f.write(new)
    return True


def should_skip_dir(name):
    skip = {'.git', 'node_modules', '.venv', 'venv', '__pycache__', '.obsidian'}
    return name in skip


def main():
    parser = argparse.ArgumentParser(description='Prepend checkbox type tags to markdown files')
    parser.add_argument('--scope', choices=['dsa','all'], default='dsa')
    args = parser.parse_args()

    root = os.getcwd()
    modified = []

    for dirpath, dirnames, filenames in os.walk(root):
        # prune unwanted dirs
        dirnames[:] = [d for d in dirnames if not should_skip_dir(d)]
        rel = os.path.relpath(dirpath, root)
        if args.scope == 'dsa':
            if not (rel == 'DSA' or rel.startswith(os.path.join('DSA', ''))):
                continue
        for name in filenames:
            if not name.lower().endswith('.md'):
                continue
            path = os.path.join(dirpath, name)
            parent = os.path.basename(os.path.dirname(path))
            category = parent if parent else 'root'
            try:
                changed = insert_tag(path, category)
            except Exception as e:
                print(f'ERROR: {path}: {e}')
                continue
            if changed:
                relp = os.path.relpath(path, root).replace('\\', '/')
                print(relp)
                modified.append(relp)
    print(f'--DONE-- modified {len(modified)} files')

if __name__ == '__main__':
    main()
