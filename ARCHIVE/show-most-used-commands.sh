#!/bin/bash
#Description: find the most-used commands from your bash history
history | awk '{print $2}' | sort | uniq -c | sort -rn | head -n 20
history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head