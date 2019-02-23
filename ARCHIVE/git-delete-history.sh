#!/bin/bash
set -o errexit
 
# Author: Greg Bacon
# Source: https://stackoverflow.com/a/2158271
# License: CC-BY-SA 3.0 (http://creativecommons.org/licenses/by-sa/3.0/)
# Description: permanently delete files/folders from your git repository/history
# Usage: cd to your repository's root and then run the script with a list of paths
# you want to delete, e.g., git-delete-history path1 path2
 
# remove all paths passed as arguments from the history of the repo
files=$@
git filter-branch --prune-empty -d /dev/shm/scratch --index-filter "git rm -rf --cached --ignore-unmatch $files" --tag-name-filter cat -- --all
 
# remove the temporary history git-filter-branch otherwise leaves behind for a long time
git update-ref -d refs/original/refs/heads/master
git reflog expire --expire=now --all
git gc --prune=now

