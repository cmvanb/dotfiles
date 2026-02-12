#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Create a new todo document
#-------------------------------------------------------------------------------

set -euo pipefail

# TODO: Generate the todo document from a template. Ask for a title.
# Create a new todo document.
cp "$XDG_WIKI_HOME/templates/todo.md" "$XDG_WIKI_HOME/todo/$(date +%Y-%m-%d).md"
