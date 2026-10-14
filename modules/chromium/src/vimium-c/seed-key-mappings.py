#!/usr/bin/env -S uv run --quiet --script
# /// script
# requires-python = ">=3.11,<3.13"
# dependencies = ["plyvel"]
# ///
#-------------------------------------------------------------------------------
# Seed Vimium C key mappings into a Chromium profile
#-------------------------------------------------------------------------------

import argparse
import json
import sys
from pathlib import Path

import plyvel

EXTENSION_ID = "hfjbmagddngcpeloejdejnfgbamkjaeg"
KEY = "keyMappings"

# Vimium C splits large values across these keys in sync storage.
SPLIT_KEYS = [f"{KEY}:{i}" for i in range(13)]

# Vimium C treats sync storage as the source of truth while syncing is on,
# so both stores receive the same value.
STORES = ["Sync Extension Settings", "Local Extension Settings"]


def update(db_path, value):
    if value is None and not db_path.exists():
        return
    db_path.mkdir(parents=True, exist_ok=True)
    db = plyvel.DB(str(db_path), create_if_missing=True)
    try:
        with db.write_batch() as batch:
            for key in SPLIT_KEYS:
                batch.delete(key.encode())
            if value is None:
                batch.delete(KEY.encode())
            else:
                batch.put(KEY.encode(), json.dumps(value).encode())
    finally:
        db.close()


def main():
    parser = argparse.ArgumentParser(description="Seed Vimium C key mappings into a Chromium profile")
    parser.add_argument("profile", type=Path, help="Chromium profile directory")
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--mappings", type=Path, help="key mappings file to seed")
    group.add_argument("--clear", action="store_true", help="remove seeded key mappings")
    args = parser.parse_args()

    value = None if args.clear else args.mappings.read_text()

    try:
        for store in STORES:
            update(args.profile / store / EXTENSION_ID, value)
    except plyvel.IOError as error:
        print(f"Skipped Vimium C key mappings, close Chromium and redeploy: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
