#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Generate a contrast-mirrored light palette from a dark color scheme
#
# Every palette step is indexed by its contrast against the canvas. Each light
# step is solved in OKLCH so its WCAG contrast against the light canvas matches
# its dark twin's contrast against the dark canvas. Consumers that reference
# steps by index therefore keep the same relationships in both schemes.
#
# Usage:
#   generate-contrast-mirror-palette.py <dark-scheme.yaml>
#
# Prints the palette section of the light scheme as YAML.
#-------------------------------------------------------------------------------

import argparse
import math
import re
import sys


# Color math
#-------------------------------------------------------------------------------

def _to_linear(c):
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

def _to_srgb(c):
    return 12.92 * c if c <= 0.0031308 else 1.055 * c ** (1 / 2.4) - 0.055

def _hex_to_rgb(h):
    h = h.lstrip('#')
    return [int(h[i:i + 2], 16) / 255 for i in (0, 2, 4)]

def _rgb_to_hex(rgb):
    return '#' + ''.join(f'{max(0, min(255, round(x * 255))):02x}' for x in rgb)

def luminance(h):
    r, g, b = [_to_linear(x) for x in _hex_to_rgb(h)]
    return 0.2126 * r + 0.7152 * g + 0.0722 * b

def contrast(a, b):
    la, lb = luminance(a), luminance(b)
    return (max(la, lb) + 0.05) / (min(la, lb) + 0.05)

def _rgb_to_oklab(rgb):
    r, g, b = [_to_linear(x) for x in rgb]
    l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b
    m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b
    s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b
    l, m, s = [math.copysign(abs(x) ** (1 / 3), x) for x in (l, m, s)]
    return (
        0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
        1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
        0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s,
    )

def _oklab_to_linear(L, a, b):
    l = (L + 0.3963377774 * a + 0.2158037573 * b) ** 3
    m = (L - 0.1055613458 * a - 0.0638541728 * b) ** 3
    s = (L - 0.0894841775 * a - 1.2914855480 * b) ** 3
    return (
        4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
        -1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
        -0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s,
    )

def hex_to_lch(h):
    L, a, b = _rgb_to_oklab(_hex_to_rgb(h))
    return L, math.hypot(a, b), math.degrees(math.atan2(b, a)) % 360

def lch_to_hex(L, C, H):
    """Convert OKLCH to hex, reducing chroma until the color fits sRGB."""
    def linear(c):
        return _oklab_to_linear(L, c * math.cos(math.radians(H)), c * math.sin(math.radians(H)))
    def in_gamut(rgb):
        return all(-1e-4 <= x <= 1 + 1e-4 for x in rgb)

    if not in_gamut(linear(C)):
        lo, hi = 0.0, C
        for _ in range(30):
            mid = (lo + hi) / 2
            if in_gamut(linear(mid)):
                lo = mid
            else:
                hi = mid
        C = lo
    return _rgb_to_hex([_to_srgb(max(0, min(1, x))) for x in linear(C)])

def solve_lightness(target_luminance, C, H):
    lo, hi = 0.0, 1.0
    for _ in range(40):
        mid = (lo + hi) / 2
        if luminance(lch_to_hex(mid, C, H)) < target_luminance:
            lo = mid
        else:
            hi = mid
    return (lo + hi) / 2


# Design parameters
#-------------------------------------------------------------------------------

# Cream paper canvas (OKLCH).
CANVAS_LCH = (0.985, 0.017, 82)

# Contrast boost for bright rooms: dark contrast is raised to this power.
BOOST = 1.10

# Accents compress toward this log-contrast ceiling so high steps keep their hue.
ACCENT_CEILING = 2.5
YELLOW_CEILING = 1.75
ACCENT_MIN_STEP = 1.13


def _t(i, n):
    return i / (n - 1)


# Solver
#-------------------------------------------------------------------------------

