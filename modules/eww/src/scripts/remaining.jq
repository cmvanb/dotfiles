# Time left until an ISO 8601 instant, relative to $now: "2h 10m", "4d 3h".
def remaining:
    if . == null then ""
    else (sub("\\.[0-9]+"; "") | sub("(?<tz>[+-][0-9]{2}):(?<m>[0-9]{2})$"; "\(.tz)\(.m)")
          | strptime("%Y-%m-%dT%H:%M:%S%z") | mktime) - $now
         | if . <= 0 then "now"
           elif . < 3600 then "\(. / 60 | floor)m"
           elif . < 86400 then "\(. / 3600 | floor)h \(. % 3600 / 60 | floor)m"
           else "\(. / 86400 | floor)d \(. % 86400 / 3600 | floor)h" end
    end;
