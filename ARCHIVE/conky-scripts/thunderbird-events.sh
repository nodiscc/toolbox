#!/bin/bash
# Description: list events in thunderbird calendar, sorted by date
# License:

# only display last X events
limit=10

function get_tb_events() {
  sqlite3 ~/.thunderbird/*/calendar-data/cache.sqlite \
  'SELECT "title","event_start" FROM "cal_events" ORDER BY "priority" DESC LIMIT 0, 50000;' | \
  awk -F'|' '
    {
      cmd = "date --rfc-3339=date -d @" substr($2, 0, 10);
      cmd | getline out;
      print out, $1;
      close(cmd);
  }'
}

get_tb_events | sort | tail -n $limit
