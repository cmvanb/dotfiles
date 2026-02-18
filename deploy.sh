#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Deploy dotfiles
#
# Single entry point CLI for profile-based module deployment
#-------------------------------------------------------------------------------

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
cd "$script_dir"

source lib/profile.sh
source lib/fs.sh
source lib/linux.sh

# Bootstrap environment
#-------------------------------------------------------------------------------

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.local/cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_BIN_HOME="${XDG_BIN_HOME:-$HOME/.local/bin}"
export XDG_OPT_HOME="${XDG_OPT_HOME:-$HOME/.local/opt}"
export XDG_SCRIPTS_HOME="${XDG_SCRIPTS_HOME:-$HOME/.local/scripts}"
export XDG_TEMPLATES_DIR="${XDG_TEMPLATES_DIR:-$HOME/.local/share/templates}"

export DEPLOY_DISTRO="$(linux::get_distro_id)"
export DEPLOY_HOST="$(uname -n)"
export DEPLOY_PROFILE=""  # Will be set per profile
export ESH_SHELL=/usr/bin/bash

state_dir="$HOME/.local/state/dotfiles"

# Utilities
#-------------------------------------------------------------------------------

log_header() {
    echo
    echo "$@"
}

log_item() {
    echo "  $@"
}

log_error() {
    echo "Error: $*" >&2
    exit 1
}

log_error_with_hint() {
    local error_msg="$1"
    shift
    local hint_msg="$*"

    echo "Error: $error_msg" >&2
    echo
    echo "$hint_msg" >&2
    exit 1
}

# State management
#-------------------------------------------------------------------------------

state::write() {
    local profile="$1"
    local modules="$2"
    local wm="$3"

    mkdir -p "$state_dir"
    echo "$profile" > "$state_dir/profile"
    echo "$modules" > "$state_dir/modules"
    echo "$wm" > "$state_dir/wm"
}

state::read() {
    local -n ref_profile="$1"
    local -n ref_modules="$2"
    local -n ref_wm="$3"

    if [[ ! -f "$state_dir/profile" ]]; then
        return 1
    fi

    ref_profile=$(cat "$state_dir/profile")
    ref_modules=$(cat "$state_dir/modules")
    ref_wm=$(cat "$state_dir/wm")
}

# Subcommands
#-------------------------------------------------------------------------------

cmd_list() {
    log_header "Profiles available:"
    log_item "$(ls profiles | tr '\n' ' ' | sed 's/ $//')"

    log_header "Modules available:"
    local all_modules=$(ls modules | sort -u | tr '\n' ' ' | sed 's/ $//')
    log_item "$all_modules"
    echo
}

cmd_show() {
    local profile_name="$1"

    # Get inheritance chain
    local chain_str
    chain_str=$(profile::get_inheritance_chain "$profile_name" profiles) || log_error "\`$profile_name\` is not a profile"

    log_header "Resolving profile: $profile_name"
    # Format as: parent1 -> parent2 -> profile
    local chain_display=$(echo "$chain_str" | paste -sd ' ' - | sed 's/ / -> /g')
    log_item "$chain_display"

    # Merge profiles
    local -a chain=($chain_str)
    local -A merged
    profile::merge profiles merged "${chain[@]}" || return 1

    if [[ -n "${merged[wm]}" ]]; then
        log_header "Window manager:"
        log_item "${merged[wm]}"
    fi

    log_header "Distro:"
    log_item "$DEPLOY_DISTRO"

    if [[ -n "${merged[libs]}" ]]; then
        log_header "Libraries:"
        log_item "${merged[libs]}"
    fi

    if [[ -n "${merged[themes]}" ]]; then
        log_header "Theme:"
        log_item "${merged[themes]}"
    fi

    if [[ -n "${merged[installs]}" ]]; then
        log_header "Modules:"
        log_item "${merged[installs]}"
    fi

    if [[ -n "${merged[enables]}" ]]; then
        log_header "Services:"
        log_item "${merged[enables]}"
    fi
    echo
}

