#!/bin/bash

# Start Quodlibet if it isn't already running
quodlibet --run

# Give it a moment to initialize
sleep 1

# Filter on a random album and start playing
quodlibet --random=album
quodlibet --play
