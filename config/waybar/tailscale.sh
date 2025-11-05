#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Tailscale status waybar component
#-------------------------------------------------------------------------------

tailscale status >/dev/null 2>&1 && echo "  tailscale"