cmd_install() {
    local target="$1"
    local dry_run="${2:-false}"

    # Check if target is a profile
    local is_profile=false
    local chain_str=""
    chain_str=$(profile::get_inheritance_chain "$target" profiles 2>/dev/null) && is_profile=true || true

    if [[ "$is_profile" == "true" ]]; then
        # Deploy a profile
        local -a chain=($chain_str)

        log_header "Resolving profile: $target"
        local chain_display=$(echo "$chain_str" | paste -sd ' ' - | sed 's/ / -> /g')
        log_item "$chain_display"

        local -A merged
        profile::merge profiles merged "${chain[@]}" || return 1

        export DEPLOY_PROFILE="${chain[*]}"
        [[ -n "${merged[wm]}" ]] && export DEPLOY_WM="${merged[wm]}"

        log_header "Profile: $target"
        [[ -n "${merged[wm]}" ]] && log_item "Window manager: ${merged[wm]}"
        log_item "Distro: $DEPLOY_DISTRO"

        if [[ "$dry_run" == "true" ]]; then
            log_header "Would install:"
            log_item "${merged[libs]} ${merged[themes]} ${merged[installs]}"

            if [[ -n "${merged[enables]}" ]]; then
                log_header "Would enable:"
                log_item "${merged[enables]}"
            fi

            log_header "Dry run complete, no changes were made."
            echo
            return 0
        fi

        # Deploy in category order
        install_modules "lib" "${merged[libs]}"
        install_modules "theme" "${merged[themes]}"
        install_modules "install" "${merged[installs]}"

        if [[ -n "${merged[enables]}" ]]; then
            enable_services "${merged[enables]}"
        fi

        state::write "$target" "${merged[installs]}" "${merged[wm]:-}"

        log_header "Deployment complete."
    else
        # Install a single module
        if [[ ! -f "modules/$target/deploy.sh" ]]; then
            log_error_with_hint "\`$target\` is not a profile or module" "Run \`./deploy.sh list\` to see available profiles and modules."
        fi

        if [[ "$dry_run" == "true" ]]; then
            log_header "Would install:"
            log_item "$target"
            log_header "Dry run complete, no changes were made."
            echo
            return 0
        fi

        export DEPLOY_PROFILE=""

        log_header "Installing module: $target"
        install_module "$target"
    fi
}

cmd_uninstall() {
    local target="${1:-}"

    if [[ -z "$target" ]]; then
        local profile modules wm
        state::read profile modules wm || log_error "No deployment state found. Specify a profile or module to uninstall."

        target="$profile"
        echo "Using tracked state: profile=$profile"
    fi

    # Check if target is a profile
    if [[ -f "profiles/$target" ]]; then
        local chain_str
        chain_str=$(profile::get_inheritance_chain "$target" profiles) || log_error "Failed to resolve profile: $target"

        local -a chain=($chain_str)
        local -A merged
        profile::merge profiles merged "${chain[@]}" || return 1

        log_header "Uninstalling profile: $target"

        disable_services "${merged[enables]}"
        uninstall_modules "install" "${merged[installs]}"
        uninstall_modules "theme" "${merged[themes]}"
        uninstall_modules "lib" "${merged[libs]}"

        rm -f "$state_dir/profile" "$state_dir/modules" "$state_dir/wm"

        log_header "Uninstall complete."
    else
        log_header "Uninstalling module: $target"
        uninstall_module "$target"
    fi
}

cmd_status() {
    if ! state::read profile modules wm; then
        echo "No deployment state found."
        return 0
    fi

    log_header "Profile:"
    log_item "$profile"

    log_header "Window manager:"
    log_item "${wm:-none}"

    if [[ -n "$modules" ]]; then
        log_header "Modules deployed:"
        log_item "  $modules"
    fi
    echo
}

# Module installation helpers
#-------------------------------------------------------------------------------

install_modules() {
    local category="$1"
    local modules="$2"

    [[ -z "$modules" ]] && return 0

    case "$category" in
        lib)
            log_header "Deploying library modules..."
            ;;
        theme)
            log_header "Deploying theme modules..."
            ;;
        install)
            log_header "Deploying modules..."
            ;;
    esac

    for module in $modules; do
        install_module "$module" || {
            log_error "Failed to install module: $module"
        }
    done
}

