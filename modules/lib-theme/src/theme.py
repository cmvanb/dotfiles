#-------------------------------------------------------------------------------
# System theme Python API
#-------------------------------------------------------------------------------

import os
import sys
import yaml
from pathlib import Path
from color_utils import Color


CONFIG_DIR = Path(os.path.expandvars('$XDG_CONFIG_HOME/theme'))
CACHE_DIR  = Path(os.path.expandvars('$XDG_CACHE_HOME/theme'))
LUA_PATH   = CACHE_DIR / 'theme-data.lua'
SH_PATH    = CACHE_DIR / 'theme-data.sh'
FISH_PATH  = CACHE_DIR / 'theme-data.fish'

COLORS_PATH = CONFIG_DIR / 'colors.yaml'
FONTS_PATH  = CONFIG_DIR / 'fonts.yaml'
CURSOR_PATH = CONFIG_DIR / 'cursor.yaml'


# Utilities
#-------------------------------------------------------------------------------

def _is_readable_file(path: Path) -> bool:
    return path.is_file() and os.access(path, os.R_OK)

def _raise(message: str) -> None:
    raise Exception(f'[theme.py] {message}')


# Parsing
#-------------------------------------------------------------------------------

def _parse_one(path: Path) -> tuple[dict, dict, dict]:
    if not _is_readable_file(path):
        _raise(f'`{path}` is not readable.')

    with open(path, 'r') as f:
        data = yaml.safe_load(f.read())

    colors  = { k: Color(str(v)) for k, v in data.get('colors', {}).items() }
    fonts   = { k: str(v)        for k, v in data.get('fonts', {}).items() }
    cursor  = { k: str(v)        for k, v in data.get('cursor', {}).items() }

    return colors, fonts, cursor

def _parse(*paths: Path) -> tuple[dict, dict, dict]:
    colors, fonts, cursor = {}, {}, {}
    for path in paths:
        c, f, cu = _parse_one(path)
        colors.update(c)
        fonts.update(f)
        cursor.update(cu)
    return colors, fonts, cursor


# Cache generation
#-------------------------------------------------------------------------------

def _write_lua(colors: dict, fonts: dict, cursor: dict):
    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    lines = ['return {\n']

    lines.append('  colors = {\n')
    for k, v in colors.items():
        lines.append(f'    {k} = "{v.as_hex()}",\n')
    lines.append('  },\n')

    lines.append('  fonts = {\n')
    for k, v in fonts.items():
        lines.append(f'    {k} = "{v}",\n')
    lines.append('  },\n')

    lines.append('  cursor = {\n')
    for k, v in cursor.items():
        lines.append(f'    {k} = "{v}",\n')
    lines.append('  },\n')

    lines.append('}\n')

    with open(LUA_PATH, 'w') as f:
        f.writelines(lines)


def _write_sh(colors: dict, fonts: dict, cursor: dict):
    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    lines = []
    for k, v in colors.items():
        lines.append(f"{k}='{v.as_hex()}'\n")
    for k, v in fonts.items():
        lines.append(f"{k}='{v}'\n")
    for k, v in cursor.items():
        lines.append(f"{k}='{v}'\n")

    with open(SH_PATH, 'w') as f:
        f.writelines(lines)


def _write_fish(colors: dict, fonts: dict, cursor: dict):
    CACHE_DIR.mkdir(parents=True, exist_ok=True)

    lines = []
    for k, v in colors.items():
        lines.append(f"set -g {k} '{v.as_hex()}'\n")
    for k, v in fonts.items():
        lines.append(f"set -g {k} '{v}'\n")
    for k, v in cursor.items():
        lines.append(f"set -g {k} '{v}'\n")

    with open(FISH_PATH, 'w') as f:
        f.writelines(lines)


# Entry point
#-------------------------------------------------------------------------------

_colors, _fonts, _cursor = _parse(COLORS_PATH, FONTS_PATH, CURSOR_PATH)


def parse(*paths: Path):
    colors, fonts, cursor = _parse(*paths)
    _write_lua(colors, fonts, cursor)
    _write_sh(colors, fonts, cursor)
    _write_fish(colors, fonts, cursor)


# Lookup API
#-------------------------------------------------------------------------------

def _get_color(name: str) -> Color:
    if name not in _colors:
        _raise(f'Color `{name}` not found in theme.')
    return _colors[name]

def _get_font(name: str) -> str:
    if name not in _fonts:
        _raise(f'Font `{name}` not found in theme.')
    return _fonts[name]

def _get_cursor(name: str) -> str:
    if name not in _cursor:
        _raise(f'Cursor `{name}` not found in theme.')
    return _cursor[name]


_PALETTE_OFFSETS = {
    'primary':   16,
    'secondary': 32,
    'text':      48,
    'gray':      64,
    'red':       80,
    'orange':    90,
    'yellow':    100,
    'green':     110,
    'cyan':      120,
    'blue':      130,
    'purple':    140,
    'magenta':   150,
}

_LARGE_PALETTES = {'primary', 'secondary', 'text', 'gray'}

_ANSI_INDICES = {
    'ansi_black':     0,
    'ansi_red':       1,
    'ansi_green':     2,
    'ansi_yellow':    3,
    'ansi_blue':      4,
    'ansi_magenta':   5,
    'ansi_cyan':      6,
    'ansi_white':     7,
    'ansi_brblack':   8,
    'ansi_brred':     9,
    'ansi_brgreen':   10,
    'ansi_bryellow':  11,
    'ansi_brblue':    12,
    'ansi_brmagenta': 13,
    'ansi_brcyan':    14,
    'ansi_brwhite':   15,
}


