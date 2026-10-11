#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Claude subscription usage for eww
#
#   {"ok": true, "session": 42, "session_reset": "2h 10m", "week": 12,
#    "week_reset": "4d 3h", "extra_used": 1.5, "extra_limit": 50,
#    "extra": 3, "currency": "USD"}
#-------------------------------------------------------------------------------

set -uo pipefail

unavailable='{"ok":false,"session":0,"session_reset":"","week":0,"week_reset":"","extra_used":0,"extra_limit":0,"extra":0,"currency":""}'

creds="${XDG_CONFIG_HOME:-$HOME/.config}/claude/.credentials.json"
token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds" 2>/dev/null)

if [[ -z $token ]]; then
    echo "$unavailable"
    exit 0
fi

response=$(curl -sf --max-time 10 "https://api.anthropic.com/api/oauth/usage" \
    -H "Authorization: Bearer $token" \
    -H "anthropic-beta: oauth-2025-04-20" \
    -H "User-Agent: claude-code/2.1.170")

if [[ -z $response ]]; then
    echo "$unavailable"
    exit 0
fi

jq -c --argjson now "$(date +%s)" '
    def remaining:
        if . == null then ""
        else (sub("\\.[0-9]+"; "") | sub("(?<tz>[+-][0-9]{2}):(?<m>[0-9]{2})$"; "\(.tz)\(.m)")
              | strptime("%Y-%m-%dT%H:%M:%S%z") | mktime) - $now
             | if . <= 0 then "now"
               elif . < 3600 then "\(. / 60 | floor)m"
               elif . < 86400 then "\(. / 3600 | floor)h \(. % 3600 / 60 | floor)m"
               else "\(. / 86400 | floor)d \(. % 86400 / 3600 | floor)h" end
        end;
    {
        ok: true,
        session: ((.five_hour.utilization // 0) | floor),
        session_reset: (.five_hour.resets_at | remaining),
        week: ((.seven_day.utilization // 0) | floor),
        week_reset: (.seven_day.resets_at | remaining),
        extra_used: ((.extra_usage.used_credits // 0) / 100),
        extra_limit: ((.extra_usage.monthly_limit // 0) / 100),
        extra: ((.extra_usage.utilization // 0) | round),
        currency: (.extra_usage.currency // "")
    }
' <<< "$response" 2>/dev/null || echo "$unavailable"
