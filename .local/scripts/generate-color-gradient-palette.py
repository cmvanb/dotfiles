#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Generate color gradient palette
#-------------------------------------------------------------------------------

import argparse
import sys
import math

# TODO: Extract to a module.
def float_range(minimum, maximum):
    # Return function handle of an argument type function for  ArgumentParser 
    # checking a float is in range: minimum <= arg <= maximum

    # Define the function with default arguments
    def float_range_checker(arg):
        # New Type function for argparse - a float within predefined range.
        try:
            f = float(arg)
        except ValueError:    
            raise argparse.ArgumentTypeError('Must be a floating point number.')
        if f < minimum or f > maximum:
            raise argparse.ArgumentTypeError(f'Must be in range ({str(minimum)} .. {str(maximum)}).')
        return f

    # Return function handle to checking function
    return float_range_checker

class Color():
    def __init__(self, r, g, b):
        self.r = int(r)
        self.b = int(b)
        self.g = int(g)

    def __str__(self):
        return f'{self.r}, {self.g}, {self.b}'

    # TODO: Find a better way to calculate a high contrast foreground color.
    # see: https://stackoverflow.com/questions/9733288/how-to-programmatically-calculate-the-contrast-ratio-between-two-colors
    # see: https://stackoverflow.com/questions/7260989/how-to-pick-good-contrast-rgb-colors-programmatically
    # see: https://contrast-ratio.com/
    def escape_fg(self):
        return f'\x1b[38:2:{255 - self.r}:{255 - self.g}:{255 - self.b}m'

    def escape_bg(self):
        return f'\x1b[48:2:{self.r}:{self.g}:{self.b}m'

    def escape_reset(self):
        return '\x1b[0m'

    def terminal_output(self):
        return f'{self.escape_bg()}{self.escape_fg()}#{self.r:02x}{self.g:02x}{self.b:02x}{self.escape_reset()}'

    @staticmethod
    def parse(argument):
        if not argument:
            raise ValueError(f'Color cannot be an empty string.')
        if len(argument) != 7 or argument[:1] != '#':
            raise ValueError(f'Color must be in the format #RRGGBB.')
        return Color(int(argument[1:3], 16), int(argument[3:5], 16), int(argument[5:7], 16))

def interp(start, end, percentage):
    return start + ((end - start) * percentage)

def interp_color(start, end, percentage):
    return Color(interp(start.r, end.r, percentage), interp(start.g, end.g, percentage), interp(start.b, end.b, percentage))

def main():
    startColor = None
    middleColor = None
    endColor = None

    parser = argparse.ArgumentParser(description='Generate color gradient palette')
    parser.add_argument('--samples',  required=True,  type=int, choices=range(2, 21), help='Number of colors to samples along the gradient.')
    parser.add_argument('--start',    required=True,  help='The start of the gradient. Hexadecimal color in the format #RRGGBB.')
    parser.add_argument('--end',      required=True,  help='The end of the gradient. Hexadecimal color in the format #RRGGBB.')
    parser.add_argument('--middle',   required=False, help='The middle of the gradient, this is optional. Hexadecimal color in the format #RRGGBB.')
    parser.add_argument('--midpoint', required=False, type=float_range(0.0, 1.0), help='Decimal in the range 0.0 to 1.0 representing the position of the middle color.')

    try:
        args = parser.parse_args()

        startColor = Color.parse(args.start)
        endColor = Color.parse(args.end)
        if args.middle is not None:
            middleColor = Color.parse(args.middle)

    except Exception as ex:
        print(f'Error: {ex}')
        sys.exit(1)

    maxIndex = args.samples - 1

    if middleColor is not None:
        midPoint = 0.5 if args.midpoint is None else args.midpoint

        # Sample the colors to the left and right of the midpoint.
        midLeftIndex = math.floor(midPoint * maxIndex)
        endPointA = (midLeftIndex / maxIndex) / midPoint
        endColorA = interp_color(startColor, middleColor, endPointA)
        midRightIndex = math.ceil(midPoint * maxIndex)
        startPointB = ((midRightIndex / maxIndex) - midPoint) / (1.0 - midPoint)
        startColorB = interp_color(middleColor, endColor, startPointB)

        # Then we can correctly sample the remaining colors.
        palette = []
        for index in range(0, args.samples):
            samplePercentage = index / maxIndex
            if samplePercentage < midPoint:
                subSamplePercentage = samplePercentage / midPoint
                palette.append(interp_color(startColor, endColorA, subSamplePercentage))
            else:
                subSamplePercentage = (samplePercentage - midPoint) / (1.0 - midPoint)
                palette.append(interp_color(startColorB, endColor, subSamplePercentage))

    else:
        palette = []
        for index in range(0, args.samples):
            palette.append(interp_color(startColor, endColor, index / maxIndex))

    for color in palette:
        print(f'{color.terminal_output()}')

if __name__ == '__main__':
    main()
