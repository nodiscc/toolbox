#!/bin/bash
# Description: remove files permanently from a git repository history.
# Execute this script in the git root directory
# For a size report: ./gitsize.sh df
# To remove the big files:
# use like: ./gitsize.sh rm $bigfilename
# Example: ./gitsize.sh rm includes/ubuntu-12.04.iso
# It will then search your git repo and remove all of it.

# Copyright (C) 2012 Remy van Elst

#     This program is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.

#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.

#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see .

if [ ! -e $1 ]; then
    if [ -d .git ]; then
        if [ $1 == "rm" ]; then
            if [ ! -e $2 ]; then
                echo "Removing Biggest file $2 from git repo"
                DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &&&& pwd )"
                rm -rf .git/refs/original/
                git filter-branch --index-filter "git rm --cached --ignore-unmatch $2" --tag-name-filter cat -- --all
                rm -rf .git/refs/original/
                git reflog expire --all --expire-unreachable=0
                git repack -A -d
                git prune
                git gc --aggressive
            else 
                echo "I need a file to remove..."
            fi
        elif [ $1 == "df" ]; then
            IFS=$'n';
            echo "All sizes are in kB's. The pack column is the size of the object, compressed, inside the pack file."
            objects=`git verify-pack -v .git/objects/pack/pack-*.idx | grep -v chain | grep -v pack | sort -k3nr | head -n 10`
            output="size,pack,SHA,location"
            for y in $objects
            do
                # extract the size in bytes
                size=$((`echo $y | cut -f 5 -d ' '`))
                # extract the compressed size in bytes
                compressedSize=$((`echo $y | cut -f 6 -d ' '`))
                # extract the SHA
                sha=`echo $y | cut -f 1 -d ' '`
                # find the objects location in the repository tree
                other=`git rev-list --all --objects | grep $sha`
                #lineBreak=`echo -e "n"`
                output="${output}n${size},${compressedSize},${other}"
            done

            echo -e $output | column -t -s ', '
        fi
    else
        echo "Cannot find .git directory, exitting. This script should be ran from a git working dir."
        exit 1
    fi
else
    echo "Usage:"
    echo "    For a size report:"
    echo "    $0 df"
    echo "    "
    echo "    To remove a big file from git history:"
    echo "    $0 rm "
    echo "    Example, to remove the file "includes\ubuntu-12.04.iso":"
    echo "    $0 rm includes\ubuntu-12.04.iso"
    echo "    Made by Raymii.org. GPLv3 License"

fi