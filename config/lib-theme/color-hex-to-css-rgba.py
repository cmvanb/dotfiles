#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Convert a hexadecimal color code (000000 -> ffffff) to a CSS RGBA expression.
#-------------------------------------------------------------------------------

import argparse
from color_utils import hex_color, float_range

def main():
    parser = argparse.ArgumentParser(
        description='Convert a hexadecimal color to a CSS RGBA expression with the provided alpha value.')
    parser.add_argument('--color', type=hex_color(), help='Hexadecimal color value (000000 -> ffffff)')
    parser.add_argument('--alpha', type=float_range(0.0, 1.0), help='Alpha value (0.0 -> 1.0)')

    args = parser.parse_args()

    print(args.color.to_css_rgba(args.alpha))

if __name__ == '__main__':
    main()
