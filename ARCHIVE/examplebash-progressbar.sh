#!/bin/bash
#Description: Example progress bar in bash
 
function loading {
    char="|"
    while :; do
        case "$char" in
            "|")
                char="/"
                ;;
            "/")
                char="-"
                ;;
            "-")
                char="\\"
                ;;
            "\\")
                char="|"
                ;;
        esac
        sleep .2s
        echo -en "\rLoading $char"
    done
}
 
loading &
pid=$!
 
# do something
sleep 5s
 
kill -9 $pid
wait $pid 2>/dev/null # Supress "Killed" message
echo -en "\r\033[K" # Completely overwrite last line
 
echo "Done."