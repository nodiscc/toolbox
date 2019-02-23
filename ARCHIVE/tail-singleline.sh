#!/bin/bash -eu
# Description: In-place tail: prints the last output line of a command, overriding it in-place
# SOurce: https://gist.github.com/sinelaw/12b7957950c5103e7b46
LOG_FILE=$1
SB="stdbuf -i0 -oL"
shift
tput sc
$@ 2>&1 | $SB tee $LOG_FILE | $SB cut -c-$(tput cols) | $SB sed -u 's/\(.\)/\\\1/g' | $SB xargs -0 -d'\n' -iyosi  -n1  bash -c 'tput rc;tput el; printf "\r%s" yosi'
EXIT_CODE=${PIPESTATUS[0]}
tput rc;tput el;printf "\r" # Delete the last printed line
exit $EXIT_CODE

