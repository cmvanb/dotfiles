#!/usr/bin/env python3
import json
import subprocess


def equalize_node(node):
    layout = node.get('layout', '')
    children = node.get('nodes', [])

    if layout in ('splith', 'splitv') and len(children) > 1:
        count = len(children)
        dim = 'width' if layout == 'splith' else 'height'
        ppt = 100 // count
        for child in children:
            subprocess.run(
                ['swaymsg', f'[con_id={child["id"]}] resize set {dim} {ppt} ppt'],
                capture_output=True,
            )

    for child in children:
        equalize_node(child)


def find_focused_workspace(node):
    if node.get('type') == 'workspace' and _has_focused(node):
        return node
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        result = find_focused_workspace(child)
        if result:
            return result
    return None


def _has_focused(node):
    if node.get('focused'):
        return True
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        if _has_focused(child):
            return True
    return False


tree = json.loads(
    subprocess.run(['swaymsg', '-t', 'get_tree'], capture_output=True, text=True).stdout
)
workspace = find_focused_workspace(tree)
if workspace:
    equalize_node(workspace)
