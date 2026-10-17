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

config="${XDG_CONFIG_HOME:-$HOME/.config}/claude"
creds="$config/.credentials.json"
lock="$config/.oauth_refresh.lock"
token_url="https://platform.claude.com/v1/oauth/token"
client_id="9d1c250a-e61b-44d9-88ed-5944d1962f5e"
backoff="${XDG_RUNTIME_DIR:-/tmp}/eww/claude-refresh-backoff"

expiring() {
    jq -e --argjson now "$(date +%s%3N)" \
        '.claudeAiOauth.expiresAt < $now + 300000' "$creds" >/dev/null 2>&1
}

# Retrying every poll after a failure keeps the token endpoint rate limited.
backing_off() {
    [[ -f $backoff ]] && (( $(date +%s) < $(cut -d' ' -f1 "$backoff") ))
}

back_off() {
    read -r _ delay 2>/dev/null <"$backoff" || delay=150
    delay=$(( delay * 2 > 3600 ? 3600 : delay * 2 ))
    mkdir -p "${backoff%/*}"
    echo "$(( $(date +%s) + delay )) $delay" >"$backoff"
}

refresh() {
    expiring || return 0

    if ! tokens=$(jq -c --arg client_id "$client_id" '.claudeAiOauth | {
        grant_type: "refresh_token",
        refresh_token: .refreshToken,
        client_id: $client_id,
        scope: (.scopes | join(" "))
    }' "$creds" | curl -sS --fail-with-body --max-time 10 "$token_url" \
        -H "Content-Type: application/json" --data @- 2>&1); then
        echo "claude.sh: token refresh failed: $tokens" >&2
        back_off
        return 0
    fi
    rm -f "$backoff"

    tmp=$(mktemp "$creds.XXXXXX")
    if jq --argjson t "$tokens" --argjson now "$(date +%s%3N)" '.claudeAiOauth += ({
        accessToken: $t.access_token,
        refreshToken: ($t.refresh_token // .claudeAiOauth.refreshToken),
        expiresAt: ($now + $t.expires_in * 1000)
    } + if $t.refresh_token_expires_in then
        {refreshTokenExpiresAt: ($now + $t.refresh_token_expires_in * 1000)}
    else {} end)' "$creds" >"$tmp"; then
        mv "$tmp" "$creds"
    else
        rm -f "$tmp"
    fi
}

# Shares Claude Code's refresh lock so only one process rotates the refresh token.
if expiring && ! backing_off; then
    find "$lock" -maxdepth 0 -mmin +1 -exec rmdir {} \; 2>/dev/null
    if mkdir "$lock" 2>/dev/null; then
        refresh
        rmdir "$lock"
    fi
fi

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

jq -c -L "$(dirname "${BASH_SOURCE[0]}")" --argjson now "$(date +%s)" '
    include "remaining";
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
