#!/usr/bin/env python3
"""
HoI4 Idea GFX entry generator — folder scan, duplicate detection, safer writes

Based on the original by Yard1; this version adds:
- Scans idea files to collect `picture` names
- **--icons-dir** to scan a folder for icon files; optional **--recurse**
- **--exts** (or --ext) to accept one or more icon formats (.tga/.dds/etc.)
- **--subdir** to write paths under gfx/interface/ideas/<subdir>/...
- Duplicate detection (skip existing SpriteTypes in target .gfx)
- **--backup** to create .bak files before writing
- **--dry-run** to preview changes without writing
- Predictable prefix handling: default adds `idea_` to filenames; use **--no-prefix** to disable, or **--prefix** to set custom text

Author: Lukas/Argeddion (building on Yard1's script)
License: MIT

Since this can be a bit confusing, here's what you need to paste into your command Console:
py "C:\Users\User\Documents\Paradox Interactive\Hearts of Iron IV\mod\eaw_foe\interface\hoi4ideagfxentry.py" ^ 
  "C:\Users\User\Documents\Paradox Interactive\Hearts of Iron IV\mod\eaw_foe\interface\foe_ideas.gfx" ^ 
  --icons-dir "C:\Users\User\Documents\Paradox Interactive\Hearts of Iron IV\mod\eaw_foe\gfx\interface\ideas\[YourIdeasFolder]" ^
  --exts .tga .dds --subdir NCG --recurse

Just replace [YourIdeasFolder] with the actual name of the folder you have your ideas in.
This script is CD-agnostic and works from any base-folder.
"""
import argparse
import os
import re
import sys
from typing import List, Tuple, Iterable, Set

# ----------------------- Utils -----------------------

def readable_dir(path: str) -> str:
    if not os.path.isdir(path):
        raise argparse.ArgumentTypeError(f"{path} is not a valid directory")
    if not os.access(path, os.R_OK):
        raise argparse.ArgumentTypeError(f"{path} is not readable")
    return path


def read_text(path: str) -> str:
    with open(path, 'r', encoding='utf-8', errors='replace') as f:
        return f.read()


def read_lines(path: str) -> List[str]:
    return read_text(path).splitlines()


def write_lines(path: str, lines: List[str]):
    with open(path, 'w', encoding='utf-8') as f:
        for line in lines:
            f.write(str(line) + "\n")


def backup_file(path: str):
    bak = path + ".bak"
    if not os.path.exists(bak):
        with open(path, 'rb') as src, open(bak, 'wb') as dst:
            dst.write(src.read())


def find_insertion_index(lines: List[str]) -> int:
    """Return the index before the file's final closing brace '}'. If none, append."""
    for i in range(len(lines) - 1, -1, -1):
        if '}' in lines[i]:
            return i
    return len(lines)

# ----------------------- Idea parsing -----------------------

def parse_idea_pictures(idea_file: str) -> List[str]:
    """Parse an idea file and extract unique picture names using a brace counter.
    Mirrors the spirit of Yard1's original logic, but is Python 3 and whitespace tolerant.
    """
    print(f"Reading idea file {idea_file} ...")
    text = read_text(idea_file)
    # strip comments
    text = re.sub(r"#.*", "", text)
    lines = text.splitlines()

    open_blocks = 0
    current_picture = ""
    pictures: List[str] = []

    for raw in lines:
        line = raw.strip()
        # detect picture assignments inside deeper blocks
        if open_blocks > 2 and re.search(r"(^|\s)picture\s*=", line):
            # grab token after '=' (strip quotes if present)
            val = re.sub(r".*picture\s*=\s*", "", line)
            val = val.strip().strip('"')
            current_picture = val
        # also capture certain two-level forms like `my_idea = {` lines
        if open_blocks == 2 and '{' in line:
            token = re.sub(r"\s|=(\s|){", "", line)
            token = token.strip().strip('"')
            current_picture = token
        # on descent back above 3, commit any collected picture
        if open_blocks < 3 and current_picture:
            if current_picture not in pictures:
                pictures.append(current_picture)
            current_picture = ""

        open_blocks += line.count('{')
        open_blocks -= line.count('}')

    # edge case: file ends while inside a block
    if current_picture and current_picture not in pictures:
        pictures.append(current_picture)

    print(f"Found {len(pictures)} unique idea picture names.")
    return pictures

# ----------------------- Sprite builders -----------------------

def has_sprite_named(file_text: str, sprite_name: str) -> bool:
    return f'"{sprite_name}"' in file_text


def sprite_block(name: str, texture_path: str) -> List[str]:
    return [
        "\tSpriteType = {",
        f"\t\tname = \"{name}\"",
        f"\t\ttexturefile = \"{texture_path}\"",
        "\t}"
    ]

# ----------------------- Icons discovery -----------------------

def normalize_exts(single_ext: str, multi_exts: List[str]) -> List[str]:
    exts = multi_exts or [single_ext or '.tga']
    out = []
    for e in exts:
        if not e:
            continue
        e = e.lower()
        if not e.startswith('.'):
            e = '.' + e
        out.append(e)
    # Undupe
    seen: Set[str] = set()
    ordered: List[str] = []
    for e in out:
        if e not in seen:
            seen.add(e)
            ordered.append(e)
    return ordered or ['.tga']


