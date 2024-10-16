#-------------------------------------------------------------------------------
# Color utilities
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

    def to_rgb_int(self):
        return f'{self.r},{self.g},{self.b}'
