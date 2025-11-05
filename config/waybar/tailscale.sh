#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Tailscale status waybar component
#-------------------------------------------------------------------------------

[ -z "$(tailscale status | grep 'Tailscale is stopped'.)" ] && echo "  tailscale" || echo ""
