#!/bin/bash
#Description: play a random somafm radio station
#thanks to http://pastebin.com/iLFyyqLa

PID=./somafm.pid

if [[ -e $PID ]]; then
    kill -9 $(cat $PID)
    rm $PID
fi

BASE_URL=http://ice.somafm.com/

STATION=$(whiptail --clear --title "SomaFM" --menu \
    "Select a station" 0 0 0 \
    groovesalad "Groove Salad" \
    secretagent "Secret Agent" \
    spacestation "Space Station" \
    missioncontrol "Mission Control" \
    christmas "Christmas Lounge" \
    3>&1 1>&2 2>&3)

if [[ $STATION ]]; then
	echo "Playing $STATION..."
    curl -s $BASE_URL$STATION | mpg123 -q - 
    #echo $! > $PID
fi

