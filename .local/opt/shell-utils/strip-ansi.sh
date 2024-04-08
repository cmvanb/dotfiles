#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Strip ANSI escape sequences from a file.
#
# NOTE: You may already have a binary for this task named `strip-ansi-escapes`.
#-------------------------------------------------------------------------------

LC_ALL=C.UTF8 sed -E "s/\x1B\[[\x30-\x3F]*[\x20-\x20F]*[\x40-\x7E]//g" <<< "$(cat)"
