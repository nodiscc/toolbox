#!/bin/bash
# Description: countdown in days/hours/minutes/seconds to a date
end=$(date -d '2020-08-31 00:00:05 UTC+0100' +%s)
start=$(date +%s)
seconds_remaining=$((end-start))
echo $seconds_remaining

countdown(){
    date1=$((`date +%s` + $1));
    while [ "$date1" -ge `date +%s` ]; do 
    ## Is this more than 24h away?
    days=$(($(($(( $date1 - $(date +%s))) * 1 ))/86400))
    echo -ne "$days day(s) and $(date -u --date @$(($date1 - `date +%s`)) +%H:%M:%S)\r"; 
    sleep 0.1
    done
}
stopwatch(){
    date1=`date +%s`; 
    while true; do 
    days=$(( $(($(date +%s) - date1)) / 86400 ))
    echo -ne "$days day(s) and $(date -u --date @$((`date +%s` - $date1)) +%H:%M:%S)\r";
    sleep 0.1
    done
}
countdown $seconds_remaining
