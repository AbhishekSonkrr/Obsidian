import os
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC_MD = ROOT / "Untitled.md"
OUT_DIR = ROOT / "DSA"

def slug_filename(name: str) -> str:
    # keep readable filenames but remove problematic characters
    name = name.strip()
    name = re.sub(r"[\\/:*?\"<>|]", "-", name)
    name = re.sub(r"\s+", " ", name)
    return name + ".md"

def parse_table_lines(lines):
    in_table = False
    current_topic = None
    rows = []
    for ln in lines:
        if not in_table:
            if re.search(r"Topics\s*\|\s*complete\s*\|\s*question", ln, re.I):
                in_table = True
            continue
        # stop when table ends (a non-table line after table header and rows)
        if in_table and not ln.strip().startswith("|"):
            break
        if not ln.strip().startswith("|"):
            continue
        parts = [p.strip() for p in ln.strip().strip("|").split("|")]
        if len(parts) < 3:
            continue
        topic_cell = parts[0]
        question_cell = parts[2]
        if topic_cell:
            current_topic = topic_cell
        m = re.search(r"\[([^\]]+)\]\(([^)]+)\)", question_cell)
        if m:
            qtext = m.group(1).strip()
            qurl = m.group(2).strip()
            rows.append((current_topic or "Misc", qtext, qurl))
    return rows

def write_question_file(topic, qtext, qurl):
    folder = OUT_DIR / topic
    folder.mkdir(parents=True, exist_ok=True)
    fname = slug_filename(qtext)
    path = folder / fname
    link_value = f"[{qtext}]({qurl})"
    content = f"---\nlink: \"{link_value}\"\n---\n\n# {qtext}\n\nSource: {qurl}\n"
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)
    return path

def main():
    if not SRC_MD.exists():
        print(f"Source file not found: {SRC_MD}")
        return
    lines = SRC_MD.read_text(encoding="utf-8").splitlines()
    rows = parse_table_lines(lines)
    if not rows:
        print("No questions found in the table of Untitled.md")
        return
    OUT_DIR.mkdir(exist_ok=True)
    created = []
    for topic, qtext, qurl in rows:
        p = write_question_file(topic, qtext, qurl)
        created.append(p)
    print(f"Created {len(created)} files under {OUT_DIR}")
    for p in created[:20]:
        print(p)
    if len(created) > 20:
        print("...")

if __name__ == '__main__':
    main()
