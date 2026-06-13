#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# Claude AI usage waybar component.
#-------------------------------------------------------------------------------

humanize_remaining() {
    local then now diff
    then=$(date -d "$1" +%s 2>/dev/null) || { echo "—"; return; }
    now=$(date +%s)
    diff=$((then - now))

    if (( diff <= 0 )); then
        echo "now"

    elif (( diff < 3600 )); then
        printf "%dm" $(( diff / 60 ))

    elif (( diff < 86400 )); then
        printf "%dh %dm" $(( diff / 3600 )) $(( (diff % 3600) / 60 ))

    else
        printf "%dd %dh" $(( diff / 86400 )) $(( (diff % 86400) / 3600 ))

    fi
}

creds="${XDG_CONFIG_HOME:-$HOME/.config}/claude/.credentials.json"
token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds" 2>/dev/null)

if [[ -z $token ]]; then
    printf '{"text":"claude —"}\n'
    exit 0
fi

response=$(curl -sf --max-time 10 "https://api.anthropic.com/api/oauth/usage" \
    -H "Authorization: Bearer $token" \
    -H "anthropic-beta: oauth-2025-04-20" \
    -H "User-Agent: claude-code/2.1.170")

if [[ -z $response ]]; then
    printf '{"text":"claude —"}\n'
    exit 0
fi

h5=$(jq -r '(.five_hour.utilization // 0) | floor' <<< "$response")
d7=$(jq -r '(.seven_day.utilization // 0) | floor' <<< "$response")
h5_resets=$(jq -r '.five_hour.resets_at // empty' <<< "$response")
d7_resets=$(jq -r '.seven_day.resets_at // empty' <<< "$response")
credits_used=$(jq -r '(.extra_usage.used_credits // 0) / 100' <<< "$response")
credits_limit=$(jq -r '(.extra_usage.monthly_limit // 0) / 100' <<< "$response")
credits_pct=$(jq -r '(.extra_usage.utilization // 0) | round' <<< "$response")
currency=$(jq -r '.extra_usage.currency // "?"' <<< "$response")

h5_left=$(humanize_remaining "$h5_resets")
d7_left=$(humanize_remaining "$d7_resets")

tooltip="5h: ${h5}%  ·  resets in ${h5_left}"$'\n'"7d: ${d7}%  ·  resets in ${d7_left}"$'\n'"credits: ${credits_used}/${credits_limit} ${currency}  (${credits_pct}%)"

jq -cn \
    --arg text "claude ${h5}%" \
    --arg tooltip "$tooltip" \
    --argjson pct "$h5" \
    '{"text": $text, "tooltip": $tooltip, "percentage": $pct}'