class Solver:
    def __init__(self, dark: dict[str, str]):
        self.dark = dark
        self.dark_canvas = dark['canvas']
        self.canvas = lch_to_hex(*CANVAS_LCH)
        self.canvas_lum = luminance(self.canvas)
        L, C, H = CANVAS_LCH
        self.canvas_ab = (C * math.cos(math.radians(H)), C * math.sin(math.radians(H)))

    def _target_luminance(self, c):
        return (self.canvas_lum + 0.05) / c - 0.05

    def _dark_contrast(self, key):
        return contrast(self.dark[key], self.dark_canvas)

    def _base_curve(self, boost):
        """Mirror contrast, softly compressing the top end below the canvas maximum."""
        ceiling = (self.canvas_lum + 0.05) / 0.05 - 0.6
        knee = 10.0
        def curve(c):
            c = c ** boost
            if c < knee:
                return c
            return knee + (ceiling - knee) * (1 - math.exp(-(c - knee) / (ceiling - knee)))
        return curve

    @staticmethod
    def _accent_curve(ceiling):
        def curve(c):
            c = c ** BOOST
            return math.exp(ceiling * math.tanh(math.log(c) / ceiling))
        return curve

    def _tint(self, C, H, i, n):
        """Blend near-canvas steps toward the canvas tint so surfaces sit on the paper."""
        w = max(0, 1 - i / (n * 0.45)) ** 2
        ca, cb = self.canvas_ab
        a = C * math.cos(math.radians(H)) * (1 - w) + ca * w * 1.6
        b = C * math.sin(math.radians(H)) * (1 - w) + cb * w * 1.6
        return math.hypot(a, b), math.degrees(math.atan2(b, a)) % 360

    def base_scale(self, name, hue, chroma, boost=BOOST):
        curve = self._base_curve(boost)
        out = []
        for i in range(16):
            c = curve(self._dark_contrast(f'{name}_{i}'))
            C, H = self._tint(chroma(i), hue(i), i, 16)
            out.append(lch_to_hex(solve_lightness(self._target_luminance(c), C, H), C, H))
        return out

    def accent_scale(self, name, hue_clamp=lambda h: h, ceiling=ACCENT_CEILING):
        curve = self._accent_curve(ceiling)
        out, previous = [], None
        for i in range(10):
            key = f'{name}_{i}'
            c = curve(self._dark_contrast(key))
            if previous is not None:
                c = max(c, previous * ACCENT_MIN_STEP)
            previous = c
            _, C, H = hex_to_lch(self.dark[key])
            H = hue_clamp(H)
            if self._dark_contrast(key) < 1.7:
                C *= 0.55  # tints near the canvas stay calm instead of candy
            out.append(lch_to_hex(solve_lightness(self._target_luminance(c), C, H), C, H))
        return out

    def solve(self) -> dict[str, list[str]]:
        t = _t
        return {
            'primary':   self.base_scale('primary', lambda i: 262, lambda i: 0.006 + 0.16 * t(i, 16) ** 1.3),
            'secondary': self.base_scale('secondary', lambda i: 262, lambda i: 0.004 + 0.056 * t(i, 16) ** 1.3),
            'text':      self.base_scale(
                'text',
                lambda i: 60 - 35 * t(i, 16),
                lambda i: 0.015 + 0.02 * math.sin(math.pi * min(1, t(i, 16) * 1.4)) if t(i, 16) < 0.7 else 0.03,
                boost=1.0,
            ),
            'gray':      self.base_scale('gray', lambda i: 258, lambda i: 0.008 + 0.022 * t(i, 16)),
            'red':       self.accent_scale('red'),
            'orange':    self.accent_scale('orange', lambda h: min(h, 62)),
            'yellow':    self.accent_scale('yellow', lambda h: min(h, 88), ceiling=YELLOW_CEILING),
            'green':     self.accent_scale('green', lambda h: max(h, 142)),
            'cyan':      self.accent_scale('cyan', lambda h: max(min(h, 200), 180)),
            'blue':      self.accent_scale('blue'),
            'purple':    self.accent_scale('purple'),
            'magenta':   self.accent_scale('magenta'),
        }


# Entry point
#-------------------------------------------------------------------------------

def _load_colors(path) -> dict[str, str]:
    colors = {}
    with open(path) as f:
        for line in f:
            m = re.match(r'\s+(\w+):\s+&\w+\s+"(#[0-9a-fA-F]{6})"', line)
            if m:
                colors[m[1]] = m[2].lower()
    return colors

def main():
    parser = argparse.ArgumentParser(description='Generate a contrast-mirrored light palette.')
    parser.add_argument('dark', help='Dark scheme YAML file.')
    args = parser.parse_args()

    solver = Solver(_load_colors(args.dark))
    scales = solver.solve()

    print(f'  canvas: &canvas "{solver.canvas}"')
    for name, steps in scales.items():
        print()
        for i, h in enumerate(steps):
            key = f'{name}_{i}'
            print(f'  {key + ":":<14}&{key:<13}"{h}"')

if __name__ == '__main__':
    sys.exit(main())