def iter_icon_files(icons_dir: str, exts: List[str], recurse: bool) -> Iterable[Tuple[str, str, str]]:
    """Yield (icon_name, ext, rel_subdir) under icons_dir for matching exts."""
    if not icons_dir:
        return []
    root = os.path.abspath(icons_dir)

    def yield_from(dirpath: str, filenames: List[str]):
        rel = os.path.relpath(dirpath, root)
        rel_sub = '' if rel == '.' else rel.replace('\\', '/')
        for fn in filenames:
            base, ext = os.path.splitext(fn)
            if ext.lower() in exts:
                yield base, ext.lower(), rel_sub

    if recurse:
        for dirpath, _dirs, files in os.walk(root):
            yield from yield_from(dirpath, files)
    else:
        yield from yield_from(root, os.listdir(root))

# ----------------------- Main -----------------------

def main():
    p = argparse.ArgumentParser(description='Generate Idea SpriteTypes from an idea file and/or by scanning an icon folder.')
    p.add_argument('gfx_file', help='Target .gfx file to append/create (e.g., interface/ideas/my_ideas.gfx)')

    # Sources of names
    p.add_argument('--idea-file', help='(Optional) /common/ideas file to parse for picture names')
    p.add_argument('--icons-dir', type=readable_dir, help='(Optional) Folder under gfx/interface/ideas to scan for filenames')
    p.add_argument('--recurse', action='store_true', help='Recurse into subfolders of --icons-dir')
    p.add_argument('--ext', default='.tga', help='Single icon extension (default: .tga). Ignored if --exts given')
    p.add_argument('--exts', nargs='+', help='Multiple icon extensions to allow, e.g. --exts .tga .dds')
    p.add_argument('--subdir', default='', help='Base subfolder under gfx/interface/ideas (e.g., NCG)')

    # Prefix behavior
    p.add_argument('--no-prefix', action='store_true', help='Do NOT add the idea_ prefix to icon filenames')
    p.add_argument('--prefix', default='', help='Custom filename prefix to prepend (ignored if --no-prefix)')
    p.add_argument('--strip-prefix', default='', help='When scanning filenames, strip this leading prefix before deriving the base name (e.g., idea_)')

    # Safety
    p.add_argument('--backup', action='store_true', help='Create .bak before writing if file exists')
    p.add_argument('--dry-run', action='store_true', help="Report planned changes without writing")

    args = p.parse_args()
    if not args.idea_file and not args.icons_dir:
        sys.exit('Provide at least one source of names: --idea-file and/or --icons-dir')



    # Prepare targets
    gfx_path = args.gfx_file
    if os.path.isdir(gfx_path):
        sys.exit(f"gfx_file points to a directory, not a file: {gfx_path}")

    # Ensure parent folder exists when creating new file
    parent = os.path.dirname(gfx_path)
    if parent and not os.path.exists(parent):
        os.makedirs(parent, exist_ok=True)

    # Load or init gfx lines
    if os.path.exists(gfx_path):
        lines = read_lines(gfx_path)
    else:
        lines = ["spriteTypes = {", "}"]

    # Cache for duplicate detection
    gfx_text = "\n".join(lines)

    # Gather candidate base names (union of ideas + folder scan)
    names: Set[str] = set()

    # From ideas file 
    if args.idea_file:
        names.update(parse_idea_pictures(args.idea_file))

    # From folder scan
    exts = normalize_exts(args.ext, args.exts)
    if args.icons_dir:
        for base, ext, rel in iter_icon_files(args.icons_dir, exts, args.recurse):
            # If you later add --strip-prefix, you can trim it here; for now, just use the filename base
            names.add(base)


    # Prepare insertions
    added = 0
    base_sub = args.subdir.strip('/\\') if args.subdir else ''

    for base in sorted(names):
        prefix = '' if args.no_prefix else (args.prefix or '')
        # Pick the first allowed extension for output (scan-only mode can’t reliably pick per-file ext)
        ext = exts[0]

        texture_subparts = [p for p in [base_sub] if p]
        subpath = ('/'.join(texture_subparts) + '/') if texture_subparts else ''
        texture_path = f"gfx/interface/ideas/{subpath}{prefix}{base}{ext}"

        sprite_name = f"GFX_idea_{base}"
        if has_sprite_named(gfx_text, sprite_name):
            print(f"[SKIP] {sprite_name} already present in {os.path.basename(gfx_path)}")
            continue

        block = sprite_block(sprite_name, texture_path)
        idx = find_insertion_index(lines)
        lines = lines[:idx] + block + lines[idx:]
        gfx_text += f"\nname = \"{sprite_name}\"\n"
        added += 1
        print(f"[ADD ] {sprite_name} -> {os.path.basename(gfx_path)} ({texture_path})")


    if args.dry_run:
        print("\nDry run complete — no files written.")
        return

    if added and args.backup and os.path.exists(gfx_path):
        backup_file(gfx_path)

    write_lines(gfx_path, lines)
    print(f"GFX file {gfx_path} written successfully; added {added} new SpriteTypes.")


if __name__ == '__main__':
    main()
