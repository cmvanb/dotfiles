#!/bin/bash
#-------------------------------------------------------------------------------
# Run flatpak applications in bubblewrap, to enforce XDG basedir compliance.
#-------------------------------------------------------------------------------


set -e

VAR_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/flatpak/var"
mkdir -p "$VAR_DIR"

exec bwrap \
  --ro-bind / / \
  --dev /dev \
  --proc /proc \
  --tmpfs /tmp \
  --bind /tmp /tmp \
  --bind "$VAR_DIR" "$HOME/.var" \
  --bind /run/user/$(id -u) /run/user/$(id -u) \
  --setenv HOME "$HOME" \
  -- flatpak run "$@"
