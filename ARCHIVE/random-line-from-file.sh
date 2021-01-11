#!/bin/bash
#Description: Echo a random line from a file
#Usage: put it in /etc/update-motd.d/ !

quotes_file="/usr/local/share/glados.txt"
num_lines=$(wc -l "$quotes_file" | awk '{print $1}')
line_num=$(perl -e "print int rand($num_lines)")
sed ${line_num}"q;d" "$quotes_file"
