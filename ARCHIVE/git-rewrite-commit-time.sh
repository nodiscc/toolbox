#!/bin/bash
#Description: rewrite git commit times
#Copyright (C) 2014 VonC https://stackoverflow.com/users/6309/vonc
#License: CC-BY-SA http://creativecommons.org/licenses/by-sa/3.0/


#Test directory creation: mkdir gitrew; cd gitrew; git init; for i in $(seq 1 30); do echo hah >> file.txt; git a .; git c -m "add stuff"; done

#TODO: check previous commit to the commit specified, get its time, increment 1 second an duse this time
#TODO: rewrite dates for

Usage="Usage: $(basename $0) COMMIT \"DATE\"
	 DATE (YYYY-mm-dd HH:MM:SS)"

if [ "$1" = "-h" ]
	then echo "$Usage"
	exit 1
fi

# commit
# date YYYY-mm-dd HH:MM:SS

commit="$1" datecal="$2"
temp_branch="temp-rebasing-branch"
current_branch="$(git rev-parse --abbrev-ref HEAD)"

date_timestamp=$(date -d "$datecal" +%s)
date_r=$(date -R -d "$datecal")

if [[ -z "$commit" ]]; then
    exit 0
fi

git checkout -b "$temp_branch" "$commit"
GIT_COMMITTER_DATE="$date_timestamp" GIT_AUTHOR_DATE="$date_timestamp" git commit --amend --no-edit --date "$date_r"
git checkout "$current_branch"
git rebase --committer-date-is-author-date "$commit" --onto "$temp_branch"
git branch -d "$temp_branch"