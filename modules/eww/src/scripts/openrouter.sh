#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# OpenRouter usage for eww
#
#   {"ok": true, "has_budget": true, "budget": 12, "budget_spent": "2.40",
#    "budget_limit": "20.00", "budget_reset": "17d 7h", "has_credits": true,
#    "credits": 61, "credits_left": "43.36", "credits_topup": "70.00",
#    "credits_runway": "9d 4h", "today": "0.10", "week": "1.20", "month": "2.40",
#    "has_activity": true, "days_spend": "4.10",
#    "days": [{"label": "Thu", "today": true, "value": 80, "tooltip": "…"}, …],
#    "models_spend": "0.10",
#    "models": [{"name": "claude-opus-5.5", "requests": 3, "spend": "0.08"}, …],
#    "models_more": 0, "models_more_spend": "0.00"}
#
# The credits meter drains from the balance at the last top-up. OpenRouter
# reports only lifetime purchases, so that balance is recorded whenever they
# change.
#
# Spend by day and model comes from the analytics API, which only answers a
# management key. Without one, the panel falls back to the key's totals.
#-------------------------------------------------------------------------------

set -uo pipefail

script_dir=$(dirname "${BASH_SOURCE[0]}")
unavailable='{"ok":false,"has_budget":false,"budget":0,"budget_spent":"","budget_limit":"","budget_reset":"","has_credits":false,"credits":0,"credits_left":"","credits_topup":"","credits_runway":"","today":"","week":"","month":"","has_activity":false,"days_spend":"","days":[],"models_spend":"","models":[],"models_more":0,"models_more_spend":""}'
topup_file="${XDG_STATE_HOME:-$HOME/.local/state}/eww/openrouter-topup.json"

# A locked vault would prompt for the master password on every poll.
if ! rbw unlocked &> /dev/null; then
    echo "$unavailable"
    exit 0
fi

token=$(rbw get "OpenRouter API Key OpenCode Local Dev" 2>/dev/null)
management_token=$(rbw get "OpenRouter Management Key" 2>/dev/null)

if [[ -z $token ]]; then
    echo "$unavailable"
    exit 0
fi

fetch () {
    curl -sf --max-time 10 "https://openrouter.ai/api/v1/$1" \
        -H "Authorization: Bearer $token"
}

key=$(fetch key)

if [[ -z $key ]]; then
    echo "$unavailable"
    exit 0
fi

credits=$(fetch credits)

# Spend and requests by model for each UTC day of the last week.
activity=
if [[ -n $management_token ]]; then
    activity=$(curl -sf --max-time 10 "https://openrouter.ai/api/v1/analytics/query" \
        -H "Authorization: Bearer $management_token" \
        -H "Content-Type: application/json" \
        -d "$(jq -cn --arg start "$(date -u -d '6 days ago' +%Y-%m-%dT00:00:00Z)" \
                     --arg end "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '{
                metrics: ["total_usage", "request_count"],
                dimensions: ["model"],
                granularity: "day",
                time_range: {start: $start, end: $end}
            }')")
fi

# {"purchased": 370, "balance": 120.5}: lifetime purchases and the balance
# right after they last changed.
topup=$(jq -c . "$topup_file" 2>/dev/null)
if [[ -n $credits ]]; then
    latest=$(jq -c --argjson topup "${topup:-null}" '
        .data as $account
        | if $topup.purchased == $account.total_credits then $topup
          else {purchased: $account.total_credits,
                balance: ($account.total_credits - $account.total_usage)} end
    ' <<< "$credits" 2>/dev/null)
    if [[ -n $latest && $latest != "$topup" ]]; then
        mkdir -p "$(dirname "$topup_file")"
        echo "$latest" > "$topup_file.tmp" && mv "$topup_file.tmp" "$topup_file"
    fi
    topup=$latest
fi

jq -c -L "$script_dir" -f "$script_dir/openrouter.jq" \
    --argjson now "$(date +%s)" \
    --argjson credits "${credits:-null}" \
    --argjson topup "${topup:-null}" \
    --argjson activity "${activity:-null}" \
    <<< "$key" 2>/dev/null || echo "$unavailable"
