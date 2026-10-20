#!/usr/bin/env bash
#-------------------------------------------------------------------------------
# OpenRouter usage for eww
#
#   {"ok": true, "has_budget": true, "budget": 12, "budget_spent": "2.40",
#    "budget_limit": "20.00", "budget_reset": "17d 7h", "has_credits": true,
#    "credits": 61, "credits_left": "43.36", "credits_total": "70.00",
#    "today": "0.10", "week": "1.20", "month": "2.40"}
#-------------------------------------------------------------------------------

set -uo pipefail

unavailable='{"ok":false,"has_budget":false,"budget":0,"budget_spent":"","budget_limit":"","budget_reset":"","has_credits":false,"credits":0,"credits_left":"","credits_total":"","today":"","week":"","month":""}'

# A locked vault would prompt for the master password on every poll.
if ! rbw unlocked &> /dev/null; then
    echo "$unavailable"
    exit 0
fi

token=$(rbw get "OpenRouter API Key OpenCode Local Dev" 2>/dev/null)

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

jq -c -L "$(dirname "${BASH_SOURCE[0]}")" --argjson now "$(date +%s)" \
    --argjson credits "${credits:-null}" '
    include "remaining";
    def money: (. * 100 | round) as $c
        | "\($c / 100 | floor).\($c % 100 | tostring | if length == 1 then "0" + . else . end)";
    .data as $key
    | $key.effective_budget as $budget
    | $credits.data as $account
    | {
        ok: true,
        has_budget: ($budget != null),
        budget: (if $budget != null and $budget.limit_usd > 0
                 then 100 * $budget.spend_usd / $budget.limit_usd | floor else 0 end),
        budget_spent: ($budget.spend_usd // 0 | money),
        budget_limit: ($budget.limit_usd // 0 | money),
        budget_reset: ($budget.resets_at | remaining),
        has_credits: ($account != null),
        credits: (if ($account.total_credits // 0) > 0
                  then 100 - 100 * $account.total_usage / $account.total_credits | floor else 0 end),
        credits_left: (($account.total_credits // 0) - ($account.total_usage // 0) | money),
        credits_total: ($account.total_credits // 0 | money),
        today: ($key.usage_daily // 0 | money),
        week: ($key.usage_weekly // 0 | money),
        month: ($key.usage_monthly // 0 | money)
    }
' <<< "$key" 2>/dev/null || echo "$unavailable"