def color_named(name: str) -> str:
    return _get_color(name).as_hex()

def color_hash(name: str) -> str:
    return _get_color(name).with_hash()

def color_zerox(name: str) -> str:
    return _get_color(name).with_zerox()

def color_css_rgba(name: str, alpha: float) -> str:
    return _get_color(name).as_css_rgba(alpha)

def color_css_rgba_hex(hex: str, alpha: float) -> str:
    return Color(hex).as_css_rgba(alpha)

def color_rgb_int(name: str) -> str:
    return _get_color(name).as_rgb_int()

def color_rgb_int_hex(hex: str) -> str:
    return Color(hex).as_rgb_int()

def color_ansi_fg(name: str) -> str:
    c = _get_color(name)
    return f'\x1b[38:2:{c.r}:{c.g}:{c.b}m'

def color_ansi_fg_hex(hex: str) -> str:
    c = Color(hex)
    return f'\x1b[38:2:{c.r}:{c.g}:{c.b}m'

def color_ansi_bg(name: str) -> str:
    c = _get_color(name)
    return f'\x1b[48:2:{c.r}:{c.g}:{c.b}m'

def color_ansi_bg_hex(hex: str) -> str:
    c = Color(hex)
    return f'\x1b[48:2:{c.r}:{c.g}:{c.b}m'

def color_ansi(fg_name: str, bg_name: str) -> str:
    return color_ansi_fg(fg_name) + color_ansi_bg(bg_name)

def color_ansi_hex(fg_hex: str, bg_hex: str) -> str:
    return color_ansi_fg_hex(fg_hex) + color_ansi_bg_hex(bg_hex)

def color_ansi_reset() -> str:
    return '\x1b[0m'

def color_256(name: str) -> int:
    if name in _ANSI_INDICES:
        return _ANSI_INDICES[name]

    parts = name.rsplit('_', 1)
    if len(parts) == 2:
        palette, index_str = parts
        if palette in _PALETTE_OFFSETS:
            try:
                index = int(index_str)
            except ValueError:
                pass
            else:
                limit = 15 if palette in _LARGE_PALETTES else 9
                if 0 <= index <= limit:
                    return _PALETTE_OFFSETS[palette] + index

    raise Exception(f'[theme.py] color_256: unknown color `{name}`')


def font(name: str) -> str:
    return _get_font(name)

def cursor(name: str) -> str:
    return _get_cursor(name)


# CLI
#-------------------------------------------------------------------------------

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print(f'Usage: theme.py <command> [args]', file=sys.stderr)
        print(f'Commands: parse, color_named, color_hash, color_zerox, color_css_rgba, color_css_rgba_hex, color_rgb_int, color_rgb_int_hex, color_256, color_ansi, color_ansi_hex, color_ansi_fg, color_ansi_fg_hex, color_ansi_bg, color_ansi_bg_hex, color_ansi_reset, font, cursor', file=sys.stderr)
        sys.exit(1)

    cmd = sys.argv[1]

    if cmd == 'parse':
        if len(sys.argv) < 3:
            print('Usage: theme.py parse <file1.yaml> [file2.yaml ...]', file=sys.stderr)
            sys.exit(1)
        parse(*[Path(p) for p in sys.argv[2:]])

    elif cmd == 'color_256':
        print(color_256(sys.argv[2]), end='')

    elif cmd == 'color_ansi':
        print(color_ansi(sys.argv[2], sys.argv[3]), end='')

    elif cmd == 'color_ansi_hex':
        print(color_ansi_hex(sys.argv[2], sys.argv[3]), end='')

    elif cmd == 'color_ansi_fg':
        print(color_ansi_fg(sys.argv[2]), end='')

    elif cmd == 'color_ansi_fg_hex':
        print(color_ansi_fg_hex(sys.argv[2]), end='')

    elif cmd == 'color_ansi_bg':
        print(color_ansi_bg(sys.argv[2]), end='')

    elif cmd == 'color_ansi_bg_hex':
        print(color_ansi_bg_hex(sys.argv[2]), end='')

    elif cmd == 'color_ansi_reset':
        print(color_ansi_reset(), end='')

    elif cmd == 'color_named':
        print(color_named(sys.argv[2]), end='')

    elif cmd == 'color_hash':
        print(color_hash(sys.argv[2]), end='')

    elif cmd == 'color_zerox':
        print(color_zerox(sys.argv[2]), end='')

    elif cmd == 'color_css_rgba':
        print(color_css_rgba(sys.argv[2], float(sys.argv[3])), end='')

    elif cmd == 'color_css_rgba_hex':
        print(color_css_rgba_hex(sys.argv[2], float(sys.argv[3])), end='')

    elif cmd == 'color_rgb_int':
        print(color_rgb_int(sys.argv[2]), end='')

    elif cmd == 'color_rgb_int_hex':
        print(color_rgb_int_hex(sys.argv[2]), end='')

    elif cmd == 'font':
        print(font(sys.argv[2]), end='')

    elif cmd == 'cursor':
        print(cursor(sys.argv[2]), end='')

    else:
        print(f'Unknown command: {cmd}', file=sys.stderr)
        sys.exit(1)
