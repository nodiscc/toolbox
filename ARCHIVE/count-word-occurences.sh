#!/bin/bash
#Description: Counts number of occurences of a word in a file
#Usage: count-word-occurences.sh "searchterm" file
# http://www.unix.com/unix-dummies-questions-answers/87375-how-count-occurences-specific-word-file-bash-shell.html

tr -s ' ' '\n' < $2 | grep -c "$1"
