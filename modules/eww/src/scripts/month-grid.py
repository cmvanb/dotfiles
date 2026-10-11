#!/usr/bin/env python3
#-------------------------------------------------------------------------------
# Calendar data for the eww calendar popup
#
# Usage: month-grid.py month <offset>   # month view, offset in months from today
#        month-grid.py year <offset>    # year view, offset in years from today
#
# Prints the JSON consumed by the eww `calendar` variable.
#-------------------------------------------------------------------------------

import calendar
import datetime
import json
import sys

WEEKDAYS = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su']


def shift_month(date, offset):
    index = date.year * 12 + date.month - 1 + offset
    return index // 12, index % 12 + 1


def weeks(year, month, today):
    rows = []
    for week in calendar.Calendar(firstweekday=0).monthdatescalendar(year, month):
        days = []
        for day in week:
            classes = []
            if day.month != month:
                classes.append('other')
            if day.weekday() >= 5:
                classes.append('weekend')
            if day == today:
                classes.append('today')
            days.append({'day': day.day, 'class': ' '.join(classes)})
        rows.append({'week': week[0].isocalendar().week, 'days': days})

    # A fixed 6-row grid keeps the popup height stable while paging.
    while len(rows) < 6:
        last = datetime.date(year, month, 1) + datetime.timedelta(days=7 * len(rows))
        start = last - datetime.timedelta(days=last.weekday())
        days = [
            {'day': (start + datetime.timedelta(days=i)).day, 'class': 'other weekend' if i >= 5 else 'other'}
            for i in range(7)
        ]
        rows.append({'week': start.isocalendar().week, 'days': days})
    return rows


def month_view(offset, today):
    year, month = shift_month(today, offset)
    return {
        'view': 'month',
        'offset': offset,
        'year_offset': year - today.year,
        'title': f'{calendar.month_name[month]} {year}',
        'current': offset == 0,
        'weekdays': WEEKDAYS,
        'weeks': weeks(year, month, today),
    }


def year_view(offset, today):
    year = today.year + offset
    months = []
    for month in range(1, 13):
        months.append({
            'title': calendar.month_name[month],
            'offset': (year - today.year) * 12 + month - today.month,
            'current': year == today.year and month == today.month,
            'weeks': weeks(year, month, today),
        })
    return {
        'view': 'year',
        'offset': offset,
        'title': str(year),
        'current': offset == 0,
        'weekdays': WEEKDAYS,
        'months': months,
    }


def main():
    view = sys.argv[1] if len(sys.argv) > 1 else 'month'
    offset = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    today = datetime.date.today()

    data = year_view(offset, today) if view == 'year' else month_view(offset, today)
    print(json.dumps(data, separators=(',', ':')))


if __name__ == '__main__':
    main()
