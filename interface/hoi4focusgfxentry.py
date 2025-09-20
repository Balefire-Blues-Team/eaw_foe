#!/usr/bin/env python3
"""
HoI4 Focus GFX entry generator — folder scan + multi-icon + duplicate detection

New in this version
- **--icons-dir**: scan a folder for icon files and add them all automatically
- **--recurse**: include subfolders under --icons-dir
- **--exts**: accept multiple file extensions (default: .tga). Backwards compatible with --ext
- Per-file subfolder support: write texture paths like gfx/interface/goals/<base_subdir>/<relative_subdir>/<icon><ext>
- Duplicate detection (skip if a sprite with that name already exists)
- Multi-icon positional args are still supported and can be combined with --icons-dir
- Optional --backup and --dry-run

Author: Lukas/Argeddion (based on Yard1's original)
License: MIT

Here's what you gotta do to run the script:
Start CMD from the folder that contains your Icons
py "C:\Users\User\Documents\Paradox Interactive\Hearts of Iron IV\mod\eaw_foe\interface\hoi4focusgfxentry.py" ^
  --goals "[YourGoalsFile].gfx" --goals_shine "[YourGoalsShineFile].gfx" ^
  --icons-dir "C:\Users\User\Documents\Paradox Interactive\Hearts of Iron IV\mod\eaw_foe\gfx\interface\goals\[YourIconFolder]" ^
  --exts .tga .dds --subdir NCG -d--directory "."

"""
import argparse
import os
import sys
from typing import List, Tuple, Iterable, Set

# ----------------------- Helpers -----------------------

def readable_dir(path: str) -> str:
    if not os.path.isdir(path):
        raise argparse.ArgumentTypeError(f"{path} is not a valid directory")
    if not os.access(path, os.R_OK):
        raise argparse.ArgumentTypeError(f"{path} is not readable")
    return path


def read_lines(path: str) -> List[str]:
    with open(path, 'r', encoding='utf-8', errors='replace') as f:
        return f.read().splitlines()


def write_lines(path: str, lines: List[str]):
    with open(path, 'w', encoding='utf-8') as f:
        for line in lines:
            f.write(str(line) + "\n")


def backup_file(path: str):
    bak = path + ".bak"
    if not os.path.exists(bak):
        with open(path, 'rb') as src, open(bak, 'wb') as dst:
            dst.write(src.read())


def find_index_before_file_closing_brace(lines: List[str]) -> int:
    """Return index of the last '}' (file-closing brace) to insert before it.
    If none is found, append to end.
    """
    for i in range(len(lines) - 1, -1, -1):
        if '}' in lines[i]:
            return i
    return len(lines)


def normalize_exts(single_ext: str, multi_exts: List[str]) -> List[str]:
    if multi_exts:
        exts = multi_exts
    else:
        exts = [single_ext or '.tga']
    out = []
    for e in exts:
        if not e:
            continue
        e = e.lower()
        if not e.startswith('.'):
            e = '.' + e
        out.append(e)
    seen: Set[str] = set()
    ordered: List[str] = []
    for e in out:
        if e not in seen:
            seen.add(e)
            ordered.append(e)
    return ordered or ['.tga']


def make_texture_path(icon: str, ext: str, base_subdir: str, relative_subdir: str) -> str:
    parts = [p for p in [base_subdir.strip('/\\') if base_subdir else '',
                         relative_subdir.strip('/\\') if relative_subdir else ''] if p]
    sub = ('/'.join(parts) + '/') if parts else ''
    return f"gfx/interface/goals/{sub}{icon}{ext}"


def has_sprite_named(file_text: str, sprite_name: str) -> bool:
    needle = f'"{sprite_name}"'
    return needle in file_text


def build_goals_block(icon: str, texture_path: str) -> List[str]:
    return [
        "\tSpriteType = {",
        f"\t\tname = \"GFX_{icon}\"",
        f"\t\ttexturefile = \"{texture_path}\"",
        "\t}"
    ]


