#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Seed the default page zoom into a Chromium profile
#-------------------------------------------------------------------------------

import argparse
import json
import math
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description="Seed the default page zoom into a Chromium profile")
    parser.add_argument("profile", type=Path, help="Chromium profile directory")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--percent", type=float, help="default page zoom in percent")
    group.add_argument("--clear", action="store_true", help="reset the default page zoom to 100%%")
    args = parser.parse_args()

    # Chromium rewrites Preferences on exit, so edits only persist while it is closed.
    if (args.profile.parent / "SingletonLock").is_symlink():
        print("Skipped default page zoom, close Chromium and redeploy.", file=sys.stderr)
        return 1

    prefs_path = args.profile / "Preferences"
    prefs = json.loads(prefs_path.read_text()) if prefs_path.exists() else {}

    # Chromium stores zoom as a level, where the zoom factor is 1.2 ** level.
    level = 0.0 if args.clear else math.log(args.percent / 100) / math.log(1.2)
    prefs.setdefault("partition", {}).setdefault("default_zoom_level", {})["x"] = level

    args.profile.mkdir(parents=True, exist_ok=True)
    prefs_path.write_text(json.dumps(prefs))
    return 0


if __name__ == "__main__":
    sys.exit(main())
