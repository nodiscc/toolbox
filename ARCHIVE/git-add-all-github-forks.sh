#!/bin/bash
#Description: add all forks for a github project as git remotes
#Requires: curl, jq

usage="$0 owner repo"
owner="$1"
repo="$2"

if [ "$1" = "" -o "$2" = "" ]
    then echo "$USAGE"
fi

data=$(curl https://api.github.com/repos/$owner/$repo/forks)
forks=$(echo "$data" |jq '.[] | {clone_url: .clone_url}' | \
        egrep -oh "[A-Za-z]*/$repo\.git[^/]")

echo "Forks found:"
echo "$forks"

users=$(echo "$forks" | cut -d"/" -f 1)
echo "$users"

for user in $users;
    do
    true
    git remote add "$user" "https://github.com/$user/$repo.git"
done

git remote update