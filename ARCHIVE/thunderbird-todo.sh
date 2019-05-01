#!/bin/bash
#Description: output a list of thunderbird tasks not marked COMPLETED

# shellcheck disable=SC2016
for i in ~/.thunderbird/*/calendar-data/cache.sqlite; do
    sqlite3 "$i" 'SELECT `title` FROM `cal_todos` WHERE (`ical_status` NOT LIKE "%COMPLETED%" OR `ical_status` IS NULL) ORDER BY `priority` DESC LIMIT 0, 50000;'
done | sort --unique | cut -b 1-25