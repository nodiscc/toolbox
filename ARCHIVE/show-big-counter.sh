#!/bin/bash
#Description: Show /home/partition usage % as a big counter

command="df -m /home/ | tail -n1 | awk '{print $2 " " $3}' | xargs python -c 'import sys; print( float(sys.argv[2]) / float(sys.argv[1]) * 100 )' | cut -b 1-5"
while true; do
	clear
	df -m /home/ | \
		tail -n1 | \
		awk '{print $2 " " $3}' | \
		xargs python -c 'import sys; print( float(sys.argv[2]) / float(sys.argv[1]) * 100 )' | \
		cut -b 1-5 | \
		toilet -f mono9;
	sleep 10;
done