def build_shine_block(icon: str, texture_path: str) -> List[str]:
    anim_common_top = [
        "\t\tanimationtexturescale = { x = 1.0 y = 1.0 } ",
        "\t\tanimationrotationoffset = { x = 0.0 y = 0.0 }",
        "\t\tanimationtype = \"scrolling\"      #scrolling, rotating, pulsing",
        "\t\tanimationblendmode = \"add\"       #add, multiply, overlay",
        "\t\tanimationdelay = 0\t\t\t# in seconds",
        "\t\tanimationtime = 0.75\t\t\t\t# in seconds",
        "\t\tanimationlooping = no\t\t\t# yes or no ;)",
        "\t\tanimationtexturefile = \"gfx/interface/goals/shine_overlay.dds\" \t# <- the animated file",
        f"\t\tanimationmaskfile = \"{texture_path}\"",
    ]

    block = [
        "\tSpriteType = {",
        f"\t\tname = \"GFX_{icon}_shine\"",
        f"\t\ttexturefile = \"{texture_path}\"",
        "\t\teffectFile = \"gfx/FX/buttonstate.lua\"",
        "\t\tanimation = {",
        *anim_common_top,
        "\t\t\tanimationrotation = -90.0\t\t# -90 clockwise 90 counterclockwise(by default)",
        "\t\t}",
        "\t\tanimation = {",
        *anim_common_top,
        "\t\t\tanimationrotation = 90.0\t\t# -90 clockwise 90 counterclockwise(by default)",
        "\t\t}",
        "\t\tlegacy_lazy_load = no",
        "\t}"
    ]
    return block


def insert_block(lines: List[str], block: List[str]) -> List[str]:
    idx = find_index_before_file_closing_brace(lines)
    return lines[:idx] + block + lines[idx:]

# ----------------------- Scanning -----------------------

def iter_icon_files(icons_dir: str, exts: List[str], recurse: bool) -> Iterable[Tuple[str, str, str]]:
    """
    Yield tuples of (icon_name, extension, relative_subdir) for files in icons_dir
    that match allowed extensions. relative_subdir is the directory under icons_dir
    where the file resides ('' for top level).
    """
    if not icons_dir:
        return []

    icons_dir = os.path.abspath(icons_dir)

    def handle_dir(dirpath: str, filenames: List[str]):
        rel = os.path.relpath(dirpath, icons_dir)
        relative_subdir = '' if rel == '.' else rel.replace('\\', '/')
        for fn in filenames:
            base, ext = os.path.splitext(fn)
            if ext.lower() in exts:
                yield base, ext.lower(), relative_subdir

    if recurse:
        for dirpath, _dirs, files in os.walk(icons_dir):
            yield from handle_dir(dirpath, files)
    else:
        yield from handle_dir(icons_dir, os.listdir(icons_dir))

# ----------------------- Main -----------------------

