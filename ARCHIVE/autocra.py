#!/usr/bin/env python3
# Description: display events in a .ics file with durations where a duratino of 1 is equivalent to 8-hour work day
# usage: Download an ICS calendar (https://OW_ADDRESS/owa/#path=/options/calendarpublishing) as calendar.ics in the current directory, python3 autocra.py

from icalendar import Calendar, Event
from datetime import datetime
from pytz import UTC # timezone

g = open('calendar.ics','rb')
gcal = Calendar.from_ical(g.read())
dtstart_day_prev = ''
for component in gcal.walk():
    try:
        dtstart = component.get('dtstart').dt.strftime('%H:%M')
        dtstart_day = component.get('dtstart').dt.strftime('%a %Y/%m/%d')
        dtend = component.get('dtend').dt.strftime('%H:%M')
        duration_td = component.get('dtend').dt - component.get('dtstart').dt
        duration = duration_td.total_seconds() / 3600 / 8
    except:
        dtstart = "UNK"
        dtstart_day = "UNK"
        dtend = "UNK"
        duration = "UNK"
    if dtstart_day == dtstart_day_prev:
        print('{}-{} | {} | {}'.format(dtstart, dtend, duration, component.get('summary')))
    else:
        print('')
        print('{} -------------'.format(dtstart_day))
        print('{}-{} | {} | {}'.format(dtstart, dtend, duration, component.get('summary')))
    dtstart_day_prev = dtstart_day
g.close()
