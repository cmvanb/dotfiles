#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Generate color gradient palette
#-------------------------------------------------------------------------------

import argparse
import sys
import math
import re

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

def _linearize(c):
    """Convert an sRGB channel (0..1) to linear light for WCAG luminance."""
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

def _relative_luminance(r, g, b):
    """WCAG 2.1 relative luminance from sRGB 0..255 components."""
    rl = _linearize(r / 255)
    gl = _linearize(g / 255)
    bl = _linearize(b / 255)
    return 0.2126 * rl + 0.7152 * gl + 0.0722 * bl

class Color():
    def __init__(self, r, g, b):
        self.r = int(r)
        self.g = int(g)
        self.b = int(b)

    def __str__(self):
        return f'{self.r}, {self.g}, {self.b}'

    def escape_fg(self):
        """Pick black or white foreground for maximum contrast (WCAG luminance)."""
        lum = _relative_luminance(self.r, self.g, self.b)
        # Contrast ratio against white = (1 + 0.05) / (lum + 0.05)
        # Contrast ratio against black = (lum + 0.05) / (0 + 0.05)
        # Choose whichever gives higher contrast.
        contrast_white = 1.05 / (lum + 0.05)
        contrast_black = (lum + 0.05) / 0.05
        if contrast_white >= contrast_black:
            return '\x1b[38:2:255:255:255m'
        else:
            return '\x1b[38:2:0:0:0m'

    def escape_bg(self):
        return f'\x1b[48:2:{self.r}:{self.g}:{self.b}m'

    @staticmethod
    def escape_reset():
        return '\x1b[0m'

    def terminal_output(self):
        return f'{self.escape_bg()}        {self.escape_fg()}#{self.r:02x}{self.g:02x}{self.b:02x}{Color.escape_reset()}'

    def lerp(self, other, t):
        """Linearly interpolate between this color and another at position t (0..1)."""
        return Color(
            interp(self.r, other.r, t),
            interp(self.g, other.g, t),
            interp(self.b, other.b, t),
        )

    @staticmethod
    def parse(argument):
        if not argument:
            raise ValueError('Color cannot be an empty string.')
        if not re.fullmatch(r'#[0-9a-fA-F]{6}', argument):
            raise ValueError(
                f'Invalid color {argument!r}: expected format #RRGGBB with hex digits.'
            )
        return Color(int(argument[1:3], 16), int(argument[3:5], 16), int(argument[5:7], 16))

def ease_in(t):
    """Quadratic ease-in: slow start, fast end."""
    return t * t

def ease_out(t):
    """Quadratic ease-out: fast start, slow end."""
    return t * (2 - t)

def ease_in_out(t):
    """Quadratic ease-in-out: slow at both ends."""
    return 2 * t * t if t < 0.5 else -1 + (4 - 2 * t) * t

def smoothstep(t):
    """Cubic Hermite: slow at both ends, less compression in the middle than ease-in-out."""
    return t * t * (3 - 2 * t)

CURVES = {
    'linear':       lambda t: t,
    'ease-in':      ease_in,
    'ease-out':     ease_out,
    'ease-in-out':  ease_in_out,
    'smoothstep':   smoothstep,
}

def interp(start, end, percentage):
    return start + ((end - start) * percentage)

def main():
    startColor = None
    middleColor = None
    endColor = None

    parser = argparse.ArgumentParser(description='Generate color gradient palette')
    parser.add_argument('--samples',  required=True,  type=int, help='Number of colors to sample along the gradient (minimum 2).')
    parser.add_argument('--start',    required=True,  help='The start of the gradient. Hexadecimal color in the format #RRGGBB.')
    parser.add_argument('--end',      required=True,  help='The end of the gradient. Hexadecimal color in the format #RRGGBB.')
    parser.add_argument('--middle',   required=False, help='The middle of the gradient, this is optional. Hexadecimal color in the format #RRGGBB.')
    parser.add_argument('--midpoint', required=False, type=float_range(0.0, 1.0), help='Decimal in the range 0.0 to 1.0 representing the position of the middle color.')
    parser.add_argument('--curve',    required=False, default='linear', choices=list(CURVES.keys()), help='Interpolation curve. One of: linear (default), ease-in, ease-out, ease-in-out, smoothstep.')

    try:
        args = parser.parse_args()

        if args.samples < 2:
            raise ValueError('--samples must be at least 2.')

        startColor = Color.parse(args.start)
        endColor = Color.parse(args.end)
        if args.middle is not None:
            middleColor = Color.parse(args.middle)

    except Exception as ex:
        print(f'Error: {ex}')
        sys.exit(1)

    maxIndex = args.samples - 1
    curve = CURVES[args.curve]

    if middleColor is not None:
        midPoint = 0.5 if args.midpoint is None else args.midpoint

        if midPoint <= 0.0 or midPoint >= 1.0:
            print('Error: --midpoint must be strictly between 0.0 and 1.0 when --middle is used.')
            sys.exit(1)

        # Sample the colors to the left and right of the midpoint.
        midLeftIndex = math.floor(midPoint * maxIndex)
        endPointA = curve((midLeftIndex / maxIndex) / midPoint)
        endColorA = startColor.lerp(middleColor, endPointA)
        midRightIndex = math.ceil(midPoint * maxIndex)
        startPointB = curve(((midRightIndex / maxIndex) - midPoint) / (1.0 - midPoint))
        startColorB = middleColor.lerp(endColor, startPointB)

        # Then we can correctly sample the remaining colors.
        palette = []
        for index in range(0, args.samples):
            samplePercentage = index / maxIndex
            if samplePercentage < midPoint:
                subSamplePercentage = curve(samplePercentage / midPoint)
                palette.append(startColor.lerp(endColorA, subSamplePercentage))
            else:
                subSamplePercentage = curve((samplePercentage - midPoint) / (1.0 - midPoint))
                palette.append(startColorB.lerp(endColor, subSamplePercentage))

    else:
        palette = []
        for index in range(0, args.samples):
            palette.append(startColor.lerp(endColor, curve(index / maxIndex)))

    for color in palette:
        print(color.terminal_output())

if __name__ == '__main__':
    main()
