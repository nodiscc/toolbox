#!/bin/bash
#Description: Does not work
set -e

remotename=origin
currentbranch=$(git rev-parse --abbrev-ref HEAD)
commits_since_push=$(git log $remotename/$currentbranch..$currentbranch  | egrep "[0-9a-f]{40}")
number_of_commits=$(echo "$commits_since_push" | wc -l)
done_changing="0"
time_increment="1"
remote_time=$(git show --date=iso --format="%ad" origin/master | head -n1 | awk -F" " '{print $1 " " $2}') #Get commit time of origin/master

echo "remote was updated at $remote_time"
echo "Changing time for $number_of_commits commits..."

for i in $(seq 1 "$number_of_commits")
do
	#Get last commit
	target=$(echo "$commits_since_push" | tail -n $i | head -n1 | awk -F" " '{print $2}')
	echo "target commit: $target"

	#Craft new commit date (add 1 second to previous commit)
	new_date=$(date "+%Y-%m-%d %H:%M:%S" -d "$remote_time $time_increment seconds")
	echo "new date is $new_date"

	#Change commit date
	/home/bsp/Téléchargements/git-rewrite-commit-time "$target" \"$new_date\" > /dev/null

	#Add 1 second to time for next commit
	time_increment=$(($time_increment+1))
done