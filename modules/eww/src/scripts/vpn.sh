#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# ProtonVPN state and control for eww
#
# Drives the wg-quick@proton0 tunnel and protonvpn-switch deployed by the
# manifesto protonvpn role.
#
#   vpn.sh status               {"present": true, "up": true}
#   vpn.sh profiles             {"selected": "nl-266", "profiles": ["de-445", "nl-266"]}
#   vpn.sh connect [profile]
#   vpn.sh disconnect
#
# The profiles are root-only and every sudo call logs to the journal, so the
# bar polls `status` and only the open panel polls `profiles`.
#-------------------------------------------------------------------------------

set -uo pipefail

interface=proton0
unit="wg-quick@$interface"
switch=/usr/local/bin/protonvpn-switch
profiles_dir=/etc/wireguard/protonvpn-profiles

refresh() {
    eww poll vpn vpn_profiles &> /dev/null
}

case ${1:-} in
    status)
        jq -cn \
            --argjson present "$([[ -x $switch ]] && echo true || echo false)" \
            --argjson up "$(systemctl is-active --quiet "$unit" && echo true || echo false)" \
            '{present: $present, up: $up}'
        ;;
    profiles)
        # One line per profile, prefixed "*" when it is the tunnel's config.
        sudo -n bash -c '
            for f in "$1"/*.conf; do
                [[ -e $f ]] || continue
                name=${f##*/}
                cmp -s "$f" "$2" && echo "*${name%.conf}" || echo " ${name%.conf}"
            done' _ "$profiles_dir" "/etc/wireguard/$interface.conf" 2> /dev/null \
            | jq -cRn '[inputs] | {
                selected: (map(select(startswith("*"))[1:]) | first // ""),
                profiles: map(.[1:])
            }'
        ;;
    connect)
        if [[ -n ${2:-} ]]; then
            sudo -n "$switch" "$2" > /dev/null
        fi
        sudo -n systemctl start "$unit"
        refresh
        ;;
    disconnect)
        sudo -n systemctl stop "$unit"
        refresh
        ;;
    *)
        echo "Usage: vpn.sh status|profiles|connect [profile]|disconnect" >&2
        exit 1
        ;;
esac
