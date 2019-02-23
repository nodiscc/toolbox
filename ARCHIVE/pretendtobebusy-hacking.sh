#!/bin/bash
#Description: pretend to be busy on a console screen
#from http://www.howtogeek.com/howto/44997/how-to-use-bash-history-to-improve-your-command-line-productivity/
cat /dev/urandom | hexdump -C | grep --color=always "ca fe"
