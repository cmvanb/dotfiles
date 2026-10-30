#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Niri state listener for eww
#
# Follows the niri event stream and prints one JSON object per change, in the
# shape sway.py documents. Workspaces are referenced by name when named, else
# by their index on the output, which `focus-workspace` accepts either way.
# Empty unnamed inactive workspaces are hidden: niri always keeps one trailing
# empty workspace per output, which sway has no counterpart for.
#-------------------------------------------------------------------------------

import json
import math
import select
import subprocess
import sys

from icons import MAX_ICONS, IconResolver

# Animated window titles emit bursts of events; one snapshot per burst suffices.
COALESCE_SECONDS = 0.05


class State:
    """Mirror of niri's workspaces and windows, updated from events."""

    def __init__(self):
        self.workspaces = None
        self.windows = None

    @property
    def ready(self):
        return self.workspaces is not None and self.windows is not None

    def handle(self, event):
        (kind, data), = event.items()
        handler = getattr(self, f'_on_{kind}', None)
        if handler and (self.ready or kind in ('WorkspacesChanged', 'WindowsChanged')):
            handler(data)

    def _on_WorkspacesChanged(self, data):
        self.workspaces = {ws['id']: ws for ws in data['workspaces']}

    def _on_WorkspaceActivated(self, data):
        target = self.workspaces.get(data['id'])
        if target is None:
            return
        for ws in self.workspaces.values():
            if ws['output'] == target['output']:
                ws['is_active'] = False
            if data['focused']:
                ws['is_focused'] = False
        target['is_active'] = True
        target['is_focused'] = target['is_focused'] or data['focused']

    def _on_WorkspaceUrgencyChanged(self, data):
        if data['id'] in self.workspaces:
            self.workspaces[data['id']]['is_urgent'] = data['urgent']

    def _on_WorkspaceActiveWindowChanged(self, data):
        if data['workspace_id'] in self.workspaces:
            self.workspaces[data['workspace_id']]['active_window_id'] = data['active_window_id']

    def _on_WindowsChanged(self, data):
        self.windows = {win['id']: win for win in data['windows']}

    def _on_WindowOpenedOrChanged(self, data):
        window = data['window']
        if window['is_focused']:
            for win in self.windows.values():
                win['is_focused'] = False
        self.windows[window['id']] = window

    def _on_WindowClosed(self, data):
        self.windows.pop(data['id'], None)

    def _on_WindowFocusChanged(self, data):
        for win in self.windows.values():
            win['is_focused'] = win['id'] == data['id']

    def _on_WindowUrgencyChanged(self, data):
        if data['id'] in self.windows:
            self.windows[data['id']]['is_urgent'] = data['urgent']

    def _on_WindowLayoutsChanged(self, data):
        for win_id, layout in data['changes']:
            if win_id in self.windows:
                self.windows[win_id]['layout'] = layout


def layout_order(win):
    """Tiled windows by column then row, floating windows after."""
    pos = (win.get('layout') or {}).get('pos_in_scrolling_layout')
    return (win['is_floating'], pos or (math.inf, math.inf), win['id'])


def snapshot(resolver, state):
    windows_by_ws = {}
    for win in sorted(state.windows.values(), key=layout_order):
        windows_by_ws.setdefault(win['workspace_id'], []).append(win)

    outputs = {}
    for ws in sorted(state.workspaces.values(), key=lambda ws: ws['idx']):
        if ws['output'] is None:
            continue
        output = outputs.setdefault(ws['output'], {'title': '', 'icon': '', 'workspaces': []})

        if ws['is_active']:
            active = state.windows.get(ws['active_window_id'])
            if active:
                output['title'] = active.get('title') or ''
                output['icon'] = resolver.resolve(active.get('app_id'))

        if ws['active_window_id'] is None and ws['name'] is None and not ws['is_active']:
            continue

        apps = []
        for win in windows_by_ws.get(ws['id'], []):
            icon = resolver.resolve(win.get('app_id'))
            if icon not in apps:
                apps.append(icon)

        ref = ws['name'] or str(ws['idx'])
        output['workspaces'].append({
            'name': ref,
            'label': ref,
            'focused': ws['is_focused'],
            'visible': ws['is_active'],
            'urgent': ws['is_urgent'],
            'icons': apps[:MAX_ICONS],
            'more': max(0, len(apps) - MAX_ICONS),
        })

    return {'mode': 'default', 'outputs': outputs}


def main():
    resolver = IconResolver()
    state = State()
    last = None

    # Unbuffered, so select() sees every pending event line.
    proc = subprocess.Popen(
        ['niri', 'msg', '-j', 'event-stream'],
        stdout=subprocess.PIPE,
        bufsize=0,
    )

    def emit():
        nonlocal last
        if not state.ready:
            return
        line = json.dumps(snapshot(resolver, state), separators=(',', ':'))
        if line != last:
            print(line, flush=True)
            last = line

    for raw in iter(proc.stdout.readline, b''):
        state.handle(json.loads(raw))
        while select.select([proc.stdout], [], [], COALESCE_SECONDS)[0]:
            raw = proc.stdout.readline()
            if not raw:
                break
            state.handle(json.loads(raw))
        emit()

    sys.exit(proc.wait())


if __name__ == '__main__':
    main()
