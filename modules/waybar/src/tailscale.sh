#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Tailscale status waybar component
#-------------------------------------------------------------------------------

if tailscale status >/dev/null 2>&1; then
    tooltip=$(tailscale status 2>/dev/null | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}' | sed '$ s/\\n$//')
    printf '{"text":"  tailscale","tooltip":"<tt>%s</tt>"}\n' "$tooltip"
fi
