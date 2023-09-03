#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Follow the white rabbit.
#-------------------------------------------------------------------------------

set -euo pipefail

if ! command -v fortune &> /dev/null; then
    exit 42
fi
if ! command -v neo-matrix &> /dev/null; then
    exit 69
fi

message=$(fortune -n 120 -s)
message=$(echo -e "$message" | tr -d '\n')

neo-matrix \
    --charset punc \
    --defaultbg \
    --fps 16 \
    --message "$message"
