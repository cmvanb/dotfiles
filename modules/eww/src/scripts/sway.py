#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Sway state listener for eww
#
# Subscribes to sway events and prints one JSON object per change:
#
#   {
#     "mode": "default",
#     "outputs": {
#       "eDP-1": {
#         "title": "...", "icon": "...",
#         "workspaces": [{"name", "label", "focused", "visible", "urgent",
#                         "icons": [...], "more": 0}, ...]
#       }
#     }
#   }
#
# Each bar instance reads only the entry for its own output, matching waybar's
# per-output `sway/workspaces`.
#-------------------------------------------------------------------------------

import json
import select
import subprocess
import sys

from icons import MAX_ICONS, IconResolver

EVENTS = '["workspace","window","output","mode"]'
# Animated window titles emit bursts of events; one snapshot per burst suffices.
COALESCE_SECONDS = 0.05


def swaymsg(kind):
    out = subprocess.run(['swaymsg', '-r', '-t', kind], capture_output=True, text=True)
    return json.loads(out.stdout)


def app_of(node):
    return node.get('app_id') or (node.get('window_properties') or {}).get('class')


def windows(node):
    """Yield application windows below node in tree order."""
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        if child.get('pid') and child.get('type') in ('con', 'floating_con'):
            yield child
        yield from windows(child)


def focused_window(node):
    """Follow the focus stack so unfocused outputs still report their window."""
    while node.get('focus'):
        children = {c['id']: c for c in node.get('nodes', []) + node.get('floating_nodes', [])}
        node = children.get(node['focus'][0])
        if node is None:
            return None
    return node if node.get('pid') else None


def label_of(name, num):
    """Strip the "N:" prefix; show bare per-output numbers as the key pressed."""
    prefix, sep, rest = name.partition(':')
    if sep and prefix.isdigit():
        return rest
    if 0 < num <= 100:
        return str((num - 1) % 10 + 1)
    return name


def snapshot(resolver, mode):
    workspaces = {ws['name']: ws for ws in swaymsg('get_workspaces')}
    tree = swaymsg('get_tree')
    outputs = {}

    for output in tree.get('nodes', []):
        if output['name'].startswith('__'):
            continue

        entries = []
        title, title_icon = '', ''
        for ws in output.get('nodes', []):
            state = workspaces.get(ws['name'], {})
            apps = []
            for win in windows(ws):
                icon = resolver.resolve(app_of(win))
                if icon not in apps:
                    apps.append(icon)

            entries.append({
                'name': ws['name'],
                'label': label_of(ws['name'], ws.get('num', -1)),
                'focused': state.get('focused', False),
                'visible': state.get('visible', False),
                'urgent': state.get('urgent', False),
                'icons': apps[:MAX_ICONS],
                'more': max(0, len(apps) - MAX_ICONS),
            })

            if state.get('visible'):
                focused = focused_window(ws)
                if focused:
                    title = focused.get('name') or ''
                    title_icon = resolver.resolve(app_of(focused))

        outputs[output['name']] = {
            'title': title,
            'icon': title_icon,
            'workspaces': entries,
        }

    return {'mode': mode, 'outputs': outputs}


def main():
    resolver = IconResolver()
    mode = 'default'
    last = None

    # Unbuffered, so select() sees every pending event line.
    proc = subprocess.Popen(
        ['swaymsg', '-r', '-m', '-t', 'subscribe', EVENTS],
        stdout=subprocess.PIPE,
        bufsize=0,
    )

    def emit():
        nonlocal last
        line = json.dumps(snapshot(resolver, mode), separators=(',', ':'))
        if line != last:
            print(line, flush=True)
            last = line

    def handle(raw):
        nonlocal mode
        event = json.loads(raw)
        if 'change' in event and 'pango_markup' in event:
            mode = event['change']

    emit()
    for raw in iter(proc.stdout.readline, b''):
        handle(raw)
        while select.select([proc.stdout], [], [], COALESCE_SECONDS)[0]:
            raw = proc.stdout.readline()
            if not raw:
                break
            handle(raw)
        emit()

    sys.exit(proc.wait())


if __name__ == '__main__':
    main()
