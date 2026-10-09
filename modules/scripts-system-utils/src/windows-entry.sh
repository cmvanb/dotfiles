#!/usr/bin/env bash
# Succeed when systemd-boot offers the Windows entry. The manifesto bootloader
# role deploys 02-windows.conf only for hosts with windows_dualboot set.

strings -el /sys/firmware/efi/efivars/LoaderEntries-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f 2>/dev/null \
    | grep -qx '02-windows.conf'
