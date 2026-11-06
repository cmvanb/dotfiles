#!/usr/bin/env bash
# Set firmware BootNext to bypass the systemd-boot menu, which a one-shot
# loader entry does not skip while loader.conf sets a timeout.
set -euo pipefail

entry=$(efibootmgr | sed -n 's/^Boot\([0-9A-Fa-f]\{4\}\)\*\? Windows Boot Manager\b.*/\1/p' | head -n1)
if [[ -z $entry ]]; then
    echo "Windows Boot Manager entry not found" >&2
    exit 1
fi

sudo efibootmgr --quiet --bootnext "$entry"
systemctl reboot