def main():
    parser = argparse.ArgumentParser(
        description='Add HoI4 focus icon SpriteType entries to goals and goals_shine .gfx files.'
    )
    parser.add_argument('icon_names', nargs='*', help='Optional: one or more icon names (without extension). Can be combined with --icons-dir')
    parser.add_argument('-d', '--directory', '-d--directory', dest='directory', default=os.getcwd(), type=readable_dir,
                        help='Directory to look for .gfx files in (default: working directory)')
    parser.add_argument('--goals', default='goals.gfx', help='Goals file name (default: goals.gfx)')
    parser.add_argument('--goals_shine', default='goals_shine.gfx', help='Goals shine file name (default: goals_shine.gfx)')

    # Icon discovery
    parser.add_argument('--icons-dir', type=readable_dir, help='Folder to scan for icon files (e.g., gfx/interface/goals/NCG)')
    parser.add_argument('--recurse', action='store_true', help='Recurse into subfolders under --icons-dir')
    parser.add_argument('--ext', default='.tga', help='Single icon extension (default: .tga). Ignored if --exts is provided')
    parser.add_argument('--exts', nargs='+', default=None, help='Multiple allowed extensions, e.g. --exts .tga .dds')
    parser.add_argument('--subdir', default='', help='Base subfolder under gfx/interface/goals (e.g., NCG) appended before any relative subfolders from --icons-dir')

    # Safety
    parser.add_argument('--backup', action='store_true', help='Create .bak backups of the target files before writing')
    parser.add_argument('--dry-run', action='store_true', help="Parse and report changes, but don't write files")

    args = parser.parse_args()

    dirpath = args.directory
    goals_path = os.path.join(dirpath, args.goals)
    shine_path = os.path.join(dirpath, args.goals_shine)

    # Validate presence
    if not os.path.isfile(goals_path):
        sys.exit(f"Missing goals file: {goals_path}")
    if not os.path.isfile(shine_path):
        sys.exit(f"Missing goals_shine file: {shine_path}")

    # Prepare extension list
    exts = normalize_exts(args.ext, args.exts)

    # Read once for duplicate detection
    goals_lines = read_lines(goals_path)
    shine_lines = read_lines(shine_path)
    goals_text = "\n".join(goals_lines)
    shine_text = "\n".join(shine_lines)

    # Collect requested icons
    pending: List[Tuple[str, str, str]] = []  # (icon_name, ext, relative_subdir)
    for name in args.icon_names:
        # When user lists names manually, choose the first extension from exts
        pending.append((name, exts[0], ''))

    # Add from directory scan, if any
    if args.icons_dir:
        for icon_name, ext, rel_sub in iter_icon_files(args.icons_dir, exts, args.recurse):
            pending.append((icon_name, ext, rel_sub))

    # If nothing collected, stop
    if not pending:
        sys.exit("No icons specified. Provide names positionally and/or use --icons-dir.")

    # Unduplicate icon + subdir pairs
    seen_keys: Set[Tuple[str, str]] = set()
    unique_pending: List[Tuple[str, str, str]] = []
    for icon_name, ext, rel_sub in pending:
        key = (icon_name, rel_sub)
        if key not in seen_keys:
            seen_keys.add(key)
            unique_pending.append((icon_name, ext, rel_sub))

    added_any = False

    for icon, ext, rel_sub in unique_pending:
        texture_path = make_texture_path(icon, ext, args.subdir, rel_sub)
        name_main = f"GFX_{icon}"
        name_shine = f"GFX_{icon}_shine"

        # Duplikate detection
        exists_main = has_sprite_named(goals_text, name_main)
        exists_shine = has_sprite_named(shine_text, name_shine)

        if exists_main:
            print(f"[SKIP] {name_main} already present in {args.goals}")
        else:
            block = build_goals_block(icon, texture_path)
            goals_lines = insert_block(goals_lines, block)
            goals_text += f"\nname = \"{name_main}\"\n"
            print(f"[ADD ] {name_main} -> {args.goals} ({texture_path})")
            added_any = True

        if exists_shine:
            print(f"[SKIP] {name_shine} already present in {args.goals_shine}")
        else:
            block = build_shine_block(icon, texture_path)
            shine_lines = insert_block(shine_lines, block)
            shine_text += f"\nname = \"{name_shine}\"\n"
            print(f"[ADD ] {name_shine} -> {args.goals_shine} ({texture_path})")
            added_any = True

    if args.dry_run:
        print("\nDry run complete — no files written.")
        return

    if args.backup and added_any:
        backup_file(goals_path)
        backup_file(shine_path)

    if added_any:
        write_lines(goals_path, goals_lines)
        write_lines(shine_path, shine_lines)
        print("\nDone.")
    else:
        print("\nNothing to do — all requested entries already exist.")


if __name__ == '__main__':
    main()
