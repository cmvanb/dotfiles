#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Convert a hexadecimal color code (000000 -> ffffff) to an RGB integer tuple.
#-------------------------------------------------------------------------------

import argparse
from color_utils import hex_color

def main():
    parser = argparse.ArgumentParser(
        description='Convert a hexadecimal color to an RGB integer tuple.')
    parser.add_argument('--color', type=hex_color(), help='Hexadecimal color value (000000 -> ffffff)')

    args = parser.parse_args()

    print(args.color.to_rgb_int())

if __name__ == '__main__':
    main()
