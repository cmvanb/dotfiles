import subprocess

Sheet.addCommand('gx', 'open-cell-url', 'subprocess.Popen(["xdg-open", cursorDisplay])', 'open current cell value as URL with xdg-open')
