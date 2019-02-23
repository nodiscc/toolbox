#!/bin/bash
# Description: Generate some composite word
shuf -n 2 /usr/share/dict/words | tr -dc 'A-Za-z0-9';
echo
