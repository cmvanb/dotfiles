#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Mako template renderer
#
# Usage:
#   render-mako <template_path> <output_path> [KEY=VALUE ...]
#
# KEY=VALUE pairs inject extra variables into the template context (used for
# runtime templates like bookmark.mako.md that receive per-invocation data).
#-------------------------------------------------------------------------------

import os
import sys
from pathlib import Path


def _get_theme_dir() -> Path:
    xdg_opt = os.environ.get('XDG_OPT_HOME', os.path.expanduser('~/.local/opt'))
    return Path(xdg_opt) / 'theme'


def _load_theme():
    theme_dir = _get_theme_dir()
    if str(theme_dir) not in sys.path:
        sys.path.insert(0, str(theme_dir))
    import theme
    return theme


def _build_context(theme) -> dict:
    """Build the full Mako template context from the theme API and environment."""

    ctx = {}

    # --- Color formatting functions ---
    ctx['color_hash']        = theme.color_hash
    ctx['color_named']       = theme.color_named
    ctx['color_zerox']       = theme.color_zerox
    ctx['color_rgb_int']     = theme.color_rgb_int
    ctx['color_css_rgba']    = theme.color_css_rgba
    ctx['color_css_rgba_hex']= theme.color_css_rgba_hex
    ctx['color_rgb_int_hex'] = theme.color_rgb_int_hex
    ctx['color_256']         = theme.color_256
    ctx['color_ansi_fg']     = theme.color_ansi_fg
    ctx['color_ansi_fg_hex'] = theme.color_ansi_fg_hex
    ctx['color_ansi_bg']     = theme.color_ansi_bg
    ctx['color_ansi_bg_hex'] = theme.color_ansi_bg_hex
    ctx['color_ansi']        = theme.color_ansi
    ctx['color_ansi_hex']    = theme.color_ansi_hex
    ctx['color_ansi_reset']  = theme.color_ansi_reset

    # --- Font and cursor accessor functions ---
    ctx['font']   = theme.font
    ctx['cursor'] = theme.cursor

    # --- All color values as plain variables (e.g. primary_8 = "2a68ca") ---
    # Access the private parsed dicts directly.
    for name, color in theme._colors.items():
        ctx[name] = color.as_hex()

    # --- All font values ---
    for name, value in theme._fonts.items():
        ctx[name] = value

    # --- All cursor values ---
    for name, value in theme._cursor.items():
        ctx[name] = value

    # --- XDG environment variables ---
    for key in (
        'XDG_CONFIG_HOME', 'XDG_CACHE_HOME', 'XDG_DATA_HOME', 'XDG_STATE_HOME',
        'XDG_BIN_HOME', 'XDG_OPT_HOME', 'XDG_SCRIPTS_HOME', 'XDG_TEMPLATES_DIR',
    ):
        ctx[key] = os.environ.get(key, '')

    # --- Deploy-time variables ---
    ctx['DEPLOY_PROFILE'] = os.environ.get('DEPLOY_PROFILE', '')
    ctx['DEPLOY_DISTRO']  = os.environ.get('DEPLOY_DISTRO', '')
    ctx['DEPLOY_WM']      = os.environ.get('DEPLOY_WM', '')
    ctx['DEPLOY_HOST']    = os.environ.get('DEPLOY_HOST', '')
    ctx['USER']           = os.environ.get('USER', '')

    return ctx


def render(template_path: str, output_path: str, extra: dict | None = None):
    from mako.exceptions import RichTraceback

    theme = _load_theme()
    ctx   = _build_context(theme)

    if extra:
        ctx.update(extra)

    tpl_path = Path(template_path)
    if not tpl_path.is_file():
        print(f'[render-mako] ERROR: Template not found: `{template_path}`', file=sys.stderr)
        sys.exit(1)

    try:
        from mako.lookup import TemplateLookup
        lookup = TemplateLookup(
            directories=[str(tpl_path.parent.resolve())],
            strict_undefined=True,
        )
        tpl = lookup.get_template(tpl_path.name)
        result = tpl.render(**ctx)
    except Exception:
        tb = RichTraceback()
        print(f'[render-mako] ERROR: Rendering `{template_path}` failed:', file=sys.stderr)
        for filename, lineno, function, line in tb.traceback:
            print(f'  File {filename}, line {lineno}, in {function}', file=sys.stderr)
            print(f'    {line}', file=sys.stderr)
        print(f'{tb.error.__class__.__name__}: {tb.error}', file=sys.stderr)
        sys.exit(1)

    out_path = Path(output_path)
    out_path.parent.mkdir(parents=True, exist_ok=True)

    # Delete pre-existing target (matches behaviour of render_esh_template).
    if out_path.exists():
        out_path.unlink()

    out_path.write_text(result, encoding='utf-8')


def _parse_extra(args: list[str]) -> dict:
    """Parse KEY=VALUE pairs from CLI arguments."""
    extra = {}
    for arg in args:
        if '=' in arg:
            key, _, value = arg.partition('=')
            extra[key.strip()] = value
        else:
            print(f'[render-mako] WARNING: Ignoring malformed argument: `{arg}`', file=sys.stderr)
    return extra


def main():
    if len(sys.argv) < 3:
        print('Usage: render-mako <template_path> <output_path> [KEY=VALUE ...]', file=sys.stderr)
        sys.exit(1)

    template_path = sys.argv[1]
    output_path   = sys.argv[2]

    if not template_path:
        print('[render-mako] ERROR: Missing argument: template', file=sys.stderr)
        sys.exit(1)

    if not Path(template_path).is_file():
        print(f'[render-mako] ERROR: Template file does not exist: `{template_path}`', file=sys.stderr)
        sys.exit(1)

    if not output_path:
        print('[render-mako] ERROR: Missing argument: output', file=sys.stderr)
        sys.exit(1)

    extra = _parse_extra(sys.argv[3:]) if len(sys.argv) > 3 else {}

    render(template_path, output_path, extra or None)


if __name__ == '__main__':
    main()
