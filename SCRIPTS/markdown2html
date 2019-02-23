#!/bin/sh
#Description: render a markdown document to HTML and view it in the default browser
#Dependencies: pandoc
#TODO: open a file selection dialog if no argument is passed
#TODO: load/embed a css stylesheet ( -c )
set -e


tmpfile=`mktemp`

if [ -f "$tmpfile" ]
	then rm "$tmpfile"
fi

pandoc -t html -o $tmpfile -s "$1"


x-www-browser $tmpfile
sleep 30
rm "$tmpfile"
