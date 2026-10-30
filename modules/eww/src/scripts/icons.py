#-------------------------------------------------------------------------------
# Application icon lookup shared by the window manager listeners
#-------------------------------------------------------------------------------

import gi

gi.require_version('Gtk', '3.0')
from gi.repository import Gio, Gtk  # noqa: E402

MAX_ICONS = 4
# Raster icons are looked up at this size and scaled down by CSS.
RASTER_SIZE = 64
FALLBACK_ICON = 'application-x-executable'


class IconResolver:
    """Map a Wayland app_id or X11 class to an icon name or file path."""

    def __init__(self):
        self.theme = Gtk.IconTheme.get_default()
        self.cache = {}
        self.index = None

    def _build_index(self):
        index = {}
        for info in Gio.AppInfo.get_all():
            icon = info.get_icon()
            if icon is None:
                continue
            value = icon.to_string()
            desktop_id = (info.get_id() or '').removesuffix('.desktop').lower()
            index.setdefault(desktop_id, value)
            index.setdefault(desktop_id.rsplit('.', 1)[-1], value)
            wm_class = info.get_startup_wm_class() if hasattr(info, 'get_startup_wm_class') else None
            if wm_class:
                index.setdefault(wm_class.lower(), value)
        return index

    def resolve(self, app):
        if not app:
            return FALLBACK_ICON
        if app in self.cache:
            return self.cache[app]
        if self.index is None:
            self.index = self._build_index()

        key = app.lower()
        icon = self.index.get(key) or self.index.get(key.rsplit('.', 1)[-1])
        if icon is None:
            # The app may have been installed after the index was built.
            self.index = self._build_index()
            icon = self.index.get(key) or self.index.get(key.rsplit('.', 1)[-1])
        if icon is None and self.theme.has_icon(key):
            icon = key
        if icon is None or (not icon.startswith('/') and not self.theme.has_icon(icon)):
            icon = FALLBACK_ICON

        icon = self._scalable(icon)
        self.cache[app] = icon
        return icon

    def _scalable(self, icon):
        """Prefer a file path for raster theme icons.

        GTK draws a raster `-gtk-icontheme()` image at its nearest stock size
        and ignores `background-size`, which overflows the bar. A large file
        loaded through `url()` scales down to the exact CSS size instead.
        """
        if icon.startswith('/'):
            return icon
        info = self.theme.lookup_icon(icon, RASTER_SIZE, 0)
        path = info.get_filename() if info else None
        if path and not path.endswith('.svg'):
            return path
        return icon
