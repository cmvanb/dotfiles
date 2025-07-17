#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Tailscale status waybar component
#-------------------------------------------------------------------------------

[ -z "$(tailscale status | grep active)" ] && echo "" || echo "🔒 tailscale"
