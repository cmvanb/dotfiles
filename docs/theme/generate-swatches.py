#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.12"
# dependencies = ["pyyaml"]
# ///
"""Render palette swatch strips for docs/theme.md.

Usage: generate-swatches.py

Writes one SVG per palette and scheme next to this script, then prints the
markdown table that embeds them.
"""
import re
from pathlib import Path

import yaml

HERE = Path(__file__).resolve().parent
SOURCES = HERE.parents[1] / 'modules/theme-base/src'
SCHEMES = ['carbon-dark', 'carbon-light']

SIZE = 16
GAP = 2
PAD = 3
SLOTS = 16
STEP = re.compile(r'(.+)_(\d+)$')


def palettes(colors):
    rows = {'canvas': [colors['canvas']]}
    for key, value in colors.items():
        match = STEP.match(key)
        if match and (match[1] in rows or match[2] == '0'):
            rows.setdefault(match[1], []).append(value)
    ansi = [v for k, v in colors.items() if k.startswith('ansi_')]
    rows['ansi'] = ansi[:8]
    rows['ansi_br'] = ansi[8:]
    return rows


def strip_width(count):
    return 2 * PAD + count * SIZE + (count - 1) * GAP


# Every strip has the full width, so a scaled table scales all squares alike.
def svg(canvas, steps):
    width = strip_width(SLOTS)
    height = 2 * PAD + SIZE
    cells = ''.join(
        f'<rect x="{PAD + i * (SIZE + GAP)}" y="{PAD}" width="{SIZE}" height="{SIZE}" fill="{c}"/>'
        for i, c in enumerate(steps)
    )
    return (
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}">'
        f'<rect width="{strip_width(len(steps))}" height="{height}" fill="{canvas}"/>{cells}</svg>\n'
    )


def main():
    for old in HERE.glob('*.svg'):
        old.unlink()

    names = None
    for scheme in SCHEMES:
        colors = yaml.safe_load((SOURCES / f'{scheme}.yaml').read_text())['colors']
        rows = palettes(colors)
        names = names or list(rows)
        for name, steps in rows.items():
            (HERE / f'{scheme}-{name}.svg').write_text(svg(colors['canvas'], steps))

    print('| Palette | ' + ' | '.join(SCHEMES) + ' |')
    print('|---' * (len(SCHEMES) + 1) + '|')
    for name in names:
        cells = ' | '.join(f'![{name} {s}](theme/{s}-{name}.svg)' for s in SCHEMES)
        print(f'| `{name}` | {cells} |')


if __name__ == '__main__':
    main()
