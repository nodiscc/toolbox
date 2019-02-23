#!/bin/bash
#Description: find the most used character in  a file
#source: http://www.reddit.com/r/linux/comments/1ct7ny/wc_for_character_that_is_used_the_most/c9jqz5m
cat $@ | fold -w1 | sort | uniq -c|sort -n