install_module() {
    local module="$1"
    local module_path="modules/$module/deploy.sh"

    [[ -f "$module_path" ]] || log_error "Module not found: $module"

    source "$module_path"

    if ! declare -F "${module}::install" >/dev/null 2>&1; then
        log_error "Function \`${module}::install\` not found in module \`$module\`"
    fi

    "${module}::install"
}

uninstall_modules() {
    local category="$1"
    local modules="$2"

    [[ -z "$modules" ]] && return 0

    case "$category" in
        lib)
            log_header "Uninstalling library modules..."
            ;;
        theme)
            log_header "Uninstalling theme modules..."
            ;;
        install)
            log_header "Uninstalling modules..."
            ;;
    esac

    local -a module_array=($modules)
    for ((i = ${#module_array[@]} - 1; i >= 0; i--)); do
        uninstall_module "${module_array[$i]}" || true
    done
}

uninstall_module() {
    local module="$1"
    local module_path="modules/$module/deploy.sh"

    [[ -f "$module_path" ]] || log_error "Module not found: $module"

    source "$module_path"

    if declare -F "${module}::uninstall" >/dev/null 2>&1; then
        "${module}::uninstall" || echo "  Warning: ${module}::uninstall reported errors."
    fi
}

enable_services() {
    local services="$1"
    [[ -z "$services" ]] && return 0

    log_header "Enabling services..."

    for service in $services; do
        local module_path="modules/$service/deploy.sh"

        [[ -f "$module_path" ]] || log_error "Service module not found: $service"

        source "$module_path"

        if declare -F "${service}::enable" >/dev/null 2>&1; then
            "${service}::enable" || echo "  Warning: ${service}::enable reported errors."
        fi
    done
}

disable_services() {
    local services="$1"
    [[ -z "$services" ]] && return 0

    log_header "Disabling services..."

    local -a service_array=($services)
    for ((i = ${#service_array[@]} - 1; i >= 0; i--)); do
        local service="${service_array[$i]}"
        local module_path="modules/$service/deploy.sh"

        [[ -f "$module_path" ]] || log_error "Service module not found: $service"

        source "$module_path"

        if declare -F "${service}::disable" >/dev/null 2>&1; then
            "${service}::disable" || echo "  Warning: ${service}::disable reported errors."
        fi
    done
}

# Main
#-------------------------------------------------------------------------------

usage() {
    cat <<EOF
Usage: ./deploy.sh <command> [options]

Commands:
  install <profile|module>    Install a profile or individual module
  uninstall [profile|module]  Uninstall (defaults to tracked state)
  list                        List available profiles and modules
  show <profile>              Show resolved modules for a profile
  status                      Show currently deployed profile

Options:
  --dry-run                   Show what would be done without doing it
  --help                      Show this help message
  --host                      Auto-detect profile from hostname

Examples:
  ./deploy.sh install cyxwel
  ./deploy.sh install server
  ./deploy.sh install --host
  ./deploy.sh install nvim
  ./deploy.sh uninstall
  ./deploy.sh show workstation
  ./deploy.sh status
EOF
}

main() {
    local cmd="${1:-}"
    [[ -z "$cmd" ]] && { usage; exit 1; }

    case "$cmd" in
        list)
            cmd_list
            ;;
        show)
            [[ -z "${2:-}" ]] && log_error "show requires a profile name"
            cmd_show "$2"
            ;;
        install)
            [[ -z "${2:-}" ]] && log_error "install requires a profile or module name"
            local dry_run_flag=false
            local target="${2}"

            if [[ "$target" == "--host" ]]; then
                target="$DEPLOY_HOST"
            elif [[ "$target" == "--dry-run" ]]; then
                log_error "install: --dry-run must come after the profile/module name"
            fi

            # Check if --dry-run flag is in position 3
            if [[ "${3:-}" == "--dry-run" ]]; then
                dry_run_flag=true
            fi

            cmd_install "$target" "$dry_run_flag"
            ;;
        uninstall)
            cmd_uninstall "${2:-}"
            ;;
        status)
            cmd_status
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            log_error_with_hint "Unknown command: $cmd" "$(usage)"
            ;;
    esac
}

main "$@"
