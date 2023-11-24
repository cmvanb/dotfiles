#!/usr/bin/env bash

# TODO: Save active tag on source output, restore it on destination output.

riverctl send-to-output "$1"
riverctl focus-output "$1"
