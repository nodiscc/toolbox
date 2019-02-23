#!/bin/bash
# Description: replace first word with 2nd word in specified file
sed -i "s/$1/$2/g" "$3"

