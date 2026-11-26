# Shapes OpenRouter's key endpoint (input), credits ($credits), last top-up
# ($topup) and analytics by model and UTC day ($activity) for the panel.

include "remaining";

def money: (. * 100 | round) as $c
    | "\($c / 100 | floor).\($c % 100 | tostring | if length == 1 then "0" + . else . end)";

def number: if type == "string" then tonumber else . // 0 end;

def percent($of): if $of > 0 then 100 * . / $of | floor | [., 0] | max | [., 100] | min else 0 end;

.data as $key
| $key.effective_budget as $budget
| $credits.data as $account
| (($account.total_credits // 0) - ($account.total_usage // 0)) as $left
| ($now - $now % 86400) as $midnight
| ($midnight | strftime("%Y-%m-%d")) as $today
| [$activity.data.data[]?
   | {date: .date__day[0:10], model, spend: (.total_usage | number), requests: (.request_count | number)}] as $rows
| [range(6; -1; -1) as $ago
   | ($midnight - $ago * 86400) as $start
   | ($start | strftime("%Y-%m-%d")) as $date
   | [$rows[] | select(.date == $date)] as $day
   | {date: $date, label: ($start | strftime("%a")), title: ($start | strftime("%a %-d %b")),
      spend: ([$day[].spend] | add // 0), requests: ([$day[].requests] | add // 0)}] as $days
| ([$days[].spend] | add) as $week
| ([$days[].spend] | max) as $peak
| (($now - $midnight + 6 * 86400) / 86400) as $elapsed
| ([$rows[] | select(.date == $today)]
   | group_by(.model)
   | map({name: (.[0].model | sub("^[^/]+/"; "")), spend: ([.[].spend] | add), requests: ([.[].requests] | add)})
   | sort_by(-.spend)) as $models
| ($days[-1].spend) as $spent_today
| {
    ok: true,
    has_budget: ($budget != null),
    budget: ($budget.spend_usd // 0 | percent($budget.limit_usd // 0)),
    budget_spent: ($budget.spend_usd // 0 | money),
    budget_limit: ($budget.limit_usd // 0 | money),
    budget_reset: ($budget.resets_at | remaining),
    has_credits: ($account != null),
    credits: ($left | percent($topup.balance // 0)),
    credits_left: ($left | money),
    credits_topup: ($topup.balance // 0 | money),
    credits_runway: (if $activity != null and $week > 0 then $left / ($week / $elapsed) * 86400 | duration else "" end),
    today: ($key.usage_daily // 0 | money),
    week: ($key.usage_weekly // 0 | money),
    month: ($key.usage_monthly // 0 | money),
    has_activity: ($activity != null),
    days_spend: ($week | money),
    days: [$days[] | {label, today: (.date == $today),
                      value: (.spend | percent($peak)),
                      tooltip: "\(.title) · $\(.spend | money) · \(.requests) requests"}],
    models_spend: ($spent_today | money),
    models: [$models[0:5][] | {name, requests, spend: (.spend | money)}],
    models_more: ($models | length - 5 | [., 0] | max),
    models_more_spend: ([$models[5:][].spend] | add // 0 | money)
}
