#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Profile API: parse, resolve, and merge deployment profiles
#-------------------------------------------------------------------------------

profile::parse() {
    local profile_file="$1"
    local -n ref_out="$2"

    [[ -f "$profile_file" ]] || {
        echo "Error: Profile file not found: $profile_file" >&2
        return 1
    }

    local line key value
    while IFS= read -r line; do
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$line" ]] && continue

        if [[ "$line" =~ ^([a-z._-]+)=(.*)$ ]]; then
            key="${BASH_REMATCH[1]}"
            value="${BASH_REMATCH[2]}"
            ref_out["$key"]="$value"
        fi
    done < "$profile_file"
}

profile::find() {
    local name="$1"
    local profiles_dir="$2"

    if [[ -f "$profiles_dir/$name" ]]; then
        echo "$profiles_dir/$name"
        return 0
    fi
    return 1
}

profile::resolve_chain() {
    local name="$1"
    local profiles_dir="$2"

    # Base case: profile not found
    if ! [[ -f "$profiles_dir/$name" ]]; then
        echo "Error: Profile not found: $name" >&2
        return 1
    fi

    # Parse this profile
    local -A profile_data
    profile::parse "$profiles_dir/$name" profile_data || return 1

    # Recursively resolve parent
    local parent="${profile_data[profile.extends]}"
    if [[ -n "$parent" ]]; then
        profile::resolve_chain "$parent" "$profiles_dir" || return 1
    fi

    # Output this profile name
    echo "$name"
}

profile::get_inheritance_chain() {
    local name="$1"
    local profiles_dir="$2"

    profile::resolve_chain "$name" "$profiles_dir" || return 1
}

profile::merge() {
    local profiles_dir="$1"
    shift
    local -n ref_result="$1"
    shift
    local -a profile_names=("$@")

    local -a libs=()
    local -a themes=()
    local -a installs=()
    local -a enables=()
    local wm=""

    for profile_name in "${profile_names[@]}"; do
        local profile_file
        profile_file=$(profile::find "$profile_name" "$profiles_dir") || return 1

        local -A data
        profile::parse "$profile_file" data || return 1

        if [[ -v "data[profile.wm]" ]] && [[ -z "$wm" ]]; then
            wm="${data[profile.wm]}"
        fi

        if [[ -v "data[modules.lib]" ]] && [[ -n "${data[modules.lib]}" ]]; then
            for lib in ${data[modules.lib]}; do
                ! printf '%s\n' "${libs[@]}" 2>/dev/null | grep -q "^$lib$" && libs+=("$lib")
            done
        fi

        if [[ -v "data[modules.theme]" ]] && [[ -n "${data[modules.theme]}" ]]; then
            for theme in ${data[modules.theme]}; do
                ! printf '%s\n' "${themes[@]}" 2>/dev/null | grep -q "^$theme$" && themes+=("$theme")
            done
        fi

        if [[ -v "data[modules.install]" ]] && [[ -n "${data[modules.install]}" ]]; then
            for install in ${data[modules.install]}; do
                ! printf '%s\n' "${installs[@]}" 2>/dev/null | grep -q "^$install$" && installs+=("$install")
            done
        fi

        if [[ -v "data[modules.enable]" ]] && [[ -n "${data[modules.enable]}" ]]; then
            for enable in ${data[modules.enable]}; do
                ! printf '%s\n' "${enables[@]}" 2>/dev/null | grep -q "^$enable$" && enables+=("$enable")
            done
        fi
    done

    ref_result[wm]="$wm"
    ref_result[libs]="${libs[*]}"
    ref_result[themes]="${themes[*]}"
    ref_result[installs]="${installs[*]}"
    ref_result[enables]="${enables[*]}"
}
