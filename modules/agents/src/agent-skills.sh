#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Manage agent skills
#
# Links local skills and vendored third party skills into the shared skills
# directory. Vendored sources are declared in `vendor.txt`.
#
# Usage:
#   agent-skills sync     Clone missing sources, then relink all skills
#   agent-skills update   Fetch sources at their declared ref, then relink
#   agent-skills list     Show linked skills and their source
#-------------------------------------------------------------------------------

set -euo pipefail

src_dir=$(dirname -- "$(realpath -- "${BASH_SOURCE[0]}")")

manifest="$src_dir/vendor.txt"
local_skills="$src_dir/skills"

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

skills_dir="$XDG_CONFIG_HOME/agents/skills"
vendor_dir="$XDG_DATA_HOME/agents/vendor"


# Vendored sources
#-------------------------------------------------------------------------------

vendor::clone () {
    local name="$1" url="$2" ref="$3"
    shift 3

    echo "  Cloning $name at $ref."

    git clone --quiet --depth 1 --filter=blob:none --sparse --branch "$ref" "$url" "$vendor_dir/$name"
    git -C "$vendor_dir/$name" sparse-checkout set "$@"
}

vendor::update () {
    local name="$1" url="$2" ref="$3"
    shift 3

    echo "  Updating $name to latest $ref."

    git -C "$vendor_dir/$name" fetch --quiet --depth 1 origin "$ref"
    git -C "$vendor_dir/$name" reset --quiet --hard FETCH_HEAD
    git -C "$vendor_dir/$name" sparse-checkout set "$@"
}

vendor::sync () {
    local update="$1"

    mkdir -p "$vendor_dir"

    local name url ref paths
    while read -r name url ref paths; do
        [[ -z "$name" || "$name" == \#* ]] && continue

        # shellcheck disable=SC2086
        if [[ ! -d "$vendor_dir/$name/.git" ]]; then
            vendor::clone "$name" "$url" "$ref" $paths
        elif [[ "$update" == "true" ]]; then
            vendor::update "$name" "$url" "$ref" $paths
        fi
    done < "$manifest"
}

vendor::revision () {
    git -C "$1" rev-parse --short HEAD
}


# Skill links
#-------------------------------------------------------------------------------

skills::link_directory () {
    local dir="$1"

    [[ -d "$dir" ]] || return 0

    local skill name
    for skill in "$dir"/*/; do
        [[ -f "$skill/SKILL.md" ]] || continue

        name=$(basename "$skill")

        if [[ -e "$skills_dir/$name" ]]; then
            echo "  Skipping duplicate skill: $name ($dir)"
            continue
        fi

        ln -sfT "$(realpath -- "$skill")" "$skills_dir/$name"
    done
}

skills::relink () {
    # The skills directory was a link to the local skills in earlier versions.
    [[ -L "$skills_dir" ]] && rm "$skills_dir"

    mkdir -p "$skills_dir"
    find "$skills_dir" -mindepth 1 -maxdepth 1 -type l -delete

    skills::link_directory "$local_skills"

    local name url ref paths path
    while read -r name url ref paths; do
        [[ -z "$name" || "$name" == \#* ]] && continue

        for path in $paths; do
            skills::link_directory "$vendor_dir/$name/$path"
        done
    done < "$manifest"

    echo "  Linked $(find "$skills_dir" -mindepth 1 -maxdepth 1 -type l | wc -l) skills."
}


# Commands
#-------------------------------------------------------------------------------

command::sync () {
    vendor::sync false
    skills::relink
}

command::update () {
    vendor::sync true
    skills::relink
}

command::list () {
    local skill
    for skill in "$skills_dir"/*; do
        [[ -e "$skill" ]] || continue

        printf '%-48s %s\n' "$(basename "$skill")" "$(realpath -- "$skill")"
    done
}

case "${1:-sync}" in
    sync)   command::sync ;;
    update) command::update ;;
    list)   command::list ;;
    *)      echo "Usage: agent-skills [sync|update|list]" >&2; exit 1 ;;
esac
