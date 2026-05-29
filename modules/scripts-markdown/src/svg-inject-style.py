#!/usr/bin/env python3
"""Inject style="color-scheme: only light" into every SVG element from stdin.

Handles both inline <svg> elements and base64-encoded SVGs in
<img src="data:image/svg+xml;base64,..."> attributes.
"""

import base64
import re
import sys

_SVG_TAG_RE = re.compile(r'<svg(?:[^>]|"[^"]*"|\'[^\']*\')*>')
_B64_SVG_RE = re.compile(r'src="data:image/svg\+xml;base64,([^"]+)"')
_IMG_TAG_RE = re.compile(r'<img(?:[^>]|"[^"]*"|\'[^\']*\')*/?>')
_ALT_RE = re.compile(r'\balt="([^"]*)"')
_TITLE_ATTR_RE = re.compile(r'\btitle=')


def _inject(m: re.Match) -> str:
    tag = m.group(0)
    if " style=" in tag:
        i = tag.index(" style=") + 8  # points to first char of value
        j = tag.index(tag[i - 1], i)  # closing quote
        existing = tag[i:j].rstrip("; ")
        return tag[:i] + existing + "; color-scheme: only light" + tag[j:]
    return "<svg" + ' style="color-scheme: only light"' + tag[4:]


def _inject_into_svg_source(svg: str) -> str:
    return _SVG_TAG_RE.sub(_inject, svg)


def _replace_b64(m: re.Match) -> str:
    try:
        svg = base64.b64decode(m.group(1)).decode("utf-8")
        svg = _inject_into_svg_source(svg)
        encoded = base64.b64encode(svg.encode("utf-8")).decode("ascii")
        return f'src="data:image/svg+xml;base64,{encoded}"'
    except Exception:
        return m.group(0)


def _add_title_from_alt(m: re.Match) -> str:
    tag = m.group(0)
    if _TITLE_ATTR_RE.search(tag):
        return tag
    alt_m = _ALT_RE.search(tag)
    if not alt_m or not alt_m.group(1):
        return tag
    title = alt_m.group(1)
    if tag.endswith("/>"):
        return tag[:-2] + f' title="{title}" />'
    return tag[:-1] + f' title="{title}">'


html = sys.stdin.read()
html = _inject_into_svg_source(html)
html = _B64_SVG_RE.sub(_replace_b64, html)
html = _IMG_TAG_RE.sub(_add_title_from_alt, html)
sys.stdout.write(html)
