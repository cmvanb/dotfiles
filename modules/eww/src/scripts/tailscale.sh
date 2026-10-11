#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Tailscale state for eww
#
#   {"up": true, "name": "casino", "ip": "100.x.y.z",
#    "peers": [{"name": "...", "ip": "100.x.y.z", "os": "linux", "online": true}]}
#-------------------------------------------------------------------------------

set -uo pipefail

tailscale status --json 2>/dev/null | jq -c '
    if .BackendState == "Running" then {
        up: true,
        name: .Self.HostName,
        ip: (.Self.TailscaleIPs[0] // ""),
        peers: ([.Peer // {} | .[] | {
            name: (.DNSName | split(".")[0]),
            ip: (.TailscaleIPs[0] // ""),
            os: .OS,
            online: .Online
        }] | sort_by((.online | not), .name))
    } else {up: false, name: "", ip: "", peers: []} end
' || echo '{"up":false,"name":"","ip":"","peers":[]}'
