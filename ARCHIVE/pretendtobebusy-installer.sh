#!/bin/bash
#Description: Prentend to be busy installing stuff/watching progress bars
j=0
while true
	do
	let j=$j+1
	for i in $(seq 0 20 100)
		do
		echo $i
		sleep 1
		done \
	| dialog --gauge "Install part $j : `sed $(perl -e "print int rand(99999)")"q;d" /usr/share/dict/words`" 6 40
done
