#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["fonttools"]
# ///
#-------------------------------------------------------------------------------
# Generate Nimbus Sans with vertical metrics that Chromium centers
#-------------------------------------------------------------------------------

import argparse
from pathlib import Path

from fontTools.ttLib import TTFont

SOURCE_DIR = Path("/usr/share/fonts/gsfonts")
STYLES = ["Regular", "Bold", "Italic", "BoldItalic"]
FAMILY = "Nimbus Sans"
UI_FAMILY = "Nimbus Sans Chromium"

# Chromium centers the cap height when the line box leaves room for it.
# Nimbus Sans has a 1em line box, so its text sits high. This value was
# measured to align tab titles with the tab icons and to center the omnibox
# text at the UI scale in chromium-flags.conf.
LINE_HEIGHT = 1.2


def generate(source, dest):
    font = TTFont(source)
    upm = font["head"].unitsPerEm
    hhea, os2 = font["hhea"], font["OS/2"]

    height = round(LINE_HEIGHT * upm)
    ascent = (height + os2.sCapHeight) // 2
    descent = height - ascent

    hhea.ascent, hhea.descent, hhea.lineGap = ascent, -descent, 0
    os2.sTypoAscender, os2.sTypoDescender, os2.sTypoLineGap = ascent, -descent, 0
    os2.usWinAscent, os2.usWinDescent = ascent, descent
    os2.sCapHeight = round(os2.sCapHeight * 1.36)

    for record in font["name"].names:
        text = record.toUnicode()
        if record.nameID == 6:
            text = text.replace(FAMILY.replace(" ", ""), UI_FAMILY.replace(" ", ""))
        else:
            text = text.replace(FAMILY, UI_FAMILY)
        record.string = text

    font.save(dest)


def main():
    parser = argparse.ArgumentParser(description="Generate Nimbus Sans with vertical metrics that Chromium centers")
    parser.add_argument("dest", type=Path, help="output directory")
    args = parser.parse_args()

    args.dest.mkdir(parents=True, exist_ok=True)
    for style in STYLES:
        generate(SOURCE_DIR / f"NimbusSans-{style}.otf", args.dest / f"NimbusSansChromium-{style}.otf")


if __name__ == "__main__":
    main()
