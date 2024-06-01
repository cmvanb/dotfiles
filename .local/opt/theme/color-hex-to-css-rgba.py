#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Convert a hexadecimal color code (000000 -> ffffff) to a CSS RGBA expression.
#-------------------------------------------------------------------------------

import argparse

def float_range(minimum, maximum):
    def float_range_checker(arg):
        try:
            f = float(arg)
        except ValueError:
            raise argparse.ArgumentTypeError('Must be a floating point number.')
        if f < minimum or f > maximum:
            raise argparse.ArgumentTypeError(f'Must be in range ({str(minimum)} .. {str(maximum)}).')
        return f

    return float_range_checker

def hex_color():
    def hex_color_checker(arg):
        if len(arg) != 6:
            raise argparse.ArgumentTypeError('Hexadecimal value must be 6 chars.')
        try:
            _ = int(arg, 16)
        except ValueError:
            raise argparse.ArgumentTypeError('Must be a hexadecimal value.')

        return Color(arg)

    return hex_color_checker

class Color():
    def __init__(self, hex):
        self.hex = hex
        self.r = int(hex[0:2], 16)
        self.g = int(hex[2:4], 16)
        self.b = int(hex[4:6], 16)

    def to_css_rgba(self, alpha):
        return f'rgba({self.r}, {self.g}, {self.b}, {alpha})'

def main():
    parser = argparse.ArgumentParser(
        description='Convert a hexadecimal color to a CSS RGBA expression with the provided alpha value.')
    parser.add_argument('--color', type=hex_color(), help='Hexadecimal color value (000000 -> ffffff)')
    parser.add_argument('--alpha', type=float_range(0.0, 1.0), help='Alpha value (0.0 -> 1.0)')

    args = parser.parse_args()

    print(args.color.to_css_rgba(args.alpha))

if __name__ == '__main__':
    main()
