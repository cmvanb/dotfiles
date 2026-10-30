#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Regenerate carbon.mako.toml from the Neovim highlights
#
# Usage:
#   generate-theme.sh          # rewrite the template
#   generate-theme.sh --check  # fail when the template is out of date
#
# Rerun after changing the Neovim highlights or updating justpager queries.
#-------------------------------------------------------------------------------

set -euo pipefail

src=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
template="$src/carbon.mako.toml"
output=$(mktemp)
trap 'rm -f "$output"' EXIT

JUSTPAGER_THEME_OUTPUT="$output" nvim --headless \
    "+lua local ok, error = pcall(dofile, '$src/generate-theme.lua') if not ok then io.stderr:write(error, '\n') vim.cmd('cquit 1') end" \
    +qa

if [[ "${1:-}" == --check ]]; then
    if ! diff -u "$template" "$output"; then
        echo "carbon.mako.toml is out of date; run generate-theme.sh." >&2
        exit 1
    fi
    echo "carbon.mako.toml is up to date."
else
    cp "$output" "$template"
    echo "Wrote $template."
fi
