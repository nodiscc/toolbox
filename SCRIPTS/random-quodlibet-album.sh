#!/bin/bash
# Description: play a random album in quodlibet music player
# Start Quodlibet if it isn't already running
quodlibet --run
# Give it a moment to initialize
sleep 3
# Filter on a random album and start playing
quodlibet --random=album
quodlibet --play
